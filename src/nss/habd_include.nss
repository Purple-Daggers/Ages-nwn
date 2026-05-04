// Henchmen Always Bleed to Death v1.1
// By Demetrious, OldManWhistler, and IntrepidCW
// (OldManWhistler did the original main hard work)
//
// http://nwvault.ign.com/Files/scripts/data/1098019141000.shtml
//
// This file contains:
// - description
// - installation information
// - configuration settings
// - global constants
// - common functions

/*
Noobs read there:
This System is modified via constants, after modyfind the constants ... :
Always recompile your module after modifying habd_include because it is an include file.
#1: Select "Build" from the toolset menu and then choose "Build Module".
#2: Click the "Advanced Controls" box to bring up the advanced options.
#3: Make sure that the only boxes that are selected are "Compile" and "Scripts".
#4: Click the "Build" button.
#5: Remember to always make sure you are using the options you want to use when running "Build Module"!
*/

/*
INTRODUCTION

From the same fools who brought you PHB Familiars and UMD by the book, Supply Based
Resting, Party Loot Notification, Permanent Area Effect Spells, Speed Override,
Take Cover (PHB environment AC) and PHB Movement Skills (Balance, Climb, Jump,
Swim, Escape Artist).

The main intent of this system is that players never instantly die (configurable). Player death
will always be caused by player action -- because help didn't reach them in time
and never because of a bad roll of the dice. They will always go through bleeding
before reaching death. There are stabilization checks (configurable 10% chance)
and bandages can bring you back to life on a DC 15 heal skill check as per PHB,
except that when stabilized you instantly go to 1 HP.

One of the unfortunate side effect of playing a real-time game rather than a
turn-based game is that it can be very difficult to react to a player bleeding
in a timely matter. In turn-based play, your party members would know that you
are bleeding and be able to react within one or two round. This system seeks to
restore the ability for your party members to be aware and react.

With the default settings of this system it should be very rare for low level
players to die if they have party members with them for support. Once they reach
higher levels and have the means to afford Resurrection and Raise Dead then the
time to bleed to death decreases. The intention is to make death a rare
occurrence. After all, with all those local clerics tossing out rez like candy,
its any wonder there's still undead around left to fight.

The bleed/death system is intended for multiplayer use but CAN be used in solo
play. The respawn system is intended for multiplayer use only but can be used
for single party if the auto-raise feature is enabled. The auto-raise feature
can be configured to use up scrolls. The respawn system can be disabled or
easily replaced with a different system.

This system was originally built with single-party DMed play in mind, but it
should be able to scale to ANY kind of play. This is the Swiss Army knife of
death systems. The same bleeding/death/respawn system can be used for henchmen
AS WELL as players, removing additional complexity from your module.

If you want to support solo play with this script, then enable the fast
bleed option and set the solo auto-raise option to a very low value. That way
when a player bleeds/dies in solo play they do not have to wait long for help
that will never come.

Finally, the system can be configured in a short time to fit your needs.
Respawned PCs can be moved to a predefined waypoint, you can also use the
bindstone system implemented. HPs can be fully managed by the HABD. Finally you
have some tools to use some sort of 'Hell/Heaven' areas in your module.

THANKS
- HCR team, at one time or another we must have stolen some of your ideas.
- Lazybones for coming up with a name for the system.
- Typhonius, DickNervous, Feds, Ochobee and Blewz for help with the initial play-testing.
- Giantkin for help with betatesting.

Apologies to anyone who is suffering, or knows someone who suffers with a
hereditary blood-coagulation disorder and takes offense at the name. We thought
it was a rather witty name for a system where players must always go through
bleeding before dying. No offense was intended.

OTHER WORKS BY SAME AUTHORS

Demetrious' Portfolio
http://nwvault.ign.com/portfolios/data/1055729301.shtml

OldManWhistler's Portfolio
http://nwvault.ign.com/portfolios/data/1054937958.shtml

IntrepidCW Portfolio
http://nwvault.ign.com/portfolios/data/1081928501.shtml


FEATURES

IMPLEMENTATION NOTES

- Basics: 5 scripts, 3 player items, 2 DM items, 1 placeable. Some optional
premade objects (2NPC, 3 Conversations, 1 Placeable, 1 Waypoint, 1 Trigger).
The only NWN content modified is Raise Dead and Resurrection
spells, and the henchmen death scripts should be modified if you want to enable
henchman bleeding/respawn as ghost.
- It uses DelayCommand events scheduled on the players instead of heartbeats.
It only uses CPU cycles when players are bleeding, dying, dead, respawned or
entering/leaving the module. This removes the overhead of searching through the
player list on the heartbeat.
- Delayed commands are rescheduled at the start of a chain to prevent stalled
states when the CPU is overloaded and events start getting dropped.
- DelayCommand is *NOT* a recursive function, so there is no worry about CPU
performance hits.
- All settings are CONST variables that are evaluated at compile time to speed up execution.
- Henchmen only bleed/respawn if they have a master. Potions can be used on
bleeding henchmen as well as any of the normal means of healing another creature.
Henchmen bleeding is implemented by "faking" to 0 to -9 HP bleed with 10 to 0 HP.
FEATURES NOT IMPLEMENTED
- We considered having an option for limiting raising and resurrecting to same
party only (to prevent death penalty griefers) but you cannot invite dead players
to your party so we decided against that.
- We considered storing player location persistently, but all persistent location
systems I have seen require some kind of workaround to store the player location
over a module reset (most common being an additional script in the exit event of
every area). We figured it was better to leave such complexity out of this system
and let the end user choose the persistent location system that is right for their
needs. HOWEVER see the BindStone feature.
- We include an optional kind of bind stone system. It can be also used to bring
persistence to controled locations.
- Our respawn system can easily be removed (changing one line in the configuration) so that you can
replace it with the respawn system of your choice.
- Dropped items are not automatically picked up. Dropping large inventories is
laggy enough without adding additional processing.
- There is no ability to change the settings while the module is running. This
is because all the settings are constants to speed up execution.
- It is not possible to make familiars or animal companions bleed because there
is no scripting command for making them rejoin the party as a familiar/companion.
ITEMS:
- All items are stored under Custom4 in the palette or Chooser. (creatures at
tutorial)
- Automatically given out to players who do not possess them on log in.
- All items have no weight, are worth no money and cannot be sold.
- Items cannot be transferred to other players or dropped.
- There is a Skull item that displays the player's bleed/death/lost XP/lost GP
statistics.
- There is a Bandages item that can stabilize a bleeding player on a DC 15 heal
check or make a respawned ghost follow the player using the bandages.
    (there are advanced bandages that can be sold, are not free, and could be
    placed at stores if you wish).
- There is a Rulebook item that displays how this system is configured for the
module. It displays the penalties as they would currently apply to the PC reading the book.
- There is a DM statistic item that can display the bleed/death/lost XP/lost GP
statistics for an entire party.
- There is a DM force death item that can instant kill players/henchmen without
putting them through the bleeding state. You can tie this in with the prevent
death feature to make death only happen when the DM decides it should.

BLEEDING:
- Works for players as well as henchmen.
- 10% chance of self-stabilization to 1 HP (chance is configurable)
- If going from living to -6 or lower you will be capped at -5 to give you a
good chance to be saved (configurable).
- If going from living to dead you will be set to -6 to -9 HP instead of dying
 (configurable).
- You can declare some areas where death is hard: Mosters will be able to kill you
on a single hit, and you will start bleeding at appropiate number (no -5 limit)
- Free DC15 heal check bandages can be used to stabilize other players to 1 HP.
- Any healing will stabilize another player.
- Casting raise/rez on a bleeding player stabilizes them to 1 HP or more. (It is
a waste of a spell, but it works).
- Immune to damage while bleeding. You have to bleed to death.
- Regeneration items always stabilize players and keep them from ever dying.
(Defaults to leaving regeneration items on the player) It can unequip these items.
- Bleeding players are temporarily made invisible to make monsters change targets.
- Players can be made invisible for a configurable amount of time after bleeding
to give them a chance to heal or run away (default is 1 second).
- Possessed familiars die instead of bleeding.
- First bleed message tells the total time until death.
- Nearby party members are notified of the bleeding player every round, even
number of rounds between bleeding is greater than one.
- All DMs are notified of when players are bleeding/dying. (default on)
- Number of rounds between bleeding is based off of player level. (defaults to
giving low levels a long time between bleeding to reduce the chance of dying
since they can't afford Raise/Rez)
- Fast 1sec bleed when playing solo without a party (configurable). (default off)
- There is an option for preventing player death until they reach a certain
level. (default is 2). The DM Force Instant Death widget can bypass this setting.

DEATH:
- Now you can specify areas (by Resref) where death and bleeding is imposible.
- Now you can specify areas (by Resref) where Instant Death due to a single hit
is allowed.
- Force auto-respawn after being dead for a specified time. (default 3 min)
- Force auto-raise after being dead or respawned for a specific time. (default off)
- Auto-raise can be configured to only work if the player possesses raise dead /
resurrection scrolls that are consumed in the process. If this is enabled then
the dying can never cause raise dead/resurrection scrolls to be dropped or destroyed. (default off)
- Additional force auto-raise timer for solo players only. (default off)
- Henchmen have their own separate auto-respawn and auto-raise timers.
- DMs can bring dead players back to life with no penalty by using a DM heal.

HENCHMEN BLEEDING AND DEATH:
- The same bleeding/death/respawn system can be used for henchmen by modifying
your henchmen OnDeath scripts. Requires two additional lines to your henchmen
scripts and should be compatible with all henchmen AI provided that they use the
NW_ASC_BUSY condition properly.
- Henchmen support does not require any other modifications.

PENALTIES:
- Separate % GP/XP penalties for respawn, raise dead and resurrection.
- XP penalty can be configured to prevent level loss (default no level loss).
- GP penalty can be configured to have a maximum amount to take (default 10,000gp max).
- If dropping/destruction of all gold is enable, then no gold will be lost to the
penalty (since the player drops the items before the penalty is applied).
- There is no penalty for henchmen bleed/death.
- User defined functions called at bleed, respawn, raise and rez that can be
used to apply other penalties without having to go deep into the internals of our code.

ITEM DROPPING ON DEATH:
- Item dropping on player death can be configured as any combination of the
following options. Any options can be configured to do nothing (0), drop item (1)
or destroy item (2). The conditions are evaluated in an order of precedence.
  - Drop nothing. (default)
  - Drop all gold. (this will avoid any GP penalties since gold is dropped before
  penalty applied)
  - Drop equipped left-hand/right-hand items.
  - Drop a random equipped item.
  - Drop the most expensive equipped item.
  - Drop all equipped items.
  - Drop Raise Dead / Resurrection scrolls.
  - Drop a random backpack item.
  - Drop the most expensive backpack item.
  - Drop all backpack items.
- Dropped items are NOT automatically re-equipped or picked up.
- If players forget to pick up items they dropped, they are automatically
reminded every 30 seconds.
- The placeable created to store dropped items is automatically destroyed when it empties.
- If all of the drop settings are disabled then the placeable is not created.
- There is an option to destroy dropped items rather than store them in a placeable.

PERSISTENCE:
- Persistence can be disabled with a flag. (default enabled)
- Persistence only works with a multiplayer server. It has no effect in single
player (no OnClientLeave event in single player). Exception: Using BindStones.
- Statistics to keep track of how many times the player has bled/died in total,
how many times since the server was restarted, and how much gold/XP the player
has lost in total from penalties.
- Persistent DB functions for storing bleed/death/respawn state.
- Auto-respawn and auto-raise timers are stored persistently at various increments.
- Players remain in the same state over module restarts, even with local vault
characters.
- Persistent data is stored with one DB write at OnClientLeave and one DB read
at OnClientEnter. It is very fast with minimal DB size (less than 1kb per player record).
- When bleed/death/respawn is restored at player log in, it does not reapply the
penalties or falsely increment the statistics.

RESPAWN:
- Can be used with other respawn systems (default uses our system)
- Option to disable death GUI to remove respawn. (Default GUI enabled)
- Option to disable respawn button but leave death GUI (Default respawn button enabled)
- Additional system to respawn as a ghost with no player control. (default enabled)
- Using bandages on respawned ghost makes them follow you if you are in the same
party (simulates carrying a corpse).
- Living players can barter with respawned ghosts (simulates search the players
corpse for scrolls, except corpse has a say in what is taken).
- Respawned ghosts cannot be DM moved by shift-click.
- Respawned ghosts cannot be recovered in single player by using the dm_heal console
command. So the respawn state could be used as permanent death in a single player
game by setting the auto-respawn timer to 0.1.
- Permadeath for PWs is supported (requires you to script what leads the player
to permadeath, see the custom permadeath function at script "habd_onpcrespawn";
furthermore you must specify a waypoint in the options there)
- Casting raise or rez brings respawn ghost back to life, but applies raise/rez
penalty on top of respawn penalty.
- DMs can bring the "ghosted" PC back to life by toggling invulnerability (no
penalty). Casting raise or rez also works, but DM heal does not.
- Respawned PCs can be moved to a waypoint or to a BindStone.

*/


// ****************************************************************************
// INSTALLATION
// ****************************************************************************

/*
// If you are unsure of which scripts are currently associated with your module
// event, go to your
// Module Properties and click on the Events tab.
// First import habd_1.erf

// #1: Change your Module OnPlayerDying script to "habd_onpcdying".

// #2: Change your Module OnPlayerDeath script to "habd_onpcdeath".

// #3: Change your Module OnPlayerRespawn script to "habd_onpcrespawn". If you wish
// to use a different respawn system then make sure the HABD_RESPAWN_SCRIPTvariable in
// "habd_include" is set to the script you want to use.

// #4: Add the following line (before the Main statement) to your module
// OnActivateItem, OnClientEnter, OnClientLeave, OnUnAcquiredItem,
// nw_s0_raisdead, nw_s0_resserec scripts:
#include "habd_include"

// #5: Add the following line to your module OnActivateItem script:
if (HABDOnActivateItem(GetItemActivator(), GetItemActivatedTarget(), GetItemActivated()))
return;

// #6: Add the following lines to your module OnClientEnter script:
HABDGetDBOnClientEnter(GetEnteringObject());
DelayCommand(6.0, HABDItemsOnClientEnter(GetEnteringObject()));

// #7: Add the following line to your module OnClientLeave script:
HABDSetDBOnClientLeave(GetName(GetExitingObject()));

// #8: Add the following line to your module OnUnAcquiredItem script:
if (HABDOnUnAcquiredItem(GetModuleItemLostBy(), GetModuleItemLost())) return;

// #9&10 automatic: Modify the spells Resurection and Raise Importing an erf
// If you are using patch 1.62 or up, import the habd_nw_1_64.erf file to replace
// your nw_s0_raisdead and nw_s0_resserec scripts.
//
// For older versions try Importing the habd_nw_1_31.erf file to replace your
// nw_s0_raisdead and nw_s0_resserec scripts with SoU 1.31 compliant ones.

// If you have custom code at these spells, then you need to merge manually:
// (if your code has a return; sentence somewhere, then you should think about
// where you can put the HABDCode)

// #9 manual: Open nw_s0_raisdead. Copy this at the end of the script (before
the last } ):

    // HABD CODE START
    HABDRaiseDeadSpell(oTarget);
    // HABD CODE END


// #10 manual: Open nw_s0_resserec. Copy this at the end of the script (before
the last } ):

    // HABD CODE START
    HABDResurrectionSpell(oTarget);
    // HABD CODE END


// #11.1: Optional, for bleeding/respawning henchmen open up your henchmen OnDeath event scripts (ie: nw_ch_ac7) and add the following line to the top:
#include "habd_include"
// #11.2: Add the following line as the first line inside of the main function.
void main()
{
    // HABD CODE START
    if (HABDMakeHenchmanBleed()) return;
    // HABD CODE END

// #12: Open up "habd_include" and go to the configuration modification section.
// Change the configuration as it suits your needs. Make sure to save the include
// file and recompile your module to ensure that the settings take effect.
// IMPORTANT: Recompile your module scripts!


// #XX: ONLY IF YOU USE AN OLD PATCH. If you are using a patch below 1.64 ...
// Read the FAQ for detailed info, and make sure you change the constants in
// the MISC section (always set HABD_PATCH_PRE1_64 to TRUE)



// Install Notes:
// 1. You can get problems if you are using another script to track hitpoints when these HP are <=0.
//  I encourage you to disable these scripts, and enable the HABD HP Tracking, setting TRUE the
//  configuration constant HABD_MANAGE_HITPOINTS.
// 2. Read the FAQ for more.


See PDF file for additional information.
*/


// ****************************************************************************
// CONFIGURATION - MODIFY THIS SECTION
// ****************************************************************************

// CUSTOM SETTINGS
//
// HABD_CUSTOM_*
// Custom variable that..
//const int HABD_CUSTOM_*


// MISC SETTINGS
//
// HABD_PATCH_PRE1_64
// If you are using a NWN patch below 1.64, mark there as TRUE, otherwise the code could
// suffer an exploit when PCs leave the game possessing a familiar (altough to
// solve the NWN Bug the script is less robust). Default FALSE.
//
// HABD_LEVELUPBLEED_EXPLOIT_KILLS
// There is a exploit, when a PC levels up when bleeding. He is not stabilized
// properly, and he does not die. If this constant is TRUE the PC is killed and
// the DMs alerted. If FALSE it will simply alert DMs and print the note in log.
//
// HABD_FAMILIAR_EXPLOIT
// There is a exploit, PCs can possess their familiar when dying :\, it tends
// to ruin lost dying scripts and provoke strange behaivours. If set to 0, the
// familiar of a PC will always die when starting to bleed. If set to 1, the
// familiar will not die then, he will be able to figth, but if the PC possess
// the familiar it will die and the PC will keep bleeding.
//
// HABD_ITEMSONENTER
// Configure what items are given to players and DMs when entering the module.
// It is a three digit number. Each number is an item, 0 = dont' give the item,
// 1 = give the item.
// First number is the DeathToken, second the bandages, third the HABDRulesItem.
// E.g. "010" = only give the Bandages on enter
//
// HABD_PATCH_PRECURSEDITEMS
// If you are using a NWN patch that does not support Cursed Items (Undroppable)
// , turn it to TRUE, you will need also to do some small changes (read the FAQ)
//
// HABD_SPELL_TRACKING
// HABD can take care of Spell/feat tracking, making sure that the exploit that
// restores feat/spell uses will not happen. This feature will work perfectly
// if you are running NWN patch 1.65 or better. Old patches have Bioware bugs
// that need very complicated workarounds.
// 0: No spell tracking.
// 1: (Recomended) Spell tracking saving at OnClientLeave event. Uses less
//  access to database, but is not crash - proof (do you really want to make it
//  crash proof?).
// 2: Spell tracking will save everytime HABD saves any other data, which can
//  be very often depending or other settings, can be crash-proof.
//
// HABD_USERLANGUAGE
// Default available languages, it translates most messages from english.
// Log messages, some Debug mesages and The Player Rules are not translated.
// 0: English, 1: Spanish.
//object oMod = GetModule();
const int HABD_PATCH_PRE1_64 = FALSE;
const int HABD_LEVELUPBLEED_EXPLOIT_KILLS = TRUE;
const int HABD_FAMILIAR_EXPLOIT = 0;
//string HABD_ITEMSONENTER = GetLocalString (oMod, "HABD_ITEMSONENTER");
const string HABD_ITEMSONENTER = "111";
const int HABD_PATCH_PRECURSEDITEMS = FALSE;
//int HABD_SPELL_TRACKING = GetLocalInt (oMod, "HABD_SPELL_TRACKING");
const int HABD_SPELL_TRACKING = 1;
const int HABD_USERLANGUAGE = 0;


// BLEEDING SETTINGS
//
// HABD_ALLOW_INSTANT_DEATH
// Default False. If TRUE, PCs can die when they go to alive to -10 or less hps in
// a single hit. HABD_NO_DEATH_BEFORE_LEVEL takes preference, soy low level chars
// will be still safe if you wish.
//
// HABD_KILLING_HIT. You can specify a negative number, if the PC descends to
// this number of hps or lower he suffers Instant Death (even if Instant Death
// is deactivated), in this way you can have the normal bleeding but instant
// death happens with very violent blows. If set as 0 it is off, you should
// configure it at -11 or lower if you want to use this feature.
//
// HABD_BLEEDING_START_LIMIT
// If going from living to -6 or lower you will be capped at HABD_BLEEDING_START_LIMIT
// (default -5) to give you a good chance to be saved. Set from -1 to -10.
// Set up to -10 to fully disable the cap (but dont allow instant death).
//
// HABD_PLAY_BLEED_VOICE
// Default: TRUE. If TRUE bleeding characters play a random apropiate voice. If
// FALSE no Voice is played. You can also specify a number from 2 to 100, that
// indicates a percentage chance to play the voices.
//
// HABD_STABILIZATION_DICE
// Determines the dice to be used for stabilization checks. Default 10 = d10.
// 20 = d20, 100 = d100, etc... Dont use a negative or very low value.
//
// HABD_GLOBAL_STABILIZATION_NUMBER
// A d10 (depending of HABD_STABILIZATION_DICE) is rolled each bleeding round,
// if the result is equal or higher than the HABD_GLOBAL_STABILIZATION_NUMBER
// (default 10 for D&D rules), the player  self-stabilizes. Change as you need,
// it must be a number between 0 and 10. Smaller, easier to get stabilized.
//
// HABD_SOLO_STABILIZATION_NUMBER
// As HABD_GLOBAL_STABILIZATION_NUMBER, but it is used (instead of the GLOBAL)
// at SinglePlayer Games, or if there are not more PCs at the server. I suggest
// to make it a bit lesser than Global in PWs.
//
// HABD_NOINPARTY_FAST_BLEED
// If set to TRUE, then players without a party in a server WITH MORE PCs
// (not DMs) playing go through the bleeding stage VERY fast (1 second). They
// will still have the stabilization chances. It does not check if there are PCs
// near. You can specify the time in seconds using a number e.g 2, 3, 4 instead
// of TRUE
//
// HABD_SOLO_FAST_BLEED
// If set to TRUE, then players in a Single player game or alone in the server
// will go through the bleeding stage VERY fast. This is useful for single
// player modules or when people are playing solo in a multiplayer module. They
// will still have the stabilization chances from bleeding to death without
// having to wait such a long time to die. It does not check if there are PCs
// near. You can specify the time in seconds using a number e.g 2, 3, 4 instead
// of TRUE. Default: TRUE.
//
// HABD_NERF_REGENERATION_ITEMS
// Regeneration items will cause the player to never bleed to death. This is
// how AD&D intended them to work. Unfortunately NWN regeneration is VERY Fast,
// that also means that characters with regeneration items will never die with
// this bleeding system. This is why regeneration items should be very rare, yet
// few people set up their campaigns that way.
// If you set this variable to TRUE, it will enable a workaround that unequips
// regeneration items when the player starts bleeding.
//
// HABD_NO_DEATH_BEFORE_LEVEL
// This will turn death off until the players have reached a certain level.
// Players are NEVER notified that this setting is turned on (to prevent abuses).
// From the player's perspective it will always look like they are stabilizing.
//
// HABD_POST_BLEED_INVIS_DUR
// Setting this value greater than 0.0 will give players invisibility for the
// specified period of time after they recover from bleeding. This is to give
// them a chance to heal or run away. Also search HABD_POST_BLEED_CONCEAL_DUR
//
// HABD_ROUNDS_PER_BLEED_*
// These variables are used to set how many rounds it takes to bleed -1 HP
// based on the player level. If you set the value to 0, the player will
// instantly bleed to death. Do not set to a negative value.
//
// HABD_HEAL_SKILL_DC
// DC for Heal Skill when trying to stabilize a PC using the bandages.Default:15
//
// HABD_HEALMINOR_SKILL_DC
// Once failed the Heal check for stabilization, you can get a result higher
// than HABD_HEALMINOR_SKILL_DC, then the PC will be healed up to -1 HP, but
// will be still bleeding. 0 = Disabled.
//
// HABD_ONENTER_INSTANTBLEED
// Default = TRUE. If True, when a bleeding player comes from persistence or if
// has been loged out a long time, bleeding checks are made instantaneous. It
// avoids multiplayer exploits. Set to False if you dont want it.
//
// HABD_ONENTER_INSTANTBLEED_TIME
// On use only if HABD_ONENTER_INSTANTBLEED is TRUE. It enables this feature when
// login out-in a long time. Set to 0.0 and Instant bleed will only happen
// when coming from persistance. NOTE: It is the time per hp left to die, e.g.
// a PC leaving wat -5 hps, can be out -5*15 = 75 seconds. (with deafault 15.0)
//
// HABD_ALONEINAREA_COUPDEGRACE
// If toggled on, a PC bleeding without another PCs in the area, will suffer
// a simulated coup de grace (or aditional attack) from a nearby monster, he
// will die instantly and receive a message. To turn off: FALSE (default)
// To set up, use a number between 1 and 10, it is the chance (using a d10 dice)
// to receive the coup de grace (it happens once when he starts bleeding),
// 10 = 100% .To specify that good alignment creatures will never perform coup
// de grace, use 101 to 110.
// Add 1000 to the number (1000 to 1010 or 1101 to 1110 to specify that this
// rule does not apply when there is only one PC in the server)
// We dont allow D&D fortitude saving throws, because any damage is still applied,
// and it usually drops you to -10.
// Note, Monsters will deal the extra hit even at distance, but within a max
// distance of 50 m
//
// HABD_DELAY_TOHEAL
// If 0.0, when the PC stabilizes it heals to 1 HP in a second. You can configure
// it to take some time. This number is the number of seconds that will take
// each hitpoint to be healed. Don't use more than some seconds, when the player
// logs-in he will be instantly healed.
//
// HABD_HENCHMEN_BLEED
// (default TRUE) If TRUE, the system applies the bleeding rules to the Henchmen,
// if FALSE it will NOT use the HABD Rules (Notes: ExecuteScript can help you to
// mix ondying scripts). If 2 = It will instantly kill bleeding henchmen ;)
// If 3, It will allow instant kill of Henchmen only.
//
// HABD_HENCHMEN_DEATH
// (default TRUE) If TRUE, the system applies the death rules to the Henchmen,
// if FALSE it will NOT use the HABD Rules (Notes: ExecuteScript can help you to
// mix ondeath scripts).
const int HABD_ONENTER_INSTANTBLEED = TRUE;
const float HABD_ONENTER_INSTANTBLEED_TIME = 15.0;
const int HABD_ALONEINAREA_COUPDEGRACE = FALSE;
const int HABD_ALLOW_INSTANT_DEATH = FALSE;
const int HABD_KILLING_HIT = 0;
const int HABD_BLEEDING_START_LIMIT = -5;
const int HABD_HEAL_SKILL_DC = 15;
const int HABD_HEALMINOR_SKILL_DC = 0;
//int HABD_PLAY_BLEED_VOICE = GetLocalInt (oMod, "HABD_PLAY_BLEED_VOICE");
const int HABD_PLAY_BLEED_VOICE = 1;
const int HABD_STABILIZATION_DICE = 10;
const int HABD_GLOBAL_STABILIZATION_NUMBER = 10;
const int HABD_SOLO_STABILIZATION_NUMBER = 10;
const int HABD_NOINPARTY_FAST_BLEED = TRUE;
const int HABD_SOLO_FAST_BLEED = TRUE;
const int HABD_NERF_REGENERATION_ITEMS = TRUE;
const int HABD_NO_DEATH_UNTIL_LEVEL = 4;
//int HABD_NO_DEATH_UNTIL_LEVEL = GetLocalInt (oMod, "HABD_NO_DEATH_UNTIL_LEVEL");
const float HABD_POST_BLEED_INVIS_DUR = 2.0;
//float HABD_POST_BLEED_INVIS_DUR = GetLocalFloat (oMod, "HABD_POST_BLEED_INVIS_DUR");
const float HABD_DELAY_TOHEAL = 0.0;
const int HABD_HENCHMEN_BLEED = TRUE;
const int HABD_HENCHMEN_DEATH = TRUE;
const int HABD_ROUNDS_PER_BLEED_01 = 4;
const int HABD_ROUNDS_PER_BLEED_02 = 4;
const int HABD_ROUNDS_PER_BLEED_03 = 4;
const int HABD_ROUNDS_PER_BLEED_04 = 4;
const int HABD_ROUNDS_PER_BLEED_05 = 4;
const int HABD_ROUNDS_PER_BLEED_06 = 3;
const int HABD_ROUNDS_PER_BLEED_07 = 3;
const int HABD_ROUNDS_PER_BLEED_08 = 3;
const int HABD_ROUNDS_PER_BLEED_09 = 3;
const int HABD_ROUNDS_PER_BLEED_10 = 3;
const int HABD_ROUNDS_PER_BLEED_11 = 2;
const int HABD_ROUNDS_PER_BLEED_12 = 2;
const int HABD_ROUNDS_PER_BLEED_13 = 2;
const int HABD_ROUNDS_PER_BLEED_14 = 2;
const int HABD_ROUNDS_PER_BLEED_15 = 2;
const int HABD_ROUNDS_PER_BLEED_16 = 1;
const int HABD_ROUNDS_PER_BLEED_17 = 1;
const int HABD_ROUNDS_PER_BLEED_18 = 1;
const int HABD_ROUNDS_PER_BLEED_19 = 1;
const int HABD_ROUNDS_PER_BLEED_20 = 1;
// Epic Levels added in HoTU
const int HABD_ROUNDS_PER_BLEED_21 = 1;
const int HABD_ROUNDS_PER_BLEED_22 = 1;
const int HABD_ROUNDS_PER_BLEED_23 = 1;
const int HABD_ROUNDS_PER_BLEED_24 = 1;
const int HABD_ROUNDS_PER_BLEED_25 = 1;
const int HABD_ROUNDS_PER_BLEED_26 = 1;
const int HABD_ROUNDS_PER_BLEED_27 = 1;
const int HABD_ROUNDS_PER_BLEED_28 = 1;
const int HABD_ROUNDS_PER_BLEED_29 = 1;
const int HABD_ROUNDS_PER_BLEED_30 = 1;
const int HABD_ROUNDS_PER_BLEED_31 = 1;
const int HABD_ROUNDS_PER_BLEED_32 = 1;
const int HABD_ROUNDS_PER_BLEED_33 = 1;
const int HABD_ROUNDS_PER_BLEED_34 = 1;
const int HABD_ROUNDS_PER_BLEED_35 = 1;
const int HABD_ROUNDS_PER_BLEED_36 = 1;
const int HABD_ROUNDS_PER_BLEED_37 = 1;
const int HABD_ROUNDS_PER_BLEED_38 = 1;
const int HABD_ROUNDS_PER_BLEED_39 = 1;
const int HABD_ROUNDS_PER_BLEED_40 = 1;


// DM NOTIFICATION SETTINGS
//
// HABD_DM_NOTIFICATION_ON_BLEED
// If TRUE, it will SendMessageToAllDMs when a player bleeds.
// This can generate a lot of spam on the DM channel. It is only intended for
// use with single party games.
//
// HABD_DM_NOTIFICATION_ON_DEATH
// If TRUE, it will SendMessageToAllDMs when a player dies.
//
// HABD_DM_NOTIFICATION_ON_PENALTY
// If TRUE, it will SendMessageToAllDMs when a gets an XP/GP penalty from respawn/raise/rez.
//
// HABD_DM_DISPLAY_STATS_TO_ALL
// If TRUE, using the DM statistics item will display the statistics to all DMs.
// If FALSE, it will display only to the DM using the item.
// Setting it to TRUE is useful when you want to capture such info into your
// DM Client log file.
const int HABD_DM_NOTIFICATION_ON_BLEED = 0;
const int HABD_DM_NOTIFICATION_ON_DEATH = 1;
const int HABD_DM_NOTIFICATION_ON_PENALTY = 1;
const int HABD_DM_DISPLAY_STATS_TO_ALL = 0;
//int HABD_DM_NOTIFICATION_ON_BLEED = GetLocalInt (oMod, "HABD_DM_NOTIFICATION_ON_BLEED");
//int HABD_DM_NOTIFICATION_ON_DEATH = GetLocalInt (oMod, "HABD_DM_NOTIFICATION_ON_DEATH");
//int HABD_DM_NOTIFICATION_ON_PENALTY = GetLocalInt (oMod, "HABD_DM_NOTIFICATION_ON_PENALTY");
//int HABD_DM_DISPLAY_STATS_TO_ALL = GetLocalInt (oMod, "HABD_DM_DISPLAY_STATS_TO_ALL");

