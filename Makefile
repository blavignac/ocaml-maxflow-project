.PHONY: all build format edit demo clean

src?=0
dst?=5
graph?=graph1.txt
exportfile?=exportfile.txt
all: build

build:
	@echo "\n   🚨  COMPILING  🚨 \n"
	dune build src/ftest.exe
	ls src/*.exe > /dev/null && ln -fs src/*.exe .

format:
	ocp-indent --inplace src/*

edit:
	code . -n

exp: build
	@echo "\n   🚢  EXPORTING  🚢\n"
	./ftest.exe graphs/${graph} $(src) $(dst) outfile $(exportfile)
	@echo "\n   🎆  RESULT (content of exportfile.txt)  🎆\n"
	@cat $(exportfile)

demo: build
	@echo "\n   ⚡  EXECUTING  ⚡\n"
	./ftest.exe graphs/${graph} $(src) $(dst) outfile $(exportfile)
	@echo "\n   🥁  RESULT (content of outfile)  🥁\n"
	@cat outfile


clean:
	find -L . -name "*~" -delete
	rm -f *.exe
	dune clean
