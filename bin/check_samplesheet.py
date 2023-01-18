#!/usr/bin/env python3

import os
import sys
import errno
import argparse

def parse_args(args=None):
    Description = "Check contents of input samplesheet CSV"
    Epilog = "Example usage: python check_samplesheet.py <FILE_IN> <FILE_OUT>"

    parser = argparse.ArgumentParser(description=Description, epilog=Epilog)
    parser.add_argument("FILE_IN", help="Input samplesheet CSV")
    parser.add_argument("FILE_OUT", help="Output file")
    return parser.parse_args(args)

def make_dir(path):
    if len(path) > 0:
        try:
            os.makedirs(path)
        except OSError as exception:
            if exception.errno != errno.EXIST:
                raise exception

def print_error(error, context="Line", context_str=""):
    error_str = f"ERROR: Please check samplesheet -> {error}"
    if context != "" and context_str != "":
        error_str = f"ERROR: Please check samplesheet -> {error}\n{context.strip()}: '{context_str.strip()}'"
    print(error_str)
    sys.exit(1)

def check_samplesheet(file_in, file_out):
    """
    This function checks that the samplesheet follows the correct format:
    sample,fastq
    """

    sample_info_dict = {}
    with open(file_in, "r", encoding="utf-8-sig") as fin:
        # first check header
        MIN_COLS = 2
        HEADER = ["sample", "fastq"]
        header = [x.strip('"') for x in fin.readline().strip().split(",")]
        if header[: len(HEADER)] != HEADER:
            print(f"ERROR: Please check the samplesheet header -> {','.join(header)} != {','.join(HEADER)}")
            sys.exit(1)

        # check sample entries
        for line in fin:
            if line.strip():
                lspl = [x.strip().strip('"') for x in line.strip().split(",")]

            # check valid number of columns per row
            if len(lspl) < len(HEADER):
                print_error(
                    f"Invalid number of columns (minimum = {len(HEADER)})!"
                    "Line",
                    line,
                )
            num_cols = len([x for x in lspl if x])
            if num_cols < MIN_COLS:
                print_error(
                    f"Invalid number of populated columns (minimum = {MIN_COLS})!"
                    "Line",
                    line,
                )
            # check sample name entires
            sample,fastq = lspl[: len(HEADER)]
            if sample.find(" ") != -1:
                print(f"WARNING: Spaces have been replaced by underscores for sample: {sample}")
                sample = sample.replace(" ", "_")
            if not sample:
                print_error("Sample entry has not been specified!", "Line", line)


            # check fastq file extensions
            for reads in [fastq]:
                if reads:
                    if reads.find(" ") != -1:
                        print_error("Fastq file contains spaces!", "Line", line)
                    if not reads.endswith(".fastq.gz") and not reads.endswith(".fq.gz"):
                        print_error(
                            "Fastq file does not have extension '.fastq.gz' or 'fq.gz'!",
                            "Line",
                            line,
                        )
            # populate sample data
            sample_info = [fastq]

            # Create sample info mapping dictionary
            if sample not in sample_info_dict:
                sample_info_dict[sample] = [sample_info]
            else:
                if sample_info in sample_info_dict[sample]:
                    print_error("Samplesheet contains duplicate rows!", "Line", line)
                else:
                    sample_info_dict[sample].append(sample_info)

    # Write validated samplesheet with the appropriate columns
    if len(sample_info_dict) > 0:
        out_dir = os.path.dirname(file_out)
        make_dir(out_dir)
        with open(file_out, "w") as fout:
            fout.write(",".join(["sample", "fastq"]) + "\n")
            for sample in sorted(sample_info_dict.keys()):
                for idx, val in enumerate(sample_info_dict[sample]):
                    fout.write(",".join([f"{sample}"] + val) + "\n")
    else:
        print_error(f"No entires to process!", "Samplesheet: {file_in}")

def main(args=None):
    args = parse_args(args)
    check_samplesheet(args.FILE_IN, args.FILE_OUT)

if __name__ == "__main__":
    sys.exit(main())
