# Assembly-Web-Server
![Assembly Icon](https://img.shields.io/badge/x86-Assembly-green?style=for-the-badge&logo=assembly)

This will assembly the x86 into ELF64 object file format using nasm
```bash
nasm -f elf64 server.asm -o server
```

Then we will use ld linker
```bash
ld -o server server.asm
```
