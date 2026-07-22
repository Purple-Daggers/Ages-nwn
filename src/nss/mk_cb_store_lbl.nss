// mk_cb_hd_f_label

#include "mk_inc_tools"
#include "mk_inc_2da_disp"
#include "mk_inc_tlk"
#include "mk_inc_cheats"

void main()
{
    object oPC = OBJECT_SELF;
    int nRow = GetLocalInt(oPC, MK_2DA_DISP_CALLBACK_ROW);

    string sLabel = MK_CHEATS_GetStoreNameByID(nRow);

    SetLocalString(oPC, MK_2DA_DISP_CALLBACK_LABEL, sLabel);
}
