CC=gcc # C compiler
CFLAGS=-fPIC -Wall -g -O # C flags
LDFLAGS=-shared -s -static-libgcc # linking flags
RM=rm -f # rm command

OBJS := smooth_whit.o
SRCS := $(patsubst %o, %c, $(OBJS)) 

target=smooth_whit.so

.PHONY: all clean

all: $(OBJS)
	$(CC) $^ $(LDFLAGS) -o $(target)

$(OBJS): $(SRCS)
	$(CC) $(CFLAGS) -c $^ 

#-o $@ 
clean:
	$(RM) *.o *.so *.exe *.dll
