#include "mk_inc_debug"
#include "mk_inc_2da_disp"
#include "mk_inc_tlk"
#include "mk_inc_iprp"
#include "mk_inc_cheats"

const string s2DAfile = "itempropdef";
const string sColumnStrRef = "Name";


void main()
{
    object oPC = OBJECT_SELF;
    int nRow = GetLocalInt(OBJECT_SELF, MK_2DA_DISP_CALLBACK_ROW);
    object oItem = MK_CHEATS_GetCurrentItem();

    int nStrRef = MK_Get2DAInt(s2DAfile, sColumnStrRef, nRow, -1);

    itemproperty iProp = MK_IPRP_GetItemProperty(oItem, nRow);
    int bHasIProp = GetIsItemPropertyValid(iProp);

//    MK_DEBUG_TRACE("mk_cb_iprp_iplbl: nIProp="+IntToString(nRow)
//        +", nStrRef="+IntToString(nStrRef)
//        +", bHasIProp="+IntToString(bHasIProp));

    int nGender = GetGender(OBJECT_SELF);
    string sColorTag = GetLocalString(oPC, (bHasIProp ? "MK_2DA_DISP_CURRENT_COLOR" : "MK_2DA_DISP_DEFAULT_COLOR"));
    string sLabel = sColorTag + GetStringByStrRef(nStrRef, nGender) + " [#"+IntToString(nRow)+"]</c>";

    SetLocalString(OBJECT_SELF, MK_2DA_DISP_CALLBACK_LABEL, sLabel);
}
