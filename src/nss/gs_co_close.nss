#include "gs_inc_container"

const int GS_LIMIT_DEFAULT = 20;

void main()
{
    string sTag = GetTag(OBJECT_SELF);
    int nLimit  = GetLocalInt(OBJECT_SELF, "GS_LIMIT");

    if (! nLimit) nLimit = GS_LIMIT_DEFAULT;
    DelayCommand(0.5, gsCOSave(sTag, OBJECT_SELF, nLimit));
}
