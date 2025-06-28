

function build() {
	# -P -undef
	gcc -x assembler-with-cpp -E -o $1.temp $1.asm &&
	avr-as -mmcu=atmega328p -g -o $1.o $1.temp &&
	avr-ld -g -o $1.elf $1.o &&
	#avr-objcopy -j .text -j .data -O ihex $1.o $1.hex
	avr-objcopy -O ihex -R .eeprom $1.elf $1.hex
}

function upload() {
	usudo avrdude -p m328p -c arduino -P /dev/$2 -U flash:w:$1
}

function monitor() {
	usudo arduino-cli monitor -p /dev/$1
}

function emulategdb() {
	simavr -g -f 16000000 -m atmega328p -ff $1
}

function sim() {
	pkill simutron
	./simutron/bin/start-simutron
}

function debug() {
	avr-gdb -x config.gdb $1
}

function clean() {
	\rm *.o
	\rm *.hex
	\rm *.elf
	\rm *.temp
}
