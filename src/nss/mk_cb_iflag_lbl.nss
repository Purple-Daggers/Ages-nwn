#include "mk_inc_itm_disp"
#include "mk_inc_iprp"
#include "mk_inc_states"

void main()
{
    object oPC = OBJECT_SELF;
    object oItem = GetLocalObject(oPC, MK_ITM_DISP_CALLBACK_OBJECT);

    string sLabel = MK_IPRP_GetItemName(oItem, TRUE);

    string sColorTag = GetLocalString(oPC, "MK_CHEATS_FLAGS_COLOR");
    string sCloseTag = "</c>";

    int nState = MK_GenericDialog_GetState();

    switch (nState)
    {
    case MK_STATE_CHEATS_CURSEDFLAG:
        if (GetItemCursedFlag(oItem))
        {
            sLabel += (sColorTag + " *" + GetStringByStrRef(111874) + "*" + sCloseTag);
        }
        break;
    case MK_STATE_CHEATS_PLOTFLAG:
        if (GetPlotFlag(oItem))
        {
            sLabel += (sColorTag + " *" + GetStringByStrRef(6808) + "*" + sCloseTag); // or 7520?
        }
        break;
    case MK_STATE_CHEATS_STOLENFLAG:
        if (GetStolenFlag(oItem))
        {
            sLabel += (sColorTag + " *" + GetStringByStrRef(7102) + "*" + sCloseTag);
        }
        break;
    case MK_STATE_CHEATS_NOTIDENTIFIED:
        if (!GetIdentified(oItem))
        {
            // Postfix already done by MK_IPRP_GetItemName()
            sLabel = sColorTag + sLabel + sCloseTag;
        }
        break;
    }
    SetLocalString(OBJECT_SELF, MK_ITM_DISP_CALLBACK_LABEL, sLabel);
}