// TIMER SETTINGS
//
// All timers start counting from the moment the player dies.
//
// HABD_FORCE_RESPAWN_TIMER (AUTO-RESPAWN)
// HABD_NPC_FORCE_RESPAWN_TIMER (AUTO-RESPAWN)
// Set this to a value greater than 0.0 to force respawn after a certain amount
// of time has lapsed. If players remain lying dead for long enough, they will
// be forced to respawn. Auto-respawn timer must be less than the auto-raise timer
// if the auto-raise timer is enabled.
//
// HABD_FORCE_RAISE_TIMER (AUTO-RAISE)
// HABD_NPC_FORCE_RAISE_TIMER (AUTO-RAISE)
// Set this to a value greater than 0.0 to force raise after a certain amount
// of time has lapsed after death. If players remain lying dead or respawned
// for long enough, they will be forced raised. Autorepawn timer must be
// less than the autoraise timer if the autoraise timer is enabled.
//
// HABD_SOLO_FORCE_RAISE_TIMER (AUTO-RAISE FOR SOLO ONLY)
// Set this to a value greater than 0.0 to force raise solo players after a
// certain amount of time has lapsed after death. If the player remain lying
// dead or respawned for long enough, they will be forced to respawn. It aplies
// to PCs at Solo game or Alone in the Server. Does NOT affect PCs without Party
// in a server with more PCs around.
//
// HABD_RESTART_FORCE_RAISE_TIMER
// If you set it to a value higher than 0.0, when the server restarts everyone
// that logins respawned will be autoraised in this time (if an autoraise timer
// stored in the DataBase was not lesser). If your PC corpse items can be raised
// dont set it to a low value (at least 10 seconds).
//
// HABD_FORCE_RAISE_USES_SCROLLS
// Set this value to TRUE to have force raise consume scrolls. If the player or
// henchmen does not possess any standard raise/rez scrolls then they will not
// be force raised. Note: this will keep raise/rez scrolls from being
// dropped on player death.
//
// HABD_AUTOTIMERS_UPDATE
// When you log out/in any respawn/raise timer is reset... it is not usefull if
// you set long autoraise/respawn timers. If the constant is a number >0 it means
// that we Update the timers each HABD_AUTOTIMERS_UPDATE seconds. Default: 10.
// It should be less than any timer set, and always more than 0. If you set to
// 0 NOtimer will work.
//
// HABD_RESPAWN_IS_RAISE
// If TRUE, when you respawn, you are instantly raised.
const float HABD_FORCE_RESPAWN_TIMER = 300.0;
const float HABD_FORCE_RAISE_TIMER = 0.0;
const float HABD_SOLO_FORCE_RAISE_TIMER = 0.0;
const float HABD_RESTART_FORCE_RAISE_TIMER = 0.0;
const float HABD_NPC_FORCE_RESPAWN_TIMER = 0.0;
const float HABD_NPC_FORCE_RAISE_TIMER = 0.0;
const int HABD_FORCE_RAISE_USES_SCROLLS = FALSE;
const int HABD_AUTOTIMERS_UPDATE = 10;
const int HABD_RESPAWN_IS_RAISE = TRUE;


// PERSISTENCE SETTINGS
//
// Note: If you want to change the way to use the DataBase (to implement NWNX eg)
// modify the functions HABDSaveStringToDB, HABDLoadStringFromDB,
// HABDSaveBSLocationToDB, HABDLoadBSLocationFromDB.
//
// HADB_DB_PERSISTENT
// If set to FALSE, persistent data won't be stored. If you are making a single
// player module, the persistent data won't be stored anyways because the
// OnClientLeave event shuts down the module before it writes to the database.
//
// HABD_DB_NAME
// The name of the database to store the persistent information. If you leave it
// with the default value then the same DB will be used for all modules you run.
// If you want to use different databases for different modules then change the
// name.
//
// HABD_ONENTER_HOSTILEREPUTATION
// Default TRUE, when entering the PC gets reputation 0 (war) with the hostile
// faction. If your use of the hostile faction gets problems from this. Turn to
// FALSE. Or manage de factions with your own code.
//
// HABD_MANAGE_HITPOINTS
// Provides full management (optional, you never know) of hps. If you use it,
// disable any other hp manager script/function.. If you turn it false, only
// critical HP info will be saved and restored... however you could have some
// problems when using with another HP management script.
//
// HABD_BINDSTONE_PERSISTENT
// It will save the Bindstone locations to the DB. It will be very usefull if
// you are using any kind of DM location manager (or using this Bindstone system
// to manage locations). It does NOT restore locations. Read the Respawn options
// also. Really it saves locs to DB and loads them after server restart, for
// respawn purposes mainly. Furthermore, when doing so it will also save all the
// HABD info (hps, state, etc..).
//
// HABD_BINDSTONE_MANAGE_LOCATIONS
// If TRUE, when the PC logsin after a server restart, he will jump to last
// bindstone triggered. It is a limited and optional way to make locations
// persistent. Usefull if you only want to make the players appear in safe or
// controlled places.
//
// HABD_EXPORTCHAR
// If TRUE, every time we save the HABD info to the DB, the player is also
// exported. It improves the system robustness against server crashes. In Single
// Player Games it will be better as FALSE.
//
// HABD_SMART_SAVETODB
// If set to TRUE, information will be saved to DB more often, not only at
// onclientleave event (or bindstone triggering if used). We'll save info to
// db when the PC suffers a state change: bleeding, from bleeding to alive,
// death, respawn, raising... It makes HABD more robust against server crashes.
const int HADB_DB_PERSISTENT = 1;
const string HABD_DB_NAME = "habd_data";
//int HADB_DB_PERSISTENT = GetLocalInt (oMod, "HADB_DB_PERSISTENT");
//string HABD_DB_NAME = GetLocalString (oMod, "HABD_DB_NAME");
const int HABD_ONENTER_HOSTILEREPUTATION = TRUE;
const int HABD_MANAGE_HITPOINTS  = TRUE;
const int HABD_BINDSTONE_PERSISTENT = FALSE;
const int HABD_BINDSTONE_MANAGE_LOCATIONS = FALSE;
const int HABD_EXPORTCHAR = TRUE;
const int HABD_SMART_SAVETODB = TRUE;


// PENALTY SETTINGS
//
// Set values for the respawn/raise/rez penalties.
// The value is a percentage of the total XP to get to the next level or
// the total GP coinage the player possesses. Set a value of 0 if you do not
// want a penalty. Set a value of 100 if you want the player to lose a level or
// to lose all of their GPs.
// If HABD_DROP_GOLD is set to TRUE, then the gold penalties won't do anything
// because gold is dropped before the penalties are applied.
//
// HABD_RESPAWN_*_LOSS
// Penalty for respawning.
//
// HABD_RAISE_*_LOSS
// Penalty for being raised from the dead.
//
// HABD_REZ_*_LOSS
// Penalty for being resurrected.
//
// HABD_NO_LEVEL_LOSS_FROM_XP_PENALTY
// Set this to FALSE to allow XP penalty to cause level loss. If set to TRUE
// then the penalties can cause a player to lose a level.
//
// HABD_MAX_GP_LOSS_FROM_GP_PENALTY
// Set this to a value greater than 0 to set a maximum GP loss. Regardless of
// the percentage penalty they will will only lose a maximum of that amount.
//
// HABD_NO_0PX_FROM_PENALTY
// If set to TRUE, a PC will be lowered to 1px instead of 0px (if it happens),
// it is usefull if you use the fact of having 0 px to identify new players.
const int HABD_RESPAWN_XP_LOSS = 5;
const int HABD_RESPAWN_GP_LOSS = 100;
const int HABD_RAISE_XP_LOSS = 0;
const int HABD_RAISE_GP_LOSS = 0;
const int HABD_REZ_XP_LOSS = 0;
const int HABD_REZ_GP_LOSS = 0;
const int HABD_NO_LEVEL_LOSS_FROM_XP_PENALTY = TRUE;
const int HABD_MAX_GP_LOSS_FROM_GP_PENALTY = 0;
const int HABD_MAX_XP_LOSS_FROM_XP_PENALTY = 1500;
const int HABD_NO_0PX_FROM_PENALTY = TRUE;

// ITEM DROP ON DEATH SETTINGS
//
// Set these constants to 1 if you would like to drop specific things at
// time of death. Set the constant to 2 if you would like to have the dropped item destroyed.
// Plot items are NEVER dropped or destroyed (see HABD_DROP_PLOT_ITEMS).
// There is an order of prescendence to the operations.
//
// Dropped items are NOT automatically repossessed when the player returns
// to life. This is to reduce lag. The placeable that stores the dropped items
// with automatically notify the player if it still contains items and
// self-destructs when it is empty of items.
// More Options: Search constant HABD_BAG_LOOTMESSAGE_FREQ.
//
// HABD_DROP_GOLD
// Drop or destroy all gold the player possesses. This happens before any penalties are
// applied, so the GP penalties will not do anything if this is enabled.
//
// HABD_DROP_WEAPON_SHIELD
// Drop or destroy the items equipped in the left and right hand slots.
//
// HABD_DROP_RANDOM_EQUIPPED
// Drop or destroy a random item from the players inventory on death.
//
// HABD_DROP_MOST_EXPENSIVE_EQUIPPED
// Drop or destroy the most expensive item the player has.
//
// HABD_DROP_EQUIPPED
// Drop or destroy all equipped items (including left and right hand slots).
// This setting overrides HABD_DROP_WEAPON_SHIELD.
//
// HABD_DROP_RAISE_REZ
// Drop or destroy any Raise Dead or Resurrection scrolls in the backpack.
//
// HABD_DROP_RANDOM_BACKPACK
// Drop or destroy a random item from the players inventory on death.
//
// HABD_DROP_MOST_EXPENSIVE_BACKPACK
// Drop or destroy the most expensive item the player has.
//
// HABD_DROP_BACKPACK
// Drop or destroy any items in the backpack (including Raise Dead / Resurrection)
// This setting overrides HABD_DROP_RAISE_REZ.
//
// HABD_DROP_PLOT_ITEMS
// Allows you to drop or destroy Plot Items (altough it could be a bad idea).
// 0-Not drop plot, 1-drop, 2-destroy OR drop.
//
// HABD_DROP_ALLOWED_LOOTERS
// Determines who can loot the death bag. DMs can always loot. 0-Only the death
// PC, 1-The Death PC and the people in his Party, 2-Everybody
//
// 0 - off
// 1 - drop
// 2 - destroy
const int HABD_DROP_GOLD = 0;
const int HABD_DROP_WEAPON_SHIELD = 0;
const int HABD_DROP_RANDOM_EQUIPPED = 0;
const int HABD_DROP_MOST_EXPENSIVE_EQUIPPED = 0;
const int HABD_DROP_EQUIPPED = 0;
const int HABD_DROP_RAISE_REZ = 0;
const int HABD_DROP_RANDOM_BACKPACK = 0;
const int HABD_DROP_MOST_EXPENSIVE_BACKPACK = 0;
const int HABD_DROP_BACKPACK = 0;
const int HABD_DROP_PLOT_ITEMS = 0;
const int HABD_DROP_ALLOWED_LOOTERS = 0;


// RESPAWN SETTINGS:
//
// HABD_RESPAWN_SCRIPT
// This is the script called when respawn is forced. It should be the same
// script as in your module OnPlayerRespawn script. Change this value if you
// want to use the auto-respawn feature with a different respawn system.
//
// HABD_RESPAWN_ALLOWED
// Set this to FALSE to turn off the death GUI. Players will lie there dead
// until someone raises them.
//
// HABD_INSTANT_RESPAWN_ALLOWED
// Set this to FALSE to turn off the respawn option in death GUI (if the death
// GUI is enabled).
//
// HABD_HENCHMEN_GHOST_RESPAWN
// Set this to TRUE to allow henchmen to respawn as ghosts the same way players
// do. If set to FALSE, it will perform the default henchmen death code of
// whatever henchmen AI you are using.
//
// HABD_RESPAWNPOINT
// The player will respawn at the WAYPOINT of the specified TAG. Default = "",
// it means no movement, will respawn at the death point, if you place the
// waypoint and introduce the Tag, the PC will jump to the waypoint when respawn.
// Usefull to make Purgatoriums, hells etc...if you want to make a difference
// based on alignments, you should use an intermediate area. Note that respawned
// PCs are not alive until resurrected.
// It is ignored when the BindStone system is working.
//
// HABD_JUMPTORESPAWNPOINT_FIRST_ONENTER
// It specifies, that, if you come from a server restart or crash (not a simple
// logout/login) as respawned, you must be mjoved to the respawnPoint or not.
// Disable it if you use a fine alternative location manager. DEfault: TRUE.
//
// HABD_GHOST_EFFECTS_ON
// It turns on (TRUE) off (FALSE) some ghost visual and mechanic effects: PlotFag,
// , sanctuary, and VFX. Turn off has sense if you transport the respawned PC to
// a 'hell'. Notes: they are still ignored by hostiles; they can be still
// selected to follow a PC, but they will not jump to another area in this way
// (exploit safe). Default TRUE.
//
// HABD_GHOST_COMMANDABLE
// It makes the player ghost Uncommandable (cannot be moved by the player) (false)
// or commandable (true). Default FALSE.
//
// HABD_HENCHMEN_NO_RAISE
// If FALSE, Henchmen can be raised using the HABD Rules. Otherwise they dont.
// (usefull if you are using another Henchmen system)
//
// HABD_PERMADEATH_LOCATION
// A PERMADEATH (permanent death) player will respawn at the WAYPOINT of the
// specified TAG. Default = "", it means no movement, will respawn at the
// death point, if you place the waypoint and introduce the Tag, the PC will
// jump to the waypoint when Permadeath takes place.
// To configure the permadeath, see the permadeath custom function
// HABDUserDefinedPermadeath in the script habd_onpcrespawn
//
// HABD_AUTORAISE_WAYPOINT
// If you introduce a waypoint tag, a PC that raises due to the AutoRespawn
// feature, will be moved to the waypoint. Default: "" (no jumping)
//
// HABD_RESPAWN_PCDEADCLON
// (Default TRUE) If set to TRUE, a beatifull and dead clon of the PC will be
// created at the location of the PC when he pressed the respawn button. The
// clon is not selectable or destroyable. Using Tabulator players can read the
// clon name (pc name).
// The Clon will only appear if there is a death bag with drop items or a corpse
// item inside, however, and will be destroyed when the death bag is destroyed.
// If you set if to TRUE I counsel you to change the HABD Death Bag appearance
// to an invisible object, both things will result in an cool visual effect.
// If you are using an Old Patch this function will not work, because the
// the function CopyObject could not work (in this case set to FALSE and delete
// code displaying errors).
//
// HABD_DROP_CORPSE_ITEM
// If set to TRUE, a Corpse item will be dropped to the loot bag (if no loot
// bag it will try to create a new one). The corpse can be raised by a NPC.
//
// HABD_RESTART_DELETE_CORPSES
// If set to TRUE (Recomended, using HABD_RESTART_FORCE_RAISE_TIMER at the same
// time). When the server resets, all the corpse items found in PCs inventories
// that come from persistence will be deleted.
//
// HABD_RAISE_LOGOUT_PLAYERS
// If TRUE, the corpse items cab be used to raise PCs even when they are not
// logged-in in the server! If FALSE, they can only be raised when logged in.
//
// HABD_BINDSTONE_TAG
// Tag of the objects involved in the Bindstone feature (NPCs, placeables,
// triggers and Waypoints). Better dont change this if you want to use the
// premade objects that come with the script.
//
// HABD_BINDSTONE_USEWHENRESPAWNED
// If TRUE, the locations saved by BindStones will be used when the PC respawns
// and he will be moved to the las location binded. Also see the Persistence
// options.
//
// HABD_BINDSTONE_RESPAWNPENALTY
// If TRUE, when a PC respawns, it will use the penalties stored into the
// bindstone waypoint he is transported to. HABD_BINDSTONE_USEWHENRESPAWNED must
// be TRUE also.
// The waypoint will store these % penalties in two integer variables:
// HABD_BINDSTONEWayPoint_XPPENALTY and HABD_BINDSTONEWayPoint_GPPENALTY
// You must edit the variables in the toolset (rigth click in the WP, Variables..)
// If 0: Use default penalties. If <0: Penalty 0%. >0 A % Penalty, e.g. 20 is 20%
// The objects that come with the .erf should have these variables defined, just
// change them. It is an HABD 0.9 feature, old users should replace their waypoints.
//
// HABD_DINAMICRESPAWN1
// It is a Special feature that allows to dinamically change the Respawn
// configuration, when the PC is carrying some special items. The Code provides
// a basic support and a sample system, no Items. To know more details about how
// customizing and using it, read the FAQ.
// If this constant is set to 0, this feature will not work; when set to 1, will
// work, but special items will not be deleted from the PC when respawning; if
// 2, a special item will be deleted when respawning.
//
// HABD_HARDCORE_RESPAWN1
// It is a Special feature that will make harder the configured respawn settings
// when a particular condition is met. When the condition is met, the player
// cannot benefit from autoraising or rainsing when respawning, and must be
// raised by another PC or DM (if enabled).
// IT IS NOT PERMADEATH (for Permadeath read HABD_PERMADEATH_LOCATION info).
// The condition must be scripted at function HABDHardCoreRespawn in
// "habd_include", altough it uses a preset one if not customized. Read the FAQ
// for more info. You must first set this constant to TRUE (default FALSE = off).
const string HABD_RESPAWN_SCRIPT = "_tc_habdrespawn";
const int HABD_RESPAWN_ALLOWED = TRUE;
const int HABD_INSTANT_RESPAWN_ALLOWED = TRUE;
const int HABD_HENCHMEN_GHOST_RESPAWN = FALSE;
const string HABD_RESPAWNPOINT = "WP_TheMorgue";
const int HABD_JUMPTORESPAWNPOINT_FIRST_ONENTER = FALSE;
const int HABD_GHOST_EFFECTS_ON = FALSE;
const int HABD_GHOST_COMMANDABLE = FALSE;
const int HABD_HENCHMEN_NO_RAISE = FALSE;
const string HABD_PERMADEATH_LOCATION = "";
const string HABD_AUTORAISE_WAYPOINT = "WP_TheMorgue";
const int HABD_RESPAWN_PCDEADCLON = FALSE;
const int HABD_DROP_CORPSE_ITEM = FALSE;
const int HABD_RESTART_DELETE_CORPSES = FALSE;
const int HABD_RAISE_LOGOUT_PLAYERS = TRUE;
// BindStone Configuration.
const string HABD_BINDSTONE_TAG = "HABD_BindStone_UtilsObject"; //better dont change the Tag
const int HABD_BINDSTONE_USEWHENRESPAWNED = FALSE;
const int HABD_BINDSTONE_RESPAWNPENALTY = FALSE;
//Special Configuration.
const int HABD_DINAMICRESPAWN1 = 1;
const int HABD_HARDCORE_RESPAWN1 = FALSE;


// SAFE AREAS SETTINGS:
// HABD_SAFEAREA_RESREF_*
// It allows you to specify some areas were you can't death or bleed.
// It is intended to help you make 'heavens' and 'hells' for death players.
// There you must specify the RESREFs of the areas.
// You can set up to 10 areas. If you need more, add more constants and modify
// the function HABD_GetIsSafeArea().
// IMPORTANT: Start writing in the first constant, otherwise it will not check
// the following areas.
const string HABD_SAFEAREA_RESREF_1 ="";
const string HABD_SAFEAREA_RESREF_2 ="";
const string HABD_SAFEAREA_RESREF_3 ="";
const string HABD_SAFEAREA_RESREF_4 ="";
const string HABD_SAFEAREA_RESREF_5 ="";
const string HABD_SAFEAREA_RESREF_6 ="";
const string HABD_SAFEAREA_RESREF_7 ="";
const string HABD_SAFEAREA_RESREF_8 ="";
const string HABD_SAFEAREA_RESREF_9 ="";
const string HABD_SAFEAREA_RESREF_10 ="";


// HARD AREAS SETTINGS:     (buwahaha)
// HABD_HARDAREA_RESREF_*
// If you enable the usual cap and disable Instant Death for all the module,
// maybe you still want to make some areas more frigthening. There you can
// specify the ResRefs of the areas that will be Hard (eg use with the villains
// base). In a hard area the bleeding cap is -9, and Instant Death is allowed.
// You can set up to 20 areas. If you need more, add more constants and modify
// the function HABD_GetIsHardArea(). Note: It will kill even PCs of low level
// that shouldnt die (HABD_NO_DEATH_BEFORE_LEVEL is ignored)
// IMPORTANT: Start writing in the first constant, otherwise it will not check
// the following areas.
const string HABD_HARDAREA_RESREF_1 ="";
const string HABD_HARDAREA_RESREF_2 ="";
const string HABD_HARDAREA_RESREF_3 ="";
const string HABD_HARDAREA_RESREF_4 ="";
const string HABD_HARDAREA_RESREF_5 ="";
const string HABD_HARDAREA_RESREF_6 ="";
const string HABD_HARDAREA_RESREF_7 ="";
const string HABD_HARDAREA_RESREF_8 ="";
const string HABD_HARDAREA_RESREF_9 ="";
const string HABD_HARDAREA_RESREF_10 ="";
const string HABD_HARDAREA_RESREF_11 ="";
const string HABD_HARDAREA_RESREF_12 ="";
const string HABD_HARDAREA_RESREF_13 ="";
const string HABD_HARDAREA_RESREF_14 ="";
const string HABD_HARDAREA_RESREF_15 ="";
const string HABD_HARDAREA_RESREF_16 ="";
const string HABD_HARDAREA_RESREF_17 ="";
const string HABD_HARDAREA_RESREF_18 ="";
const string HABD_HARDAREA_RESREF_19 ="";
const string HABD_HARDAREA_RESREF_20 ="";


// USER DEFINED FUNCTIONS:
// Modify these following functions to add additional status penalties, hooks
// into other systems, or whatever you want. They will be called on the Bleed,
// Respawn, Raise and Resurrection events. IMPORTANT: Do not give CON penalties
// on any events which would have the player at 1 HP (bleeding or raise) because
// you will just make them start bleeding again if their CON goes to a negative
// value.
//
// HABD_USERDEFINED_*_DESC
// If these strings have a value, then the information will be sent to the
// player when the event happens. This description will also be displayed in the
// death rulebook.
//
// HABDUserDefinedBleed() - Called after a player starts bleeding.
// HABDUserDefinedRespawn() - Called after a player respawns with the HABD
//                            respawn system. Not called with other respawn systems.
// HABDUserDefinedRaise() - Called when the Raise Dead spell is cast on a dead
//                          or respawned player.
// HABDUserDefinedResurrection() - Called when the Resurrection spell is cast on
//                                 a dead or respawned player.
string HABD_USERDEFINED_BLEED_DESC = "";
void HABDUserDefinedBleed()
{
    if (HABD_USERDEFINED_BLEED_DESC != "") SendMessageToPC(OBJECT_SELF, "HABD_BLEED: "+HABD_USERDEFINED_BLEED_DESC);
// Do not give the player a CON penalty (by stat penalty or curse effect) after
// stabilizing from bleed since they will only have 1 HP and it will most likely
// just start them bleeding again.
}

string HABD_USERDEFINED_RESPAWN_DESC = "";
void HABDUserDefinedRespawn()
{
    if (HABD_USERDEFINED_RESPAWN_DESC != "") SendMessageToPC(OBJECT_SELF, "HABD_RESPAWN: "+HABD_USERDEFINED_RESPAWN_DESC);
// You may have to toggle the plot flag in order to apply negative effects
// depending on whether or not the negative effect would be prevented by the
// the plot flag.
//  int iPlotFlag = GetPlotFlag(OBJECT_SELF);
//  SetPlotFlag(OBJECT_SELF, FALSE);
    // Apply status effects here
//  SetPlotFlag(OBJECT_SELF, iPlotFlag);
}

string HABD_USERDEFINED_RAISE_DESC = "";
void HABDUserDefinedRaise()
{
    if (HABD_USERDEFINED_RAISE_DESC != "") SendMessageToPC(OBJECT_SELF, "HABD_RAISE: "+HABD_USERDEFINED_RAISE_DESC);
// Do not give the player a CON penalty (by stat penalty or curse effect) after
// they are raised since they will only have 1 HP and it will most likely
// just start them bleeding again.
}

string HABD_USERDEFINED_RESURRECTION_DESC = "";
void HABDUserDefinedResurrection()
{
    if (HABD_USERDEFINED_RESURRECTION_DESC != "") SendMessageToPC(OBJECT_SELF, "HABD_RESURRECTION: "+HABD_USERDEFINED_RESURRECTION_DESC);
}



// END OF CONFIGURATION
// ****************************************************************************
// Modifications below there could be dangerous, not for noobs




// ****************************************************************************
// GLOBALS - DO NOT MODIFY
// ****************************************************************************

// Item tags. We use constants for the item tags to prevent typos.
const string HABD_ITEM_TOKEN = "habd_deathtoken";
const string HABD_ITEM_BANDAGES = "habd_bandages";
const string HABD_ITEM_BANDAGESPLUS2 = "habd_bandages2";
const string HABD_ITEM_BANDAGESPLUS5 = "habd_bandages5";
const string HABD_ITEM_RULES = "habd_rules";
const string HABD_ITEM_DM_TOKEN = "habd_dmtoken";
const string HABD_ITEM_DM_DEATH = "habd_dmdeath";

//Corpse items
const string HABD_CORPSEITEM_FEM_RESREF = "habd_corpsefem";
const string HABD_CORPSEITEM_MALE_RESREF = "habd_corpsemale";

//Special items
//Items Tag Prefix to set respawn options dinamically when placed on PC
//inventory, better dont change this, be sure it is 13 character length.
const string HABD_DINAMICSET_ITEM_PREFIX_TAG = "HABD_DINSETIT";
//Tag of the Item that can be used by the HadCore feature as a "Extra Life".
const string HABD_HARDCORE_RESPAWN_LIFETOKEN_TAG = "HABD_HCRLIFET1";

// Placeable to store dropped items in.
const string HABD_PLACEABLE_BAG = "habd_deathbag";
// How often the bag will check to see if it is empty before destroying itself.
const float HABD_BAG_SELF_DESTRUCT_TIMER = 30.0;
// Modifies how often the Death Bag Message is sent, basically it multiplies HABD_BAG_SELF_DESTRUCT_TIMER.
const int HABD_BAG_LOOTMESSAGE_FREQ  = 2;
// If you dont want the PCs to know who owns the loot bags, set to false.
const int HABD_BAG_SAYSNAMETOPLAYERS = TRUE;

// Similar to Invisibility after stabilization, but applies a 100% concealment
// to avoid any possible problem with true seeing creatures. Note that this
// effect doesnt dissapear when the PC attacks someone, so i dont counsel
// a time higher than 2.0 seconds. Is used the lesser from HABD_POST_BLEED_INVIS_DUR
// and HABD_POST_BLEED_CONCEAL_DUR
const float HABD_POST_BLEED_CONCEAL_DUR = 2.0f;

// List of all resurrection/raise dead scrolls. You can add your own.
const string HABD_SCROLL_TAGS = ":NW_IT_SPDVSCR501:NW_IT_SPSCROL139:NW_IT_SPSCROL141:NW_IT_SPDVSCR702:";

// Player States. These values must all be unique.
const int HABD_STATE_PLAYER_ALIVE = 0;
const int HABD_STATE_PLAYER_BLEEDING = 1;
const int HABD_STATE_RESPAWNED_GHOST = 2;
const int HABD_STATE_PLAYER_DEAD = 3;
const int HABD_STATE_PLAYER_INSTANT_DEATH = 4;
const int HABD_STATE_PC_PERMADEATH = 5;

// Event Signals. Modify if they interfere with your custom signals. Actually
// nof fully implemented.
const int HABD_EVENTDYINGSIGNAL = -11;
const int HABD_EVENTDEATHSIGNAL = -12;


// Campaign database variable. The persistent information will be stored in the
// database with a 32 character variable name that consists of this variable +
// player's Name + character name. We use unique variable names per
// character rather than the built-in unique oPC parameter because oPC is not
// valid in the OnClientLeave event where we store the database.
// Do NOT Use long strings, i counsel no more than 3 chars. It can be empty "".
const string HABD_PERSIST_NAME = "";

// The same but is only used by Locations from BindStones, it should be different
// than HABD_PERSIST_NAME, should not be contained by HABD_PERSIST_NAME (or
// viceversa), it should not have the allowed characters for PlayerNames.
// I suggest things like @#& etc..
// Do NOT Use long strings, i counsel no more than 3 chars.
const string HABD_PERSIST_BINDSTONELOC_NAME = "@?";

// The same but is only used by Spell Tracking Feature, it should be different
// than HABD_PERSIST_NAME, should not be contained by HABD_PERSIST_NAME (or
// viceversa), it should not have the allowed characters for PlayerNames.
// I suggest things like @#& etc..
// Do NOT Use long strings, i counsel no more than 3 chars.
const string HABD_PERSIST_SPELLTRACKING_NAME = "#&";

// Module level local variables.

// Player HP while bleeding.
const string HABD_LAST_HP = "HABDLastHP";
// Player state.
const string HABD_PLAYER_STATE = "HABDPCState";
// Number of times player bled.
const string HABD_BLEED_COUNT = "HABDBleedCnt";
// Number of times player died.
const string HABD_DEATH_COUNT = "HABDDeathCnt";
// Amount of XP lost from the penalties.
const string HABD_LOST_XP_COUNT = "HABDLostXPCnt";
// Amount of GP lost from the penalties.
const string HABD_LOST_GP_COUNT = "HABDLostGPCnt";
// Number of times player bled since module load.
const string HABD_CURRENT_BLEED_COUNT = "HABDCBleedCnt";
// Number of times player died since module load.
const string HABD_CURRENT_DEATH_COUNT = "HABDCDeathCnt";
// Amount of XP lost from the penalties since module load.
const string HABD_CURRENT_LOST_XP_COUNT = "HABDCLostXPCnt";
// Amount of GP lost from the penalties since module load.
const string HABD_CURRENT_LOST_GP_COUNT = "HABDCLostGPCnt";
// 1 if the player was forced to respawn from DB (so that penalty isn't reapplied).
const string HABD_FORCED_RESPAWN = "HABDFRespawn";
// Used to store a local array of the items the player was forced to unequipped
// because the item had the regeneration property.
const string HABD_UNEQUIPED_ITEMS = "HABDUneqdItems";
// Used to track the object the respawned ghost is made to follow.
const string HABD_GHOST_AUTOFOLLOW = "HABDAutofollow";
// Used to prevent updating the statistics when the states are reapplied from the DB.
const string HABD_PERSISTANT_REAPPLY = "HABDPReapply";
// Used to store the player's Name in the OnClientEnter event.
const string HABD_PERSISTANT_ID = "HABDPCID";
// Used to store the player's respawn timer.
const string HABD_RESPAWN_TIMER = "HABDPRespawnT";
// Used to store the player's raise timer.
const string HABD_RAISE_TIMER = "HABDPRaiseT";
// Used to store the player's old relationship with Hostile faction.
const string HABD_OLD_FACTION = "HABDOldF";
// Used to store the player's old relationship with Hostile faction.
const string HABD_OLD_FACTION_SET = "HABDOldFSet";
// Who owns the items in the loot bag?
const string HABD_BAG_PCDEADCLON = "HABDBagPCDeadClon";
// Who owns the items in the loot bag?
const string HABD_BAG_OWNER = "HABDBagOwn";
// Loot bag owner PC name.
const string HABD_BAG_OWNER_NAME = "HABDBagOwnerPCName";
// The name of the Player will be stored in the corpse
const string HABD_CORPSE_OWNER_PLAYERNAME = "HABDCorpseItemOwnerPCPlayerName";
// The name of the PC will be stored in the corpse
const string HABD_CORPSE_OWNER_PCNAME = "HABDCorpseItemOwnerPlayerCharacterName";
// The object ID of the PC corpse is stored in the module, refering the PC.
const string HABD_PC_CORPSE_OBJECT_ID = "HABDPCItemCorpseObjectID";
// Is bleed notification already running?
const string HABD_REPORT_BLEED_RUNNING = "HABDBleedRep";
// Is this a non-PC bleeding?
const string HABD_NPC_BLEED = "HABDNPCB";
// Temporarily store the NPCs master
const string HABD_NPC_MASTER = "HABDNPCM";
// Store the scroll that will be used to bring the player back if
// HABD_FORCE_RAISE_USES_SCROLLS is set to TRUE.
const string HABD_STORED_SCROLL = "HABDSRez";
// Variable to say that the player has stabilized, but he hasnot been healed
// to 1 HP still.
const string HABD_DELAYTOHEAL_CONTROL = "HABDDelayToHealControlVariable";
// Variable that say the real negative hit points the PC was dropped when the
// last death happened. It is only reliable when an Instant Death happens.
// Added for a Permadeath request.
const string HABD_MINHPLASTBLEED = "HABDMinimunHPsLastBleed";
// Used to comunicate functions to determine Attemped targets of NPCs.
const string HABD_AttempedTarget = "HABD_AttempedTargetNPCStop";
// Used to store dinamic Respawning options for PCs, suporting the small dinamic
// respawn feature. PC Object Local Variable.
const string HABD_DINAMIC_OPTION1 = "HABD_DinamicRespawnOptionVariable";
// No Used Variable that will be saved at/loaded from the DataBase to this
// Local Variable. It should be used to save custom states/info for custom
// scripting. The variable stored there can NOT contain a coma ",".
const string HABD_CUSTOM_VAR = "HABDCustomUserPersistentStringVariable";


// Player Level/HitDices while bleeding.It is used to Avoid an Exploit when
// level up while bleeding. PC Local Var.
const string HABD_LAST_LEVEL = "HABDLastPCLevelWhenBleeding";

// Used by OnEnter instant bleed option, for Module local variable. It is
// added as a sufix to player and PC names.
const string HABD_ONENTER_INSTANTBLEED_VAR = "HABD_ONENTER_INSTANTBLEED_LOGINOUT_CONTROLVARNAME";

// The name of the variable placed on the Module, refered to a PC,, used to
// control if the player has entered before in this server session. In order to
// make diference between server restart and client logout/login. Do NOT use it
// outside the function HABDGetDBOnClientEnter().
const string HABD_ONENTER_FIRST_TIME = "HABD_ONENTER_FIRST_TIME_SINCE_SERVER_RESTART";
// PC local variable name. If TRUE, says that the ghost must go to the
// respawn point actually when coming from persistence -optional.
const string HABD_FORCEJUMPTORESPAWNPOINT = "HABD_FORCEJUMPTORESPAWNPOINT_WHENCOMINGFROM_PERSISTENCE";
// PC local variable, says that autoraised must be restored. Actually when we
// log-in as Respawned.
const string HABD_RESTORE_AUTO_RAISE = "HABD_RestoreAutoRaise_WhenLogin";
// PC local variable name. It will store the location from a "Bindstone" that
// will be recalled when respawned.
const string HABD_RESPAWNBS_LOCATION = "HABD_RESPAWNBINDSTONE_LOCATION";

