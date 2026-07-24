/* CHAT Library by Jamesfelicia */

#include "gs_inc_language"
#include "as_inc_fxnui"
#include "as_inc_target"
#include "gs_inc_subrace"

const int CHAT_COMMAND_INVALID = -1;
const int CHAT_COMMAND_SAVE = 0;
const int CHAT_COMMAND_LANGUAGE = 1;
const int CHAT_COMMAND_MOVE_FIXTURE = 2;
const int CHAT_COMMAND_ROLL_DICE = 3;
const int CHAT_COMMAND_REPUTATION_VIEW = 4;
const int CHAT_COMMAND_REPUTATION_GIVE = 5;
const int CHAT_COMMAND_MODIFY_EARS = 6;
const int CHAT_COMMAND_MODIFY_TAIL = 7;
const int CHAT_COMMAND_MODIFY_WHISPERSTALKER = 8;
const int CHAT_COMMAND_SET_COLOR_SKIN = 9;
const int CHAT_COMMAND_SET_COLOR_HAIR = 10;
const int CHAT_COMMAND_MODIFY_VEYDRAN = 11;
const int CHAT_COMMAND_MODIFY_SCALE = 12;

//return matching integer if tag matches a chat command
int gsCTGetChatCommand(string sTag);
//process a chat command
void gsCTProcessCommand(object oSpeaker, int nCommand, string sParams);


int gsCTGetChatCommand(string sTag)
{
    if(sTag == "save") return CHAT_COMMAND_SAVE;
    if(sTag == "language") return CHAT_COMMAND_LANGUAGE;
    if(sTag == "move") return CHAT_COMMAND_MOVE_FIXTURE;
    if(sTag == "roll") return CHAT_COMMAND_ROLL_DICE;
    if(sTag == "rep" || sTag == "reputation") return CHAT_COMMAND_REPUTATION_VIEW;
    if(sTag == "giverep") return CHAT_COMMAND_REPUTATION_GIVE;
    if(sTag == "ears") return CHAT_COMMAND_MODIFY_EARS;
    if(sTag == "tail") return CHAT_COMMAND_MODIFY_TAIL;
    if(sTag == "cat") return CHAT_COMMAND_MODIFY_WHISPERSTALKER;
    if(sTag == "skin") return CHAT_COMMAND_SET_COLOR_SKIN;
    if(sTag == "hair") return CHAT_COMMAND_SET_COLOR_HAIR;
    if(sTag == "veydran") return CHAT_COMMAND_MODIFY_VEYDRAN;
    if(sTag == "scale") return CHAT_COMMAND_MODIFY_SCALE;
    return CHAT_COMMAND_INVALID;
}

