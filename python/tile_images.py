import argparse
from pathlib import Path

from reportlab.lib.units import mm
from reportlab.platypus import Image, SimpleDocTemplate, Table, TableStyle

edges = ("left", "right", "top", "bottom")


class PlainDoc(SimpleDocTemplate):
    def __init__(self, outfile: Path, width: int, height: int, *args, **kwargs) -> None:
        kwargs["pagesize"] = [width * mm, height * mm]
        kwargs["author"] = "Watal M. Iwasaki"
        kwargs["title"] = outfile.name
        kwargs.update({x + "Margin": 0 for x in edges})
        super().__init__(outfile, *args, **kwargs)


class PlainTable(Table):
    def __init__(self, data) -> None:
        super().__init__(data)
        style = [(x.upper() + "PADDING", (0, 0), (-1, -1), 0) for x in edges]
        self.setStyle(TableStyle(style))


def layout(
    infiles: list[str], cols: int, width: int | None = None, height: int | None = None
):
    data = []
    for i in range(0, len(infiles), cols):
        data.append([Image(x, width, height) for x in infiles[i : (i + cols)]])
    return data


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-o", "--outfile", default="tiled_images.pdf", type=Path)
    parser.add_argument("-c", "--columns", type=int, default=2)
    parser.add_argument("-W", "--width", type=int, default=300)
    parser.add_argument("-H", "--height", type=int, default=300)
    parser.add_argument("infile", nargs="*")
    args = parser.parse_args()

    print(args.infile)
    doc = PlainDoc(args.outfile, args.width, args.height)
    data = layout(args.infile, args.columns)
    table = PlainTable(data)
    doc.build([table])