// Variables for individual penalties into BindStone WayPoints (Utils)
// Better dont change them, because it will not change the variables put in the
// toolset!
const string HABD_BINDSTONEWP_XPPENALTY = "HABD_BINDSTONEWayPoint_XPPENALTY";
const string HABD_BINDSTONEWP_GPPENALTY = "HABD_BINDSTONEWayPoint_GPPENALTY";

// Turns on developer debugging information. Should not be used.
const int HABD_DEBUG = FALSE;

// For Debug Purposes. If TRUE, allows Cursed flag Items to be dropped,
// if 2 = allows to be destroyed and dropped
const int HABD_DROP_CURSED_ITEMS = FALSE;
// For Debug (default FALSE).
const int HABD_ALLOW_GHOST_PICKPOCKET = FALSE;

// Allows the use of Export function on morphed shifter players if TRUE;
// default FALSE (suggested).
const int HABD_EXPORT_MORPHED_SHIFTERS = FALSE;

// Enables the default AutoRaising VFX (default 1). To disable 0.
const int HABD_AUTORAISE_VFX = 1;

// The name and version of this script.
const string HABD_VERSION = "Henchmen Always Bleed to Death v1.1 BETA";

// ****************************************************************************
// COMMON FUNCTIONS
// ****************************************************************************

string HABDGetPlayerStateName (object oPC)
{
    int iState = GetLocalInt(GetModule(), HABD_PLAYER_STATE+GetPCPlayerName(oPC)+GetName(oPC));
    string sErrorMsg ="";

    if(HABD_USERLANGUAGE==0)
    switch(iState)
    {
        case HABD_STATE_PLAYER_ALIVE: return "alive";
        case HABD_STATE_PLAYER_BLEEDING: return "bleeding to death";
        case HABD_STATE_RESPAWNED_GHOST: return "respawned as a ghost";
        case HABD_STATE_PLAYER_DEAD: return "dead";
        case HABD_STATE_PLAYER_INSTANT_DEATH: return "instant death";
        case HABD_STATE_PC_PERMADEATH: return "permanent death";
        default: sErrorMsg = "Unknown State "+IntToString(iState); break;
    }

    else if(HABD_USERLANGUAGE==1)
    switch(iState)
    {
        case HABD_STATE_PLAYER_ALIVE: return "vivo";
        case HABD_STATE_PLAYER_BLEEDING: return "muriendo";
        case HABD_STATE_RESPAWNED_GHOST: return "respawnado como fantasma";
        case HABD_STATE_PLAYER_DEAD: return "muerto";
        case HABD_STATE_PLAYER_INSTANT_DEATH: return "muerte instantanea";
        case HABD_STATE_PC_PERMADEATH: return "muerte permanente";
        default: sErrorMsg = "HABD Estado Desconocido "+IntToString(iState); break;
    }

    return sErrorMsg;
}


// ****************************************************************************



// HABDPlayerName will return the Player Name of the Player Character. It will
// work even if the player has logged out, if you have configured HABD properly
// (because it will look into local variables if needed). Return "" if error.
string HABDPlayerName(object ofPC);
string HABDPlayerName(object ofPC)
{
  string sPlayerName = GetPCPlayerName(ofPC);
  if (sPlayerName == "")
    {
    if ( HABD_PATCH_PRE1_64 == FALSE )
        sPlayerName = GetLocalString(ofPC, HABD_PERSISTANT_ID+GetName(ofPC));
        else
            sPlayerName = GetLocalString(GetModule(), HABD_PERSISTANT_ID+GetName(ofPC));
    }
  return sPlayerName;
}
// ****************************************************************************



// Saves the HABD Spell Traking String
void HABDSaveSpellTrackingToDB (string sString, string sPlayerName, string sPCName);

void HABDSaveSpellTrackingToDB (string sString, string sPlayerName, string sPCName)
{
    string sVarName = "";
    sVarName = HABD_PERSIST_SPELLTRACKING_NAME;
    if ( GetStringLength (sPlayerName)>20 )
        sVarName = sVarName + GetStringLeft(sPlayerName,20);
        else
            sVarName = sVarName + sPlayerName;
    sVarName = sVarName + sPCName;
    sVarName = GetStringLeft(sVarName,32);
    SetCampaignString(HABD_DB_NAME, sVarName, sString);
}

// Loads the HABD packed string from the DB.
string HABDLoadSpellTrackingFromDB (string sPlayerName, string sPCName);

string HABDLoadSpellTrackingFromDB (string sPlayerName, string sPCName)
{
    string sVarName = "";
    sVarName = HABD_PERSIST_SPELLTRACKING_NAME;
    if ( GetStringLength (sPlayerName)>20 )
        sVarName = sVarName + GetStringLeft(sPlayerName,20);
        else
            sVarName = sVarName + sPlayerName;
    sVarName = sVarName + sPCName;
    sVarName = GetStringLeft(sVarName,32);
    return GetCampaignString(HABD_DB_NAME, sVarName);
}

//******************************************************************************
// HABDSFTrackFindPreviousLevel
//  Function.     Returns: integer
//  Function used by DBRestoreSpellFeatUsages.
//  CREDITS: Based on Satchmogold "Preventing logout/login exploits" scripts.
//    http://nwvault.ign.com/Files/scripts/data/1071676333666.shtml
int HABDSFTrackFindPreviousLevel (string sVar, string sLevels);
int HABDSFTrackFindPreviousLevel (string sVar, string sLevels)
{
  string sTmp;
  int iPos = FindSubString( sLevels, sVar );
  if ( iPos > -1 )
  {
    iPos += GetStringLength( sVar);
    while ( GetSubString( sLevels, iPos, 1 ) != ";" )
      sTmp += GetSubString( sLevels, iPos++, 1 );
    if ( sTmp != "" )
    {
      return StringToInt( sTmp );
    }
  }
  //else return -100
  return -100;

}   //End of function
//------------------------------------------------------------------------------

//******************************************************************************
// HABDRestoreSpellFeatUses
//  Function.     Input: Object PC.
//  It restores the PC current spell and feat usages.
//  If no Object PC is used, it will use the last entered player.
//  CREDITS: Based on Satchmogold "Preventing logout/login exploits" scripts.
//    http://nwvault.ign.com/Files/scripts/data/1071676333666.shtml
void HABDRestoreSpellFeatUses (object ofPC = OBJECT_INVALID);
void HABDRestoreSpellFeatUses (object ofPC = OBJECT_INVALID)
{
    //if error, or no object PC stated
    if (ofPC == OBJECT_INVALID)
        ofPC = GetEnteringObject();

    //if no error
    if (ofPC != OBJECT_INVALID)
    {

    int index, iLev, iCurLev;

    string sLevels = HABDLoadSpellTrackingFromDB(GetPCPlayerName(ofPC),GetName(ofPC));
    if ( sLevels != "" )
    {
        /*
        //It tracks current hitpoints, but other functions do that
        iCurLev = GetCurrentHitPoints( oPC );
        iLev = FindPreviousLevel( "HP=" );
        if ( iLev > -100 && iCurLev > iLev )
        {
            effect eDamage = EffectDamage( iCurLev - iLev, DAMAGE_TYPE_DIVINE, DAMAGE_POWER_ENERGY );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oPC );
        }
        */

        //Tracks Spells
        for( index = 0; index < 622; index++ )
        {
            iCurLev = GetHasSpell( index, ofPC );
            if ( iCurLev > 0 )
            {
                iLev = HABDSFTrackFindPreviousLevel( "S" + IntToString( index ) + "=" , sLevels );
                if ( iLev == -100 )
                    iLev = 0;
                while ( iLev < iCurLev )
                {
                    DecrementRemainingSpellUses( ofPC, index );
                    iLev++;
                }
            }
        }   //end of for

        //Tracks Feats
        for( index = 0; index < 480; index++ )
        {
            iCurLev = GetHasFeat( index, ofPC );
            if ( iCurLev > 0 )
            {
                iLev = HABDSFTrackFindPreviousLevel( "F" + IntToString( index ) + "=" , sLevels );
                if ( iLev == -100 )
                    iLev = 0;
                while ( iLev < iCurLev )
                {
                    DecrementRemainingFeatUses( ofPC, index );
                    iLev++;
                }
            }
        }   //end of for

    }   //end of if

    }   //end of if

}   //End of function
//------------------------------------------------------------------------------

//******************************************************************************
// HABDSaveSpellFeatUses
//  Function. Input: Object PC
//  It restores the PC current spell and feat usages.
//  CREDITS: Based on Satchmogold "Preventing logout/login exploits" scripts.
//    http://nwvault.ign.com/Files/scripts/data/1071676333666.shtml
void HABDSaveSpellFeatUses (object ofPC = OBJECT_INVALID);
void HABDSaveSpellFeatUses (object ofPC = OBJECT_INVALID)
{
  int index, iLev;
  string sLevels;
  object oPC = GetExitingObject();
  iLev = GetCurrentHitPoints( ofPC );
  sLevels = "HP=" + IntToString( iLev ) + ";";

  for( index = 0; index < 622; index++ )
  {
    iLev = GetHasSpell( index, ofPC );
    if ( iLev > 0 )
      sLevels += "S" + IntToString( index ) + "=" + IntToString( iLev ) + ";";
  }

  for( index = 0; index < 480; index++ )
  {
    iLev = GetHasFeat( index, ofPC );
    if ( iLev > 0 )
      sLevels += "F" + IntToString( index ) + "=" + IntToString( iLev ) + ";";
  }

  string sPlayerName = HABDPlayerName(ofPC);
  if (sPlayerName != "")
  HABDSaveSpellTrackingToDB(sLevels, sPlayerName,GetName(ofPC));

}   //End of function
//------------------------------------------------------------------------------



//******************************************************************************

// Saves the HABD packed string to the DB, if you want to use an alternative DB
// System, as NWNX, you can modify this freely.
// Default: The name for the variable is Prefix + PlayerName (capped to 20 char
// max)+ PCName. Finally it is capped to the 32 char max allowed by the BW DB.
void HABDSaveStringToDB (string sString, string sPlayerName, string sPCName);

void HABDSaveStringToDB (string sString, string sPlayerName, string sPCName)
{
    string sVarName = "";
    sVarName = HABD_PERSIST_NAME;
    if ( GetStringLength (sPlayerName)>20 )
        sVarName = sVarName + GetStringLeft(sPlayerName,20);
        else
            sVarName = sVarName + sPlayerName;
    sVarName = sVarName + sPCName;
    sVarName = GetStringLeft(sVarName,32);
    SetCampaignString(HABD_DB_NAME, sVarName, sString);

    // Save Spell Tracking info
    if (HABD_SPELL_TRACKING>=2) HABDSaveSpellFeatUses(GetExitingObject());
}

// Loads the HABD packed string from the DB.
string HABDLoadStringFromDB (string sPlayerName, string sPCName);

string HABDLoadStringFromDB (string sPlayerName, string sPCName)
{
    string sVarName = "";
    sVarName = HABD_PERSIST_NAME;
    if ( GetStringLength (sPlayerName)>20 )
        sVarName = sVarName + GetStringLeft(sPlayerName,20);
        else
            sVarName = sVarName + sPlayerName;
    sVarName = sVarName + sPCName;
    sVarName = GetStringLeft(sVarName,32);
    return GetCampaignString(HABD_DB_NAME, sVarName);
}

// Saves the HABD BindStone Location to the DB.
void HABDSaveBSLocationToDB (location lLoc, string sPlayerName, string sPCName);

void HABDSaveBSLocationToDB (location lLoc, string sPlayerName, string sPCName)
{
    string sVarName = "";
    sVarName = HABD_PERSIST_BINDSTONELOC_NAME;
    if ( GetStringLength (sPlayerName)>20 )
        sVarName = sVarName + GetStringLeft(sPlayerName,20);
        else
            sVarName = sVarName + sPlayerName;
    sVarName = sVarName + sPCName;
    sVarName = GetStringLeft(sVarName,32);
    SetCampaignLocation(HABD_DB_NAME, sVarName, lLoc);
}

// Loads the HABD BindStone Location from the DB.
location HABDLoadBSLocationFromDB (string sPlayerName, string sPCName);

location HABDLoadBSLocationFromDB (string sPlayerName, string sPCName)
{
    string sVarName = "";
    sVarName = HABD_PERSIST_BINDSTONELOC_NAME;
    if ( GetStringLength (sPlayerName)>20 )
        sVarName = sVarName + GetStringLeft(sPlayerName,20);
        else
            sVarName = sVarName + sPlayerName;
    sVarName = sVarName + sPCName;
    sVarName = GetStringLeft(sVarName,32);
    return GetCampaignLocation(HABD_DB_NAME, sVarName);
}


// ****************************************************************************


// Returns the ith element in a comma-separated-value string. If the element
// does not exist it returns an empty string.
//   sStr - the CSV string.
//   i - the ith element.
string HABDStrTok(string sStr, int i);

string HABDStrTok(string sStr, int i)
{
    int iIndex = 1;
    int iLast = 0;
    int iPos = GetStringLength(sStr);
    int iDelimiter = FindSubString(sStr, ",");
    while (iDelimiter != -1)
    {
        if (iIndex == i) return GetStringLeft(GetStringRight(sStr, iPos), iDelimiter);
        iIndex++;
        iPos = iPos - iDelimiter - 1;
        iDelimiter = FindSubString(GetStringRight(sStr, iPos), ",");
    }
    return "";
}

// ****************************************************************************



// Returns the string value of the Custom-Use persistent Variable of the PC.
// For custom scripting purpose.
string HABDGetCustomVar(object oPC);

string HABDGetCustomVar(object oPC)
{
    object oMod = GetModule();
    string sID = HABDPlayerName(oPC)+GetName(oPC);
    return GetLocalString(oMod, HABD_CUSTOM_VAR+sID);
}
// ****************************************************************************

// Sets the string value of the Custom-Use persistent Variable of the PC.
// The String MUST NOT contain a coma "," or the HABD functions could not work
// properly, this function doesnt check if the string is valid.
// For custom scripting purpose.
void HABDSetCustomVar(object oPC, string value);

void HABDSetCustomVar(object oPC, string value)
{
    object oMod = GetModule();
    string sID = HABDPlayerName(oPC)+GetName(oPC);
    SetLocalString(oMod, HABD_CUSTOM_VAR+sID, value);
}
// ****************************************************************************


// Applies XP/GP penalty to the player. Increments global statistics.
//   oPC - the player to apply the penalty to.
//   iPercXP - percentage of XP to remove (100% = 1 level)
//   iPercGP - percentage of GP to remove (100% = all gold)
void HABDApplyPenalty(object oPC, int iPercXP, int iPercGP);

void HABDApplyPenalty(object oPC, int iPercXP, int iPercGP)
{
    object oMod = GetModule();
    string sID = GetPCPlayerName(oPC)+GetName(oPC);

    // Do nothing if no penalty should be applied.
    if ((iPercXP == 0) && (iPercGP == 0) || (!GetIsPC(oPC))) return;

    int nXP = GetXP(oPC);
    int nPenalty = iPercXP * 10 * GetHitDice(oPC); //1000 = 100% penalty.
    int nHD = GetHitDice(oPC);
    int nMin = ((nHD * (nHD - 1)) / 2) * 1000;

    // Should we prevent the player from losing a level?
    int nNewXP = nXP - nPenalty;
    if (HABD_NO_LEVEL_LOSS_FROM_XP_PENALTY)
    {
        if (nNewXP < nMin) nNewXP = nMin;
    }
    // Should we prevent the player from going to 0 px?
    if (nNewXP == 0)    nNewXP = 1;

    // Should we prevent the player losing more than a MAX XP?
    if (nNewXP > HABD_MAX_XP_LOSS_FROM_XP_PENALTY)    nNewXP = HABD_MAX_XP_LOSS_FROM_XP_PENALTY;

    // Should we limit the amount of gold taken from the player?
    int nGoldToTake = FloatToInt(iPercGP * GetGold(oPC) / 100.0);  //0.75 = 75% of players gold
    if (
        (HABD_MAX_GP_LOSS_FROM_GP_PENALTY > 0) &&
        (nGoldToTake > HABD_MAX_GP_LOSS_FROM_GP_PENALTY)
        )
    {
        nGoldToTake = HABD_MAX_GP_LOSS_FROM_GP_PENALTY;
        if(HABD_USERLANGUAGE==0)
        SendMessageToPC(oPC, "OOC: GP loss has reached maximum cap of "+IntToString(nGoldToTake)+" GP.");
        else if(HABD_USERLANGUAGE==1)
        SendMessageToPC(oPC, "OOC: El oro perdido a llegado a un tope maximo de "+IntToString(nGoldToTake)+" PO.");
    }
    // Increment statistics.
    SetLocalInt(oMod, HABD_LOST_XP_COUNT+sID, GetLocalInt(oMod, HABD_LOST_XP_COUNT+sID)+nXP-nNewXP);
    SetLocalInt(oMod, HABD_LOST_GP_COUNT+sID, GetLocalInt(oMod, HABD_LOST_GP_COUNT+sID)+nGoldToTake);
    SetLocalInt(oMod, HABD_CURRENT_LOST_XP_COUNT+sID, GetLocalInt(oMod, HABD_CURRENT_LOST_XP_COUNT+sID)+nXP-nNewXP);
    SetLocalInt(oMod, HABD_CURRENT_LOST_GP_COUNT+sID, GetLocalInt(oMod, HABD_CURRENT_LOST_GP_COUNT+sID)+nGoldToTake);

    // Apply XP penalty.
    if (nNewXP < nXP) SetXP(oPC, nNewXP);
    else
    {
        if(HABD_USERLANGUAGE==0)
        SendMessageToPC(oPC, "OOC: XP loss has reached minimum cap to prevent level loss.");
        else if(HABD_USERLANGUAGE==1)
        SendMessageToPC(oPC, "OOC: La EXPERIENCIA perdida ha llegado a un tope minimo para prevenir la perdida de nivel.");
        nPenalty = 0;
    }
    // Apply GP penalty.
    AssignCommand(oPC, TakeGoldFromCreature(nGoldToTake, oPC, TRUE));
    // Notification.
    string sMsg;
    if(HABD_USERLANGUAGE==0)
        sMsg = "DEATH PENALTY APPLIED: " +GetName(oPC) + " " + IntToString(nPenalty) + " XP ("+IntToString(iPercXP)+"%), " + IntToString(nGoldToTake) + " GP ("+IntToString(iPercGP)+"%).";
    else if(HABD_USERLANGUAGE==1)
        sMsg = "PENALIZACION por MUERTE Aplicado: " +GetName(oPC) + " " + IntToString(nPenalty) + " PX ("+IntToString(iPercXP)+"%), " + IntToString(nGoldToTake) + " PO ("+IntToString(iPercGP)+"%).";
    if (HABD_DM_NOTIFICATION_ON_PENALTY) SendMessageToAllDMs(sMsg);
    SendMessageToPC(oPC, sMsg);
    return;
}

// ****************************************************************************

// If the player is bleeding, it will stabilize them with no penalties. If the
// player is dead it will restore them to alive state and apply the penalty
// based on the spell used to restore them. This function does not guard against
// casting on living players because the raise/rez spells already do that.
//   oPC - the dead/bleeding player.
//   nSpell - SPELL_RAISE_DEAD or SPELL_RESURRECTION
void HABDApplyPenaltyIfDead(object oPC, int nSpell);

void HABDApplyPenaltyIfDead(object oPC, int nSpell)
{
    object oMod = GetModule();
    string sID = GetPCPlayerName(oPC)+GetName(oPC);
    int iState = GetLocalInt(oMod, HABD_PLAYER_STATE+sID);
    // Check if casting raise/rez on a bleeding player
    if (iState == HABD_STATE_PLAYER_BLEEDING)
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(1), oPC);
        if(HABD_USERLANGUAGE==0)
            FloatingTextStringOnCreature("SUCCESS: stabilized "+GetName(oPC)+".", oPC);
        else if(HABD_USERLANGUAGE==1)
            FloatingTextStringOnCreature("EXITO: estabilizado "+GetName(oPC)+".", oPC);
        return;
    }
    // Set player back to alive, assumed that the player is NOT in the alive
    // state. Otherwise potential exploit of casting on living players to give
    // them penalties.
    if ( iState != HABD_STATE_PLAYER_ALIVE & iState != HABD_STATE_PC_PERMADEATH )
    {
      SetLocalInt(oMod, HABD_PLAYER_STATE+sID, HABD_STATE_PLAYER_ALIVE);
      if (nSpell == SPELL_RAISE_DEAD)
      {
        HABDApplyPenalty(oPC, HABD_RAISE_XP_LOSS, HABD_RAISE_GP_LOSS);
        AssignCommand(oPC, HABDUserDefinedRaise());
      }
      if (nSpell == SPELL_RESURRECTION)
      {
        HABDApplyPenalty(oPC, HABD_REZ_XP_LOSS, HABD_REZ_GP_LOSS);
        AssignCommand(oPC, HABDUserDefinedResurrection());
      }
    }
    //-
}

// ****************************************************************************


// It will return the WayPoint Tag to be used with respawning at a point.
// By default it returns the default WP set at the constants. But you can
// modify this to move players that die in the enemies base to a prison, e.g.
// "i" should be used to know what event called the function (not implemented)
string HABDRespawnWPTag (object oPC, int i=0);

string HABDRespawnWPTag (object oPC, int i=0)
{
    // if (GetResRef(GetArea(oPC)) == "DrEvilBase") return "DrEvilPrisonWPTag";
    return HABD_RESPAWNPOINT;
}

// ****************************************************************************


// It will return the WayPoint Tag to be used with moving at a PERMADEATH point.
// By default it returns the default WP set at the constants. But you can
// modify this to move players that die in the enemies base to the 9thHell, e.g.
// "i" should be used to know what event called the function (not fully
// implemented)
string HABDPermadeathWPTag (object oPC, int i=0);

string HABDPermadeathWPTag (object oPC, int i=0)
{
    // if (GetResRef(GetArea(oPC)) == "DrVeryEvilBase") return "9thHellWPTag";
    // if (GetCustomVar(oPC) == "PermD_HellN4") return "HellN4WPTag";
    // int iState = GetLocalInt(oMod,HABD_PLAYER_STATE+sID);
    // if ( iState == HABD_STATE_PC_PERMADEATH ) {}
    // if (i == HABD_EVENTDEATHSIGNAL)  {}
    // if (i == HABD_EVENTDYINGSIGNAL) {}
    return HABD_PERMADEATH_LOCATION;
}

// ****************************************************************************


// Says if the player is Alone in his AREA: It only counts PCs, not DMs.
// Returns TRUE if he is alone in the Area. False if error or not Alone.
int HABDPlayerAloneInArea(object oPC);

int HABDPlayerAloneInArea(object oPC)
{
    object oArea = GetArea (oPC);
        if (oArea == OBJECT_INVALID)
            return FALSE;
    object foPC = GetFirstObjectInArea();
    int iPlayers = 0;
    while ( foPC!=OBJECT_INVALID & iPlayers<2 )
    {
        if ( GetIsPC(foPC) & GetIsDM(foPC)==FALSE & GetIsDMPossessed(foPC)==FALSE)
            iPlayers = iPlayers +1;
        foPC = GetNextObjectInArea();
    }
    if (iPlayers <= 1)
        return TRUE;
            else return FALSE;
}


// Says if the player is SOLO in the Server: If he is playing a Solo game, or
// if he is alone in the server. It only counts PCs, not DMs.
// Returns TRUE if Solo
int HABDPlayerIsSolo(object oPC);

int HABDPlayerIsSolo(object oPC)
{
    object foPC = GetFirstPC();
    int iPlayers = 0;
    while ( foPC!=OBJECT_INVALID & iPlayers<2 )
    {
        if ( GetIsPC(foPC)  &  GetPCPlayerName(foPC) != "" & GetIsDM(foPC)==FALSE & GetIsDMPossessed(foPC)==FALSE )
            iPlayers = iPlayers +1;
        foPC = GetNextPC();
    }
    if (iPlayers <= 1)
        return TRUE;
            else return FALSE;
}

// ****************************************************************************

// Returns the party size of oPC's party. Party size does not include non-PCs.
int HABDGetPartySize(object oPC);

int HABDGetPartySize(object oPC)
{
    int i = 0;
    object oParty = GetFirstFactionMember(oPC);
    while (GetIsObjectValid(oParty))
    {
        i++;
        oParty = GetNextFactionMember(oPC);
    }
    return (i);
}

// ****************************************************************************



// If the player is alone in the area, it will execute a coup of grace on him
// note that it does not check the Player state, it returns TRUE if the player
// died due to the coup of grace; FALSE if the PC survived.
int HABDCoupDeGraceAloneInArea(object oPC);

int HABDCoupDeGraceAloneInArea(object oPC)
{
    if ( HABDPlayerAloneInArea(oPC) == TRUE & HABD_ALONEINAREA_COUPDEGRACE!=FALSE )
    {
        int coupdegrace = FALSE;
        int goodalignkills = FALSE;
        int chance = HABD_ALONEINAREA_COUPDEGRACE;
        //coup de grace is allowed?
        if ( HABD_ALONEINAREA_COUPDEGRACE > 1000 )
        {
            if ( HABDPlayerIsSolo(oPC) == FALSE )
                coupdegrace = TRUE;
        }
        else
            if ( HABD_ALONEINAREA_COUPDEGRACE != FALSE )
            coupdegrace = TRUE;

        if ( coupdegrace == FALSE)
            return FALSE;

        //should good alignment creatures kill you?
        //what is the chance of get the coup of grace?
        if ( coupdegrace == TRUE)
        {
            if ( HABD_ALONEINAREA_COUPDEGRACE >=1 &  HABD_ALONEINAREA_COUPDEGRACE <=10
                & HABD_ALONEINAREA_COUPDEGRACE >=1001 &  HABD_ALONEINAREA_COUPDEGRACE <=1010
                )
                goodalignkills = TRUE;
            if  (HABD_ALONEINAREA_COUPDEGRACE > 1100)
            {
                chance = HABD_ALONEINAREA_COUPDEGRACE - 1100;
            }
            else
            if  (HABD_ALONEINAREA_COUPDEGRACE > 1000)
            {
                chance = HABD_ALONEINAREA_COUPDEGRACE - 1000;
            }
            else
            if  (HABD_ALONEINAREA_COUPDEGRACE > 100)
            {
                chance = HABD_ALONEINAREA_COUPDEGRACE - 100;
            }
            else
            chance = HABD_ALONEINAREA_COUPDEGRACE;
        }

        //first, roll the chance
        if ( d10()>=chance )
            return FALSE;
        //Now, the PC MUST be killed, if an enemy is near

        //Search the nearest enemy creature in a max 50 meters
        //Note that it must be called before HABD make creatures neutral
        object oKiller = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE,oPC,1,CREATURE_TYPE_REPUTATION,REPUTATION_TYPE_ENEMY);
        if (oKiller == OBJECT_INVALID)
            return FALSE;
        if ( GetAlignmentGoodEvil(oKiller) == ALIGNMENT_GOOD & goodalignkills == FALSE )
            return FALSE;
        float fmeters = GetDistanceBetween(oPC, oKiller);
        if ( fmeters <= 3.0 )
        {
            //play monster animation and return TRUE
            AssignCommand(oKiller, SetFacingPoint(GetPosition(oPC))  );
            AssignCommand(oKiller, PlayAnimation(ANIMATION_FIREFORGET_BOW)  );
            if(HABD_USERLANGUAGE==0)
                SendMessageToPC(oPC, GetName(oKiller)+" executed a coup de grace on you, when you were bleeding, because you had no comrades in the area.");
            else if(HABD_USERLANGUAGE==1)
                SendMessageToPC(oPC, GetName(oKiller)+" ha ejecutado un golpe de gracia sobre ti, cuando estabas desangrandote, por que no tenias nadie que te ayudase en el area.");
            return TRUE;
        }
        else
        if ( fmeters <= 50.0 )
        {
            //play monster animation and return TRUE
            AssignCommand(oKiller, SetFacingPoint(GetPosition(oPC))  );
            AssignCommand(oKiller, PlayAnimation(ANIMATION_FIREFORGET_BOW)  );
            if(HABD_USERLANGUAGE==0)
                SendMessageToPC(oPC, GetName(oKiller)+" hit you with a ranged weapon, with the intention to kill you definitively, when you were bleeding, because you had no comrades in the area.");
            else if(HABD_USERLANGUAGE==1)
                SendMessageToPC(oPC, GetName(oKiller)+" te golpeo con un arma a distancia, con la intencion de rematarte, cuando estabas desangrandote, por que no tenias nadie que te ayudase en el area.");
            return TRUE;
        }
    }
    return FALSE;
}


// ****************************************************************************



// Returns the time interval in seconds that it takes for a player to bleed
// -1 HP.
//   oPC - player to get the bleed duration for.
//   iNotify - if TRUE and the player is solo then they will receive a warning
//             that they are bleeding to death very fast because they do not
//             have a party or are alone in the server.
float HABDGetBleedTimer (object oPC, int iNotify = TRUE);

float HABDGetBleedTimer (object oPC, int iNotify = TRUE)
{
    // Is fast bleeding for players in a Solo Game or alone in the server enabled?
    if (HABD_SOLO_FAST_BLEED >= 1)
    {
        // Is the player in a solo game/alone in the server?
        if (HABDPlayerIsSolo(oPC) == TRUE)
        {
            // Should we warn them?
            if (iNotify == TRUE)
            {
                if(HABD_USERLANGUAGE==0)
                SendMessageToPC(oPC, "OOC: Bleeding to death very fast because there are no more PCs to save you.");
                else if(HABD_USERLANGUAGE==1)
                SendMessageToPC(oPC, "OOC: Desangrandote muy rapido por que no hay mas PJs para salvarte.");
            }
            //returns the bleeding time, for TRUE, it is 1.0
            return (IntToFloat(HABD_SOLO_FAST_BLEED) );
        }
    }

    // Is fast bleeding for players Whitout Party enabled?
    if (HABD_NOINPARTY_FAST_BLEED >= 1 )
    {
        // Is the player solo (whitout party) and there are more PCs in the server?
        if (HABDGetPartySize(oPC) == 1 & HABDPlayerIsSolo(oPC) == FALSE)
        {
            // Should we warn them?
            if (iNotify == TRUE)
            {
                if(HABD_USERLANGUAGE==0)
                SendMessageToPC(oPC, "OOC: Bleeding to death very fast because you do not have a party to save you.");
                else if(HABD_USERLANGUAGE==1)
                SendMessageToPC(oPC, "OOC: Desangrandote muy rapido por que no estas en un grupo de PJs que te puedan salvar.");
            }
            //returns the bleeding time, for TRUE, it is 1.0
            return (IntToFloat(HABD_NOINPARTY_FAST_BLEED) );
        }
    }

    // Get the scaled bleed duration based on the player's level.
    int iLevel = GetHitDice(oPC);
    int iRounds = 1;
    switch (iLevel)
    {
        case 01: iRounds = HABD_ROUNDS_PER_BLEED_01; break;
        case 02: iRounds = HABD_ROUNDS_PER_BLEED_02; break;
        case 03: iRounds = HABD_ROUNDS_PER_BLEED_03; break;
        case 04: iRounds = HABD_ROUNDS_PER_BLEED_04; break;
        case 05: iRounds = HABD_ROUNDS_PER_BLEED_05; break;
        case 06: iRounds = HABD_ROUNDS_PER_BLEED_06; break;
        case 07: iRounds = HABD_ROUNDS_PER_BLEED_07; break;
        case 08: iRounds = HABD_ROUNDS_PER_BLEED_08; break;
        case 09: iRounds = HABD_ROUNDS_PER_BLEED_09; break;
        case 10: iRounds = HABD_ROUNDS_PER_BLEED_10; break;
        case 11: iRounds = HABD_ROUNDS_PER_BLEED_11; break;
        case 12: iRounds = HABD_ROUNDS_PER_BLEED_12; break;
        case 13: iRounds = HABD_ROUNDS_PER_BLEED_13; break;
        case 14: iRounds = HABD_ROUNDS_PER_BLEED_14; break;
        case 15: iRounds = HABD_ROUNDS_PER_BLEED_15; break;
        case 16: iRounds = HABD_ROUNDS_PER_BLEED_16; break;
        case 17: iRounds = HABD_ROUNDS_PER_BLEED_17; break;
        case 18: iRounds = HABD_ROUNDS_PER_BLEED_18; break;
        case 19: iRounds = HABD_ROUNDS_PER_BLEED_19; break;
        case 20: iRounds = HABD_ROUNDS_PER_BLEED_20; break;
        case 21: iRounds = HABD_ROUNDS_PER_BLEED_21; break;
        case 22: iRounds = HABD_ROUNDS_PER_BLEED_22; break;
        case 23: iRounds = HABD_ROUNDS_PER_BLEED_23; break;
        case 24: iRounds = HABD_ROUNDS_PER_BLEED_24; break;
        case 25: iRounds = HABD_ROUNDS_PER_BLEED_25; break;
        case 26: iRounds = HABD_ROUNDS_PER_BLEED_26; break;
        case 27: iRounds = HABD_ROUNDS_PER_BLEED_27; break;
        case 28: iRounds = HABD_ROUNDS_PER_BLEED_28; break;
        case 29: iRounds = HABD_ROUNDS_PER_BLEED_29; break;
        case 30: iRounds = HABD_ROUNDS_PER_BLEED_30; break;
        case 31: iRounds = HABD_ROUNDS_PER_BLEED_31; break;
        case 32: iRounds = HABD_ROUNDS_PER_BLEED_32; break;
        case 33: iRounds = HABD_ROUNDS_PER_BLEED_33; break;
        case 34: iRounds = HABD_ROUNDS_PER_BLEED_34; break;
        case 35: iRounds = HABD_ROUNDS_PER_BLEED_35; break;
        case 36: iRounds = HABD_ROUNDS_PER_BLEED_36; break;
        case 37: iRounds = HABD_ROUNDS_PER_BLEED_37; break;
        case 38: iRounds = HABD_ROUNDS_PER_BLEED_38; break;
        case 39: iRounds = HABD_ROUNDS_PER_BLEED_39; break;
        case 40: iRounds = HABD_ROUNDS_PER_BLEED_40; break;
    }
    if (HABD_DEBUG) return (6.0);
    else return (iRounds * 6.0);
}

