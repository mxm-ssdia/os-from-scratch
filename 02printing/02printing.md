# Whats nasm > (the netwide assembler)

`$ sudo pacman -S nasm`

- Its the tool that builds the component(assembly)
- **Nasm** is a assembler it takes human redable ssembly language (like mov eax, 1) and translate it directly into raw, machine-executable binary code
  - **Purpose** to convert assembly source code (.asm) files into obj files or pure binary files
  - **Input** example.asm written in x86 or x86_64
  - **Output**
    - **Object files** (.o / .obj )
    - **Flat binary files** ( .bin ) pure code no metadata.Crutial for writing things like bootloader or os kernals that runs directly runs on the hardware
    - **Assembly to flat binary** `$ nasm -f bin my_program.asm -o my_program.bin`

---

# Whats qemu (The quick emulator)

`$ sudo pacman -Syu`
`$ sudo pacman -S nasm qemu-full`

- The env that lets you test and run that component (emulates a cmpt)
- **QEMU is a machine emulator and virtualizer.** It can mimic an entire computer system (CPU, RAM, disks, peripherals) without needing physical hardware.
- **Purpose** to run os build for one type of machine (eg x86_64) on a diff machine (eg ARM based Mac)

* **Emulation** it translate the inst of (x86_64) into inst for the (ARM)
* **Modes of emmulation**
  - **Sys emulation** emulates a full sys Pc
  - **User-mode emulation** emulates just the cpu and syscall env to run a single program compiled for a diff OS (like running a linux prog on windows)

- **Run a raw binary file as if it were a bootable disk img**
  - `$ qemu-system-x86_64 -drive format=raw,file=my_program.bin`
