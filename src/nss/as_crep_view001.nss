#include "as_inc_rep"
#include "gs_inc_token"

int StartingConditional()
{
    json jReputationsList = JsonNull();
    object oPlayer = GetLocalObject(OBJECT_SELF, "AS_REP_TARGET");
    if (!GetLocalInt(OBJECT_SELF, "AS_REP_LOADED"))
    {
        jReputationsList = asRPGetReputations(oPlayer);
        jReputationsList = JsonArrayTransform(jReputationsList, JSON_ARRAY_SORT_DESCENDING);
        SetLocalInt(OBJECT_SELF, "AS_REP_REPUTATION", -1);
        SetLocalInt(OBJECT_SELF, "AS_REP_LOADED", TRUE);
        SetLocalJson(OBJECT_SELF, "AS_REP_REPUTATIONS_LIST", jReputationsList);
    }

    string sKey = "";
    int nRep = 0;
    int nNth          = GetLocalInt(OBJECT_SELF, "AS_REP_PAGE_START");
    nNth              = JsonGetType(JsonArrayGet(jReputationsList, nNth)) == JSON_TYPE_NULL ? -1 : nNth;
    int nSlot         = 1;

    SetLocalInt(OBJECT_SELF, "AS_REP_PAGE_START", nNth);

    while (TRUE)
    {
        SetLocalInt(OBJECT_SELF, "AS_REP_SLOT_" + IntToString(nSlot), nNth);

        if (nNth != -1)
        {
            sKey = JsonGetString(JsonArrayGet(jReputationsList, nNth));
            nRep = asRPGetReputation(oPlayer, sKey);
            gsTKSetToken(100 + nSlot, "<cþë¦>" + sKey + "<câÛÂ>");
            gsTKSetToken(110 + nSlot, "<c(”þ>" + IntToString(nRep));
        }

        if (++nSlot > 10) break;

        if (nNth != -1)  nNth = asRPGetNextReputation(jReputationsList, nNth);
    }

    SetLocalInt(OBJECT_SELF, "AS_REP_PAGE_END", nNth);

    nNth = GetLocalInt(OBJECT_SELF, "AS_REP_REPUTATION");
    if (nNth != -1)
    {
        sKey = JsonGetString(JsonArrayGet(jReputationsList, nNth));
        nRep = asRPGetReputation(oPlayer, sKey);
        SetCustomToken(1100, sKey);
        SetCustomToken(1101, IntToString(nRep));
    } else {
        SetCustomToken(1100, "None selected");
        SetCustomToken(1101, "N/A");
    }

    return TRUE;
}

