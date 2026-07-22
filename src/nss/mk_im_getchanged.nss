//#include "x2_inc_craft"
#include "mk_inc_craft"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oTarget = MK_GetCurrentTarget(oPC);
    object oBackup =  CIGetCurrentModBackup(oPC);
    object oItem = CIGetCurrentModItem(oPC);

    int iResult;

    switch (CIGetCurrentModMode(oPC))
    {
    case MK_CI_MODMODE_CHARACTER:
        iResult = MK_GetIsDescriptionModified(oTarget);
        break;
//    case MK_CI_MODMODE_ITEM:
//        iResult = (GetIsObjectValid(oItem) && (GetLocalInt(oItem, "MK_ITEM_MODIFIED")==1));
//        break;
    default:
        iResult = MK_GetIsModified(oItem, oBackup);
        break;
    }

    return iResult;
}
