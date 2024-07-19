#!/usr/bin/env python3

import argparse
import pandas as pd

class AgatSpStatisticsParser:
    def __init__(self, data):
        self.data = data
    
    def parse_transcript_data(self):
        # Split the data into sections
        sections = self.data.strip().split("\n\n")
        
        # Identify the indexes of each section
        isoforms_start = sections[0]
        longest_isoform_start = sections[1]
        
        # Parse each section into a dictionary
        isoforms = self.parse_section(isoforms_start)
        longest_isoform = self.parse_section(longest_isoform_start)
        
        # Combine both dictionaries into a single DataFrame
        df = pd.DataFrame([isoforms, longest_isoform], index=['Isoforms', 'Longest Isoform'])
        
        return df

    def parse_section(self, section):
        lines = section.strip().split('\n')
        data = {}
        for line in lines:
            if ':' in line:
                key, value = line.split(':', 1)
                data[key.strip()] = value.strip()
        return data

def main():

    modules = {
        "agat_sp_statistics": "Parse transcript data including isoforms and longest isoform statistics."
    }

    parser = argparse.ArgumentParser(description='Parse transcript data.')
    parser.add_argument('--module', type=str, required=True, help='Specify the module for output parsing. Available modules: ' + ', '.join(modules.keys()))
    parser.add_argument('file', type=str, help='Path to the input file containing transcript data')

    args = parser.parse_args()

    # Read the input file
    with open(args.file, 'r') as file:
        data = file.read()

    if args.module in modules:
        if args.module == "agat_sp_statistics":
            parser = AgatSpStatisticsParser(data)
            df = parser.parse_transcript_data()
            print(df.to_string())
    else:
        print(f"Module '{args.module}' is not recognized. Available modules are: {', '.join(modules.keys())}.")

if __name__ == "__main__":
    main()