void gsCTProcessCommand(object oSpeaker, int nCommand, string sParams){
    int nParam = StringToInt(sParams);
    switch(nCommand)
    {
        case CHAT_COMMAND_INVALID:
        break;
        case CHAT_COMMAND_SAVE:
            SendMessageToPC(oSpeaker, "Save command not yet implemented. Captured params:" + sParams);
        break;
        case CHAT_COMMAND_MOVE_FIXTURE:
            asFXMoveObjectNUI(oSpeaker);
        break;
        case CHAT_COMMAND_ROLL_DICE:
            SetLocalString(oSpeaker, "dmfi_univ_conv", "pc_dicebag");
            AssignCommand(oSpeaker, ClearAllActions());
            AssignCommand(oSpeaker, ActionStartConversation(OBJECT_SELF, "dmfi_universal", TRUE, FALSE));
        break;
        case CHAT_COMMAND_REPUTATION_VIEW:
            if(GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
            {
                SetLocalInt(oSpeaker, "AS_TARGET_MODE_ID", TARGETING_MODE_REPUTATION_VIEW);
                EnterTargetingMode(oSpeaker, OBJECT_TYPE_CREATURE);
            }
        break;
        case CHAT_COMMAND_REPUTATION_GIVE:
            if(GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
            {
                SetLocalInt(oSpeaker, "AS_TARGET_MODE_ID", TARGETING_MODE_REPUTATION_GIVE);
                SetLocalInt(oSpeaker, "AS_REPUTATION_CHANGE", nParam);
                EnterTargetingMode(oSpeaker, OBJECT_TYPE_CREATURE);
            }
        break;
        case CHAT_COMMAND_MODIFY_EARS:
            if(GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker) || (gsSUGetHasCatEars(gsSUGetSubRace(oSpeaker)))){
                AssignCommand(oSpeaker, ClearAllActions());
                AssignCommand(oSpeaker, ActionStartConversation(OBJECT_SELF, "as_ears", TRUE, FALSE));
            }
        break;
        case CHAT_COMMAND_MODIFY_TAIL:
            if(GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker) || (gsSUGetHasCatTail(gsSUGetSubRace(oSpeaker)) && GetLocalInt(GetArea(oSpeaker), "AS_CUSTOMIZE") == TRUE)){
                AssignCommand(oSpeaker, ClearAllActions());
                AssignCommand(oSpeaker, ActionStartConversation(OBJECT_SELF, "as_tails", TRUE, FALSE));
            }
        break;
        case CHAT_COMMAND_MODIFY_WHISPERSTALKER:
            if(GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker) || (gsSUGetHasCatModel(gsSUGetSubRace(oSpeaker)) && GetLocalInt(GetArea(oSpeaker), "AS_CUSTOMIZE") == TRUE)){
                AssignCommand(oSpeaker, ClearAllActions());
                AssignCommand(oSpeaker, ActionStartConversation(OBJECT_SELF, "as_cats", TRUE, FALSE));
            }
        break;
        case CHAT_COMMAND_MODIFY_VEYDRAN:
            if(GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker) || (gsSUGetIsVeydran(gsSUGetSubRace(oSpeaker)) && GetLocalInt(GetArea(oSpeaker), "AS_CUSTOMIZE") == TRUE)){
                AssignCommand(oSpeaker, ClearAllActions());
                AssignCommand(oSpeaker, ActionStartConversation(OBJECT_SELF, "as_vey", TRUE, FALSE));
            }
        break;
        case CHAT_COMMAND_SET_COLOR_SKIN:
            if(GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker) || GetLocalInt(GetArea(oSpeaker), "AS_CUSTOMIZE") == TRUE)
            {
                SetColor(oSpeaker, COLOR_CHANNEL_SKIN, nParam);
            }
        break;
        case CHAT_COMMAND_SET_COLOR_HAIR:
            if(GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker) || GetLocalInt(GetArea(oSpeaker), "AS_CUSTOMIZE") == TRUE)
            {
                SetColor(oSpeaker, COLOR_CHANNEL_HAIR, nParam);
            }
        break;
        case CHAT_COMMAND_MODIFY_SCALE:
            if(GetIsDM(oSpeaker) || GetIsDMPossessed(oSpeaker))
            {
                AssignCommand(oSpeaker, ClearAllActions());
                AssignCommand(oSpeaker, ActionStartConversation(OBJECT_SELF, "as_scale", TRUE, FALSE));
            }
        break;
        case CHAT_COMMAND_LANGUAGE:
            SendMessageToPC(
                oSpeaker,
                GS_T_16777343 + ":\n" +
                                                                                 "<cþôh>" +
                "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_COMMON)      + " <cþþþ>... " +
                "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_COMMON)    + "\n" +

                (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_ABYSSAL,     oSpeaker) ? "<cþôh>" : "<cþ((>") +
                "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_ABYSSAL)     + " <cþþþ>... " +
                "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_ABYSSAL)   + "\n" +

                (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_ANIMAL,      oSpeaker) ? "<cþôh>" : "<cþ((>") +
                "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_ANIMAL)      + " <cþþþ>... " +
                "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_ANIMAL)    + "\n" +

                (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_CELESTIAL,   oSpeaker) ? "<cþôh>" : "<cþ((>") +
                "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_CELESTIAL)   + " <cþþþ>... " +
                "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_CELESTIAL) + "\n" +

                (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_DRACONIC,    oSpeaker) ? "<cþôh>" : "<cþ((>") +
                "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_DRACONIC)    + " <cþþþ>... " +
                "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_DRACONIC)  + "\n" +

                (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_DWARVEN,     oSpeaker) ? "<cþôh>" : "<cþ((>") +
                "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_DWARVEN)     + " <cþþþ>... " +
                "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_DWARVEN)   + "\n" +

                (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_ELVEN,       oSpeaker) ? "<cþôh>" : "<cþ((>") +
                "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_ELVEN)       + " <cþþþ>... " +
                "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_ELVEN)     + "\n" +

                (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_GNOME,       oSpeaker) ? "<cþôh>" : "<cþ((>") +
                "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_GNOME)       + " <cþþþ>... " +
                "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_GNOME)     + "\n" +

                (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_GOBLIN,      oSpeaker) ? "<cþôh>" : "<cþ((>") +
                "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_GOBLIN)      + " <cþþþ>... " +
                "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_GOBLIN)    + "\n" +

                (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_HALFLING,    oSpeaker) ? "<cþôh>" : "<cþ((>") +
                "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_HALFLING)    + " <cþþþ>... " +
                "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_HALFLING)  + "\n" +

                (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_INFERNAL,    oSpeaker) ? "<cþôh>" : "<cþ((>") +
                "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_INFERNAL)    + " <cþþþ>... " +
                "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_INFERNAL)  + "\n" +

                (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_ORC,         oSpeaker) ? "<cþôh>" : "<cþ((>") +
                "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_ORC)         + " <cþþþ>... " +
                "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_ORC)       + "\n" +

                (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_SIGN,        oSpeaker) ? "<cþôh>" : "<cþ((>") +
                "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_SIGN)        + " <cþþþ>... " +
                "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_SIGN)      + "\n" +

                (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_THIEF,       oSpeaker) ? "<cþôh>" : "<cþ((>") +
                "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_THIEF)       + " <cþþþ>... " +
                "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_THIEF)     + "\n" +

                (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_UNDERCOMMON, oSpeaker) ? "<cþôh>" : "<cþ((>") +
                "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_UNDERCOMMON) + " <cþþþ>... " +
                "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_UNDERCOMMON));
        break;
    }
}


