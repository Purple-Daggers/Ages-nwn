#include "mk_inc_generic"
#include "mk_inc_craft"
#include "mk_inc_body"
#include "mk_inc_ccoh_db"
#include "mk_inc_states"
#include "mk_inc_delimiter"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oTarget = MK_GetCurrentTarget(oPC);
    object oItem = CIGetCurrentModItem(oPC);

    MK_CCOH_DB_Init(oPC);

    MK_DELIMITER_Initialize();

    int nState = MK_GenericDialog_GetState();
    int nAction = MK_GenericDialog_GetAction();

//    MK_DEBUG_TRACE("mk_pre_db_item: nState="+IntToString(nState)+", nAction="+IntToString(nAction));

    switch (nState)
    {
    case MK_STATE_INIT:
        // We've just selected "Save/Restore" (coming from modify an item)
        MK_GenericDialog_SetState(MK_STATE_DATABASE_1);
        break;
    case MK_STATE_BODY_SELECT:
        // We've just selected "Save/Restore" (coming from modify body)
        MK_GenericDialog_SetState(MK_STATE_DATABASE_1);
        // So the cancel script restores the body
        CISetCurrentModMode(oPC, MK_CI_MODMODE_BODY);
        MK_SetBodyPartToBeModified(oPC, nAction);
//        MK_SaveBody(oPC, 0);
        break;
    case MK_STATE_DATABASE_1:
        // We've choosen to read from local/global or to write to local/global
        switch (nAction)
        {
        case 10: // save to database
        case 12:
//            MK_CCOH_DB_SetDatabaseName(oPC, "");
            MK_CCOH_DB_SetReadWriteMode(oPC, MK_CCOH_DB_WRITE);
            MK_GenericDialog_SetState(MK_STATE_DATABASE_2);
            break;
        case 11: // read from database
        case 13:
//            MK_CCOH_DB_SetDatabaseName(oPC, "");
            MK_CCOH_DB_SetReadWriteMode(oPC, MK_CCOH_DB_READ);
            MK_GenericDialog_SetState(MK_STATE_DATABASE_2);
            break;
        case 15: // database administration
            MK_CCOH_DB_SetReadWriteMode(oPC, MK_CCOH_DB_ADMIN);
            MK_GenericDialog_SetState(MK_STATE_DATABASE_2);
            break;
/*        case 12: // save to global
            MK_CCOH_DB_SetDatabaseName(oPC, MK_CCOH_DB_DATABASE_NAME);
            MK_CCOH_DB_SetReadWriteMode(oPC, MK_CCOH_DB_WRITE);
            MK_GenericDialog_SetState(MK_STATE_DATABASE_2);
            break;
        case 13: // read from global
            MK_CCOH_DB_SetDatabaseName(oPC, MK_CCOH_DB_DATABASE_NAME);
            MK_CCOH_DB_SetReadWriteMode(oPC, MK_CCOH_DB_READ);
            MK_GenericDialog_SetState(MK_STATE_DATABASE_2);
            break;*/
        }
        break;
    case MK_STATE_DATABASE_2:
        // We've just choosen the slot number
        if ((nAction>=1) && (nAction<=30))
        {
            MK_CCOH_DB_SetCurrentSlot(oPC, nAction);
            string sSlotName;
            if (MK_CCOH_DB_GetIsSlotUsed(oPC, nAction))
            {
                sSlotName = MK_CCOH_DB_CreateSlotName(oPC, nAction, FALSE);
            }
            else
            {
                switch (CIGetCurrentModMode(oPC))
                {
                case MK_CI_MODMODE_BODY:
                    sSlotName = GetName(oTarget);
                    break;
                default:
                    sSlotName = GetName(oItem);
                    break;
                }
            }
            MK_CCOH_DB_SetCurrentSlotName(oPC, sSlotName);

            int nValidIASStrTypes;
            switch (MK_CCOH_DB_GetReadWriteMode(oPC))
            {
            case MK_CCOH_DB_READ:
                nValidIASStrTypes = MK_CCOH_DB_GetIASStrTypesFromSlot(oPC, nAction);
                break;
            case MK_CCOH_DB_WRITE:
                switch (CIGetCurrentModMode(oPC))
                {
                case X2_CI_MODMODE_ARMOR:
                case MK_CI_MODMODE_CLOAK:
                case MK_CI_MODMODE_HELMET:
                    nValidIASStrTypes = MK_CCOH_DB_ITEM_APPR_MODEL | MK_CCOH_DB_ITEM_APPR_COLOR;
                    break;
                case X2_CI_MODMODE_WEAPON:
                case MK_CI_MODMODE_SHIELD:
                    nValidIASStrTypes = MK_CCOH_DB_ITEM_APPR_MODEL;
                    break;
                case MK_CI_MODMODE_BODY:
                    nValidIASStrTypes = MK_CCOH_DB_BODY_APPR_HEAD | MK_CCOH_DB_BODY_APPR_TAIL
                        | MK_CCOH_DB_BODY_APPR_WINGS | MK_CCOH_DB_BODY_APPR_PHENO
                        | MK_CCOH_DB_BODY_APPR_PORTRAIT | MK_CCOH_DB_BODY_APPR_BODY
                        | MK_CCOH_DB_BODY_APPR_COLOR | MK_CCOH_DB_BODY_APPR_TYPE
                        | MK_CCOH_DB_BODY_APPR_SCALE;
                    break;
                }
                break;
            }
            MK_CCOH_DB_SetValidIASStrTypes(oPC, nValidIASStrTypes);
            MK_CCOH_DB_SetSelectedIASStrTypes(oPC, nValidIASStrTypes);

            MK_GenericDialog_SetState(MK_STATE_DATABASE_3);
        }
        else if (nAction == 255)
        {
            MK_GenericDialog_SetState(MK_STATE_DATABASE_1);
        }
        break;
    case MK_STATE_DATABASE_3:
        // We've just choosen what to read or write (model, color or both)
        switch (nAction)
        {
        case 18:
            switch (CIGetCurrentModMode(oPC))
            {
            case X2_CI_MODMODE_ARMOR:
            case X2_CI_MODMODE_WEAPON:
            case MK_CI_MODMODE_CLOAK:
            case MK_CI_MODMODE_HELMET:
            case MK_CI_MODMODE_SHIELD:
                MK_CCOH_DB_SetCurrentSlotName(oPC, GetName(oItem));
                break;
            case MK_CI_MODMODE_BODY:
                MK_CCOH_DB_SetCurrentSlotName(oPC, GetName(oTarget));
                break;
            }
            break;
        case 20:
//            SendMessageToPC(oPC, "Delete selected slot!");
            MK_CCOH_DB_DeleteCurrentSlot(oPC);
            MK_GenericDialog_SetState(MK_STATE_DATABASE_2);
            break;
        case 100:
        {
            // Editor: OK
            string sSlotName = MK_TrimString(GetLocalString(oPC, g_varEditorBuffer));
            MK_CCOH_DB_SetCurrentSlotName(oPC, sSlotName);
            MK_Editor_CleanUp(oPC);
            break;
        }
        case 101:
            // Editor: Cancel
            MK_Editor_CleanUp(oPC);
            break;
        case 255:
            MK_CCOH_DB_SetCurrentSlot(oPC, -1);
            MK_CCOH_DB_SetCurrentSlotName(oPC, "");
            MK_GenericDialog_SetState(MK_STATE_DATABASE_2);
            break;
        default:
            if ((nAction>=0) && (nAction<=15))
            {
                MK_CCOH_DB_ToggleSelectedIASStrType(oPC, nAction);
            }
            break;
        }
        break;
    default:
        break;
    }

    int bOk;

    nState = MK_GenericDialog_GetState();

