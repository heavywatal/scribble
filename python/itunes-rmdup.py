"""Move old files to trash, rename new files to old names.
"""
import pathlib
import shutil
import datetime


def print_stat(file):
    dt = datetime.datetime.fromtimestamp(file.stat().st_ctime)
    time = dt.isoformat(timespec='seconds')
    size = round(file.stat().st_size * 1e-3)
    print(f'{time} {size:>7}KB  {file.name}')


def rmdup(directory, dry_run=False, force=False):
    dir = pathlib.Path(directory)
    tracks = dict()
    for file in sorted(dir.glob('*.m4a')):
        print_stat(file)
        key = file.name.split(' ', 1)[0]
        tracks.setdefault(key, []).append(file)
    print(tracks.keys())
    duplicated = {k: v for k, v in tracks.items() if len(v) > 1}
    print(f'{len(duplicated)} duplicates')
    trash = pathlib.Path('~/.Trash').expanduser()
    for files in duplicated.values():
        old, new = sorted(files, key=lambda x: x.stat().st_ctime)
        try:
            assert old.stat().st_size < new.stat().st_size
        except AssertionError as err:
            print("The new one is smaller:")
            print_stat(old)
            print_stat(new)
            if not force:
                raise err
        if dry_run:
            print('- ' + old.name)
            print('+ ' + new.name)
        else:
            shutil.move(str(old), trash)
            shutil.move(str(new), str(old))
            print_stat(old)


def main():
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('-n', '--dry-run', action='store_true')
    parser.add_argument('-f', '--force', action='store_true')
    parser.add_argument('directory')
    args = parser.parse_args()
    rmdup(args.directory, args.dry_run, args.force)


if __name__ == '__main__':
    main()
