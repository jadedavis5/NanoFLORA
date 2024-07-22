#!/usr/bin/env python3

import re
import argparse
import pandas as pd

class AgatSpStatistics:
    def __init__(self, file_path):
        self.file_path = file_path
        self.data = []
        self.switch_to_longest_isoform = False

    def parse(self):
        with open(self.file_path, 'r') as file:
            first_part = True
            number_of_gene_count = 0
            for line in file:
                line = line.strip()
                if line and not line.startswith('---'):  # Skip lines starting with '---'
                    if "Number of gene" in line:
                        number_of_gene_count += 1
                        if number_of_gene_count > 1:
                            self.switch_to_longest_isoform = True
                            first_part = False
                    
                    if not self.switch_to_longest_isoform and "Shortest intron into three_prime_utr part (bp)" in line:
                        first_part = False

                    try:
                        key, value, category = self._parse_line(line, first_part)
                        self.data.append((key, value, category))
                    except ValueError as e:
                        print(f"Skipping line due to error: {e}")

    def _parse_line(self, line, first_part):
        match = re.match(r"(.*?)([\d]+(\.\d+)?)([a-zA-Z]*)$", line)
        if match:
            key = match.group(1).strip()
            value = match.group(2) + match.group(4)
            category = "Isoforms" if not self.switch_to_longest_isoform else "Longest isoform"
            return key, value, category
        else:
            raise ValueError(f"Line format is incorrect: {line}")

    def to_dataframe(self):
        df = pd.DataFrame(self.data, columns=['Feature', 'Value', 'Group'])
        return df

def main():
    parser = argparse.ArgumentParser(description="Parse statistics files.")
    parser.add_argument('--module', type=str, required=True, choices=['agat_sp_statistics'], help="Module to execute")
    parser.add_argument('--input', type=str, required=True, help="Path to the input statistics file")
    parser.add_argument('--output', type=str, required=True, help="Path to the output CSV file")
    args = parser.parse_args()

    if args.module == 'agat_sp_statistics':
        agat_parser = AgatSpStatistics(args.input)
        agat_parser.parse()
        df = agat_parser.to_dataframe()
        with open(args.output, 'w') as f:
            f.write("#Feature,Value,Group\n")
            df.to_csv(f, index=False, header=False)
        print(f"Data has been written to {args.output}")

if __name__ == "__main__":
    main()
