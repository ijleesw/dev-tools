#!/usr/bin/env python3

import os
import argparse
import string
import random
import math

filename_len = 64
filename_pool = "0123456789abcdefghijklmnopqrstuvwxyz"
filesize_ub = 5 * 1024 * 1024 * 1024    # ub = upper bound
chunk_len = 4096

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--path", type=str, default="./", help="path to generate file")
    parser.add_argument("--size", type=float, default=0, help="file size")
    parser.add_argument("--unit", type=str, default="B", help="unit of size -- B, KB, MB, GB")
    parser.add_argument("--count", type=int, default=1, help="file count")
    args = parser.parse_args()

    assert (os.path.isdir(os.path.abspath(args.path)))
    assert (args.size > 0)
    assert (args.unit == "B" or args.unit == "KB" or args.unit == "MB" or args.unit == "GB")
    assert (args.count >= 1)

    base_size = args.size
    if args.unit == "KB":
        base_size *= 1024
    elif args.unit == "MB":
        base_size *= (1024 * 1024)
    elif args.unit == "GB":
        base_size *= (1024 * 1024 * 1024)
    base_size = int(base_size) - 1

    assert (base_size <= filesize_ub)   # less than or equal to 5GB

    chunk = b'\0' * chunk_len

    for c in range(1, 1+args.count):
        while True:
            filename = ""
            for i in range(filename_len):
                filename += random.choice(filename_pool)
            filepath = os.path.join(os.path.abspath(args.path), filename)
            if not os.path.exists(filepath):
                break

        with open(filepath, "wb") as f:
            size = base_size
            while size > 0:
                if size >= chunk_len:
                    f.write(chunk)
                else:
                    f.write(chunk[:size])
                size -= chunk_len
            f.write(b'\0')

        print("File #{} Done -- Check {}".format(c, filepath))

if __name__ == '__main__':
    main()
