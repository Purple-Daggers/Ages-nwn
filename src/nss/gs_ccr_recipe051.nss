#include "gs_inc_craft"
#include "gs_inc_istate"

int StartingConditional()
{
    object oItem      = GetFirstItemInInventory();
    int nSkill        = GetLocalInt(OBJECT_SELF, "GS_SKILL");
    int nState        = 0;
    int nStateMaximum = 0;

    while (GetIsObjectValid(oItem))
    {
        if (gsISGetItemCraftSkill(oItem) == nSkill)
        {
            nState        = gsISGetItemState(oItem);
            nStateMaximum = gsISGetMaximumItemState(oItem);

            if (nState < nStateMaximum)
            {
                object oSpeaker = GetPCSpeaker();

                SetCustomToken(100, GetName(oItem));
                SetCustomToken(101, IntToString(nState));
                SetCustomToken(102, IntToString(nStateMaximum));
                SetCustomToken(103, IntToString(gsISGetItemRepairDC(oItem)));
                SetCustomToken(104, IntToString(gsCRGetSkillRank(nSkill, oSpeaker)));
                SetCustomToken(105, IntToString(gsCRGetCraftPoints(oSpeaker)));

                SetLocalObject(OBJECT_SELF, "GS_ITEM", oItem);
                return TRUE;
            }
        }

        oItem = GetNextItemInInventory();
    }

    return FALSE;
}
