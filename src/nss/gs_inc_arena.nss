/* ARENA Library by Gigaschatten */

//void main() {}

#include "gs_inc_common"
#include "gs_inc_xp"

//return TRUE if oParticipant is assigned at oArena
int gsAEGetIsParticipant(object oArena, object oParticipant);
//assign oParticipant at oArena
void gsAEAssignParticipant(object oArena, object oParticipant);
//retire oParticipant from oArena
void gsAERetireParticipant(object oArena, object oParticipant);
//remove participant at nPlacement from oArena
void gsAERemoveParticipant(object oArena, int nPlacement);
//set stParticipant at oArena for nPlacement
void gsAESetParticipant(object oArena, int nPlacement, struct gsAEParticipant stParticipant);
//set mPresence of nPlacement at oArena
void gsAESetParticipantPresence(object oArena, int nPlacement, int nPresent = TRUE);
//return presence state of nPlacement at oArena
int gsAEGetParticipantPresence(object oArena, int nPlacement);
//return participant data of nPlacement at oArena, GS_AE_PARTICIPANT_INVALID on fail
struct gsAEParticipant gsAEGetParticipant(object oArena, int nPlacement);
//recompute placement stack of oArena
void gsAERefreshParticipantList(object oArena);
//return placement of actual contest at oArena
int gsAEGetContest(object oArena);
//end actual contest at oArena with nStatus and switch to next contest
void gsAESetContest(object oArena, int nStatus);
//skip all contests at oArena with absent participants
void gsAESkipContest(object oArena);
//initialize contest round at oArena
void gsAEBeginRound(object oArena);
//set contest state at oArena to nValue
void gsAESetContestState(object oArena, int nValue);
//return contest state at oArena
int gsAEGetContestState(object oArena);

struct gsAEParticipant
{
    string sName;
    object oCreature;
    int nSuccess;
    int nDefeat;
};

struct gsAEParticipant GS_AE_PARTICIPANT_INVALID;

const int GS_AE_CONTEST_STATUS_NONE              = 0;
const int GS_AE_CONTEST_STATUS_SUCCEEDED         = 1;
const int GS_AE_CONTEST_STATUS_DEFEATED          = 2;
const int GS_AE_CONTEST_STATUS_EQUAL             = 3;
const int GS_AE_CONTEST_STATUS_DEFENDER_ABSENT   = 4;
const int GS_AE_CONTEST_STATUS_CHALLENGER_ABSENT = 5;
const int GS_AE_CONTEST_STATUS_CANCELED          = 6;

const int GS_AE_CONTEST_STATE_IDLE               = 0;
const int GS_AE_CONTEST_STATE_ACTIVATING         = 1;
const int GS_AE_CONTEST_STATE_ACTIVE             = 2;
const int GS_AE_CONTEST_STATE_DEACTIVATING       = 3;

