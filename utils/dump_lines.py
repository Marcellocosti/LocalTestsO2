import sys
import os

def dump_lines(input_file, start_line, end_line):
    """Dump lines from start_line to end_line into a new text file."""
    if start_line < 1 or end_line < start_line:
        raise ValueError("Invalid line range")

    base_name, ext = os.path.splitext(os.path.basename(input_file))
    output_file = f"{base_name}_{start_line}_{end_line}.txt"

    with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
        for current_line_number, line in enumerate(infile, start=1):
            if start_line <= current_line_number <= end_line:
                outfile.write(line)
            elif current_line_number > end_line:
                break

    print(f"Lines {start_line} to {end_line} dumped to {output_file}")


if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python dump_lines.py <file_path> <start_line> <end_line>")
        sys.exit(1)

    file_path = sys.argv[1]
    start_line = int(sys.argv[2])
    end_line = int(sys.argv[3])

    dump_lines(file_path, start_line, end_line)
