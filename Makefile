NAME = videogrid
VERSION = 0.6

PD_DIR = /home/ub/build/pd-git
GEM_DIR = @GEM_DIR@

FF_CFLAGS = 
FF_LIBS   = 

LIBS = -lm -lc  -lm
CFLAGS = -g -O2 -Wall

# choose target by OS
UNAME := $(shell uname)
ifeq ($(UNAME), Linux)
TARGET=pd_linux
else
TARGET=pd_darwin
#FF_CFLAGS=-I/sw/include ??
#PD_DIR=/Applications/Pd-extended.app/Contents/Resources/include ??
endif


current: $(TARGET)

# ----------------------- LINUX -----------------------

pd_linux: $(NAME).pd_linux

.SUFFIXES: .pd_linux

.cc.pd_linux:
	g++ $(FF_CFLAGS) $(CFLAGS) -I$(PD_DIR)/src -I$(GEM_DIR)/src -fPIC -c -O -o videogrid.o videogrid.cc
	g++ $(FF_CFLAGS) $(CFLAGS) -Wl,--export-dynamic  -shared -o videogrid.pd_linux videogrid.o $(FF_LIBS) $(LIBS)
	rm -f $*.o 

# ----------------------------------------------------------

# ----------------------- LINUX -----------------------

pd_darwin: $(NAME).pd_darwin

.SUFFIXES: .pd_darwin

.cc.pd_darwin:
	g++ $(FF_CFLAGS) -I$(PD_DIR)/src -I$(GEM_DIR)/src -fPIC -c -O -o videogrid.o videogrid.cc
	g++ $(FF_CFLAGS) $(CFLAGS) -Wl -bundle -undefined dynamic_lookup -o videogrid.pd_darwin videogrid.o $(FF_LIBS) $(LIBS)
	rm -f $*.o 

# ----------------------------------------------------------

install:
	cp *-help.pd $(PD_DIR)/doc/5.reference

clean:
	rm -f *.o *.pd_* so_locations
