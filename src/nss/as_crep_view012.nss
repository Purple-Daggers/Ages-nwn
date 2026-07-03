#include "as_inc_rep"

int StartingConditional()
{
    int nNth = GetLocalInt(OBJECT_SELF, "AS_REP_PAGE_END");
    json jReputationsList = GetLocalJson(OBJECT_SELF, "AS_REP_REPUTATIONS_LIST");
    return nNth > 0 && asRPGetNextReputation(jReputationsList, nNth) != -1;
}

