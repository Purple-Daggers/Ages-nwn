#include "gs_inc_common"
#include "gs_inc_iprop"
#include "gs_inc_text"
#include "gs_inc_xp"

const int GS_LIMIT_COST = 10000;

int StartingConditional()
{
    object oItem = GetFirstItemInInventory();

    if (GetIsObjectValid(oItem))
    {
        int nPropertyID = GetLocalInt(OBJECT_SELF, "GS_PROPERTY_ID");
        int nSubTypeID  = GetLocalInt(OBJECT_SELF, "GS_SUBTYPE_ID");
        int nCostID     = GetLocalInt(OBJECT_SELF, "GS_COST_ID");
        int nParamID    = GetLocalInt(OBJECT_SELF, "GS_PARAM_ID");

        itemproperty ipProperty = gsIPGetItemProperty(nPropertyID, nSubTypeID, nCostID, nParamID);

        if (GetIsItemPropertyValid(ipProperty))
        {
            object oSpeaker = GetPCSpeaker();
            int nDM         = GetIsDM(oSpeaker);
            int nCost       = nDM ? 0 : gsIPGetCost(oItem, ipProperty);

            // Addition by Mithreas. Enchanters are better at enchanting. --[
            if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT, oSpeaker))
            {
              nCost = FloatToInt(IntToFloat(nCost) * 0.65); // 35% discount
            }
            else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT, oSpeaker))
            {
              nCost = FloatToInt(IntToFloat(nCost) * 0.80); // 20% discount
            }
            else if (GetHasFeat(FEAT_SPELL_FOCUS_ENCHANTMENT, oSpeaker))
            {
              nCost = FloatToInt(IntToFloat(nCost) * 0.90); // 10% discount
            }
            // ]-- End addition.

            if (! nDM && nCost > GetGold(oSpeaker))
            {
                SetCustomToken(100, GS_T_16777238);
            }
            else
            {
                if (! nDM)
                {
                    int nChance = 5;

                    if (nCost)
                    {
                        nChance  = (gsCMGetItemValue(oItem) + nCost) * 100 / GS_LIMIT_COST;
                        if (nChance < 5)        nChance =   5;
                        else if (nChance > 100) nChance = 100;

                        TakeGoldFromCreature(nCost, oSpeaker, TRUE);
                    }

                    if (Random(100) < nChance)
                    {
                        nCost   /= 10;
                        SetCustomToken(100, gsCMReplaceString(GS_T_16777239, IntToString(nCost)));
                        DestroyObject(oItem);
                        gsXPGiveExperience(oSpeaker, -nCost);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                            EffectVisualEffect(VFX_IMP_DEATH),
                                            OBJECT_SELF);
                        return TRUE;
                    }
                }

                SetCustomToken(100, GS_T_16777240);
                gsIPAddItemProperty(oItem, ipProperty);
                ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                    EffectVisualEffect(VFX_IMP_SUPER_HEROISM),
                                    OBJECT_SELF);
            }
        }

        return TRUE;
    }

    return FALSE;
}
