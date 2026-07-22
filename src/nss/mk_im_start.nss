#include "mk_inc_craft"
#include "mk_inc_generic"
#include "mk_inc_ccoh_db"
#include "mk_inc_states"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oTarget = MK_GetCurrentTarget(oPC);
    object oItem;

    MK_CCOH_DB_Init(oPC);

    int nAction = MK_GenericDialog_GetAction(TRUE);
    int nState = MK_GenericDialog_GetState();

    switch (nState)
    {
    case MK_STATE_DATABASE_3:
        MK_DEBUG_TRACE("mk_im_start: GetState=MK_STATE_DATABASE_3");
        switch (nAction)
        {
        case 250:
        {
            int nSelectedIASStrTypes = MK_CCOH_DB_GetSelectedIASStrTypes(oPC);
            switch (MK_CCOH_DB_GetReadWriteMode(oPC))
            {
            case MK_CCOH_DB_READ:
                switch (CIGetCurrentModMode(oPC))
                {
                case X2_CI_MODMODE_ARMOR:
                case X2_CI_MODMODE_WEAPON:
                case MK_CI_MODMODE_CLOAK:
                case MK_CI_MODMODE_HELMET:
                case MK_CI_MODMODE_SHIELD:
                {
                    oItem = CIGetCurrentModItem(oPC);

                    object oItemQ = MK_CCOH_DB_ReadItemAppearanceFromDatabase(
                        oPC, oItem,
                        MK_CCOH_DB_GetCurrentSlot(oPC),
                        nSelectedIASStrTypes);
                    if (GetIsObjectValid(oItemQ))
                    {
                        DestroyObject(oItem);
                        oItem = oItemQ;
                        CISetCurrentModItem(oPC, oItem);
                        MK_EquipModifiedItem(oTarget, oPC);
                        SendMessageToPC(oPC, "Appearance read from database!");
                    }
                    else
                    {
                        SendMessageToPC(oPC, "Failed to read appearance from database!");
                    }
                }
//                case MK_CI_MODMODE_BODY:
//                    break;
                }
                break;
            case MK_CCOH_DB_WRITE:
                switch (CIGetCurrentModMode(oPC))
                {
                case X2_CI_MODMODE_ARMOR:
                case X2_CI_MODMODE_WEAPON:
                case MK_CI_MODMODE_CLOAK:
                case MK_CI_MODMODE_HELMET:
                case MK_CI_MODMODE_SHIELD:
                    oItem = CIGetCurrentModItem(oPC);
                    if (MK_CCOH_DB_WriteItemAppearanceToDatabase(
                    oPC, oItem,
                    MK_CCOH_DB_GetCurrentSlot(oPC),
                    nSelectedIASStrTypes,
                    MK_CCOH_DB_GetCurrentSlotName(oPC)))
                    {
                        SendMessageToPC(oPC, "Appearance written to database!");
                    }
                    else
                    {
                        SendMessageToPC(oPC, "Failed to write appearance to database!");
                    }
                    break;
//                case MK_CI_MODMODE_BODY:
//                    break;
                }
                break;
            }
            break;
        }
        }
        nState = MK_STATE_INIT;
        MK_GenericDialog_SetState(nState);
        break;
    case MK_STATE_DATABASE_1:
        MK_DEBUG_TRACE("mk_im_start: GetState=MK_STATE_DATABASE_1");
        oItem = CIGetCurrentModItem(oPC);
        nState = MK_STATE_INIT;
        MK_GenericDialog_SetState(nState);
        break;
    case MK_STATE_INIT:
        MK_DEBUG_TRACE("mk_im_start: GetState=MK_STATE_INIT");
        switch (nAction)
        {
        case X2_CI_MODMODE_ARMOR:
        case X2_CI_MODMODE_WEAPON:
        case MK_CI_MODMODE_CLOAK:
        case MK_CI_MODMODE_HELMET:
        case MK_CI_MODMODE_SHIELD:
            StoreCameraFacing();
            CISetCurrentModMode(oPC, nAction);
            MK_SetCurrentModPart(oPC, -1);
            oItem = GetItemInSlot(MK_GetCurrentInventorySlot(oPC), oTarget);
            // Make backup, make mirror item, call CISetCurrentModItem(), ...
            MK_StartModifyItem(oPC, oItem, TRUE);
            // Add light effect and immobilize player
            MK_AddTemporaryEffects(oPC, MK_TAG_TEMP_EFFECT, TRUE, oTarget);
            break;
        default:
            return FALSE;
        }
        break;
    }

    float fFacing = GetFacing(oPC);
    float fDistance = 3.5f;
    float fPitch = 75.0f;

    switch (CIGetCurrentModMode(oPC))
    {
    case X2_CI_MODMODE_ARMOR:
        fFacing += 180.0;
        break;
    case X2_CI_MODMODE_WEAPON:
        fFacing += 90.0;
        break;
    case MK_CI_MODMODE_CLOAK:
        fFacing += 315.0;
        break;
    case MK_CI_MODMODE_HELMET:
        fFacing += 180.0;
        break;
    case MK_CI_MODMODE_SHIELD:
        fFacing += 270.0;
        break;
    }

    if (fFacing > 359.0)
    {
        fFacing -=359.0;
    }
    SetCameraFacing(fFacing, fDistance, fPitch, CAMERA_TRANSITION_TYPE_FAST);

//    int nSlot = MK_GetCurrentInventorySlot(oPC);
//    object oItem = GetItemInSlot(nSlot, oPC);

    if (CIGetCurrentModMode(oPC) == MK_CI_MODMODE_CLOAK)
    {
        MK_GenericDialog_SetCondition(7, MK_VERSION_GetIsVersionGreaterEqual_1_69(oPC));
    }

    MK_GenericDialog_SetCondition(21, GetLocalInt(oPC, "MK_DISABLE_SAVE_ITEM_APPEARANCE")!=1);

    int bDisableTextEditor = (MK_VERSION_GetIsVersionLower_1_69(oPC) && (GetLocalInt(oPC, "MK_DISABLE_TEXT_EDITOR") == 1));
    MK_GenericDialog_SetCondition(22, !bDisableTextEditor && GetLocalInt(oPC, "MK_ENABLE_RENAME_ITEMS"));
    MK_GenericDialog_SetCondition(23, !bDisableTextEditor && GetLocalInt(oPC, "MK_ENABLE_EDIT_DESCRIPTION"));
    MK_GenericDialog_SetCondition(24, !MK_GetHiddenWhenEquipped(oItem));

    MK_SetCustomTokenByItemTypeName(oTarget, oPC);

//    MK_VerifyCurrentModItem(oPC, "mk_im_start(end)");

    return TRUE;
}
