#include "mk_inc_generic"
#include "mk_inc_body"
#include "mk_inc_vfx"
#include "mk_inc_states"
#include "mk_inc_2da_disp"
#include "mk_inc_delimiter"
#include "mk_inc_cep"

int GetIsCraftingDisabled(object oPC, int i)
{
    string sVarName = "MK_DISABLE_CRAFT_" + MK_IntToString(i, 2, "0");
    return (GetLocalInt(oPC, sVarName)==1);
}


int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oTarget = OBJECT_SELF;

    int nState = MK_GenericDialog_GetState();

    int nCurrentPage=-1;

    int nAction = MK_GenericDialog_GetAction();

    MK_DEBUG_TRACE("mk_pre_vfx (in): nState="+IntToString(nState));
    MK_DEBUG_TRACE("mk_pre_vfx (in): nAction="+IntToString(nAction));

    int nVFXMode = -1;

    switch (nState)
    {
    case MK_STATE_VFX_SELECT_FILTER:
        switch (nAction)
        {
        case 250:
        case 251:
        case 252:
        case 253:
            nCurrentPage = MK_2DA_DISPLAY_UpdatePage(nAction);
            break;
        case -1:
            break;
        default:
            if ((nAction>=0) && (nAction<MK_2DA_DISPLAY_GetPageLength()))
            {
                nVFXMode = MK_2DA_DISPLAY_GetSelectedRow(nAction);
                MK_VFX_SetVFXMode(nVFXMode, oPC);
 //               MK_DEBUG_TRACE("mk_pre_vfx2: nVFXMode="+IntToString(nVFXMode));
                string s2DA = MK_VFX_Get_VFXModeFile(oPC);
                MK_GenericDialog_SetState(nState = MK_STATE_VFX_SELECT_EFFECT);
                string sScrCheck = Get2DAString(s2DA, "SCR_CHECK", nVFXMode);
                int nMaxHoleSize = MK_Get2DAInt(s2DA, "MAX_HOLE_SIZE", nVFXMode, 10);

                MK_VFX_SetCurrentVFX(-1);
                MK_VFX_SetCurrentRow(-1);

                MK_2DA_DISPLAY_Initialize(
                    MK_VFX_Get2DAFile(oPC, nVFXMode),
                    "Label",
                    "Label",
                    "",
                    "Type_FD",
                    nMaxHoleSize,
                    sScrCheck
                    );

                MK_2DA_DISPLAY_SetPageLength(MK_VFX_GetNumberOfVFXPerPage(oPC));
                nCurrentPage = MK_2DA_DISPLAY_GetCurrentPage();
                nAction = -1;
                MK_CraftBody_SetDefaultCameraFacing(oPC);
            }
        }
        break;
    case MK_STATE_VFX_SELECT_EFFECT:
        switch (nAction)
        {
        case 250:
        case 251:
        case 252:
        case 253:
            nCurrentPage = MK_2DA_DISPLAY_UpdatePage(nAction);
            break;
        case 255:
            MK_VFX_SetCurrentVFX(-1);
            MK_VFX_SetCurrentRow(-1);
            MK_GenericDialog_SetState(nState = MK_STATE_VFX_INIT_FILTER);
            break;
        case 127:
            // Remove all effects
            MK_VFX_RemoveAllEffects(oTarget);
            MK_VFX_SetCurrentVFX(-1);
            MK_VFX_SetCurrentRow(-1);
            break;
        case 40:
            MK_GenericDialog_SetState(nState = MK_STATE_VFX_EDIT_EFFECT);
            MK_DEBUG_TRACE("Edit effect: nState="+IntToString(nState));
            break;
        case -1:
            break;
        default:
            if ((nAction>=0) && (nAction<MK_2DA_DISPLAY_GetPageLength()))
            {
                int nRow = MK_2DA_DISPLAY_GetSelectedRow(nAction);
                nVFXMode = MK_VFX_GetVFXMode(oPC);
                int nVFX = MK_VFX_GetVFX(oPC, nVFXMode, nRow, oTarget);
//                MK_DEBUG_TRACE("mk_pre_vfx2: nAction="+IntToString(nAction)
//                    +", nRow="+IntToString(nRow)
//                    +", nVFXMode="+IntToString(nVFXMode)
//                    +", nVFX="+IntToString(nVFX));
                if (nVFX!=-1)
                {
                    int bHasVFX = MK_VFX_GetHasVFX(oPC, nVFX, oTarget);
                    int bIsCurrentVFX = (MK_VFX_GetCurrentVFX()==nVFX);

                    if (bIsCurrentVFX && bHasVFX)
                    {
                        if (!MK_VFX_RemoveVFX(oTarget, nVFX, oPC))
                        {
                            SendMessageToPC(oPC, "Failed to remove the selected vfx!");
                        }
                        else
                        {
                            MK_VFX_SetCurrentVFX(-1);
                            MK_VFX_SetCurrentRow(-1);
                        }
                    }
                    else if (!bIsCurrentVFX && bHasVFX)
                    {
                        MK_VFX_SetCurrentVFX(nVFX);
                        MK_VFX_SetCurrentRow(nRow);
                    }
                    else
                    {
                        if (!MK_VFX_ApplyVFX(oTarget, nVFX, oPC, nVFXMode, nRow))
                        {
                            SendMessageToPC(oPC, "Failed to apply the selected vfx!");
                        }
                        else
                        {
                            MK_VFX_SetCurrentVFX(nVFX);
                            MK_VFX_SetCurrentRow(nRow);
                        }
                    }
                }
            }
        }
        break;
    case MK_STATE_VFX_EDIT_EFFECT:
        switch (nAction)
        {
        case 21:
        case 22:
        case 23:
        case 24:
        case 25:
        case 26:
        {
            // rotation
            effect e = MK_EFFECT_GetCurrentEffect(oTarget);
            vector vRotate = MK_EFFECT_GetRotate(e);
            float fStep = GetLocalFloat(oPC, "MK_VFX_ROTATE_STEP");
            if (fStep==0.0) fStep = 1.0f;
            switch (nAction)
            {
            case 21:
                vRotate.z += fStep;
                break;
            case 22:
                vRotate.z -= fStep;
                break;
            case 23:
                vRotate.x += fStep;
                break;
            case 24:
                vRotate.x -= fStep;
                break;
            case 25:
                vRotate.y += fStep;
                break;
            case 26:
                vRotate.y -= fStep;
                break;
            }

            MK_EFFECT_UpdateEffect(oTarget, MK_VFX_GetCurrentVFX(), oPC,
                MK_EFFECT_GetScale(e),
                MK_EFFECT_GetTranslate(e),
                vRotate);
            break;
        }
        case 28:
        case 29:
        {
            // scale
            effect e = MK_EFFECT_GetCurrentEffect(oTarget);
            float fScale = MK_EFFECT_GetScale(e);
            float fStep = GetLocalFloat(oPC, "MK_VFX_SCALE_STEP");
            if (fStep==0.0) fStep = 0.05f;

            if (29-nAction)
            {
                fScale += fStep;
            }
            else
            {
                fScale -= fStep;
            }
            MK_DEBUG_TRACE("Edit effect: fScale = "+FloatToString(fScale, 7, 3));

            MK_EFFECT_UpdateEffect(oTarget, MK_VFX_GetCurrentVFX(), oPC,
                fScale,
                MK_EFFECT_GetTranslate(e),
                MK_EFFECT_GetRotate(e));
            break;
        }
        case 31:
        case 32:
        case 33:
        case 34:
        case 35:
        case 36:
        {
            // translate
            effect e = MK_EFFECT_GetCurrentEffect(oTarget);
            vector vTranslate = MK_EFFECT_GetTranslate(e);
            float fStep = GetLocalFloat(oPC, "MK_VFX_TRANSLATE_STEP");
            if (fStep==0.0) fStep = 0.1f;

            switch (nAction)
            {
            case 31:
                vTranslate.z += fStep;
                break;
            case 32:
                vTranslate.z -= fStep;
                break;
            case 33:
                vTranslate.x += fStep;
                break;
            case 34:
                vTranslate.x -= fStep;
                break;
            case 35:
                vTranslate.y += fStep;
                break;
            case 36:
                vTranslate.y -= fStep;
                break;
            }

            MK_EFFECT_UpdateEffect(oTarget, MK_VFX_GetCurrentVFX(), oPC,
                MK_EFFECT_GetScale(e),
                vTranslate,
                MK_EFFECT_GetRotate(e));

            break;
        }
        case 39:
        {
            // reset
            int nVFX = MK_VFX_GetCurrentVFX();
            if (nVFX!=-1)
            {
                MK_EFFECT_UpdateEffect(oTarget, nVFX, oPC,
                    1.0f,
                    [0.0, 0.0, 0.0],
                    [0.0, 0.0, 0.0]);
//                MK_VFX_RemoveVFX(oPC, nVFX);
//                MK_VFX_ApplyVFX(oPC, nVFX);
            }
            break;
        }
        case 255:
            MK_GenericDialog_SetState(nState = MK_STATE_VFX_SELECT_EFFECT);
            MK_DEBUG_TRACE("Edit effect (back): nState="+IntToString(nState));
            break;
        }
        break;
    default:
        MK_GenericDialog_SetState(nState = MK_STATE_VFX_INIT_FILTER);
        MK_VFX_Initialize(oPC);
        break;
    }

    switch (nState)
    {
    case MK_STATE_VFX_INIT_FILTER:
        MK_2DA_DISPLAY_Initialize(MK_VFX_Get_VFXModeFile(oPC), "", "LABEL", "STRREF", "NAME", 10, "mk_cb_vfx_filter");
        MK_2DA_DISPLAY_SetPageLength(10);
        MK_GenericDialog_SetState(nState = MK_STATE_VFX_SELECT_FILTER);
        break;
    }

    nCurrentPage = MK_2DA_DISPLAY_GetCurrentPage();

    switch (nState)
    {
    case MK_STATE_VFX_SELECT_FILTER:
        MK_2DA_DISPLAY_DisplayPage(nCurrentPage, -1, "", FALSE);
        MK_DELIMITER_Initialize();
        SetCustomToken(14433, MK_VFX_Get_VFXModeFile(oPC));
        break;
    case MK_STATE_VFX_SELECT_EFFECT:
    {
        MK_2DA_DISPLAY_DisplayPage(nCurrentPage, MK_VFX_GetCurrentRow(), "mk_cb_vfx_label", FALSE);

        nVFXMode = MK_VFX_GetVFXMode(oPC);
        string sWarning="";
        int nStrRef = (MK_Get2DAInt(MK_VFX_Get_VFXModeFile(oPC), "MESSAGE", nVFXMode, 0));
        if (nStrRef!=0)
        {
            sWarning = " "+MK_TLK_GetStringByStrRef(nStrRef);
        }
        SetCustomToken(14430, sWarning);

        MK_GenericDialog_SetCondition(127, TRUE);

        int bAllowEditVFX = (MK_VFX_GetCurrentVFX()!=-1) && MK_VERSION_GetIsBuildVersionGreaterEqual(oPC, 8193, 14);

        MK_GenericDialog_SetCondition(40, bAllowEditVFX);

        MK_DELIMITER_Initialize();
        break;
    }
    case MK_STATE_VFX_EDIT_EFFECT:
    {
        string sRotate="";
        string sTranslate="";
        string sScale="";

        effect e = MK_EFFECT_GetCurrentEffect(oTarget);
        if (GetIsEffectValid(e))
        {
            float fScale = MK_EFFECT_GetScale(e);
            sScale = FloatToString(fScale, 7, 3);

            vector vTranslate = MK_EFFECT_GetTranslate(e);
            sTranslate = "("+FloatToString(vTranslate.x,7,3)+
                FloatToString(vTranslate.y, 7, 3)+
                FloatToString(vTranslate.z, 7, 3)+")";

            vector vRotate = MK_EFFECT_GetRotate(e);
            sRotate = "("+FloatToString(vRotate.x,7,3)+
                FloatToString(vRotate.y, 7, 3)+
                FloatToString(vRotate.z, 7, 3)+")";
        }
        else
        {
            sScale = GetLocalString(oPC, MK_EFFECT_SCALE);
            sTranslate = GetLocalString(oPC, MK_EFFECT_TRANSLATE);
            sRotate = GetLocalString(oPC, MK_EFFECT_ROTATE);
        }

        SetCustomToken(14499, sScale);
        SetCustomToken(14498, sTranslate);
        SetCustomToken(14497, sRotate);
        SetCustomToken(14496, IntToString(MK_VFX_GetCurrentVFX()));
        MK_DEBUG_TRACE("Edit effect: nState="+IntToString(nState));
        break;
    }
    }

    MK_DEBUG_TRACE("mk_pre_vfx (out): nState="+IntToString(nState));

    return TRUE;
}
