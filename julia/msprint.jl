# Read massif.out.<pid> from `valgrind --tools=massif`
infile = ARGS[1]
content = open(infile) do file
    read(file, String)
end

function parse_block(s)
    lines = split(s, "\n"; limit=8)
    [split(x, "=")[2] for x in lines[3:7]]
end

blocks = split(content, "#-----------\nsnapshot=")
names = ["time", "mem_heap_B", "mem_heap_extra_B", "mem_stacks_B", "heap_tree"]
println(join(names, "\t"))
for block in blocks[2:end]
    values = parse_block(block)
    println(join(values, "\t"))
end
