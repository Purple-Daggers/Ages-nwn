#include "gs_inc_container"

const int GS_LIMIT_DEFAULT = 20;

void main()
{
    if (! GetLocalInt(OBJECT_SELF, "GS_ENABLED"))
    {
        int nLimit = GetLocalInt(OBJECT_SELF, "GS_LIMIT");

        if (! nLimit) nLimit = GS_LIMIT_DEFAULT;
        gsCOLoad(GetTag(OBJECT_SELF), OBJECT_SELF, nLimit);
        SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);
    }
}
