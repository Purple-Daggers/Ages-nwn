#include "gs_inc_common"

void main()
{
    object oStore = GetNearestObjectByTag("GS_STORE_004_05");
    if (GetIsObjectValid(oStore)) gsCMOpenStore(oStore, OBJECT_SELF, GetPCSpeaker());
}
