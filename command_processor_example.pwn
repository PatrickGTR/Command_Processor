#define FILTERSCRIPT

#include <a_samp>

#undef MAX_PLAYERS
#define MAX_PLAYERS 50

#include <sscanf2>
#include <command_processor>

enum (<<= 1)
{
    UNUSED = 1,
	
    CMD_LEVEL_1, // Vip
    CMD_LEVEL_2, // Moderator
    CMD_LEVEL_3, // Administrator
    CMD_LEVEL_4, // Head Administrator
    CMD_LEVEL_5  // Server Owner
};

enum
{
    MIN_LEVEL_0 = 0,
    MIN_LEVEL_1 = CMD_LEVEL_1 | CMD_LEVEL_2 | CMD_LEVEL_3 | CMD_LEVEL_4 | CMD_LEVEL_5,
    MIN_LEVEL_2 = CMD_LEVEL_2 | CMD_LEVEL_3 | CMD_LEVEL_4 | CMD_LEVEL_5,
    MIN_LEVEL_3 = CMD_LEVEL_3 | CMD_LEVEL_4 | CMD_LEVEL_5,
    MIN_LEVEL_4 = CMD_LEVEL_4 | CMD_LEVEL_5,
    MIN_LEVEL_5 = CMD_LEVEL_5
};

static gPlayer_Admin[MAX_PLAYERS char];

public OnFilterScriptInit()
{
    // set as 2nd parameter in CMD_SetFlags function
    // the appropriate constant for the minimum admin level that can use the certain command
    // non-admin commands are by default 0 (no flags)

    // admins with level 1+ can use these:
    CMD_SetFlags("acmds", MIN_LEVEL_1);
    CMD_SetFlags("god", MIN_LEVEL_1);
	
    // admins with level 2+ can use these:
    CMD_SetFlags("explode", MIN_LEVEL_2);
    CMD_SetFlags("kick", MIN_LEVEL_2);
    CMD_SetFlags("mute", MIN_LEVEL_2);
	
    // admins with level 3+ can use these:
    CMD_SetFlags("ban", MIN_LEVEL_3);
	
    // admins with level 4+ can use these:
    CMD_SetFlags("unban", MIN_LEVEL_4);
	
    // admins with level 5+ can use these:
    CMD_SetFlags("setlevel", MIN_LEVEL_5);
    CMD_SetFlags("setcmdflags", MIN_LEVEL_5);
    return 1;
}

//-----------------------------------------------------

public OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
    if (flags)
    {
        // RCON admins can use any command
        if (IsPlayerAdmin(playerid)) return 1;

        new level = gPlayer_Admin{playerid};

        // if it is an admin command and the player is not an admin or their level is not enough to access the command
        // it will return an error and won't execute the command.
        if (!level || !(flags & (2 << (--level))))
        {
            SendClientMessage(playerid, 0xFF0000FF, "SERVER: You are not authorized to use this command.");
            return 0;
        }
    }
    return 1;
}

//-----------------------------------------------------
//                  	LEVEL 0
//-----------------------------------------------------

CMD:admins(playerid, params[])
{
    SendClientMessage(playerid, -1, "admins");
    return 1;
}

CMD:cmds(playerid, params[])
{
    new i, buffer[32];
    static cmd_list[32]; // the more non-admin commands you add, the bigger the size must be

    cmd_list[0] = EOS;

    while (GetPublicName(i, buffer))
    {
        if (!strcmp(buffer, "cmd_", false, 4) && !CMD_GetFlags(buffer[4]))
        {
            buffer[2] = '\n';
            buffer[3] = '/';
            strcat(cmd_list, buffer[2]);
        }
        i++;
    }
    
    ShowPlayerDialog(playerid, 483, DIALOG_STYLE_LIST, "Commands", cmd_list, "Close", "");
    return 1;
}

CMD:goto(playerid, params[])
{
    SendClientMessage(playerid, -1, "goto");
    return 1;
}

CMD:v(playerid, params[])
{
    SendClientMessage(playerid, -1, "v");
    return 1;
}

CMD:weapons(playerid, params[])
{
    SendClientMessage(playerid, -1, "weapons");
    return 1;
}

//-----------------------------------------------------
//                  	LEVEL 1
//-----------------------------------------------------

