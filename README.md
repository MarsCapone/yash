YASH (Yet Another SHell)
========================

A simple shell in Ruby.

The shell can run any command on the system path, and has use of the `|` symbol
for redirecting outputs as inputs to other programs. 

Parslet is used to parse commands. 

There is also a facility for custom commands by extending the `BuiltinCommand` 
class and adding instances to the `CommandHandler`.
