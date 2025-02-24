import json
import argparse
import os

# Set up argument parsing
parser = argparse.ArgumentParser(description="Extract and merge configuration fields from JSON.")
parser.add_argument("input_directory", help="Path to the input directory")
parser.add_argument("output_directory", help="Path to the output directory")
args = parser.parse_args()

# Read input JSON
with open(args.input_directory, "r") as infile:
    data = json.load(infile)

# Extract all dictionaries from the "configuration" fields
task_cfg = {}
for workflow in data.get("workflows", []):
    configuration = workflow.get("configuration", {})
    task_cfg.update(configuration)

# Write merged configuration back to output file
with open(args.output_directory, "w") as outfile:
    json.dump(task_cfg, outfile, indent=4)

print(f"Processed configuration saved to {args.output_directory}")
