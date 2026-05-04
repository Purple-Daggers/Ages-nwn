#include "gs_inc_common"
#include "gs_inc_pc"
#include "gs_inc_respawn"
#include "gs_inc_time"
#include "gs_inc_xp"

void main()
{
    object oUsedBy     = GetLastUsedBy();
    if (! GetIsPC(oUsedBy))              return;
    if (GetIsPossessedFamiliar(oUsedBy)) return;

    //timeout
    int nTimeout       = gsTIGetGameTimestamp(GetLocalInt(GetModule(), "GS_DEATH_TIMEOUT")) -
                         gsTIGetActualTimestamp() +
                         GetCampaignInt("GS_DEATH_TIMESTAMP", gsPCGetPlayerID(oUsedBy));

    if (nTimeout > 0)
    {
        nTimeout = gsTIGetRealTimestamp(nTimeout);

        FloatingTextStringOnCreature(
            gsCMReplaceString(
                GS_T_16777455,
                IntToString(gsTIGetHour(nTimeout)),
                IntToString(gsTIGetMinute(nTimeout)),
                IntToString(gsTIGetSecond(nTimeout))),
            oUsedBy,
            FALSE);
        return;
    }

    location lLocation = gsREGetRespawnLocation(oUsedBy);

    //penalty
    gsXPApplyDeathPenalty(oUsedBy);

    //teleport
    switch (GetAlignmentGoodEvil(oUsedBy))
    {
    case ALIGNMENT_GOOD:
    case ALIGNMENT_NEUTRAL:
        gsCMTeleportToLocation(oUsedBy, lLocation, VFX_IMP_HEALING_X);
        break;

    case ALIGNMENT_EVIL:
        gsCMTeleportToLocation(oUsedBy, lLocation, VFX_IMP_HARM);
        break;
    }

    //destroy corpse
    object oCorpse = GetLocalObject(oUsedBy, "GS_CORPSE");

    if (GetIsObjectValid(oCorpse)) DestroyObject(oCorpse);
    DeleteLocalObject(oUsedBy, "GS_CORPSE");
}
