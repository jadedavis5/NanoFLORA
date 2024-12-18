#!/usr/bin/env python3

import re
import argparse
import csv

class GFFCompareParser:
    def __init__(self, input_file_path, output_file_path):
        self.input_file_path = input_file_path
        self.output_file_path = output_file_path
        self.results = {}

    def parse(self):
        with open(self.input_file_path, 'r') as file:
            content = file.read()

        # Extract and store the values for Sensitivity (column 0) and Precision (column 1)
        self.results["Base level_Sensitivity"] = self._extract_value(content, "Base level", 0)
        self.results["Base level_Precision"] = self._extract_value(content, "Base level", 1)

        self.results["Exon level_Sensitivity"] = self._extract_value(content, "Exon level", 0)
        self.results["Exon level_Precision"] = self._extract_value(content, "Exon level", 1)

        self.results["Intron level_Sensitivity"] = self._extract_value(content, "Intron level", 0)
        self.results["Intron level_Precision"] = self._extract_value(content, "Intron level", 1)

        self.results["Intron chain level_Sensitivity"] = self._extract_value(content, "Intron chain level", 0)
        self.results["Intron chain level_Precision"] = self._extract_value(content, "Intron chain level", 1)

        self.results["Transcript level_Sensitivity"] = self._extract_value(content, "Transcript level", 0)
        self.results["Transcript level_Precision"] = self._extract_value(content, "Transcript level", 1)

        self.results["Locus level_Sensitivity"] = self._extract_value(content, "Locus level", 0)
        self.results["Locus level_Precision"] = self._extract_value(content, "Locus level", 1)

    def _extract_value(self, content, level, column):
        # Match lines with the specified level and extract values by column index (0 for Sensitivity, 1 for Precision)
        adjusted_pattern = rf"{level}:\s+([\d.]+)\s+\|\s+([\d.]+)"
        print(f"Debug: Adjusted Pattern = {adjusted_pattern}")
        match = re.search(adjusted_pattern, content)
        if match:
            return match.group(column + 1)  # column=0 for Sensitivity, column=1 for Precision
        else:
            return "Not Found"

    def save_results(self):
        with open(self.output_file_path, 'w', newline='') as csvfile:
            csv_writer = csv.writer(csvfile)
            csv_writer.writerow(["Metric", "Value"])  # CSV header

            for key, value in self.results.items():
                metric = key.replace(':', '')  # Remove trailing colon
                value = value.replace(".0", "") if value != "Not Found" else value  # Remove .0 from numeric values
                csv_writer.writerow([metric, value])

def main():
    parser = argparse.ArgumentParser(description="Parse GFFCompare output to extract sensitivity and precision metrics and save to CSV.")
    parser.add_argument('input_file', type=str, help='Path to the GFFCompare output file.')
    parser.add_argument('output_file', type=str, help='Path to the CSV file to save the results.')
    args = parser.parse_args()

    # Create a parser instance and process the file
    gffcompare_parser = GFFCompareParser(args.input_file, args.output_file)
    gffcompare_parser.parse()
    gffcompare_parser.save_results()
    print(f"Results have been saved to {args.output_file}")

if __name__ == "__main__":
    main()
