/* JUSTICE Library by Gigaschatten */

//void main() {}

#include "gs_inc_pc"
#include "gs_inc_time"

const string GS_JU_TRIAL_WITNESS          = "GS_JU_TW_";

const string GS_JU_TRIAL_PLAINTIFF_ID     = "GS_JU_T0_";
const string GS_JU_TRIAL_PLAINTIFF_NAME   = "GS_JU_T1_";
const string GS_JU_TRIAL_DEFENDANT_ID     = "GS_JU_T2_";
const string GS_JU_TRIAL_DEFENDANT_NAME   = "GS_JU_T3_";
const string GS_JU_TRIAL_ACCUSATION       = "GS_JU_T4_";
const string GS_JU_TRIAL_PENALTY          = "GS_JU_T5_";
const string GS_JU_TRIAL_TIMESTAMP        = "GS_JU_T6_";
const string GS_JU_TRIAL_JUDGEMENT        = "GS_JU_T7_";
const string GS_JU_TRIAL_JUDGEMENT_COUNT  = "GS_JU_T8_";
const string GS_JU_TRIAL_FLAG             = "GS_JU_T9_";

const int GS_JU_TRIAL_DURATION            =     900; //15 minutes

const string GS_JU_JUDGEMENT_CONVICT_ID   = "GS_JU_J0_";
const string GS_JU_JUDGEMENT_CONVICT_NAME = "GS_JU_J1_";
const string GS_JU_JUDGEMENT_TIMESTAMP    = "GS_JU_J2_";
const string GS_JU_JUDGEMENT_FLAG         = "GS_JU_J3_";

const int GS_JU_TRIAL_PENALTY_CAPITAL     = 1209600; //2 weeks
const int GS_JU_TRIAL_PENALTY_SERIOUS     =  604800; //1 week
const int GS_JU_TRIAL_PENALTY_TRIVIAL     =   86400; //1 day

int gsJUTrialNth                          =       0;
int gsJUJudgementNth                      =       0;

//return TRUE if oPC is plaintiff at oJustice
int gsJUGetIsPlaintiff(object oJustice, object oPC);
//return TRUE if oPC is defendant at oJustice
int gsJUGetIsDefendant(object oJustice, object oPC);
//add stTrial to oJustice and return index
int gsJUOpenTrial(object oJustice, struct gsJUTrial stTrial);
//set data of nTrial to stTrial at oJustice
void gsJUSetTrial(object oJustice, int nTrial, struct gsJUTrial stTrial);
//return data of nTrial from oJustice
struct gsJUTrial gsJUGetTrial(object oJustice, int nTrial);
//return index of first trial at oJustice
int gsJUGetFirstTrial(object oJustice);
//return index of next trial at oJustice
int gsJUGetNextTrial(object oJustice);
//return judgement of nTrial at oJustice and delete it
int gsJUCloseTrial(object oJustice, int nTrial);
//return TRUE if nJudgement of oPC is successfully applied to nTrial at oJustice
int gsJUTrialJudgement(object oJustice, object oPC, int nTrial, int nJudgement);
//return index of judgement passed on oPC at oJustice
int gsJUGetIsConvict(object oJustice, object oPC);
//add stJudgement to oJustice
void gsJUAddJudgement(object oJustice, struct gsJUJudgement stJudgement);
//return data of nJudgement from oJustice
struct gsJUJudgement gsJUGetJudgement(object oJustice, int nJudgement);
//return index of first judgement at oJustice
int gsJUGetFirstJudgement(object oJustice);
//return index of next judgement at oJustice
int gsJUGetNextJudgement(object oJustice);
//return index of previous judgement to offset nJudgement at oJustice
int gsJUGetPreviousJudgement(object oJustice, int nJudgement);
//delete nJudgement from oJustice
void gsJUEndJudgement(object oJustice, int nJudgement);
//save judgements of oJustice in database
void gsJUSaveJudgement(object oJustice);
//load judgements of oJustice from database
void gsJULoadJudgement(object oJustice);

struct gsJUTrial
{
    string sPlaintiffID;
    string sPlaintiffName;
    string sDefendantID;
    string sDefendantName;
    string sAccusation;
    int nPenalty;
    int nTimestamp;
    int nJudgement;
    int nJudgementCount;
    int nFlag;
};

