# Makefile for RISC-V ISA Manuals
#
# This work is licensed under the Creative Commons Attribution-ShareAlike 4.0
# International License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-sa/4.0/ or send a letter to
# Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
#
# SPDX-License-Identifier: CC-BY-SA-4.0
#
# Description:
# 
# This Makefile is designed to automate the process of building and packaging 
# the documentation for RISC-V ISA Manuals. It supports multiple build targets 
# for generating documentation in various formats (PDF, HTML).
DOCS := \
		riscv-interrupts.adoc

SRC_DIR := src
BUILD_DIR := build

DOCKER_RUN := docker run --rm -v ${PWD}:/build -w /build \
riscvintl/riscv-docs-base-container-image:latest

HEADER_SOURCE := ${SRC_DIR}/riscv-interrupts.adoc
PDF_RESULT := riscv-interrupts.pdf

ASCIIDOCTOR_PDF := asciidoctor-pdf
OPTIONS := --trace \
			--verbose \
           -a compress \
           -a mathematical-format=svg \
           -a pdf-fontsdir=docs-resources/fonts \
           -a pdf-theme=docs-resources/themes/riscv-pdf.yml \
           --failure-level=ERROR
REQUIRES := --require=asciidoctor-diagram \
			--require=asciidoctor-mathematical

.PHONY: all build clean build-container build-no-container

all: build

build: 
	@echo "Checking if Docker is available..."
	@if command -v docker >/dev/null 2>&1 ; then \
		echo "Docker is available, building inside Docker container..."; \
		$(MAKE) build-container; \
	else \
		echo "Docker is not available, building without Docker..."; \
		$(MAKE) build-no-container; \
	fi

build-container:
	@echo "Starting build inside Docker container..."
	$(DOCKER_RUN) /bin/sh -c "$(ASCIIDOCTOR_PDF) $(OPTIONS) $(REQUIRES) --out-file=$(PDF_RESULT) $(HEADER_SOURCE)"
	@echo "Build completed successfully inside Docker container."

build-no-container:
	@echo "Starting build..."
	$(ASCIIDOCTOR_PDF) $(OPTIONS) $(REQUIRES) --out-file=$(PDF_RESULT) $(HEADER_SOURCE)
	@echo "Build completed successfully."

clean:
	@echo "Cleaning up generated files..."
	rm -f $(PDF_RESULT)
	@echo "Cleanup completed."