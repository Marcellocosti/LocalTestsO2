import json
import sys

def unify_json_files(file_paths):
    """
    Unifies multiple JSON files and writes the result to an output file.

    :param file_paths: List of paths to JSON files
    :param output_path: Path to save the unified JSON file
    """
    try:
        unified_data = None

        for file_path in file_paths:
            with open(file_path, 'r') as file:
                data = json.load(file)

                if unified_data is None:
                    unified_data = data
                elif isinstance(unified_data, dict) and isinstance(data, dict):
                    unified_data.update(data)
                elif isinstance(unified_data, list) and isinstance(data, list):
                    unified_data += data
                else:
                    raise ValueError("All JSON files must be either lists or dictionaries.")

        # Save the unified JSON object
        with open("./cfg.json", 'w') as output_file:
            json.dump(unified_data, output_file, indent=4)

        print(f"Unified JSON has been saved to ./cfg.json")

    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python script.py <file1> <file2> [<file3> ...]")
    else:
        file_paths = sys.argv[1:]

        unify_json_files(file_paths)
