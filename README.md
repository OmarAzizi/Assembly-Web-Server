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

![Screenshot from 2024-02-20 23-53-37](https://github.com/OmarAzizi/Assembly-Web-Server/assets/110500643/525c236f-79cb-46ef-a1db-c0743ef7bc83)

The server is waiting for a connection on port 8080, so se can go to the web browser on http://localhost:8080 to connect to it or run the following [curl](https://www.hostinger.com/tutorials/curl-command-with-examples-linux/#:~:text=Limit%20cURL%20Output-,What%20Is%20cURL%20Command%3F,used%20to%20troubleshoot%20connection%20issues.) command line
```bash
curl --output - http://localhost:8080
```

### Using curl
![image](https://github.com/OmarAzizi/Assembly-Web-Server/assets/110500643/b78708b0-d363-46bb-a58c-4953614808b2)

### Using the web browser
![image](https://github.com/OmarAzizi/Assembly-Web-Server/assets/110500643/fb655d29-bb55-4722-9c3a-d243b06eda61)
 
