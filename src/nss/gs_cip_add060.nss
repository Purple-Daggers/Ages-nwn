#include "gs_inc_common"
#include "gs_inc_iprop"

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
            int nCost            = gsIPGetCost(oItem, ipProperty);
            int nChance          = 5;
            int nPropertyStrRef  = GetLocalInt(OBJECT_SELF, "GS_PROPERTY_STRREF");
            string sPropertyName = GetStringByStrRef(nPropertyStrRef);

            // Addition by Mithreas. Enchanters are better at enchanting. --[
            if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT, GetPCSpeaker()))
            {
              nCost = FloatToInt(IntToFloat(nCost) * 0.65); // 35% discount
            }
            else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT, GetPCSpeaker()))
            {
              nCost = FloatToInt(IntToFloat(nCost) * 0.80); // 20% discount
            }
            else if (GetHasFeat(FEAT_SPELL_FOCUS_ENCHANTMENT, GetPCSpeaker()))
            {
              nCost = FloatToInt(IntToFloat(nCost) * 0.90); // 10% discount
            }
            // ]-- End addition.

            if (nCost)
            {
                nChance = (gsCMGetItemValue(oItem) + nCost) * 100 / GS_LIMIT_COST;
                if (nChance < 5)        nChance =   5;
                else if (nChance > 100) nChance = 100;
            }

            SetCustomToken(100, GetName(oItem));
            SetCustomToken(101, sPropertyName);
            SetCustomToken(102, IntToString(nCost));
            SetCustomToken(103, IntToString(100 - nChance));
            SetCustomToken(104, IntToString(nCost / 10));

            return TRUE;
        }
    }

    return FALSE;
}
