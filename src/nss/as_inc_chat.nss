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
                "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_EYNNELIC)      + " <cþþþ>... " +
                "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_EYNNELIC)    + "\n" + 

                (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_ORIS,     oSpeaker) ? "<cþôh>" : "<cþ((>") +
                "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_ORIS)     + " <cþþþ>... " +
                "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_ORIS)   + "\n" +

                (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_ADHEAS,     oSpeaker) ? "<cþôh>" : "<cþ((>") +
                "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_ADHEAS)     + " <cþþþ>... " +
                "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_ADHEAS)   + "\n" +

                (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_ADHEAS,     oSpeaker) ? "<cþôh>" : "<cþ((>") +
                "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_ADHEAS)     + " <cþþþ>... " +
                "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_ADHEAS)   + "\n" +

                (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_DORVIN,     oSpeaker) ? "<cþôh>" : "<cþ((>") +
                "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_DORVIN)     + " <cþþþ>... " +
                "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_DORVIN)   + "\n" +

                (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_VUTA,     oSpeaker) ? "<cþôh>" : "<cþ((>") +
                "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_VUTA)     + " <cþþþ>... " +
                "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_VUTA)   + "\n" +

                (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_OLD_DULRIC,     oSpeaker) ? "<cþôh>" : "<cþ((>") +
                "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_OLD_DULRIC)     + " <cþþþ>... " +
                "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_OLD_DULRIC)   + "\n" +

                (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_LOW_ELDARIS,     oSpeaker) ? "<cþôh>" : "<cþ((>") +
                "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_LOW_ELDARIS)     + " <cþþþ>... " +
                "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_LOW_ELDARIS)   + "\n" +

                (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_RUDHEAS,     oSpeaker) ? "<cþôh>" : "<cþ((>") +
                "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_RUDHEAS)     + " <cþþþ>... " +
                "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_RUDHEAS)   + "\n" +

                (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_RASHEMI,     oSpeaker) ? "<cþôh>" : "<cþ((>") +
                "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_RASHEMI)     + " <cþþþ>... " +
                "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_RASHEMI)   + "\n" +

                (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_ROST,     oSpeaker) ? "<cþôh>" : "<cþ((>") +
                "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_ROST)     + " <cþþþ>... " +
                "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_ROST)   + "\n" +

                (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_BOSHA,     oSpeaker) ? "<cþôh>" : "<cþ((>") +
                "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_BOSHA)     + " <cþþþ>... " +
                "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_BOSHA)   + "\n" +

                (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_VEYDISH,     oSpeaker) ? "<cþôh>" : "<cþ((>") +
                "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_VEYDISH)     + " <cþþþ>... " +
                "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_VEYDISH)   + "\n" + 

                (gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_VIVERIC,     oSpeaker) ? "<cþôh>" : "<cþ((>") +
                "/dm -" + gsLAGetLanguageKey(GS_LA_LANGUAGE_VIVERIC)     + " <cþþþ>... " +
                "<cVs·>" + gsLAGetLanguageName(GS_LA_LANGUAGE_VIVERIC)
                
                
                );
        break;
    }
}


