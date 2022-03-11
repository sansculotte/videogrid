NAME = videogrid
VERSION = 0.3

PD_DIR = /usr/include/pd
GEM_DIR = /home/ub/build/Gem

LDLIBS = -lm -lc -lm

FFMPEG_LIBS=libavcodec   \
			libavformat  \
            libavutil    \
            libswscale   \
 
CFLAGS += -Wall -g -O2 -Wno-write-strings
CFLAGS := $(shell pkg-config --cflags $(FFMPEG_LIBS)) $(CFLAGS)
LDLIBS := $(shell pkg-config --libs $(FFMPEG_LIBS)) $(LDLIBS)

# choose target by OS
UNAME := $(shell uname)

ifeq ($(UNAME), Linux)
TARGET=pd_linux
else
TARGET=pd_darwin
endif


current: $(TARGET)

# ----------------------- LINUX -----------------------

pd_linux: $(NAME).pd_linux

.SUFFIXES: .pd_linux
.cc.pd_linux:
	echo "$(LDIBS)"
	g++ $(FF_CFLAGS) $(CFLAGS) -I$(PD_DIR) -I$(GEM_DIR)/src -fPIC -c -O -o videogrid.o videogrid.cc
	g++ $(FF_CFLAGS) $(CFLAGS) -Wl,--export-dynamic -shared -o videogrid.pd_linux videogrid.o $(LDLIBS)
	rm -f $*.o 

# ----------------------------------------------------------

# ----------------------- LINUX -----------------------

pd_darwin: $(NAME).pd_darwin

.SUFFIXES: .pd_darwin

.cc.pd_darwin:
	g++ $(FF_CFLAGS) -I$(PD_DIR) -I$(GEM_DIR)/src -fPIC -c -O -o videogrid.o videogrid.cc
	g++ $(FF_CFLAGS) $(CFLAGS) -Wl -bundle -undefined dynamic_lookup -o videogrid.pd_darwin videogrid.o $(LDLIBS)
	rm -f $*.o 

# ----------------------------------------------------------

install:
	cp *-help.pd $(PD_DIR)/doc/5.reference

clean:
	rm -f *.o *.pd_* so_locations
