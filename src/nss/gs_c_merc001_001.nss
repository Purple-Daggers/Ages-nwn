#include "gs_inc_common"

void main()
{
    object oStore = GetNearestObjectByTag("GS_STORE_" + GetTag(OBJECT_SELF));
    if (GetIsObjectValid(oStore)) gsCMOpenStore(oStore, OBJECT_SELF, GetPCSpeaker());
}
