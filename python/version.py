from packaging import version

assert version.parse("24.0.2") > version.parse("17.12.0")

def version_tuple(s: str):
    return tuple(int(x) for x in s.split("."))

assert version_tuple("24.0.2") > version_tuple("17.12.0")
assert version_tuple("24.0") > version_tuple("17.12.0")
assert version_tuple("17.9.9") < version_tuple("17.12.0")
