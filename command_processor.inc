/*
    Command Processor ~ Kevin-Reinke

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program. If not, see <http://www.gnu.org/licenses/>.
*/

#if defined _cmdp_included
    #endinput
#endif

#define _cmdp_included

#if !defined sscanf
    #error "SSCANF could not be found"
#endif

#if !defined isnull
    #define isnull(%1) ((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
#endif

#if defined OnPlayerCommandReceived
    forward OnPlayerCommandReceived(playerid, cmd[], params[], flags);
#endif

#if defined OnPlayerCommandPerformed
    forward OnPlayerCommandPerformed(playerid, cmd[], params[], success, flags);
#endif

#define CMD:%1(%2) forward cmd_%1(%2); public cmd_%1(%2)
#define COMMAND:%1(%2) forward cmd_%1(%2); public cmd_%1(%2)
#define cmd(%1,%2) forward cmd_%1(%2); public cmd_%1(%2)
#define command(%1,%2) forward cmd_%1(%2); public cmd_%1(%2)

static stock cmd@flags;

public OnPlayerCommandText(playerid, cmdtext[])
{
    static prefix[4] = {'c', 'm', 'd', '_'}, cmd[28];
    static params[126];

    params = "\1";
    sscanf(cmdtext[1], "s[28]s[126]", cmd[4], params);

    for (new i = strlen(cmd); --i != -1;)
    {
        cmd[i] |= 0x20;
    }

    cmd@flags = getproperty(.name = cmd);

    #if defined OnPlayerCommandReceived
        if (!OnPlayerCommandReceived(playerid, cmd, params, cmd@flags)) return 1;
    #endif

    #if defined OnPlayerCommandPerformed
        return OnPlayerCommandPerformed(playerid, cmd, params, CallLocalFunction(prefix, "is", playerid, params, cmd@flags));
    #else
        return CallLocalFunction(prefix, "is", playerid, params);
    #endif
}

stock CMD_GetFlags(const cmd[])
{
    return getproperty(.name = cmd);
}

stock CommandExists(const cmd[])
{
    static prefix[4] = {'c', 'm', 'd', '_'}, cmd_name[28];

    strcpy(cmd_name, cmd);
    return funcidx(prefix) != -1;
}

stock CMD_SetFlags(const cmd[], flags)
{
    setproperty(.name = cmd, .value = flags);
}
