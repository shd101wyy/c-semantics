SEMANTICS_DIR = semantics
SCRIPTS_DIR = scripts
PARSER_DIR = parser
LIBC_DIR = libc
PARSER = $(PARSER_DIR)/cparser
DIST_DIR = dist
#svnversion

#export C_K_BASE ?= $(C_K_BASE)

FILES_TO_DIST = \
	$(wildcard $(SCRIPTS_DIR)/*.sql) \
	$(SCRIPTS_DIR)/accessProfiling.pl \
	$(SCRIPTS_DIR)/compile.pl \
	$(SCRIPTS_DIR)/xmlToK.pl \
	$(SCRIPTS_DIR)/programRunner.pl \
	$(SCRIPTS_DIR)/analyzeProfile.pl \
	$(PARSER_DIR)/cparser \
	$(wildcard $(LIBC_DIR)/includes/*) \
	$(wildcard $(LIBC_DIR)/src/*)

.PHONY: all fast thread check-vars dist pdf test cparser semantics clean

all: WHICH_SEMANTICS="semantics"
all: dist

fast: WHICH_SEMANTICS="fast"
fast: dist

thread: WHICH_SEMANTICS="thread"
thread: dist

check-vars:
ifeq ($(C_K_BASE),)
	@echo "ERROR: Please set C_K_BASE to the full path of your K installation."
	@echo "Make sure you do NOT include a trailing slash\\"
	@echo "One way to do this is to type 'export C_K_BASE=/path/to/k/framework', and then rerun 'make'"
	@exit 1
endif
	@if ! ocaml -version > /dev/null 2>&1; then echo "ERROR: You don't seem to have ocaml installed.  You need to install this before continuing.  Please see the README for more information."; false; fi
	@if ! gcc -v > /dev/null 2>&1; then echo "ERROR: You don't seem to have gcc installed.  You need to install this before continuing.  Please see the README for more information."; false; fi
	@if ! maude --version > /dev/null 2>&1; then echo "ERROR: You don't seem to have maude installed.  You need to install this before continuing.  Please see the README for more information."; false; fi
	@perl $(SCRIPTS_DIR)/checkForModules.pl

dist: check-vars $(DIST_DIR)/dist.done

pdf: check-vars
	@$(MAKE) -C $(SEMANTICS_DIR) pdf

$(DIST_DIR)/dist.done: check-vars Makefile cparser semantics $(FILES_TO_DIST)
	@mkdir -p $(DIST_DIR)
	@mkdir -p $(DIST_DIR)/includes
	@mkdir -p $(DIST_DIR)/lib
	@cp $(FILES_TO_DIST) $(DIST_DIR)
	@cp -r $(SEMANTICS_DIR)/c11-kompiled $(DIST_DIR)
	@cp -r $(SEMANTICS_DIR)/c11-kompiled-nd $(DIST_DIR)
	@cp -r $(SEMANTICS_DIR)/c11-kompiled-nd-thread $(DIST_DIR)
	@mv $(DIST_DIR)/*.h $(DIST_DIR)/includes
	@mv $(DIST_DIR)/*.c $(DIST_DIR)/lib
	@mv $(DIST_DIR)/compile.pl $(DIST_DIR)/kcc
	@echo "Compiling the standard library..."
	@echo compiling clib
	@$(DIST_DIR)/kcc -c -o $(DIST_DIR)/lib/clib.o $(DIST_DIR)/lib/clib.c
	@echo compiling ctype
	@$(DIST_DIR)/kcc -c -o $(DIST_DIR)/lib/ctype.o $(DIST_DIR)/lib/ctype.c
	@echo compiling math
	@$(DIST_DIR)/kcc -c -o $(DIST_DIR)/lib/math.o $(DIST_DIR)/lib/math.c
	@echo compiling stdio
	@$(DIST_DIR)/kcc -c -o $(DIST_DIR)/lib/stdio.o $(DIST_DIR)/lib/stdio.c
	@echo compiling stdlib
	@$(DIST_DIR)/kcc -c -o $(DIST_DIR)/lib/stdlib.o $(DIST_DIR)/lib/stdlib.c
	@echo compiling string
	@$(DIST_DIR)/kcc -c -o $(DIST_DIR)/lib/string.o $(DIST_DIR)/lib/string.c
	@echo "Done."
	@echo "Testing kcc..."
	@perl $(SCRIPTS_DIR)/testInstall.pl $(DIST_DIR)/kcc $(DIST_DIR)/testProgram.c $(DIST_DIR)/testProgram.compiled
	@echo "Done."
	@echo "Calibrating the semantic profiler..."
# done so that an empty file gets copied by the analyzeProfile.pl wrapper
	@mv maudeProfileDB.sqlite maudeProfileDB.sqlite.calibration.bak > /dev/null 2>&1 || true
	@touch maudeProfileDB.sqlite
	@perl $(SCRIPTS_DIR)/initializeProfiler.pl $(DIST_DIR)/c11-kompiled/base.maude
	@mv maudeProfileDB.sqlite $(DIST_DIR)/maudeProfileDB.calibration.sqlite
	@mv maudeProfileDB.sqlite.calibration.bak maudeProfileDB.sqlite > /dev/null 2>&1 || true
	@echo "Done."
	@echo "Cleaning up..."
	@rm -f $(DIST_DIR)/testProgram.c
	@rm -f $(DIST_DIR)/testProgram.compiled
	@echo "Done."
	@touch $(DIST_DIR)/dist.done

test: dist
	@$(MAKE) -C tests

cparser:
	@$(MAKE) -C $(PARSER_DIR)
	@-strip $(PARSER)

semantics: check-vars
	@$(MAKE) $(WHICH_SEMANTICS) -C $(SEMANTICS_DIR)

clean:
	$(MAKE) -C $(PARSER_DIR) clean
	$(MAKE) -C $(SEMANTICS_DIR) clean
	$(MAKE) -C tests clean
	rm -rf $(DIST_DIR)
	rm -f ./*.tmp ./*.log ./*.cil ./*-gen.maude ./*.gen.maude ./*.pre.gen ./*.prepre.gen ./a.out ./*.kdump ./*.pre.pre
