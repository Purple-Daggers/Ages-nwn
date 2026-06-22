#include "gs_inc_common"
#include "gs_inc_encounter"
#include "gs_inc_text"

const int GS_SLOT = 9;

int StartingConditional()
{
    object oArea = GetArea(OBJECT_SELF);
    int nNth     = GetLocalInt(OBJECT_SELF, "GS_EN_OFFSET") + GS_SLOT;

    if (nNth <= GetLocalInt(OBJECT_SELF, "GS_EN_COUNT"))
    {
        nNth = GetLocalInt(OBJECT_SELF, "GS_EN_SLOT_" + IntToString(nNth));

        SetCustomToken(
            99 + GS_SLOT,
            gsCMReplaceString(
                GS_T_16777442,
                gsENGetCreatureName(GS_SLOT, oArea),
                FloatToString(gsENGetCreatureRating(GS_SLOT, oArea), 0, 1),
                IntToString(gsENGetCreatureChance(GS_SLOT, oArea)),
                IntToString(gsENGetCreatureTimeflag(GS_SLOT, oArea))));
        return TRUE;
    }

    return FALSE;
}
