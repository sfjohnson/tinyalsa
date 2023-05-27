DESTDIR ?=
PREFIX ?= /usr/local
LIBDIR ?= $(PREFIX)/lib
BINDIR ?= $(PREFIX)/bin
ifdef DEB_HOST_MULTIARCH
LIBDIR := $(LIBDIR)/$(DEB_HOST_MULTIARCH)
endif

HOST_OS := $(shell uname -s | tr '[:upper:]' '[:lower:]')
HOST_ARCH := $(shell uname -m)

CC = $(ANDROID_NDK_HOME)/toolchains/llvm/prebuilt/$(HOST_OS)-$(HOST_ARCH)/bin/aarch64-linux-android30-clang
AR = $(ANDROID_NDK_HOME)/toolchains/llvm/prebuilt/$(HOST_OS)-$(HOST_ARCH)/bin/llvm-ar
LD = $(ANDROID_NDK_HOME)/toolchains/llvm/prebuilt/$(HOST_OS)-$(HOST_ARCH)/bin/aarch64-linux-android30-clang

WARNINGS = -Wall -Wextra -Werror -Wfatal-errors
INCLUDE_DIRS = -I ../include
override CFLAGS := $(WARNINGS) $(INCLUDE_DIRS) -fPIC $(CFLAGS)

VPATH = ../include/tinyalsa
OBJECTS = limits.o mixer.o pcm.o pcm_plugin.o pcm_hw.o snd_card_plugin.o mixer_plugin.o mixer_hw.o

LIBVERSION_MAJOR = $(TINYALSA_VERSION_MAJOR)
LIBVERSION = $(TINYALSA_VERSION)

.PHONY: all
all: libtinyalsa.a libtinyalsa.so

pcm.o: pcm.c limits.h pcm.h pcm_io.h plugin.h snd_card_plugin.h

pcm_plugin.o: pcm_plugin.c asoundlib.h pcm_io.h plugin.h snd_card_plugin.h

pcm_hw.o: pcm_hw.c asoundlib.h pcm_io.h

limits.o: limits.c limits.h

mixer.o: mixer.c mixer.h mixer_io.h plugin.h

snd_card_plugin.o: snd_card_plugin.c plugin.h snd_card_plugin.h

mixer_plugin.o: mixer_plugin.c mixer_io.h plugin.h snd_card_plugin.h

mixer_hw.o: mixer_hw.c mixer_io.h

libtinyalsa.a: $(OBJECTS)
	$(AR) $(ARFLAGS) $@ $^

libtinyalsa.so: libtinyalsa.so.$(LIBVERSION_MAJOR)
	ln -sf $< $@

libtinyalsa.so.$(LIBVERSION_MAJOR): libtinyalsa.so.$(LIBVERSION)
	ln -sf $< $@

libtinyalsa.so.$(LIBVERSION): $(OBJECTS)
	$(LD) $(LDFLAGS) -shared -Wl,-soname,libtinyalsa.so.$(LIBVERSION_MAJOR) $^ -o $@

.PHONY: clean
clean:
	rm -f libtinyalsa.a
	rm -f libtinyalsa.so
	rm -f libtinyalsa.so.$(LIBVERSION_MAJOR)
	rm -f libtinyalsa.so.$(LIBVERSION)
	rm -f $(OBJECTS)

.PHONY: install
install: libtinyalsa.a libtinyalsa.so.$(LIBVERSION_MAJOR)
	install -d $(DESTDIR)$(LIBDIR)/
	install libtinyalsa.a $(DESTDIR)$(LIBDIR)/
	install libtinyalsa.so.$(LIBVERSION) $(DESTDIR)$(LIBDIR)/
	ln -sf libtinyalsa.so.$(LIBVERSION) $(DESTDIR)$(LIBDIR)/libtinyalsa.so.$(LIBVERSION_MAJOR)
	ln -sf libtinyalsa.so.$(LIBVERSION_MAJOR) $(DESTDIR)$(LIBDIR)/libtinyalsa.so

