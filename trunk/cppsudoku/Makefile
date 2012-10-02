# Start

CC=g++

VERSION=0.1

CFLAGS=-DVERSION=$(VERSION) -O2 -fomit-frame-pointer -funroll-all-loops -g -c -W -Wall -I.
LDFLAGS=

CFLAGS+=-DDEBUG

SRCS=\
int2string.cpp \
main.cpp \
cell.cpp \
table.cpp

EXE=sudoku

OBJS=$(SRCS:.cpp=.o)

HDRS=$(*.hpp)

$(EXE): $(OBJS)
	$(CC) $(LDFLAGS) $(OBJS) -o $@

all: $(SRCS) $(EXE)

dep.mk: $(SRCS) $(HDRS)
	$(CC) $(CFLAGS) -MM $(SRCS) > dep.mk

include dep.mk

.cpp.o:
	$(CC) $(CFLAGS) $< -o $@

clean:
	rm -rf *.o $(EXE) core.* dep.mk