// ****************************************************************************

//****************************************************************************
/*Says if the PC has levels in the PrC Shifter and is polymorphed (exporting a
PC in this conditions can cause serious problems), if he is a shifter using the
Druid Wild Shape it will return TRUE too. Returns TRUE if Morphed Shifter,
else returns FALSE*/
int IsShifterMorphed(object oPC);

int IsShifterMorphed(object oPC)
{
    effect ef = GetFirstEffect(oPC);
    int iShifter = FALSE;
    if (GetLevelByClass(CLASS_TYPE_SHIFTER,oPC)>0)  //Is Shifter, search the PolyEff
    while( GetEffectType(ef) != EFFECT_TYPE_INVALIDEFFECT && iShifter == FALSE)
    {
        if ( GetEffectType(ef) == EFFECT_TYPE_POLYMORPH
            && GetLevelByClass(CLASS_TYPE_SHIFTER,oPC)>0
            /*&& GetAppearanceType(oPC) <= 6*/)
            iShifter = TRUE;
        ef = GetNextEffect(oPC);
    }
    return iShifter;
}


// ****************************************************************************
// Used to store the information to the persistent DB.
// It will only work properly if the PC is logged in or has fired the
// OnClientLeave Event.
void HABDSetDBString(object oPC, int iLogInfo = FALSE);

void HABDSetDBString(object oPC, int iLogInfo = FALSE)
{
    if (!HADB_DB_PERSISTENT) return;

    object oMod = GetModule();
    // Note: GetPCPlayerName does not function in the OnClientLeave event.
    // So use the player's name to get the shadowed version we stored in the
    // OnClientEnter.
    string sName = GetName(oPC);
    string sID = "";
    string sPlayerName = "";
    sPlayerName = HABDPlayerName(oPC);
    sID = sPlayerName+sName;

    // Hit points, GetCurrentHPs return 0 if error.
    int iHP = 0;
    if (HABD_MANAGE_HITPOINTS == TRUE)
    {
    iHP = GetCurrentHitPoints(GetExitingObject());
    if (iHP <= 0) //if posible error, or negatives we can rely in shadowed variables
        iHP = GetLocalInt(oMod, HABD_LAST_HP+sID);
    }
    else
        iHP = GetLocalInt(oMod, HABD_LAST_HP+sID);

    // avoid critical problems with HABD_DELAYTOHEAL option
    if (GetLocalInt(oMod, HABD_DELAYTOHEAL_CONTROL+sID) == TRUE )
        SetLocalInt(oMod,HABD_PLAYER_STATE+sID, HABD_STATE_PLAYER_ALIVE);

    // Shadow module level variables to local variables.
    int iState = GetLocalInt(oMod, HABD_PLAYER_STATE+sID);
    int iRespawn = GetLocalInt(oMod, HABD_RESPAWN_TIMER+sID);
    int iRaise = GetLocalInt(oMod, HABD_RAISE_TIMER+sID);
    int iDCount = GetLocalInt(oMod, HABD_DEATH_COUNT+sID);
    int iBCount = GetLocalInt(oMod, HABD_BLEED_COUNT+sID);
    int iXCount = GetLocalInt(oMod, HABD_LOST_XP_COUNT+sID);
    int iGCount = GetLocalInt(oMod, HABD_LOST_GP_COUNT+sID);
    string sBindStoneAreaTag = GetTag(GetAreaFromLocation(  GetLocalLocation(oPC, HABD_RESPAWNBS_LOCATION)  ));
    // variables that allow PCs to be raised when logged out, saved as null
    int iCorpseRaise = FALSE;
    int iCorpseSpell = 0;
    int iCorpseNPCGP = 0;
    //Customizable var
    string shabdcustomvar = HABDGetCustomVar(oPC);

    // Pack data into a string to reduce database accesses.
    string sData = IntToString(iDCount)+","+IntToString(iBCount)+","+IntToString(iXCount)+","+IntToString(iGCount)+","+IntToString(iHP)+","+IntToString(iState)+","+IntToString(iRespawn)+","+IntToString(iRaise)+","+sBindStoneAreaTag+","+IntToString(iCorpseRaise)+","+IntToString(iCorpseSpell)+","+IntToString(iCorpseNPCGP)+shabdcustomvar+",0";
    // Database index is limited to 32 characters.
    //SetCampaignString(HABD_DB_NAME, GetStringLeft(HABD_PERSIST_NAME+sID,32), sData);
    // Save to DB
    HABDSaveStringToDB(sData, sPlayerName, sName);

    // Log stuff to the server log for debugging purposes. Remove later if you
    // wish to gain in performance
    if ( iLogInfo == TRUE )
    {
    PrintString("HABD_DB: Storing "+sID+" iHP="+IntToString(iHP)+" iState="+IntToString(iState)+" iRespawnTimer="+IntToString(iRespawn)+" iRaiseTimer="+IntToString(iRaise));
    PrintString("HABD_DB: Storing "+sID+" Death="+IntToString(iDCount)+" Bleed="+IntToString(iBCount)+" XPLost="+IntToString(iXCount)+" GPLost="+IntToString(iGCount));
    PrintString("HABD_DB: Storing "+sID+" "+sData);
    }

    // Save PC sheet
    if (HABD_EXPORTCHAR == TRUE)
      if (GetArea(oPC)!= OBJECT_INVALID && (IsShifterMorphed(oPC)==FALSE || HABD_EXPORT_MORPHED_SHIFTERS== TRUE )  )
        ExportSingleCharacter(oPC);
}
//***************************************************************************


//HABD Henchman function. Makes the Henchman Not Busy.
void HABDAssociateNotBusy();
//Implementation at the end of the script

// ****************************************************************************

// Deletes all HABD effects from Ghost. Called from autoraising or GhostHB.
void HABDFinishRespawnGhost(object oPC);
void HABDFinishRespawnGhost(object oPC)
{
object oMod = GetModule();
    object oPC = OBJECT_SELF;
    string sID = GetPCPlayerName(oPC)+GetName(oPC);
                        //DEBUG: Not translated to spanish
    if (HABD_DEBUG) SpeakString("DEBUG: HABDFinishRespawnGhost, "+GetName(oPC)+", PlotFlag:"+IntToString(GetPlotFlag(OBJECT_SELF))+", CommandableFlag:"+IntToString(GetCommandable())+", HP: "+IntToString(GetCurrentHitPoints(oPC))+", master: "+GetName(GetMaster(oPC))+", state:"+HABDGetPlayerStateName(oPC), TALKVOLUME_SHOUT);

    int iState = GetLocalInt(oMod, HABD_PLAYER_STATE+sID);
if ( iState != HABD_STATE_RESPAWNED_GHOST )
        {
        // Respawn state has been removed. Restore the player to normal.
        SetCommandable(TRUE);
        SetPlotFlag(OBJECT_SELF, FALSE);
        // Set playerstate to alive.
        SetLocalInt(oMod, HABD_PLAYER_STATE+sID, HABD_STATE_PLAYER_ALIVE);
        if(HABD_USERLANGUAGE==0)
            FloatingTextStringOnCreature("OOC: You shake off the ghostly effects.", OBJECT_SELF, FALSE);
        else if(HABD_USERLANGUAGE==1)
            FloatingTextStringOnCreature("OOC: Se eliminan los efectos de fantasma Respawnado.", OBJECT_SELF, FALSE);
        // Restore the player's reputation with HOSTILE faction.
        SetStandardFactionReputation(STANDARD_FACTION_HOSTILE, GetLocalInt(oPC, HABD_OLD_FACTION), oPC);
        DeleteLocalInt(oPC, HABD_OLD_FACTION_SET);
        effect eEffect = GetFirstEffect(OBJECT_SELF);
        while(GetIsEffectValid(eEffect))
          {
            // They are rezzed, remove sanctuary visual effects.
            if (GetEffectType(eEffect) == EFFECT_TYPE_CONCEALMENT)
            {
                RemoveEffect(OBJECT_SELF, eEffect);
            }
            eEffect = GetNextEffect(OBJECT_SELF);
          }
        HABDAssociateNotBusy();
        AssignCommand(OBJECT_SELF, ClearAllActions());
        // Delete any item corpse when the player is respawned, to avoid future strange situations
        object oitemcorpse = GetLocalObject(oMod, HABD_PC_CORPSE_OBJECT_ID+sID);
        if( oitemcorpse != OBJECT_INVALID )
        {
            object ocorpsecarrier = GetItemPossessor(oitemcorpse);
            if (GetIsPC(ocorpsecarrier) )
            {
                if(HABD_USERLANGUAGE==0)
                SendMessageToPC(ocorpsecarrier, "HABD: The owner of a corpse you were carrying has been raised somehow. The corpse will be deleted.");
                else if(HABD_USERLANGUAGE==1)
                SendMessageToPC(ocorpsecarrier, "HABD: El PJ de un cadaver que transportabas ha sido resucitado de alguna manera. El cadaver ha sido eliminado.");
            }
            DeleteLocalObject(oMod, HABD_PC_CORPSE_OBJECT_ID+sID);
            DestroyObject(oitemcorpse);
        }
        // Fixes the inital respawn issue with monsters not reattacking.
        object oMonster = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY,oPC, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
        DelayCommand(9.0, AssignCommand(oMonster, ActionAttack(oPC)));
        //Save info to DB (and maybe export PC) to avoid server crash problems,
        //now that we are sure the PC is Alive.
         if ( HABD_SMART_SAVETODB == TRUE )
            HABDSetDBString(oPC);
        }
}

// Bring a respawned ghost back to life.
//   oTarget - the respawned ghost player.
//   nSpell - SPELL_RAISE_DEAD or SPELL_RESURRECTION
void HABDCureRespawnGhost(object oTarget, int nSpell);

void HABDCureRespawnGhost(object oTarget, int nSpell)
{
    // Do nothing if cast on a player who is still dead.
    if(!GetIsDead(oTarget))
    {
        object oMod = GetModule();
        string sID = GetPCPlayerName(oTarget)+GetName(oTarget);
        // If the player state wasn't respawned then do nothing.
        if (GetLocalInt(GetModule(), HABD_PLAYER_STATE+sID) == HABD_STATE_RESPAWNED_GHOST)
        {
            if(HABD_USERLANGUAGE==0)
                FloatingTextStringOnCreature("OOC: You have been brought back to life.", oTarget, FALSE);
            else if(HABD_USERLANGUAGE==1)
                FloatingTextStringOnCreature("OOC: Has sido traido de vuelta a la vida.", oTarget, FALSE);
            // Allow the player to take damage.
            SetPlotFlag(oTarget, FALSE);
            // Set the player back to alive.
            SetLocalInt(GetModule(), HABD_PLAYER_STATE+sID, HABD_STATE_PLAYER_ALIVE);
            if (HABD_AUTORAISE_VFX == 1)
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RAISE_DEAD), oTarget);
            if (nSpell == SPELL_RAISE_DEAD)
            {
                HABDApplyPenalty(oTarget, HABD_RAISE_XP_LOSS, HABD_RAISE_GP_LOSS);
                AssignCommand(oTarget, HABDUserDefinedRaise());
            }
            if (nSpell == SPELL_RESURRECTION)
            {
                HABDApplyPenalty(oTarget, HABD_REZ_XP_LOSS, HABD_REZ_GP_LOSS);
                AssignCommand(oTarget, HABDUserDefinedResurrection());
            }
            DelayCommand(0.1,HABDFinishRespawnGhost(oTarget));
        }
    }
 }

// ****************************************************************************



// Will raise the owner of the corpse. If the PC is logged out, it will mark
// the PC to be autoraised when login. It should only be called for players that
// are respawned (ghost).
void HABDRaiseCorpse(object oCorpse, int iSpell, int iAdditionalGoldPenalty=0);

void HABDRaiseCorpse(object oCorpse, int iSpell, int iAdditionalGoldPenalty=0)
{
    int iraised = FALSE;

    //make sure it is a valid corpse item
    if (GetObjectType(oCorpse) == OBJECT_TYPE_ITEM &&
        ( GetResRef(oCorpse) == HABD_CORPSEITEM_FEM_RESREF ||
          GetResRef(oCorpse) == HABD_CORPSEITEM_MALE_RESREF )
        )
    {
    object oGhost = OBJECT_INVALID;

    //If we are trying to raise a corpse item, we must found who is the ghost
    //that owns the corpse.
    //Actually it only works if the PC is logged in
    int corpseownerfound = FALSE;
        oGhost = GetFirstPC();
        while (oGhost!=OBJECT_INVALID && corpseownerfound == FALSE)
        {
            if(GetPCPlayerName(oGhost) == GetLocalString(oCorpse, HABD_CORPSE_OWNER_PLAYERNAME)
                && GetName(oGhost) == GetLocalString(oCorpse, HABD_CORPSE_OWNER_PCNAME)
                )
              {
                corpseownerfound == TRUE;
              }
              else oGhost = GetNextPC();
        }

    //raise corpse item
    if (corpseownerfound == TRUE)
    {
        //the owner is logged in
        //cast the apropiate spell to raise.
            HABDCureRespawnGhost(oGhost,iSpell);
            iraised = TRUE;
    }
    else
    if (HABD_RAISE_LOGOUT_PLAYERS == TRUE)
    {
        //owner is logged out, we'll modify the database instead
        //note that it doesnt mark the PC as raised, instead we say that he
        //should be raised when he logs in next time.
        string sPlayerN = GetLocalString(oCorpse, HABD_CORPSE_OWNER_PLAYERNAME);
        string sPCName = GetLocalString(oCorpse, HABD_CORPSE_OWNER_PCNAME);
        string sID = sPlayerN+sPCName;

        string sData = HABDLoadStringFromDB(sPlayerN, sPCName);

        int iDCount = StringToInt(HABDStrTok(sData, 1));
        int iBCount = StringToInt(HABDStrTok(sData, 2));
        int iXCount = StringToInt(HABDStrTok(sData, 3));
        int iGCount = StringToInt(HABDStrTok(sData, 4));
        int iHP = StringToInt(HABDStrTok(sData, 5));
        int iState = StringToInt(HABDStrTok(sData, 6));
        int iRespawn = StringToInt(HABDStrTok(sData, 7));
        int iRaise = StringToInt(HABDStrTok(sData, 8));
        string sBindStoneAreaTag = HABDStrTok(sData, 9);
        string shabdcustomvar = HABDStrTok(sData, 13);
        // variables that allow PCs to be raised when logged out
        int iCorpseRaise = TRUE;
        int iCorpseSpell = iSpell;
        int iCorpseNPCGP = iAdditionalGoldPenalty;

        sData = IntToString(iDCount)+","+IntToString(iBCount)+","+IntToString(iXCount)+","+IntToString(iGCount)+","+IntToString(iHP)+","+IntToString(iState)+","+IntToString(iRespawn)+","+IntToString(iRaise)+","+sBindStoneAreaTag+","+IntToString(iCorpseRaise)+","+IntToString(iCorpseSpell)+","+IntToString(iCorpseNPCGP)+","+shabdcustomvar+",0";
        iraised = TRUE;

        //corpse is only created when you respawn.
        if (iState == HABD_STATE_RESPAWNED_GHOST)
        {
        HABDSaveStringToDB(sData, sPlayerN, sPCName);
        //SendMessageToPC(oPC, "OOC: Owner of the corpse was logged out, he has been marked as raised sucessfully");
        PrintString("HABD_DB: Player Character raised when Player was logged out: ");
        PrintString("HABD_DB: Storing "+sID+" iHP="+IntToString(iHP)+" iState="+IntToString(iState)+" iRespawnTimer="+IntToString(iRespawn)+" iRaiseTimer="+IntToString(iRaise));
        PrintString("HABD_DB: Storing "+sID+" Death="+IntToString(iDCount)+" Bleed="+IntToString(iBCount)+" XPLost="+IntToString(iXCount)+" GPLost="+IntToString(iGCount));
        PrintString("HABD_DB: Storing "+sID+" "+sData);
        }
    }

    //destroy found corpse
    if (oCorpse != OBJECT_INVALID && iraised == TRUE)
        {
        DeleteLocalString(oCorpse, HABD_CORPSE_OWNER_PLAYERNAME);
        DeleteLocalString(oCorpse, HABD_CORPSE_OWNER_PCNAME);
        DestroyObject(oCorpse);
        }

    }
}
//*************************************************************************



// The packed function with the code that go into the Raise Dead Spell.
// It should be placed after the pre-spell cast hook is executed, at the end
// of the script, e.g.
void HABDRaiseDeadSpell(object oTarget);

void HABDRaiseDeadSpell(object oTarget)
{
    if (HABD_HENCHMEN_NO_RAISE == TRUE && !GetIsPC(oTarget) &&
        GetObjectType(oTarget) == OBJECT_TYPE_CREATURE) return;
    if (GetObjectType(oTarget) == OBJECT_TYPE_ITEM &&
        ( GetResRef(oTarget) == HABD_CORPSEITEM_FEM_RESREF ||
          GetResRef(oTarget) == HABD_CORPSEITEM_MALE_RESREF )
        )
        //raise item corpse
        HABDRaiseCorpse(oTarget, SPELL_RAISE_DEAD);
    else
    if(GetIsDead(oTarget))
        // Apply the user defined effects.
        HABDApplyPenaltyIfDead(oTarget, SPELL_RAISE_DEAD);
    HABDCureRespawnGhost(oTarget, SPELL_RAISE_DEAD);
}


// The packed function with the code that go into the Resurrection Spell.
// It should be placed after the pre-spell cast hook is executed, at the end
// of the script, e.g.
void HABDResurrectionSpell(object oTarget);

void HABDResurrectionSpell(object oTarget)
{
    if (HABD_HENCHMEN_NO_RAISE == TRUE && !GetIsPC(oTarget) &&
        GetObjectType(oTarget) == OBJECT_TYPE_CREATURE) return;
    if (GetIsObjectValid(oTarget))
    {
        if (GetObjectType(oTarget) == OBJECT_TYPE_ITEM &&
            ( GetResRef(oTarget) == HABD_CORPSEITEM_FEM_RESREF ||
              GetResRef(oTarget) == HABD_CORPSEITEM_MALE_RESREF )
            )
            //raise item corpse
            HABDRaiseCorpse(oTarget, SPELL_RESURRECTION);
        else
        if (GetIsDead(oTarget))
        HABDApplyPenaltyIfDead(oTarget, SPELL_RESURRECTION);
        else
        HABDCureRespawnGhost(oTarget, SPELL_RESURRECTION);
    }
}

// ****************************************************************************


// Unequip all regeneration items that a player is wearing. Items are stored
// as a local array so that they can be re-equipped later.
//   oPC - the player to unequip the items for.
void HABDRegenerationItemsUnequip(object oPC);

void HABDRegenerationItemsUnequip(object oPC)
{
    // If the player already has unequiped items they never had a re-equip
    // call for then do nothing. WARNING: this could potential cause an
    // exploit if players can find a way to come back to life without initiating
    // the corresponding equip items call.
    if (GetLocalInt(oPC, HABD_UNEQUIPED_ITEMS) != 0) return;

    // Go through the players inventory and unequip all of their regeneration
    // items.
    int iCount = 0;
    int i;
    object oItem;
    object oNewItem;
    for (i=0; i<NUM_INVENTORY_SLOTS; i++)
    {
        oItem = GetItemInSlot(i, oPC);
        if (GetItemHasItemProperty(oItem, ITEM_PROPERTY_REGENERATION))
        {
            iCount++;
            // Stupid work around to ActionUnequip item not working in a timely manner.
            oNewItem = CopyItem(oItem, oPC);
            DestroyObject(oItem);
            if(HABD_USERLANGUAGE==0)
                SendMessageToPC(oPC, "Unequipping "+GetName(oItem));
            if(HABD_USERLANGUAGE==1)
                SendMessageToPC(oPC, "Desequipando "+GetName(oItem));
            SetLocalObject(oPC, HABD_UNEQUIPED_ITEMS+IntToString(iCount), oNewItem);
            SetLocalInt(oPC, HABD_UNEQUIPED_ITEMS+"Slot"+IntToString(iCount), i);
        }
    }
    SetLocalInt(oPC, HABD_UNEQUIPED_ITEMS, iCount);
}

// ****************************************************************************

// Re-equip all regeneration items that a player is wearing. Items to be
// re-equipped were stored as a local array.
//   oPC - the player to re-equip the items for.
void HABDRegenerationItemsReEquip(object oPC);

void HABDRegenerationItemsReEquip(object oPC)
{
    int iNumItems = GetLocalInt(oPC, HABD_UNEQUIPED_ITEMS);
    // If the player has no unequipped regeneration items then do nothing.
    if (iNumItems == 0) return;
    int iCount;
    int iSlot;
    object oItem;
    // Go through the local array and equip all of the items if the player
    // still possesses them.
    for (iCount=1; iCount<=iNumItems; iCount++)
    {
        oItem = GetLocalObject(oPC, HABD_UNEQUIPED_ITEMS+IntToString(iCount));
        iSlot = GetLocalInt(oPC, HABD_UNEQUIPED_ITEMS+"Slot"+IntToString(iCount));
        if (GetItemPossessor(oItem) == oPC)
        {
            if(HABD_USERLANGUAGE==0)
                SendMessageToPC(oPC, "Equipping "+GetName(oItem));
            else if(HABD_USERLANGUAGE==1)
                SendMessageToPC(oPC, "Equipando "+GetName(oItem));
            AssignCommand(oPC, ActionEquipItem(oItem, iSlot));
        }
        DeleteLocalObject(oPC, HABD_UNEQUIPED_ITEMS+IntToString(iCount));
        DeleteLocalInt(oPC, HABD_UNEQUIPED_ITEMS+"Slot"+IntToString(iCount));
    }
    DeleteLocalInt(oPC, HABD_UNEQUIPED_ITEMS);
}

// ****************************************************************************

// Give the player any of the HABD items they are missing.
//   oPC - player entering the module.
void HABDItemsOnClientEnter(object oPC);

void HABDItemsOnClientEnter(object oPC)
{
    if (GetIsDM(oPC)) {
    if(!GetIsObjectValid(GetItemPossessedBy(oPC, HABD_ITEM_DM_TOKEN)))
    {
        CreateItemOnObject(HABD_ITEM_DM_TOKEN, oPC, 1);
    }
    if(!GetIsObjectValid(GetItemPossessedBy(oPC, HABD_ITEM_DM_DEATH)))
    {
        CreateItemOnObject(HABD_ITEM_DM_DEATH, oPC, 1);
    }
    } else {
    // Check for death token.
    if ( GetStringLeft(HABD_ITEMSONENTER,1) != "0" )
    if(!GetIsObjectValid(GetItemPossessedBy(oPC, HABD_ITEM_TOKEN)))
    {
        CreateItemOnObject(HABD_ITEM_TOKEN, oPC, 1);
    }
    // Check for bandages.
    if ( GetSubString(HABD_ITEMSONENTER,1,1) != "0" )
    if(!GetIsObjectValid(GetItemPossessedBy(oPC, HABD_ITEM_BANDAGES)))
    {
        CreateItemOnObject(HABD_ITEM_BANDAGES, oPC, 1);
    }
    // Check for rule book.
    if ( GetSubString(HABD_ITEMSONENTER,2,1) != "0" )
    if(!GetIsObjectValid(GetItemPossessedBy(oPC, HABD_ITEM_RULES)))
    {
        CreateItemOnObject(HABD_ITEM_RULES, oPC, 1);
    }
    }
}

// ****************************************************************************

// ONLY IF YOU USE AN OLD PATCH. If you are using a patch below 1.62 ...
// Modern patches allow undropable objects hardcoded. Let it there for compatibility.
// Prevent the player from transfering their HABD items. Not strictly necessary
// since players will automatically get the items when they enter the module,
// but can prevent some headaches later on for players who are new to the system.
// Supossely containers cannot be stolen except if they are empty (otherwise
// this code will fail)
int HABDOnUnAcquiredItem(object oPC, object oItem);

int HABDOnUnAcquiredItem(object oPC, object oItem)
{
    string sTag = GetTag(oItem);

    if ( HABD_PATCH_PRECURSEDITEMS == TRUE )
    {
    // Check to see if the unacquired item has a tag that we recognize.
    if (
        (sTag == HABD_ITEM_TOKEN) ||
        (sTag == HABD_ITEM_BANDAGES) ||
        (sTag == HABD_ITEM_RULES)
        )
    {
        CopyItem(oItem, oPC);
        DestroyObject(oItem);
        if(HABD_USERLANGUAGE==0)
            FloatingTextStringOnCreature(GetName(oItem)+" cannot be dropped.", oPC);
        else if(HABD_USERLANGUAGE==1)
            FloatingTextStringOnCreature(GetName(oItem)+" no puede ser tirado.", oPC);
        return TRUE;
    }
    return FALSE;
    }

    object oMod = GetModule();
    string sID = GetPCPlayerName(oPC)+GetName(oPC);
    int iState = GetLocalInt(oMod, HABD_PLAYER_STATE+sID);
    object oThief = GetItemPossessor(oItem);
    if (GetStolenFlag(oItem) && iState == HABD_STATE_RESPAWNED_GHOST
        && HABD_ALLOW_GHOST_PICKPOCKET==FALSE
        && GetIsDM(oThief)==FALSE && GetIsDMPossessed(oThief)==FALSE )
    {
        object oNewItem = CopyItem(oItem, oPC, TRUE);
        DestroyObject(oItem);
        string sGPPAdvice = "Ghosts cannot suffer pickpocket";
        if(HABD_USERLANGUAGE==0)
            sGPPAdvice = "Ghosts cannot suffer pickpocket";
        else if(HABD_USERLANGUAGE==1)
            sGPPAdvice = "No se puede robar a los fantasmas";
        FloatingTextStringOnCreature(sGPPAdvice, oPC);
        FloatingTextStringOnCreature(sGPPAdvice, oThief);
        //if the item before the steal was marked as stolen it will mark it as
        //a way yo make legit stolen objects... but it is a small exploit, this
        //should avoid other problems.
        DelayCommand(0.1, SetStolenFlag(oNewItem, FALSE) );

        AssignCommand (oThief,ClearAllActions(TRUE));
        AssignCommand (oThief,ActionMoveAwayFromObject(oPC,TRUE, 5.0f));
        DelayCommand ( 0.001, SetCommandable(FALSE, oThief) );
        DelayCommand ( 1.0, SetCommandable(TRUE, oThief) );
        DelayCommand ( 1.01, AssignCommand (oThief,ActionMoveAwayFromObject(oPC,TRUE, 5.0f)) );
    }
    return FALSE;
}

// ****************************************************************************

// Use the bandage item on oTarget. If oTarget is bleeding then they will be
// stabilized if oPC passes a DC=15 Heal skill check. If oTarget is a respawned
// ghost then they will be made to follow oPC.
//   oPC - the player using the item.
//   oTarget - the target to use the item on.
//   iBonus - A positive modifier to Heal Skill granted by a quality bandage
void HABDItemBandages(object oPC, object oTarget, int iBonus=0);

void HABDItemBandages(object oPC, object oTarget, int iBonus=0)
{
    // Make sure that the bandage is being used on a valid player.
    if (!GetIsObjectValid(oTarget) || !(GetIsPC(oTarget) || GetLocalInt(oTarget, HABD_NPC_BLEED)))
    {
        if(HABD_USERLANGUAGE==0)
            FloatingTextStringOnCreature("FAILURE: bandages can only be used on players and henchmen.", oPC, FALSE);
        else if(HABD_USERLANGUAGE==1)
            FloatingTextStringOnCreature("FALLO: las vendas solo pueden usarse sobre jugadores o escuderos.", oPC, FALSE);
        return;
    }
    // Make them run to the target.
    AssignCommand(oPC, ActionForceMoveToObject(oTarget, TRUE, 0.5, 6.0));
    // Check the state of the target.
    int iState = GetLocalInt(GetModule(), HABD_PLAYER_STATE+GetPCPlayerName(oTarget)+GetName(oTarget));
    if (iState == HABD_STATE_PLAYER_BLEEDING)
    {
        string sMsg;
        // The target is bleeding, try to heal them.
        int iroll = d20() + GetSkillRank(SKILL_HEAL,oPC);
        if(HABD_USERLANGUAGE==0)
                sMsg = "Heal check: "+IntToString(iroll)+".";
            else if(HABD_USERLANGUAGE==1)
                sMsg = "Sanar: "+IntToString(iroll)+".";
            SendMessageToPC(oPC, sMsg);
        //if (GetIsSkillSuccessful(oPC, SKILL_HEAL, HABD_HEAL_SKILL_DC - iBonus ))
        if (iroll >= HABD_HEAL_SKILL_DC - iBonus)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(1), oTarget);
            if(HABD_USERLANGUAGE==0)
                sMsg = "SUCCESS: bandaged "+GetName(oTarget)+".";
            else if(HABD_USERLANGUAGE==1)
                sMsg = "EXITO: vendado "+GetName(oTarget)+".";
        } else
          {
            //partial healing
            if ( HABD_HEALMINOR_SKILL_DC>0 &&
                iroll >= HABD_HEALMINOR_SKILL_DC - iBonus &&
                GetCurrentHitPoints(oTarget)<-1 )
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(-1-GetCurrentHitPoints(oTarget)), oTarget);
                object oMod = GetModule();
                string sID = GetPCPlayerName(oTarget)+GetName(oTarget);
                //it should ensure that the the system dont identifies this healing
                //as a stabilization or magic healing!
                SetLocalInt(oMod, HABD_LAST_HP+sID, -1);
                if(HABD_USERLANGUAGE==0)
                sMsg = "PARTIAL SUCCESS: healed to -1 HPs but still bleeding!: "+GetName(oTarget)+".";
                else if(HABD_USERLANGUAGE==1)
                sMsg = "EXITO PARCIAL: curado hasta -1 PG pero todavia se esta muriendo!: "+GetName(oTarget)+".";
            }
            else
            {
            if(HABD_USERLANGUAGE==0)
                sMsg = "FAILURE: could not bandage "+GetName(oTarget)+". Try again.";
            else if(HABD_USERLANGUAGE==1)
                sMsg = "FALLO: no pudiste vendar a "+GetName(oTarget)+". Intentalo de nuevo.";
            }
          }

        // If oPC and oTarget are in the same party, then use a floating text string
        if (GetFactionEqual(oPC, oTarget))
        {
            FloatingTextStringOnCreature(sMsg, oPC);
        } else if (!GetIsDM(oPC))
        {
            AssignCommand(oPC, ActionSpeakString(sMsg));
        }
        return;
    }
    else if (iState == HABD_STATE_RESPAWNED_GHOST)
    {
        // The target is a ghost,
        if (
            (GetIsDM(oPC)) || // DMs always succeed
            (GetIsDM(GetMaster(oPC))) || // DM possessed NPCs always succeed
            (GetFactionEqual(oPC, oTarget)) // Party members always succeed
            )
        {
            if(HABD_USERLANGUAGE==0)
                FloatingTextStringOnCreature("SUCCESS: "+GetName(oTarget)+" will follow "+GetName(oPC)+".", oPC);
            else if(HABD_USERLANGUAGE==1)
                FloatingTextStringOnCreature("EXITO: "+GetName(oTarget)+" seguira a "+GetName(oPC)+".", oPC);
            SetLocalObject(oTarget, HABD_GHOST_AUTOFOLLOW, oPC);
        } else {
            if(HABD_USERLANGUAGE==0)
                AssignCommand(oPC, ActionSpeakString("FAILURE: "+GetName(oTarget)+" must be in the same party for you to move them."));
            else if(HABD_USERLANGUAGE==1)
                AssignCommand(oPC, ActionSpeakString("FALLO: "+GetName(oTarget)+" debe estar en tu mismo equipo de PJs para que lo puedas mover."));
        }
        return;
    }
    // Could not handle the target's state.
    if(HABD_USERLANGUAGE==0)
        AssignCommand(oPC, ActionSpeakString("Bandages did nothing to "+GetName(oTarget)+" because they are "+HABDGetPlayerStateName(oPC)+"."));
    else if(HABD_USERLANGUAGE==1)
        AssignCommand(oPC, ActionSpeakString("Las Vendas no le hicieron nada a "+GetName(oTarget)+" porque estaba "+HABDGetPlayerStateName(oPC)+"."));
}

// ****************************************************************************

// Display the HABD statistics to the DM.
//   oDM - the person innitating the statistics display.
//   oPC - a player in the party you want to to report the statistics on.
//   oItem - the item that activated this function.
void HABDItemDMToken (object oDM, object oPC, object oItem);

