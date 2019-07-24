"""
"""
import os
from reportlab.lib.units import mm
from reportlab.platypus import SimpleDocTemplate, Table, TableStyle, Image

edges = ('left', 'right', 'top', 'bottom')


class PlainDoc(SimpleDocTemplate):
    def __init__(self, outfile, width, height, *args, **kwargs):
        kwargs['pagesize'] = [width * mm, height * mm]
        kwargs['author'] = 'Watal M. Iwasaki'
        kwargs['title'] = os.path.basename(outfile)
        kwargs.update({x + 'Margin': 0 for x in edges})
        super().__init__(outfile, *args, **kwargs)


class PlainTable(Table):
    def __init__(self, data):
        super().__init__(data)
        style = [(x.upper() + 'PADDING', (0, 0), (-1, -1), 0) for x in edges]
        self.setStyle(TableStyle(style))


def layout(infiles, cols, width=None, height=None):
    data = []
    for i in range(0, len(infiles), cols):
        data.append([Image(x, width, height) for x in infiles[i:(i + cols)]])
    return data


if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('-o', '--outfile', default='tiled_images.pdf')
    parser.add_argument('-c', '--columns', type=int, default=2)
    parser.add_argument('-W', '--width', type=int, default=300)
    parser.add_argument('-H', '--height', type=int, default=300)
    parser.add_argument('infile', nargs='*')
    args = parser.parse_args()

    print(args.infile)
    doc = PlainDoc(args.outfile, args.width, args.height)
    data = layout(args.infile, args.columns)
    table = PlainTable(data)
    doc.build([table])