struct gsJUJudgement
{
    string sConvictID;
    string sConvictName;
    int nTimestamp;
    int nFlag;
};

int gsJUGetIsPlaintiff(object oJustice, object oPC)
{
    string sPlayerID = gsPCGetPlayerID(oPC);
    string sTrial    = "1";
    int nTrial       = 1;

    while (GetLocalInt(oJustice, GS_JU_TRIAL_FLAG + sTrial))
    {
        if (GetLocalString(oJustice, GS_JU_TRIAL_PLAINTIFF_ID + sTrial) == sPlayerID) return TRUE;
        sTrial = IntToString(++nTrial);
    }

    return FALSE;
}
//----------------------------------------------------------------
int gsJUGetIsDefendant(object oJustice, object oPC)
{
    string sPlayerID = gsPCGetPlayerID(oPC);
    string sTrial    = "1";
    int nTrial       = 1;

    while (GetLocalInt(oJustice, GS_JU_TRIAL_FLAG + sTrial))
    {
        if (GetLocalString(oJustice, GS_JU_TRIAL_DEFENDANT_ID + sTrial) == sPlayerID) return TRUE;
        sTrial = IntToString(++nTrial);
    }

    return FALSE;
}
//----------------------------------------------------------------
int gsJUOpenTrial(object oJustice, struct gsJUTrial stTrial)
{
    int nTrial              =  0;

    while (GetLocalInt(oJustice, GS_JU_TRIAL_PENALTY + IntToString(++nTrial))) {};

    stTrial.nJudgement      = 50;
    stTrial.nJudgementCount =  1;
    gsJUSetTrial(oJustice, nTrial, stTrial);

    return nTrial;
}
//----------------------------------------------------------------
void gsJUSetTrial(object oJustice, int nTrial, struct gsJUTrial stTrial)
{
    string sTrial = IntToString(nTrial);

    SetLocalString(oJustice, GS_JU_TRIAL_PLAINTIFF_ID + sTrial, stTrial.sPlaintiffID);
    SetLocalString(oJustice, GS_JU_TRIAL_PLAINTIFF_NAME + sTrial, stTrial.sPlaintiffName);
    SetLocalString(oJustice, GS_JU_TRIAL_DEFENDANT_ID + sTrial, stTrial.sDefendantID);
    SetLocalString(oJustice, GS_JU_TRIAL_DEFENDANT_NAME + sTrial, stTrial.sDefendantName);
    SetLocalString(oJustice, GS_JU_TRIAL_ACCUSATION + sTrial, stTrial.sAccusation);
    SetLocalInt(oJustice, GS_JU_TRIAL_PENALTY + sTrial, stTrial.nPenalty);
    SetLocalInt(oJustice, GS_JU_TRIAL_TIMESTAMP + sTrial, stTrial.nTimestamp);
    SetLocalInt(oJustice, GS_JU_TRIAL_JUDGEMENT + sTrial, stTrial.nJudgement);
    SetLocalInt(oJustice, GS_JU_TRIAL_JUDGEMENT_COUNT + sTrial, stTrial.nJudgementCount);
    SetLocalInt(oJustice, GS_JU_TRIAL_FLAG + sTrial, TRUE);
}
//----------------------------------------------------------------
struct gsJUTrial gsJUGetTrial(object oJustice, int nTrial)
{
    struct gsJUTrial stTrial;
    string sTrial           = IntToString(nTrial);

    stTrial.sPlaintiffID    = GetLocalString(oJustice, GS_JU_TRIAL_PLAINTIFF_ID + sTrial);
    stTrial.sPlaintiffName  = GetLocalString(oJustice, GS_JU_TRIAL_PLAINTIFF_NAME + sTrial);
    stTrial.sDefendantID    = GetLocalString(oJustice, GS_JU_TRIAL_DEFENDANT_ID + sTrial);
    stTrial.sDefendantName  = GetLocalString(oJustice, GS_JU_TRIAL_DEFENDANT_NAME + sTrial);
    stTrial.sAccusation     = GetLocalString(oJustice, GS_JU_TRIAL_ACCUSATION + sTrial);
    stTrial.nPenalty        = GetLocalInt(oJustice, GS_JU_TRIAL_PENALTY + sTrial);
    stTrial.nTimestamp      = GetLocalInt(oJustice, GS_JU_TRIAL_TIMESTAMP + sTrial);
    stTrial.nJudgement      = GetLocalInt(oJustice, GS_JU_TRIAL_JUDGEMENT + sTrial);
    stTrial.nJudgementCount = GetLocalInt(oJustice, GS_JU_TRIAL_JUDGEMENT_COUNT + sTrial);

