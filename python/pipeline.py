"""Replacing shell pipeline.

> The p1.stdout.close() call after starting the p2 is important
> in order for p1 to receive a SIGPIPE if p2 exits before p1.
>
> <https://docs.python.org/3/library/subprocess.html#replacing-shell-pipeline>
"""
from signal import SIGPIPE
from subprocess import DEVNULL, PIPE, Popen

n = 2**21
n_head = 2**4
seq = ["seq", str(n)]
tee = ["tee", "/dev/stderr"]
head = ["head", "-n", str(n_head)]
wc = ["wc"]


def main() -> None:
    print(f"{n = }, {n_head = }")
    print(f"{_with_parens() = }")
    print(f"{_with_nested() = }")
    print(f"{_with_nested_explicit() = }")
    print(f"{_with_parens_explicit() = }")
    print(f"{_with_parens_rev() = }")
    print(f"{_with_nested_rev() = }")
    print(f"{_without() = }")
    print(f"{_without_rev() = }")


def _with_parens() -> bytes:  # no deadlock unless unnecessary wait() with large n
    with (
        Popen(seq, stdout=PIPE) as pseq,
        Popen(tee, stdin=pseq.stdout, stdout=PIPE, stderr=DEVNULL) as ptee,
        Popen(head, stdin=ptee.stdout, stdout=PIPE) as phead,
        Popen(wc, stdin=phead.stdout, stdout=PIPE) as pwc,
    ):
        result, _ = pwc.communicate()
        # result is ready, but some pipes are still open
        # pseq.wait()  # may deadlock not knowing ptee finished
        # ptee.wait()  # may deadlock not knowing phead finished
        # phead.wait()  # ok
        print(f"{pseq.poll() = }, {ptee.poll() = }, {phead.poll() = }")
    # each __exit__ closes io and waits
    print(f"{pseq.poll() = }, {ptee.poll() = }, {phead.poll() = }")
    assert pseq.returncode in (0, -SIGPIPE)
    assert ptee.returncode in (0, -SIGPIPE)
    assert phead.returncode == 0
    return result


def _with_nested() -> bytes:
    with Popen(seq, stdout=PIPE) as pseq:
        with Popen(tee, stdin=pseq.stdout, stdout=PIPE, stderr=DEVNULL) as ptee:
            with Popen(head, stdin=ptee.stdout, stdout=PIPE) as phead:
                with Popen(wc, stdin=phead.stdout, stdout=PIPE) as pwc:
                    result, _ = pwc.communicate()
                    # pseq.wait()  # may deadlock not knowing ptee finished
                    # ptee.wait()  # may deadlock not knowing phead finished
                    # phead.wait()  # ok
                    print(f"{pseq.poll() = }, {ptee.poll() = }, {phead.poll() = }")
                # pwc.__exit__ closes io and waits
            # phead.__exit__ closes io and waits
        # ptee.__exit__ closes io and waits
        print(f"{pseq.poll() = }, {ptee.poll() = }, {phead.poll() = }")
        assert ptee.returncode in (0, -SIGPIPE)
    # pseq.__exit__ closes io and waits
    print(f"{pseq.poll() = }, {ptee.poll() = }, {phead.poll() = }")
    assert pseq.returncode in (0, -SIGPIPE)
    return result


def _with_nested_explicit() -> bytes:
    with Popen(seq, stdout=PIPE) as pseq:
        with Popen(tee, stdin=pseq.stdout, stdout=PIPE, stderr=DEVNULL) as ptee:
            pseq.stdout.close() if pseq.stdout else None
            with Popen(head, stdin=ptee.stdout, stdout=PIPE) as phead:
                ptee.stdout.close() if ptee.stdout else None
                with Popen(wc, stdin=phead.stdout, stdout=PIPE) as pwc:
                    phead.stdout.close() if phead.stdout else None
                    result, _ = pwc.communicate()
                    # all the processes finish at once thanks to explicit closing
                    print(f"{pseq.poll() = }, {ptee.poll() = }, {phead.poll() = }")
                    assert ptee.returncode in (0, -SIGPIPE)
    return result


def _with_parens_explicit() -> bytes:  # redundant but robust
    with (
        Popen(seq, stdout=PIPE) as pseq,
        Popen(tee, stdin=pseq.stdout, stdout=PIPE, stderr=DEVNULL) as ptee,
        Popen(head, stdin=ptee.stdout, stdout=PIPE) as phead,
        Popen(wc, stdin=phead.stdout, stdout=PIPE) as pwc,
    ):
        pseq.stdout.close() if pseq.stdout else None
        ptee.stdout.close() if ptee.stdout else None
        phead.stdout.close() if phead.stdout else None
        result, _ = pwc.communicate()
        # all the processes finish at once thanks to explicit closing
        print(f"{pseq.poll() = }, {ptee.poll() = }, {phead.poll() = }")
        assert ptee.returncode in (0, -SIGPIPE)
    return result


