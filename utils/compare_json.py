import json
import argparse

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

def transform_to_nested(data):
    """
    Converts a flat dictionary with dot-separated keys into a nested dictionary.
    Preprocesses the values during the transformation.
    """
    transformed_data = {}
    data_removed = data.copy()
    for key, value in data.items():
        if isinstance(value, dict) and value.get("values") is None:
            new_dict = transform_to_nested(value)
            data_removed[key] = new_dict
        else:
            if "." in key:
                keys = key.split('.')
                del data_removed[key]
                if transformed_data.get(keys[0]) is None:
                    transformed_data[keys[0]] = {}
                transformed_data[keys[0]][keys[1]] = value

    for key, value in transformed_data.items():
        data_removed[key] = value
    
    return data_removed

def missing_keys(dict1, dict2, nick1, nick2, mother_key = ""):
    
    missing_keys = []
    keys_only_in_dict1 = [f" {key1}" for key1 in dict1.keys() if key1 not in dict2.keys()]
    if keys_only_in_dict1:
        if mother_key != "":
            missing_keys.append(f"[{mother_key}] Keys present in {nick1} but not in {nick2}:" + ",".join(keys_only_in_dict1))
        else:
            missing_keys.append(f"Keys present in {nick1} but not in {nick2}:" + ",".join(keys_only_in_dict1))

    keys_only_in_dict2 = [f" {key2}" for key2 in dict2.keys() if key2 not in dict1.keys()]
    if keys_only_in_dict2:
        if mother_key != "":
            missing_keys.append(f"[{mother_key}] Keys present in {nick2} but not in {nick1}:" + ",".join(keys_only_in_dict2))
        else:
            missing_keys.append(f"Keys present in {nick2} but not in {nick1}:" + ",".join(keys_only_in_dict2))

    return missing_keys

def diff_non_negl(a, b):
    if isinstance(a, (int, float)) and  not isinstance(a, bool) and isinstance(b, (int, float)) and not isinstance(b, bool):
        if abs(a-b) < 0.0001:
            return False
        else: 
            return True
    else:
        return True

def compare_subdicts(dict1, dict2, nick1, nick2, mother_key, path=""):
    """
    Compares two dictionaries and finds the differences.
    Returns a list of differences, showing the keys and values that differ.
    """

    dict1 = preprocess(dict1)
    dict2 = preprocess(dict2)
    
    # To hold the differences
    differences = []
    if len(missing_keys(dict1, dict2, nick1, nick2, mother_key)) > 0:
        differences.append(missing_keys(dict1, dict2, nick1, nick2, mother_key))

    # Check for keys in dict1 but not in dict2
    for key1 in dict1.keys():
        single_key_difference = []
        if key1 in dict2.keys():
            # If the value is a dictionary, recursively compare
            if isinstance(dict1[key1], dict) and isinstance(dict2[key1], dict):
                single_key_difference.extend(compare_subdicts(dict1[key1], dict2[key1], nick1, nick2, key1, path + key1 + "."))
            elif dict1[key1] != dict2[key1] and diff_non_negl(dict1[key1], dict2[key1]):
                if mother_key != "":
                    single_key_difference.append(f"[{mother_key}, {key1}]: {nick1} = {dict1[key1]}, {nick2} = {dict2[key1]}")
                else:
                    single_key_difference.append(f"KEY {key1}: {nick1} = {dict1[key1]}, {nick2} = {dict2[key1]}")
        
        if len(single_key_difference) > 0:
            differences.append(single_key_difference)
        
    return differences

def compare_dicts(dict1, dict2, nick1, nick2, path=""):
    """
    Compares two dictionaries and finds the differences.
    Returns a list of differences, showing the keys and values that differ.
    """

    dict1 = preprocess(dict1)
    dict2 = preprocess(dict2)
    
    # To hold the differences
    differences = []
    if len(missing_keys(dict1, dict2, nick1, nick2)) > 0:
        differences.append(missing_keys(dict1, dict2,  nick1, nick2))

    for key1 in dict1.keys():
        single_key_difference = []
        if key1 in dict2.keys():
            single_key_difference.append(f"---------------------- {key1} -------------------------")
            if isinstance(dict1[key1], dict) and isinstance(dict2[key1], dict):
                single_key_difference.extend(compare_subdicts(dict1[key1], dict2[key1], nick1, nick2, "", path + key1 + "."))
            elif dict1[key1] != dict2[key1]:
                single_key_difference.append(f"KEY {key1}, {nick1} = {dict1[key1]}, {nick2} = {dict2[key1]}")

        if len(single_key_difference) > 0:
            differences.append(single_key_difference)

    return differences

def sort_list(s):
    # Define sorting priority for the prefixes
    if s.startswith("-------"):
        return (0, s)
    elif "bins" in s or "values" in s or "labels" in s:
        return (4, s)
    elif s.startswith("Keys"):
        return (1, s)
    elif s.startswith("KEY"):
        return (2, s)
    elif s.startswith("["):
        return (3, s)
    else:
        return (5, s)

def add_indentation(s, level):
    # Adds indentation based on the level
    return " " * (level * 4) + s

def order_diff(nested_list):
    ordered = []
    ordered.extend(nested_list[0])  # No sorting for the first block
    for item in nested_list[1:]:
        flattened_item = flatten(item)  # Flatten if it's a nested list
        sorted_items = sorted(flattened_item, key=sort_list)  # Sort using `sort_list`
        for line in sorted_items:
            # Add visible indentation
            indentation_level = sort_list(line)[0]  # Priority is used as indentation level
            ordered.append(add_indentation(line, indentation_level))
    
    return ordered

# Flatten function to handle nested lists
def flatten(nested):
    result = []
    for elem in nested:
        if isinstance(elem, list):
            result.extend(flatten(elem))
        else:
            result.append(elem)
    return result

def save_differences_to_file(differences, output_file):
    """
    Saves the list of differences to a text file.
    """
    
    with open(output_file, 'w') as f:
        ordered_diff = order_diff(differences)
        for idiff in range(len(ordered_diff)):
            if "[" in ordered_diff[idiff] and "[" not in ordered_diff[idiff-1]:
                f.write("\n")
            if "KEY" in ordered_diff[idiff] and "Keys" in ordered_diff[idiff-1]:
                f.write("\n")
            if "-----" in ordered_diff[idiff]:
                f.write("\n")
                f.write(ordered_diff[idiff] + "\n")
            else:
                f.write(ordered_diff[idiff] + "\n")

parser = argparse.ArgumentParser(description="Compare two JSON files and save differences.")
parser.add_argument('file1', type=str, help="Path to the first JSON file")
parser.add_argument('nickname1', type=str, help="Handy name for the first JSON file")
parser.add_argument('file2', type=str, help="Path to the second JSON file")
parser.add_argument('nickname2', type=str, help="Handy name for the second JSON file")
parser.add_argument('--output', type=str, default='differences.txt', help="Output file for differences")
parser.add_argument('--reordered_output', type=str, default='reordered_output.json', help="Output file for reordered JSON")

# Parse the command line arguments
args = parser.parse_args()
with open(args.file1, 'r') as file:
    dict1 = preprocess(transform_to_nested(json.load(file)))
with open(args.file2, 'r') as file:
    dict2 = preprocess(transform_to_nested(json.load(file)))

differences = compare_dicts(dict1, dict2, args.nickname1, args.nickname2)
save_differences_to_file(differences, args.output)
print(f"Differences saved to {args.output}")
