#include "gs_inc_common"

void main()
{
    object oStore = GetNearestObjectByTag("GS_STORE_004_03");
    if (GetIsObjectValid(oStore)) gsCMOpenStore(oStore, OBJECT_SELF, GetPCSpeaker());
}
