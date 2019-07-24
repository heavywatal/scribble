"""Delete Time Machine local backups to shrink initial backup.

defaults read /Library/Preferences/com.apple.TimeMachine MaxSize
"""
import subprocess


def listlocalsnapshots():
    args = ['/usr/bin/tmutil', 'listlocalsnapshots', '/']
    proc = subprocess.run(args, stdout=subprocess.PIPE)
    stdout = proc.stdout.decode()
    return stdout.split('\n')


def deletelocalsnapshots(date):
    args = ['/usr/bin/tmutil', 'deletelocalsnapshots', date]
    subprocess.run(args)


def main():
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('-n', '--dry-run', action='store_true')
    args = parser.parse_args()
    snapshots = listlocalsnapshots()
    dates = [x.rsplit('.', 1)[-1] for x in snapshots if x]
    print(dates)
    for date in dates:
        print(date)
        if not args.dry_run:
            deletelocalsnapshots(date)


if __name__ == '__main__':
    main()
