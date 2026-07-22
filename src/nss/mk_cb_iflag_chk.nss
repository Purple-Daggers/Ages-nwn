#include "mk_inc_debug"
#include "mk_inc_states"
#include "mk_inc_itm_disp"

void main()
{
    object oPC = OBJECT_SELF;
    object oItem = GetLocalObject(oPC, MK_ITM_DISP_CALLBACK_OBJECT);

    int nState = MK_GenericDialog_GetState();

    int bCheck = GetLocalInt(oPC, "MK_CHEATS_SHOWALLITEMS")
        || GetLocalInt(oItem, "MK_CHEATS_FLAG_" + IntToString(nState));

    if (!bCheck)
    {
        switch (nState)
        {
        case MK_STATE_CHEATS_CURSEDFLAG:
            bCheck = bCheck || GetItemCursedFlag(oItem);
            break;
        case MK_STATE_CHEATS_PLOTFLAG:
            bCheck = bCheck || GetPlotFlag(oItem);
            break;
        case MK_STATE_CHEATS_STOLENFLAG:
            bCheck = bCheck || GetStolenFlag(oItem);
            break;
        case MK_STATE_CHEATS_NOTIDENTIFIED:
            bCheck = bCheck || !GetIdentified(oItem);
            break;
        }
    }
//    MK_DEBUG_TRACE("mk_cb_iflag_chk (nState="+IntToString(nState)+"): '"+GetName(oItem)+"', bCheck="+IntToString(bCheck));

    SetLocalInt(OBJECT_SELF, MK_ITM_DISP_CALLBACK_CHECK, bCheck);
}