    return stTrial;
}
//----------------------------------------------------------------
int gsJUGetFirstTrial(object oJustice)
{
    gsJUTrialNth = 0;

    return gsJUGetNextTrial(oJustice);
}
//----------------------------------------------------------------
int gsJUGetNextTrial(object oJustice)
{
    string sTrial = IntToString(++gsJUTrialNth);

    while (GetLocalInt(oJustice, GS_JU_TRIAL_FLAG + sTrial))
    {
        if (GetLocalInt(oJustice, GS_JU_TRIAL_PENALTY + sTrial)) return gsJUTrialNth;
        sTrial = IntToString(++gsJUTrialNth);
    }

    return FALSE;
}
//----------------------------------------------------------------
int gsJUCloseTrial(object oJustice, int nTrial)
{
    struct gsJUTrial stTrial = gsJUGetTrial(oJustice, nTrial);
    string sTrial            = IntToString(nTrial);

    DeleteLocalString(oJustice, GS_JU_TRIAL_PLAINTIFF_ID + sTrial);
    DeleteLocalString(oJustice, GS_JU_TRIAL_PLAINTIFF_NAME + sTrial);
    DeleteLocalString(oJustice, GS_JU_TRIAL_DEFENDANT_ID + sTrial);
    DeleteLocalString(oJustice, GS_JU_TRIAL_DEFENDANT_NAME + sTrial);
    DeleteLocalString(oJustice, GS_JU_TRIAL_ACCUSATION + sTrial);
    DeleteLocalInt(oJustice, GS_JU_TRIAL_PENALTY + sTrial);
    DeleteLocalInt(oJustice, GS_JU_TRIAL_TIMESTAMP + sTrial);
    DeleteLocalInt(oJustice, GS_JU_TRIAL_JUDGEMENT + sTrial);
    DeleteLocalInt(oJustice, GS_JU_TRIAL_JUDGEMENT_COUNT + sTrial);

    string sTag1             = GS_JU_TRIAL_WITNESS + sTrial + "_";
    string sTag2             = sTag1 + "1";
    int nNth                 = 1;

    while (GetLocalString(oJustice, sTag2) != "")
    {
        DeleteLocalString(oJustice, sTag2);
        sTag2 = sTag1 + IntToString(++nNth);
    }

    if (! GetLocalInt(oJustice, GS_JU_TRIAL_FLAG + IntToString(nTrial + 1)))
    {
        do
        {
            DeleteLocalInt(oJustice, GS_JU_TRIAL_FLAG + sTrial);
            if (--nTrial <= 0) break;
            sTrial = IntToString(nTrial);
        }
        while (! GetLocalInt(oJustice, GS_JU_TRIAL_PENALTY + sTrial));
    }

    return stTrial.nJudgementCount ? stTrial.nJudgement / stTrial.nJudgementCount : 0;
}
//----------------------------------------------------------------
int gsJUTrialJudgement(object oJustice, object oPC, int nTrial, int nJudgement)
{
    struct gsJUTrial stTrial = gsJUGetTrial(oJustice, nTrial);
    if (! stTrial.nTimestamp) return FALSE;
    string sCDKey1           = GetPCPublicCDKey(oPC);

    if (! (gsPCGetIsPlayerEqual(sCDKey1, stTrial.sPlaintiffID) ||
           gsPCGetIsPlayerEqual(sCDKey1, stTrial.sDefendantID)))
    {
        string sTag    = GS_JU_TRIAL_WITNESS + IntToString(nTrial) + "_";
        string sCDKey2 = GetLocalString(oJustice, sTag + "1");
        int nNth       = 1;

        while (sCDKey2 != "")
        {
            if (sCDKey1 == sCDKey2) return FALSE;
            sCDKey2 = GetLocalString(oJustice, sTag + IntToString(++nNth));
        }

        SetLocalString(oJustice, sTag + IntToString(nNth), sCDKey1);

        if (stTrial.nJudgementCount < 2147483647 &&
            stTrial.nJudgement < 2147483647 - nJudgement)
        {
            stTrial.nJudgementCount += 1;
            stTrial.nJudgement      += nJudgement;
        }

        gsJUSetTrial(oJustice, nTrial, stTrial);

        return TRUE;
    }

    return FALSE;
}
//----------------------------------------------------------------
int gsJUGetIsConvict(object oJustice, object oPC)
{
    string sPlayerID  = gsPCGetPlayerID(oPC);
    string sJudgement = "1";
    int nJudgement    = 1;

    while (GetLocalInt(oJustice, GS_JU_JUDGEMENT_FLAG + sJudgement))
    {
        if (GetLocalString(oJustice, GS_JU_JUDGEMENT_CONVICT_ID + sJudgement) == sPlayerID)
        {
            int nTimestamp = gsTIGetActualTimestamp();

            if (GetLocalInt(oJustice, GS_JU_JUDGEMENT_TIMESTAMP + sJudgement) >= nTimestamp) return nJudgement;
            return FALSE;
        }

        sJudgement = IntToString(++nJudgement);
    }

    return FALSE;
}
//----------------------------------------------------------------
void gsJUAddJudgement(object oJustice, struct gsJUJudgement stJudgement)
{
    string sJudgement = "1";
    int nTimestamp    = gsTIGetActualTimestamp();
    int nDuration1    = 0;
    int nDuration2    = 0;
    int nJudgement    = 1;

    while (GetLocalInt(oJustice, GS_JU_JUDGEMENT_FLAG + sJudgement))
    {
        nDuration1 = GetLocalInt(oJustice, GS_JU_JUDGEMENT_TIMESTAMP + sJudgement) - nTimestamp;
        if (nDuration1 < 0) nDuration1 = 0;

        if (GetLocalString(oJustice, GS_JU_JUDGEMENT_CONVICT_ID + sJudgement) == stJudgement.sConvictID)
        {
            nDuration2 = nDuration1;
            break;
        }

        sJudgement = IntToString(++nJudgement);
    }

    if (nDuration2 > 2147483647 - stJudgement.nTimestamp) nDuration2  = 2147483647;
    else                                                  nDuration2 += stJudgement.nTimestamp;

    SetLocalString(oJustice, GS_JU_JUDGEMENT_CONVICT_ID + sJudgement, stJudgement.sConvictID);
    SetLocalString(oJustice, GS_JU_JUDGEMENT_CONVICT_NAME + sJudgement, stJudgement.sConvictName);
    SetLocalInt(oJustice, GS_JU_JUDGEMENT_TIMESTAMP + sJudgement, nDuration2);
    SetLocalInt(oJustice, GS_JU_JUDGEMENT_FLAG + sJudgement, TRUE);
}
//----------------------------------------------------------------
struct gsJUJudgement gsJUGetJudgement(object oJustice, int nJudgement)
{
    struct gsJUJudgement stJudgement;
    string sJudgement        = IntToString(nJudgement);

