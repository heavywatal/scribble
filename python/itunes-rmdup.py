#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Move old files to trash, rename new files to old names
"""
import pathlib
import shutil
import datetime


def print_stat(file):
    dt = datetime.datetime.fromtimestamp(file.stat().st_ctime)
    time = dt.isoformat(timespec='seconds')
    size = round(file.stat().st_size * 1e-6)
    print(f'{time} {size:>4}MB  {file.name}')


def sort_by_ctime_size(files):
    if files[0].stat().st_ctime < files[1].stat().st_ctime:
        assert files[0].stat().st_size < files[1].stat().st_size
        return files
    else:
        assert files[0].stat().st_size > files[1].stat().st_size
        return reversed(files)


def rmdup(directory, dry_run=False):
    dir = pathlib.Path(directory)
    tracks = dict()
    for file in sorted(dir.glob('*.m4a')):
        print_stat(file)
        key = file.name.split(' ', 1)[0]
        tracks.setdefault(key, []).append(file)
    print('######')
    trash = pathlib.Path('~/.Trash').expanduser()
    for files in tracks.values():
        if len(files) == 2:
            old, new = sort_by_ctime_size(files)
            if dry_run:
                print('old: ' + str(old))
                print('new: ' + str(new))
            else:
                shutil.move(str(old), trash)
                shutil.move(str(new), str(old))
                print_stat(old)


def main():
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('-n', '--dry-run', action='store_true')
    parser.add_argument('directory')
    args = parser.parse_args()
    rmdup(args.directory, args.dry_run)


if __name__ == '__main__':
    main()
