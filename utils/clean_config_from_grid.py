import json
import argparse
import os

# Set up argument parsing
parser = argparse.ArgumentParser(description="Extract and merge configuration fields from JSON.")
parser.add_argument("input_directory", help="Path to the input directory")
args = parser.parse_args()

# Read input JSON
with open(args.input_directory, "r") as infile:
    data = json.load(infile)

# Extract all dictionaries from the "configuration" fields
task_cfg = {}
for workflow in data.get("workflows", []):
    configuration = workflow.get("configuration", {})
    task_cfg.update(configuration)

# Prepare output filename in the same directory as input
input_dir = os.path.dirname(args.input_directory)
base_name = os.path.splitext(os.path.basename(args.input_directory))[0]
output_file = os.path.join(input_dir, f"{base_name}_cleaned.json")

# Write merged configuration back to output file
with open(output_file, "w") as outfile:
    json.dump(task_cfg, outfile, indent=4)

print(f"Processed configuration saved to {output_file}")