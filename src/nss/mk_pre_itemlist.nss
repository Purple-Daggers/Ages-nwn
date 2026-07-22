#include "mk_inc_generic"
#include "x2_inc_craft"
#include "mk_inc_craft"
#include "mk_inc_states"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oTarget = MK_GetCurrentTarget(oPC);
    object oItem = CIGetCurrentModItem(oPC);
    int nItemType = GetBaseItemType(oItem);


    int nPosition=0;
    oItem = GetFirstItemInInventory(oTarget);
    while (GetIsObjectValid(oItem))
    {
        if (GetBaseItemType(oItem)==nItemType)
        {
            MK_GenericDialog_SetCondition(nPosition,1);
            MK_GenericDialog_SetObject(nPosition, oItem);
//            SetLocalInt(OBJECT_SELF, "MK_CONDITION_"+IntToString(nPosition),1);
//            SetLocalObject(OBJECT_SELF, "MK_OBJECT_"+IntToString(nPosition), oItem);
            SetCustomToken(MK_TOKEN_ITEMLIST+nPosition, GetName(oItem));
            nPosition++;
        }
        oItem = GetNextItemInInventory(oTarget);
    }
    while (nPosition<21)
    {
        MK_GenericDialog_SetCondition(nPosition,0);

//        SetLocalInt(OBJECT_SELF, "MK_CONDITION_"+IntToString(nPosition),0);
        nPosition++;
    }

    MK_GenericDialog_SetState(MK_STATE_COPY);
//    SetLocalInt(OBJECT_SELF, "MK_SET_COPY", 1);

    MK_SetCustomTokenByItemTypeName(oTarget, oPC);

    return TRUE;
}
