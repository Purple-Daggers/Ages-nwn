#include "gs_inc_iprop"

int StartingConditional()
{
    int nTableID = GetLocalInt(OBJECT_SELF, "GS_TABLE_ID");
    int nNth     = GetLocalInt(OBJECT_SELF, "GS_OFFSET");
    int nCount   = gsIPGetCount(nTableID);

    return nNth + 5 < nCount;
}
