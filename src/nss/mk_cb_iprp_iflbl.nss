///////////////////////////////////////////////////////////////////////////////
// mk_cb_iprp_iflbl
///////////////////////////////////////////////////////////////////////////////
// callback itemproperty item filter label
///////////////////////////////////////////////////////////////////////////////

#include "mk_inc_debug"
#include "mk_inc_2da_disp"
#include "mk_inc_tlk"
#include "mk_inc_cheats"
//#include "mk_inc_iprp"

const string s2DAfile = "iprp_feats";
const string sColumnFeatIndex = "FeatIndex";
const string sColumnStrRef = "Name";


void main()
{
    object oPC = OBJECT_SELF;
    int nRow = GetLocalInt(OBJECT_SELF, MK_2DA_DISP_CALLBACK_ROW);

    int bSelected = MK_CHEATS_GetIsItemTypeSelected(oPC, nRow);

    int nCol;
    int nStrRef;
    string sLabel="";
    int nGender = GetGender(OBJECT_SELF);
    for (nCol = 1; (nStrRef = MK_Get2DAInt("mk_iprp_cols", "StrRef"+IntToString(nCol), nRow, -1))!=-1; nCol++)
    {
        sLabel += (MK_TLK_GetStringByStrRef(nStrRef, nGender) + ", ");
    }
    if (sLabel!="")
    {
        sLabel = GetStringLeft(sLabel, GetStringLength(sLabel)-2);
    }

//    MK_DEBUG_TRACE("mk_cb_iprp_ftlbl: nFeat="+IntToString(nFeat)
//        +", nFeatIndex="+IntToString(nFeatIndex)
//        +", nStrRef="+IntToString(nStrRef)
//        +", bHasFeat="+IntToString(bHasFeat));

    string sColorTag = GetLocalString(oPC, (bSelected ? "MK_2DA_DISP_CURRENT_COLOR" : "MK_2DA_DISP_DEFAULT_COLOR"));
    sLabel = sColorTag + MK_TLK_GetStringByStrRef( bSelected ? -39 : -40, nGender )
        + sLabel + "</c>";

    SetLocalString(OBJECT_SELF, MK_2DA_DISP_CALLBACK_LABEL, sLabel);
}
