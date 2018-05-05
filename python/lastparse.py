#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
parse csv exported from lastpass
"""
import csv


def main(infile, outfile):
    fn = ["grouping", "name", "username", "password", "extra", "url"]
    with open(infile, 'rU') as fin:
        reader = csv.DictReader(fin, delimiter=',')
        dicts = [row for row in reader]
    dicts.sort(key=lambda d: d["name"])
    dicts.sort(key=lambda d: d["grouping"])
    with open(outfile, 'w') as fout:
        writer = csv.DictWriter(fout, fieldnames=fn, extrasaction="ignore")
        writer.writeheader()
        writer.writerows(dicts)


if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("-o", "--outfile", default="ssaptsal.csv")
    parser.add_argument("infile")
    args = parser.parse_args()

    main(args.infile, args.outfile)
