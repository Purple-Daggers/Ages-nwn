// mk_cb_hd_f_label

#include "mk_inc_tools"
#include "mk_inc_2da_disp"
#include "mk_inc_tlk"
#include "mk_inc_head"

void main()
{
    object oPC = GetPCSpeaker();
    object oTarget = OBJECT_SELF;
    int nRow = GetLocalInt(OBJECT_SELF, MK_2DA_DISP_CALLBACK_ROW);
    string s2DA = MK_HEAD_Get2DAFile(oPC);
    MK_DEBUG_TRACE("mk_cb_hd_f_label(oPC='"+GetName(oPC)+"', oTarget='"+GetName(oTarget)+"', s2DA='"+s2DA+"', nRow="+IntToString(nRow)+")");
    string sLabel = MK_TLK_GetStringByStrRef( MK_HEAD_GetIsFilterSelected(oTarget, nRow) ? -39 : -40 )
        + MK_TLK_Get2DAStringByStrRef(s2DA, nRow, "STRREF", "LABEL");
    MK_DEBUG_TRACE(" > sLabel='"+sLabel+"'");
//    int nStrRef = MK_Get2DAInt(s2DA, "STRREF", nRow, 0);
//    string sLabel = (nStrRef!=0 ? MK_TLK_GetStringByStrRef(nStrRef) : Get2DAString(s2DA, "LABEL", nRow));
//    sLabel = MK_TLK_GetStringByStrRef( MK_HEAD_GetIsFilterSelected(oTarget, nRow) ? -39 : -40, GetGender(oTarget) ) + sLabel;

    SetLocalString(OBJECT_SELF, MK_2DA_DISP_CALLBACK_LABEL, sLabel);
}