    stJudgement.sConvictID   = GetLocalString(oJustice, GS_JU_JUDGEMENT_CONVICT_ID + sJudgement);
    stJudgement.sConvictName = GetLocalString(oJustice, GS_JU_JUDGEMENT_CONVICT_NAME + sJudgement);
    stJudgement.nTimestamp   = GetLocalInt(oJustice, GS_JU_JUDGEMENT_TIMESTAMP + sJudgement);

    return stJudgement;
}
//----------------------------------------------------------------
int gsJUGetFirstJudgement(object oJustice)
{
    gsJUJudgementNth = 0;

    return gsJUGetNextJudgement(oJustice);
}
//----------------------------------------------------------------
int gsJUGetNextJudgement(object oJustice)
{
    string sJudgement = IntToString(++gsJUJudgementNth);

    while (GetLocalInt(oJustice, GS_JU_JUDGEMENT_FLAG + sJudgement))
    {
        if (GetLocalInt(oJustice, GS_JU_JUDGEMENT_TIMESTAMP + sJudgement)) return gsJUJudgementNth;
        sJudgement = IntToString(++gsJUJudgementNth);
    }

    return FALSE;
}
//----------------------------------------------------------------
void gsJUEndJudgement(object oJustice, int nJudgement)
{
    string sJudgement = IntToString(nJudgement);

    DeleteLocalString(oJustice, GS_JU_JUDGEMENT_CONVICT_ID + sJudgement);
    DeleteLocalString(oJustice, GS_JU_JUDGEMENT_CONVICT_NAME + sJudgement);
    DeleteLocalInt(oJustice, GS_JU_JUDGEMENT_TIMESTAMP + sJudgement);

    if (! GetLocalInt(oJustice, GS_JU_JUDGEMENT_FLAG + IntToString(nJudgement + 1)))
    {
        do
        {
            DeleteLocalInt(oJustice, GS_JU_JUDGEMENT_FLAG + sJudgement);
            if (--nJudgement <= 0) break;
            sJudgement = IntToString(nJudgement);
        }
        while (! GetLocalInt(oJustice, GS_JU_JUDGEMENT_TIMESTAMP + sJudgement));
    }
}
//----------------------------------------------------------------
void gsJUSaveJudgement(object oJustice)
{
    string sDatabase  = "GS_JU_" + GetTag(oJustice);
    string sJudgement = "1";
    string sNth       = "";
    int nTimestamp    = 0;
    int nJudgement    = 1;
    int nNth          = 1;

    while (GetLocalInt(oJustice, GS_JU_JUDGEMENT_FLAG + sJudgement))
    {
        sJudgement = IntToString(nJudgement);
        nTimestamp = GetLocalInt(oJustice, GS_JU_JUDGEMENT_TIMESTAMP + sJudgement);

        if (nTimestamp)
        {
            sNth = IntToString(nNth++);

            SetCampaignString(
                sDatabase,
                "CONVICT_ID_" + sNth,
                GetLocalString(oJustice, GS_JU_JUDGEMENT_CONVICT_ID + sJudgement));
            SetCampaignString(
                sDatabase,
                "CONVICT_NAME_" + sNth,
                GetLocalString(oJustice, GS_JU_JUDGEMENT_CONVICT_NAME + sJudgement));
            SetCampaignInt(
                sDatabase,
                "TIMESTAMP_" + sNth,
                GetLocalInt(oJustice, GS_JU_JUDGEMENT_TIMESTAMP + sJudgement));
        }

        sJudgement = IntToString(++nJudgement);
    }

    SetCampaignInt(sDatabase, "TIMESTAMP_" + IntToString(nNth), FALSE);
}
//----------------------------------------------------------------
void gsJULoadJudgement(object oJustice)
{
    string sDatabase  = "GS_JU_" + GetTag(oJustice);
    string sNth       = "1";
    int nTimestamp    = GetCampaignInt(sDatabase, "TIMESTAMP_1");
    int nNth          = 1;

    while (nTimestamp > 0)
    {
        SetLocalString(
            oJustice,
            GS_JU_JUDGEMENT_CONVICT_ID + sNth,
            GetCampaignString(sDatabase, "CONVICT_ID_" + sNth));
        SetLocalString(
            oJustice,
            GS_JU_JUDGEMENT_CONVICT_NAME + sNth,
            GetCampaignString(sDatabase, "CONVICT_NAME_" + sNth));
        SetLocalInt(
            oJustice,
            GS_JU_JUDGEMENT_TIMESTAMP + sNth,
            nTimestamp);
        SetLocalInt(
            oJustice,
            GS_JU_JUDGEMENT_FLAG + sNth,
            TRUE);

        sNth       = IntToString(++nNth);
        nTimestamp = GetCampaignInt(sDatabase, "TIMESTAMP_" + sNth);
    }

    DeleteLocalInt(oJustice, GS_JU_JUDGEMENT_FLAG + sNth);
}
