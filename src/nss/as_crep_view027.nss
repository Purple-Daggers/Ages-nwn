#include "as_inc_rep"

void main()
{
    int nNth1 = GetLocalInt(OBJECT_SELF, "AS_REP_PAGE_START");
    json jReputationsList = GetLocalJson(OBJECT_SELF, "AS_REP_REPUTATIONS_LIST");

    if (nNth1 > 0)
    {
        int nNth2 = 0;
        int nNth3 = 0;

        for (; nNth2 < 10; nNth2++)
        {
            nNth3 = asRPGetPreviousReputation(jReputationsList, nNth1);
            if (nNth3 == -1) break;
            nNth1 = nNth3;
        }

        SetLocalInt(OBJECT_SELF, "AS_REP_PAGE_START", nNth1);
    }
}

