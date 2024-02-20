# Assembly-Web-Server
![Assembly Icon](https://img.shields.io/badge/x86-Assembly-green?style=for-the-badge&logo=assembly)

This will assembly the x86 into [ELF64](https://en.wikipedia.org/wiki/Executable_and_Linkable_Format) object file format using [nasm](https://www.nasm.us/) (Netwide Assembler)
```bash
nasm -f elf64 server.asm -o server
```

Then we will use [ld](https://ftp.gnu.org/old-gnu/Manuals/ld-2.9.1/html_mono/ld.html) (GNU linker)
```bash
ld -o server server.o
```

## Running the server
I ran the server with [strace](https://en.wikipedia.org/wiki/Strace) so I can see the system-calls while running the server
```bash
strace ./server
```

The output should look something like this

