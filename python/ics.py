"""Apple Reminder format (.ics) <-> Plain text."""
import argparse
import re
from pathlib import Path


def read(infile: Path) -> list[str]:
    entries: list[str] = []
    patt = re.compile("SUMMARY:(.*)")
    with infile.open("r") as fin:
        for mobj in patt.finditer(fin.read()):
            print(mobj.group(1))
            entries.append(mobj.group(1))
    return entries


def write(entries: list[str], outfile: Path) -> None:
    template = "BEGIN:VTODO\nSUMMARY:{}\nEND:VTODO\n"
    entries = [template.format(x) for x in entries]
    with outfile.open("w") as fout:
        fout.write("BEGIN:VCALENDAR\n")
        fout.writelines(entries)
        fout.write("END:VCALENDAR\n")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("infile", type=Path)
    args = parser.parse_args()

    if args.infile.suffix == ".ics":
        entries = read(args.infile)
        outfile = args.infile.stem + ".txt"
        print("\noutput: " + outfile)
        with outfile.open("w") as fout:
            fout.write("\n".join(entries) + "\n")
    else:
        entries: list[str] = []
        with args.infile.open("r") as fin:
            for line in fin:
                print(line.strip())
                entries.append(line.strip())
        outfile = args.infile.stem + ".ics"
        print("\noutput: " + outfile)
        write(entries, outfile)


if __name__ == "__main__":
    main()
