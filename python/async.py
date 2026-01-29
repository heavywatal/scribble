import asyncio


async def main() -> None:
    print("main start")
    tasks: list[asyncio.Task[None]] = []
    tasks.append(asyncio.create_task(coroutine("Alice")))
    tasks.append(asyncio.create_task(coroutine("Bob")))
    tasks.append(asyncio.create_task(subp(["sleep", "1"])))
    await asyncio.sleep(0)  # next line is printed before Hello without this
    print("main middle")
    await asyncio.gather(*tasks)
    print("main end")


async def coroutine(name: str) -> None:
    print(f"Hello, {name}!")
    await asyncio.sleep(1)  # not time.sleep(1)
    print(f"Bye!, {name}!")


async def subp(args: list[str]) -> None:
    cmd = " ".join(args)
    print(cmd)
    process = await asyncio.create_subprocess_exec(
        *args,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE,
    )
    stdout, stderr = await process.communicate()
    print(f"{cmd} returned {process.returncode}")
    if stdout:
        print(f"[stdout]\n{stdout.decode()}")
    if stderr:
        print(f"[stderr]\n{stderr.decode()}")


if __name__ == "__main__":
    asyncio.run(main())
