#include "gs_inc_booksh"

void main()
{
    int nNth = GetLocalInt(OBJECT_SELF, "GS_PAGE_END");

    if (nNth != -1)
    {
        nNth = gsBSGetNextBook(nNth);
        if (nNth != -1) SetLocalInt(OBJECT_SELF, "GS_PAGE_START", nNth);
    }
}