void HABDItemDMToken (object oDM, object oPC, object oItem)
{
    object oMod = GetModule();

    // Check if used by DM.
    if (
        (!GetIsDM(oDM) &&
        (!GetIsDM(GetMaster(oDM))) &&
        (!GetLocalInt(oMod, "dmfi_Admin" + GetPCPublicCDKey(oDM))))
        )
    {
        // This item is not usable by players.
        if(HABD_USERLANGUAGE==0)
            FloatingTextStringOnCreature("You cannot use this item." , oDM, FALSE);
        else if(HABD_USERLANGUAGE==1)
            FloatingTextStringOnCreature("No puedes usar este objeto." , oDM, FALSE);
        DestroyObject(oItem);
        return;
    }

    // Check if used on player.
    if ((!GetIsPC(oPC)) || GetIsDM(GetMaster(oPC)) || (GetIsDM(oPC)))
    {
        if(HABD_USERLANGUAGE==0)
            FloatingTextStringOnCreature("Can only be used on players. "+GetName(oPC)+" is not a player.", oDM, FALSE);
        else if(HABD_USERLANGUAGE==1)
            FloatingTextStringOnCreature("Solo puede ser usado sobre jugadores. "+GetName(oPC)+" no es un personaje jugador.", oDM, FALSE);
        return;
    }

    // Display stats for party.
    string sMsg;
    string sID;
    object oParty = GetFirstFactionMember(oPC, FALSE);
    while (GetIsObjectValid(oParty))
    {
        sID = GetPCPlayerName(oParty)+GetName(oParty);
        if(HABD_USERLANGUAGE==0)
        sMsg = GetName(oParty)+": bleeding "
            +IntToString(GetLocalInt(oMod, HABD_CURRENT_BLEED_COUNT+sID))
            +", died "+IntToString(GetLocalInt(oMod, HABD_CURRENT_DEATH_COUNT+sID))
            +", lost "+IntToString(GetLocalInt(oMod, HABD_CURRENT_LOST_XP_COUNT+sID))+" XP, lost "
            +IntToString(GetLocalInt(oMod, HABD_CURRENT_LOST_GP_COUNT+sID))+" GP since server restart.";
        else if(HABD_USERLANGUAGE==1)
        sMsg = GetName(oParty)+": desangramiento "
            +IntToString(GetLocalInt(oMod, HABD_CURRENT_BLEED_COUNT+sID))
            +", muerto "+IntToString(GetLocalInt(oMod, HABD_CURRENT_DEATH_COUNT+sID))
            +", perdio "+IntToString(GetLocalInt(oMod, HABD_CURRENT_LOST_XP_COUNT+sID))+" PX, perdio "
            +IntToString(GetLocalInt(oMod, HABD_CURRENT_LOST_GP_COUNT+sID))+" PO desde el reinicio del server.";
        if (HABD_DM_DISPLAY_STATS_TO_ALL) SendMessageToAllDMs(sMsg);
        else SendMessageToPC(oDM, sMsg);
        oParty = GetNextFactionMember(oPC, FALSE);
    }
    return;
}

// Instantly kill a player/henchman without going through bleed. Will also kill
// any NPC you point it at.
//   oDM - the person using this item.
//   oPC - a player/henchman you want to kill.
//   oItem - the item that activated this function.
void HABDItemDMDeath (object oDM, object oPC, object oItem);

void HABDItemDMDeath (object oDM, object oPC, object oItem)
{
    object oMod = GetModule();

    // Check if used by DM.
    if (
        (!GetIsDM(oDM) &&
        (!GetIsDM(GetMaster(oDM))) &&
        (!GetLocalInt(oMod, "dmfi_Admin" + GetPCPublicCDKey(oDM))))
        )
    {
        // This item is not usable by players.
        if(HABD_USERLANGUAGE==0)
            FloatingTextStringOnCreature("You cannot use this item." , oDM, FALSE);
        else if(HABD_USERLANGUAGE==1)
            FloatingTextStringOnCreature("No puedes usar este objeto." , oDM, FALSE);
        DestroyObject(oItem);
        return;
    }

    // Kill 'em.
    SetLocalInt(GetModule(), HABD_PLAYER_STATE+GetPCPlayerName(oPC)+GetName(oPC), HABD_STATE_PLAYER_DEAD);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(TRUE), oPC);

    return;
}

// ****************************************************************************

// Display the HABD statistics to the player.
//   oPC - the player to report the statistics on.
void HABDItemToken (object oPC);

void HABDItemToken (object oPC)
{
    object oMod = GetModule();
    string sID = GetPCPlayerName(oPC)+GetName(oPC);
    if(HABD_USERLANGUAGE==0)
    {
    FloatingTextStringOnCreature("You have died "+IntToString(GetLocalInt(oMod, HABD_CURRENT_DEATH_COUNT+sID))+" times since server restart.", oPC, FALSE);
    FloatingTextStringOnCreature("You have started bleeding "+IntToString(GetLocalInt(oMod, HABD_CURRENT_BLEED_COUNT+sID))+" times since server restart.", oPC, FALSE);
    FloatingTextStringOnCreature("You have lost "+IntToString(GetLocalInt(oMod, HABD_CURRENT_LOST_XP_COUNT+sID))+" XP from dying since server restart.", oPC, FALSE);
    FloatingTextStringOnCreature("You have lost "+IntToString(GetLocalInt(oMod, HABD_CURRENT_LOST_GP_COUNT+sID))+" GP from dying since server restart.", oPC, FALSE);
    FloatingTextStringOnCreature("You have died "+IntToString(GetLocalInt(oMod, HABD_DEATH_COUNT+sID))+" times in total.", oPC, FALSE);
    FloatingTextStringOnCreature("You have started bleeding "+IntToString(GetLocalInt(oMod, HABD_BLEED_COUNT+sID))+" times in total.", oPC, FALSE);
    FloatingTextStringOnCreature("You have lost "+IntToString(GetLocalInt(oMod, HABD_LOST_XP_COUNT+sID))+" XP from dying.", oPC, FALSE);
    FloatingTextStringOnCreature("You have lost "+IntToString(GetLocalInt(oMod, HABD_LOST_GP_COUNT+sID))+" GP from dying.", oPC, FALSE);
    }
    else if(HABD_USERLANGUAGE==1)
    {
    FloatingTextStringOnCreature("Has muerto "+IntToString(GetLocalInt(oMod, HABD_CURRENT_DEATH_COUNT+sID))+" veces desde el reinicio del server.", oPC, FALSE);
    FloatingTextStringOnCreature("Has empezado a morirte "+IntToString(GetLocalInt(oMod, HABD_CURRENT_BLEED_COUNT+sID))+" veces desde el reinicio del server.", oPC, FALSE);
    FloatingTextStringOnCreature("Has perdido "+IntToString(GetLocalInt(oMod, HABD_CURRENT_LOST_XP_COUNT+sID))+" PX por morir desde el reinicio del server.", oPC, FALSE);
    FloatingTextStringOnCreature("Has perdido "+IntToString(GetLocalInt(oMod, HABD_CURRENT_LOST_GP_COUNT+sID))+" PO por morir desde el reinicio del server.", oPC, FALSE);
    FloatingTextStringOnCreature("Has muerto "+IntToString(GetLocalInt(oMod, HABD_DEATH_COUNT+sID))+" veces en total.", oPC, FALSE);
    FloatingTextStringOnCreature("Has empezado a morirte "+IntToString(GetLocalInt(oMod, HABD_BLEED_COUNT+sID))+" veces en total.", oPC, FALSE);
    FloatingTextStringOnCreature("Has perdido "+IntToString(GetLocalInt(oMod, HABD_LOST_XP_COUNT+sID))+" PX por morir.", oPC, FALSE);
    FloatingTextStringOnCreature("Has perdido "+IntToString(GetLocalInt(oMod, HABD_LOST_GP_COUNT+sID))+" PO por morir.", oPC, FALSE);
    }
}

// ****************************************************************************


// Small function to transform HABD drop settings to a descriptive string.
string HABDGetDropType(int iSetting);
string HABDGetDropType(int iSetting)
{
    string sErrorMsg = "ERROR: unknown setting";
    if(HABD_USERLANGUAGE==0)
    switch (iSetting)
    {
        case 0: return "not dropped or destroyed";
        case 1: return "dropped";
        case 2: return "destroyed";
        default: sErrorMsg = "ERROR: unknown setting"; break;
    }
    else if(HABD_USERLANGUAGE==1)
    switch (iSetting)
    {
        case 0: return "ni tirado al suelo ni destruido";
        case 1: return "tirado al suelo";
        case 2: return "destruido";
        default: sErrorMsg = "ERROR: configuracion desconocida"; break;
    }
    return sErrorMsg;
}


// Display the HABD rules to the player.   DEBUG: Not translated to spanish
//   oPC - the player to show the rules to.
void HABDItemRules (object oPC);

void HABDItemRules (object oPC)
{
    int iXP = GetXP(oPC);
    int iGP = GetGold(oPC);
    int iTime = FloatToInt(HABDGetBleedTimer(oPC, FALSE));
    int nPenalty = 10 * GetHitDice(oPC);

    string sMsg = HABD_VERSION+"\n";
    SendMessageToPC(oPC, sMsg);

    if (GetIsDM(oPC) || (GetIsDM(GetMaster(oPC))))
    {
        sMsg = "SPECIAL DM RULES:\n";
        sMsg = sMsg + "- players cannot die until they are level "+IntToString(HABD_NO_DEATH_UNTIL_LEVEL)+"\n";
        if (HABD_DM_NOTIFICATION_ON_BLEED) sMsg = sMsg + "- DM channel notification on player/henchman bleed.\n";
        if (HABD_DM_NOTIFICATION_ON_DEATH) sMsg = sMsg + "- DM channel notification on player/henchman death.\n";
        if (HABD_DM_NOTIFICATION_ON_PENALTY) sMsg = sMsg + "- DM channel notification on player/henchman XP/GP penalty.\n";
        if (HABD_DM_DISPLAY_STATS_TO_ALL) sMsg = sMsg + "- DM channel notification when checking persistent stats for a party.\n";
        if (HABD_LEVELUPBLEED_EXPLOIT_KILLS) sMsg = sMsg + "- If a player Levels up while bleeding (exploit) he will death.\n";
            else sMsg = sMsg + "- If a player Levels up while bleeding (exploit) he wont death, but DMs and log will receive the notification.\n";
        SendMessageToPC(oPC, sMsg);
    }

    sMsg = "PERSISTENCE:\n";
    if (HADB_DB_PERSISTENT) sMsg = sMsg + "- bleeding/death/respawn/autotimer state is saved over server restart, as well as statistics.\n";
    if (HABD_BINDSTONE_MANAGE_LOCATIONS) sMsg = sMsg + "- Permanent locations are managed using a Bindstone/Trigger System.\n";
    SendMessageToPC(oPC, sMsg);

    sMsg = "BLEEDING RULES:\n";
    sMsg = sMsg + "- players bleed from 0 to -9 HP before death.\n";
    sMsg = sMsg + "- instant bleed of "+IntToString(HABD_BLEEDING_START_LIMIT-1)+" to -9 will start at "+IntToString(HABD_BLEEDING_START_LIMIT)+" HP.\n";
    if (HABD_ALLOW_INSTANT_DEATH == FALSE) sMsg = sMsg + "- instant death will start at "+IntToString(HABD_BLEEDING_START_LIMIT-1)+" to -9 HP.\n";
    else sMsg = sMsg + "Instant Death is allowed.\n";
    if (HABD_NOINPARTY_FAST_BLEED >= 1) sMsg = sMsg + "- soloing without a party will take "+IntToString(HABD_NOINPARTY_FAST_BLEED)+" seconds to bleed -1 HP.\n";
    if (HABD_SOLO_FAST_BLEED >= 1) sMsg = sMsg + "- being alone in the server/Solo Game will take "+IntToString(HABD_SOLO_FAST_BLEED)+" seconds to bleed -1 HP.\n";
    sMsg = sMsg + "- it will take you "+IntToString(iTime)+" seconds to bleed -1 HP.\n";
    sMsg = sMsg + "- stabilization makes you recover to 1 HP.\n";
    sMsg = sMsg + "- there is a "+IntToString(100*(HABD_STABILIZATION_DICE+1-HABD_GLOBAL_STABILIZATION_NUMBER)/HABD_STABILIZATION_DICE)+"% ("+IntToString(100*(HABD_STABILIZATION_DICE+1-HABD_SOLO_STABILIZATION_NUMBER)/HABD_STABILIZATION_DICE)+"% if single player) chance of stabilization when you bleed a HP.\n";
    sMsg = sMsg + "- bandages can be used to stabilize a player on a DC="+IntToString(HABD_HEAL_SKILL_DC)+" Heal skill check.\n";
    sMsg = sMsg + "- any healing, raise, or rez will stabilize a player.\n";
    if ( HABD_ONENTER_INSTANTBLEED == TRUE )    sMsg = sMsg + "- If you stay logged out too much time while bleeding, you'll bleed and stabilize/death at the instant you log in.\n";
    if (HABD_NERF_REGENERATION_ITEMS) sMsg = sMsg + "- regeneration items are unequipped so that they do not prevent you from dying.\n";
    else sMsg = sMsg + "- regeneration items keep you from ever dying.\n";
    if (HABD_POST_BLEED_INVIS_DUR > 0.0) sMsg = sMsg + "- you have "+FloatToString(HABD_POST_BLEED_INVIS_DUR,3,1)+" seconds of free movement after stabilization.\n";
    else sMsg = sMsg + "- monsters can see you to attack you as soon as you stabilize.\n";
    SendMessageToPC(oPC, sMsg);

    sMsg = "DEATH RULES:\n";
    if (HABD_SOLO_FORCE_RAISE_TIMER > 0.0) sMsg = sMsg + "- raise dead is forced for solo players when dead for more than "+FloatToString(HABD_SOLO_FORCE_RAISE_TIMER, 3,0)+" seconds.\n";
    else sMsg = sMsg + "- there is no solo player forced raise.\n";
    if (HABD_FORCE_RAISE_TIMER > 0.0) sMsg = sMsg + "- raise dead is forced when dead for more than "+FloatToString(HABD_FORCE_RAISE_TIMER, 3,0)+" seconds.\n";
    else sMsg = sMsg + "- there is no party player forced raise.\n";
    if (HABD_NPC_FORCE_RAISE_TIMER > 0.0) sMsg = sMsg + "- raise dead is forced for henchmen when dead for more than "+FloatToString(HABD_NPC_FORCE_RAISE_TIMER, 3,0)+" seconds.\n";
    else sMsg = sMsg + "- there is no henchmen forced raise.\n";
    if (HABD_FORCE_RAISE_USES_SCROLLS) sMsg = sMsg + "- forced raise uses raise dead/resurrection scrolls. If you run out you will not be raised.\n";
    if (HABD_FORCE_RESPAWN_TIMER > 0.0) sMsg = sMsg + "- respawn is forced when dead for more than "+FloatToString(HABD_FORCE_RESPAWN_TIMER, 3,0)+" seconds.\n";
    else sMsg = sMsg + "- there is no forced respawn.\n";
    if (HABD_NPC_FORCE_RESPAWN_TIMER > 0.0) sMsg = sMsg + "- respawn is forced for henchmen when dead for more than "+FloatToString(HABD_NPC_FORCE_RESPAWN_TIMER, 3,0)+" seconds.\n";
    else sMsg = sMsg + "- there is no henchmen forced respawn.\n";
    SendMessageToPC(oPC, sMsg);

    sMsg = "PENALTIES:\n";
    sMsg = sMsg + "- respawn has a "+IntToString(HABD_RESPAWN_XP_LOSS)+"% XP and "+IntToString(HABD_RESPAWN_GP_LOSS)+"% GP penalty ("+IntToString(HABD_RESPAWN_XP_LOSS*nPenalty)+" XP and "+IntToString(HABD_RESPAWN_GP_LOSS*iGP/100)+" GP for you).\n";
    sMsg = sMsg + "- raise dead has a "+IntToString(HABD_RAISE_XP_LOSS)+"% XP and "+IntToString(HABD_RAISE_GP_LOSS)+"% GP penalty ("+IntToString(HABD_RAISE_XP_LOSS*nPenalty)+" XP and "+IntToString(HABD_RAISE_GP_LOSS*iGP/100)+" GP for you).\n";
    sMsg = sMsg + "- resurrection has a "+IntToString(HABD_REZ_XP_LOSS)+"% XP and "+IntToString(HABD_REZ_GP_LOSS)+"% GP penalty ("+IntToString(HABD_REZ_XP_LOSS*nPenalty)+" XP and "+IntToString(HABD_REZ_GP_LOSS*iGP/100)+" GP for you).\n";
    if (HABD_NO_LEVEL_LOSS_FROM_XP_PENALTY) sMsg = sMsg + "- XP penalty CANNOT cause level loss.\n";
    else sMsg = sMsg + "- XP penalty CAN cause level loss.\n";
    if (HABD_MAX_GP_LOSS_FROM_GP_PENALTY > 0) sMsg = sMsg + "- GP penalty is capped at "+IntToString(HABD_MAX_GP_LOSS_FROM_GP_PENALTY)+" GP.\n";
    else sMsg = sMsg + "- is NOT capped.\n";
    SendMessageToPC(oPC, sMsg);

    sMsg = "ITEM DROPPING ON DEATH:\n";
    if ((HABD_DROP_GOLD == 0) &&
        (HABD_DROP_RAISE_REZ == 0) &&
        (HABD_DROP_BACKPACK == 0) &&
        (HABD_DROP_WEAPON_SHIELD == 0) &&
        (HABD_DROP_EQUIPPED == 0) &&
        (HABD_DROP_RANDOM_EQUIPPED == 0) &&
        (HABD_DROP_RANDOM_BACKPACK == 0) &&
        (HABD_DROP_MOST_EXPENSIVE_EQUIPPED == 0) &&
        (HABD_DROP_MOST_EXPENSIVE_BACKPACK == 0)
       ) sMsg = sMsg + "- there is no item dropping/destruction on death.\n";
    if (HABD_DROP_GOLD > 0) sMsg = sMsg + "- all gold is "+HABDGetDropType(HABD_DROP_GOLD)+" on death.\n";
    if (HABD_DROP_WEAPON_SHIELD > 0) sMsg = sMsg + "- equipped left and right hand items are "+HABDGetDropType(HABD_DROP_WEAPON_SHIELD)+" on death.\n";
    if (HABD_DROP_RANDOM_EQUIPPED > 0) sMsg = sMsg + "- a random equipped item is "+HABDGetDropType(HABD_DROP_RANDOM_EQUIPPED)+" on death.\n";
    if (HABD_DROP_MOST_EXPENSIVE_EQUIPPED > 0) sMsg = sMsg + "- most expensive equipped item is "+HABDGetDropType(HABD_DROP_MOST_EXPENSIVE_EQUIPPED)+" on death.\n";
    if (HABD_DROP_EQUIPPED > 0) sMsg = sMsg + "- all equipped items are "+HABDGetDropType(HABD_DROP_EQUIPPED)+" on death.\n";
    if (HABD_DROP_RAISE_REZ > 0) sMsg = sMsg + "- raise dead/resurrection scrolls are "+HABDGetDropType(HABD_DROP_RAISE_REZ)+" on death.\n";
    if (HABD_DROP_RANDOM_BACKPACK > 0) sMsg = sMsg + "- a random backpack item is "+HABDGetDropType(HABD_DROP_RANDOM_BACKPACK)+" on death.\n";
    if (HABD_DROP_MOST_EXPENSIVE_BACKPACK > 0) sMsg = sMsg + "- most expensive backpack item is "+HABDGetDropType(HABD_DROP_MOST_EXPENSIVE_BACKPACK)+" on death.\n";
    if (HABD_DROP_BACKPACK > 0) sMsg = sMsg + "- all backpack items are "+HABDGetDropType(HABD_DROP_BACKPACK)+" on death.\n";
    SendMessageToPC(oPC, sMsg);

    sMsg = "RESPAWN:\n";
    if (HABD_RESPAWN_ALLOWED)
    {
        if (HABD_INSTANT_RESPAWN_ALLOWED) sMsg = sMsg + "- player controlled respawn IS allowed.\n";
        else sMsg = sMsg + "- player controlled respawn NOT allowed.\n";
        if (HABD_RESPAWN_SCRIPT == "habd_onpcrespawn")
        {
            sMsg = sMsg + "- on respawn you will become a ghost and lose control of your player.\n";
            if (HABD_GHOST_EFFECTS_ON == FALSE ) sMsg = sMsg + "- some ghost effects are not applied: You can be hurt, you can move, no VFX.\n";
            sMsg = sMsg + "- other players can use bandages on your ghost to lead you to help.\n";
            sMsg = sMsg + "- raise or rez will bring the ghost back to life.\n";
            if ( HABD_DROP_CORPSE_ITEM == TRUE ) sMsg = sMsg + "- when respawn, you will drop a corpse item. It can be carried and raised by other PCs and NPC.\n";
            if ( HABD_DROP_CORPSE_ITEM == TRUE && HABD_RAISE_LOGOUT_PLAYERS == TRUE)
                sMsg = sMsg + "- using the corpse item, Players can be raised even when they are not loged-in the server.\n";
            if ( HABD_RESPAWNPOINT != "" ) sMsg = sMsg + "- you will respawn at a location, based on a Waypoint.\n";
            if ( HABD_BINDSTONE_USEWHENRESPAWNED ) sMsg = sMsg + "- you will respawn at a variable location, based on a Bindstone/Trigger system.\n";
            if ( HABD_PERMADEATH_LOCATION != "" ) sMsg = sMsg + "- Permadeath seems allowed. Custom Permadeath Rules (unknown).\n";
            if (HABD_HENCHMEN_GHOST_RESPAWN) sMsg = sMsg + "- same respawn system is used for henchmen.\n";
            else sMsg = sMsg + "- custom respawn system used for henchmen (unknown).\n";
        } else sMsg = sMsg + "- custom respawn system used (unknown).\n";
    } else sMsg = sMsg + "- respawn is NOT allowed.\n";
    SendMessageToPC(oPC, sMsg);

    if (
        (HABD_USERDEFINED_BLEED_DESC != "") ||
        (HABD_USERDEFINED_RESPAWN_DESC != "") ||
        (HABD_USERDEFINED_RAISE_DESC != "") ||
        (HABD_USERDEFINED_RESURRECTION_DESC != "")
        )
    {
        sMsg = "ADDITIONAL:\n";
        if (HABD_USERDEFINED_BLEED_DESC != "") sMsg = sMsg+"OnBleedStabilized: "+HABD_USERDEFINED_BLEED_DESC+"\n";
        if (HABD_RESPAWN_SCRIPT == "habd_onpcrespawn")
        {
            if (HABD_USERDEFINED_RESPAWN_DESC != "") sMsg = sMsg+"OnRespawned: "+HABD_USERDEFINED_RESPAWN_DESC+"\n";
        }
        if (HABD_USERDEFINED_RAISE_DESC != "") sMsg = sMsg+"OnRaised: "+HABD_USERDEFINED_RAISE_DESC+"\n";
        if (HABD_USERDEFINED_RESURRECTION_DESC != "") sMsg = sMsg+"OnRezzed: "+HABD_USERDEFINED_RESURRECTION_DESC+"\n";
        SendMessageToPC(oPC, sMsg);
    }
}

// ****************************************************************************

// OnActivateItem event handler. Runs the corresponding functionality based on
// the item's tag.
//   oPC - the player activating the item.
//   oTarget - the player's target.
//   oItem - the item they activated.
int HABDOnActivateItem(object oPC, object oTarget, object oItem);

int HABDOnActivateItem(object oPC, object oTarget, object oItem)
{
    string sTag = GetTag(oItem);
    string sResRef = GetResRef(oItem);
    // Have bandages at the top since they are usually time critical.
    if (sTag == HABD_ITEM_BANDAGES)
    {
        HABDItemBandages(oPC, oTarget,0);
        return TRUE;
    }
    if (sTag == HABD_ITEM_BANDAGESPLUS2)
    {
        HABDItemBandages(oPC, oTarget,2);
        return TRUE;
    }
    if (sTag == HABD_ITEM_BANDAGESPLUS5)
    {
        HABDItemBandages(oPC, oTarget,5);
        return TRUE;
    }
    if (sTag == HABD_ITEM_DM_DEATH)
    {
        HABDItemDMDeath(oPC, oTarget, oItem);
        return TRUE;
    }
    if (sTag == HABD_ITEM_TOKEN)
    {
        HABDItemToken(oPC);
        return TRUE;
    }
    if (sTag == HABD_ITEM_DM_TOKEN)
    {
        HABDItemDMToken(oPC, oTarget, oItem);
        return TRUE;
    }
    if (sTag == HABD_ITEM_RULES)
    {
        HABDItemRules(oPC);
        return TRUE;
    }
     if (sResRef == HABD_CORPSEITEM_FEM_RESREF || sResRef == HABD_CORPSEITEM_MALE_RESREF)
    {
        if(HABD_USERLANGUAGE==0)
            SendMessageToPC(oPC,"Dead PC name was: "+GetLocalString(oItem, HABD_CORPSE_OWNER_PCNAME));
        else if(HABD_USERLANGUAGE==1)
            SendMessageToPC(oPC,"El nombre del PJ muerto era: "+GetLocalString(oItem, HABD_CORPSE_OWNER_PCNAME));
        return TRUE;
    }
    return FALSE;
}

// ****************************************************************************



// TakeEnterItems(oPlayer,sItem, ByTag=FALSE)
// If the Player has the object said in inventory, it destroys them all
// sItem = resref, , if you indicate ByTag (optional) as TRUE, it
// uses sItem as Tag.
void HABDTakePCItems(object oPlayer, string sItem, int ByTag = FALSE);

void HABDTakePCItems(object oPlayer, string sItem, int ByTag = FALSE)
{
 // Check if oPlayer already have item.
 object oItemPC = GetFirstItemInInventory(oPlayer);
 object oItemC = OBJECT_INVALID;
 string sTagorResref="";

 while ( GetIsObjectValid(oItemPC) )
 {
    if (ByTag == FALSE)
        sTagorResref = GetResRef(oItemPC);
            else
                sTagorResref = GetTag(oItemPC);
  if ( sTagorResref == sItem )
   {
     DestroyObject(oItemPC);
   }
    //if it is not the item, check if it is a container and look inside
    else
    if ( GetHasInventory(oItemPC) == TRUE )
    {
        oItemC = GetFirstItemInInventory(oItemPC);
        sTagorResref="";
        while ( GetIsObjectValid(oItemC) )
        {
            if (ByTag == FALSE)
                sTagorResref = GetResRef(oItemC);
                    else
                        sTagorResref = GetTag(oItemC);
            if ( sTagorResref == sItem )
            {
                DestroyObject(oItemC);
            }
            oItemC = GetNextItemInInventory(oItemPC);
        }
    }
    //end of container checks

  oItemPC = GetNextItemInInventory(oPlayer);
 }

}

// ****************************************************************************



// Creates a dead clon of the PC in the actual PC location, gold and backpack
// items are removed from the clon, is set friendly to all standar factions,
// equipped items are cursed and undroppable. The corpse can be seen (and using
// Tab players can see the name of the clon), but the corpse is not selectable
object HABDCreatePCDeadClon(object oPC);
object HABDCreatePCDeadClon(object oPC)
{
        object oClon = CopyObject(oPC, GetLocation(oPC));
        ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDeath(FALSE,FALSE),oClon);
        SetPlotFlag(oClon, TRUE); //avoid the clon to be destroyed
        AssignCommand( oClon, SetIsDestroyable(FALSE,FALSE,FALSE));
        SetStandardFactionReputation(STANDARD_FACTION_COMMONER,100,oClon);
        SetStandardFactionReputation(STANDARD_FACTION_DEFENDER,100,oClon);
        SetStandardFactionReputation(STANDARD_FACTION_HOSTILE,100,oClon);
        SetStandardFactionReputation(STANDARD_FACTION_MERCHANT,100,oClon);
        //Destroy Not visible objects from the clon, avoid problems.
        //destroy Gold
        AssignCommand(oPC, TakeGoldFromCreature(GetGold(oClon), oClon,TRUE));
        //destroy Backpack items
        object oItem = GetFirstItemInInventory(oClon);
        while (oItem != OBJECT_INVALID)
        {
            DestroyObject(oItem);
            oItem = GetNextItemInInventory(oClon);
        }
        //Make clon equipped items undroppable
        int i;
        for (i=0; i<NUM_INVENTORY_SLOTS; i++)
        {
            oItem = GetItemInSlot(i, oClon);
            if (GetIsObjectValid(oItem) )
            {
                SetDroppableFlag(oItem, FALSE);
                SetItemCursedFlag(oItem, TRUE);
            }
        }
        return oClon;
}


// This function is used to create a pseudo-heartbeat on the death bag placeable
// that contains all of the dropped items on player death.
// iCounter is used to know how many times this process has been fired, in order
// to control the number of Messages shown (and the total time, if needed)
void HABDDeathBagHeartbeat (int iCounter = 0);

void HABDDeathBagHeartbeat (int iCounter = 0)
{
    // float iTotalTime = HABD_BAG_SELF_DESTRUCT_TIMER * IntToFloat(iCounter);
    if (GetIsObjectValid(GetFirstItemInInventory()))
    {
        // Set up timer.
        DelayCommand(HABD_BAG_SELF_DESTRUCT_TIMER, HABDDeathBagHeartbeat(iCounter+1));
        // Try to alert the owner.
        object oPC = GetLocalObject(OBJECT_SELF, HABD_BAG_OWNER);
        if (GetIsObjectValid(oPC) )
        {
            if (iCounter % HABD_BAG_LOOTMESSAGE_FREQ == 0) //time to show the Msg?
            {
              if (GetLocalInt(OBJECT_SELF, HABD_NPC_BLEED) == 1)
                {
                if(HABD_USERLANGUAGE==0)
                    FloatingTextStringOnCreature("OOC: Your henchman/companion still has items in its death bag.", GetMaster(oPC), FALSE);
                else if(HABD_USERLANGUAGE==1)
                    FloatingTextStringOnCreature("OOC: Tu escudero/camarada todavia tiene objetos en su contenedor de muerte.", GetMaster(oPC), FALSE);
                }
              else
                {
                if(HABD_USERLANGUAGE==0)
                    FloatingTextStringOnCreature("OOC: You still have items in your death bag.", oPC, FALSE);
                else if(HABD_USERLANGUAGE==1)
                    FloatingTextStringOnCreature("OOC: Todavia tienes objetos en tu contenedor de muerte.", oPC, FALSE);
                }
            }
        } else {
            // No valid owner, so destroy the variable.
            // Better not, because GetIsObjectValid return FALSE if the PC logs
            // out, but can login.. and we need the object to deal with other
            // things.
            //DeleteLocalObject(OBJECT_SELF, HABD_BAG_OWNER);
        }
    } else {
        // No valid items left inside, so self-destruct.
        SetPlotFlag(OBJECT_SELF, FALSE);
            //Destroy the PC Dead Clon
            object oClon = GetLocalObject(OBJECT_SELF, HABD_BAG_PCDEADCLON);
            if (oClon !=OBJECT_INVALID)
                {
                SetPlotFlag(oClon, FALSE);
                //if it is not set as destroyable-TRUE, the clon  will not be
                //destroyed by DestroyObject function.
                AssignCommand( oClon, SetIsDestroyable(TRUE,FALSE,FALSE));
                DestroyObject(oClon);
                }
        DestroyObject(OBJECT_SELF);
    }
}


// Creates the DeathBag, and the PCDeadClon if needed.
object HABDCreateDeathBag(object oPC);
object HABDCreateDeathBag(object oPC)
{
        // Create the bag and set up a heartbeat on it.
        object oBag = CreateObject(OBJECT_TYPE_PLACEABLE, HABD_PLACEABLE_BAG, GetLocation(oPC), TRUE);
        // Sanity test. I think it is not robust, but there is no known problems
        if (!GetIsObjectValid(oBag))
            {
                WriteTimestampedLogEntry ("HABD Error in function HABDCreateDeathBag, oBag Death Bag was not Valid? Items were not dropped for "+GetName(oPC)+" Player "+GetPCPlayerName(oPC) );
                string sErMsg = "HABD Error in function HABDCreateDeathBag, oBag Death Bag was not Valid? Items were not dropped for "+GetName(oPC)+" Player "+GetPCPlayerName(oPC);
                if(HABD_USERLANGUAGE==0)
                   sErMsg = "HABD Error in function HABDCreateDeathBag, oBag Death Bag was not Valid? Items were not dropped for "+GetName(oPC)+" Player "+GetPCPlayerName(oPC);
                else if(HABD_USERLANGUAGE==1)
                   sErMsg = "HABD Error en funcion HABDCreateDeathBag, oBag Contenedor de Muerte no era valido? Los objetos no fueron desprendidos para "+GetName(oPC)+" Jugador "+GetPCPlayerName(oPC);
                SendMessageToAllDMs (sErMsg);
                SendMessageToPC (oPC, sErMsg);
            }
        //Create the PC Dead Clon
        object oClon = OBJECT_INVALID;
        if (HABD_RESPAWN_PCDEADCLON == TRUE)
            oClon = HABDCreatePCDeadClon(oPC);

        SetLocalObject(oBag, HABD_BAG_OWNER, oPC); //store the owner of the bag in the deathbag (object id)
        SetLocalString(oBag, HABD_BAG_OWNER_NAME, GetName(oPC)); //store the owner PC name

        if (oClon != OBJECT_INVALID)
            SetLocalObject(oBag, HABD_BAG_PCDEADCLON, oClon); //store the PC dead clon object id

        //PseudoHeartBeat
        AssignCommand(oBag, DelayCommand(HABD_BAG_SELF_DESTRUCT_TIMER, HABDDeathBagHeartbeat()));

        return oBag;
}

// ****************************************************************************


// GetGoldPieceValue returns the price of the base item (usualli 1 gp) for
// unidentified items (at least from 1.61 to 1.64 patches). This will get the
// identified value of oItem (from nwnlexicon)
// Note, that function should not be edited to get the UNidentified cost of the
// item, since unidentifying an item will most likely cause equipped items to
// get unequipped.
int HABDGetGPValue(object oItem);

