import json
import sys
from deepdiff import DeepDiff

def preprocess(data):
    if isinstance(data, dict):
        return {k: preprocess(v) for k, v in data.items()}
    elif isinstance(data, list):
        return [preprocess(v) for v in data]
    elif isinstance(data, bool):
        return int(data)  # Convert True -> 1, False -> 0
    elif isinstance(data, str):
        if data.lower() == "true":
            return 1  # Treat "true" as 1
        elif data.lower() == "false":
            return 0  # Treat "false" as 0
        # Convert numeric strings to their respective numeric types
        try:
            # Try converting to float to cover both integers and floats
            if float(data).is_integer():
                return int(data)  # Convert float .0 to int (e.g., 1.0 -> 1)
            else:
                return float(data)
        except ValueError:
            return data  # If not a numeric string, return the original string

    elif isinstance(data, float):
        # Convert floats like 1.0 to 1 and 0.0 to 0
        if data.is_integer():
            return int(data)  # Convert float .0 to int (e.g., 1.0 -> 1)

    return data

def compare_json(file1_path, file2_path, diff_output_path):
    """
    Compares two JSON files, normalizes the data, and saves the differences to an output file.

    :param file1_path: Path to the first JSON file
    :param file2_path: Path to the second JSON file
    :param diff_output_path: Path to save the differences
    """
    try:
        # Load JSON files
        with open(file1_path, 'r') as f1, open(file2_path, 'r') as f2:
            json1 = json.load(f1)
            json2 = json.load(f2)

        # Preprocess both JSON objects
        normalized_json1 = preprocess(json1)
        normalized_json2 = preprocess(json2)

        # Get differences
        diff = DeepDiff(normalized_json1, normalized_json2, ignore_order=True)

        # Save differences to a file
        with open(diff_output_path, 'w') as output_file:
            output_file.write(diff.to_json(indent=4))

        print(f"Differences saved to {diff_output_path}")

    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python script.py <file1_path> <file2_path> <diff_output_path>")
    else:
        file1_path = sys.argv[1]
        file2_path = sys.argv[2]
        diff_output_path = sys.argv[3]

        # Compare JSON files and save differences
        compare_json(file1_path, file2_path, diff_output_path)
