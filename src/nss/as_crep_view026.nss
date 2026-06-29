#include "as_inc_rep"

void main()
{
    int nNth = GetLocalInt(OBJECT_SELF, "AS_REP_PAGE_END");
    json jReputationsList = GetLocalJson(OBJECT_SELF, "AS_REP_REPUTATIONS_LIST");

    if (nNth != -1)
    {
        nNth = asRPGetNextReputation(jReputationsList, nNth);
        if (nNth != -1) SetLocalInt(OBJECT_SELF, "AS_REP_PAGE_START", nNth);
    }
}