int HABDGetGPValue(object oItem)
{
    // Initial flag
    int bIdentified=GetIdentified(oItem);
    // If not already, set to identified
    if (!bIdentified) SetIdentified(oItem, TRUE);
    // Get the GP value
    int nGP=GetGoldPieceValue(oItem);
    // Re-set the identification flag to its original
    if (!bIdentified) SetIdentified(oItem, bIdentified);
    // Return the correct value
    return nGP;
}


// Takes an Item to oBag, even if it is a Plot Item.
// We dont use the CopyItem() function because it can not copy containers, is not
// pre 1.62 compatible, and has some other bugs and limitations.
void HABDTakeItem(object oItem, object oPC, object oBag);

void HABDTakeItem(object oItem, object oPC, object oBag)
{
    if( GetPlotFlag(oItem) == FALSE )
        AssignCommand(oBag, ActionTakeItem(oItem, oPC));
    else
    {
        SetPlotFlag(oItem, FALSE);
        AssignCommand(oBag, ActionTakeItem(oItem, oPC));
        AssignCommand(oBag, DelayCommand(0.5, SetPlotFlag(oItem, TRUE))  );
    }
}

// Cheks if an item is cursed, and so, if it must be dropped
// DELETE this functions and all the calls to the function, if you are using
// a pre 1.62 NWN patch (because you dont have the GetItemCursedFlag() or
// the cursed flag available).
// If it is too much work, simply make it always return TRUE.
int HABDDropCursed (object oItem);

int HABDDropCursed (object oItem)
{
    //uncomment if you use a pre 1.60 patch, and delete the rest of the function
    //return TRUE;
    if (HABD_DROP_CURSED_ITEMS ==2) return 2;
    if (HABD_DROP_CURSED_ITEMS ==TRUE) return TRUE;
    if (HABD_DROP_CURSED_ITEMS == FALSE && GetItemCursedFlag(oItem) )
        return FALSE;
        else
        return TRUE;
    return TRUE;
}

// Checks the flags of the items and the configuration constants of HABD, then
// it determines if the item can be dropped or destroyed. FALSE: Non drop or
// destroy, 1=Drop, 2=Drop and Destroy are allowed.
// Note that it doesnot check if the item is Valid, for performance reasons.
int HABDItemDroppable (object oItem);

int HABDItemDroppable (object oItem)
{
    //normal items can be destroyed and dropped
    int iDrop = 2;
    //first, check Cursed Flag
    int i = HABDDropCursed(oItem);
    if ( i < iDrop )
        iDrop = i;
    //now check the Plot Flag.
    if ( HABD_DROP_PLOT_ITEMS <2 ) //check if the constant indicates any limit
    if ( GetPlotFlag(oItem) )
    {
        if( HABD_DROP_PLOT_ITEMS < iDrop)
            iDrop = HABD_DROP_PLOT_ITEMS;
    }

    return iDrop;   //return the most restrictive condition
}

// Creates a placeable object and drops all the items into it based on the
// configured options.
//   oPC - the dead player who is losing their items.
// Notes: ActionTakeItem(oItem, oPC), will not work with Plot Items :(. In this
// case we need a NWN 1.60 patch function. CopyItem().
void HABDDropItems (object oPC);

void HABDDropItems (object oPC)
{
    object oItem;
    // Check that something is configured to drop.
    if ((HABD_DROP_GOLD == 0) &&
        (HABD_DROP_RAISE_REZ == 0) &&
        (HABD_DROP_BACKPACK == 0) &&
        (HABD_DROP_WEAPON_SHIELD == 0) &&
        (HABD_DROP_EQUIPPED == 0) &&
        (HABD_DROP_RANDOM_EQUIPPED == 0) &&
        (HABD_DROP_RANDOM_BACKPACK == 0) &&
        (HABD_DROP_MOST_EXPENSIVE_EQUIPPED == 0) &&
        (HABD_DROP_MOST_EXPENSIVE_BACKPACK == 0)
       ) return;

    object oBag;

    //Check that we have a valid location to drop the items and create the
    //Death Bag. Else delay the function.
    if ( GetIsObjectValid ( GetArea(oPC)) == FALSE )
    {
        DelayCommand(1.0, HABDDropItems(oPC) );
        return;
    }

    // Only build the placeable if something is configured to drop.
    if ((HABD_DROP_GOLD == 1) ||
        (HABD_DROP_RAISE_REZ == 1) ||
        (HABD_DROP_BACKPACK == 1) ||
        (HABD_DROP_WEAPON_SHIELD == 1) ||
        (HABD_DROP_EQUIPPED == 1) ||
        (HABD_DROP_RANDOM_EQUIPPED == 1) ||
        (HABD_DROP_RANDOM_BACKPACK == 1) ||
        (HABD_DROP_MOST_EXPENSIVE_EQUIPPED == 1) ||
        (HABD_DROP_MOST_EXPENSIVE_BACKPACK == 1)
       )
    {
        oBag = HABDCreateDeathBag(oPC);
         // Sanity test. I think it is not robust, but there is no known problems
         if (!GetIsObjectValid(oBag))
            {
                WriteTimestampedLogEntry ("HABD Error in function HABDDropItems, oBag Death Bag was not Valid? Items were not dropped for "+GetName(oPC)+" Player "+GetPCPlayerName(oPC) );
                string sErMsg = "HABD Error in function HABDDropItems, oBag Death Bag was not Valid? Items were not dropped for "+GetName(oPC)+" Player "+GetPCPlayerName(oPC);
                if(HABD_USERLANGUAGE==0)
                   sErMsg = "HABD Error in function HABDDropItems, oBag Death Bag was not Valid? Items were not dropped for "+GetName(oPC)+" Player "+GetPCPlayerName(oPC);
                else if(HABD_USERLANGUAGE==1)
                   sErMsg = "HABD Error en funcion HABDDropItems, oBag Contenedor de Muerte no era valido? Los objetos no fueron desprendidos para "+GetName(oPC)+" Jugador "+GetPCPlayerName(oPC);
                SendMessageToAllDMs (sErMsg);
                SendMessageToPC (oPC, sErMsg);
                return;
            }
    }

    // Should we drop all gold?
    if (HABD_DROP_GOLD != 0)
    {
        if (HABD_DROP_GOLD == 2)
        {
            if(HABD_USERLANGUAGE==0)
                SendMessageToPC(oPC, "Destroying all gold.");
            else if(HABD_USERLANGUAGE==1)
                SendMessageToPC(oPC, "Destruyendo todo el dinero.");
        }
        else
        {
            if(HABD_USERLANGUAGE==0)
                SendMessageToPC(oPC, "Dropping all gold.");
            else if(HABD_USERLANGUAGE==1)
                SendMessageToPC(oPC, "Tirando al suelo todo el dinero.");
        }

        if (HABD_DROP_GOLD == 2) TakeGoldFromCreature(GetGold(oPC), oPC, TRUE);
        else AssignCommand(oBag, TakeGoldFromCreature(GetGold(oPC), oPC));
    }

    // Should we only drop the right hand and left hand equipped items.
    if (HABD_DROP_WEAPON_SHIELD != 0)
    {
        if (HABD_DROP_WEAPON_SHIELD == 2)
        {
            if(HABD_USERLANGUAGE==0)
            SendMessageToPC(oPC, "Destroying equipped weapon and shield.");
            else if(HABD_USERLANGUAGE==1)
            SendMessageToPC(oPC, "Destruyendo el arma y escudo equipado.");
        }
        else
        {
            if(HABD_USERLANGUAGE==0)
            SendMessageToPC(oPC, "Dropping equipped weapon and shield.");
            else if(HABD_USERLANGUAGE==1)
            SendMessageToPC(oPC, "Tirando al suelo el arma y escudo equipados.");
        }

        oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
        if (GetIsObjectValid(oItem) )
        {
            if (HABD_DROP_WEAPON_SHIELD == 2 && HABDItemDroppable(oItem)>=2 )
                DestroyObject(oItem);
            if (HABD_DROP_WEAPON_SHIELD == 1 && HABDItemDroppable(oItem)>=1 )
                HABDTakeItem(oItem, oPC, oBag);
        }
        oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
        if (GetIsObjectValid(oItem) && HABDDropCursed(oItem)   )
        {
            if (HABD_DROP_WEAPON_SHIELD == 2 && HABDItemDroppable(oItem)>=2 )
                DestroyObject(oItem);
            if (HABD_DROP_WEAPON_SHIELD == 1 && HABDItemDroppable(oItem)>=1 )
                HABDTakeItem(oItem, oPC, oBag);
        }
    }

    // Should we drop a random equipped item?
    // Note, that the random and most expensive can be the same item (then
    // only one item is dropped)
    if ((HABD_DROP_RANDOM_EQUIPPED != 0) || (HABD_DROP_MOST_EXPENSIVE_EQUIPPED != 0 ))
    {
        int iRandomEquipped;
        int i;
        int iRandomCount = 0;
        int iMostValueCount = 0;
        int iGP = 0;
        int iHighestGP = 0;
        int iHighestGPPos = 0;
        int iDrop = 2;

        if (HABD_DROP_RANDOM_EQUIPPED == 2)
        {
            if(HABD_USERLANGUAGE==0)
            SendMessageToPC(oPC, "Destroying a random equipped items.");
            else if(HABD_USERLANGUAGE==1)
            SendMessageToPC(oPC, "Destruyendo un objeto equipado aleatorio.");
        }
        else if (HABD_DROP_RANDOM_EQUIPPED == 1)
        {
            if(HABD_USERLANGUAGE==0)
            SendMessageToPC(oPC, "Dropping a random equipped items.");
            else if(HABD_USERLANGUAGE==1)
            SendMessageToPC(oPC, "Tirando al suelo un objeto equipado aleatorio.");
        }
        if (HABD_DROP_MOST_EXPENSIVE_EQUIPPED == 2)
        {
            if(HABD_USERLANGUAGE==0)
            SendMessageToPC(oPC, "Destroying most expensive equipped items.");
            else if(HABD_USERLANGUAGE==1)
            SendMessageToPC(oPC, "Destruyendo el objeto equipado mas caro.");
        }
        else if (HABD_DROP_MOST_EXPENSIVE_EQUIPPED == 1)
        {
            if(HABD_USERLANGUAGE==0)
            SendMessageToPC(oPC, "Dropping most expensive equipped items.");
            else if(HABD_USERLANGUAGE==1)
            SendMessageToPC(oPC, "Tirando al suelo el objeto equipado mas caro.");
        }

        // Find the random item. First count how many items we can drop/destroy,
        // and where is the most valuable (and droppable/destr) item.
        for (i=0; i<NUM_INVENTORY_SLOTS; i++)
        {
            oItem = GetItemInSlot(i, oPC);
            //Containers and scrolls cannot be equiped (I hope)
            if (GetIsObjectValid(oItem))
            {
                iDrop = HABDItemDroppable(oItem);
                if ( iDrop >= HABD_DROP_RANDOM_EQUIPPED)
                    iRandomCount++;
                if ( iDrop >= HABD_DROP_MOST_EXPENSIVE_EQUIPPED )
                {
                    // Increment the number of random items and check
                    // for the highest GP item.
                    iMostValueCount++;
                    iGP = HABDGetGPValue(oItem);
                    if (iGP > iHighestGP)
                    {
                        iHighestGP = iGP;
                        iHighestGPPos = iMostValueCount;
                    }
                }
            }
        }
        iRandomEquipped = Random(iRandomCount)+1;
        iRandomCount = 0;
        iMostValueCount = 0;
        // Drop the item. Note that non droppable/destroyable items are skipped
        for (i=0; i<NUM_INVENTORY_SLOTS; i++)
        {
            oItem = GetItemInSlot(i, oPC);
            if (GetIsObjectValid(oItem) )
            {
                iDrop = HABDItemDroppable(oItem);
                // Search the random item
                if (HABD_DROP_RANDOM_EQUIPPED != 0)
                if (iDrop>=HABD_DROP_RANDOM_EQUIPPED)
                {
                    iRandomCount++;
                    // If this is the random item then drop it.
                    if ( iRandomCount == iRandomEquipped )
                    {
                      if (HABD_DROP_RANDOM_EQUIPPED == 2) DestroyObject(oItem);
                      if (HABD_DROP_RANDOM_EQUIPPED == 1) HABDTakeItem(oItem, oPC, oBag);
                    }
                }
                // Search the most expensive item
                if (HABD_DROP_MOST_EXPENSIVE_EQUIPPED != 0)
                if (iDrop>=HABD_DROP_MOST_EXPENSIVE_EQUIPPED)
                {
                    iMostValueCount++;
                    // If this is the most expensive item then drop it.
                    if ( iMostValueCount == iHighestGPPos )
                    {
                      if (HABD_DROP_MOST_EXPENSIVE_EQUIPPED == 2) DestroyObject(oItem);
                      if (HABD_DROP_MOST_EXPENSIVE_EQUIPPED == 1) HABDTakeItem(oItem, oPC, oBag);
                    }
                }
            }
        }
    }

    // Should we drop all equiped items?
    if (HABD_DROP_EQUIPPED != 0)
    {
        int iDrop = 2;
        int i;

        if (HABD_DROP_EQUIPPED == 2)
        {
            if(HABD_USERLANGUAGE==0)
            SendMessageToPC(oPC, "Destroying all equipped items.");
            else if(HABD_USERLANGUAGE==1)
            SendMessageToPC(oPC, "Destruyendo todos los objetos equipados.");
        }
        else
        {
            if(HABD_USERLANGUAGE==0)
            SendMessageToPC(oPC, "Dropping all equipped items.");
            else if(HABD_USERLANGUAGE==1)
            SendMessageToPC(oPC, "Tirando al suelo todos los objetos equipados.");
        }

        for (i=0; i<NUM_INVENTORY_SLOTS; i++)
        {
            oItem = GetItemInSlot(i, oPC);
            if (GetIsObjectValid(oItem) )
            {
                iDrop = HABDItemDroppable(oItem);
                if (HABD_DROP_EQUIPPED==2 && iDrop>=2) DestroyObject(oItem);
                if (HABD_DROP_EQUIPPED==1 && iDrop>=1) HABDTakeItem(oItem, oPC, oBag);
            }
        }
    }//----


    // Should we only drop raise/rez scrolls in inventory?
    // If they are needed for autoraise, dont drop the scrolls
    if ((HABD_DROP_RAISE_REZ != 0) && (!HABD_FORCE_RAISE_USES_SCROLLS))
    {
        int iDrop = 2;

        if (HABD_DROP_RAISE_REZ == 2)
        {
            if(HABD_USERLANGUAGE==0)
            SendMessageToPC(oPC, "Destroying all Raise Dead/Resurrection scrolls.");
            else if(HABD_USERLANGUAGE==1)
            SendMessageToPC(oPC, "Destruyendo todos los pergaminos de Reanimar Muerto/Resurrecion.");
        }
        else
        {
            if(HABD_USERLANGUAGE==0)
            SendMessageToPC(oPC, "Dropping all Raise Dead/Resurrection scrolls.");
            else if(HABD_USERLANGUAGE==1)
            SendMessageToPC(oPC, "Tirando al suelo todos los pergaminos de Reanimar Muerto/Resurrecion.");
        }

        int iBaseItemType;
        object oContainerItem;
        oItem = GetFirstItemInInventory(oPC);
        while (GetIsObjectValid(oItem))
        {
          //is not a container
          if (GetFirstItemInInventory(oItem) == OBJECT_INVALID)
          {
            // Search through the scrolls
            iBaseItemType = GetBaseItemType(oItem);
            if ((iBaseItemType == BASE_ITEM_SCROLL) ||
                (iBaseItemType == BASE_ITEM_SPELLSCROLL))
            {
                // Default scrolls cannot be made plot so don't worry about it.
                // But custom scrolls can made plot!! worry about it!
                // See if it matches the tags we are looking for.
                if (FindSubString(HABD_SCROLL_TAGS, ":"+GetTag(oItem)+":") != -1)
                {
                    iDrop = HABDItemDroppable(oItem);
                    if (HABD_DROP_RAISE_REZ == 2 &&  iDrop>=2 )
                        DestroyObject(oItem);
                    if (HABD_DROP_RAISE_REZ == 1 &&  iDrop>=1 )
                    {
                        //AssignCommand(oBag, ActionTakeItem(oItem, oPC)); //it does not take plot items
                        HABDTakeItem(oItem, oPC, oBag);
                    }
                }
            }
          }
          //is a container, loop inside the container
          else
          {
            oContainerItem = GetFirstItemInInventory(oItem);
            while (GetIsObjectValid(oContainerItem))
            {
                // Search through the scrolls
                iBaseItemType = GetBaseItemType(oContainerItem);
                if ((iBaseItemType == BASE_ITEM_SCROLL) ||
                    (iBaseItemType == BASE_ITEM_SPELLSCROLL))
                {
                  // Default scrolls cannot be made plot so don't worry about it.
                  // But custom scrolls can made plot!! worry about it!
                  // See if it matches the tags we are looking for.
                  if (FindSubString(HABD_SCROLL_TAGS, ":"+GetTag(oContainerItem)+":") != -1)
                  {
                    iDrop = HABDItemDroppable(oContainerItem);
                    if (HABD_DROP_RAISE_REZ == 2 &&  iDrop>=2 )
                        DestroyObject(oItem);
                    if (HABD_DROP_RAISE_REZ == 1 &&  iDrop>=1 )
                    {
                        //AssignCommand(oBag, ActionTakeItem(oItem, oPC)); //it does not take plot items
                        HABDTakeItem(oContainerItem, oItem, oBag);
                    }
                  }
                }
                oContainerItem = GetNextItemInInventory(oItem);
             }
          }//end of container tasks
            oItem = GetNextItemInInventory(oPC);
        }//end of while
    }//----


    // Should we drop a random backpack item?
    if ((HABD_DROP_RANDOM_BACKPACK != 0) || (HABD_DROP_MOST_EXPENSIVE_BACKPACK != 0))
    {
        int iRandomBackpack;
        int iGP = 0;
        int iHighestGP = 0;
        int iHighestGPPos = 0;

        if (HABD_DROP_RANDOM_BACKPACK == 2)
        {
            if(HABD_USERLANGUAGE==0)
            SendMessageToPC(oPC, "Destroying a random backpack item.");
            else if(HABD_USERLANGUAGE==1)
            SendMessageToPC(oPC, "Destruyendo un objeto aleatorio de la mochila.");
        }
        else if (HABD_DROP_RANDOM_BACKPACK == 1)
        {
            if(HABD_USERLANGUAGE==0)
            SendMessageToPC(oPC, "Dropping a random backpack item.");
            else if(HABD_USERLANGUAGE==1)
            SendMessageToPC(oPC, "Tirando al suelo un objeto aleatorio de la mochila.");
        }
        if (HABD_DROP_MOST_EXPENSIVE_BACKPACK == 2)
        {
            if(HABD_USERLANGUAGE==0)
            SendMessageToPC(oPC, "Destroying most expensive backpack item.");
            else if(HABD_USERLANGUAGE==1)
            SendMessageToPC(oPC, "Destruyendo el objeto mas caro de la mochila.");
        }
        else if (HABD_DROP_MOST_EXPENSIVE_BACKPACK == 1)
        {
            if(HABD_USERLANGUAGE==0)
            SendMessageToPC(oPC, "Dropping most expensive backpack item.");
            else if(HABD_USERLANGUAGE==1)
            SendMessageToPC(oPC, "Tirando al suelo el objeto mas caro de la mochila.");
        }

        int iRandomCount = 0;
        int iMostValueCount = 0;
        int iBaseItemType;
        int iDrop = 2;
        object oContainerItem;
        // Find the random item.
        oItem = GetFirstItemInInventory(oPC);
        while (GetIsObjectValid(oItem))
        {
           // it is not a container, or an empty one
           if (GetFirstItemInInventory(oItem) == OBJECT_INVALID)
           {
             iDrop = HABDItemDroppable(oItem);
             if ( HABD_FORCE_RAISE_USES_SCROLLS == TRUE)
             {
               iBaseItemType = GetBaseItemType(oItem);
               if ((iBaseItemType == BASE_ITEM_SCROLL) ||
                   (iBaseItemType == BASE_ITEM_SPELLSCROLL))
                  if (FindSubString(HABD_SCROLL_TAGS, ":"+GetTag(oItem)+":") != -1)
                      iDrop = 0; //dropping the raise scrolls seems not allowed
              }
              if ( iDrop >= HABD_DROP_RANDOM_BACKPACK)
                 iRandomCount++;
              if ( iDrop >= HABD_DROP_MOST_EXPENSIVE_BACKPACK )
              {
                  // Increment the number of items and check
                  // for the highest GP item.
                  iMostValueCount++;
                  iGP = HABDGetGPValue(oItem);
                  if (iGP > iHighestGP)
                  {
                     iHighestGP = iGP;
                     iHighestGPPos = iMostValueCount;
                  }
               }
            }
            //damn, the item is a non empty container, cicle inside the container
            else
            {
              oContainerItem = GetFirstItemInInventory(oItem);
              while (GetIsObjectValid(oContainerItem))
              {
                iDrop = HABDItemDroppable(oContainerItem);
                if ( HABD_FORCE_RAISE_USES_SCROLLS == TRUE)
                {
                iBaseItemType = GetBaseItemType(oContainerItem);
                if ((iBaseItemType == BASE_ITEM_SCROLL) ||
                   (iBaseItemType == BASE_ITEM_SPELLSCROLL))
                  if (FindSubString(HABD_SCROLL_TAGS, ":"+GetTag(oContainerItem)+":") != -1)
                      iDrop = 0; //dropping the raise scrolls seems not allowed
                }
                if ( iDrop >= HABD_DROP_RANDOM_BACKPACK)
                 iRandomCount++;
                if ( iDrop >= HABD_DROP_MOST_EXPENSIVE_BACKPACK )
                {
                  // Increment the number of items and check
                  // for the highest GP item.
                  iMostValueCount++;
                  iGP = HABDGetGPValue(oContainerItem);
                  if (iGP > iHighestGP)
                  {
                     iHighestGP = iGP;
                     iHighestGPPos = iMostValueCount;
                  }
                }
                oContainerItem = GetNextItemInInventory(oItem);
              }
            } //end of container tasks
            oItem = GetNextItemInInventory(oPC);
        }//end of while

        iRandomBackpack = Random(iRandomCount)+1;
        iRandomCount = 0;
        iMostValueCount = 0;
        // Find and Drop the random / most expensive items.
        oItem = GetFirstItemInInventory(oPC);
        while (GetIsObjectValid(oItem))
        {
           // it is not a container, or an empty one
           if (GetFirstItemInInventory(oItem) == OBJECT_INVALID)
           {
             iDrop = HABDItemDroppable(oItem);
             if ( HABD_FORCE_RAISE_USES_SCROLLS == TRUE)
             {
               iBaseItemType = GetBaseItemType(oItem);
               if ((iBaseItemType == BASE_ITEM_SCROLL) ||
                   (iBaseItemType == BASE_ITEM_SPELLSCROLL))
                  if (FindSubString(HABD_SCROLL_TAGS, ":"+GetTag(oItem)+":") != -1)
                      iDrop = 0; //dropping the raise scrolls seems not allowed
              }
              if ( HABD_DROP_RANDOM_BACKPACK != 0)
              if ( iDrop >= HABD_DROP_RANDOM_BACKPACK)
              {
                 iRandomCount++;
                 // If this is the random item then drop it.
                 if ( iRandomCount == iRandomBackpack )
                 {
                   if (HABD_DROP_RANDOM_BACKPACK == 2) DestroyObject(oItem);
                   if (HABD_DROP_RANDOM_BACKPACK == 1) HABDTakeItem(oItem, oPC, oBag);
                 }

              }
              if ( HABD_DROP_MOST_EXPENSIVE_BACKPACK != 0)
              if ( iDrop >= HABD_DROP_MOST_EXPENSIVE_BACKPACK )
              {
                   iMostValueCount++;
                   // If this is the most expensive item then drop it.
                   if ( iMostValueCount == iHighestGPPos )
                   {
                      if (HABD_DROP_MOST_EXPENSIVE_BACKPACK == 2) DestroyObject(oItem);
                      if (HABD_DROP_MOST_EXPENSIVE_BACKPACK == 1) HABDTakeItem(oItem, oPC, oBag);
                   }
               }
            }
            //damn, the item is a non empty container, cicle inside the container
            else
            {
              oContainerItem = GetFirstItemInInventory(oItem);
              while (GetIsObjectValid(oContainerItem))
              {
                iDrop = HABDItemDroppable(oContainerItem);
                if ( HABD_FORCE_RAISE_USES_SCROLLS == TRUE)
                {
                iBaseItemType = GetBaseItemType(oContainerItem);
                if ((iBaseItemType == BASE_ITEM_SCROLL) ||
                   (iBaseItemType == BASE_ITEM_SPELLSCROLL))
                  if (FindSubString(HABD_SCROLL_TAGS, ":"+GetTag(oContainerItem)+":") != -1)
                      iDrop = 0; //dropping the raise scrolls seems not allowed
                }
                if ( HABD_DROP_RANDOM_BACKPACK != 0)
                if ( iDrop >= HABD_DROP_RANDOM_BACKPACK)
                {
                  iRandomCount++;
                  // If this is the random item then drop it.
                  if ( iRandomCount == iRandomBackpack )
                  {
                    if (HABD_DROP_RANDOM_BACKPACK == 2) DestroyObject(oContainerItem);
                    if (HABD_DROP_RANDOM_BACKPACK == 1) HABDTakeItem(oContainerItem, oItem, oBag);
                  }
                }
                if ( HABD_DROP_MOST_EXPENSIVE_BACKPACK != 0)
                if ( iDrop >= HABD_DROP_MOST_EXPENSIVE_BACKPACK )
                {
                  iMostValueCount++;
                   // If this is the most expensive item then drop it.
                   if ( iMostValueCount == iHighestGPPos )
                   {
                      if (HABD_DROP_MOST_EXPENSIVE_BACKPACK == 2) DestroyObject(oContainerItem);
                      if (HABD_DROP_MOST_EXPENSIVE_BACKPACK == 1) HABDTakeItem(oContainerItem, oItem, oBag);
                   }
                }
                oContainerItem = GetNextItemInInventory(oItem);
              }
            } //end of container tasks
            oItem = GetNextItemInInventory(oPC);
        }//end of while
    } //----


    // Should we drop everything in the backpack that isn't plot?
    if (HABD_DROP_BACKPACK != 0)
    {
        int iBaseItemType;
        int iContainerEmpty=TRUE;
        int iDrop = 2;
        object oContainerItem;

        if (HABD_DROP_BACKPACK == 2)
        {
            if(HABD_USERLANGUAGE==0)
            SendMessageToPC(oPC, "Destroying all backpack items.");
            else if(HABD_USERLANGUAGE==1)
            SendMessageToPC(oPC, "Destruyendo todos los objetos de la mochila.");
        }
        else
        {
            if(HABD_USERLANGUAGE==0)
            SendMessageToPC(oPC, "Dropping all backpack items.");
            else if(HABD_USERLANGUAGE==1)
            SendMessageToPC(oPC, "Tirando al suelo todos los objetos de la mochila.");
        }

        oItem = GetFirstItemInInventory(oPC);
        // Find and Drop the random / most expensive items.
        oItem = GetFirstItemInInventory(oPC);
        while (GetIsObjectValid(oItem))
        {
           // it is not a container, or is an empty one
           if (GetFirstItemInInventory(oItem) == OBJECT_INVALID)
           {
             iDrop = HABDItemDroppable(oItem);
             if ( HABD_FORCE_RAISE_USES_SCROLLS == TRUE)
             {
               iBaseItemType = GetBaseItemType(oItem);
               if ((iBaseItemType == BASE_ITEM_SCROLL) ||
                   (iBaseItemType == BASE_ITEM_SPELLSCROLL))
                  if (FindSubString(HABD_SCROLL_TAGS, ":"+GetTag(oItem)+":") != -1)
                      iDrop = 0; //dropping the raise scrolls seems not allowed
              }
              if ( iDrop >= HABD_DROP_BACKPACK )
              {
                   if (HABD_DROP_BACKPACK == 2) DestroyObject(oItem);
                   if (HABD_DROP_BACKPACK == 1) HABDTakeItem(oItem, oPC, oBag);

              }
            }
            //damn, the item is a non empty container, cicle inside the container
            else
            {
              oContainerItem = GetFirstItemInInventory(oItem);
              iContainerEmpty = TRUE;
              while (GetIsObjectValid(oContainerItem))
              {
                iDrop = HABDItemDroppable(oContainerItem);
                if ( HABD_FORCE_RAISE_USES_SCROLLS == TRUE)
                {
                iBaseItemType = GetBaseItemType(oContainerItem);
                if ((iBaseItemType == BASE_ITEM_SCROLL) ||
                   (iBaseItemType == BASE_ITEM_SPELLSCROLL))
                  if (FindSubString(HABD_SCROLL_TAGS, ":"+GetTag(oContainerItem)+":") != -1)
                      iDrop = 0; //dropping the raise scrolls seems not allowed
                }
                if ( iDrop >= HABD_DROP_BACKPACK )
                {
                   if (HABD_DROP_BACKPACK == 2) DestroyObject(oContainerItem);
                   if (HABD_DROP_BACKPACK == 1) HABDTakeItem(oContainerItem, oItem, oBag);
                }
                else iContainerEmpty = FALSE;
                oContainerItem = GetNextItemInInventory(oItem);
              }
              //if the container is now empty.. drop the container itself
              {
                iDrop = HABDItemDroppable(oItem);
                //container cannot be a raise scroll
                if ( iDrop >= HABD_DROP_BACKPACK )
                {
                   if (HABD_DROP_BACKPACK == 2) DestroyObject(oItem);
                   if (HABD_DROP_BACKPACK == 1) HABDTakeItem(oItem, oPC, oBag);
                }
              }
            } //end of container tasks
            oItem = GetNextItemInInventory(oPC);
        }//end of while
    }

    return;
}

// ****************************************************************************



//The function will store the GetAttemptedAttackTarget() return in a variable,
// it should be called using   AssignCommand(oEnemy, ClearAllActions(TRUE));
void HABDGetAttempAttack(object oPC);
void HABDGetAttempAttack(object oPC)
{
SetLocalObject(oPC, HABD_AttempedTarget, GetAttemptedAttackTarget());
}

//The function should clear actions of creatures that are attacking the PC.
void HABDStopNearbyAttackers(object oPC);

void HABDStopNearbyAttackers(object oPC)
{
    AssignCommand(oPC, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectInvisibility(INVISIBILITY_TYPE_NORMAL), oPC, 6.0));
    int n=1;
        //CREATURE_TYPE_REPUTATION will not work, because sometimes they keep
        //attacking you even if they seem neutral or friendly :\ Specially if
        //they have true vision.
    object oEnemy = GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE, oPC, n,CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC);
    while (oEnemy != OBJECT_INVALID)
    {
        object oAttemp = OBJECT_INVALID;
        AssignCommand(oEnemy, HABDGetAttempAttack(oPC));
        if (GetAttackTarget(oEnemy) == oPC || GetLocalObject(oPC, HABD_AttempedTarget) == oPC)
            {
            AssignCommand(oEnemy, ClearAllActions(TRUE));
            }

        n=n+1;
        oEnemy = GetNearestCreature(CREATURE_TYPE_IS_ALIVE,TRUE, oPC, n, CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC);
    }
    DeleteLocalObject(oPC, HABD_AttempedTarget);
}
// ****************************************************************************



// This function checks that the player is not jumping to another area, it will
// make the player jump to the Permadeath point when finished the travel. It fixes
// some problems when jumping when we come from persistence.
// If you call it for a recently death PC that has been respawned, make sure
// he have received this: Otherwise he will not heal and jump
// ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
// iSignal = Should provide information about what event called the function,
// not fully implemented.
void HABDJumpToPermaDeathPoint(object oPC, int iSignal = 0);

void HABDJumpToPermaDeathPoint(object oPC, int iSignal = 0)
{
 string sWPTag = HABDPermadeathWPTag(oPC, iSignal);
 if ( sWPTag != "" )
 if ( GetArea(oPC) != OBJECT_INVALID )
  {
       object oRespPoint = GetWaypointByTag(sWPTag);
       if ( GetIsObjectValid (oRespPoint) ) //check the waypoint existes
       {
          location lRespLoc = GetLocation( oRespPoint );
          int iCommand = GetCommandable (oPC);
          if (iCommand == FALSE)
            SetCommandable(TRUE, oPC);    //make sure the PC is commandable to jump
          if (GetCurrentHitPoints(oPC)<=0)
          {
            effect eHealto1HP = EffectHeal(1-GetCurrentHitPoints(oPC));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eHealto1HP  , oPC );
          }
          AssignCommand (oPC,ClearAllActions(TRUE));
          AssignCommand (oPC, JumpToLocation (lRespLoc) );
          if (iCommand == FALSE)
            DelayCommand ( 0.001, SetCommandable(FALSE, oPC) );
       }
  }
 else DelayCommand ( 1.0, HABDJumpToPermaDeathPoint(oPC) );
}
// ***************************************************************************



// Used by HABDJumpToBindStonePointOnEnterBleeding, restores Bleeding when OnEnter
void HABDMakeBleeding(object oPC, int iHP);

void HABDMakeBleeding(object oPC, int iHP)
{
int iDmg = GetCurrentHitPoints(oPC) - iHP;
if(HABD_USERLANGUAGE==0)
    SendMessageToPC(oPC, "HABD_DB: Restoring bleeding by doing "+IntToString(iDmg)+" HP damage.");
else  if(HABD_USERLANGUAGE==1)
    SendMessageToPC(oPC, "HABD_DB: Restaurando el desangramiento infligiendo "+IntToString(iDmg)+" PG de heridas.");

ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDamage(iDmg, DAMAGE_TYPE_POSITIVE, DAMAGE_POWER_PLUS_FIVE), oPC);
SetPlotFlag(oPC, TRUE);
}

