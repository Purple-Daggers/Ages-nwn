#include "gs_inc_forum"

void main()
{
    int nNth1 = GetLocalInt(OBJECT_SELF, "GS_PAGE_START");

    if (nNth1 > 0)
    {
        int nNth2 = 0;
        int nNth3 = 0;

        for (; nNth2 < 5; nNth2++)
        {
            nNth3 = gsFOGetPreviousMessage(nNth1);
            if (nNth3 == -1) break;
            nNth1 = nNth3;
        }

        SetLocalInt(OBJECT_SELF, "GS_PAGE_START", nNth1);
    }
}
