# https://docs.ruby-lang.org/ja/latest/class/Pathname.html

require 'pathname'

normal = Pathname('normal')
empty = Pathname('')
dot = Pathname('.')
slash = Pathname('/')
trailing_slash = Pathname('trail/')

def print_slash(x, y = Pathname('normal'))
  p [x.to_s, y.to_s, (x / y).to_s]
  p [y.to_s, x.to_s, (y / x).to_s]
end

print_slash(normal)
print_slash(empty)
print_slash(dot)
print_slash(slash)
print_slash(trailing_slash)
