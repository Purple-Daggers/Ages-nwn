#include "gs_inc_common"
#include "gs_inc_effect"
#include "gs_inc_language"
#include "gs_inc_listener"
#include "gs_inc_text"
#include "gs_inc_time"
#include "gs_inc_worship"
#include "as_inc_chat"
#include "dmfi_plychat_inc"

const string DMFI_PLAYERCHAT_SCRIPTNAME = "dmfi_plychat_exe";

string gsRateValue(int nValue, int nInaccuracy = 0)
{
    if (nInaccuracy > 0) nValue += nInaccuracy / 2 - Random(nInaccuracy + 1);
    if (nValue <= -8) return GS_T_16777464;
    if (nValue <= -5) return GS_T_16777465;
    if (nValue <= -2) return GS_T_16777466;
    if (nValue <=  1) return GS_T_16777467;
    if (nValue <=  4) return GS_T_16777468;
    if (nValue <=  7) return GS_T_16777469;
    return GS_T_16777470;
}
//----------------------------------------------------------------
void gsLook()
{
    float fDirection = GetFacing(OBJECT_SELF);
    vector vTarget   = GetPosition(OBJECT_SELF) + AngleToVector(fDirection);
    location lTarget = Location(GetArea(OBJECT_SELF), vTarget, fDirection);
    object oObject   = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTarget, TRUE);
    string sMessage  = "";
    string sString   = "";
    int nInsight     = GetHitDice(OBJECT_SELF) + GetAbilityModifier(ABILITY_WISDOM);
    int nPerform     = 0;
    int nInaccuracy  = 0;
    int nValue       = 0;

    while (GetIsObjectValid(oObject))
    {
        if (oObject != OBJECT_SELF &&
            GetObjectSeen(oObject))
        {
            sString = GetTag(oObject);

            if (sString != "GS_BOSS" &&
                sString != "GS_ENCOUNTER" &&
                sString != "GS_LISTENER")
            {
                nPerform     = GetSkillRank(SKILL_PERFORM, oObject) / 5;
                nInaccuracy  = GetSkillRank(SKILL_BLUFF, oObject) + nPerform;
                if (nInaccuracy < 10) nInaccuracy = 10;
                nInaccuracy -= nInsight;
                sMessage    += gsCMReplaceString(GS_T_16777462, GetName(oObject), IntToString(-nInaccuracy));

                //race
                sMessage    += "\n<c fþ>" + GS_T_16777458 + ": ";
                if (nInaccuracy < 0)
                {
                    sString  = GetSubRace(oObject);
                    if (sString == "")
                    {
                        nValue  = GetRacialType(oObject);
                        nValue  = StringToInt(Get2DAString("racialtypes", "Name", nValue));
                        sString = GetStringByStrRef(nValue);
                    }
                    sMessage += "<c™þþ>" + sString;
                }
                else
                {
                    sMessage += "<c°°°>" + GS_T_16777463;
                }

                //strength
                sMessage    += "\n<c fþ>" + GS_T_16777457 + ": " +
                               gsRateValue(GetAbilityScore(oObject, ABILITY_STRENGTH) - 10, nInaccuracy);

                //dexterity
                sMessage    += "\n<c fþ>" + GS_T_16777459 + ": " +
                               gsRateValue(GetAbilityScore(oObject, ABILITY_DEXTERITY) - 10, nInaccuracy);

                //constitution
                sMessage    += "\n<c fþ>" + GS_T_16777460 + ": " +
                               gsRateValue(GetAbilityScore(oObject, ABILITY_CONSTITUTION) - 10, nInaccuracy);

                //intelligence
                sMessage    += "\n<c fþ>" + GS_T_16777473 + ": " +
                               gsRateValue(GetAbilityScore(oObject, ABILITY_INTELLIGENCE) - 10, nInaccuracy);

                //concentration
                sMessage    += "\n<c fþ>" + GS_T_16777474 + ": " +
                               gsRateValue((GetSkillRank(SKILL_CONCENTRATION, oObject) - 10) / 2, nInaccuracy);

                //discipline
                sMessage    += "\n<c fþ>" + GS_T_16777475 + ": " +
                               gsRateValue((GetSkillRank(SKILL_DISCIPLINE, oObject) - 10) / 2, nInaccuracy);

                //charisma
                sMessage    += "\n<c fþ>" + GS_T_16777461 + ": " +
                               gsRateValue(GetAbilityScore(oObject, ABILITY_CHARISMA) - 10);

                //persuade
                sMessage    += "\n<c fþ>" + GS_T_16777471 + ": " +
                               gsRateValue((GetSkillRank(SKILL_PERSUADE, oObject) - 10) / 2 + nPerform);

                //intimidate
                sMessage    += "\n<c fþ>" + GS_T_16777472 + ": " +
                               gsRateValue((GetSkillRank(SKILL_INTIMIDATE, oObject) - 10) / 2 + nPerform);

                sMessage    += "\n";
            }
        }

        oObject = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lTarget, TRUE);
    }

    if (sMessage != "")
    {
        sMessage = GetSubString(sMessage, 0, GetStringLength(sMessage) - 1);
        SendMessageToPC(OBJECT_SELF, sMessage);
    }
}
//----------------------------------------------------------------
int gsEmote(object oSpeaker, string sString)
{
    if (! (GetIsDead(oSpeaker) || gsFXGetHasMindAffactingEffect(oSpeaker)))
    {
        if (sString == GS_T_16777404)
        {
            // Addition by Mithreas to store the location someone sits/lies in.
            // This is so the state scripts won't make them stand up. --[
            SetLocalLocation(oSpeaker, "MI_SIT_LOCATION", GetLocation(oSpeaker));
            // ]-- End edit.
            AssignCommand(oSpeaker, PlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.0, 3600.0));
            gsWOGrantFavor(oSpeaker);
            return TRUE;
        }

        if (sString == GS_T_16777405)
        {
            AssignCommand(oSpeaker, PlayAnimation(ANIMATION_FIREFORGET_VICTORY3));
            PlayVoiceChat(VOICE_CHAT_THREATEN, oSpeaker);
            return TRUE;
        }

        if (sString == GS_T_16777406)
        {
            if (gsFLGetAreaFlag("OVERRIDE_TELEPORT", oSpeaker))
            {
                FloatingTextStringOnCreature(GS_T_16777454, oSpeaker, FALSE);
            }
            else
            {
                object oTarget = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC,
                                                    oSpeaker, 1,
                                                    CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_FRIEND,
                                                    CREATURE_TYPE_IS_ALIVE, TRUE);

                if (GetIsObjectValid(oTarget))
                {
                    AssignCommand(oSpeaker, ActionForceFollowObject(oTarget, 5.0));
                }
            }

            return TRUE;
        }

        if (sString == GS_T_16777407)
        {
            AssignCommand(oSpeaker, PlayAnimation(ANIMATION_FIREFORGET_TAUNT));
            PlayVoiceChat(VOICE_CHAT_TAUNT, oSpeaker);
            return TRUE;
        }

        if (sString == GS_T_16777408)
        {
            // Addition by Mithreas to store the location someone sits/lies in.
            // This is so the state scripts won't make them stand up. --[
            SetLocalLocation(oSpeaker, "MI_SIT_LOCATION", GetLocation(oSpeaker));
            // ]-- End edit.
            AssignCommand(oSpeaker, PlayAnimation(ANIMATION_LOOPING_WORSHIP, 1.0, 3600.0));
            return TRUE;
        }

        if (sString == GS_T_16777409)
        {
            AssignCommand(oSpeaker, PlayAnimation(ANIMATION_FIREFORGET_VICTORY2));
            PlayVoiceChat(VOICE_CHAT_CHEER, oSpeaker);
            return TRUE;
        }

        if (sString == GS_T_16777479)
        {
            // Addition by Mithreas to store the location someone sits/lies in.
            // This is so the state scripts won't make them stand up. --[
            SetLocalLocation(oSpeaker, "MI_SIT_LOCATION", GetLocation(oSpeaker));
            // ]-- End edit.
            AssignCommand(oSpeaker, PlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.0, 3600.0));
            return TRUE;
        }

        if (sString == GS_T_16777410)
        {
            AssignCommand(oSpeaker, PlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING, 1.0, 2.0));
            PlayVoiceChat(VOICE_CHAT_LAUGH, oSpeaker);
            return TRUE;
        }

        if (sString == GS_T_16777411)
        {
            // Addition by Mithreas to store the location someone sits/lies in.
            // This is so the state scripts won't make them stand up. --[
            SetLocalLocation(oSpeaker, "MI_SIT_LOCATION", GetLocation(oSpeaker));
            // ]-- End edit.
            AssignCommand(oSpeaker, PlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0, 3600.0));
            return TRUE;
        }

        if (sString == GS_T_16777412)
        {
            AssignCommand(oSpeaker, PlayAnimation(ANIMATION_FIREFORGET_READ));
            return TRUE;
        }

        if (sString == GS_T_16777413)
        {
            // Addition by Mithreas to store the location someone sits/lies in.
            // This is so the state scripts won't make them stand up. --[
            SetLocalLocation(oSpeaker, "MI_SIT_LOCATION", GetLocation(oSpeaker));
            // ]-- End edit.
            AssignCommand(oSpeaker, PlayAnimation(ANIMATION_LOOPING_SIT_CROSS, 1.0, 3600.0));
            return TRUE;
        }

        if (sString == GS_T_16777414)
        {
            AssignCommand(oSpeaker, PlayAnimation(ANIMATION_FIREFORGET_GREETING));
            PlayVoiceChat(VOICE_CHAT_GOODBYE, oSpeaker);
            return TRUE;
        }

        if (sString == GS_T_16777415)
        {
            AssignCommand(oSpeaker, PlayAnimation(ANIMATION_FIREFORGET_BOW));
            return TRUE;
        }

        if (sString == GS_T_16777416)
        {
            AssignCommand(oSpeaker, PlayAnimation(ANIMATION_FIREFORGET_GREETING));
            PlayVoiceChat(VOICE_CHAT_HELLO, oSpeaker);
            return TRUE;
        }

        if (sString == GS_T_16777417)
        {
            AssignCommand(oSpeaker, PlayAnimation(ANIMATION_FIREFORGET_SPASM));
            return TRUE;
        }

        if (sString == GS_T_16777340)
        {
            AssignCommand(oSpeaker, ClearAllActions());
            AssignCommand(oSpeaker, ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_LEFT));
            AssignCommand(oSpeaker, ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_RIGHT));
            AssignCommand(oSpeaker, ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD));
            AssignCommand(oSpeaker, gsLook());
            return TRUE;
        }

        if (sString == "!") //dislike
        {
            location lLocation = GetLocation(oSpeaker);
            object oCreature   = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLocation);

            while (GetIsObjectValid(oCreature))
            {
                SetPCDislike(oSpeaker, oCreature);
                oCreature = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLocation);
            }

            return TRUE;
        }


        if (sString == GS_T_16777532) //detect evil
        {
            //get caster level
            int nCasterLevelPaladin = (GetAlignmentGoodEvil(oSpeaker) == ALIGNMENT_GOOD &&
                                       GetAlignmentLawChaos(oSpeaker) == ALIGNMENT_LAWFUL) ?
                                      GetLevelByClass(CLASS_TYPE_PALADIN, oSpeaker) : 0;
            int nCasterLevelCleric  = GetLevelByClass(CLASS_TYPE_CLERIC, oSpeaker);
            int nCasterLevel        = nCasterLevelPaladin > nCasterLevelCleric ?
                                      nCasterLevelPaladin : nCasterLevelCleric;

            if (nCasterLevel)
            {
                //usage limitation
                int nTimestamp1 = gsTIGetActualTimestamp();
                int nTimestamp2 = GetLocalInt(oSpeaker, "GS_LI_TIMESTAMP_DETECT_EVIL");

                if (nTimestamp1 > nTimestamp2 + FloatToInt(HoursToSeconds(4))) //TIME UPDATE: 4 hours
                {
                    location lLocation = GetLocation(oSpeaker);
                    object oCreature   = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLocation);
                    effect eVisual     = EffectVisualEffect(VFX_DUR_PARALYZED);
                    int nDC            = 11 + GetAbilityModifier(ABILITY_WISDOM, oSpeaker);

                    //add feat bonus to DC
                    if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_DIVINATION, oSpeaker))         nDC += 6;
                    else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_DIVINATION, oSpeaker)) nDC += 4;
                    else if (GetHasFeat(FEAT_SPELL_FOCUS_DIVINATION, oSpeaker))         nDC += 2;

                    //mark evil creatures
                    while (GetIsObjectValid(oCreature))
                    {
                        if (oCreature != oSpeaker &&
                            GetAlignmentGoodEvil(oCreature) == ALIGNMENT_EVIL &&
                            WillSave(oCreature, nDC, SAVING_THROW_TYPE_DIVINE, OBJECT_INVALID) == 0)
                        {
                            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVisual, oCreature, 3.0);
                            SendMessageToPC(oSpeaker, gsCMReplaceString(GS_T_16777534, GetName(oCreature)));
                        }

                        oCreature = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLocation);
                    }

                    SetLocalInt(oSpeaker, "GS_LI_TIMESTAMP_DETECT_EVIL", nTimestamp1);
                }
                else
                {
                    FloatingTextStringOnCreature(GS_T_16777533, oSpeaker, FALSE);
                }
            }

            return TRUE;
        }
    }

    return FALSE;
}
//----------------------------------------------------------------
void main()
{
    //filter speaker
    object oSpeaker      = GetPCChatSpeaker();
    if(!GetIsPC(oSpeaker))
    {
        return;
    }

    //filter ai command
    string sString       = GetPCChatMessage();
    if (GetStringLeft(sString, 6) == "GS_AI_") return;

    //activity
    SetLocalInt(oSpeaker, "GS_ACTIVE", TRUE);

    //language
    string sLanguageName = "";
    int nLanguage1       = GetLocalInt(oSpeaker, "GS_LI_LANGUAGE");
    int nSpeakLanguage   = FALSE;
    int nSwitchLanguage  = FALSE;
    int nChatCommand = FALSE;

    if (GetStringLeft(sString, 1) == "-")
    {
        int nLength    = GetStringLength(sString);
        int nPosition  = FindSubString(sString + " ", " ");
        string sKey    = GetSubString(sString, 1, nPosition - 1);
        sString        = GetStringRight(sString, nLength - nPosition - 1);
        int nLanguage2 = gsLAGetLanguageByKey(sKey);
        int nCommand = gsCTGetChatCommand(sKey);

        if (nLanguage2 != GS_LA_LANGUAGE_INVALID)
        {
            nSpeakLanguage = TRUE;

            if (nLanguage2 != nLanguage1)
            {
                nLanguage1      = nLanguage2;
                nSwitchLanguage = TRUE;
            }
        }
        else if (nCommand != -1)
        {
            nChatCommand = TRUE;
            gsCTProcessCommand(oSpeaker, nCommand, sString);
        }
    }

    //emote
    int nEmote = gsEmote(oSpeaker, sString);

    if ((nSpeakLanguage || nLanguage1) && !nChatCommand)
    {
        string sOutput = "";
        sLanguageName = gsLAGetLanguageName(nLanguage1);

        if (gsLAGetCanSpeakLanguage(nLanguage1, oSpeaker))
        {
            if (nSwitchLanguage)
            {
                SetLocalInt(oSpeaker, "GS_LI_LANGUAGE", nLanguage1);
                SendMessageToPC(oSpeaker, gsCMReplaceString(GS_T_16777531, sLanguageName));
            }

            if (sString != "")
            {
                //emote or speak common
                if (nEmote || nLanguage1 == GS_LA_LANGUAGE_COMMON)
                {
                    sOutput               = sString;
                    sLanguageName         = "";
                }

                //speak other language
                else
                {
                    switch (nLanguage1)
                    {
                    case GS_LA_LANGUAGE_SIGN:
                    case GS_LA_LANGUAGE_THIEF:
                        sString = GetStringLeft(sString, 25);
                    }

                    //distribute input
                    string sLanguageColor = gsLAGetLanguageColor(nLanguage1);
                    sLanguageName         = " <cVs·>[" + sLanguageColor + sLanguageName + "<cVs·>]";
                    string sInput         = "<cþôh>" + GetName(oSpeaker) + sLanguageName + "<cþôh>: " +
                                            "<cþþþ>" + sString;

                    SendMessageToPC(oSpeaker, sInput);

                    object oPC            = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC,
                                                               oSpeaker, 1);
                    int nNth              = 1;

                    while (GetIsObjectValid(oPC) &&
                           GetDistanceBetween(oSpeaker, oPC) <= 20.0)
                    {
                        if (gsLAGetCanSpeakLanguage(nLanguage1, oPC) ||
                            gsCMGetBaseSkillRank(SKILL_LORE, IP_CONST_ABILITY_INT, oPC) + d20() > 40)
                        {
                            SendMessageToPC(oPC, sInput);
                        }

                        oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC,
                                                 oSpeaker, ++nNth);
                    }

                    //translate
                    sOutput               = gsLATranslate(sString, nLanguage1);
                }

                //speak
                //AssignCommand(oSpeaker, SpeakString(sOutput));
                SetPCChatMessage(sOutput);
            }
        }
        else
        {
            SendMessageToPC(oSpeaker, gsCMReplaceString(GS_T_16777342, sLanguageName));
            sLanguageName = "";
        }
    }

    //dm message distribution
    object oPC      = GetFirstPC();
    string sMessage = "<cVs·>[" + GetName(GetArea(oSpeaker)) + "<cVs·>] " +
                      "<cþôh>" + GetName(oSpeaker) + sLanguageName + "<cþôh>: " +
                      "<cþþþ>" + sString;

    while (GetIsObjectValid(oPC))
    {
        if (GetIsDM(oPC) || GetIsDMPossessed(oPC)) SendMessageToPC(oPC, sMessage);
        oPC = GetNextPC();
    }

    //DMFI 
    int nVolume = GetPCChatVolume();
    object oShouter = GetPCChatSpeaker();

    int bInvoke;
    string sChatHandlerScript;
    int maskChannels;
    // int bListenAll;
    object oRunner;
    int bAutoRemove;
    int bDirtyList = FALSE;
    int iHook;
    object oMod = GetModule();
