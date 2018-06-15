target remote localhost:3333
file DIYAudio.elf
mon reset halt
tbreak main
c

define reset
	mon reset halt
end
