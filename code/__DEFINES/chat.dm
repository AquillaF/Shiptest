/**
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

#define MESSAGE_TYPE_SYSTEM "system"
#define MESSAGE_TYPE_LOCALCHAT "localchat"
#define MESSAGE_TYPE_RADIO "radio"
#define MESSAGE_TYPE_INFO "info"
#define MESSAGE_TYPE_WARNING "warning"
#define MESSAGE_TYPE_DEADCHAT "deadchat"
#define MESSAGE_TYPE_OOC "ooc"
#define MESSAGE_TYPE_LOOC "looc"
#define MESSAGE_TYPE_ADMINPM "adminpm"
#define MESSAGE_TYPE_COMBAT "combat"
#define MESSAGE_TYPE_ADMINCHAT "adminchat"
#define MESSAGE_TYPE_MENTORCHAT "mentorchat"
#define MESSAGE_TYPE_EVENTCHAT "eventchat"
#define MESSAGE_TYPE_ADMINLOG "adminlog"
#define MESSAGE_TYPE_ATTACKLOG "attacklog"
#define MESSAGE_TYPE_DEBUG "debug"

//debug printing macros (for development and testing)
/// Used for debug messages to the world
#define debug2_world(msg) if (GLOB.Debug2) to_chat(world, \
	type = MESSAGE_TYPE_DEBUG, \
	text = "DEBUG: [msg]")
/// Used for debug messages to the player
#define debug2_usr(msg) if (GLOB.Debug2&&usr) to_chat(usr, \
	type = MESSAGE_TYPE_DEBUG, \
	text = "DEBUG: [msg]")
/// Used for debug messages to the admins
#define debug2_admins(msg) if (GLOB.Debug2) to_chat(GLOB.admins, \
	type = MESSAGE_TYPE_DEBUG, \
	text = "DEBUG: [msg]")
/// Used for debug messages to the server
#define debug2_world_log(msg) if (GLOB.Debug2) log_world("DEBUG: [msg]")
/// Adds a generic box around whatever message you're sending in chat. Really makes things stand out.
#define boxed_message(str) ("<div class='boxed_message'>" + str + "</div>")
/// Adds a box around whatever message you're sending in chat. Can apply color and/or additional classes. Available colors: red, green, blue, purple. Use it like red_box
#define custom_boxed_message(classes, str) ("<div class='boxed_message " + classes + "'>" + str + "</div>")
/// Makes a fieldset with a neaty styled name. Can apply additional classes.
#define fieldset_block(title, content, classes) ("<fieldset class='fieldset " + classes + "'><legend class='fieldset_legend'>" + title + "</legend>" + content + "</fieldset>")
