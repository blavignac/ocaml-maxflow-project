.PHONY: all build format edit demo clean

src?=0
dst?=4
graph?=test.txt
exportfile?=exportfile.txt
exportgraph?=exportgraph.svg
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
	@echo "\n   🎆  RESULT (graph displayed on firefox)  🎆\n"
	@dot -Tsvg $(exportfile) > $(exportgraph)
	@rm $(exportfile)
	@firefox $(exportgraph)

demo: build
	@echo "\n   ⚡  EXECUTING  ⚡\n"
	./ftest.exe graphs/${graph} $(src) $(dst) outfile $(exportfile)
	@echo "\n🥁 END 🥁\n"

clean:
	find -L . -name "*~" -delete
	rm -f *.exe
	dune clean

coloc: build
	@echo "\n   🚢  MONEY SHARE  🚢\n"
	./ftest.exe graphs/${graph} 0 1 outfile $(exportfile)
