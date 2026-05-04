#include "gs_inc_craft"

int StartingConditional()
{
    object oItem   = GetFirstItemInInventory();
    int nSkill     = GetLocalInt(OBJECT_SELF, "GS_SKILL");
    string sString = "GS_CR_" + IntToString(nSkill) + "_";
    int nCount     = GetStringLength(sString);

    while (GetIsObjectValid(oItem))
    {
        if (GetStringLeft(GetTag(oItem), nCount) == sString)
        {
            struct gsCRProduction stProduction =
                gsCRGetProductionData(oItem);
            struct gsCRRecipe stRecipe         =
                gsCRGetRecipeByID(stProduction.nSkill, stProduction.sRecipe);
            object oSpeaker                    = GetPCSpeaker();
            int nCraftPoints                   = gsCRGetRecipeCraftPoints(stRecipe);

            SetCustomToken(100, IntToString(100 * stProduction.nCraftPoints / nCraftPoints));
            SetCustomToken(101, stRecipe.sName);
            SetCustomToken(102, gsCRGetCategoryName(stRecipe.nCategory));
            SetCustomToken(103, IntToString(gsCRGetRecipeDC(stRecipe)));
            SetCustomToken(104, IntToString(stProduction.nCraftPoints));
            SetCustomToken(105, IntToString(nCraftPoints));
            SetCustomToken(106, IntToString(stRecipe.nValue));
            SetCustomToken(107, gsCRGetRecipeOutputList(stRecipe));
            SetCustomToken(108, IntToString(gsCRGetSkillRank(nSkill, oSpeaker)));
            SetCustomToken(109, IntToString(gsCRGetCraftPoints(oSpeaker)));

            SetLocalObject(OBJECT_SELF, "GS_ITEM", oItem);
            return TRUE;
        }

        oItem = GetNextItemInInventory();
    }

    return FALSE;
}