int gsAEGetIsParticipant(object oArena, object oParticipant)
{
    int nPlacement = 0;

    while (GetLocalString(oArena, "GS_AE_PARTICIPANT_NAME_" + IntToString(++nPlacement)) != "")
    {
        if (GetLocalObject(oArena, "GS_AE_PARTICIPANT_CREATURE_" + IntToString(nPlacement)) == oParticipant) return TRUE;
    }

    return FALSE;
}
//----------------------------------------------------------------
void gsAEAssignParticipant(object oArena, object oParticipant)
{
    if (gsAEGetIsParticipant(oArena, oParticipant)) return;

    struct gsAEParticipant stParticipant;
    int nPlacement          = 0;

    stParticipant.sName     = GetName(oParticipant);
    stParticipant.oCreature = oParticipant;
    stParticipant.nSuccess  = 0;
    stParticipant.nDefeat   = 0;

    while (GetLocalString(oArena, "GS_AE_PARTICIPANT_NAME_" + IntToString(++nPlacement)) != "") {};

    gsAESetParticipant(oArena, nPlacement, stParticipant);
}
//----------------------------------------------------------------
void gsAERetireParticipant(object oArena, object oParticipant)
{
    string sTag    = "";
    int nPlacement = 0;

    while (GetLocalString(oArena, "GS_AE_PARTICIPANT_NAME_" + IntToString(++nPlacement)) != "")
    {
        sTag = "GS_AE_PARTICIPANT_CREATURE_" + IntToString(nPlacement);

        if (GetLocalObject(oArena, sTag) == oParticipant)
        {
            DeleteLocalObject(oArena, sTag);
            return;
        }
    }
}
//----------------------------------------------------------------
void gsAERemoveParticipant(object oArena, int nPlacement)
{
    DeleteLocalObject(oArena, "GS_AE_PARTICIPANT_CREATURE_" + IntToString(nPlacement));
}
//----------------------------------------------------------------
void gsAESetParticipant(object oArena, int nPlacement, struct gsAEParticipant stParticipant)
{
    string sPlacement = IntToString(nPlacement);

    if (stParticipant.nSuccess > 2147483646) stParticipant.nSuccess = 2147483646;
    if (stParticipant.nDefeat  > 2147483646) stParticipant.nDefeat  = 2147483646;

    SetLocalString(oArena, "GS_AE_PARTICIPANT_NAME_" + sPlacement, stParticipant.sName);
    SetLocalObject(oArena, "GS_AE_PARTICIPANT_CREATURE_" + sPlacement, stParticipant.oCreature);
    SetLocalInt(oArena, "GS_AE_PARTICIPANT_SUCCESS_" + sPlacement, stParticipant.nSuccess);
    SetLocalInt(oArena, "GS_AE_PARTICIPANT_DEFEAT_" + sPlacement, stParticipant.nDefeat);
}
//----------------------------------------------------------------
void gsAESetParticipantPresence(object oArena, int nPlacement, int nPresent = TRUE)
{
    object oParticipant = GetLocalObject(oArena, "GS_AE_PARTICIPANT_CREATURE_" + IntToString(nPlacement));

    if (! GetIsObjectValid(oParticipant)) return;
    SetLocalInt(oParticipant, GetTag(oArena) + "_PARTICIPANT_STATE", nPresent);
}
//----------------------------------------------------------------
int gsAEGetParticipantPresence(object oArena, int nPlacement)
{
    object oParticipant = GetLocalObject(oArena, "GS_AE_PARTICIPANT_CREATURE_" + IntToString(nPlacement));

    if (! GetIsObjectValid(oParticipant)) return FALSE;
    return GetLocalInt(oParticipant, GetTag(oArena) + "_PARTICIPANT_STATE");
}
//----------------------------------------------------------------
struct gsAEParticipant gsAEGetParticipant(object oArena, int nPlacement)
{
    struct gsAEParticipant stParticipant;
    string sPlacement       = IntToString(nPlacement);

    stParticipant.sName     = GetLocalString(oArena, "GS_AE_PARTICIPANT_NAME_" + sPlacement);
    stParticipant.oCreature = GetLocalObject(oArena, "GS_AE_PARTICIPANT_CREATURE_" + sPlacement);
    stParticipant.nSuccess  = GetLocalInt(oArena, "GS_AE_PARTICIPANT_SUCCESS_" + sPlacement);
    stParticipant.nDefeat   = GetLocalInt(oArena, "GS_AE_PARTICIPANT_DEFEAT_" + sPlacement);

