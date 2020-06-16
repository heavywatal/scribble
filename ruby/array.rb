x = [1, 2, 3]
p x
p x.first

y = []
p y
p y.first

p [].empty?
p [].nil?

def func(*items)
  p items
end

func(1, 2)
func(1)
func()
func(nil)
