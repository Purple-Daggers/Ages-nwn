// mk_cb_hd_label

#include "mk_inc_debug"
#include "mk_inc_2da_disp"
#include "mk_inc_tools"

void main()
{
//    object oPC = GetPCSpeaker();
//    object oTarget = OBJECT_SELF;
    int nRow = GetLocalInt(OBJECT_SELF, MK_2DA_DISP_CALLBACK_ROW);
    string sLabel = "Head " + MK_IntToString(nRow, 3, "0");
//    MK_DEBUG_TRACE("mk_cb_hd_label: nRow="+IntToString(nRow)+", sLabel='"+sLabel+"'");
    SetLocalString(OBJECT_SELF, MK_2DA_DISP_CALLBACK_LABEL, sLabel);
}
