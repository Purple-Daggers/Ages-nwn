// mk_cb_hd_f_flt

#include "mk_inc_debug"
#include "mk_inc_generic"
#include "mk_inc_states"
#include "mk_inc_head"
#include "mk_inc_2da_disp"

void main()
{
    int bReturn = FALSE;
    int nState = MK_GenericDialog_GetState();

    switch (nState)
    {
    case MK_STATE_HEAD_FILTER:
    {
        object oPC = GetPCSpeaker();
        object oTarget = OBJECT_SELF;
        int nRow = GetLocalInt(OBJECT_SELF, MK_2DA_DISP_CALLBACK_ROW);
        bReturn = !MK_HEAD_GetIsFilterEmpty(oPC, oTarget, nRow);
        MK_DEBUG_TRACE("mk_cb_hd_f_flt: nRow="+IntToString(nRow)+", bReturn="+IntToString(bReturn));
        break;
    }
    }
    SetLocalInt(OBJECT_SELF, MK_2DA_DISP_CALLBACK_CHECK, bReturn);
}

