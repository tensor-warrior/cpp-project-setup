# Include the Conan-generated dependencies
-include build/conandeps.mk

CXX ?= g++
CXXFLAGS ?= -std=c++17 -Wall

# Flags prefixes required by MakeDeps
CONAN_LIB_FLAG ?= -l
CONAN_INCLUDE_DIR_FLAG ?= -I
CONAN_LIB_DIR_FLAG ?= -L

# Append Conan flags
CXXFLAGS += -Iinclude $(CONAN_INCLUDE_DIRS)
LDFLAGS += $(CONAN_LIB_DIRS)
LDLIBS += $(CONAN_LIBS) $(CONAN_SYSTEM_LIBS)

ifeq ($(OS),Windows_NT)
EXEEXT = .exe
MKDIR_BIN = cmd /C "if not exist bin mkdir bin"
MKDIR_OBJ = cmd /C "if not exist build\obj mkdir build\obj"
CLEAN_FILES = cmd /C "for %f in ($(subst /,\,$(OBJS)) $(subst /,\,$(LEGACY_OBJS)) $(subst /,\,$(TARGET))) do @if exist %f del /Q %f"
else
MKDIR_BIN = mkdir -p bin
MKDIR_OBJ = mkdir -p build/obj
CLEAN_FILES = rm -f $(OBJS) $(LEGACY_OBJS) $(TARGET)
endif

TARGET = bin/app$(EXEEXT)
SRCS = $(wildcard src/*.cpp)
OBJS = $(patsubst src/%.cpp,build/obj/%.o,$(SRCS))
LEGACY_OBJS = $(SRCS:.cpp=.o)

.PHONY: all run clean

all: $(TARGET)

$(TARGET): $(OBJS) | bin
	$(CXX) $(OBJS) -o $@ $(LDFLAGS) $(LDLIBS)

build/obj/%.o: src/%.cpp | build/obj
	$(CXX) $(CXXFLAGS) -c $< -o $@

bin:
	$(MKDIR_BIN)

build/obj:
	$(MKDIR_OBJ)

run: $(TARGET)
	./$(TARGET)

clean:
	$(CLEAN_FILES)