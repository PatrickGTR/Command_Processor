# Command Processor - SA-MP

This include was written by SickAttack

Original thread: http://forum.sa-mp.com/showthread.php?t=618661

Original Repository: https://github.com/Kevin-Reinke/Command_Processor

This is a modified version of it that includes flags.



- Functions
-----------

```pawn
native CMD_SetFlags(const cmd[], flags);
```
__Description:__
Sets the specified command's flag value.

__Parameters:__
- cmd - The name of the command (in lower-case).
- flags - The flag value to set for a command.

__Return Values:__
This function does not return any specific values.



```pawn
native CMD_GetFlags(const cmd[]);
```
__Description:__
Gets the specified command's flag value.

__Parameters:__
- cmd - The name of the command (in lower-case).

__Return Values:__
The current flag value of the specified command, 0 if none is set or command does not exist.



```pawn
native CommandExists(const cmd[]);
```
__Description:__
Checks if a command exists.

__Parameters:__
- cmd - The name of the command (in lower-case).

__Return Values:__
- 0: Command does not exist.
- 1: Command exists.
