/* EXPERIENCE Library by Gigaschatten */

#include "gs_inc_boss"
#include "gs_inc_common"
#include "gs_inc_pc"
#include "gs_inc_subrace"
#include "gs_inc_text"
#include "gs_inc_time"

//void main() {}

const int GS_XP_ALIGNMENT_SHIFT          = FALSE;
const int GS_XP_KILL_MODIFIER            =    25; //base xp value
const int GS_XP_KILL_PER_LEVEL           = FALSE; //daily kill reward, set to FALSE to disable
const int GS_XP_PENALTY_PER_LEVEL_HIGH   =   200; //level 20+, set to FALSE to take a full level
const int GS_XP_PENALTY_PER_LEVEL_MEDIUM =   100; //level 10+, set to FALSE to take a full level
const int GS_XP_PENALTY_PER_LEVEL_LOW    =    50; //level  1+, set to FALSE to take a full level
const int GS_XP_BONUS_HIGH               =  2000;
const int GS_XP_BONUS_MEDIUM             =  1000;
const int GS_XP_BONUS_LOW                =   500;
const int GS_XP_BONUS_MINI               =    50;
const int GS_XP_PUNISHMENT_HIGH          = -2000;
const int GS_XP_PUNISHMENT_MEDIUM        = -1000;
const int GS_XP_PUNISHMENT_LOW           =  -500;

//distribute experience for slaying oVictim to each enemy within fRange
void gsXPRewardKill(object oVictim = OBJECT_SELF, float fRange = 40.0);
//return death penalty of oPC, set nPenalty to override internal settings, if nLevelSafe is TRUE oPC will not lose levels
int gsXPGetDeathPenalty(object oPC, int nPenalty = FALSE, int nLevelSafe = FALSE);
//apply death penalty to oPC, set nPenalty to override internal settings, if nLevelSafe is TRUE oPC will not lose levels
void gsXPApplyDeathPenalty(object oPC, int nPenalty = FALSE, int nLevelSafe = FALSE);
//give nAmount experience to each member of oCreature's faction nearby
void gsXPDistributeExperience(object oCreature, int nAmount);
//give nAmount experience to oCreature, display floating message if nFloat is TRUE
void gsXPGiveExperience(object oCreature, int nAmount, int nFloat = TRUE, int nKill = FALSE);
//apply nBonus/punishment to oCreature or each member of party oCreature is in if nParty is TRUE
void gsXPApply(object oCreature, int nBonus, int nParty = FALSE);
//set kill limit of oPC to nValue
void gsXPSetKillLimit(object oPC, int nValue);
//return kill limit of oPC
int gsXPGetKillLimit(object oPC);
//set kill timeout of oPC to nValue
void gsXPSetKillTimeout(object oPC, int nValue);
//return kill timeout of oPC
int gsXPGetKillTimeout(object oPC);
//return percentual multi class penalty of oPC having nSubRace
int gsXPGetMultiClassPenalty(object oPC, int nSubRace = FALSE);
// Added by Mith - determine whether this class is a PrC or not
int gsXPGetIsPrestigeClass(int nClass);

