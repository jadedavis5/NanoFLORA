#!/usr/bin/env python3

#!/usr/bin/env python3

import argparse
import pandas as pd
from Bio import SeqIO
import gffutils
import os

# Define the canonical splice sites
CANONICAL_SPLICE_SITES = [("GT", "AG"), ("GC", "AG"), ("AT", "AC")]

def is_canonical_splice_site(donor, acceptor):
    return (donor, acceptor) in CANONICAL_SPLICE_SITES

def analyze_transcript_features(fasta_file, gff_file):
    # Read the genome sequence
    genome = SeqIO.to_dict(SeqIO.parse(fasta_file, "fasta"))

    # Create a gffutils database
    db = gffutils.create_db(gff_file, dbfn=':memory:', force=True, keep_order=True, merge_strategy='merge', sort_attribute_values=True)

    data = []

    for transcript in db.features_of_type('transcript'):
        transcript_id = transcript.id
        exons = list(db.children(transcript, featuretype='exon', order_by='start'))
        introns = []

        if len(exons) > 1:
            for i in range(len(exons) - 1):
                intron_start = exons[i].end
                intron_end = exons[i + 1].start - 1
                intron_seq = genome[transcript.chrom].seq[intron_start:intron_end]

                if transcript.strand == '+':  # Positive strand
                    donor = intron_seq[:2].upper()
                    acceptor = intron_seq[-2:].upper()
                else:  # Negative strand
                    donor = intron_seq[-2:].reverse_complement().upper()
                    acceptor = intron_seq[:2].reverse_complement().upper()

                introns.append((donor, acceptor))

        type_ = "monoexonic" if len(exons) == 1 else "polyexonic"
        if type_ == "monoexonic":
            type_splicing = "NA"
        else:
            type_splicing = "canonical" if all(is_canonical_splice_site(d, a) for d, a in introns) else "non-canonical"

        data.append({
            "file": os.path.basename(gff_file),
            "transcript_id": transcript_id,
            "type": type_,
            "type_splicing": type_splicing
        })

    return pd.DataFrame(data)

def summarize_transcripts(df):
    summary_data = []

    for file_name, group in df.groupby("file"):
        total = len(group)
        monoexonic_count = len(group[group['type'] == 'monoexonic'])
        polyexonic_count = len(group[group['type'] == 'polyexonic'])
        canonical_count = len(group[(group['type_splicing'] == 'canonical') & (group['type'] == 'polyexonic')])
        non_canonical_count = len(group[(group['type_splicing'] == 'non-canonical') & (group['type'] == 'polyexonic')])

        summary_data.append({
            "file": file_name,
            "total_transcripts": total,
            "monoexonic": round(monoexonic_count / total * 100, 2),
            "polyexonic_canonical": round(canonical_count / polyexonic_count * 100, 2),
            "polyexonic_non_canonical": round(non_canonical_count / polyexonic_count * 100, 2),
        })

    return pd.DataFrame(summary_data)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Analyze transcript features from FASTA and GFF files.")
    parser.add_argument("-g", "--genome", required=True, help="Path to the genome FASTA file.")
    parser.add_argument("-t", "--gff_files", required=True, nargs='+', help="Paths to the GFF files.")
    parser.add_argument("-o", "--output_prefix", default="output_", help="Output prefix for the result files. Default is 'output_'.")

    args = parser.parse_args()

    fasta_file = args.genome
    gff_files = args.gff_files
    output_prefix = args.output_prefix

    all_transcript_features = []

    for gff_file in gff_files:
        transcript_features = analyze_transcript_features(fasta_file, gff_file)
        all_transcript_features.append(transcript_features)

    combined_df = pd.concat(all_transcript_features, ignore_index=True)
    combined_df.to_csv(f"{output_prefix}transcript_features.csv", index=False)

    summary_df = summarize_transcripts(combined_df)
    
    summary_output = []
    for _, row in summary_df.iterrows():
        summary_output.append(f"transcripts_analyzed,{row['total_transcripts']}")
        summary_output.append(f"monoexonic,{row['monoexonic']}")
        summary_output.append(f"polyexonic_canonical,{row['polyexonic_canonical']}")
        summary_output.append(f"polyexonic_noncanonical,{row['polyexonic_non_canonical']}")

    with open(f"{output_prefix}transcript_summary.csv", 'w') as f:
        f.write("type,percentage\n")
        f.write("\n".join(summary_output))
    
    print(f"Transcript features and summary saved to '{output_prefix}transcript_features.csv' and '{output_prefix}transcript_summary.csv'.")
