"""Simple wrapper of qsub command of PBS system."""
import argparse
import os
import subprocess
from pathlib import Path


def make_script(args: list[str]) -> str:
    args[0] = str(Path(args[0]).resolve())
    assert os.access(args[0], os.X_OK)
    lines = ["#!/bin/sh", "cd $PBS_O_WORKDIR", " ".join(args)]
    return "\n".join(lines) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("-n", "--dry-run", action="store_true")
    parser.add_argument("-N", "--jobname")
    parser.add_argument("-j", "--ncpus", default=1, type=int)
    parser.add_argument("-m", "--mem", default=1, type=int)
    parser.add_argument("positional", nargs="+")
    args = parser.parse_args()
    executable = args.positional[0]
    jobname = args.jobname or Path(executable).name
    resource = f"select=1:ncpus={args.ncpus}:mem={args.mem}gb"
    command = f"qsub -j oe -N {jobname} -l {resource}"
    if executable.endswith(".R"):
        qsub_r = Path(__file__).with_name("qsub.R")
        command += f" -v NCPUS={args.ncpus},INFILE={executable} {qsub_r}"
        input_ = None
    else:
        script = make_script(args.positional)
        input_ = script.encode()
        print(script)
    print(command)
    if not args.dry_run:
        subprocess.run(command, input=input_, shell=True, check=True)


if __name__ == "__main__":
    main()
