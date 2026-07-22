///////////////////////////////////////////////////////////////////////////////
// mk_cb_iprp_ctlbl
///////////////////////////////////////////////////////////////////////////////
// callback itemproperty costtablevalue label
///////////////////////////////////////////////////////////////////////////////

#include "mk_inc_debug"
#include "mk_inc_2da_disp"
#include "mk_inc_tlk"
#include "mk_inc_iprp"
#include "mk_inc_cheats"

//const string s2DAfile = "itempropdef";
const string sColumnStrRef = "Name";

void main()
{
    object oPC = OBJECT_SELF;
    int nRow = GetLocalInt(OBJECT_SELF, MK_2DA_DISP_CALLBACK_ROW);
    object oItem = MK_CHEATS_GetCurrentItem();

    string s2DAFile = MK_2DA_DISPLAY_Get2DAFileName();

    int nStrRef = MK_Get2DAInt(s2DAFile, sColumnStrRef, nRow, -1);

    int nIPropID = MK_CHEATS_GetCurrentItemPropertyID();
    int nSubType = MK_CHEATS_GetCurrentItemPropertySubType();
//    int nParam1 = MK_CHEATS_GetCurrentItemPropertyParam1();

    itemproperty iProp = MK_IPRP_GetItemProperty(oItem, nIPropID, nSubType, nRow);
    int bHasIProp = GetIsItemPropertyValid(iProp);

//    MK_DEBUG_TRACE("mk_cb_iprp_ctlbl: nIProp="+IntToString(nRow)
//        +", nStrRef="+IntToString(nStrRef)
//        +", bHasIProp="+IntToString(bHasIProp));

    int nGender = GetGender(OBJECT_SELF);
    string sColorTag = GetLocalString(oPC, (bHasIProp ? "MK_2DA_DISP_CURRENT_COLOR" : "MK_2DA_DISP_DEFAULT_COLOR"));
    string sLabel = sColorTag + GetStringByStrRef(nStrRef, nGender) + " [#"+IntToString(nRow)+"]</c>";

    SetLocalString(OBJECT_SELF, MK_2DA_DISP_CALLBACK_LABEL, sLabel);
}
