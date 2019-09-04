#
# Authors:     TS
# Maintainers: TS
# Copyright:   2019, HRDAG, GPL v2 or later
# =========================================
# julia-experiments/general/Makefile

.PHONY: all clean

all: index.html

clean: 
		-rm index.html

index.html: README.md
	pandoc $< -o $@ \
		--css=/Users/tshah/.email-stylesheet.css \
		--standalone \
		--self-contained

# done
