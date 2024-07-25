#!/usr/bin/env python3

import pandas as pd
import argparse

class CodingPotentialAnalyzer:
    def __init__(self, input_file):
        self.input_file = input_file

    def load_data(self):
        self.df = pd.read_csv(self.input_file, sep='\t')

    def calculate_percentages(self):
        total_sequences = len(self.df)
        coding_count = len(self.df[self.df['classification'] == 'coding'])
        noncoding_count = len(self.df[self.df['classification'] == 'noncoding'])

        self.coding_percentage = round((coding_count / total_sequences) * 100, 2)
        self.noncoding_percentage = round((noncoding_count / total_sequences) * 100, 2)

    def get_percentages(self):
        return self.coding_percentage, self.noncoding_percentage

    def save_results(self, output_file):
        results = {
            'type': ['coding_perc', 'noncoding_perc'],
            'percentage': [self.coding_percentage, self.noncoding_percentage]
        }
        result_df = pd.DataFrame(results)
        result_df.to_csv(output_file, index=False)

def main():
    parser = argparse.ArgumentParser(description="Calculate coding and noncoding percentages from a TSV file.")
    parser.add_argument('--input', type=str, required=True, help="Input TSV file with coding potential data.")
    parser.add_argument('--output', type=str, required=True, help="Output CSV file to save the results.")
    args = parser.parse_args()

    analyzer = CodingPotentialAnalyzer(args.input)
    analyzer.load_data()
    analyzer.calculate_percentages()
    analyzer.save_results(args.output)

if __name__ == "__main__":
    main()
