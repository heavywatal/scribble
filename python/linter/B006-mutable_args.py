# ruff: noqa: S101
from collections.abc import Sequence


def dangerous(mutarg: list[int] = []) -> list[int]:  # noqa: B006
    mutarg.append(1)
    return mutarg


assert dangerous() == [1]  # initialize the default [] only once
assert dangerous() == [1, 1]  # surprising!
assert dangerous([2]) == [2, 1]
assert dangerous() == [1, 1, 1]  # surprising!


def partial_safety_by_annotation(pseudo_immut: Sequence[str] = ()) -> Sequence[str]:
    """Can receive mutable as well, but linter blames mutation."""
    # pseudo_immut.append("blamed")
    if isinstance(pseudo_immut, list):
        pseudo_immut.append("not blamed")
    print(f"{pseudo_immut=}")
    return pseudo_immut


partial_safety_by_annotation()
partial_safety_by_annotation(["list"])
partial_safety_by_annotation(("tuple",))
