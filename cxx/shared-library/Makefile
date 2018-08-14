CXX = clang++
CXXFLAGS = -g -O2 -Wall -Wextra -Wpedantic -fPIC
LDFLAGS = -L. -Wl,-rpath,. -ltest

all: a.out
	./$< &
	sleep 1
	./$<

a.out: main.o libtest.so
	$(LINK.cpp) ${OUTPUT_OPTION} $<

libtest.so: test.o
	$(CXX) -shared -o $@ $<

clean:
	$(RM) *.out *.so *.o
