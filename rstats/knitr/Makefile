QMD_SRCS := $(wildcard *.qmd)
RMD_SRCS := $(wildcard *.Rmd)
PRODUCTS := $(QMD_SRCS:.qmd=.md) $(QMD_SRCS:.qmd=.html)
PRODUCTS := $(RMD_SRCS:.Rmd=.md) $(RMD_SRCS:.Rmd=.html)

$(info SRCS = ${QMD_SRCS} ${RMD_SRCS})
$(info PRODUCTS = ${PRODUCTS})

all: ${PRODUCTS}
	@:

%.md: %.qmd
%.md: %.Rmd
	knit.R $<

%.html: %.Rmd
	rende.R $<

%.html: %.qmd
	quarto render $<
