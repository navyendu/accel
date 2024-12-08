SRCS = \
	rtl/testbench.v

build:
	iverilog $(SRCS) -I rtl

run:
	./a.out
