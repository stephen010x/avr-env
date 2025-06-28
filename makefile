SHELL:=/bin/bash

script:=./make.sh
name:=text
port:=ttyUSB0
#port:=ttyACM0

all: build

build:
	source $(script) && build $(name)

upload:
	source $(script) && upload $(name).hex $(port)

emulate:
	source $(script) && emulategdb $(name).elf

debug:
	source $(script) && debug $(name).elf

sim:
	source $(script) && sim

clean:
	source $(script) && clean


.PHONY: all build upload monitor emulategdb debug clean
