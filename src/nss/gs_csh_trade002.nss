#include "gs_inc_common"
#include "gs_inc_finance"
#include "gs_inc_shop"
#include "gs_inc_text"

void main()
{
    object oSpeaker = GetPCSpeaker();
    object oItem    = GetLocalObject(oSpeaker, "GS_SH_ITEM");
    object oSelf    = OBJECT_SELF;
    int nSalePrice  = gsSHGetSalePrice(OBJECT_SELF);
    int nValue      = gsCMGetItemValue(oItem) * nSalePrice / 100;
    if (nValue < 1) nValue = 1;

    if (GetGold(oSpeaker) < nValue)
    {
        SendMessageToPC(oSpeaker, GS_T_16777238);
    }
    else
    {
        string sID  = gsSHGetOwnerID(OBJECT_SELF);

        AssignCommand(oSpeaker, gsFITransfer(sID, nValue));
        gsSHExportItem(oItem, oSpeaker);
        ActionDoCommand(DelayCommand(0.5, gsSHSave(OBJECT_SELF)));
    }

    AssignCommand(oSpeaker, ActionInteractObject(oSelf));
}
