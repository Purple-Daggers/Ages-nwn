#include "gs_inc_common"
#include "gs_inc_encounter"
#include "gs_inc_text"

const int GS_SLOT = 1;

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
                gsENGetCreatureName(nNth, oArea),
                FloatToString(gsENGetCreatureRating(nNth, oArea), 0, 1),
                IntToString(gsENGetCreatureChance(nNth, oArea))));
        return TRUE;
    }

    return FALSE;
}
