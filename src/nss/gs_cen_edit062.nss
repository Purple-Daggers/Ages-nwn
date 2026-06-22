#include "gs_inc_encounter"

int StartingConditional()
{
    object oArea = GetArea(OBJECT_SELF);
    int nOffset  = 0;
    int nSlot    = 0;
    int nNth     = 1;

    for (; nNth <= GS_EN_LIMIT_SLOT; nNth++)
    {
        if (gsENGetCreatureTemplate(nNth, oArea) != "")
            SetLocalInt(OBJECT_SELF, "GS_EN_SLOT_" + IntToString(++nSlot), nNth);
    }

    if (GetLocalObject(OBJECT_SELF, "GS_EN_AREA") != oArea)
    {
        SetLocalObject(OBJECT_SELF, "GS_EN_AREA", oArea);
    }
    else if (nSlot)
    {
        nOffset = GetLocalInt(OBJECT_SELF, "GS_EN_OFFSET");
        while (nOffset >= nSlot) nOffset -= 10;
    }

    SetLocalInt(OBJECT_SELF, "GS_EN_OFFSET", nOffset);
    SetLocalInt(OBJECT_SELF, "GS_EN_COUNT", nSlot);
    SetCustomToken(1000, IntToString(gsENGetEncounterChance(oArea)));
    SetCustomToken(1001, FloatToString(gsENGetMinimumRating(oArea), 0, 1));
    SetCustomToken(1002, IntToString(nOffset / 10 + 1));
    SetCustomToken(1003, IntToString(nSlot ? (nSlot - 1) / 10 + 1 : 1));
    return TRUE;
}
