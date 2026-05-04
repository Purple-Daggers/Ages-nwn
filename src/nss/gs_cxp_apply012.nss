#include "gs_inc_pc"

void main()
{
    object oTarget = GetLocalObject(OBJECT_SELF, "GS_TARGET");

    gsPCSetRolePlay(oTarget, 100);
}
