///////////////////////////////////////////////////////////////////////////////
// mk_cb_iprp_ftlbl
///////////////////////////////////////////////////////////////////////////////
// callback itemproperty feat label
///////////////////////////////////////////////////////////////////////////////

#include "mk_inc_debug"
#include "mk_inc_2da_disp"
#include "mk_inc_tlk"
#include "mk_inc_iprp"

const string s2DAfile = "iprp_feats";
const string sColumnFeatIndex = "FeatIndex";
const string sColumnStrRef = "Name";


void main()
{
    object oPC = OBJECT_SELF;
    int nRow = GetLocalInt(OBJECT_SELF, MK_2DA_DISP_CALLBACK_ROW);

    int nFeat = nRow;
    int nFeatIndex = MK_Get2DAInt(s2DAfile, sColumnFeatIndex, nRow, -1);
    int nStrRef = MK_Get2DAInt(s2DAfile, sColumnStrRef, nRow, -1);

    object oItem = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);

    int bHasFeat = MK_IPRP_GetItemHasFeat(oItem, nFeat);

//    MK_DEBUG_TRACE("mk_cb_iprp_ftlbl: nFeat="+IntToString(nFeat)
//        +", nFeatIndex="+IntToString(nFeatIndex)
//        +", nStrRef="+IntToString(nStrRef)
//        +", bHasFeat="+IntToString(bHasFeat));

    int nGender = GetGender(OBJECT_SELF);
    string sColorTag = GetLocalString(oPC, (bHasFeat ? "MK_2DA_DISP_CURRENT_COLOR" : "MK_2DA_DISP_DEFAULT_COLOR"));
    string sLabel = sColorTag + MK_TLK_GetStringByStrRef( bHasFeat ? -39 : -40, nGender )
        + GetStringByStrRef(nStrRef, nGender) + " [#"+IntToString(nFeatIndex)+"]</c>";

    SetLocalString(OBJECT_SELF, MK_2DA_DISP_CALLBACK_LABEL, sLabel);
}
