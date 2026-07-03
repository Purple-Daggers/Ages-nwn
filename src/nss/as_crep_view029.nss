#include "as_inc_rep"

void main()
{
    int nNth = GetLocalInt(OBJECT_SELF, "AS_REP_REPUTATION");

    if (nNth != -1)
    {
        json jReputationsList = GetLocalJson(OBJECT_SELF, "AS_REP_REPUTATIONS_LIST");
        object oPlayer = GetLocalObject(OBJECT_SELF, "AS_REP_TARGET");
        string sFaction = JsonGetString(JsonArrayGet(jReputationsList, nNth));
        asRPAdjustReputation(oPlayer, sFaction, 1);
    }
}
