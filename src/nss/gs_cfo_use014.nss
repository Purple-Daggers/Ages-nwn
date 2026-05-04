#include "gs_inc_forum"

int StartingConditional()
{
    int nNth = GetLocalInt(OBJECT_SELF, "GS_PAGE_END");
    return nNth > 0 && gsFOGetNextMessage(nNth) != -1;
}
