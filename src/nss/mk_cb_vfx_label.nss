#include "mk_inc_tools"
#include "mk_inc_2da_disp"
#include "mk_inc_states"
#include "mk_inc_vfx"
#include "mk_inc_generic"
#include "mk_inc_tlk"

void main()
{
    object oPC = GetPCSpeaker();
    object oTarget = OBJECT_SELF;
//    SendMessageToPC(GetFirstPC(), "GetPCSpeaker()="+GetName(GetPCSpeaker()));
//    SendMessageToPC(GetFirstPC(), "OBJECT_SELF="+GetName(OBJECT_SELF));
    int nVFXMode = MK_VFX_GetVFXMode(oPC);

//    MK_DEBUG_TRACE("Callback script is running! nVFXmode="+IntToString(nVFXmode)+" detected.");

    string sLabel="";

    if (nVFXMode!=-1)
    {
        string s2DAFile = MK_VFX_Get2DAFile(oPC, nVFXMode);
        int nRow = GetLocalInt(OBJECT_SELF, MK_2DA_DISP_CALLBACK_ROW);

        string sName = Get2DAString(s2DAFile, "Label", nRow);

        int nVFX = MK_VFX_GetVFX(oPC, nVFXMode, nRow, oTarget);

//        MK_DEBUG_TRACE("s2DAFile='"+s2DAFile+"', nRow="+IntToString(nRow)+", sName='"+sName+"', sColumn='"+sColumn+"', nVFX="+IntToString(nVFX));

        string sDescription = MK_VFX_GetDescription(nVFXMode, nVFX, sName);
        int bHasVFX = MK_VFX_GetHasVFX(oPC, nVFX, oTarget);

//        MK_DEBUG_TRACE("s2DAFile='"+s2DAFile+"', nRow="+IntToString(nRow)+", sName='"+sName+"', sColumn='"
//            +sColumn+"', nVFX="+IntToString(nVFX)+", sDescription='"+sDescription+"', bHasVFX="+IntToString(bHasVFX));
        int nGender = GetGender(oTarget);

        sLabel = MK_TLK_GetStringByStrRef( bHasVFX ? -39 : -40, nGender ) + sDescription;

//        MK_DEBUG_TRACE("sLabel='"+sLabel+"'");
    }
    SetLocalString(OBJECT_SELF, MK_2DA_DISP_CALLBACK_LABEL, sLabel);
}