// This function checks that the player is not jumping to another area, it will
// make the player jump to the BindStone point when finished the travel, then it
// Makes the PC Bleed. It fixes some problems when jumping when we come from
// persistence in BLEEDING State.
void HABDJumpToBindStonePointOnEnterBleeding(object oPC, int iHP);

void HABDJumpToBindStonePointOnEnterBleeding(object oPC, int iHP)
{
 if ( GetArea(oPC) != OBJECT_INVALID )
  {
       location lRespLoc = GetLocalLocation(oPC, HABD_RESPAWNBS_LOCATION);
       if ( GetAreaFromLocation(lRespLoc) != OBJECT_INVALID )
       {
          int iCommand = GetCommandable (oPC);
          if (iCommand == FALSE)
            SetCommandable(TRUE, oPC);    //make sure the PC is commandable to jump
          if (GetCurrentHitPoints(oPC)<=0)
          {
            effect eHealto1HP = EffectHeal(1-GetCurrentHitPoints(oPC));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eHealto1HP  , oPC );
          }
          AssignCommand (oPC,ClearAllActions(TRUE));
          AssignCommand (oPC, JumpToLocation (lRespLoc) );
          DelayCommand ( 0.1, HABDMakeBleeding(oPC,iHP) );
          if (iCommand == FALSE)
            DelayCommand ( 0.001, SetCommandable(FALSE, oPC) );
       }
       else
       DelayCommand ( 0.1, HABDMakeBleeding(oPC,iHP) );
  }
 else DelayCommand ( 1.0, HABDJumpToBindStonePointOnEnterBleeding(oPC, iHP) );
}
// ***************************************************************************


// Used by HABDJumpToBindStonePointOnEnterDeath, restores Death when OnEnter
void HABDMakeDeath(object oPC, int iInstant = FALSE);

void HABDMakeDeath(object oPC, int iInstant = FALSE)
{
        object oMod = GetModule();
        string sID = GetPCPlayerName(oPC)+GetName(oPC);

        if (iInstant == TRUE)
        {
            // Set the auto-respawn/raise timers to maximum (not entering form persist).
            SetLocalInt(oMod, HABD_RESPAWN_TIMER+sID, FloatToInt(HABD_FORCE_RESPAWN_TIMER));
            if ((HABD_SOLO_FORCE_RAISE_TIMER > 0.0) & (HABDPlayerIsSolo(oPC)==TRUE)  )
            {
            SetLocalInt(oMod, HABD_RAISE_TIMER+sID, FloatToInt(HABD_SOLO_FORCE_RAISE_TIMER));
            } else {
            SetLocalInt(oMod, HABD_RAISE_TIMER+sID, FloatToInt(HABD_FORCE_RAISE_TIMER));
            }
            // Increment the counters.
            SetLocalInt(oMod, HABD_CURRENT_DEATH_COUNT+sID, GetLocalInt(oMod, HABD_CURRENT_DEATH_COUNT+sID) + 1);
            SetLocalInt(oMod, HABD_DEATH_COUNT+sID, GetLocalInt(oMod, HABD_DEATH_COUNT+sID) + 1);
            //--
          }

          // KILL
          ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oPC);

          if (iInstant == TRUE)
            DelayCommand(1.0, AssignCommand(oPC, HABDDropItems(oPC)) );
}

// This function checks that the player is not jumping to another area, it will
// make the player jump to the BindStone point when finished the travel, then it
// kills the PC. It fixes some problems when jumping when we come from
// persistence in DEATH State.
void HABDJumpToBindStonePointOnEnterDeath(object oPC, int iInstant = FALSE);

void HABDJumpToBindStonePointOnEnterDeath(object oPC, int iInstant = FALSE)
{
 if ( GetArea(oPC) != OBJECT_INVALID )
  {
       location lRespLoc = GetLocalLocation(oPC, HABD_RESPAWNBS_LOCATION);
       if ( GetAreaFromLocation(lRespLoc) != OBJECT_INVALID )
       {
          int iCommand = GetCommandable (oPC);
          if (iCommand == FALSE)
            SetCommandable(TRUE, oPC);    //make sure the PC is commandable to jump
          if (GetCurrentHitPoints(oPC)<=0)
          {
            effect eHealto1HP = EffectHeal(1-GetCurrentHitPoints(oPC));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eHealto1HP  , oPC );
          }
          AssignCommand (oPC,ClearAllActions(TRUE));
          AssignCommand (oPC, JumpToLocation (lRespLoc) );
          DelayCommand ( 0.1, HABDMakeDeath(oPC, iInstant) );
          if (iCommand == FALSE)
            DelayCommand ( 0.001, SetCommandable(FALSE, oPC) );
       }
       else
       {
         DelayCommand ( 0.1, HABDMakeDeath(oPC, iInstant) );
       }
  }
 else DelayCommand ( 1.0, HABDJumpToBindStonePointOnEnterDeath(oPC) );
}
// ***************************************************************************



// This function checks that the player is not jumping to another area, it will
// make the player jump to the BindStone point when finished the travel. It fixes
// some problems when jumping when we come from persistence.
void HABDJumpToBindStonePoint(object oPC);

void HABDJumpToBindStonePoint(object oPC)
{
 if ( GetArea(oPC) != OBJECT_INVALID )
  {
  //if ( HABD_BINDSTONE_USEWHENRESPAWNED == TRUE)
    //{
       location lRespLoc = GetLocalLocation(oPC, HABD_RESPAWNBS_LOCATION);
       if ( GetAreaFromLocation(lRespLoc) != OBJECT_INVALID )
       {
          int iCommand = GetCommandable (oPC);
          if (iCommand == FALSE)
            SetCommandable(TRUE, oPC);    //make sure the PC is commandable to jump
          if (GetCurrentHitPoints(oPC)<=0)
          {
            effect eHealto1HP = EffectHeal(1-GetCurrentHitPoints(oPC));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eHealto1HP  , oPC );
          }
          AssignCommand (oPC,ClearAllActions(TRUE));
          AssignCommand (oPC, JumpToLocation (lRespLoc) );
          if (iCommand == FALSE)
            DelayCommand ( 0.001, SetCommandable(FALSE, oPC) );
       }
    //}
  }
 else DelayCommand ( 1.0, HABDJumpToBindStonePoint(oPC) );
}
// ***************************************************************************


// Re-Builds a secure bind stone location knowing the original location (for
// orientation and XYZ position) and the Area Tag. If the Area tag was changed
// or bindstones moved from the area, it could fail.
location HABDBuildBindStoneLoc (string sBindStoneAreaTag, location lBindStoneLoc);

location HABDBuildBindStoneLoc (string sBindStoneAreaTag, location lBindStoneLoc)
{
    //Find the actual object for the correct area, by Tag.
    //GetObjectType does not return if an object is an area...
    //Cicle with all objects with this tag, until we found an Area object.
    int iFound = FALSE;
    int i=0;
    object oArea = GetObjectByTag(sBindStoneAreaTag, i);
    while ( oArea!=OBJECT_INVALID & iFound ==FALSE )
    {
        if ( GetIsAreaNatural(oArea) != AREA_INVALID)
        iFound = TRUE;
        else
        {
        i=i+1;
        oArea = GetObjectByTag(sBindStoneAreaTag, i);
        }
    }
    //Area not found
    if( iFound == FALSE )
    {
        WriteTimestampedLogEntry("Location of HABD respawn bindstone stored in DataBase was wrong. Probably, because the are was deleted, changed its tag or changed its ResRef. The PC will enter without a bindstone, until he founds one.");
        return Location(OBJECT_INVALID, Vector(), 0.0f ); //error return
    }
    //Area found
    //Rebuild the location.
    location lPoint = Location (oArea, GetPositionFromLocation(lBindStoneLoc), GetFacingFromLocation(lBindStoneLoc) );
    //But the design of the area could have been changed. Now we search a bindstone
    //waypoint nearest in the area, and use it.
    iFound = FALSE;
    i=1;
    object oBindStone = GetNearestObjectToLocation(OBJECT_TYPE_WAYPOINT, lPoint,i);
    while (oBindStone != OBJECT_INVALID & iFound == FALSE)
    {
        if ( GetTag(oBindStone) == HABD_BINDSTONE_TAG)
        {
            iFound = TRUE;
        }
        else
        {
            i=i+1;
            oBindStone = GetNearestObjectToLocation(OBJECT_TYPE_WAYPOINT, lPoint,i);
        }
    }
    //bindstone not found
    if (oBindStone == OBJECT_INVALID)
    {
        WriteTimestampedLogEntry("Location of HABD respawn bindstone stored in DataBase is rigth, but no BlindStone Waypoint was found in the Area. Probably, the area design was changed and any blindstone deleted. The PC will enter without a bindstone, until he founds one.");
        return Location(OBJECT_INVALID, Vector(), 0.0f ); //error return
    }
    //Bindstone location 100% secure, return it :)
    return GetLocation(oBindStone);
}


// It will return the reference to the bindstone waypoint the PC should use if
// respawning, then you can get the Area or the Tag from that info. If the Area
// tag was changed or bindstones moved from the area, it could fail. It could
// work even if the Player is logged out.
// Returns OBJECT_INVALID if Error or not found.
object HABDGetBindStoneWP (object oPC);

object HABDGetBindStoneWP (object oPC)
{
    string splayername = HABDPlayerName(oPC);
    string sData = HABDLoadStringFromDB(splayername, GetName(oPC));
    string sBindStoneAreaTag = HABDStrTok(sData, 9);
    location lBindStoneLoc = HABDLoadBSLocationFromDB(splayername, GetName(oPC));
    //Find the actual object for the correct area, by Tag.
    //GetObjectType does not return if an object is an area...
    //Cicle with all objects with this tag, until we found an Area object.
    int iFound = FALSE;
    int i=0;
    object oArea = GetObjectByTag(sBindStoneAreaTag, i);
    while ( oArea!=OBJECT_INVALID & iFound ==FALSE )
    {
        if ( GetIsAreaNatural(oArea) != AREA_INVALID)
        iFound = TRUE;
        else
        {
        i=i+1;
        oArea = GetObjectByTag(sBindStoneAreaTag, i);
        }
    }
    //Area not found
    if( iFound == FALSE )
    {
        WriteTimestampedLogEntry("HABDGetBindStoneWP Error: Location of HABD respawn bindstone stored in DataBase was wrong. Probably, because the are was deleted, changed its tag or changed its ResRef.");
        return OBJECT_INVALID; //error return
    }
    //Area found
    //Rebuild the location.
    location lPoint = Location (oArea, GetPositionFromLocation(lBindStoneLoc), GetFacingFromLocation(lBindStoneLoc) );
    //But the design of the area could have been changed. Now we search a bindstone
    //waypoint nearest in the area, and use it.
    iFound = FALSE;
    i=1;
    object oBindStone = GetNearestObjectToLocation(OBJECT_TYPE_WAYPOINT, lPoint,i);
    while (oBindStone != OBJECT_INVALID & iFound == FALSE)
    {
        if ( GetTag(oBindStone) == HABD_BINDSTONE_TAG)
        {
            iFound = TRUE;
        }
        else
        {
            i=i+1;
            oBindStone = GetNearestObjectToLocation(OBJECT_TYPE_WAYPOINT, lPoint,i);
        }
    }
    //bindstone not found
    if (oBindStone == OBJECT_INVALID)
    {
        WriteTimestampedLogEntry("HABDGetBindStoneWP Error: Location of HABD respawn bindstone stored in DataBase is rigth, but no BlindStone Waypoint was found in the Area. Probably, the area design was changed and any blindstone deleted.");
        return OBJECT_INVALID; //error return
    }
    //Bindstone location 100% secure, return it :)
    return oBindStone;
}

// ****************************************************************************


// OnClientEnter event handler. Used to restore the information from the
// persistent DB. It also resets the bleeding/death/respawn state over
// server resets.
//   oPC - player to restore information to.
void HABDGetDBOnClientEnter(object oPC);

void HABDGetDBOnClientEnter(object oPC)
{
    // Remove any accidental states that might have been stored on the player
    // file.
    SetPlotFlag(oPC, FALSE);
    SetCommandable(TRUE, oPC);
    // This might screw things up if you are messing around with the faction
    // system a lot.
    if (HABD_ONENTER_HOSTILEREPUTATION == TRUE )
        SetStandardFactionReputation(STANDARD_FACTION_HOSTILE, 0, oPC);

    string sID = GetPCPlayerName(oPC)+GetName(oPC);
    object oMod = GetModule();

    if (!HADB_DB_PERSISTENT)
        {
        SetLocalInt(oMod, HABD_ONENTER_FIRST_TIME+sID, 1);
        return;
        }

    // Store the player's Name. That information is needed for writing
    // to the database in the OnClientLeave event (because you can't determine
    // the Player's Name after they have left).
    if ( HABD_PATCH_PRE1_64 == FALSE )
        SetLocalString(oPC, HABD_PERSISTANT_ID+GetName(oPC), GetPCPlayerName(oPC));
        else SetLocalString(oMod, HABD_PERSISTANT_ID+GetName(oPC), GetPCPlayerName(oPC));

    if (HABD_SPELL_TRACKING>0)  HABDRestoreSpellFeatUses(oPC);

    // We use packed strings in the database to reduce database access since
    // its slow. Database index is limited to 32 characters.
    //string sData = GetCampaignString(HABD_DB_NAME, GetStringLeft(HABD_PERSIST_NAME+sID, 32));
    string sData = HABDLoadStringFromDB(GetPCPlayerName(oPC), GetName(oPC));

    // Load statistics
    int iDCount = StringToInt(HABDStrTok(sData, 1));
    int iBCount = StringToInt(HABDStrTok(sData, 2));
    int iXCount = StringToInt(HABDStrTok(sData, 3));
    int iGCount = StringToInt(HABDStrTok(sData, 4));
    // Restore the counters.
    SetLocalInt(oMod, HABD_DEATH_COUNT+sID, iDCount);
    SetLocalInt(oMod, HABD_BLEED_COUNT+sID, iBCount);
    SetLocalInt(oMod, HABD_LOST_XP_COUNT+sID, iXCount);
    SetLocalInt(oMod, HABD_LOST_GP_COUNT+sID, iGCount);
    // Load state
    int iHP = StringToInt(HABDStrTok(sData, 5));
    int iState = StringToInt(HABDStrTok(sData, 6));
    int iRespawn = StringToInt(HABDStrTok(sData, 7));
    int iRaise = StringToInt(HABDStrTok(sData, 8));
    string sBindStoneAreaTag = HABDStrTok(sData, 9);
    // variables that allow PCs to be raised when logged out
        int iCorpseRaise = StringToInt(HABDStrTok(sData, 10));
        int iCorpseSpell = StringToInt(HABDStrTok(sData, 11));
        int iCorpseNPCGP = StringToInt(HABDStrTok(sData, 12));
    //custom variable
    string shabdcustomvar = HABDStrTok(sData, 13);
        HABDSetCustomVar(oPC, shabdcustomvar);
    // if the player was raised when logged out and is a ghost, stop autoraise
    if(iCorpseRaise==TRUE && iState==HABD_STATE_RESPAWNED_GHOST)
        iRaise = 0;
    // Restore state.
    SetLocalInt(oMod, HABD_PLAYER_STATE+sID, iState);
    SetLocalInt(oMod, HABD_LAST_HP+sID, iHP);
    // Only apply timers if they are enabled. Module settings could have changed.
    if (HABD_FORCE_RESPAWN_TIMER > 0.0) SetLocalInt(oMod, HABD_RESPAWN_TIMER+sID, iRespawn);
    if ((HABD_FORCE_RAISE_TIMER > 0.0) || (HABD_SOLO_FORCE_RAISE_TIMER > 0.0)) SetLocalInt(oMod, HABD_RAISE_TIMER+sID, iRaise);

    int iDmg = 0;

    // Restore the bindstone location INFO after server restart
    if (  HABD_BINDSTONE_PERSISTENT == TRUE & GetLocalInt(oMod, HABD_ONENTER_FIRST_TIME+sID) == FALSE )
    {
        //location lBindStoneLoc = GetCampaignLocation(HABD_DB_NAME, GetStringLeft(HABD_PERSIST_BINDSTONELOC_NAME+sID,32));
        location lBindStoneLoc = HABDLoadBSLocationFromDB(GetPCPlayerName(oPC), GetName(oPC));
        lBindStoneLoc = HABDBuildBindStoneLoc (sBindStoneAreaTag, lBindStoneLoc);
        if ( GetAreaFromLocation (lBindStoneLoc) != OBJECT_INVALID )
            SetLocalLocation(oPC, HABD_RESPAWNBS_LOCATION, lBindStoneLoc);
    }

    // DELAY TO HEAL STABILIZED WAS BROKEN WHEN LOG OUT?
    if (GetLocalInt(oMod, HABD_DELAYTOHEAL_CONTROL+sID) == TRUE )
    {
        if (iHP <1 ) iHP = 1;
        iDmg = GetCurrentHitPoints(oPC) - iHP;
        if(HABD_USERLANGUAGE==0)
            SendMessageToPC(oPC, "HABD_DB: Delay to recover from stabilization was interrupted due log out: Stabilized.");
        else if(HABD_USERLANGUAGE==1)
            SendMessageToPC(oPC, "HABD_DB: El retraso hasta estabilizarse fue interrumpido por que saliste del servidor: Estabilizado.");
        ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDamage(iDmg, DAMAGE_TYPE_POSITIVE, DAMAGE_POWER_ENERGY), oPC);
        SetLocalInt(oMod, HABD_LAST_HP+sID, 1);
        SetLocalInt(oMod,HABD_PLAYER_STATE+sID, HABD_STATE_PLAYER_ALIVE);
        DeleteLocalInt(oMod, HABD_DELAYTOHEAL_CONTROL+sID);
    }

    // Delete CORPSE ITEMs in PC inventory
    if (HABD_RESTART_DELETE_CORPSES == TRUE)
        if (GetIsDM(oPC) != TRUE)
            if (GetLocalInt(oMod, HABD_ONENTER_FIRST_TIME+sID) == 0 )
            {
                HABDTakePCItems(oPC,HABD_CORPSEITEM_FEM_RESREF);
                HABDTakePCItems(oPC,HABD_CORPSEITEM_MALE_RESREF);
            }

    // REAPPLY BLEEDING.
    int iDeathByInstantBleeding = FALSE;
    // First, apply Fast/Instant bleeding on enter?
    int iOnEnterNoInstantBleed = GetLocalInt(GetModule(), sID+HABD_ONENTER_INSTANTBLEED_VAR);
        if (HABD_ONENTER_INSTANTBLEED == FALSE)
            iOnEnterNoInstantBleed = TRUE;
        if (GetHitDice(oPC)<HABD_NO_DEATH_UNTIL_LEVEL)
            iOnEnterNoInstantBleed = TRUE;
    DeleteLocalInt(GetModule(), sID+HABD_ONENTER_INSTANTBLEED_VAR);
    // No Instant Bleeding
    if (iState == HABD_STATE_PLAYER_BLEEDING & iOnEnterNoInstantBleed==TRUE)
    {
        //check iHP are correct
        if ( iHP>0 )
            {
            iHP = 0;
            if(HABD_USERLANGUAGE==0)
                SendMessageToAllDMs("habd_include error, function HABDGetDBOnClientEnter(), saved HPs are not correct when restoring Bleeding");
            else if(HABD_USERLANGUAGE==1)
                SendMessageToAllDMs("habd_include error, funcion HABDGetDBOnClientEnter(), HPs (puntos de golpe) salvados no son correctos cuando estabamos restaurando un Desangramiento");
            WriteTimestampedLogEntry("habd_include error, function HABDGetDBOnClientEnter(), saved HPs are not correct when restoring Bleeding");
            }
        SetLocalInt(oPC, HABD_PERSISTANT_REAPPLY, 1);
        //Manage locations via BindStones, if turned on the option
        location lRespLoc = GetLocalLocation(oPC, HABD_RESPAWNBS_LOCATION);
        if (HABD_BINDSTONE_MANAGE_LOCATIONS == TRUE & iState != HABD_STATE_PC_PERMADEATH
          & GetLocalInt (oMod, HABD_ONENTER_FIRST_TIME+sID) ==FALSE
          & GetAreaFromLocation(lRespLoc) != OBJECT_INVALID)
            HABDJumpToBindStonePointOnEnterBleeding(oPC, iHP);
            else  //else just restore bleeding
            HABDMakeBleeding(oPC,iHP);
    }
    // Instant Bleeding
    if (iState == HABD_STATE_PLAYER_BLEEDING & iOnEnterNoInstantBleed==FALSE)
    {
        //check iHP are correct
        if ( iHP>0 )
            {
            iHP = 0;
            if(HABD_USERLANGUAGE==0)
                SendMessageToAllDMs("habd_include error, function HABDGetDBOnClientEnter(), saved HPs are not correct when restoring Bleeding");
            else if(HABD_USERLANGUAGE==1)
                SendMessageToAllDMs("habd_include error, funcion HABDGetDBOnClientEnter(), HPs (puntos de golpe) salvados no son correctos cuando estabamos restaurando un Desangramiento");
            WriteTimestampedLogEntry("habd_include error, function HABDGetDBOnClientEnter(), saved HPs are not correct when restoring Bleeding");
            }
        //Instant Bleed Checks
        int iInstantStabilized = FALSE;
        int ifsn=-iHP;
        int iNeededSavingRoll = HABD_GLOBAL_STABILIZATION_NUMBER;
            if ( HABDPlayerIsSolo(oPC) )
                iNeededSavingRoll = HABD_SOLO_STABILIZATION_NUMBER;
        while (ifsn<(10) && iInstantStabilized==FALSE)
        {
            if (Random(HABD_STABILIZATION_DICE+1)>=iNeededSavingRoll)
                iInstantStabilized=TRUE;
            ifsn=ifsn+1;
        }
        //InstantStabilization
        if (iInstantStabilized==TRUE)
        {
        //SetLocalInt(oPC, HABD_PERSISTANT_REAPPLY, 1); //is it needed?
        iDmg = GetCurrentHitPoints(oPC) - 1;
        if(HABD_USERLANGUAGE==0)
            SendMessageToPC(oPC, "HABD_DB: Instant Bleeding Controls, because you take long time to login after loging out: Stabilized.");
        else if(HABD_USERLANGUAGE==1)
            SendMessageToPC(oPC, "HABD_DB: Controles de Desangramiento Instantaneo, porque tardaste mucho en volver al juego tras desconectar muriendote: Estabilizado.");
        ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDamage(iDmg, DAMAGE_TYPE_POSITIVE, DAMAGE_POWER_ENERGY), oPC);
        SetLocalInt(oMod, HABD_LAST_HP+sID, 1);
        SetLocalInt(oMod,HABD_PLAYER_STATE+sID, HABD_STATE_PLAYER_ALIVE);
        //Manage locations via BindStones, if turned on the option
        if (HABD_BINDSTONE_MANAGE_LOCATIONS == TRUE & iState != HABD_STATE_PC_PERMADEATH)
        if ( GetLocalInt (oMod, HABD_ONENTER_FIRST_TIME+sID) ==FALSE )
        HABDJumpToBindStonePoint(oPC);
        }
        //Instant NO stabilized : DEATH
        else
        {
        SetLocalInt(oPC, HABD_PERSISTANT_REAPPLY, 1);
        if(HABD_USERLANGUAGE==0)
            SendMessageToPC(oPC, "HABD_DB: Instant Bleeding Controls, because you take long time to login after loging out: Death.");
        else if(HABD_USERLANGUAGE==1)
            SendMessageToPC(oPC, "HABD_DB: Controles de Desangramiento Instantaneo, porque tardaste mucho en volver al juego tras desconectar muriendote: Muerto.");
        SetLocalInt(oMod,HABD_PLAYER_STATE+sID, HABD_STATE_PLAYER_DEAD);
        //Manage locations via BindStones, if turned on the option
        location lRespLoc = GetLocalLocation(oPC, HABD_RESPAWNBS_LOCATION);
        if (HABD_BINDSTONE_MANAGE_LOCATIONS == TRUE && iState != HABD_STATE_PC_PERMADEATH
        && GetLocalInt (oMod, HABD_ONENTER_FIRST_TIME+sID) == FALSE
        && GetAreaFromLocation(lRespLoc) != OBJECT_INVALID)
        HABDJumpToBindStonePointOnEnterDeath(oPC, TRUE);
        else
            HABDMakeDeath(oPC, TRUE);
        iDeathByInstantBleeding == TRUE;
        }

    }
    //End of Reappling Bleeding

    // Reapply death.
    if (iState == HABD_STATE_PLAYER_DEAD & iDeathByInstantBleeding==FALSE)
    {
        //check iHP are correct
        if ( iHP>-10 )
            {
            //iHP = -10;
            if(HABD_USERLANGUAGE==0)
                SendMessageToAllDMs("habd_include error, function HABDGetDBOnClientEnter(), saved HPs are not correct when restoring Death");
            else if(HABD_USERLANGUAGE==1)
                SendMessageToAllDMs("habd_include error, funcion HABDGetDBOnClientEnter(), HPs (puntos de golpe) guardados no son correctos al restaurar Muerte");
            WriteTimestampedLogEntry("habd_include error, function HABDGetDBOnClientEnter(), saved HPs are not correct when restoring Death");
            }
        SetLocalInt(oPC, HABD_PERSISTANT_REAPPLY, 1);
        if(HABD_USERLANGUAGE==0)
            SendMessageToPC(oPC, "HABD_DB: Restoring death.");
        else if(HABD_USERLANGUAGE==1)
            SendMessageToPC(oPC, "HABD_DB: Restaurando Muerte.");
        //Manage locations via BindStones, if turned on the option
        location lRespLoc = GetLocalLocation(oPC, HABD_RESPAWNBS_LOCATION);
        if (HABD_BINDSTONE_MANAGE_LOCATIONS == TRUE & iState != HABD_STATE_PC_PERMADEATH
        & GetLocalInt (oMod, HABD_ONENTER_FIRST_TIME+sID) ==FALSE
        & GetAreaFromLocation(lRespLoc) != OBJECT_INVALID)
        HABDJumpToBindStonePointOnEnterDeath(oPC);
        else   //else just make him Death
        HABDMakeDeath(oPC);
        //ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oPC);
    }

    DeleteLocalInt(oPC, HABD_RESTORE_AUTO_RAISE);
    // Reapply respawn.
    if (iState == HABD_STATE_RESPAWNED_GHOST)
    {
        if (HABDRespawnWPTag(oPC) != "")
            if (HABD_JUMPTORESPAWNPOINT_FIRST_ONENTER==TRUE)
                if ( GetLocalInt (oMod, HABD_ONENTER_FIRST_TIME+sID) ==FALSE )
                    SetLocalInt (oPC,HABD_FORCEJUMPTORESPAWNPOINT, 1);
        SetLocalInt(oPC, HABD_PERSISTANT_REAPPLY, 1);
        if(HABD_USERLANGUAGE==0)
            SendMessageToPC(oPC, "HABD_DB: Restoring ghost respawn.");
        else if(HABD_USERLANGUAGE==1)
            SendMessageToPC(oPC, "HABD_DB: Restaurando Respawn como Fantasma.");
        if ( GetLocalInt (oPC,HABD_FORCEJUMPTORESPAWNPOINT) == TRUE )
        {
            if(HABD_USERLANGUAGE==0)
            SendMessageToPC(oPC, "HABD_DB: Jumping to respawn point.");
            else if(HABD_USERLANGUAGE==1)
            SendMessageToPC(oPC, "HABD_DB: Saltando hacia el punto de Respawn.");
        }
        SetLocalInt(oPC, HABD_FORCED_RESPAWN, 1);
        SetLocalInt(oPC, HABD_RESTORE_AUTO_RAISE, 1);

        if ( HABD_RESTART_FORCE_RAISE_TIMER != 0.0)
        if ( FloatToInt(HABD_RESTART_FORCE_RAISE_TIMER) <
            GetLocalInt(oMod, HABD_RAISE_TIMER+sID)
            )
            if ( GetLocalInt (oMod, HABD_ONENTER_FIRST_TIME+sID) == FALSE )
                SetLocalInt(oMod, HABD_RAISE_TIMER+sID, FloatToInt(HABD_RESTART_FORCE_RAISE_TIMER));

        AssignCommand(oPC, ExecuteScript(HABD_RESPAWN_SCRIPT, oPC));

        //if player was raised when logged out..
        if (iCorpseRaise == TRUE)
        {
            HABDCureRespawnGhost(oPC,iCorpseSpell);
            //money that muts be paid to the raiser NPC
            AssignCommand(GetModule(),TakeGoldFromCreature(iCorpseNPCGP, oPC, TRUE));
            //when player is logged in, the three camp. variables for this process
            //will be saved somewhen as null (at clientleave e.g.)
            if(HABD_USERLANGUAGE==0)
                SendMessageToPC(oPC, "HABD: You were raised using a corpse item when you were logged out");
            else if(HABD_USERLANGUAGE==1)
                SendMessageToPC(oPC, "HABD: Fuiste resucitado usando un objeto Cadaver cuando estabas fuera del server");
        }

        //Manage locations via BindStones, if turned on the option
        if (HABD_BINDSTONE_MANAGE_LOCATIONS == TRUE & iState != HABD_STATE_PC_PERMADEATH)
        if ( GetLocalInt (oMod, HABD_ONENTER_FIRST_TIME+sID) ==FALSE )
        HABDJumpToBindStonePoint(oPC);
    }

    //Manage locations via BindStones, if turned on the option
    //if Alive, or undefined
    if (iState != HABD_STATE_RESPAWNED_GHOST & iState != HABD_STATE_PLAYER_DEAD
        & iState != HABD_STATE_PLAYER_BLEEDING)
    if (HABD_BINDSTONE_MANAGE_LOCATIONS == TRUE & iState != HABD_STATE_PC_PERMADEATH)
        if ( GetLocalInt (oMod, HABD_ONENTER_FIRST_TIME+sID) ==FALSE )
        HABDJumpToBindStonePoint(oPC);

    //Move the permadeath PCs to the Permadeath Waypoint
    if (iState == HABD_STATE_PC_PERMADEATH)
        if ( GetLocalInt (oMod, HABD_ONENTER_FIRST_TIME+sID) ==FALSE )
        HABDJumpToPermaDeathPoint(oPC);

    //Manage full hit points, if turned on the option
    /* Note that a PC with 0 HPs should be bleeding -hps for this case restored
    before-. If the Player had no HABD Data base info, we get iHP = 0, in this
    case we better dont kill him -we know he does not have 0 Hps because he
    should have the bleeding state in this case-. If the player is DEAD, the
    system applyes the Death Effect. In any other case -respawned, alive...
    hps are restored.
    */
    if ( HABD_MANAGE_HITPOINTS == TRUE && iState != HABD_STATE_PLAYER_BLEEDING
        && iState != HABD_STATE_PLAYER_DEAD &&  iHP != 0 )
    {
        if (iHP<0) iHP = 1;
        iDmg = GetCurrentHitPoints(oPC) - iHP;
        if(HABD_USERLANGUAGE==0)
            SendMessageToPC(oPC, "HABD_DB: Restoring HitPoints by doing "+IntToString(iDmg)+" HP damage.");
        else if(HABD_USERLANGUAGE==1)
            SendMessageToPC(oPC, "HABD_DB: Restaurando Puntos de Golpe haciendo "+IntToString(iDmg)+" PG de heridas.");
        ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDamage(iDmg, DAMAGE_TYPE_POSITIVE, DAMAGE_POWER_PLUS_FIVE), oPC);
    }

    // Log stuff to the server log for debugging purposes. Remove this later
    // to speed things up even more.
    PrintString("HABD_DB: Restoring "+sID+" gives "+sData);
    PrintString("HABD_DB: Restoring "+sID+" Death="+IntToString(iDCount)+" Bleed="+IntToString(iBCount)+" XPLost="+IntToString(iXCount)+" GPLost="+IntToString(iGCount));
    // Log stuff to the server log for debugging purposes. Remove this later
    // to speed things up even more.
    PrintString("HABD_DB: Restoring "+sID+" gives "+sData);
    PrintString("HABD_DB: Restoring "+sID+" iHP="+IntToString(iHP)+" iState="+IntToString(iState)+" iRespawnTimer="+IntToString(iRespawn)+" iRaiseTimer="+IntToString(iRaise));

    SetLocalInt (oMod, HABD_ONENTER_FIRST_TIME+sID, 1);

    //Save info to DB (and maybe export PC) to avoid server crash problems,
    if ( HABD_SMART_SAVETODB == TRUE )
        HABDSetDBString(oPC);
}

// ****************************************************************************



// OnClientLeave event handler. Used to store the information from the
// persistent DB. It also resets the bleeding/death/respawn state over
// server resets.
//   sName - name of the player to store information about.
// Remarks about NWN OnClientLeave: You cannot save local variables in PCs properly.
void HABDSetDBOnClientLeave(string sName);

