#include "mk_inc_generic"

#include "mk_inc_body"
#include "mk_inc_craft"
#include "mk_inc_ccoh_db"
#include "mk_inc_states"
#include "mk_inc_horse"
#include "mk_inc_delimiter"

int GetIsCraftingDisabled(object oPC, int i)
{
    string sVarName = "MK_DISABLE_CRAFT_" + MK_IntToString(i, 2, "0");
    return (GetLocalInt(oPC, sVarName)==1);
}

int StartingConditional()
{
    object oPC = GetPCSpeaker();

    MK_CCOH_DB_Init(oPC);

    int nState = MK_GenericDialog_GetState();

    int nAction = MK_GenericDialog_GetAction();

    object oTarget = MK_GetCurrentTarget(oPC);

    int nBodyPartToBeModified = MK_GetBodyPartToBeModified(oPC);
    MK_DEBUG_TRACE("mk_pre_body: nState="+IntToString(nState)+", nAction="+IntToString(nAction));

    switch (nState)
    {
    case MK_STATE_INIT:
        switch (nAction)
        {
        case MK_CRAFTBODY_HORSE:
            // Riding
            StoreCameraFacing();
            nState = MK_STATE_BODY_MODIFY;
            CISetCurrentModMode(oPC, MK_CI_MODMODE_BODY);
            MK_SetBodyPartToBeModified(oPC, nAction, TRUE);
//            MK_SaveBodyPart(oPC);
            MK_InitializeHorseSelection(oTarget);
            MK_AddTemporaryEffects(oPC, MK_TAG_TEMP_EFFECT, FALSE, oTarget);
            break;
        default:
            StoreCameraFacing();
            nState = MK_STATE_BODY_SELECT;
            break;
        }
        MK_CCOH_DB_SaveBody(oTarget);
//        MK_SaveBody(oPC, 0);
        MK_GenericDialog_SetState(nState);
        break;
    case MK_STATE_VFX_SELECT_FILTER:
//        if (nAction==255)
        MK_GenericDialog_SetState(nState = MK_STATE_BODY_SELECT);
        break;
    case MK_STATE_DATABASE_1:
        MK_GenericDialog_SetState(nState = MK_STATE_BODY_SELECT);
        break;
    case MK_STATE_DATABASE_3:
        switch (nAction)
        {
        case 250:
        {
            int nSelectedIASStrTypes = MK_CCOH_DB_GetSelectedIASStrTypes(oPC);
            MK_DEBUG_TRACE("> nIASStrTypes="+IntToString(nSelectedIASStrTypes)+
                ", RWmode="+IntToString(MK_CCOH_DB_GetReadWriteMode(oPC)));
            switch (MK_CCOH_DB_GetReadWriteMode(oPC))
            {
            case MK_CCOH_DB_READ:
                switch (CIGetCurrentModMode(oPC))
                {
                case MK_CI_MODMODE_BODY:
                    if (MK_CCOH_DB_ReadBodyAppearanceFromDatabase(
                        oPC, oTarget,
                        MK_CCOH_DB_GetCurrentSlot(oPC),
                        nSelectedIASStrTypes))
                    {
                        SendMessageToPC(oPC, "Appearance read from database!");
                    }
                    else
                    {
                        SendMessageToPC(oPC, "Failed to read appearance from database!");
                    }
                    break;
                }
                break;
            case MK_CCOH_DB_WRITE:
                switch (CIGetCurrentModMode(oPC))
                {
                case MK_CI_MODMODE_BODY:
                    if (MK_CCOH_DB_WriteBodyAppearanceToDatabase(
                        oPC, oTarget,
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
                }
                break;
            }
            break;
        }
        }
        nState = MK_STATE_BODY_SELECT;
        MK_GenericDialog_SetState(nState);
        break;
    case MK_STATE_BODY_SELECT:
        if ((nAction>0) && (nAction<=MK_CRAFTBODY_NUMBER_OF_BODYPARTS))
        {
            // So the finish/cancel scripts work properly
            CISetCurrentModMode(oPC, MK_CI_MODMODE_BODY);

            MK_SetBodyPartToBeModified(oPC, nAction, TRUE);
//            MK_SaveBodyPart(oPC);

            switch (nAction)
            {
            case MK_CRAFTBODY_BODY:
                MK_SetSubPartToBeModified(oPC, -1, FALSE);
                break;
            case MK_CRAFTBODY_COLOR:
                MK_SetSubPartToBeModified(oPC, -1, oPC==oTarget);
                break;
            }
            nState = MK_STATE_BODY_MODIFY;
            MK_GenericDialog_SetState(nState);
        }
/*        else if (nAction==MK_CRAFTBODY_SAVERESTORE)
        {
            // So the cancel script restores the body
            CISetCurrentModMode(oPC, MK_CI_MODMODE_BODY);
            MK_SetBodyPartToBeModified(oPC, nAction);
//            MK_SaveBody(oPC, 0);
        }*/
        else if (nAction!=255)
        {
            SendMessageToPC(oPC, "mk_pre_body: I think we shouldn't be here. Something went wrong?");
        }

        switch (MK_GetBodyPartToBeModified(oPC))
        {
//        case MK_CRAFTBODY_HORSE:
        case MK_CRAFTBODY_BODY:
        case MK_CRAFTBODY_COLOR:
        case MK_CRAFTBODY_PHENOTYPE:
        case MK_CRAFTBODY_HEAD:
        case MK_CRAFTBODY_TAIL:
        case MK_CRAFTBODY_WINGS:
//        case MK_CRAFTBODY_SCALE:
            MK_AddTemporaryEffects(oPC, MK_TAG_TEMP_EFFECT, FALSE, oTarget);
            break;
        }

        break;
    case MK_STATE_BODY_MODIFY:

        switch (nBodyPartToBeModified)
        {
        case MK_CRAFTBODY_PORTRAIT:
            if ((nAction>=1) && (nAction<=4))
            {
                MK_NewPortrait(oTarget, nAction, oPC);
                ClearAllActions();
                // So we have the proper portrait in the dialog as well
                ActionPauseConversation();
                ActionWait(GetLocalFloat(oPC, "MK_PORTRAIT_DELAY"));
                ActionResumeConversation();
            }
            break;
        case MK_CRAFTBODY_HEAD:
            switch (nAction)
            {
            case 1:
            case 2:
                MK_NewBodyPart(oTarget, nAction, oPC);
                break;
            case 20:
            case 21:
            case 22:
            case 23:
            case 24:
                SetLocalInt(oPC, MK_CRAFTBODY_HEAD_FILTER, (nAction-20));
                break;
            case 250:
                MK_SwapTattooColors(oTarget);
                break;
            }
            break;
        case MK_CRAFTBODY_PHENOTYPE:
        case MK_CRAFTBODY_TAIL:
        case MK_CRAFTBODY_WINGS:
            switch (nAction)
            {
            case 1:
            case 2:
            case 3:
                MK_NewBodyPart(oTarget, nAction, oPC);
                break;
            }
            break;
        case MK_CRAFTBODY_BODY:
        {
            int nCurrentSubPart = MK_GetSubPartToBeModified(oPC);
            if (nCurrentSubPart==-1)
            {
                nCurrentSubPart = nAction;
                nAction = -1;
                MK_SetSubPartToBeModified(oPC, nCurrentSubPart, (oPC==oTarget) && (nBodyPartToBeModified == MK_CRAFTBODY_BODY));
            }
            else if (nAction == -1)
            {
                nCurrentSubPart = -1;
                MK_SetSubPartToBeModified(oPC, nCurrentSubPart, (oPC==oTarget) && (nBodyPartToBeModified == MK_CRAFTBODY_BODY));
            }

            if ((nCurrentSubPart!=-1) && (nAction!=-1))
            {
                switch (nAction)
                {
                case 1:
                case 2:
                    MK_NewBodyPart(oTarget, nAction, oPC);
                    break;
                }
            }
            break;
        }
        case MK_CRAFTBODY_COLOR:
        {
            int nCurrentSubPart = MK_GetSubPartToBeModified(oPC);
            if ((nCurrentSubPart==-1) && (nAction==250))
            {
                MK_SwapTattooColors(oTarget);
            }
            else if (nCurrentSubPart==-1)
            {
                nCurrentSubPart = nAction;
                nAction = -1;
                MK_SetSubPartToBeModified(oPC, nCurrentSubPart, (oPC==oTarget) && (nBodyPartToBeModified == MK_CRAFTBODY_BODY));
            }
            else if (nAction == -1)
            {
                nCurrentSubPart = -1;
                MK_SetSubPartToBeModified(oPC, nCurrentSubPart, (oPC==oTarget) && (nBodyPartToBeModified == MK_CRAFTBODY_BODY));
            }

            if ((nCurrentSubPart!=-1) && (nAction!=-1))
            {
                switch (nAction)
                {
                case 1:
                case 2:
                    MK_NewBodyPart(oTarget, nAction, oPC);
                    break;
                }
            }
            break;
        }
        case MK_CRAFTBODY_HORSE:
        {
            int nHorse=-1;
            switch (nAction)
            {
            case 1:
            case 2:
                MK_NewBodyPart(oTarget, nAction, oPC);
                break;
            case 3:
                nHorse = GetLocalInt(oTarget, MK_VAR_CURRENT_HORSE);
                break;
            case 4:
                nHorse = MK_HORSE_1;
                break;
            case 5:
                nHorse = MK_HORSE_2;
                break;
            case 6:
                nHorse = MK_HORSE_3;
                break;
            case 7:
                nHorse = MK_HORSE_4;
                break;
            case 8:
                nHorse = MK_HORSE_5;
                break;
            case 20:
                nHorse = 0;
                break;
            }
            if (nHorse!=-1)
            {
                MK_CreatureMountHorse(oTarget,nHorse);
            }
            break;
        }
        }
        break;
    }

    switch (nState)
    {
    case MK_STATE_BODY_SELECT:
    {
//        MK_DEBUG_TRACE("mk_pre_body: state=MK_STATE_BODY_SELECT");
        int nPartBased = MK_GetIsPartBasedAppearanceType(oTarget);
        int iCondition;
        int bOk;
        string sVarName;
        for (iCondition=11; iCondition<=26; iCondition++)
        {
            bOk = (!GetIsCraftingDisabled(oPC, iCondition));
            switch (iCondition)
            {
            case 11: // portraits
                bOk = bOk && MK_VERSION_GetIsVersionGreaterEqual_1_67(oPC);
                break;
            case 12: // head
            case 14: // body parts
            case 15: // tail
            case 16: // wings
                bOk = bOk && nPartBased && MK_VERSION_GetIsVersionGreaterEqual_1_67(oPC);
                break;
            case 13: // pheno
                bOk = bOk && nPartBased && MK_VERSION_GetIsVersionGreaterEqual_1_64(oPC);
                break;
            case 17: // color
                bOk = bOk && nPartBased && MK_VERSION_GetIsVersionGreaterEqual_1_69(oPC);
                break;
            case 18: // not used
            case 20: // not used
                bOk = FALSE;
                break;
            case 21: // scale
//                bOk = bOk && MK_VERSION_GetIsVersionGreaterEqual_1_75(oPC);
                bOk = bOk && MK_VERSION_GetIsBuildVersionGreaterEqual(oPC, 8193, 21);
                break;
            case 23: // description
                bOk = bOk && MK_VERSION_GetIsVersionGreaterEqual_1_69(oPC) &&
                    //  (!GetIsCraftingDisabled(oPC, iCondition)) &&
                        (!MK_CCOH_DB_GetIsBodyChanged(oPC)) &&
                        (GetLocalInt(oPC, "MK_DISABLE_TEXT_EDITOR")!=1);
                break;
            case 25: // footstep type
                bOk = bOk && MK_VERSION_GetIsVersionGreaterEqual_1_66(oPC);
                break;
            case 26: // deity
                bOk = bOk && (oPC == oTarget);
                break;
//            default:
//                bOk = (!GetIsCraftingDisabled(oPC, iCondition));
//                break;
            }
            MK_GenericDialog_SetCondition(iCondition, bOk);
        }
        MK_GenericDialog_SetCondition(254, MK_CCOH_DB_GetIsBodyChanged(oPC));
        break;
    }
    case MK_STATE_BODY_MODIFY:
//        MK_DEBUG_TRACE("mk_pre_body: state=MK_STATE_BODY_MODIFY");

        MK_GenericDialog_SetCondition(254, MK_CCOH_DB_GetIsBodyChanged(oPC));
        MK_GenericDialog_SetCondition(255, FALSE);
        MK_GenericDialog_SetCondition(257, TRUE);

        switch (MK_GetBodyPartToBeModified(oPC))
        {
/*
        case MK_CRAFTBODY_SAVERESTORE:
        {
            int bUsedAny=FALSE;
            int nSlot;
            for (nSlot=1; nSlot<=MK_CRAFTBODY_NUMBER_OF_SLOTS; nSlot++)
            {
                int bUsed = MK_GetIsUsedSaveBodySlot(oPC, nSlot);
                bUsedAny = bUsedAny || bUsed;
                MK_GenericDialog_SetCondition(nSlot, !bUsed);
                MK_GenericDialog_SetCondition(10+nSlot, bUsed);
            }
            MK_GenericDialog_SetCondition(0, bUsedAny);
            MK_GenericDialog_SetCondition(22, !bIsModified);
            break;
        }
*/
        case MK_CRAFTBODY_HEAD:
        {
            MK_GenericDialog_SetCondition(17,
                MK_VERSION_GetIsVersionGreaterEqual_1_69(oPC) &&
                (!GetIsCraftingDisabled(oPC, 17)));

            int nCurrentFilter = GetLocalInt(oPC, MK_CRAFTBODY_HEAD_FILTER);
            int nUserFilter    = (GetLocalString(oPC, "MK_2DA_VALID_HEADS")!="");
            int nCEPFilter     = (MK_BODY_GetCEPHeadFilterExists(oPC));
            MK_GenericDialog_SetCondition(20, (nCurrentFilter!=0));
            MK_GenericDialog_SetCondition(21, (nCurrentFilter!=1));
            MK_GenericDialog_SetCondition(22, (nCurrentFilter!=2) && (nUserFilter) && (!nCEPFilter));
            MK_GenericDialog_SetCondition(23, (nCurrentFilter!=3) && (!nUserFilter) && (nCEPFilter));
            MK_GenericDialog_SetCondition(24, (nCurrentFilter!=4) && (nUserFilter) && (nCEPFilter));

            string sFilter="";
            switch (nCurrentFilter)
            {
            case 0:
                sFilter = "none";
                break;
            case 1:
                sFilter = "Bioware";
                break;
            case 2:
                sFilter = "User";
                break;
            case 3:
                sFilter = "CEP";
                break;
            case 4:
                sFilter = "User / CEP";
                break;
            }
            SetCustomToken(14433, sFilter);

            break;
        }
        case MK_CRAFTBODY_PORTRAIT:
        {
            int nMaxCustomId = MK_GetMaxPortraitId(oPC, TRUE);
            MK_GenericDialog_SetCondition(3,nMaxCustomId>0);
            MK_GenericDialog_SetCondition(4,nMaxCustomId>0);
            break;
        }
        case MK_CRAFTBODY_BODY:
        {
            int nBodyPart;
            for (nBodyPart=0; nBodyPart<=17; nBodyPart++)
            {
                int nMaxBodyPartID = MK_GetMaxBodyPartID(oPC, nBodyPart);
                MK_GenericDialog_SetCondition(nBodyPart, nMaxBodyPartID>0);
            }
            break;
        }
        case MK_CRAFTBODY_HORSE:
        {
//            MK_DEBUG_TRACE("mk_pre_body: part=MK_CRAFTBODY_HORSE");
            int bIsRiding = MK_GetIsRiding(oTarget);
            int nCurrentHorse = GetLocalInt(oTarget, MK_VAR_CURRENT_HORSE);
            int nHorse = GetCreatureTailType(oTarget);
//            MK_DEBUG_TRACE("bIsRiding="+IntToString(bIsRiding)+", nCurrentHorse="+IntToString(nCurrentHorse)+", nHorse="+IntToString(nHorse));
            MK_GenericDialog_SetCondition(1, bIsRiding);
            MK_GenericDialog_SetCondition(2, bIsRiding);
            MK_GenericDialog_SetCondition(3, (nCurrentHorse!=0) && (nHorse!=nCurrentHorse));
            MK_GenericDialog_SetCondition(4, (nCurrentHorse!=MK_HORSE_1) && (nHorse!=MK_HORSE_1));
            MK_GenericDialog_SetCondition(5, (nCurrentHorse!=MK_HORSE_2) && (nHorse!=MK_HORSE_2));
            MK_GenericDialog_SetCondition(6, (nCurrentHorse!=MK_HORSE_3) && (nHorse!=MK_HORSE_3));
            MK_GenericDialog_SetCondition(7, (nCurrentHorse!=MK_HORSE_4) && (nHorse!=MK_HORSE_4));
            MK_GenericDialog_SetCondition(8, (nCurrentHorse!=MK_HORSE_5) && (nHorse!=MK_HORSE_5));
            MK_GenericDialog_SetCondition(20, bIsRiding);
            MK_SetBodyPartTokens(oPC, oTarget);

            switch (MK_HORSE_GetHorseSystem(oPC))
            {
            case MK_HORSE_BIOWARE_HORSE_SYSTEM:
                MK_GenericDialog_SetCondition(254, FALSE);
                MK_GenericDialog_SetCondition(255, TRUE);
                MK_GenericDialog_SetCondition(257, FALSE);
                SetCustomToken(14424, "Bioware Instant Horse System.");
                break;
            case MK_HORSE_CCOH_HORSE_SYSTEM:
                MK_GenericDialog_SetCondition(254, TRUE);
                MK_GenericDialog_SetCondition(255, FALSE);
                MK_GenericDialog_SetCondition(257, TRUE);
                SetCustomToken(14424, "CCOH Simple Horse System.");
                break;
            }

            break;
        }
/*        default:
            MK_SetBodyPartTokens(oPC);
            break;*/
        }
        MK_SetBodyPartTokens(oPC, oTarget);

        break;
    }

    MK_DELIMITER_Initialize();

    return TRUE;
}
