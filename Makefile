.PHONY: tests

repl:
	@doppler run -- make -f Makefile.ac repl

build:
	@doppler run -- make -f Makefile.ac build

test:
	@doppler run -- make -f Makefile.ac test

tests:
	@doppler run -- make -f Makefile.ac tests

format:
	@make -f Makefile.ac format

lint:
	@make -f Makefile.ac lint

lldb:
	@doppler run -- make -f Makefile.ac lldb

report:
	@doppler run -- make -f Makefile.cov report

show:
	@doppler run -- make -f Makefile.cov show