void gsXPRewardKill(object oVictim = OBJECT_SELF, float fRange = 40.0)
{
    object oCreature         = OBJECT_INVALID;
    location lLocation       = GetLocation(oVictim);
    string sVictimName       = GetName(oVictim);
    float fRatingVictim      = 0.0;
    float fRating            = 0.0;
    float fRatingPC          = 0.0;
    float fRatingNPC         = 0.0;
    float fExperience        = 0.0;
    int nVictimIsPC          = GetIsPC(oVictim);
    int nSubRace             = GS_SU_NONE;
    int nCountPC             = 0;
    int nExperience          = 0;
    int nApplyAlignmentShift = nVictimIsPC && GS_XP_ALIGNMENT_SHIFT > 0;
    int nAlignmentVictimGE   = GetAlignmentGoodEvil(oVictim);
    int nAlignmentVictimLC   = GetAlignmentLawChaos(oVictim);
    int nAlignmentKillerGE   = 0;
    int nAlignmentKillerLC   = 0;
    int nAlignmentShiftGE    = 0;
    int nAlignmentShiftLC    = 0;

    //compute victim rating
    if (nVictimIsPC)
    {
        fRatingVictim = IntToFloat(GetHitDice(oVictim));
    }
    else if (! GetLevelByClass(CLASS_TYPE_COMMONER, oVictim))
    {
        fRatingVictim = GetChallengeRating(oVictim);
    }

    //compute rating
    oCreature   = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lLocation, TRUE);

    while (GetIsObjectValid(oCreature))
    {
        if (! GetIsDMPossessed(oCreature) &&
            GetIsReactionTypeHostile(oVictim, oCreature))
        {
            if (GetIsPC(oCreature))
            {
                fRating     = IntToFloat(GetHitDice(oCreature));
                nCountPC   += 1;

                if (fRating > fRatingPC) fRatingPC = fRating;
            }
            else
            {
                fRating     = GetChallengeRating(oCreature) / 2.0;
                fRating    *= fRating;
                fRatingNPC += fRating;
            }
        }

        oCreature = GetNextObjectInShape(SHAPE_SPHERE, fRange, lLocation, TRUE);
    }

    if (fRatingPC == 0.0)   return;

    fRating     = (fRatingVictim - sqrt(fRatingPC * fRatingPC + fRatingNPC)) / 15.0 + 1.0;
    if (fRating < 0.0)      fRating = 0.0;
    else if (fRating > 2.0) fRating = 2.0;
    fExperience = IntToFloat(GS_XP_KILL_MODIFIER) * fRating;

    //party size modification
    switch (nCountPC)
    {
    case 1:  fExperience *= 0.95; break;
    case 2:                       break;
    case 3:  fExperience *= 1.05; break;
    case 4:  fExperience *= 1.1;  break;
    case 5:  fExperience *= 1.05; break;
    case 6:                       break;
    case 7:  fExperience *= 0.75; break;
    case 8:  fExperience *= 0.5;  break;
    case 9:  fExperience *= 0.25; break;
    default: fExperience  = 0.0;  break;
    }

    nExperience = FloatToInt(fExperience);
    if (nExperience <= 0)                    nExperience  = 1;
    else if (gsBOGetIsBossCreature(oVictim)) nExperience *= 4;

    //distribute experience
    oCreature   = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lLocation, TRUE);

    while (GetIsObjectValid(oCreature))
    {
        if (GetIsPC(oCreature) &&
            GetIsReactionTypeHostile(oVictim, oCreature))
        {
            //adjust alignment
            if (nApplyAlignmentShift)
            {
                nAlignmentKillerGE = GetAlignmentGoodEvil(oCreature);
                nAlignmentKillerLC = GetAlignmentLawChaos(oCreature);
                nAlignmentShiftGE  = 0;
                nAlignmentShiftLC  = 0;

                switch (nAlignmentVictimGE)
                {
                case ALIGNMENT_GOOD:
                    nAlignmentShiftGE--;
                    break;

                case ALIGNMENT_EVIL:
                    if (nAlignmentKillerGE != ALIGNMENT_EVIL)
                        nAlignmentShiftGE++;
                    break;
                }

                switch (nAlignmentVictimLC)
                {
                case ALIGNMENT_LAWFUL:
                    nAlignmentShiftLC--;
                    break;

                case ALIGNMENT_CHAOTIC:
                    if (nAlignmentKillerGE != ALIGNMENT_CHAOTIC)
                        nAlignmentShiftLC++;
                    break;
                }

                if (nAlignmentShiftGE > 0)
                    AdjustAlignment(oCreature, ALIGNMENT_GOOD, GS_XP_ALIGNMENT_SHIFT);
                else if (nAlignmentShiftGE < 0)
                    AdjustAlignment(oCreature, ALIGNMENT_EVIL, GS_XP_ALIGNMENT_SHIFT);

                if (nAlignmentShiftLC > 0)
                    AdjustAlignment(oCreature, ALIGNMENT_LAWFUL, GS_XP_ALIGNMENT_SHIFT);
                else if (nAlignmentShiftLC < 0)
                    AdjustAlignment(oCreature, ALIGNMENT_CHAOTIC, GS_XP_ALIGNMENT_SHIFT);
            }

            gsXPGiveExperience(oCreature, nExperience, TRUE, TRUE);
        }

        oCreature = GetNextObjectInShape(SHAPE_SPHERE, fRange, lLocation, TRUE);
    }
}
//----------------------------------------------------------------
int gsXPGetDeathPenalty(object oPC, int nPenalty = FALSE, int nLevelSafe = FALSE)
{
    int nHitDice = GetHitDice(oPC);
    int nXP      = GetXP(oPC);
    int nLimit   = nXP - 3000; //level 3

    //determine penalty
    if (! nPenalty)
    {
        if (nHitDice > 20)      nPenalty = GS_XP_PENALTY_PER_LEVEL_HIGH;
        else if (nHitDice > 10) nPenalty = GS_XP_PENALTY_PER_LEVEL_MEDIUM;
        else                    nPenalty = GS_XP_PENALTY_PER_LEVEL_LOW;
        nPenalty *= nHitDice;
    }

    if (! nPenalty)
    {
        nPenalty  = nXP - (nHitDice - 1) * (nHitDice - 2) / 2 * 1000 - nHitDice * 100;
    }

    //start safety
    if (nPenalty > nLimit) nPenalty = nLimit;

    //level safety
    if (nLevelSafe)
    {
        nLimit = nXP - nHitDice * (nHitDice - 1) / 2 * 1000;
        if (nPenalty > nLimit) nPenalty = nLimit;
    }

    return nPenalty < 0 ? 0 : nPenalty;
}
//----------------------------------------------------------------
void gsXPApplyDeathPenalty(object oPC, int nPenalty = FALSE, int nLevelSafe = FALSE)
{
    nPenalty = gsXPGetDeathPenalty(oPC, nPenalty, nLevelSafe);
    if (nPenalty > 0) gsXPGiveExperience(oPC, -nPenalty);
}
//----------------------------------------------------------------
void gsXPDistributeExperience(object oCreature, int nAmount)
{
    object oArea   = GetArea(oCreature);
    object oMember = GetFirstFactionMember(oCreature);

    while (GetIsObjectValid(oMember))
    {
        if (oArea == GetArea(oMember) &&
            GetDistanceBetween(oCreature, oMember) <= 40.0)
        {
            gsXPGiveExperience(oMember, nAmount);
        }

        oMember = GetNextFactionMember(oCreature);
    }
}
//----------------------------------------------------------------
void gsXPGiveExperience(object oCreature, int nAmount, int nFloat = TRUE, int nKill = FALSE)
{
    if (nAmount == 0) return;

    string sMessage  = "";
    int nXP          = GetXP(oCreature);

    if (nAmount > 0)
    {
        int nLevel   = GetHitDice(oCreature);
        int nXPLevel = (nLevel + 1) * nLevel / 2 * 1000;
        int nSubRace = gsSUGetSubRaceByName(GetSubRace(oCreature));

        if (nKill)
        {
            if (GS_XP_KILL_PER_LEVEL > 0 && nLevel > 4)
            {
                int nTimestamp = gsTIGetActualTimestamp();
                int nTimeout   = gsXPGetKillTimeout(oCreature);
                int nLimit     = 0;

                if (nTimeout < nTimestamp)
                {
                    nTimeout = nTimestamp + gsTIGetGameTimestamp(86400); //TIME UPDATE: gsTIGetGameTimestamp basically turns seconds into gametime seconds. gsTIGetGameTimestamp(86400) = 24 hours REAL LIFE time.
                    gsXPSetKillTimeout(oCreature, nTimeout);
                }
                else
                {
                    nLimit   = gsXPGetKillLimit(oCreature);

                    if (nLimit > nLevel * GS_XP_KILL_PER_LEVEL)
                    {
                        SendMessageToPC(oCreature, GS_T_16777314);
                        return;
                    }
                }

                gsXPSetKillLimit(oCreature, nLimit + nAmount);
            }

            //apply effective character level
            nAmount = nAmount * nLevel / gsSUGetECL(nSubRace, nLevel);

            //apply multiclass penalty
            nAmount = nAmount * gsXPGetMultiClassPenalty(oCreature, nSubRace) / 100;

            if (nAmount <= 0) nAmount = 1;
        }

        if (nXP >= nXPLevel)
        {
            SendMessageToPC(oCreature, GS_T_16777341);
            return;
        }

        sMessage     = "<cªÕþ>+";
    }
    else
    {
        sMessage     = "<cþ((>";
    }

    SetXP(oCreature, nXP + nAmount);
    gsPCMemorizeClassData(oCreature);

    sMessage        += IntToString(nAmount) + " " + GS_T_16777315;
    if (nFloat)       FloatingTextStringOnCreature(sMessage, oCreature, FALSE);
    else              SendMessageToPC(oCreature, sMessage);
}
//----------------------------------------------------------------
void gsXPApply(object oCreature, int nBonus, int nParty = FALSE)
{
    if (! nBonus) return;

    string sColor   = "";
    string sType    = "";
    string sSubType = "";
    int nDM         = GetIsDM(OBJECT_SELF);

    if (nBonus < 0)
    {
        sColor = "<cþ((>";
        sType  = GS_T_16777316;

        if (nBonus < GS_XP_PUNISHMENT_MEDIUM)   sSubType = GS_T_16777321;
        else if (nBonus < GS_XP_PUNISHMENT_LOW) sSubType = GS_T_16777320;
        else                                    sSubType = GS_T_16777319;
    }
    else
    {
        sColor = "<cªÕþ>";
        sType  = GS_T_16777317;

        if (nBonus <= GS_XP_BONUS_MINI)         sSubType = GS_T_16777318;
        else if (nBonus <= GS_XP_BONUS_LOW)     sSubType = GS_T_16777319;
        else if (nBonus <= GS_XP_BONUS_MEDIUM)  sSubType = GS_T_16777320;
        else                                    sSubType = GS_T_16777321;
    }

    if (nParty)
    {
        object oMember = GetFirstFactionMember(oCreature);

        while (GetIsObjectValid(oMember))
        {
            SendMessageToPC(
                oMember,
                sColor + gsCMReplaceString(GS_T_16777322, sSubType + " " + sType));
            if (nDM)
                SendMessageToAllDMs(
                    gsCMReplaceString(
                        GS_T_16777323,
                        GetName(oMember),
                        sSubType + " " + sType,
                        GetName(OBJECT_SELF)));

            gsXPGiveExperience(oMember, nBonus);

            oMember = GetNextFactionMember(oCreature);
        }
    }
    else
    {
        SendMessageToPC(
            oCreature,
            sColor + gsCMReplaceString(GS_T_16777322, sSubType + " " + sType));
        if (nDM)
            SendMessageToAllDMs(
                gsCMReplaceString(
                    GS_T_16777323,
                    GetName(oCreature),
                    sSubType + " " + sType,
                    GetName(OBJECT_SELF)));

        gsXPGiveExperience(oCreature, nBonus);
    }
}
//----------------------------------------------------------------
void gsXPSetKillLimit(object oPC, int nValue)
{
    SetLocalInt(oPC, "GS_XP_KILL_LIMIT", nValue <= 0 ? -1 : nValue);
    SetCampaignInt("GS_XP_KILL_LIMIT", gsPCGetPlayerID(oPC), nValue);
}
//----------------------------------------------------------------
int gsXPGetKillLimit(object oPC)
{
    int nValue = GetLocalInt(oPC, "GS_XP_KILL_LIMIT");

    if (! nValue)
    {
        nValue = GetCampaignInt("GS_XP_KILL_LIMIT", gsPCGetPlayerID(oPC));
        SetLocalInt(oPC, "GS_XP_KILL_LIMIT", nValue <= 0 ? -1 : nValue);
        return nValue;
    }

    return nValue < 0 ? 0 : nValue;
}
//----------------------------------------------------------------
void gsXPSetKillTimeout(object oPC, int nValue)
{
    SetLocalInt(oPC, "GS_XP_KILL_TIMEOUT", nValue <= 0 ? -1 : nValue);
    SetCampaignInt("GS_XP_KILL_TIMEOUT", gsPCGetPlayerID(oPC), nValue);
}
//----------------------------------------------------------------
int gsXPGetKillTimeout(object oPC)
{
    int nValue = GetLocalInt(oPC, "GS_XP_KILL_TIMEOUT");

    if (! nValue)
    {
        nValue = GetCampaignInt("GS_XP_KILL_TIMEOUT", gsPCGetPlayerID(oPC));
        SetLocalInt(oPC, "GS_XP_KILL_TIMEOUT", nValue <= 0 ? -1 : nValue);
        return nValue;
    }

    return nValue < 0 ? 0 : nValue;
}
//----------------------------------------------------------------
int gsXPGetMultiClassPenalty(object oPC, int nSubRace = FALSE)
{
    int nClass2       = GetClassByPosition(2, oPC);
    if (nClass2 == CLASS_TYPE_INVALID) return 100; //no multi class character
    int nLevel2       = GetLevelByClass(nClass2, oPC);
    int nClass1       = GetClassByPosition(1, oPC);
    int nLevel1       = GetLevelByClass(nClass1, oPC);
    int nClass3       = GetClassByPosition(3, oPC);
    int nLevel3       = nClass3 == CLASS_TYPE_INVALID ? 0 : GetLevelByClass(nClass3, oPC);
    int nFavoredClass = CLASS_TYPE_INVALID;
    int nNth          = 0;

    //order classes by level
    if (nLevel3)
    {
        if (nLevel3 > nLevel1)
        {
            nNth    = nClass1;
            nClass1 = nClass3;
            nClass3 = nNth;
            nNth    = nLevel1;
            nLevel1 = nLevel3;
            nLevel3 = nNth;
        }

        if (nLevel3 > nLevel2)
        {
            nNth    = nClass2;
            nClass2 = nClass3;
            nClass3 = nNth;
            nNth    = nLevel2;
            nLevel2 = nLevel3;
            nLevel3 = nNth;
        }
    }

    if (nLevel2 > nLevel1)
    {
        nNth    = nClass1;
        nClass1 = nClass2;
        nClass2 = nNth;
        nNth    = nLevel1;
        nLevel1 = nLevel2;
        nLevel2 = nNth;
    }

    /* favored class
    if (nSubRace)
    {
        nFavoredClass = gsSUGetFavoredClass(nSubRace, GetGender(oPC));
    }
    else
    {
        switch (GetRacialType(oPC))
        {
        case RACIAL_TYPE_DWARF:
            nFavoredClass = CLASS_TYPE_FIGHTER;
            break;

        case RACIAL_TYPE_ELF:
            nFavoredClass = CLASS_TYPE_WIZARD;
            break;

        case RACIAL_TYPE_GNOME:
            nFavoredClass = CLASS_TYPE_WIZARD;
            break;

        case RACIAL_TYPE_HALFELF:
            nFavoredClass = nClass1;
            break;

        case RACIAL_TYPE_HALFLING:
            nFavoredClass = CLASS_TYPE_ROGUE;
            break;

        case RACIAL_TYPE_HALFORC:
            nFavoredClass = CLASS_TYPE_BARBARIAN;
            break;

        case RACIAL_TYPE_HUMAN:
            nFavoredClass = nClass1;
            break;
        }
    }
    */

    nFavoredClass = nClass1;

    // Edits by Mithreas to correct a number of XP-related bugs. Compare
    // levels in classes, not class constants (i.e. nLevel* not nClass*).
    // --[
    if ((nClass3 == nFavoredClass) || !gsXPGetIsPrestigeClass(nClass3))
    {
        if ((nClass1 == nFavoredClass) || gsXPGetIsPrestigeClass(nClass1))
        {
            if (gsXPGetIsPrestigeClass(nClass2)) return 100;
            if (nLevel2 - nLevel3 > 1) return 80;
            return 100;
        }

        if ((nClass2 == nFavoredClass) || gsXPGetIsPrestigeClass(nClass2))
        {
            if (nLevel1 - nLevel3 > 1) return 80;
            return 100;
        }

        if (nLevel1 - nLevel2 > 1)
        {
            if (nLevel2 - nLevel3 > 1) return 60;
            // if (nLevel1 - nLevel3 > 1) return 60; - this is not needed (1>2).
            return 80;
        }

        if (nLevel2 - nLevel3 > 1) // Added by Mith.
        {
          // 1 and 2 are within 1 level of each other and 1>2. So only 3 is out
          // of step.
          return 80;
        }
    }

    if (nClass1 == nFavoredClass) return 100;
    if (nClass2 == nFavoredClass) return 100;
    if (gsXPGetIsPrestigeClass(nClass1)) return 100;
    if (gsXPGetIsPrestigeClass(nClass2)) return 100;
    if (nLevel1 - nLevel2 > 1)    return  80;
    // ]-- End edits.
    return 100;
}
//----------------------------------------------------------------
// Added by Mith --[
int gsXPGetIsPrestigeClass(int nClass)
{
  switch (nClass)
  {
    case CLASS_TYPE_ARCANE_ARCHER:
    case CLASS_TYPE_ASSASSIN:
    case CLASS_TYPE_BLACKGUARD:
    case CLASS_TYPE_DIVINE_CHAMPION:
    case CLASS_TYPE_DRAGON_DISCIPLE:
    case CLASS_TYPE_DWARVEN_DEFENDER:
    case CLASS_TYPE_EYE_OF_GRUUMSH:
    case CLASS_TYPE_PALE_MASTER:
    case CLASS_TYPE_SHADOWDANCER:
    case CLASS_TYPE_SHIFTER:
    case CLASS_TYPE_SHOU_DISCIPLE:
    case CLASS_TYPE_WEAPON_MASTER:
      return TRUE;
    default:
  }

  return FALSE;
}
// ]-- End addition.
