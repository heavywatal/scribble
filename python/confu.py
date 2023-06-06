import concurrent.futures as confu
import time


def main():
    with confu.ThreadPoolExecutor(3) as pool:
        ls = "ABC"
        for x in ls:
            pool.submit(sub, f"{x}")
        print(f"submitted {ls}")


def sub(label: str):
    with confu.ThreadPoolExecutor(3) as pool:
        ls = list(range(3))
        for i in ls:
            x = f"{label}-{i}"
            pool.submit(sleep_print, x)
        print(f"submitted {ls}")


def sleep_print(label: str, secs: int | float = 0.5):
    print(f"{label} start")
    time.sleep(secs)
    print(f"{label} end")


if __name__ == "__main__":
    main()
