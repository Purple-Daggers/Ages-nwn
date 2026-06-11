#include "gs_inc_booksh"

void main()
{
    int nNth1 = GetLocalInt(OBJECT_SELF, "GS_PAGE_START");

    if (nNth1 > 0)
    {
        int nNth2 = 0;
        int nNth3 = 0;

        for (; nNth2 < 10; nNth2++)
        {
            nNth3 = gsBSGetPreviousBook(nNth1);
            if (nNth3 == -1) break;
            nNth1 = nNth3;
        }

        SetLocalInt(OBJECT_SELF, "GS_PAGE_START", nNth1);
    }
}

