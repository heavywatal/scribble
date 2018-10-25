// Read massif.out.<pid> from `valgrind --tools=massif`

package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"strings"
)

func parse_block(s string) []string {
	var lines []string = strings.SplitN(s, "\n", 8)
	var values []string
	for _, line := range lines[2:7] {
		values = append(values, strings.Split(line, "=")[1])
	}
	return values
}

func main() {
	var infile string = os.Args[1]
	data, err := ioutil.ReadFile(infile)
	if err != nil {
		fmt.Print(err)
		return
	}
	names := []string{"time", "mem_heap_B", "mem_heap_extra_B", "mem_stacks_B", "heap_tree"}
	println(strings.Join(names, "\t"))
	var blocks []string = strings.Split(string(data), "#-----------\nsnapshot=")
	for _, block := range blocks[1:] {
		var values []string = parse_block(block)
		println(strings.Join(values, "\t"))
	}
}
