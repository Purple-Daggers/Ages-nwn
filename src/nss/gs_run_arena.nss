#include "gs_inc_arena"
#include "gs_inc_combat"
#include "gs_inc_common"
#include "gs_inc_effect"
#include "gs_inc_flag"
#include "gs_inc_text"
#include "gs_inc_time"

const int GS_ANIMATION_NONE        = 0;
const int GS_ANIMATION_VICTORY     = 1;
const int GS_ANIMATION_DEFEAT      = 2;

const string GS_TAG_DEFENDER_IN    = "_DEFENDER_IN";
const string GS_TAG_CHALLENGER_IN  = "_CHALLENGER_IN";
const string GS_TAG_DEFENDER_OUT   = "_DEFENDER_OUT";
const string GS_TAG_CHALLENGER_OUT = "_CHALLENGER_OUT";

void gsAnnounce(string sText)
{
    string sTag       = GetTag(OBJECT_SELF) + "_ANNOUNCER";
    int nNth          = 0;
    object oAnnouncer = GetObjectByTag(sTag, nNth++);

    while (GetIsObjectValid(oAnnouncer))
    {
        AssignCommand(oAnnouncer, SpeakString(sText));
        oAnnouncer = GetObjectByTag(sTag, nNth++);
    }
}
//----------------------------------------------------------------
void gsInform(object oTarget, string sText)
{
    if (GetIsObjectValid(oTarget))
    {
        FloatingTextStringOnCreature(
            GetName(OBJECT_SELF) + ": " + sText,
            oTarget,
            FALSE);
    }
}
//----------------------------------------------------------------
void gsGong()
{
    PlaySound("as_cv_gongring2");
}
//----------------------------------------------------------------
void gsRestore(object oCreature)
{
    if (GetIsDead(oCreature)) ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oCreature);
    gsFXRestore(oCreature);
    ForceRest(oCreature);
}
//----------------------------------------------------------------
void gsPrepare(object oCreature, string sTag)
{
    //restore
    gsRestore(oCreature);

    //destroy allies
    object oMember = GetFirstFactionMember(oCreature);
    object oMaster = OBJECT_INVALID;

    while (GetIsObjectValid(oMember))
    {
        oMaster = GetMaster(oMember);

        while (GetIsObjectValid(oMaster))
        {
            if (GetIsPC(oMaster))
            {
                DestroyObject(oMember);
                break;
            }

            oMaster = GetMaster(oMaster);
        }

        oMember = GetNextFactionMember(oCreature);
    }

    //move to initial position
    object oTarget = GetWaypointByTag(sTag);

    AssignCommand(oCreature, ClearAllActions(TRUE));
    AssignCommand(oCreature, JumpToObject(oTarget));
    AssignCommand(oCreature, SetCommandable(FALSE));

    //npc
    if (! GetIsPC(oCreature))
    {
        //ai
        gsFLSetFlag(GS_FL_DISABLE_AI, oCreature);
        gsFLSetFlag(GS_FL_DISABLE_CALL, oCreature);
        gsFLSetFlag(GS_FL_DISABLE_COMBAT, oCreature);
    }
}
//----------------------------------------------------------------
void gsStart(object oCreature)
{
    //enable action queue change
    SetCommandable(TRUE, oCreature);

    //clear action mode
    SetActionMode(oCreature, ACTION_MODE_COUNTERSPELL,          FALSE);
    SetActionMode(oCreature, ACTION_MODE_DEFENSIVE_CAST,        FALSE);
    SetActionMode(oCreature, ACTION_MODE_DETECT,                FALSE);
    SetActionMode(oCreature, ACTION_MODE_DIRTY_FIGHTING,        FALSE);
    SetActionMode(oCreature, ACTION_MODE_EXPERTISE,             FALSE);
    SetActionMode(oCreature, ACTION_MODE_FLURRY_OF_BLOWS,       FALSE);
    SetActionMode(oCreature, ACTION_MODE_IMPROVED_EXPERTISE,    FALSE);
    SetActionMode(oCreature, ACTION_MODE_IMPROVED_POWER_ATTACK, FALSE);
    SetActionMode(oCreature, ACTION_MODE_PARRY,                 FALSE);
    SetActionMode(oCreature, ACTION_MODE_POWER_ATTACK,          FALSE);
    SetActionMode(oCreature, ACTION_MODE_RAPID_SHOT,            FALSE);
    SetActionMode(oCreature, ACTION_MODE_STEALTH,               FALSE);

    //npc
    if (! GetIsPC(oCreature))
    {
        //ai
        SetAILevel(oCreature, AI_LEVEL_NORMAL);
        gsFLSetFlag(GS_FL_DISABLE_COMBAT, oCreature, FALSE);
    }
}
//----------------------------------------------------------------
void gsExit(object oCreature, location lTarget)
{
    SetPlotFlag(oCreature, FALSE);

    //enable action queue change
    SetCommandable(TRUE, oCreature);

    //move to exit position
    AssignCommand(oCreature, ClearAllActions(TRUE));
    AssignCommand(oCreature, JumpToLocation(lTarget));

    //npc
    if (! GetIsPC(oCreature))
    {
        //ai
        gsFLSetFlag(GS_FL_DISABLE_AI, oCreature, FALSE);
        gsFLSetFlag(GS_FL_DISABLE_CALL, oCreature, FALSE);
        gsFLSetFlag(GS_FL_DISABLE_COMBAT, oCreature, FALSE);
    }
}
//----------------------------------------------------------------
void gsEnd(object oCreature, string sTag, int nAnimation = GS_ANIMATION_NONE)
{
    //restore
    gsRestore(oCreature);

    //clear action queue
    AssignCommand(oCreature, ClearAllActions(TRUE));

    //animation
    switch (nAnimation)
    {
    case GS_ANIMATION_NONE:
        break;

    case GS_ANIMATION_VICTORY:
        AssignCommand(oCreature, PlayAnimation(ANIMATION_FIREFORGET_VICTORY2, 0.5));
        AssignCommand(oCreature, PlayVoiceChat(VOICE_CHAT_LAUGH));
        break;

    case GS_ANIMATION_DEFEAT:
        AssignCommand(oCreature, PlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0, 60.0));
        break;
    }

    //disable action queue change
    AssignCommand(oCreature, SetCommandable(FALSE));

    //get exit location
    location lTarget;

    if (GetIsPC(oCreature))
    {
        object oTarget = GetWaypointByTag(sTag);
        lTarget        = GetLocation(oTarget);
    }

    //npc
    else
    {
        lTarget        = GetLocalLocation(oCreature, "GS_LOCATION");

        //ai
        gsFLSetFlag(GS_FL_DISABLE_AI, oCreature);
        gsFLSetFlag(GS_FL_DISABLE_CALL, oCreature);
        gsFLSetFlag(GS_FL_DISABLE_COMBAT, oCreature);
    }

    //schedule exit
    DelayCommand(15.0, gsExit(oCreature, lTarget));
}
//----------------------------------------------------------------
void main()
{
    int nPlacement = gsAEGetContest(OBJECT_SELF);

    //beginn new round
    if (nPlacement <= 0)
    {
        gsAEBeginRound(OBJECT_SELF);

        //skip all contests with missing participants
        gsAESkipContest(OBJECT_SELF);

        nPlacement = gsAEGetContest(OBJECT_SELF);
        if (nPlacement <= 0) return;

        //contest state
        gsAESetContestState(OBJECT_SELF, GS_AE_CONTEST_STATE_DEACTIVATING);
    }

    //actual round
    struct gsAEParticipant stDefender   = gsAEGetParticipant(OBJECT_SELF, nPlacement);
    struct gsAEParticipant stChallenger = gsAEGetParticipant(OBJECT_SELF, nPlacement + 1);
    object oArea                        = GetArea(OBJECT_SELF);
    string sTag                         = GetTag(OBJECT_SELF);
    string sTagDefenderIn               = sTag + GS_TAG_DEFENDER_IN;
    string sTagChallengerIn             = sTag + GS_TAG_CHALLENGER_IN;
    string sTagDefenderOut              = sTag + GS_TAG_DEFENDER_OUT;
    string sTagChallengerOut            = sTag + GS_TAG_CHALLENGER_OUT;
    int nStatus                         = GS_AE_CONTEST_STATUS_NONE;
    int nTimestamp1                     = gsTIGetActualTimestamp();
    int nTimestamp2                     = GetLocalInt(OBJECT_SELF, "GS_AE_TIMESTAMP");
    int nContestState                   = gsAEGetContestState(OBJECT_SELF);

    //determine contest status
    if (nContestState == GS_AE_CONTEST_STATE_ACTIVATING ||
        nContestState == GS_AE_CONTEST_STATE_ACTIVE)
    {
        //defender absent
        if (! GetIsObjectValid(stDefender.oCreature) ||
            ! gsAEGetParticipantPresence(OBJECT_SELF, nPlacement))
        {
            //challenger present => challenger wins
            if (GetIsObjectValid(stChallenger.oCreature) &&
                gsAEGetParticipantPresence(OBJECT_SELF, nPlacement + 1))
            {
                nStatus = GS_AE_CONTEST_STATUS_DEFENDER_ABSENT;
            }

            //challenger absent => tie
            else
            {
                nStatus = GS_AE_CONTEST_STATUS_CANCELED;
            }
        }

        //challenger absent => defender wins
        else if (! GetIsObjectValid(stChallenger.oCreature) ||
                 ! gsAEGetParticipantPresence(OBJECT_SELF, nPlacement + 1))
        {
            nStatus = GS_AE_CONTEST_STATUS_CHALLENGER_ABSENT;
        }

        //defender dead
        else if (GetIsDead(stDefender.oCreature))
        {
            //challenger alive => challenger wins
            if (! GetIsDead(stChallenger.oCreature))
            {
                nStatus = GS_AE_CONTEST_STATUS_SUCCEEDED;
            }

            //challenger dead => tie
            else
            {
                nStatus = GS_AE_CONTEST_STATUS_EQUAL;
            }
        }

        //challenger dead => defender wins
        else if (GetIsDead(stChallenger.oCreature))
        {
            nStatus = GS_AE_CONTEST_STATUS_DEFEATED;
        }
    }

    if (nStatus) nContestState = GS_AE_CONTEST_STATE_ACTIVE;

    switch (nContestState)
    {
    case GS_AE_CONTEST_STATE_IDLE:
//................................................................
        if (nTimestamp1 >= nTimestamp2 &&
            (nTimestamp1 >= GetLocalInt(OBJECT_SELF, "GS_AE_CONTEST_TIMESTAMP") ||
             ((! GetIsPC(stDefender.oCreature)   || gsAEGetParticipantPresence(OBJECT_SELF, nPlacement)) &&
              (! GetIsPC(stChallenger.oCreature) || gsAEGetParticipantPresence(OBJECT_SELF, nPlacement + 1)))))
        {
            //defender
            if (! GetIsPC(stDefender.oCreature))
            {
                gsPrepare(stDefender.oCreature, sTagDefenderIn);
                gsAESetParticipantPresence(OBJECT_SELF, nPlacement);
                SetPlotFlag(stDefender.oCreature, TRUE);
            }
            else if (gsAEGetParticipantPresence(OBJECT_SELF, nPlacement))
            {
                gsPrepare(stDefender.oCreature, sTagDefenderIn);
                SetPlotFlag(stDefender.oCreature, TRUE);
            }

            //challenger
            if (! GetIsPC(stChallenger.oCreature))
            {
                gsPrepare(stChallenger.oCreature, sTagChallengerIn);
                gsAESetParticipantPresence(OBJECT_SELF, nPlacement + 1);
                SetPlotFlag(stChallenger.oCreature, TRUE);
            }
            else if (gsAEGetParticipantPresence(OBJECT_SELF, nPlacement + 1))
            {
                gsPrepare(stChallenger.oCreature, sTagChallengerIn);
                SetPlotFlag(stChallenger.oCreature, TRUE);
            }

            gsAnnounce(gsCMReplaceString(GS_T_16777493,
                                         IntToString(nPlacement),
                                         stDefender.sName,
                                         IntToString(stDefender.nSuccess),
                                         IntToString(stDefender.nDefeat)) +
                       gsCMReplaceString(GS_T_16777494,
                                         stChallenger.sName,
                                         IntToString(stChallenger.nSuccess),
                                         IntToString(stChallenger.nDefeat)));

            //schedule
            nTimestamp2 = nTimestamp1 + gsTIGetGameTimestamp(10);
            SetLocalInt(OBJECT_SELF, "GS_AE_TIMESTAMP", nTimestamp2);

            //contest state
            nContestState = GS_AE_CONTEST_STATE_ACTIVATING;
            gsAESetContestState(OBJECT_SELF, nContestState);
        }
        break;

    case GS_AE_CONTEST_STATE_ACTIVATING:
//................................................................
        if (nTimestamp1 >= nTimestamp2)
        {
            MusicBattlePlay(oArea);
            gsGong();
            gsAnnounce(GS_T_16777492);

            SetPlotFlag(stDefender.oCreature, FALSE);
            SetPlotFlag(stChallenger.oCreature, FALSE);

            //reputation
            object oFaction = gsCMGetObject("GS_FACTION_ARENA_DEFENDER", OBJECT_TYPE_CREATURE);
            ChangeFaction(stDefender.oCreature, oFaction);
            oFaction        = gsCMGetObject("GS_FACTION_ARENA_CHALLENGER", OBJECT_TYPE_CREATURE);
            ChangeFaction(stChallenger.oCreature, oFaction);
            SetIsTemporaryEnemy(stChallenger.oCreature, stDefender.oCreature);
            SetIsTemporaryEnemy(stDefender.oCreature, stChallenger.oCreature);

            RemoveFromParty(stDefender.oCreature);
            RemoveFromParty(stChallenger.oCreature);
            SetPCDislike(stDefender.oCreature, stChallenger.oCreature);

            gsStart(stDefender.oCreature);
            gsStart(stChallenger.oCreature);

            //combat
            if (! GetIsPC(stDefender.oCreature))
                AssignCommand(stDefender.oCreature, gsCBDetermineCombatRound(stChallenger.oCreature));
            if (! GetIsPC(stChallenger.oCreature))
                AssignCommand(stChallenger.oCreature, gsCBDetermineCombatRound(stDefender.oCreature));

            //schedule
            nTimestamp2     = nTimestamp1 + gsTIGetGameTimestamp(gsTIGetTimestamp(0, 0, 0, 0, 4));
            SetLocalInt(OBJECT_SELF, "GS_AE_TIMESTAMP", nTimestamp2);

            gsAESetContestState(OBJECT_SELF, GS_AE_CONTEST_STATE_ACTIVE);
        }
        break;

    case GS_AE_CONTEST_STATE_ACTIVE:
//................................................................
        if (nStatus || nTimestamp1 >= nTimestamp2)
        {
            MusicBattleStop(oArea);
            gsGong();

            //clean up
            gsFXRemoveAllAOLs(oArea);

            //determine contest status
            if (! nStatus)
            {
                int nHPDefender   = 100 * GetCurrentHitPoints(stDefender.oCreature) /
                                    GetMaxHitPoints(stDefender.oCreature);
                int nHPChallenger = 100 * GetCurrentHitPoints(stChallenger.oCreature) /
                                    GetMaxHitPoints(stChallenger.oCreature);

                //tie
                if (nHPDefender == nHPChallenger)
                {
                    nStatus = GS_AE_CONTEST_STATUS_EQUAL;
                }

                //defender wins
                else if (nHPDefender > nHPChallenger)
                {
                    nStatus = GS_AE_CONTEST_STATUS_DEFEATED;
                }

                //challenger wins
                else
                {
                    nStatus = GS_AE_CONTEST_STATUS_SUCCEEDED;
                }
            }

            //end contest
            switch (nStatus)
            {
            case GS_AE_CONTEST_STATUS_SUCCEEDED:
                gsAnnounce(gsCMReplaceString(GS_T_16777489,
                                             stChallenger.sName,
                                             stDefender.sName,
                                             IntToString(nPlacement)));
                gsEnd(stDefender.oCreature, sTagDefenderOut, GS_ANIMATION_DEFEAT);
                gsEnd(stChallenger.oCreature, sTagChallengerOut, GS_ANIMATION_VICTORY);
                break;

            case GS_AE_CONTEST_STATUS_DEFEATED:
                gsAnnounce(gsCMReplaceString(GS_T_16777491,
                                             stDefender.sName,
                                             stChallenger.sName,
                                             IntToString(nPlacement)));
                gsEnd(stDefender.oCreature, sTagDefenderOut, GS_ANIMATION_VICTORY);
                gsEnd(stChallenger.oCreature, sTagChallengerOut, GS_ANIMATION_DEFEAT);
                break;

            case GS_AE_CONTEST_STATUS_EQUAL:
                gsAnnounce(gsCMReplaceString(GS_T_16777490,
                                             IntToString(nPlacement),
                                             stDefender.sName,
                                             stChallenger.sName));
                gsEnd(stDefender.oCreature, sTagDefenderOut);
                gsEnd(stChallenger.oCreature, sTagChallengerOut);
                break;

            case GS_AE_CONTEST_STATUS_DEFENDER_ABSENT:
                gsAnnounce(gsCMReplaceString(GS_T_16777486,
                                             stChallenger.sName,
                                             stDefender.sName,
                                             IntToString(nPlacement)));
                gsEnd(stChallenger.oCreature, sTagChallengerOut);
                break;

            case GS_AE_CONTEST_STATUS_CHALLENGER_ABSENT:
                gsAnnounce(gsCMReplaceString(GS_T_16777488,
                                             stDefender.sName,
                                             stChallenger.sName,
                                             IntToString(nPlacement)));
                gsEnd(stDefender.oCreature, sTagDefenderOut);
                break;

            case GS_AE_CONTEST_STATUS_CANCELED:
                gsAnnounce(gsCMReplaceString(GS_T_16777487,
                                             IntToString(nPlacement),
                                             stDefender.sName,
                                             stChallenger.sName));
                gsAESetContest(OBJECT_SELF, GS_AE_CONTEST_STATUS_CANCELED);
                break;
            }

            gsAESetContest(OBJECT_SELF, nStatus);

            //skip all contests with missing participants
            gsAESkipContest(OBJECT_SELF);

            //reputation
            object oFaction = gsCMGetObject("GS_FACTION_NEUTRAL", OBJECT_TYPE_CREATURE);
            ClearPersonalReputation(stChallenger.oCreature, stDefender.oCreature);
            ClearPersonalReputation(stDefender.oCreature, stChallenger.oCreature);
            ChangeFaction(stDefender.oCreature, oFaction);
            ChangeFaction(stChallenger.oCreature, oFaction);

            switch (nStatus)
            {
            case GS_AE_CONTEST_STATUS_SUCCEEDED:
            case GS_AE_CONTEST_STATUS_DEFEATED:
            case GS_AE_CONTEST_STATUS_EQUAL:
                SetPCLike(stDefender.oCreature, stChallenger.oCreature);
                SetPlotFlag(stDefender.oCreature, TRUE);
                SetPlotFlag(stChallenger.oCreature, TRUE);
                break;

            case GS_AE_CONTEST_STATUS_DEFENDER_ABSENT:
                SetPlotFlag(stChallenger.oCreature, TRUE);
                break;

            case GS_AE_CONTEST_STATUS_CHALLENGER_ABSENT:
                SetPlotFlag(stDefender.oCreature, TRUE);
                break;
            }

            //schedule
            nTimestamp2     = nTimestamp1 + gsTIGetGameTimestamp(10);
            SetLocalInt(OBJECT_SELF, "GS_AE_TIMESTAMP", nTimestamp2);

            //contest state
            nContestState   = GS_AE_CONTEST_STATE_DEACTIVATING;
            gsAESetContestState(OBJECT_SELF, nContestState);
        }
        break;

    case GS_AE_CONTEST_STATE_DEACTIVATING:
//................................................................
        if (nTimestamp1 >= nTimestamp2)
        {
            //contest schedule
            nTimestamp2    = nTimestamp1 + gsTIGetGameTimestamp(gsTIGetTimestamp(0, 0, 0, 0, 2));
            nTimestamp2    = gsTIGetFullHour(nTimestamp2);
            SetLocalInt(OBJECT_SELF, "GS_AE_CONTEST_TIMESTAMP", nTimestamp2);

            string sHour   = IntToString(gsTIGetHour(nTimestamp2));
            string sString = gsCMReplaceString(GS_T_16777498, sHour);

            gsInform(stDefender.oCreature, sString);
            gsInform(stChallenger.oCreature, sString);
            gsAnnounce(gsCMReplaceString(GS_T_16777485,
                                         IntToString(nPlacement),
                                         sHour,
                                         stDefender.sName,
                                         stChallenger.sName));

            //schedule
            nTimestamp2    = nTimestamp1 + gsTIGetGameTimestamp(20);
            SetLocalInt(OBJECT_SELF, "GS_AE_TIMESTAMP", nTimestamp2);

            //contest state
            nContestState  = GS_AE_CONTEST_STATE_IDLE;
            gsAESetContestState(OBJECT_SELF, nContestState);
        }
    }
}
