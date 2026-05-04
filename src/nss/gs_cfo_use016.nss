#include "gs_inc_forum"

int StartingConditional()
{
    int nNth = GetLocalInt(OBJECT_SELF, "GS_PAGE_START");
    return nNth > 0 && gsFOGetPreviousMessage(nNth) != -1;
}
