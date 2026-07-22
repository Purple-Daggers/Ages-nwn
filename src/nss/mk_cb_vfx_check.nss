#include "mk_inc_debug"
//#include "mk_inc_tools"
#include "mk_inc_vfx"
//#include "mk_inc_generic"
//#include "mk_inc_states"
#include "mk_inc_2da_disp"

void main()
{
    object oPC = GetPCSpeaker();
    object oTarget = OBJECT_SELF;
    int nVFXMode = MK_VFX_GetVFXMode(oPC);
//    MK_DEBUG_TRACE("Running mk_cb_vfx_check: );
    int nRow = GetLocalInt(OBJECT_SELF, MK_2DA_DISP_CALLBACK_ROW);

    int bCheck=MK_VFX_GetVFXIsValid(oPC, nVFXMode, nRow, oTarget);

//    MK_DEBUG_TRACE("mk_cb_vfx_check: nVFXmode="+IntToString(nVFXmode)
//        +", nRow="+IntToString(nRow)
//        +", bCheck="+IntToString(bCheck));

    SetLocalInt(OBJECT_SELF, MK_2DA_DISP_CALLBACK_CHECK, bCheck);
}