void HABDSetDBOnClientLeave(string sName)
{
    //if (!HADB_DB_PERSISTENT) return;
    object oMod = GetModule();
    // Note: GetPCPlayerName does not function in the OnClientLeave event.
    // So use the player's name to get the shadowed version we stored in the
    // OnClientEnter.
    string sID = "";
    string sPlayerName = "";
    sPlayerName = HABDPlayerName(GetExitingObject());
    sID = sPlayerName+sName;

    // Save Spell Tracking info
    if (HABD_SPELL_TRACKING>0) HABDSaveSpellFeatUses(GetExitingObject());
    // Hit points, GetCurrentHPs return 0 if error.
    int iHP = 0;
    if (HABD_MANAGE_HITPOINTS == TRUE)
    {
    iHP = GetCurrentHitPoints(GetExitingObject());
    if (iHP <= 0) //if posible error, or negatives we can rely in shadowed variables
        iHP = GetLocalInt(oMod, HABD_LAST_HP+sID);
    }
    else
        iHP = GetLocalInt(oMod, HABD_LAST_HP+sID);

    int iState = GetLocalInt(oMod, HABD_PLAYER_STATE+sID);

    // Instant Bleeding for login/logout if the PC is out too much time.
    // Allowed time depends of the hps left to die, and the time per HP.
    if (HABD_ONENTER_INSTANTBLEED == TRUE)
    if (iHP<0 & iState == HABD_STATE_PLAYER_BLEEDING & iHP>-10)
    {
        float ff_c_time = IntToFloat(10+iHP)*HABD_ONENTER_INSTANTBLEED_TIME;
        SetLocalInt(GetModule(), sID+HABD_ONENTER_INSTANTBLEED_VAR, TRUE);
        if (HABD_ONENTER_INSTANTBLEED_TIME > 0.0)
            AssignCommand(GetModule(),DelayCommand(ff_c_time,DeleteLocalInt(GetModule(),sID+HABD_ONENTER_INSTANTBLEED_VAR)));
    }

    //save info to the DB, and print a log message
    HABDSetDBString(GetExitingObject(), TRUE);
}
//******************************************************************************


// This function checks that the player is not jumping to another area, it will
// make the player jump to the AutoRaise point when finished the travel.
void HABDJumpToAutoRaiseWP(object oPC);

void HABDJumpToAutoRaiseWP(object oPC)
{
 if ( GetArea(oPC) != OBJECT_INVALID )
  {
  if ( HABD_AUTORAISE_WAYPOINT != "")
    {
        object oRespPoint = GetWaypointByTag(HABD_AUTORAISE_WAYPOINT);
        if ( GetIsObjectValid (oRespPoint) ) //check the waypoint existes
        {
          location lRespLoc = GetLocation( oRespPoint );
          int iCommand = GetCommandable (oPC);
          if (iCommand == FALSE)
            SetCommandable(TRUE, oPC);    //make sure the PC is commandable to jump
          if(HABD_USERLANGUAGE==0)
            SendMessageToPC(oPC,"HABD: Jumping to AutoRaise Waypoint");
          else if(HABD_USERLANGUAGE==1)
            SendMessageToPC(oPC,"HABD: Saltando hacia el Punto de Ruta de Auto-Resurreccion");
          if (GetCurrentHitPoints(oPC)<=0)
          {
            effect eHealto1HP = EffectHeal(1-GetCurrentHitPoints(oPC));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eHealto1HP  , oPC );
          }
          AssignCommand (oPC,ClearAllActions(TRUE));
          AssignCommand(oPC, JumpToLocation(lRespLoc) );
          //if (iCommand == FALSE)
            //DelayCommand ( 0.001, SetCommandable(FALSE, oPC) );
       }
    }
  }
 else DelayCommand ( 1.0, HABDJumpToAutoRaiseWP(oPC) );
}
// ***************************************************************************




// ****************************************************************************
// Check to see if the player has any raise or resurrection scrolls on them.
// If they do have them then a local object will be set pointing to that item.
//   oPC - the dead player.
// Returns the number of scrolls that they possess.
int HABDCheckForRaiseRezScrolls(object oPC);

int HABDCheckForRaiseRezScrolls(object oPC)
{
    DeleteLocalObject(oPC, HABD_STORED_SCROLL);
    int iStoredCost = 1000000;
    int iCost = 0;
    int iBaseItemType;
    int iNumFound = 0;
    object oItem = GetFirstItemInInventory(oPC);
    while (GetIsObjectValid(oItem))
    {
        // Search through the scrolls
        iBaseItemType = GetBaseItemType(oItem);
        if ((iBaseItemType == BASE_ITEM_SCROLL) ||
            (iBaseItemType == BASE_ITEM_SPELLSCROLL))
        {
            // Default scrolls cannot be made plot so don't worry about it.
            // See if it matches the tags we are looking for.
            if (FindSubString(HABD_SCROLL_TAGS, ":"+GetTag(oItem)+":") != -1)
            {
                // Use the least expensive scroll the player has.
                iCost = GetGoldPieceValue(oItem) / GetItemStackSize(oItem);
                iNumFound = iNumFound + GetItemStackSize(oItem);
                if (iCost < iStoredCost)
                {
                    iStoredCost = iCost;
                    // Store the item because this is what we want to use to
                    // bring them back from the dead.
                    SetLocalObject(oPC, HABD_STORED_SCROLL, oItem);
                }
            }
        }
        oItem = GetNextItemInInventory(oPC);
    }
    return (iNumFound);
}

// *****************************************************************************




// Forces a dead player to automatically respawn.
//   oPC - the dead player who is being forced to respawn.
void HABDForceAutoRespawn(object oPC);

void HABDForceAutoRespawn(object oPC)
{
    // Make sure the player is dead.
    if (!GetIsDead(oPC) ||
      (GetLocalInt(GetModule(), HABD_PLAYER_STATE+GetPCPlayerName(oPC)+GetName(oPC)) != HABD_STATE_PLAYER_DEAD))
    {
    DeleteLocalInt(GetModule(), HABD_RESPAWN_TIMER+GetPCPlayerName(oPC)+GetName(oPC));
        return;
    }

    // Force the player to respawn.
    SetLocalInt(oPC, HABD_FORCED_RESPAWN, 1);
    AssignCommand(oPC, ExecuteScript(HABD_RESPAWN_SCRIPT, oPC));
    DeleteLocalInt(GetModule(), HABD_RESPAWN_TIMER+GetPCPlayerName(oPC)+GetName(oPC));
    if(HABD_USERLANGUAGE==0)
        FloatingTextStringOnCreature("OOC: Automatically respawning "+GetName(oPC)+" because timer elapsed.", oPC, TRUE);
    else if(HABD_USERLANGUAGE==1)
        FloatingTextStringOnCreature("OOC: Respawnando Automaticamente "+GetName(oPC)+" porque paso el tiempo.", oPC, TRUE);

    AssignCommand(oPC, JumpToLocation(GetLocation(GetObjectByTag(HABD_RESPAWNPOINT))));
    return;
}

// ****************************************************************************

// Forces a dead player to automatically raise.
//   oPC - the dead player who is being forced to raise.
void HABDForceAutoRaise(object oPC);

void HABDForceAutoRaise(object oPC)
{
    // Make sure the player is dead.
    int iState = GetLocalInt(GetModule(), HABD_PLAYER_STATE+GetPCPlayerName(oPC)+GetName(oPC));
    if ((iState != HABD_STATE_PLAYER_DEAD) &&
        (iState != HABD_STATE_RESPAWNED_GHOST))
    {
        DeleteLocalInt(GetModule(), HABD_RAISE_TIMER+GetPCPlayerName(oPC)+GetName(oPC));
        return;
    }
    DeleteLocalInt(GetModule(), HABD_RAISE_TIMER+GetPCPlayerName(oPC)+GetName(oPC));
    // If force raise uses up scrolls, then do so.
    if (HABD_FORCE_RAISE_USES_SCROLLS)
    {
        object oScroll = GetLocalObject(oPC, HABD_STORED_SCROLL);
        if (GetItemPossessor(oScroll) == oPC)
        {
            int iStackSize = GetItemStackSize(oScroll);
            // Only one item so destroy it, this is why it should only use scrolls.
            // If it uses a charged item, then this could be wasted.
            if (iStackSize == 1) DestroyObject(oScroll);
            else SetItemStackSize(oScroll, iStackSize - 1);
        } else {
            if(HABD_USERLANGUAGE==0)
                FloatingTextStringOnCreature("OOC: Auto-raise aborted for "+GetName(oPC)+" because could not find any scrolls.", oPC, TRUE);
            else if(HABD_USERLANGUAGE==1)
                FloatingTextStringOnCreature("OOC: Auto-resurreccion abortado para "+GetName(oPC)+" por que no se encontro ningun pergamino.", oPC, TRUE);
            return;
        }
        DeleteLocalObject(oPC, HABD_STORED_SCROLL);
    }
    // Copy of Raise Dead spell script since you can't make a dead player cast raise at themself.
    if (GetIsDead(oPC))
    {
        if (HABD_AUTORAISE_VFX == 1)
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RAISE_DEAD), GetLocation(oPC));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
        HABDApplyPenaltyIfDead(oPC, SPELL_RAISE_DEAD);
    } else {
        HABDCureRespawnGhost(oPC, SPELL_RAISE_DEAD);
    }
    // Force the player to respawn (raise to alive).
    if(HABD_USERLANGUAGE==0)
        FloatingTextStringOnCreature("OOC: Automatically raising "+GetName(oPC)+" because timer elapsed.", oPC, TRUE);
    else if(HABD_USERLANGUAGE==1)
        FloatingTextStringOnCreature("OOC: Resucitando automaticamente a "+GetName(oPC)+" porque paso el tiempo.", oPC, TRUE);
    // Move the player to AutoRaise waypoint
    if (HABD_AUTORAISE_WAYPOINT != "")
        HABDJumpToAutoRaiseWP(oPC);

    return;
}

//******************************************************************************



/* Remarks about timers:
When you set a timer like this:
AssignCommand(oPC, DelayCommand(fRespawn, ProcessToDo() )  );
Before patch 1.64 The timer runs with the PC.. until he lives the server or the
delay is finished. It means that, when the PC logs out, the delay process die
forever. It was a feature.
After patch 1.64 it doesnt happen... it means that the workaround for previous
patches can produce a bug, and some things are more difficult now. :(
To make HABD compatible with all versions we use a system that could cause a bug
(having two or more autoraising counters at the same time when login/logout)
but these counters will die if there are more process modyfing the counters ;)
Only the last Counter set will be valid.
*/

// It ensures that, if a PC leaves when the autoraising timer is running, this
// timer will be somewhat decremented (otherwise it is reseted to maximun)
//   oPC - the dead player who is being forced to raise.
// It is executed one time per minute (default)
void HABDAutoRaiseTimerUpdater(object oPC, int iSureCount);

void HABDAutoRaiseTimerUpdater(object oPC, int iSureCount)
{
    if (HABD_AUTOTIMERS_UPDATE <= 0)
    return;
    // Make sure the player is login
    if ( GetPCPlayerName(oPC) == "" )
    return;
    // Make sure the player is dead.
    int iState = GetLocalInt(GetModule(), HABD_PLAYER_STATE+GetPCPlayerName(oPC)+GetName(oPC));
    if ((iState != HABD_STATE_PLAYER_DEAD) && (iState != HABD_STATE_RESPAWNED_GHOST))
    return;
    //check if the timer was already deleted by some reason (usually by function
    // HABDForceAutoRaise )
    int iTimer = GetLocalInt(GetModule(), HABD_RAISE_TIMER+GetPCPlayerName(oPC)+GetName(oPC));
    if ( iTimer == 0 )
    return;
    //Make sure that no other HABDAutoRaiseTimerUpdater process is working,
    //otherwise kill this process.
    if (iSureCount != iTimer)
    return;
    //if iTimer should be updated to negative or 0, end of timer checking and
    //call AutoRaise
    if ( HABD_AUTOTIMERS_UPDATE >= iTimer )
    {
        HABDForceAutoRaise(oPC);
        return;
    }
    //Decrement timer
    iTimer = iTimer - HABD_AUTOTIMERS_UPDATE;
    //Save timer to local variable
    SetLocalInt(GetModule(), HABD_RAISE_TIMER+GetPCPlayerName(oPC)+GetName(oPC), iTimer);
    //delay the next check process
    AssignCommand(oPC, DelayCommand(IntToFloat(HABD_AUTOTIMERS_UPDATE), HABDAutoRaiseTimerUpdater(oPC, iTimer)));
    return;
}

// It ensures that, if a PC leaves when the autorespawn timer is running, this
// timer will be somewhat decremented (otherwise it is reseted to maximun)
//   oPC - the dead player who is being forced to respawn.
// It is executed one time per minute (default)
void HABDAutoRespawnTimerUpdater(object oPC, int iSureCount);

void HABDAutoRespawnTimerUpdater(object oPC, int iSureCount)
{
    if (HABD_AUTOTIMERS_UPDATE <= 0)
    return;
     // Make sure the player is login
    if ( GetPCPlayerName(oPC) == "" )
    return;
    // Make sure the player is dead.
    int iState = GetLocalInt(GetModule(), HABD_PLAYER_STATE+GetPCPlayerName(oPC)+GetName(oPC));
    if (iState != HABD_STATE_PLAYER_DEAD)
    return;
    //check if the timer was already deleted by some reason (usually by function
    // ForceAutoRespawn in script "habd_onpcdeath")
    int iTimer = GetLocalInt(GetModule(), HABD_RESPAWN_TIMER+GetPCPlayerName(oPC)+GetName(oPC));
    if ( iTimer == 0 )
    return;
    //Make sure that no other HABDAutoRaiseTimerUpdater process is working,
    //otherwise kill this process.
    if (iSureCount != iTimer)
    return;
    //if iTimer should be updated to negative or 0, end of timer checking
    //Force AutoRespawn
    if ( HABD_AUTOTIMERS_UPDATE >= iTimer )
    {
        HABDForceAutoRespawn(oPC);
        return;
    }
    //Decrement timer
    iTimer = iTimer - HABD_AUTOTIMERS_UPDATE;
    //Save timer to local variable
    SetLocalInt(GetModule(), HABD_RESPAWN_TIMER+GetPCPlayerName(oPC)+GetName(oPC), iTimer);
    //delay the next check process
    AssignCommand(oPC, DelayCommand(IntToFloat(HABD_AUTOTIMERS_UPDATE), HABDAutoRespawnTimerUpdater(oPC,iTimer)));
    return;
}

// *****************************************************************************



// HABD_GetIsSafeArea. It checks if the area where oPC is placed, is defined as
// a Safe Area (no death or bleeding).
// Returns TRUE if it is a Safe area.
int HABD_GetIsSafeArea(object oPC);

int HABD_GetIsSafeArea(object oPC)
{
    //at least first area must be specified- for better performance
    if ( HABD_SAFEAREA_RESREF_1 == "")
        return FALSE;

    object oArea = GetArea (oPC);
    string sArea = "";
    if ( oArea != OBJECT_INVALID )
        sArea = GetResRef(oArea);
    if (sArea != "")
    if (sArea == HABD_SAFEAREA_RESREF_1 || sArea == HABD_SAFEAREA_RESREF_2 ||
        sArea == HABD_SAFEAREA_RESREF_3 || sArea == HABD_SAFEAREA_RESREF_4 ||
        sArea == HABD_SAFEAREA_RESREF_5 || sArea == HABD_SAFEAREA_RESREF_6 ||
        sArea == HABD_SAFEAREA_RESREF_7 || sArea == HABD_SAFEAREA_RESREF_8 ||
        sArea == HABD_SAFEAREA_RESREF_9 || sArea == HABD_SAFEAREA_RESREF_10
        )
        return TRUE;

    //else
   return FALSE;
}


// HABD_GetIsHardArea. It checks if the area where oPC is placed, is defined as
// a Hard Area (where instant death is allowed and bleeding cap is minimun).
// Returns TRUE if it is a hard area.
int HABD_GetIsHardArea(object oPC);

int HABD_GetIsHardArea(object oPC)
{
    //at least first area must be specified- for better performance
    if ( HABD_HARDAREA_RESREF_1 == "")
        return FALSE;

    object oArea = GetArea (oPC);
    string sArea = "";
    if ( oArea != OBJECT_INVALID )
        sArea = GetResRef(oArea);
    if (sArea != "")
    if (sArea == HABD_HARDAREA_RESREF_1 || sArea == HABD_HARDAREA_RESREF_2 ||
        sArea == HABD_HARDAREA_RESREF_3 || sArea == HABD_HARDAREA_RESREF_4 ||
        sArea == HABD_HARDAREA_RESREF_5 || sArea == HABD_HARDAREA_RESREF_6 ||
        sArea == HABD_HARDAREA_RESREF_7 || sArea == HABD_HARDAREA_RESREF_8 ||
        sArea == HABD_HARDAREA_RESREF_9 || sArea == HABD_HARDAREA_RESREF_10 ||
        sArea == HABD_HARDAREA_RESREF_11 || sArea == HABD_HARDAREA_RESREF_12 ||
        sArea == HABD_HARDAREA_RESREF_13 || sArea == HABD_HARDAREA_RESREF_14 ||
        sArea == HABD_HARDAREA_RESREF_15 || sArea == HABD_HARDAREA_RESREF_16 ||
        sArea == HABD_HARDAREA_RESREF_17 || sArea == HABD_HARDAREA_RESREF_18 ||
        sArea == HABD_HARDAREA_RESREF_19 || sArea == HABD_HARDAREA_RESREF_20)
        return TRUE;

    //else
   return FALSE;
}


//******************************************************************************
// HABDBindstoneLocationToDB. Saves the location to the HABD DB, to do so we
// use a secure workaround (locations are not relyable, because the object
// area can changed when the server restart). So, we save the location
// (X Y Z position and orientation) and the Tag of the Area.
void HABDBindstoneLocationToDB(location lBDLoc, object oPC);

void HABDBindstoneLocationToDB(location lBDLoc, object oPC)
{
    if ( HADB_DB_PERSISTENT == TRUE & HABD_BINDSTONE_PERSISTENT == TRUE )
    {
        object oArea = GetAreaFromLocation(lBDLoc);
        if (oArea != OBJECT_INVALID)
        {
            string sName = GetName(oPC);
            object oMod = GetModule();
            //recover Player Name
            string sID = "";
            string sPlayerName = "";
            sPlayerName = HABDPlayerName(oPC);
            sID = sPlayerName+sName;

            // Database index is limited to 32 characters.

            // The location info is not packed as happens with the rest of DB info.
            //SetCampaignLocation(HABD_DB_NAME, GetStringLeft(HABD_PERSIST_BINDSTONELOC_NAME+sID,32), lBDLoc);
            HABDSaveBSLocationToDB(lBDLoc, sPlayerName, sName);

            // Area Tag is packed with the usual info, we will also use it to
            // save all info to DB.
            HABDSetDBString(oPC);
        }
    }
}

//******************************************************************************


// Will search for the "best" dinamic respawning item in PCs inventory and
// containers and will set the Local variable that stores the dinamic
// configuration.
// Furthermore it will return this item id (OBJECT_INVALID if not found or if
// the item was not better than the Cap).
// Modify for your custom usage if you wish or needs.
// Default = If no item is found, the dinamic repawn variable will set to this
//  value, a negative number means that the variable will remain unchanged.
// Cap = The better item found must have a number equal or greater to Cap,
//  otherwise the dinamic variable number will remain unchanged.
// The greater the number, better the respawning option (less penalties etc..)
// sItem = Tag prefix, dinamic items have by default tags TagPrefix1 TagPrefix2
// etc... , if you indicate ByTag (optional) as FALSE, it uses sItem as Resref
// prefix.
// int LookContainers = TRUE, if FALSE it will not look into containers
// HABD_DINAMICSET_ITEM_PREFIX_TAG = Constant, default "HABD_DINSETIT"
object HABDSetDinamicRespawnByItem(object oPlayer, int Default = -1, int Cap=0 ,string sItem = HABD_DINAMICSET_ITEM_PREFIX_TAG, int ByTag = TRUE, int LookContainers = TRUE);

object HABDSetDinamicRespawnByItem(object oPlayer, int Default = -1, int Cap=0 ,string sItem = HABD_DINAMICSET_ITEM_PREFIX_TAG, int ByTag = TRUE, int LookContainers = TRUE)
{
 // Check if oPlayer already have item.
 object oItemPC = GetFirstItemInInventory(oPlayer);
 object oItemC = OBJECT_INVALID;
 string sTagorResref="";
 int iPrefixlength = GetStringLength(sItem);
 int iValue = Default;
 string sNumber = "";
 int i;
 object oHABDItem = OBJECT_INVALID;

 while ( GetIsObjectValid(oItemPC) )
 {
    if (ByTag == FALSE)
        sTagorResref = GetResRef(oItemPC);
            else
                sTagorResref = GetTag(oItemPC);
  if ( GetSubString(sTagorResref,0, iPrefixlength) == sItem )
   {
     //extract the number from the tag
     sNumber = GetSubString(sTagorResref,iPrefixlength, GetStringLength(sTagorResref)-iPrefixlength);
     i = StringToInt(sNumber);
     if (i > iValue)
        {
        iValue = i;
        oHABDItem = oItemPC;
        }
   }
    //check if it is a container and look inside
    if ( GetHasInventory(oItemPC) == TRUE && LookContainers == TRUE)
    {
        oItemC = GetFirstItemInInventory(oItemPC);
        sTagorResref="";
        while ( GetIsObjectValid(oItemC) )
        {
            if (ByTag == FALSE)
                sTagorResref = GetResRef(oItemC);
                    else
                        sTagorResref = GetTag(oItemC);
            if ( GetSubString(sTagorResref,0, iPrefixlength) == sItem )
            {
                //extract the number from the tag
                sNumber = GetSubString(sTagorResref,iPrefixlength, GetStringLength(sTagorResref)-iPrefixlength);
                i = StringToInt(sNumber);
                if (i > iValue)
                    {
                    iValue = i;
                    oHABDItem = oItemC;
                    }
            }
            oItemC = GetNextItemInInventory(oItemPC);
        }
    }
    //end of container checks

  oItemPC = GetNextItemInInventory(oPlayer);
 }

 //finished looking at inventory, change the value if needed
 //Customize this for special numbers that should not be overwritted.
 if (iValue>= 0 && iValue>=Cap )
    SetLocalInt(oPlayer,HABD_DINAMIC_OPTION1,iValue);
 if (iValue>= 0 && iValue>=Cap )
    return oHABDItem;
    else
    return OBJECT_INVALID;
}

//This function returns the XP % (0 to 100) lost when respawning, for the
//dinamic config item of number iDinamic.
//You must customize it for your custom dinamic settings.
//iDefault will be returned if the item doesnt changes the XP penalties or if
//the number iDinamic is not recogniced, usually when you call this function
//iDefault must be the XP lost by default in HABD config constants. Otherwise you
//should use a negative value.
int HABDDinamicRespawnXP(int iDinamic, int iDefault);
int HABDDinamicRespawnXP(int iDinamic, int iDefault)
{
    switch (iDinamic)
    {
    case 4: return 30; break;
    case 5: return 45; break;
    case 6: return 15;  break;
    case 3: return 0;  break;
    default: return iDefault;
    }

    return iDefault;
}

//This function returns the GP % (0 to 100) lost when respawning, for the
//dinamic config item of number iDinamic.
//You must customize it for your custom dinamic settings.
//iDefault will be returned if the item doesnt changes the GP penalties or if
//the number iDinamic is not recogniced, usually when you call this function
//iDefault must be the GP lost by default in HABD config constants. Otherwise you
//should use a negative value.
int HABDDinamicRespawnGP(int iDinamic, int iDefault);
int HABDDinamicRespawnGP(int iDinamic, int iDefault)
{
    switch (iDinamic)
    {
    case 4: return 30; break;
    case 5: return 45; break;
    case 6: return 15;  break;
    case 3: return 0;  break;
    default: return iDefault;
    }

    return iDefault;
}

//Returns a number that says what is the configuration from HABD constants, it
//is mainly used by the function HABDDinamicRespawnTeleport .
//0: No teleporting, 1: Teleport to the Respawn Point, 2: Teleport to BindStone.
int HABDRespawnTeleportNumber();
int HABDRespawnTeleportNumber()
{
  //this function must not be customized
  if (HABD_BINDSTONE_USEWHENRESPAWNED == TRUE)
  return 2;
     else
     {
     if (HABD_RESPAWNPOINT!="")
     return 1;
            else
            return 0;
     }
}
//This function tells to HABD if the Dinamic configuration of number iDinamic
//changes the default configuration from constants. That Configuration must be
//communicated with this numbers:
//0: No teleporting, 1: Teleport to the Respawn Point, 2: Teleport to BindStone.
//2 Will only work if at least HABD_BINDSTONE_PERSISTENT constant is TRUE ;)
//iDefault must be the configuration by default in HABD config constants [it can
//be known using the function HABDRespawnTeleportNumber() ].
//Otherwise you should use a negative value for default.
//Note that this function can not change the Respawn Waypoint.
int HABDDinamicRespawnTeleport(int iDinamic, int iDefault);
int HABDDinamicRespawnTeleport(int iDinamic, int iDefault)
{
    switch (iDinamic)
    {
    case 4: return 1; break;
    case 5: return 2; break;
    case 6: return 0; break;
    case 3: return 1; break;
    default: return iDefault;
    }

    return iDefault;
}

// It returns a number that says what type of AutoRaising is ALLOWED, it does
// NOT configure the AutoRaise, but it will STOP some default features of
// configuration constants.
// E.g. .. if you dont turn HABD_RESPAWN_IS_RAISE to TRUE, no item will instantly
// raise the player.
// 0: Timer AutoRaise allowed, Raise when Respawn Allowed. HardCore Mode can Disallow
// 1: Raising when Respawn is NOT allowed. Timer AutoRaise allowed.
//      HardCore Mode can Disallow
// 2: Timer AutoRaising is NOT Allowed. Raising when Respawn is NOT allowed.
//        (can only be raised by DM or Players).
// 3: Timer AutoRaise allowed, Raise when Respawn Allowed. HardCore Mode has NO
//        Effect (is skipped)
// 4: Raising when Respawn is NOT allowed. Timer AutoRaise allowed.
//      HardCore Mode has NO Effect (is skipped)
//
// If error returns iDefault (default -1).
int HABDDinamicRespawnAutoRaise(int iDinamic, int iDefault = -1);
int HABDDinamicRespawnAutoRaise(int iDinamic, int iDefault = -1)
{
switch (iDinamic)
    {
    case 4: return 3; break;
    case 5: return 3; break;
    case 6: return 4; break;
    case 3: return 0; break;
    default: return iDefault;
    }

    return iDefault;
}

// ****************************************************************************

//Must return TRUE or FALSE. If TRUE the conditions for HardCore Mode are met.
//HardCore mode means that the PC can not benefit from Autoraising or Raising
//when Respawning.
int HABDHardCoreRespawn(object oPC);
int HABDHardCoreRespawn(object oPC)
{
    int iHardC = FALSE;
    object oMod = GetModule();
    string sID = GetPCPlayerName(oPC)+GetName(oPC);
    int DeathCount = GetLocalInt(oMod, HABD_DEATH_COUNT+sID); //number of times the PC has died
    int PC_Con = GetAbilityScore(oPC, ABILITY_CONSTITUTION);
    int PCLevel = GetHitDice (oPC);
    //int BleedCount = GetLocalInt(oMod, HABD_BLEED_COUNT+sID); //idem with bleeding
    //int LostXPCount = GetLocalInt(oMod, HABD_LOST_XP_COUNT+sID); //Total XP lost
    //int LosGPCount = GetLocalInt(oMod, HABD_LOST_GP_COUNT+sID);  //Total GP lost
    //int PC_AloneInArea = HABDPlayerAloneInArea(oPC);

    //First, check conditions.
    //E.g. Default one, you have Con+Level Lives
    if (DeathCount > PC_Con + PCLevel)
        iHardC = TRUE;

    //Check for a "Life Token" item, default Tag is "HABD_HCRLIFET1".
    object oExtraLife = GetItemPossessedBy(oPC, HABD_HARDCORE_RESPAWN_LIFETOKEN_TAG);
    if ( oExtraLife != OBJECT_INVALID )
        {
            DestroyObject(oExtraLife);
            iHardC = FALSE;
        }

    return iHardC;
}

// ****************************************************************************








// ****************************************************************************
// ASSOCIATE FUNCTIONS
// ****************************************************************************

const int HABD_NW_ASC_IS_BUSY = 0x40000000;

void HABDAssociateBusy()
{
    int nPlot = GetLocalInt(OBJECT_SELF, "NW_ASSOCIATE_MASTER");
    nPlot = nPlot | HABD_NW_ASC_IS_BUSY;
    SetLocalInt(OBJECT_SELF, "NW_ASSOCIATE_MASTER", nPlot);
}

void HABDAssociateNotBusy()
{
    int nPlot = GetLocalInt(OBJECT_SELF, "NW_ASSOCIATE_MASTER");
    nPlot = nPlot & ~HABD_NW_ASC_IS_BUSY;
    SetLocalInt(OBJECT_SELF, "NW_ASSOCIATE_MASTER", nPlot);
}

void HABDRecoverHenchmanInstantDeath()
{
    // Should regeneration items be removed from bleeding players?
    if (HABD_NERF_REGENERATION_ITEMS)
    {
        AssignCommand(OBJECT_SELF, HABDRegenerationItemsUnequip(OBJECT_SELF));
    }

    // Keep the player from taking additional damage while bleeding.
    SetPlotFlag(OBJECT_SELF, TRUE);
    // Bring the player back from death and make them bleed.
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), OBJECT_SELF);
    int iBleed = 1+Random(4);
    // Give them back their master.
    //AddHenchman(GetLocalObject(oPC, HABD_NPC_MASTER), oPC);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectTemporaryHitpoints(10), OBJECT_SELF);
    // Ten minutes should be enough for the NPC to bleed to death.
    AssignCommand(OBJECT_SELF, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0, 6.0));
    SetPlotFlag(OBJECT_SELF, FALSE);
    // Will leave player at -6 to -9
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iBleed, DAMAGE_TYPE_POSITIVE, DAMAGE_POWER_PLUS_FIVE), OBJECT_SELF);
    SetPlotFlag(OBJECT_SELF, TRUE);
    // stop nearby attackers
    AssignCommand(OBJECT_SELF, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectInvisibility(INVISIBILITY_TYPE_NORMAL), OBJECT_SELF, 6.0));
}

int HABDMakeHenchmanBleed()
{
    // Bleeding for Henchmen is not allowed?
    if (HABD_HENCHMEN_BLEED == FALSE)
        return FALSE;

    // Only run on henchmen.
    if (GetAssociate(ASSOCIATE_TYPE_HENCHMAN, GetMaster()) != OBJECT_SELF) return FALSE;
    string sID = GetPCPlayerName(OBJECT_SELF)+GetName(OBJECT_SELF);
    object oMod = GetModule();    //DEBUG: Not Translated
    if (HABD_DEBUG) SpeakString("DEBUG: HABD OnHenchmanDeath, "+GetName(OBJECT_SELF)+", HP: "+IntToString(GetCurrentHitPoints(OBJECT_SELF))+", master: "+GetName(GetMaster(OBJECT_SELF))+", state:"+HABDGetPlayerStateName(OBJECT_SELF), TALKVOLUME_SHOUT);

    // Check to see if they have bled at all - if not then give them a chance to bleed.
    int iState = GetLocalInt(oMod, HABD_PLAYER_STATE+sID);
    if ((iState == HABD_STATE_PLAYER_DEAD) || (iState == HABD_STATE_PLAYER_BLEEDING) || HABD_HENCHMEN_BLEED ==3 || HABD_HENCHMEN_BLEED ==2 )
    {
        // The henchmen is supposed to be dead.
        if (HABD_HENCHMEN_GHOST_RESPAWN)
        {
            // Run the ghost respawn on the henchman.
            DelayCommand(1.0, ExecuteScript("habd_onpcdeath", OBJECT_SELF));
            SetLocalInt(OBJECT_SELF, HABD_NPC_BLEED, 1);
            SetLocalObject(OBJECT_SELF, HABD_NPC_MASTER, GetMaster(OBJECT_SELF));
        } else {
            // Run the normal death stuff.
            SetIsDestroyable(TRUE, TRUE, TRUE);
            HABDAssociateNotBusy();
            return FALSE;
        }
    }
    else
    {
        // Player died without going through bleeding.
        // Special state for this circumstance.
        SetLocalInt(oMod, HABD_PLAYER_STATE+sID, HABD_STATE_PLAYER_INSTANT_DEATH);
        // The henchman is supposed to be bleeding.
        DelayCommand(1.0, ExecuteScript("habd_onpcdying", OBJECT_SELF));
        DelayCommand(0.5, HABDRecoverHenchmanInstantDeath());
    }
    // Keep the associate from healing themselves. Stay dead, dammit!
    HABDAssociateBusy();
    // Keep the corpse from fading because we have to bring it back from death.
    SetIsDestroyable(FALSE, TRUE, TRUE);
    // Check to see if they have bled at all - if not then give them a chance to bleed.
    if (GetLocalInt(oMod, HABD_PLAYER_STATE+sID) != HABD_STATE_PLAYER_DEAD && (HABD_HENCHMEN_BLEED != 2 || HABD_HENCHMEN_BLEED != 3)  )
    {
        // Player died without going through bleeding.
        // Special state for this circumstance.
        SetLocalInt(oMod, HABD_PLAYER_STATE+sID, HABD_STATE_PLAYER_INSTANT_DEATH);
    }
    SetLocalInt(OBJECT_SELF, HABD_NPC_BLEED, 1);
    SetLocalObject(OBJECT_SELF, HABD_NPC_MASTER, GetMaster(OBJECT_SELF));
    return TRUE;
}

// Saves the current state of all players.
void HABDSetDBStringForAllPlayers();

void HABDSetDBStringForAllPlayers()
{
  object oPC = GetFirstPC();

  while (GetIsObjectValid(oPC))
  {
    if (!GetIsDM(oPC))
    {
      HABDSetDBString(oPC);
    }
    oPC = GetNextPC();
  }
}
