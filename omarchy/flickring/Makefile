CXXFLAGS ?= -O2
CXXFLAGS += -shared -fPIC -std=c++2b -Wall -Wno-c++11-narrowing -Wno-narrowing
ifeq ($(CXX),g++)
    EXTRA_FLAGS = --no-gnu-unique
endif
INCLUDES = `pkg-config --cflags pixman-1 libdrm hyprland libinput libudev wayland-server xkbcommon cairo`

SRC = src/main.cpp src/FlickRing.cpp
TARGET = flickring.so

all: $(TARGET)

$(TARGET): $(SRC) src/FlickRing.hpp
	$(CXX) $(CXXFLAGS) $(LDFLAGS) $(EXTRA_FLAGS) $(INCLUDES) $(SRC) -o $@

clean:
	rm -f ./$(TARGET)

.PHONY: all clean