//    MK_DEBUG_TRACE("mk_pre_db_item(2): nState="+IntToString(nState)+
//       ", nCurrentModMode="+IntToString(CIGetCurrentModMode(oPC)));

    int iCondition;

    switch (nState)
    {
    case MK_STATE_DATABASE_1:
    {
        // We're about to choose what to do: read/write, local/global
        bOk = MK_CCOH_DB_GetUseLocalDb(oPC);
        MK_GenericDialog_SetCondition(10, bOk);
        MK_GenericDialog_SetCondition(11, bOk);
        MK_GenericDialog_SetCondition(12, !bOk);
        MK_GenericDialog_SetCondition(13, !bOk);
        MK_GenericDialog_SetCondition(15, TRUE);
        int nMode = CIGetCurrentModMode(oPC);
        for (iCondition=1; iCondition<=5; iCondition++)
        {
            MK_GenericDialog_SetCondition(iCondition, nMode == iCondition);
        }
        MK_GenericDialog_SetCondition(127, (nMode == MK_CI_MODMODE_BODY));
        break;
    }
    case MK_STATE_DATABASE_2:
    {
        // We're about to choose the slot number
        int nReadWriteMode = MK_CCOH_DB_GetReadWriteMode(oPC);
        int nEmptySlots = 0;
        int nMaxEmptySlots = 1;
        int bIsEmpty;
        for (iCondition=1; iCondition<=30; iCondition++)
        {
            switch (nReadWriteMode)
            {
            case MK_CCOH_DB_READ:
                bOk = MK_CCOH_DB_GetIsSlotValid(oPC, iCondition, oItem);
                break;
            case MK_CCOH_DB_WRITE:
            {
                bOk = TRUE;
                if (!MK_CCOH_DB_GetIsSlotUsed(oPC, iCondition) && (nMaxEmptySlots < ++nEmptySlots))
                {
                    bOk = FALSE;
                }
                break;
            }
            case MK_CCOH_DB_ADMIN:
                bOk = MK_CCOH_DB_GetIsSlotUsed(oPC, iCondition);
                break;
            default:
                bOk = FALSE;
                break;
            }
            if (bOk)
            {
                string sSlotName = MK_CCOH_DB_CreateSlotName(oPC, iCondition, TRUE);
                SetCustomToken(14439+iCondition, sSlotName);
            }
            MK_GenericDialog_SetCondition(iCondition, bOk);
        }
        break;
    }
    case MK_STATE_DATABASE_3:
    {
        // We're about to choose what to read or write (model, color or both)
        int nSlot = MK_CCOH_DB_GetCurrentSlot(oPC);
        SetCustomToken(14430, (nSlot!=-1 ? MK_CCOH_DB_GetCurrentSlotName(oPC) + " ("+IntToString(nSlot)+")" : GetStringByStrRef(53185)) );

        int nCurrentModMode = CIGetCurrentModMode(oPC);

        int nValidIASStrTypes = MK_CCOH_DB_GetValidIASStrTypes(oPC);
        int nSelectedIASStrTypes = MK_CCOH_DB_GetSelectedIASStrTypes(oPC);

        MK_DEBUG_TRACE("mk_pre_db_item: nValidIASStrTypes="+IntToString(nValidIASStrTypes)+
            ", nSelectedIASStrTypes="+IntToString(nSelectedIASStrTypes));

        int iCondition;
        int nApprFlag = 1;
        int nCount=0;
        for (iCondition=0; iCondition<=15; iCondition++)
        {
            bOk = (nValidIASStrTypes & nApprFlag);
            SetCustomToken(14440+iCondition,
                ( nSelectedIASStrTypes & nApprFlag ? "[X] " : "[<c   >_</c>] ")
                + MK_CCOH_DB_GetIASStrTypeName(nCurrentModMode, iCondition+1));
            MK_GenericDialog_SetCondition(iCondition, bOk);
            if (bOk) nCount++;

            nApprFlag*=2;
        }

        string sText1="";
        string sText2="";
        switch (MK_CCOH_DB_GetReadWriteMode(oPC))
        {
        case MK_CCOH_DB_READ:
            sText1 = MK_TLK_GetStringByStrRef(-79);
            sText2 = MK_TLK_GetStringByStrRef(-91);

            MK_GenericDialog_SetCondition(18,FALSE);
            MK_GenericDialog_SetCondition(19,FALSE);

            MK_GenericDialog_SetCondition(20, FALSE);

            break;
        case MK_CCOH_DB_WRITE:
        {
            sText1 = MK_TLK_GetStringByStrRef(-78);
            sText2 = MK_TLK_GetStringByStrRef(-92);

            string sText18;
            int bEnable18;
            switch (nCurrentModMode)
            {
            case MK_CI_MODMODE_BODY:
                sText18 = GetName(oTarget);
                bEnable18 = (sText18!=MK_CCOH_DB_GetCurrentSlotName(oPC));
                break;
            default:
                sText18 = GetName(oItem);
                bEnable18 = (sText18!=MK_CCOH_DB_GetCurrentSlotName(oPC));
                break;
            }
            SetCustomToken(14431, sText18);
            MK_GenericDialog_SetCondition(18, bEnable18);

            MK_GenericDialog_SetCondition(19,
                MK_VERSION_GetIsVersionGreaterEqual_1_69(oPC) && (GetLocalInt(oPC, "MK_DISABLE_TEXT_EDITOR")!=1));

            MK_GenericDialog_SetCondition(20, FALSE);

            // In case the editor gets started
            int bUseChatEvent = GetLocalInt(oPC, "MK_EDITOR_USE_CHAT_EVENT");
            SetLocalString(oPC, g_varEditorText, MK_CCOH_DB_GetCurrentSlotName(oPC));

//            MK_DEBUG_TRACE("MK_PrepeareEditor()");
            MK_PrepareEditor(oPC, 3, 24, 25, "Edit slot name:",
                30,
                TRUE, FALSE, bUseChatEvent);
//            MK_GenericDialog_SetCondition(100, FALSE);
//            MK_GenericDialog_SetCondition(101, FALSE);
//            MK_GenericDialog_SetCondition(102, TRUE);
//            MK_GenericDialog_SetCondition(103, FALSE);
            break;
        }
        case MK_CCOH_DB_ADMIN:
            MK_GenericDialog_SetCondition(19, nSlot!=-1);
            MK_GenericDialog_SetCondition(20, nSlot!=-1);

            // In case the editor gets started
            int bUseChatEvent = GetLocalInt(oPC, "MK_EDITOR_USE_CHAT_EVENT");
            SetLocalString(oPC, g_varEditorText, MK_CCOH_DB_GetCurrentSlotName(oPC));

//            MK_DEBUG_TRACE("MK_PrepeareEditor()");
            MK_PrepareEditor(oPC, 3, 24, 25, "Edit slot name:",
                30,
                TRUE, FALSE, bUseChatEvent);
//            MK_GenericDialog_SetCondition(100, FALSE);
//            MK_GenericDialog_SetCondition(101, FALSE);
//            MK_GenericDialog_SetCondition(102, TRUE);
//            MK_GenericDialog_SetCondition(103, FALSE);

            break;
        }

//        MK_DEBUG_TRACE("SetCustomToken(14460, "+sText1+")");
        SetCustomToken(14460, sText1);
        SetCustomToken(14461, sText2);

        MK_GenericDialog_SetCondition(21, nSelectedIASStrTypes && (nCurrentModMode == X2_CI_MODMODE_ARMOR));
        MK_GenericDialog_SetCondition(22, nSelectedIASStrTypes && (nCurrentModMode == X2_CI_MODMODE_WEAPON));
        MK_GenericDialog_SetCondition(23, nSelectedIASStrTypes && (nCurrentModMode == MK_CI_MODMODE_CLOAK));
        MK_GenericDialog_SetCondition(24, nSelectedIASStrTypes && (nCurrentModMode == MK_CI_MODMODE_HELMET));
        MK_GenericDialog_SetCondition(25, nSelectedIASStrTypes && (nCurrentModMode == MK_CI_MODMODE_SHIELD));
        MK_GenericDialog_SetCondition(29, nSelectedIASStrTypes && (nCurrentModMode == MK_CI_MODMODE_BODY));

        MK_DELIMITER_Initialize(nCount>0);

        break;
    }
    }

    return TRUE;
}