// SendMessageToPC(GetFirstPC(), "OnPlayerChat - process hooks");
    int nHooks = GetLocalArrayUpperBound(oMod, DMFI_CHATHOOK_HANDLE_ARRAYNAME);
    for (iHook = nHooks; iHook > 0; iHook--) // reverse-order execution, last hook gets first dibs
    {
// SendMessageToPC(GetFirstPC(), "OnPlayerChat -- process hook #" + IntToString(iHook));
        maskChannels = GetLocalArrayInt(oMod, DMFI_CHATHOOK_CHANNELS_ARRAYNAME, iHook);
// SendMessageToPC(GetFirstPC(), "OnPlayerChat -- channel heard=" + IntToString(nVolume) + ", soughtmask=" + IntToString(maskChannels));
        if (((1 << nVolume) & maskChannels) != 0) // right channel
        {
// SendMessageToPC(GetFirstPC(), "OnPlayerChat --- channel matched");

            bInvoke = FALSE;
            if (GetLocalArrayInt(oMod, DMFI_CHATHOOK_LISTENALL_ARRAYNAME, iHook) != FALSE)
            {
                bInvoke = TRUE;
            }
            else
            {
                object oDesiredSpeaker = GetLocalArrayObject(oMod, DMFI_CHATHOOK_SPEAKER_ARRAYNAME, iHook);
                if (oShouter == oDesiredSpeaker) bInvoke = TRUE;
            }
            if (bInvoke) // right speaker
            {
// SendMessageToPC(GetFirstPC(), "OnPlayerChat --- speaker matched");
                sChatHandlerScript = GetLocalArrayString(oMod, DMFI_CHATHOOK_SCRIPT_ARRAYNAME, iHook);
                oRunner = GetLocalArrayObject(oMod, DMFI_CHATHOOK_RUNNER_ARRAYNAME, iHook);
// SendMessageToPC(GetFirstPC(), "OnPlayerChat --- executing script '" + sChatHandlerScript + "' on object '" + GetName(oRunner) +"'");
                ExecuteScript(sChatHandlerScript, oRunner);
                bAutoRemove = GetLocalArrayInt(oMod, DMFI_CHATHOOK_AUTOREMOVE_ARRAYNAME, iHook);
                if (bAutoRemove)
                {
// SendMessageToPC(GetFirstPC(), "OnPlayerChat --- scheduling autoremove");
                    bDirtyList = TRUE;
                    SetLocalArrayInt(oMod, DMFI_CHATHOOK_HANDLE_ARRAYNAME, iHook, 0);
                }
            }
        }
    }

    if (bDirtyList) DMFI_ChatHookRemove(0);
    // always execute the DMFI parser
    ExecuteScript(DMFI_PLAYERCHAT_SCRIPTNAME, OBJECT_SELF);

    //DMFI END

    if(nChatCommand){
        SetPCChatMessage("");
    }

    //store message
    gsLISetLastMessage(sString, oSpeaker);
}
