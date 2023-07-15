DESTDIR ?=
PREFIX ?= /usr/local
LIBDIR ?= $(PREFIX)/lib
BINDIR ?= $(PREFIX)/bin
ifdef DEB_HOST_MULTIARCH
LIBDIR := $(LIBDIR)/$(DEB_HOST_MULTIARCH)
endif

CC = $(HOME)/arm-rpi-linux-gnueabihf/bin/arm-rpi-linux-gnueabihf-gcc
AR = $(HOME)/arm-rpi-linux-gnueabihf/bin/arm-rpi-linux-gnueabihf-ar
LD = $(HOME)/arm-rpi-linux-gnueabihf/bin/arm-rpi-linux-gnueabihf-gcc

WARNINGS = -Wall -Wextra -Werror -Wfatal-errors
INCLUDE_DIRS = -I ../include
override CFLAGS := $(WARNINGS) $(INCLUDE_DIRS) -fPIC \
--sysroot="$(HOME)/arm-rpi-linux-gnueabihf/arm-rpi-linux-gnueabihf/sysroot" \
-B"$(HOME)/arm-rpi-linux-gnueabihf/bin/arm-rpi-linux-gnueabihf-" \
$(CFLAGS)

VPATH = ../include/tinyalsa
OBJECTS = limits.o mixer.o pcm.o pcm_plugin.o pcm_hw.o snd_card_plugin.o mixer_plugin.o mixer_hw.o

.PHONY: all
all: libtinyalsa-rpi.a

pcm.o: pcm.c limits.h pcm.h pcm_io.h plugin.h snd_card_plugin.h

pcm_plugin.o: pcm_plugin.c asoundlib.h pcm_io.h plugin.h snd_card_plugin.h

pcm_hw.o: pcm_hw.c asoundlib.h pcm_io.h

limits.o: limits.c limits.h

mixer.o: mixer.c mixer.h mixer_io.h plugin.h

snd_card_plugin.o: snd_card_plugin.c plugin.h snd_card_plugin.h

mixer_plugin.o: mixer_plugin.c mixer_io.h plugin.h snd_card_plugin.h

mixer_hw.o: mixer_hw.c mixer_io.h

libtinyalsa-rpi.a: $(OBJECTS)
	$(AR) $(ARFLAGS) $@ $^

.PHONY: clean
clean:
	rm -f $(OBJECTS)
