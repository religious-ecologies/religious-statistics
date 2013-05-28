# Run all the R scripts in the project

# Lincoln A. Mullen | lincoln@lincolnmullen.com | http://lincolnmullen.com
# MIT License <http://lmullen.mit-license.org/>

# Find all .R files, then transform file name to corresponding .Rout
ROUT := $(patsubst %.R,%.Rout,$(shell find . -type f -name '*.R'))

# Find all .png files
PNG := $(shell find . -type f -name '*.png')

# The all rule makes the .Rout files corresponding to .R scripts
.PHONY: all
all: $(ROUT)

# A generic rule makes an .Rout target from the .R script
%.Rout: %.R
	@echo "Running $<"
	R CMD BATCH $(<F)

.PHONY: clean
clean:
	rm $(ROUT)
	rm $(PNG)

.PHONY: rebuild
rebuild: clean all
