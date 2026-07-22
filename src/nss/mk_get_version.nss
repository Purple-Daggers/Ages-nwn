#include "mk_inc_version"

void main()
{
    MK_VERSION_DetectGameVersionQ(OBJECT_SELF, GetLocalInt(OBJECT_SELF, "MK_NWN_VERSION_DEBUG_MESSAGE"));
}
