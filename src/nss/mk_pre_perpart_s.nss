#include "mk_inc_generic"
#include "x2_inc_craft"
#include "mk_inc_iaam"
#include "mk_inc_craft"
#include "mk_inc_states"

/*
int IsVisible(object oItem, int nModel, int nRobe)
{
    int nPartCount = MK_IAAM_GetPartCount(nModel);
    int i;

    int nHiddenByRobeCount=0;
    int nEmptyAppearanceCount=0;

    for (i=0; (i<nPartCount); i++)
    {
        int iPart = MK_IAAM_GetPart(nModel, i);
        if ((nRobe!=0) && (!MK_IsBodyPartVisible(nRobe, iPart)))
        {
            nHiddenByRobeCount++;
        }
        else
        {
            int nAppearance = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, iPart);
            if ((nAppearance==0) || ((nAppearance==1) &&
                (iPart!=ITEM_APPR_ARMOR_MODEL_TORSO) && (iPart!=ITEM_APPR_ARMOR_MODEL_PELVIS)))
            {
                nEmptyAppearanceCount++;
            }
        }
    }
    int nVisible;

    if (nHiddenByRobeCount>0)
    {
        nVisible=FALSE;
    }
    else
    {
        switch (nPartCount)
        {
        case 1:
        case 2:
            nVisible = (nEmptyAppearanceCount==0);
            break;
        case 3:
        case 4:
        case 5:
        case 6:
            nVisible = (nEmptyAppearanceCount<=2);
            break;
        default:
            nVisible = (nEmptyAppearanceCount<=4);
            break;
        }
    }
    MK_DEBUG_TRACE("IsVisible: nModel="+IntToString(nModel)+", nRobe="+IntToString(nRobe)+", nPartCount="+IntToString(nPartCount)+
        ", nHiddenByRobeCount="+IntToString(nHiddenByRobeCount)+", nEmptyAppearanceCount="+IntToString(nEmptyAppearanceCount)+", nVisible="+IntToString(nVisible));

    return nVisible;
}
*/

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oItem = CIGetCurrentModItem(oPC);

    MK_GenericDialog_SetState(MK_STATE_SELECTPART);

//    int nDisableEEFeatures = MK_INIT_GetAreEEFeaturesDisabled();
    int nVisible = !MK_GetHiddenWhenEquipped(oItem);

    int nRobe = GetItemAppearance(oItem,ITEM_APPR_TYPE_ARMOR_MODEL,ITEM_APPR_ARMOR_MODEL_ROBE);

    int iItemAppr;
    int nValid;
    for (iItemAppr=0; iItemAppr<MK_ITEM_APPR_ARMOR_NUM_MODELS; iItemAppr++)
    {
        nValid = nVisible && MK_IAAM_GetIsValid(iItemAppr) && MK_IAAM_GetIsValidForColorModify(iItemAppr)
            &&  ((nRobe == 0) || (MK_IAAM_GetIsHiddenByRobe(iItemAppr, nRobe, TRUE) < 100))
            && (MK_IAAM_GetArmorAppearanceIsNull(iItemAppr, oItem, TRUE) < 100);
        MK_GenericDialog_SetCondition(iItemAppr, nValid);
    }
    return TRUE;
}
