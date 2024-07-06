## An unfinished stack-based language
This compiler lets you compile code like `17 . 22 11 + emit` (prints out `17!`). It is completely useless, but it helped me get a bit better at Common Lisp and x86-64 assembly.
## Requirements 
- x86-64 Linux
- [fasm](https://flatassembler.net/)
- A Common Lisp implementation
## Usage
1. Load `compiler.lisp` in the Common Lisp implementation of your choice (only tested with sbcl)
2. Call `(compile-code "<your source code")`
3. Run `make` (runs the assembler)