    return stParticipant;
}
//----------------------------------------------------------------
void gsAERefreshParticipantList(object oArena)
{
    struct gsAEParticipant stParticipant;
    int nNth1 = 1;
    int nNth2 = 2;

    do
    {
        stParticipant = gsAEGetParticipant(oArena, nNth1);

        if (! GetIsObjectValid(stParticipant.oCreature))
        {
            if (nNth2 <= nNth1) nNth2 = nNth1 + 1;

            do
            {
                stParticipant = gsAEGetParticipant(oArena, nNth2);
                gsAERemoveParticipant(oArena, nNth2++);
            }
            while (! GetIsObjectValid(stParticipant.oCreature) && stParticipant.sName != "");

            gsAESetParticipant(oArena, nNth1, stParticipant);
        }

        nNth1++;
    }
    while (stParticipant.sName != "");
}
//----------------------------------------------------------------
int gsAEGetContest(object oArena)
{
    return GetLocalInt(oArena, "GS_AE_CONTEST_PLACEMENT");
}
//----------------------------------------------------------------
void gsAESetContest(object oArena, int nStatus)
{
    int nPlacement                      = gsAEGetContest(oArena);
    if (nPlacement <= 0) return;
    struct gsAEParticipant stDefender   = gsAEGetParticipant(oArena, nPlacement);
    struct gsAEParticipant stChallenger = gsAEGetParticipant(oArena, nPlacement + 1);

    switch (nStatus)
    {
    case GS_AE_CONTEST_STATUS_SUCCEEDED:
        stDefender.nDefeat++;
        stChallenger.nSuccess++;
        gsAESetParticipant(oArena, nPlacement, stChallenger);

        if (nPlacement < 10)
        {
            gsAESetParticipant(oArena, nPlacement + 1, stDefender);
        }
        else
        {
            gsAERemoveParticipant(oArena, nPlacement + 1);
        }

        if (GetIsPC(stChallenger.oCreature))
        {
            int nRatingDefender   = stDefender.nSuccess   - stDefender.nDefeat;
            if (nRatingDefender   < 0) nRatingDefender   = 0;
            int nRatingChallenger = stChallenger.nSuccess - stChallenger.nDefeat;
            if (nRatingChallenger < 0) nRatingChallenger = 0;
            int nReward           = nRatingDefender       - nRatingChallenger;

            if (nReward > 0)
            {
                nReward *= 10;
                if (nReward > 100) nReward = 100;
                gsCMCreateGold(nReward, stChallenger.oCreature);
                gsXPGiveExperience(stChallenger.oCreature, 10);
            }
            else
            {
                gsCMCreateGold(5, stChallenger.oCreature);
            }
        }
        break;

    case GS_AE_CONTEST_STATUS_DEFEATED:
        stDefender.nSuccess++;
        stChallenger.nDefeat++;
        gsAESetParticipant(oArena, nPlacement, stDefender);

        if (nPlacement < 10)
        {
            gsAESetParticipant(oArena, nPlacement + 1, stChallenger);
        }
        else
        {
            gsAERemoveParticipant(oArena, nPlacement + 1);
        }

        if (GetIsPC(stDefender.oCreature))
        {
            int nRatingDefender   = stDefender.nSuccess   - stDefender.nDefeat;
            if (nRatingDefender   < 0) nRatingDefender   = 0;
            int nRatingChallenger = stChallenger.nSuccess - stChallenger.nDefeat;
            if (nRatingChallenger < 0) nRatingChallenger = 0;
            int nReward           = nRatingChallenger     - nRatingDefender;

            if (nReward > 0)
            {
                nReward *= 10;
                if (nReward > 100) nReward = 100;
                gsCMCreateGold(nReward, stDefender.oCreature);
                gsXPGiveExperience(stDefender.oCreature, 10);
            }
            else
            {
                gsCMCreateGold(5, stDefender.oCreature);
            }
        }
        break;

    case GS_AE_CONTEST_STATUS_EQUAL:
        break;

    case GS_AE_CONTEST_STATUS_DEFENDER_ABSENT:
        gsAESetParticipant(oArena, nPlacement, stChallenger);

        if (nPlacement < 10)
        {
            gsAESetParticipant(oArena, nPlacement + 1, stDefender);
        }
        else
        {
            gsAERemoveParticipant(oArena, nPlacement + 1);
        }
        break;

    case GS_AE_CONTEST_STATUS_CHALLENGER_ABSENT:
        if (nPlacement >= 10) gsAERemoveParticipant(oArena, nPlacement + 1);
        break;

    case GS_AE_CONTEST_STATUS_CANCELED:
        break;
    }

    gsAESetParticipantPresence(oArena, nPlacement, FALSE);
    gsAESetParticipantPresence(oArena, nPlacement + 1, FALSE);
    SetLocalInt(oArena, "GS_AE_CONTEST_PLACEMENT", nPlacement - 1);
}
//----------------------------------------------------------------
void gsAESkipContest(object oArena)
{
    struct gsAEParticipant stDefender;
    struct gsAEParticipant stChallenger;
    int nPlacement = gsAEGetContest(oArena);

    while (nPlacement > 0)
    {
        stDefender   = gsAEGetParticipant(oArena, nPlacement);
        stChallenger = gsAEGetParticipant(oArena, nPlacement + 1);

        //defender absent
        if (! GetIsObjectValid(stDefender.oCreature))
        {
            //challenger present => challenger wins
            if (GetIsObjectValid(stChallenger.oCreature))
            {
                gsAESetContest(oArena, GS_AE_CONTEST_STATUS_DEFENDER_ABSENT);
            }

            //challenger absent => equal
            else
            {
                gsAESetContest(oArena, GS_AE_CONTEST_STATUS_CANCELED);
            }
        }

        //challenger absent => defender wins
        else if (! GetIsObjectValid(stChallenger.oCreature))
        {
            gsAESetContest(oArena, GS_AE_CONTEST_STATUS_CHALLENGER_ABSENT);
        }

        //defender and challenger present
        else
        {
            break;
        }

        nPlacement   = gsAEGetContest(oArena);
    }
}
//----------------------------------------------------------------
void gsAEBeginRound(object oArena)
{
    struct gsAEParticipant stParticipant;
    int nPlacement = 1;

    gsAERefreshParticipantList(oArena);

    for (; nPlacement <= 11; nPlacement++)
    {
        stParticipant = gsAEGetParticipant(oArena, nPlacement);
        if (stParticipant == GS_AE_PARTICIPANT_INVALID) break;
    }

    SetLocalInt(oArena, "GS_AE_CONTEST_PLACEMENT", nPlacement - 2);
}
//----------------------------------------------------------------
void gsAESetContestState(object oArena, int nValue)
{
    SetLocalInt(oArena, "GS_AE_CONTEST_STATE", nValue);
}
//----------------------------------------------------------------
int gsAEGetContestState(object oArena)
{
    return GetLocalInt(oArena, "GS_AE_CONTEST_STATE");
}