CMD:acmds(playerid, params[])
{
    new i, buffer[32], lvl;
    static cmd_list[55]; // the more admin commands you add, the bigger the size must be

    // if the player is RCON admin will have access to all admin commands
    // otherwise only to those that are less or equal to their level
    if (IsPlayerAdmin(playerid)) lvl = CMD_LEVEL_5;
    else lvl = 2 << (gPlayer_Admin{playerid} - 1);
	
    cmd_list[0] = EOS;

    while (GetPublicName(i, buffer))
    {
        if (!strcmp(buffer, "cmd_", false, 4) && (CMD_GetFlags(buffer[4]) & lvl))
        {
            buffer[2] = '\n';
            buffer[3] = '/';
            strcat(cmd_list, buffer[2]);
        }
        i++;
    }
    
    ShowPlayerDialog(playerid, 483, DIALOG_STYLE_LIST, "Admin Commands", cmd_list, "Close", "");
    return 1;
}

CMD:god(playerid, params[])
{
    SendClientMessage(playerid, -1, "god");
    return 1;
}

//-----------------------------------------------------
//                  	LEVEL 2
//-----------------------------------------------------

CMD:explode(playerid, params[])
{
    SendClientMessage(playerid, -1, "explode");
    return 1;
}

CMD:kick(playerid, params[])
{
    SendClientMessage(playerid, -1, "kick");
    return 1;
}

CMD:mute(playerid, params[])
{
    SendClientMessage(playerid, -1, "mute");
    return 1;
}

//-----------------------------------------------------
//                  	LEVEL 3
//-----------------------------------------------------

CMD:ban(playerid, params[])
{
    SendClientMessage(playerid, -1, "ban");
    return 1;
}

//-----------------------------------------------------
//                  	LEVEL 4
//-----------------------------------------------------

CMD:unban(playerid, params[])
{
    SendClientMessage(playerid, -1, "unban");
    return 1;
}

//-----------------------------------------------------
//                  	LEVEL 5
//-----------------------------------------------------

/*
    it sets what will be the minimum admin level for a certain command
    it will be only temporary (until the mode/script exits or restarted/reloaded)    
*/
CMD:setcmdflags(playerid, params[])
{
    new cmd[28], lvl;
	
    if (sscanf(params, "s[28]i", cmd, lvl)) return SendClientMessage(playerid, -1, "Usage: /setcmdflags <command (in lower-case)> <level>");
    if (!CMD_Exists(cmd)) return SendClientMessage(playerid, -1, "Error: This command does not exist.");
    if (!(0 <= lvl <= 5)) return SendClientMessage(playerid, -1, "Error: Out of range; level must be between 0 and 5.");
	
    new flags;
	
    switch (lvl)
    {
        case 0: flags = MIN_LEVEL_0;
        case 1: flags = MIN_LEVEL_1;
        case 2: flags = MIN_LEVEL_2;
        case 3: flags = MIN_LEVEL_3;
        case 4: flags = MIN_LEVEL_4;
        case 5: flags = MIN_LEVEL_5;
    }

    CMD_SetFlags(cmd, flags);
    return 1;
}

CMD:setlevel(playerid, params[])
{
    SendClientMessage(playerid, -1, "setlevel");
    return 1;
}

//-----------------------------------------------------

// By Nero_3D
GetPublicName(idx, buffer[32])
{
    if (idx >= 0)
    {
        new publics, natives;
        
        #emit lctrl 1
        #emit const.alt 32
        #emit sub.alt
        #emit stor.s.pri publics
        #emit add.c 4
        #emit stor.s.pri natives

        #emit lref.s.pri natives
        #emit stor.s.pri natives

        #emit lref.s.pri publics
        #emit load.s.alt idx
        #emit shl.c.alt 3
        #emit add
        #emit stor.s.pri publics

        if (publics < natives)
        {
            #emit lctrl 1
            #emit move.alt
            #emit load.s.pri publics
            #emit add.c 4
            #emit sub
            #emit stor.s.pri publics
            #emit lref.s.pri publics
            #emit sub
            #emit stor.s.pri natives

            for (idx = 0; ; natives += 4)
            {
                #emit lref.s.pri natives
                #emit stor.s.pri publics

                if ((buffer[idx++] = publics & 0xFF) == EOS || (buffer[idx++] = publics >> 8 & 0xFF) == EOS || (buffer[idx++] = publics >> 16 & 0xFF) == EOS || (buffer[idx++] = publics >>> 24) == EOS)
                {
                    return idx;
                }
            }
        }
    }
    return 0;
}
