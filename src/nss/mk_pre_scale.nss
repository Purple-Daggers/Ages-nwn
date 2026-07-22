#include "mk_inc_generic"
#include "mk_inc_states"
#include "mk_inc_craft"
#include "mk_inc_tools_s"
#include "mk_inc_ccoh_db"
#include "mk_inc_scale"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oTarget = MK_GetCurrentTarget(oPC);

    MK_CCOH_DB_Init(oPC);

    int nState = MK_GenericDialog_GetState();
    int nAction = MK_GenericDialog_GetAction();

    float fScaleFactor = MK_SCALE_GetScaleFactor(oTarget);

    switch (nState)
    {
    case MK_STATE_SCALE:
        switch (nAction)
        {
        case 249:
            fScaleFactor=1.0;
            break;
        case 250:
            fScaleFactor+=0.1;
            break;
        case 251:
            fScaleFactor+=0.01;
            break;
        case 252:
            fScaleFactor-=0.01;
            break;
        case 253:
            fScaleFactor-=0.1;
            break;
        }

        if (MK_SCALE_GetIsScaleFactorValid(fScaleFactor))
        {
            MK_SCALE_SetScaleFactor(oTarget, fScaleFactor);
        }

        break;
    default:
        nState = MK_STATE_SCALE;
        MK_GenericDialog_SetState(nState);
        CISetCurrentModMode(oPC, MK_CI_MODMODE_BODY);
        MK_SetBodyPartToBeModified(oPC, MK_CRAFTBODY_SCALE, TRUE);

        break;
    }


    switch (nState)
    {
    case MK_STATE_SCALE:
    {
        fScaleFactor = MK_SCALE_GetScaleFactor(oTarget);
//        GetObjectVisualTransform(oTarget, OBJECT_VISUAL_TRANSFORM_SCALE);

        MK_SCALE_DisplayScaleOption(250, -94, 14402, MK_SCALE_GetIsScaleFactorValid(fScaleFactor+0.1));
        MK_SCALE_DisplayScaleOption(251, -95, 14403, MK_SCALE_GetIsScaleFactorValid(fScaleFactor+0.01));
        MK_SCALE_DisplayScaleOption(252, -96, 14404, MK_SCALE_GetIsScaleFactorValid(fScaleFactor-0.01));
        MK_SCALE_DisplayScaleOption(253, -97, 14405, MK_SCALE_GetIsScaleFactorValid(fScaleFactor-0.1));
        MK_SCALE_DisplayScaleOption(249, -98, 14406, (fabs(fScaleFactor-1.0)>0.001) );

        MK_GenericDialog_SetCondition(254, MK_CCOH_DB_GetIsBodyChanged(oTarget));

        SetCustomToken(14423, MK_TrimString(FloatToString(fScaleFactor,10,2)));
        break;
    }
    }

    return TRUE;
}
