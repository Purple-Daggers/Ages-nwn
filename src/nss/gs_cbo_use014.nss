#include "gs_inc_booksh"

int StartingConditional()
{
    int nNth = GetLocalInt(OBJECT_SELF, "GS_PAGE_END");
    return nNth > 0 && gsBOGetNextBook(nNth) != -1;
}
