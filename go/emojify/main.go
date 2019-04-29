package main

import (
	"bufio"
	"os"
	"github.com/kyokomi/emoji"
)

func main() {
	var stdin = bufio.NewScanner(os.Stdin)
	for stdin.Scan() {
		emoji.Println(stdin.Text())
	}
}
