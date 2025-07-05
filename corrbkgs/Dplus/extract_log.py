# Read first 10,000 lines from 'input.txt' and write to 'output.txt'
input_file = '/home/mdicosta/LocalTestsO2/corrbkgs/Dplus/log.txt'
output_file = '/home/mdicosta/LocalTestsO2/corrbkgs/Dplus/log_0_40000.txt'


with open(input_file, 'r', encoding='utf-8') as infile, open(output_file, 'w', encoding='utf-8') as outfile:
    # total_lines = sum(1 for _ in infile)
    # print(f"Total number of lines: {total_lines}")
    infile.seek(0)  # Go back to the start of the file

    for i, line in enumerate(infile):
        if 0 <= i < 40000:
            # if 'Filling tree generated' in line:
            #     print(f"Line {i}: {line.strip()}")
            #     outfile.write(line)
            outfile.write(line)
        elif i >= 40000:
            break
