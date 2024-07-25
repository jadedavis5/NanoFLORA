#!/usr/bin/env python3

#!/usr/bin/env python3

import pandas as pd
import argparse

def extract_features(file_path):
    df = pd.read_csv(file_path)
    if 'Feature' not in df.columns:
        print(f"Columns in {file_path}: {df.columns}")
        raise KeyError(f"'Feature' column not found in {file_path}")

    features = [
        'mean transcripts per gene',
        'Number of gene',
        'Number of transcript',
        'mean introns in cdss per transcript',
        'mean introns in exons per transcript',
        'mean gene length (bp)',
        'mean transcript length (bp)',
        'Number of mrnas with utr both sides',
        'Number of mrnas with at least one utr'
    ]

    extracted_data = df[df['Feature'].isin(features)][['Feature', 'Value']]
    extracted_data = extracted_data.rename(columns={'Feature': 'type', 'Value': 'value'})
    print(f"Extracted data from {file_path}:\n", extracted_data)
    return extracted_data

def read_additional_file(file_path, source_name):
    df = pd.read_csv(file_path)
    df = df.rename(columns={df.columns[0]: 'type', df.columns[1]: 'value'})
    df['source'] = source_name
    print(f"Additional data from {file_path}:\n", df)
    return df

def main(input_summary, input_coding_potential, input_type_ss, output_path, input_gffcompare=None):
    # Extract specific features from file 1
    extracted_data = extract_features(input_summary)
    extracted_data['source'] = 'summary_stats'

    # Read additional data from file 2 and file 3
    additional_data_1 = read_additional_file(input_coding_potential, 'coding_potential')
    additional_data_2 = read_additional_file(input_type_ss, 'type_ss')

    # Process GFFCompare data if provided
    if input_gffcompare:
        additional_data_3 = read_additional_file(input_gffcompare, 'ref_gffcompare')
        # Concatenate all data
        final_data = pd.concat([extracted_data, additional_data_1, additional_data_2, additional_data_3], ignore_index=True)
    else:
        # Concatenate data without GFFCompare data
        final_data = pd.concat([extracted_data, additional_data_1, additional_data_2], ignore_index=True)

    # Process value column to remove .0 and fill na
    final_data['value'] = final_data['value'].fillna('').astype(str).str.replace(".0", "", regex=False)

    # Save the concatenated data to a CSV file
    final_data.to_csv(output_path, index=False)
    print(f"Final concatenated data:\n", final_data)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Concatenate the summary stats into a single CSV file.")
    parser.add_argument('--input_summary', type=str, required=True, help='Path to the input summary file from AGAT')
    parser.add_argument('--input_coding_potential', type=str, required=True, help='Path to the input coding potential file')
    parser.add_argument('--input_type_ss', type=str, required=True, help='Path to the input splice sites file')
    parser.add_argument('--output', type=str, required=True, help='Path to the output file')
    parser.add_argument('--input_gffcompare', type=str, help='Path to the optional GFFCompare output file')

    args = parser.parse_args()

    main(args.input_summary, args.input_coding_potential, args.input_type_ss, args.output, args.input_gffcompare)