def _with_parens_rev() -> bytes:
    # tends to deadlock with small n without explicit closing
    with (
        Popen(wc, stdin=PIPE, stdout=PIPE) as pwc,
        Popen(head, stdin=PIPE, stdout=pwc.stdin) as phead,
        Popen(tee, stdin=PIPE, stdout=phead.stdin, stderr=DEVNULL) as ptee,
        Popen(seq, stdout=ptee.stdin) as pseq,
    ):
        phead.stdin.close() if phead.stdin else None  # required if n < n_head
        ptee.stdin.close() if ptee.stdin else None  # required if n < n_head
        result, _ = pwc.communicate()
        # result is ready, but some pipes are still open
        # pseq.wait()  # may deadlock without explicit close
        # ptee.wait()  # may deadlock without explicit close
        # phead.wait()  # ok
        print(f"{pseq.poll() = }, {ptee.poll() = }, {phead.poll() = }")
    # each __exit__ closes io and waits
    print(f"{pseq.poll() = }, {ptee.poll() = }, {phead.poll() = }")
    assert ptee.returncode in (0, -SIGPIPE)
    return result


def _with_nested_rev() -> bytes:
    with Popen(wc, stdin=PIPE, stdout=PIPE) as pwc:
        with Popen(head, stdin=PIPE, stdout=pwc.stdin) as phead:
            with Popen(tee, stdin=PIPE, stdout=phead.stdin, stderr=DEVNULL) as ptee:
                phead.stdin.close() if phead.stdin else None  # required if n < n_head
                with Popen(seq, stdout=ptee.stdin) as pseq:
                    ptee.stdin.close() if ptee.stdin else None  # required if n < n_head
                    result, _ = pwc.communicate()
                    # result is ready, but some pipes are still open
                    # pseq.wait()  # may deadlock without explicit close
                    # ptee.wait()  # may deadlock without explicit close
                    # phead.wait()  # ok
                    print(f"{pseq.poll() = }, {ptee.poll() = }, {phead.poll() = }")
                # pseq.__exit__ closes io and waits
                print(f"{pseq.poll() = }, {ptee.poll() = }, {phead.poll() = }")
                assert pseq.returncode in (0, -SIGPIPE)
                assert ptee.returncode in (0, -SIGPIPE)
            # ptee.__exit__ closes io and waits
        # phead.__exit__ closes io and waits
    # pwc.__exit__ closes io and waits
    return result


def _without() -> bytes:
    pseq = Popen(seq, stdout=PIPE)
    ptee = Popen(tee, stdin=pseq.stdout, stdout=PIPE, stderr=DEVNULL)
    pseq.stdout.close() if pseq.stdout else None  # to receive SIGPIPE from ptee
    phead = Popen(head, stdin=ptee.stdout, stdout=PIPE)
    ptee.stdout.close() if ptee.stdout else None  # to receive SIGPIPE from phead
    pwc = Popen(wc, stdin=phead.stdout, stdout=PIPE)
    phead.stdout.close() if phead.stdout else None  # to receive SIGPIPE from pwc
    result, _ = pwc.communicate()
    # all the processes finish at once thanks to explicit closing
    print(f"{pseq.poll() = }, {ptee.poll() = }, {phead.poll() = }")
    assert ptee.returncode in (0, -SIGPIPE)
    return result


def _without_rev():
    pwc = Popen(wc, stdin=PIPE, stdout=PIPE)
    phead = Popen(head, stdin=PIPE, stdout=pwc.stdin)
    ptee = Popen(tee, stdin=PIPE, stdout=phead.stdin, stderr=DEVNULL)
    phead.stdin.close() if phead.stdin else None  # to send SIGPIPE to ptee?
    pseq = Popen(seq, stdout=ptee.stdin)
    ptee.stdin.close() if ptee.stdin else None  # to send SIGPIPE to seq?
    result, _ = pwc.communicate()
    # result is ready, but some pipes are still open
    print(f"{pseq.poll() = }, {ptee.poll() = }, {phead.poll() = }")
    pseq.wait()  # propagated to others
    print(f"{pseq.poll() = }, {ptee.poll() = }, {phead.poll() = }")
    assert ptee.returncode in (0, -SIGPIPE)
    return result


if __name__ == "__main__":
    main()

# ruff: noqa: S101
# ruff: noqa: S603
# ruff: noqa: SIM117
