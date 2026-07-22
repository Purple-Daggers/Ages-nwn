#include "mk_inc_debug"
#include "mk_inc_generic"
#include "mk_inc_states"
#include "mk_inc_tools"
#include "mk_inc_2da_disp"
#include "mk_inc_version"
#include "mk_inc_cep"
#include "mk_inc_vfx"


void main()
{
    int bReturn = TRUE;
    int nState = MK_GenericDialog_GetState();

    object oPC = GetPCSpeaker();
    object oTarget = OBJECT_SELF;

    switch (nState)
    {
    case MK_STATE_VFX_INIT_FILTER:
    {
        string s2DAFile = MK_VFX_Get_VFXModeFile(oPC);
        int nRow = GetLocalInt(OBJECT_SELF, MK_2DA_DISP_CALLBACK_ROW);
        int nMajor = MK_Get2DAInt(s2DAFile, "REQ_MAJ", nRow, -1);
        int nMinor = MK_Get2DAInt(s2DAFile, "REQ_MIN", nRow, -1);
        string sReqOther = Get2DAString(s2DAFile, "REQ_OTHER", nRow);
        string s2DA = Get2DAString(s2DAFile, "2DAFILE", nRow);
        int bDisable = MK_Get2DAInt(s2DAFile, "DISABLE", nRow, 0);

        if (bDisable)
        {
            bReturn = FALSE;
        }
        else
        {
            if ((nMajor>=0) && (nMinor>=0))
            {
                bReturn = MK_VERSION_GetIsVersionGreaterEqual(OBJECT_SELF, nMajor, nMinor);
            }
            if (bReturn && (sReqOther!=""))
            {
                if (sReqOther=="CEP")
                {
                    bReturn = MK_CEP_GetIsCEPInstalled();
                }
            }
            if (bReturn && (s2DA!=""))
            {
                bReturn = (Get2DAString(s2DA, "Label", 0)!="");
            }

//        MK_DEBUG_TRACE("mk_cb_vfx_filter: nRow="+IntToString(nRow)+", nVersion="+IntToString(nMajor)+"."+IntToString(nMinor)+", other"+sReqOther
//            +", s2DA="+s2DA
//            +": bReturn="+IntToString(bReturn));
        }
        break;
    }
    }
    SetLocalInt(OBJECT_SELF, MK_2DA_DISP_CALLBACK_CHECK, bReturn);

}
