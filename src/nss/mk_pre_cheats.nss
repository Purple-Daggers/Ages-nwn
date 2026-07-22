#include "mk_inc_generic"
#include "mk_inc_debug"
#include "mk_inc_states"
#include "mk_inc_math"
#include "mk_inc_delimiter"
#include "mk_inc_itm_disp"
#include "mk_inc_2da_disp"
#include "mk_inc_cheats"

//const int MK_CHEATS_DEBUG = FALSE;

const string MK_CHEATS_LEVEL_XP = "MK_CHEATS_LEVEL_XP";
const string MK_CHEATS_GOLD_AMOUNT = "MK_CHEATS_GOLD_AMOUNT";
const string MK_CHEATS_ALIGNMENT_GOODEVIL = "MK_CHEATS_ALIGNMENT_GOODEVIL";
const string MK_CHEATS_ALIGNMENT_LAWCHAOS = "MK_CHEATS_ALIGNMENT_LAWCHAOS";

/*
void MK_CHEATS_DEBUG_TRACE(string sMessage)
{
    if (MK_ITM_DISPLAY_DEBUG)
    {
        MK_DEBUG_TRACE(sMessage);
    }
}
*/

string MK_CHEATS_GetCheatEnabledDisableVarName(int nState, int bEnabled)
{
    return "MK_CHEATS_" + IntToString(nState) + "_" + (bEnabled ? "ENABLED" : "DISABLED");
}

int MK_CHEATS_GetIsCheatEnabled(int nState)
{
    string sVarName = MK_CHEATS_GetCheatEnabledDisableVarName(nState, TRUE);
    int nReturn = GetLocalInt(OBJECT_SELF, sVarName);
    MK_CHEATS_DEBUG_TRACE("MK_CHEATS_GetIsCheatEnabled("+IntToString(nState)+"): GetLocalInt("+sVarName+")="+IntToString(nReturn));
    return nReturn;
}

int MK_CHEATS_GetIsCheatDisabled(int nState)
{
    string sVarName = MK_CHEATS_GetCheatEnabledDisableVarName(nState, FALSE);
    int nReturn = GetLocalInt(OBJECT_SELF, sVarName);
    MK_CHEATS_DEBUG_TRACE("MK_CHEATS_GetIsCheatDisabled("+IntToString(nState)+"): GetLocalInt("+sVarName+")="+IntToString(nReturn));
    return nReturn;
}

void MK_CHEATS_DisableCheat(int nState, int bDisable=TRUE)
{
    SetLocalInt(OBJECT_SELF, MK_CHEATS_GetCheatEnabledDisableVarName(nState, FALSE), bDisable);
    MK_CHEATS_DEBUG_TRACE("MK_CHEATS_DisableCheat("+IntToString(nState)+", "+IntToString(bDisable)+"): "
        +"GetLocalInt("+MK_CHEATS_GetCheatEnabledDisableVarName(nState, FALSE)+")="
        + IntToString(GetLocalInt(OBJECT_SELF, MK_CHEATS_GetCheatEnabledDisableVarName(nState, FALSE))));
}

int MK_CHEATS_GetItemFlagDefaultMode(int nState)
{
    int nMode = 0;
    switch (nState)
    {
    case MK_STATE_CHEATS_PLOTFLAG:
        nMode = MK_ITM_DISP_ALL | MK_ITM_DISP_HIDDENSLOTS;
        break;
    default:
        nMode = MK_ITM_DISP_ALL;
        break;
    }
    return nMode;
}

string MK_CHEATS_GetCheatDisabledMessage(int nState)
{
    string sReturn = "";
    if (!MK_CHEATS_GetIsCheatEnabled(nState))
    {
        sReturn = MK_TLK_GetStringByStrRef(-466);
    }
    else if (MK_CHEATS_GetIsCheatDisabled(nState))
    {
        sReturn = MK_TLK_GetStringByStrRef(-485);
    }
    else
    {
        switch (nState)
        {
        case MK_STATE_CHEATS_CURSEDFLAG:
        case MK_STATE_CHEATS_PLOTFLAG:
        case MK_STATE_CHEATS_STOLENFLAG:
        case MK_STATE_CHEATS_NOTIDENTIFIED:
        {
            int nStateQ = MK_GenericDialog_SetState(nState);
            MK_ITM_DISPLAY_Initialize(BASE_ITEM_INVALID, MK_CHEATS_GetItemFlagDefaultMode(nState), MK_ITM_DISP_MAX_PAGE_LENGTH, "mk_cb_iflag_chk");
            MK_CHEATS_DEBUG_TRACE("MK_CHEATS_GetCheatDisabledMessage("+IntToString(nState)+"): nItemCount = "+IntToString(MK_ITM_DISPLAY_GetItemCount()));
            MK_GenericDialog_SetState(nStateQ);
            if (MK_ITM_DISPLAY_GetItemCount()==0)
            {
                sReturn = MK_TLK_GetStringByStrRef(-467);
            }
            MK_ITM_DISPLAY_Cleanup();
            break;
        }
        case MK_STATE_CHEATS_FEATS:
        case MK_STATE_CHEATS_SKILLPOINTS:
            if (!GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CARMOUR, OBJECT_SELF)))
            {
                sReturn = MK_TLK_GetStringByStrRef(-465);
            }
            break;
//        case MK_STATE_CHEATS_CHARGES:
//            sReturn = MK_TLK_GetStringByStrRef(-473);
//            break;
        }
    }
    return sReturn;
}

int MK_CHEATS_GetCheatEnabled(int nState)
{
    return (MK_CHEATS_GetCheatDisabledMessage(nState)=="");
}

void MK_CHEATS_SetCustomTokens()
{
    string sDisabledOptionsColor = GetLocalString(OBJECT_SELF, "MK_DISABLED_OPTIONS_COLOR");
    string sCloseColor = (sDisabledOptionsColor!="" ? "</c>" : "");
    string sMessage="";
    int nToken1,nToken2;
    int nCondition;

    int iState;
    for (iState = MK_STATE_CHEATS+1; iState<=MK_STATE_CHEATS_SWAPITEMPROPS; iState++)
    {
        sMessage = MK_CHEATS_GetCheatDisabledMessage(iState);
        switch (iState)
        {
        case MK_STATE_CHEATS_LEVEL:
            nToken1 = 14460; nToken2 = nToken1+10;
            nCondition = 31;
            break;
        case MK_STATE_CHEATS_GOLD:
            nToken1 = 14461; nToken2 = nToken1+10;
            nCondition = 32;
            break;
        case MK_STATE_CHEATS_ALIGNMENT:
            nToken1 = 14462; nToken2 = nToken1+10;
            nCondition = 33;
            break;
        case MK_STATE_CHEATS_FEATS:
            nToken1 = 14463; nToken2 = nToken1+10;
            nCondition = 34;
            break;
        case MK_STATE_CHEATS_SKILLPOINTS:
            nToken1 = 14464; nToken2 = nToken1+10;
            nCondition = 37;
            break;
        case MK_STATE_CHEATS_ITEMPROPS:
            nToken1 = 14465; nToken2 = nToken1+10;
            nCondition = 38;
            break;
        case MK_STATE_CHEATS_CURSEDFLAG:
            nToken1 = 14466; nToken2 = nToken1+10;
            nCondition = 35;
            break;
        case MK_STATE_CHEATS_OPENSTORE:
            nToken1 = 14467; nToken2 = nToken1+10;
            nCondition = 36;
            break;
        case MK_STATE_CHEATS_CHARGES:
            nToken1 = 14468; nToken2 = nToken1+10;
            nCondition = 39;
            break;
        case MK_STATE_CHEATS_PLOTFLAG:
            nToken1 = 14469; nToken2 = nToken1+10;
            nCondition = 30;
            break;
        case MK_STATE_CHEATS_STOLENFLAG:
            nToken1 = 14449; nToken2 = nToken1+10;
            nCondition = 29;
            break;
        case MK_STATE_CHEATS_NOTIDENTIFIED:
            nToken1 = 14448; nToken2 = nToken1+10;
            nCondition = 28;
            break;
        case MK_STATE_CHEATS_SWAPITEMPROPS:
            nToken1 = 14447; nToken2 = nToken1+10;
            nCondition = 27;
            break;
        }
        int bEnable = (sMessage=="");
        SetCustomToken(nToken1, (!bEnable ? sDisabledOptionsColor : ""));
        SetCustomToken(nToken2, (!bEnable ? sMessage+sCloseColor : ""));
        MK_GenericDialog_SetCondition(nCondition, bEnable);
    }
}


int MK_CHEATS_GetLevel(object oPC)
{
    int nCurrentXP = GetXP(oPC);
    int nCurrentLevel = FloatToInt(0.5 + sqrt((125.0+nCurrentXP)/500.0));
//    1/2+WURZEL((125+D11)/500)
    return nCurrentLevel;
}

int _max(int n1, int n2)
{
    return (n1>n2 ? n1 : n2);
}

int _min(int n1, int n2)
{
    return (n1<n2 ? n1 : n2);
}

int MK_CHEATS_GetMaxLevel(object oPC)
{
    int nMaxLevel = GetLocalInt(oPC, "MK_CHEATS_MAX_LEVEL");
    if (nMaxLevel==0) nMaxLevel=40;
    return nMaxLevel;
}

void MK_CHEATS_LevelPC(object oPC, int nLevels)
{
    int nCurrentXP = GetXP(oPC);
    int nCurrentLevel = MK_CHEATS_GetLevel(oPC);


    int nDesiredLevel = _min(_max(nCurrentLevel + nLevels, 1), MK_CHEATS_GetMaxLevel(oPC));
    if (nDesiredLevel!=nCurrentLevel)
    {
//        int nRequiredXP = (nDesiredLevel-1) * nDesiredLevel * 500;
        int nRequiredXP = MK_Get2DAInt("exptable", "XP", (nDesiredLevel-1), -1);
        if (nRequiredXP>=0)
        {
            int nXP = GetLocalInt(oPC, MK_CHEATS_LEVEL_XP);
            SetXP(oPC, nRequiredXP);
            SetLocalInt(oPC, MK_CHEATS_LEVEL_XP, nXP + (nRequiredXP - nCurrentXP));
        }
    }
}

void MK_CHEATS_GiveGold(object oPC, int nGold)
{
    int nCurrentGold = GetGold(oPC);
    int nGoldGiven = GetLocalInt(oPC, MK_CHEATS_GOLD_AMOUNT);
    if (nGold>0)
    {
        GiveGoldToCreature(oPC, nGold);
    }
    else if (nGold<0)
    {
        TakeGoldFromCreature(-nGold, oPC, TRUE);
    }
    SetLocalInt(oPC, MK_CHEATS_GOLD_AMOUNT, nGoldGiven + GetGold(oPC) - nCurrentGold);
}

void MK_CHEATS_AdjustAlignment(object oPC, int nAlignment, int nShift)
{
    int nCurrentAlignment=-1;
    int nAlignmentShifted=-1;
    switch (nAlignment)
    {
    case ALIGNMENT_CHAOTIC:
        nAlignment = ALIGNMENT_LAWFUL;
        nShift*=-1;
    case ALIGNMENT_LAWFUL:
        nCurrentAlignment = GetLawChaosValue(oPC);
        nAlignmentShifted = GetLocalInt(oPC, MK_CHEATS_ALIGNMENT_LAWCHAOS);
        break;
        break;
    case ALIGNMENT_EVIL:
        nAlignment = ALIGNMENT_GOOD;
        nShift*=-1;
    case ALIGNMENT_GOOD:
        nCurrentAlignment = GetGoodEvilValue(oPC);
        nAlignmentShifted = GetLocalInt(oPC, MK_CHEATS_ALIGNMENT_GOODEVIL);
        break;
    }
    MK_CHEATS_DEBUG_TRACE("MK_CHEATS_AdjustAlignment: nAlignment="+IntToString(nAlignment)
        +", nShift="+IntToString(nShift)+", nCurrentAlignment="+IntToString(nCurrentAlignment));

    AdjustAlignment(oPC, nAlignment, nShift, FALSE);

    int nNewAlignment=-1;

    switch (nAlignment)
    {
    case ALIGNMENT_LAWFUL:
        nNewAlignment = GetLawChaosValue(oPC);
        break;
    case ALIGNMENT_GOOD:
        nNewAlignment = GetGoodEvilValue(oPC);
        break;
    }

    int nCurrentShift = nNewAlignment - nCurrentAlignment;

    MK_CHEATS_DEBUG_TRACE(" > nNewAlignment="+IntToString(nNewAlignment)
        + ", nNewAlignment-nOldAlignment="+IntToString(nNewAlignment-nCurrentAlignment)
        + ", desired="+IntToString(nShift));

    if ((nCurrentShift != nShift) && (nNewAlignment!=0) && (nNewAlignment!=100))
    {
        int nAdjustment = -(nCurrentShift - nShift);
        MK_CHEATS_DEBUG_TRACE(" > adjustment required: adjustment="+IntToString(nAdjustment));
        AdjustAlignment(oPC, nAlignment, nAdjustment, FALSE);
    }

    switch (nAlignment)
    {
    case ALIGNMENT_LAWFUL:
        nNewAlignment = GetLawChaosValue(oPC);
        SetLocalInt(oPC, MK_CHEATS_ALIGNMENT_LAWCHAOS, nAlignmentShifted + (nNewAlignment-nCurrentAlignment));
        break;
    case ALIGNMENT_GOOD:
        nNewAlignment = GetGoodEvilValue(oPC);
        SetLocalInt(oPC, MK_CHEATS_ALIGNMENT_GOODEVIL, nAlignmentShifted + (nNewAlignment-nCurrentAlignment));
        break;
    }
}

void MK_CHEATS_RestoreAlignment(object oPC)
{
    int nShift;
    nShift = GetLocalInt(oPC, MK_CHEATS_ALIGNMENT_LAWCHAOS);
    if (nShift>0)
    {
        MK_CHEATS_AdjustAlignment(oPC, ALIGNMENT_CHAOTIC, nShift);
    }
    else if (nShift<0)
    {
        MK_CHEATS_AdjustAlignment(oPC, ALIGNMENT_LAWFUL, -nShift);
    }
    nShift = GetLocalInt(oPC, MK_CHEATS_ALIGNMENT_GOODEVIL);
    if (nShift>0)
    {
        MK_CHEATS_AdjustAlignment(oPC, ALIGNMENT_EVIL, nShift);
    }
    else if (nShift<0)
    {
        MK_CHEATS_AdjustAlignment(oPC, ALIGNMENT_GOOD, -nShift);
    }
}

void _SetAlignmentToken(int nToken, string sAlignmentText, int nAlignmentValue, int nShifted)
{
    string s = sAlignmentText + " (" + IntToString(nAlignmentValue) +
        (nShifted!=0 ? " / " + (nShifted>0 ? "+" : "") + IntToString(nShifted) : "") + ")";
    SetCustomToken(nToken, s);
}

void MK_CHEATS_SetAlignmentToken(object oPC, int nTokenLawChaos, int nTokenGoodEvil)
{
    int nStrRef=-1;
    switch (GetAlignmentGoodEvil(oPC))
    {
    case ALIGNMENT_GOOD:
        nStrRef = 265;
        break;
    case ALIGNMENT_EVIL:
        nStrRef = 266;
        break;
    case ALIGNMENT_NEUTRAL:
        nStrRef = 264;
        break;
    default:
        nStrRef=-1;
        break;
    }
    string sAlignmentGoodEvilText = (nStrRef!=-1 ? GetStringByStrRef(nStrRef) : "");

    switch (GetAlignmentLawChaos(oPC))
    {
    case ALIGNMENT_LAWFUL:
        nStrRef = 268;
        break;
    case ALIGNMENT_CHAOTIC:
        nStrRef = 267;
        break;
    case ALIGNMENT_NEUTRAL:
        nStrRef = 264;
        break;
    default:
        nStrRef=-1;
        break;
    }
    string sAlignmentLawChaosText = (nStrRef!=-1 ? GetStringByStrRef(nStrRef) : "");

    int nCurrentAlignmentGoodEvil = GetGoodEvilValue(oPC);
    int nCurrentAlignmentLawChaos = GetLawChaosValue(oPC);

    int nShiftedGoodEvil = GetLocalInt(oPC, MK_CHEATS_ALIGNMENT_GOODEVIL);
    int nShiftedLawChaos = GetLocalInt(oPC, MK_CHEATS_ALIGNMENT_LAWCHAOS);

    _SetAlignmentToken(nTokenGoodEvil, sAlignmentGoodEvilText, nCurrentAlignmentGoodEvil, nShiftedGoodEvil);
    _SetAlignmentToken(nTokenLawChaos, sAlignmentLawChaosText, nCurrentAlignmentLawChaos, nShiftedLawChaos);

//  SetCustomToken(nTokenGoodEvil, sAlignmentGoodEvilText + " (" + IntToString(nCurrentAlignmentGoodEvil)
//      + "[" + ( nShiftedGoodEvil > 0 ? "+" : "" ) + IntToString(nShiftedGoodEvil) + "])");
//  SetCustomToken(nTokenLawChaos, sAlignmentLawChaosText + " (" + IntToString(nCurrentAlignmentLawChaos)
//      + "[" + ( nShiftedLawChaos > 0 ? "+" : "" ) + IntToString(nShiftedLawChaos) + "])");
}

void MK_CHEATS_ToggleFeat(int nFeat)
{
    object oItem = GetItemInSlot(INVENTORY_SLOT_CARMOUR, OBJECT_SELF);
    if (!GetIsObjectValid(oItem))
    {
        return;
    }
    itemproperty iProp = MK_IPRP_GetItemProperty(oItem, ITEM_PROPERTY_BONUS_FEAT, nFeat);
    if (GetIsItemPropertyValid(iProp))
    {
        RemoveItemProperty(oItem, iProp);
    }
    else
    {
//        iProp = TagItemProperty(ItemPropertyBonusFeat(nFeat), MK_CHEATS_CreateItemPropertyTag(ITEM_PROPERTY_BONUS_FEAT, nFeat));
        iProp = ItemPropertyBonusFeat(nFeat);
        AddItemProperty(DURATION_TYPE_PERMANENT, iProp, oItem);
    }
}

int MK_CHEATS_GetCurrentSkillBonus(int bRemoveProperties=FALSE)
{
    int nSkillBonus = 0;
    object oItem = GetItemInSlot(INVENTORY_SLOT_CARMOUR, OBJECT_SELF);
    if (GetIsObjectValid(oItem))
    {
        int nSkill = MK_CHEATS_GetCurrentSkill();
        if (nSkill!=-1)
        {
            nSkillBonus = MK_IPRP_GetSkillBonus(oItem, nSkill, bRemoveProperties);
        }
    }
    return nSkillBonus;
}

int MK_CHEATS_GetHasModifiedSkill()
{
    object oItem = GetItemInSlot(INVENTORY_SLOT_CARMOUR, OBJECT_SELF);
    int iSkill;
    for (iSkill=0; iSkill<MK_CHEATS_GetSkillCount(); iSkill++)
    {
        if (MK_IPRP_GetSkillBonus(oItem, iSkill, FALSE)!=0)
        {
            return TRUE;
        }
    }
    return FALSE;
}

int MK_CHEATS_GetCanSetSkillBonus(int nSkillBonus)
{
    return (Get2DAString("iprp_skillcost", "Label", abs(nSkillBonus))!="");
}

void MK_CHEATS_SetSkillsToken()
{
    int nSkill = MK_CHEATS_GetCurrentSkill();
    int nGender = GetGender(OBJECT_SELF);
    string sDisabledOptionsColor = GetLocalString(OBJECT_SELF, "MK_DISABLED_OPTIONS_COLOR");
    int bDisableIncrease=TRUE, bDisableDecrease=TRUE;
    int nSkillBonus=0;
    int bHasModifiedSkills = MK_CHEATS_GetHasModifiedSkill();
    if (nSkill == -1)
    {
        SetCustomToken(14422, MK_TLK_GetStringByStrRef(-464, nGender));
        SetCustomToken(14423, "");
    }
    else
    {
        int nStrRef = MK_Get2DAInt("skills", "Name", nSkill, 0);
        SetCustomToken(14422, MK_TLK_GetStringByStrRef(nStrRef, nGender));
        nSkillBonus = MK_CHEATS_GetCurrentSkillBonus();
        SetCustomToken(14423," ("+IntToString(nSkillBonus)+")");

        int bCanSetSkillBonus = MK_CHEATS_GetCanSetSkillBonus(abs(nSkillBonus)+1);
        bDisableIncrease = (nSkillBonus>=0) && (!bCanSetSkillBonus);
        bDisableDecrease = (nSkillBonus<=0) && (!bCanSetSkillBonus);
    }

    SetCustomToken(14471, (bDisableIncrease ? sDisabledOptionsColor : ""));
    SetCustomToken(14472, (bDisableIncrease ? "</c>" : ""));
    SetCustomToken(14473, (bDisableDecrease ? sDisabledOptionsColor : ""));
    SetCustomToken(14474, (bDisableDecrease ? "</c>" : ""));
    SetCustomToken(14475, (nSkillBonus==0   ? sDisabledOptionsColor : ""));
    SetCustomToken(14476, (nSkillBonus==0   ? "</c>" : ""));
    SetCustomToken(14477, (!bHasModifiedSkills ? sDisabledOptionsColor : ""));
    SetCustomToken(14478, (!bHasModifiedSkills ? "</c>" : ""));
}

void MK_CHEATS_AdjustCurrentSkill(int nValue)
{
    int nSkill = MK_CHEATS_GetCurrentSkill();
    if (nSkill == -1)
    {
        return;
    }
    object oItem = GetItemInSlot(INVENTORY_SLOT_CARMOUR, OBJECT_SELF);
    if (!GetIsObjectValid(oItem))
    {
        return;
    }
    if (!MK_CHEATS_GetCanSetSkillBonus(MK_CHEATS_GetCurrentSkillBonus(FALSE) + nValue))
    {
        return;
    }

    int nSkillBonus = MK_CHEATS_GetCurrentSkillBonus(TRUE) + nValue;

    if (nSkillBonus!=0)
    {
        itemproperty iProp;
        string sTag;
        if (nSkillBonus>0)
        {
            iProp = ItemPropertySkillBonus(nSkill, nSkillBonus);
//            sTag = MK_CHEATS_CreateItemPropertyTag(ITEM_PROPERTY_SKILL_BONUS, nSkill);
        }
        else
        {
            iProp = ItemPropertyDecreaseSkill(nSkill, -nSkillBonus);
//            sTag = MK_CHEATS_CreateItemPropertyTag(ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, nSkill);
        }
        if (GetIsItemPropertyValid(iProp))
        {
//            iProp = TagItemProperty(iProp, sTag);
            AddItemProperty(DURATION_TYPE_PERMANENT, iProp, oItem);
        }
    }
}

void MK_CHEATS_ResetCurrentSkill()
{
    MK_CHEATS_GetCurrentSkillBonus(TRUE);
}

void MK_CHEATS_ResetAllSkills()
{
    object oItem = GetItemInSlot(INVENTORY_SLOT_CARMOUR, OBJECT_SELF);
    int iSkill;
    for (iSkill=0; iSkill<MK_CHEATS_GetSkillCount(); iSkill++)
    {
        MK_IPRP_GetSkillBonus(oItem, iSkill, TRUE);
    }
}

const int MK_CHEATS_MIN_CHARGES = 1;

void MK_CHEATS_AdjustItemCharges(int nAdjustBy)
{
    object oItem = MK_CHEATS_GetCurrentItem();
    if (GetIsObjectValid(oItem))
    {
        int nCharges = GetItemCharges(oItem);
        if ((nCharges>=MK_CHEATS_MIN_CHARGES) || (nAdjustBy>0))
        {
            SetItemCharges(oItem, MK_MATH_MaxInt(MK_CHEATS_MIN_CHARGES, nCharges + nAdjustBy));
        }
    }
}

int MK_CHEATS_FinishChangeCharges()
{
    int nState = MK_GenericDialog_GetState();
    object oItem = MK_CHEATS_GetCurrentItem();
    if (MK_CHEATS_FinishModifyItem())
    {
        MK_CHEATS_SetCurrentItem(oItem);
//        MK_ITM_DISPLAY_Cleanup();
//        MK_GenericDialog_SetState(nState = MK_STATE_CHEATS);
    }
    return nState;
}

int MK_CHEATS_CancelChangeCharges()
{
    MK_CHEATS_DEBUG_TRACE("MK_CHEATS_CancelChangeCharges() *start*");

    int nState = MK_GenericDialog_GetState();

    MK_CHEATS_CancelModifyItem();

    MK_ITM_DISPLAY_Cleanup();
    MK_ITM_DISPLAY_Initialize(BASE_ITEM_INVALID, MK_ITM_DISP_ALL, 10, "mk_cb_ichrg_chk");

//    MK_GenericDialog_SetState(nState = MK_STATE_CHEATS);

    MK_CHEATS_DEBUG_TRACE("MK_CHEATS_CancelChangeCharges(): *terminate*");
    return nState;
}


int MK_CHEATS_OpenCurrentStore()
{
    int bReturn = TRUE;
    int nStoreID = MK_CHEATS_GetCurrentStore();
    if (nStoreID!=-1)
    {
        object oPC = GetPCSpeaker();
        object oStore = MK_CHEATS_SearchCurrentStore();
        if (!GetIsObjectValid(oStore))
        {
            MK_DEBUG_TRACE("MK_CHEATS_OpenCurrentStore: store with tag '"+MK_CHEATS_GetCurrentStoreTag()+"' not found!");
            oStore = CreateObject(OBJECT_TYPE_STORE, MK_CHEATS_GetCurrentStoreResRef(),
                GetLocation(oPC));
        }
        if (GetIsObjectValid(oStore))
        {
            MK_DEBUG_TRACE("MK_CHEATS_OpenCurrentStore: sResRef ='"+MK_CHEATS_GetCurrentStoreResRef()+"', sTag = '"+GetTag(oStore)+"'");
            object oStoreQ = GetObjectByTag(MK_CHEATS_GetCurrentStoreTag());
            if (!GetIsObjectValid(oStoreQ))
            {
                MK_DEBUG_TRACE(" > store sill not found?");
            }
            int nMarkUp = 0, nMarkDown=0;
            if (MK_Get2DAInt("mk_cheat_stores", "ADJUST_PRICES", nStoreID, 0))
            {
                nMarkUp = FloatToInt(100*GetLocalFloat(oPC, "MK_CHEATS_ITEM_BUY") - 100);
                nMarkDown = FloatToInt(100*GetLocalFloat(oPC, "MK_CHEATS_ITEM_SELL") - 100);
                int nStoreMarkUp = MK_Get2DAInt("mk_cheat_stores", "SELL", nStoreID, -1);
                int nStoreMarkDown = MK_Get2DAInt("mk_cheat_stores", "BUY", nStoreID, -1);
                if (nStoreMarkUp!=-1)
                {
                    nMarkUp += (100-nStoreMarkUp);
                }
                if (nStoreMarkDown!=-1)
                {
                    nMarkDown += (100-nStoreMarkDown);
                }
            }
            MK_DEBUG_TRACE("OpenStore('"+GetName(oStore)+"', '"+GetName(oPC)+"', nMarkup="+IntToString(nMarkUp)+", "+IntToString(nMarkDown)+")");
            OpenStore(oStore, oPC, nMarkUp, nMarkDown);
            bReturn = !GetLocalInt(OBJECT_SELF, "MK_CHEATS_EXTITDLGONOPENSTORE");
            MK_DEBUG_TRACE("MK_CHEATS_OpenCurrentStore(): "+GetTag(oStore)+" opened!");
        }
    }
    MK_CHEATS_DEBUG_TRACE("MK_CHEATS_OpenCurrentStore()="+IntToString(bReturn));
    return bReturn;
}

int MK_CHEATS_PrepareDisablingCurrentCheat()
{
    int nState = MK_GenericDialog_GetState();
    int nToken = 0;
    switch (nState)
    {
    case MK_STATE_CHEATS_LEVEL:
        nToken = -475;
        break;
    case MK_STATE_CHEATS_GOLD:
        nToken = -476;
        break;
    case MK_STATE_CHEATS_ALIGNMENT:
        nToken = -477;
        break;
    case MK_STATE_CHEATS_FEATS:
        nToken = -478;
        break;
    case MK_STATE_CHEATS_CURSEDFLAG:
        nToken = -481;
        break;
    case MK_STATE_CHEATS_OPENSTORE:
        nToken = -483;
        break;
    case MK_STATE_CHEATS_SKILLPOINTS:
        nToken = -479;
        break;
    case MK_STATE_CHEATS_ITEMPROPS:
        nToken = -480;
        break;
    case MK_STATE_CHEATS_CHARGES:
        nToken = -482;
        break;
    case MK_STATE_CHEATS_PLOTFLAG:
        nToken = -489;
        break;
    case MK_STATE_CHEATS_STOLENFLAG:
        nToken = -493;
        break;
    case MK_STATE_CHEATS_NOTIDENTIFIED:
        nToken = -494;
        break;
    default:
        nToken = -484;
        break;
    }
    SetCustomToken(14422, MK_TLK_GetStringByStrRef(nToken));
    SetLocalInt(OBJECT_SELF, "MK_CHEATS_DISABLE_CHEAT", nState);
    MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_DISABLE);
    return nState;
}

int MK_CHEATS_DisableCurrentCheat()
{
    int nCheat = GetLocalInt(OBJECT_SELF, "MK_CHEATS_DISABLE_CHEAT");
    MK_CHEATS_DisableCheat(nCheat, TRUE);
    int nState = MK_STATE_CHEATS;
    MK_GenericDialog_SetState(nState);
    return nState;
}

int MK_CHEATS_ToggleFlag(object oItem, int nState)
{
    int nFlag;
    string sVarName = "MK_CHEATS_FLAG_"+IntToString(nState);
    int nMarked = GetLocalInt(oItem, sVarName);
    switch (nState)
    {
    case MK_STATE_CHEATS_CURSEDFLAG:
        SetItemCursedFlag(oItem, nFlag = !GetItemCursedFlag(oItem));
        break;
    case MK_STATE_CHEATS_PLOTFLAG:
        SetPlotFlag(oItem, nFlag = !GetPlotFlag(oItem));
        break;
    case MK_STATE_CHEATS_STOLENFLAG:
        SetStolenFlag(oItem, nFlag = !GetStolenFlag(oItem));
        break;
    case MK_STATE_CHEATS_NOTIDENTIFIED:
    {
        int nIdentified = GetIdentified(oItem);
        int nGold = GetLocalInt(OBJECT_SELF, "MK_CHEATS_ITEM_IDENTIFY");
        if ((!nIdentified) && (!nMarked))
        {
            int nGold = GetLocalInt(OBJECT_SELF, "MK_CHEATS_ITEM_IDENTIFY");
            if (GetGold() >= nGold)
            {
                SetIdentified(oItem, TRUE);
                nFlag = FALSE;
                if (nGold>0)
                {
                    TakeGoldFromCreature(nGold, OBJECT_SELF, TRUE);
                    SendMessageToPC(OBJECT_SELF, "Item identified: name is "+MK_IPRP_GetItemName(oItem)+"!");
                }
            }
            else
            {
                // we haven't done anything so we make sure that
                // the local int doesn't get changed later
                nMarked = !nMarked;
                nFlag = TRUE;
                SendMessageToPC(OBJECT_SELF, "Failed to identify "+MK_IPRP_GetItemName(oItem)+": not enough gold!");
            }
        }
        else
        {
            if ((nIdentified) && (nMarked) && (nGold>0))
            {
                GiveGoldToCreature(OBJECT_SELF, nGold);
                SendMessageToPC(OBJECT_SELF, "Previously identified item made unidentified again. Gold is returned!");
            }
            SetIdentified(oItem, !nIdentified);
            nFlag = nIdentified;
        }
        break;
    }
    }
    // Mark Uncursed/Unplot/Unstolen/Identified items or remove mark
    // when items are recursed, re-plot, re-stolen or re-unidentified
    // or mark items, when they are cursed, plot, stolen or unidentified
    // and remove mark, when they are uncursed, unplot, unstolen or identified.
    // This looks confusing but the idea is, that marked items are modified
    // by CCOH
    SetLocalInt(oItem, sVarName, !nMarked);

    return nFlag;
}

void MK_CHEATS_SetToggleFlagToken(int nState)
{
//    MK_DEBUG_TRACE("MK_CHEATS_SetToggleFlagToken("+IntToString(nState)+")");
    object oPC = OBJECT_SELF;
    int nStrRef1, nStrRef2, nStrRef3, nStrRefS;
    string sText1, sText2, sText3, sTextS;
    int bText3Colored=TRUE;
    string sColorToken;
    string sTokenEnd = "</c>";
    switch (nState)
    {
    case MK_STATE_CHEATS_CURSEDFLAG:
        nStrRef1 = -486; nStrRef2 = -487; nStrRef3 = -488; nStrRefS = 111874;
        break;
    case MK_STATE_CHEATS_PLOTFLAG:
        nStrRef1 = -490; nStrRef2 = -491; nStrRef3 = -492; nStrRefS = 6808;
        break;
    case MK_STATE_CHEATS_STOLENFLAG:
        nStrRef1 = -495; nStrRef2 = -496; nStrRef3 = -497; nStrRefS = 7102;
        break;
    case MK_STATE_CHEATS_NOTIDENTIFIED:
        nStrRef1 = -498; nStrRef2 = 0; nStrRef3 = 0; nStrRefS = 5548;
        sColorToken = GetLocalString(oPC, "MK_GOLD_COLOR");
        sText2 = "\n"+GetStringByStrRef(65759)+": "+sColorToken+IntToString(GetGold(oPC))+sTokenEnd;
        sText3 = "\n"+GetStringByStrRef(84370)+": "+sColorToken+IntToString(GetLocalInt(oPC, "MK_CHEATS_ITEM_IDENTIFY"))+sTokenEnd;
        bText3Colored=FALSE;
        break;
    }
    int nGender = GetGender(OBJECT_SELF);

    if (nStrRef1!=0) sText1 = MK_TLK_GetStringByStrRef(nStrRef1, nGender);
    if (nStrRef2!=0) sText2 = MK_TLK_GetStringByStrRef(nStrRef2, nGender);
    if (nStrRef3!=0) sText3 = MK_TLK_GetStringByStrRef(nStrRef3, nGender);
    if (nStrRefS!=0) sTextS = MK_TLK_GetStringByStrRef(nStrRefS, nGender);

    if (bText3Colored)
    {
        string sColorToken = GetLocalString(oPC, "MK_WARNING_COLOR");
        if (sColorToken!="")
        {
            sText3 = sColorToken+sText3+sTokenEnd;
        }
    }

    SetCustomToken(14422, sText1);
    SetCustomToken(14423, sText2);
    SetCustomToken(14424, sText3);
    SetCustomToken(14425, sTextS);
}

void MK_CHEATS_UnsetCurrentFlagForAllItems()
{
    object oPC = GetPCSpeaker();
    int nState = MK_GenericDialog_GetState();
    int nFlag;
    string sVarName = "MK_CHEATS_FLAG_"+IntToString(nState);
    int nMarked;
    int nCount = MK_ITM_DISPLAY_GetItemCount();
    int iItem;
    for (iItem=0; iItem<nCount; iItem++)
    {
        object oItem = MK_ITM_DISPLAY_GetItem(iItem);
        if (GetIsObjectValid(oItem))
        {
            nMarked = GetLocalInt(oItem, sVarName);
            if (!nMarked)
            {
                switch (nState)
                {
                case MK_STATE_CHEATS_CURSEDFLAG:
                    if (nFlag = GetItemCursedFlag(oItem))
                    {
                        SetItemCursedFlag(oItem, !nFlag);
                    }
                    break;
                case MK_STATE_CHEATS_PLOTFLAG:
                    if (nFlag = GetPlotFlag(oItem))
                    {
                        SetPlotFlag(oItem, !nFlag);
                    }
                    break;
                case MK_STATE_CHEATS_STOLENFLAG:
                    if (nFlag = GetStolenFlag(oItem))
                    {
                        SetStolenFlag(oItem, !nFlag);
                    }
                    break;
                case MK_STATE_CHEATS_NOTIDENTIFIED:
                    if (nFlag = !GetIdentified(oItem))
                    {
                        int nGold = GetGold(oPC);
                        int nGoldRequired = GetLocalInt(oPC, "MK_CHEATS_ITEM_IDENTIFY");
                        if (nGold>=nGoldRequired)
                        {
                            SetIdentified(oItem, nFlag);
                            TakeGoldFromCreature(nGoldRequired, oPC, TRUE);
                        }
                        else
                        {
                            nFlag = FALSE;
                            SendMessageToPC(oPC, "Failed to identify "+MK_IPRP_GetItemName(oItem)+": not enough gold!");
                        }
                    }
                    break;
                }
                if (nFlag)
                {
                    SetLocalInt(oItem, sVarName, TRUE);
                }
            }
        }
    }
}

void MK_CHEATS_RestoreCurrentFlagForAllItems()
{
    object oPC = GetPCSpeaker();
    int nState = MK_GenericDialog_GetState();
    int nFlag;
    string sVarName = "MK_CHEATS_FLAG_"+IntToString(nState);
    int nMarked;
    int nCount = MK_ITM_DISPLAY_GetItemCount();
    int iItem;
    for (iItem=0; iItem<nCount; iItem++)
    {
        object oItem = MK_ITM_DISPLAY_GetItem(iItem);
        if (GetIsObjectValid(oItem))
        {
            nMarked = GetLocalInt(oItem, sVarName);
            if (nMarked)
            {
                switch (nState)
                {
                case MK_STATE_CHEATS_CURSEDFLAG:
                    if (!(nFlag = GetItemCursedFlag(oItem)))
                    {
                        SetItemCursedFlag(oItem, !nFlag);
                    }
                    break;
                case MK_STATE_CHEATS_PLOTFLAG:
                    if (!(nFlag = GetPlotFlag(oItem)))
                    {
                        SetPlotFlag(oItem, !nFlag);
                    }
                    break;
                case MK_STATE_CHEATS_STOLENFLAG:
                    if (!(nFlag = GetStolenFlag(oItem)))
                    {
                        SetStolenFlag(oItem, !nFlag);
                    }
                    break;
                case MK_STATE_CHEATS_NOTIDENTIFIED:
                    if (!(nFlag = !GetIdentified(oItem)))
                    {
                        SetIdentified(oItem, nFlag);
                        int nGoldRequired = GetLocalInt(oPC, "MK_CHEATS_ITEM_IDENTIFY");
                        GiveGoldToCreature(oPC, nGoldRequired);
                    }
                    break;
                }
                if (!nFlag)
                {
                    DeleteLocalInt(oItem, sVarName);
                }
            }
        }
    }
}

int StartingConditional()
{
    int bReturn = TRUE;
    object oPC = GetPCSpeaker();

    int nState = MK_GenericDialog_GetState();
    int nAction = MK_GenericDialog_GetAction();

    MK_DEBUG_TRACE("mk_pre_cheats: nState="+IntToString(nState)+", nAction="+IntToString(nAction));

    switch (nState)
    {
    case MK_STATE_INIT:
        switch (nAction)
        {
        case 40:
            MK_GenericDialog_SetState(nState = MK_STATE_CHEATS);
            break;
        }
        break;
    case MK_STATE_CHEATS:
        switch (nAction)
        {
        case 28:
            MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_NOTIDENTIFIED);
            MK_ITM_DISPLAY_Initialize(BASE_ITEM_INVALID, MK_ITM_DISP_ALL, 10, "mk_cb_iflag_chk");
            break;
        case 29:
            MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_STOLENFLAG);
            MK_ITM_DISPLAY_Initialize(BASE_ITEM_INVALID, MK_ITM_DISP_ALL, 10, "mk_cb_iflag_chk");
            break;
        case 30:
            MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_PLOTFLAG);
            MK_ITM_DISPLAY_Initialize(BASE_ITEM_INVALID, MK_ITM_DISP_ALL | MK_ITM_DISP_HIDDENSLOTS, 10, "mk_cb_iflag_chk");
            break;
        case 31:
            MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_LEVEL);
            break;
        case 32:
            MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_GOLD);
            break;
        case 33:
            MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_ALIGNMENT);
            break;
        case 34:
            MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_FEATS);
            MK_2DA_DISPLAY_Initialize("iprp_feats", "", "Label", "Name", "FeatIndex", 10, "mk_cb_iprp_ftchk");
            MK_2DA_DISPLAY_SetPageLength(10);
            break;
        case 35:
            MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_CURSEDFLAG);
            MK_ITM_DISPLAY_Initialize(BASE_ITEM_INVALID, MK_ITM_DISP_ALL, 10, "mk_cb_iflag_chk");
            break;
        case 36:
            MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_OPENSTORE);
            MK_2DA_DISPLAY_Initialize("mk_cheat_stores", "", "STRREF", "Name", "RESREF", 50, "");
            MK_2DA_DISPLAY_SetPageLength(10);
            MK_CHEATS_SetCurrentStore(-1);
            break;
        case 37:
            MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_SKILLPOINTS);
            MK_2DA_DISPLAY_Initialize("skills", "", "Label", "Name", "Label", 1, "");
            MK_2DA_DISPLAY_SetPageLength(10);
            MK_CHEATS_SetCurrentSkill(-1);
            break;
//        case 38:
//            MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_ITEMPROPS);
//            break;
        case 39:
            MK_GenericDialog_SetState(nState = MK_STATE_CHEATS_CHARGES);
            MK_ITM_DISPLAY_Initialize(BASE_ITEM_INVALID, MK_ITM_DISP_ALL | MK_ITM_DISP_DISALLOW_UNIDENTIFIED | MK_ITM_DISP_DISALLOW_PLOTITEMS, 10, "mk_cb_ichrg_chk");
            MK_CHEATS_SetCurrentItem(OBJECT_INVALID);
            break;

        }
        break;
    case MK_STATE_CHEATS_DISABLE:
        switch (nAction)
        {
        case 100:
            MK_CHEATS_DisableCurrentCheat();
            MK_GenericDialog_SetState(nState = MK_STATE_CHEATS);
            break;
        case 101:
            MK_GenericDialog_SetState(nState = MK_STATE_CHEATS);
            break;
        }
        break;
    case MK_STATE_CHEATS_LEVEL:
    {
        int nXP = GetLocalInt(oPC, MK_CHEATS_LEVEL_XP);
        int nLevel = GetHitDice(oPC);
        switch (nAction)
        {
        case 28:
            MK_CHEATS_LevelPC(oPC, 10);
            break;
        case 29:
            MK_CHEATS_LevelPC(oPC, 1);
            break;
        case 30:
            MK_CHEATS_LevelPC(oPC, -1);
            break;
        case 31:
            MK_CHEATS_LevelPC(oPC, -10);
            break;
        case 38:
            SetXP(oPC, GetXP(oPC)-nXP);
            SetLocalInt(oPC, MK_CHEATS_LEVEL_XP, 0);
            break;
        case 39:
            SetLocalInt(oPC, MK_CHEATS_LEVEL_XP, 0);
            break;
        case 127:
            nState = MK_CHEATS_PrepareDisablingCurrentCheat();
            break;
        case 255:
            MK_GenericDialog_SetState(nState = MK_STATE_CHEATS);
            break;
        };
        break;
    }
    case MK_STATE_CHEATS_GOLD:
    {
        switch (nAction)
        {
        case 25:
            MK_CHEATS_GiveGold(oPC, 10000);
            break;
        case 26:
            MK_CHEATS_GiveGold(oPC, 1000);
            break;
        case 27:
            MK_CHEATS_GiveGold(oPC, 100);
            break;
        case 28:
            MK_CHEATS_GiveGold(oPC, 10);
            break;
        case 29:
            MK_CHEATS_GiveGold(oPC, 1);
            break;
        case 30:
            MK_CHEATS_GiveGold(oPC, -1);
            break;
        case 31:
            MK_CHEATS_GiveGold(oPC, -10);
            break;
        case 32:
            MK_CHEATS_GiveGold(oPC, -100);
            break;
        case 33:
            MK_CHEATS_GiveGold(oPC, -1000);
            break;
        case 34:
            MK_CHEATS_GiveGold(oPC, -10000);
            break;
        case 38:
            MK_CHEATS_GiveGold(oPC, -GetLocalInt(oPC, MK_CHEATS_GOLD_AMOUNT));
            break;
        case 39:
            SetLocalInt(oPC, MK_CHEATS_GOLD_AMOUNT, 0);
            break;
        case 127:
            nState = MK_CHEATS_PrepareDisablingCurrentCheat();
            break;
        case 255:
            MK_GenericDialog_SetState(nState = MK_STATE_CHEATS);
            break;
        }
        break;
    }
    case MK_STATE_CHEATS_ALIGNMENT:
        switch (nAction)
        {
        case 31:
            MK_CHEATS_AdjustAlignment(oPC, ALIGNMENT_GOOD, 1);
            break;
        case 32:
            MK_CHEATS_AdjustAlignment(oPC, ALIGNMENT_EVIL, 1);
            break;
        case 33:
            MK_CHEATS_AdjustAlignment(oPC, ALIGNMENT_LAWFUL, 1);
            break;
        case 34:
            MK_CHEATS_AdjustAlignment(oPC, ALIGNMENT_CHAOTIC, 1);
            break;
        case 35:
            MK_CHEATS_RestoreAlignment(oPC);
            break;
        case 36:
            SetLocalInt(oPC, MK_CHEATS_ALIGNMENT_LAWCHAOS, 0);
            SetLocalInt(oPC, MK_CHEATS_ALIGNMENT_GOODEVIL, 0);
            break;
        case 127:
            nState = MK_CHEATS_PrepareDisablingCurrentCheat();
            break;
        case 255:
            MK_GenericDialog_SetState(nState = MK_STATE_CHEATS);
            break;
        }
        break;
    case MK_STATE_CHEATS_FEATS:
        switch (nAction)
        {
        case 250: // First page
        case 251: // previous page
        case 252: // next page
        case 253: // last page
            MK_2DA_DISPLAY_UpdatePage(nAction);
            break;
        case 255:
            MK_2DA_DISPLAY_Cleanup();
            MK_GenericDialog_SetState(nState = MK_STATE_CHEATS);
            break;
        case 127:
            MK_2DA_DISPLAY_Cleanup();
            nState = MK_CHEATS_PrepareDisablingCurrentCheat();
            break;
        default:
            if ((nAction>=0) && (nAction<MK_2DA_DISPLAY_GetPageLength()))
            {
                int nFeat = MK_2DA_DISPLAY_GetValueAsInt(nAction);
                MK_DEBUG_TRACE("Selected feat is "+IntToString(nFeat));
                MK_CHEATS_ToggleFeat(nFeat);
            }
            break;
        }
        break;
    case MK_STATE_CHEATS_CURSEDFLAG:
    case MK_STATE_CHEATS_PLOTFLAG:
    case MK_STATE_CHEATS_STOLENFLAG:
    case MK_STATE_CHEATS_NOTIDENTIFIED:
        switch (nAction)
        {
        case 250: // First page
        case 251: // previous page
        case 252: // next page
        case 253: // last page
            MK_ITM_DISPLAY_UpdatePage(nAction);
            break;
        case 255:
            MK_ITM_DISPLAY_Cleanup();
            MK_GenericDialog_SetState(nState = MK_STATE_CHEATS);
            break;
        case 127:
            MK_ITM_DISPLAY_Cleanup();
            nState = MK_CHEATS_PrepareDisablingCurrentCheat();
            break;
        case 30:
            // change all
            MK_CHEATS_UnsetCurrentFlagForAllItems();
            break;
        case 31:
            // undo all changes
            MK_CHEATS_RestoreCurrentFlagForAllItems();
            break;
        case 38:
        case 39:
            SetLocalInt(oPC,"MK_CHEATS_SHOWALLITEMS", !GetLocalInt(oPC, "MK_CHEATS_SHOWALLITEMS"));
            MK_ITM_DISPLAY_Initialize(BASE_ITEM_INVALID, MK_CHEATS_GetItemFlagDefaultMode(nState), 10, "mk_cb_iflag_chk");
            break;
        default:
            if ((nAction>=0) && (nAction<MK_ITM_DISPLAY_GetPageLength()))
            {
                object oItem = MK_ITM_DISPLAY_GetSelectedItem(nAction);
                MK_DEBUG_TRACE("Selected item is '"+GetName(oItem)+"'");
                MK_CHEATS_ToggleFlag(oItem, nState);
            }
            break;
        }
        break;
    case MK_STATE_CHEATS_CHARGES:
        switch (nAction)
        {
        case 30:
            MK_CHEATS_AdjustItemCharges(10);
            break;
        case 31:
            MK_CHEATS_AdjustItemCharges(1);
            break;
        case 32:
            MK_CHEATS_AdjustItemCharges(-1);
            break;
        case 33:
            MK_CHEATS_AdjustItemCharges(-10);
            break;
        case 38:
        case 39:
            SetLocalInt(oPC,"MK_CHEATS_SHOWALLITEMS", !GetLocalInt(oPC, "MK_CHEATS_SHOWALLITEMS"));
            MK_ITM_DISPLAY_Initialize(BASE_ITEM_INVALID, MK_ITM_DISP_ALL, 10, "mk_cb_ichrg_chk");
            break;
        case 250: // First page
        case 251: // previous page
        case 252: // next page
        case 253: // last page
            MK_ITM_DISPLAY_UpdatePage(nAction);
            break;
        case 254:
            nState = MK_CHEATS_FinishChangeCharges();
            break;
        case 255:
            MK_CHEATS_SetCurrentItem(OBJECT_INVALID);
            MK_ITM_DISPLAY_Cleanup();
            MK_GenericDialog_SetState(nState = MK_STATE_CHEATS);
            break;
        case 257:
            nState = MK_CHEATS_CancelChangeCharges();
            break;
        case 127:
            MK_ITM_DISPLAY_Cleanup();
            nState = MK_CHEATS_PrepareDisablingCurrentCheat();
            break;
        default:
            if ((nAction>=0) && (nAction<MK_ITM_DISPLAY_GetPageLength()))
            {
                object oItem = MK_ITM_DISPLAY_GetSelectedItem(nAction);
                MK_DEBUG_TRACE("Selected item is '"+GetName(oItem)+"'");
                MK_CHEATS_SetCurrentItem(oItem);
            }
            break;
        }
        break;
    case MK_STATE_CHEATS_SKILLPOINTS:
        switch (nAction)
        {
        case 30:
            MK_CHEATS_AdjustCurrentSkill(1);
            break;
        case 31:
            MK_CHEATS_AdjustCurrentSkill(-1);
            break;
        case 32:
            MK_CHEATS_ResetCurrentSkill();
            break;
        case 33:
            MK_CHEATS_ResetAllSkills();
        case 250: // First page
        case 251: // previous page
        case 252: // next page
        case 253: // last page
            MK_2DA_DISPLAY_UpdatePage(nAction);
            break;
        case 255:
            MK_2DA_DISPLAY_Cleanup();
            MK_CHEATS_SetCurrentStore(0);
            MK_GenericDialog_SetState(nState = MK_STATE_CHEATS);
            break;
        case 127:
            MK_2DA_DISPLAY_Cleanup();
            MK_CHEATS_SetCurrentStore(0);
            nState = MK_CHEATS_PrepareDisablingCurrentCheat();
            break;
        default:
            if ((nAction>=0) && (nAction<MK_2DA_DISPLAY_GetPageLength()))
            {
                int nSkill = MK_2DA_DISPLAY_GetValueAsInt(nAction);
                if (nSkill == MK_CHEATS_GetCurrentSkill())
                {
                    MK_CHEATS_AdjustCurrentSkill(1);
                }
                else
                {
                    MK_CHEATS_SetCurrentSkill(nSkill);
                }
            }
        }
        break;
    case MK_STATE_CHEATS_ITEMPROPS:
        MK_ITM_DISPLAY_Cleanup();
        switch (nAction)
        {
        case 127:
            nState = MK_CHEATS_PrepareDisablingCurrentCheat();
            break;
        default:
            MK_GenericDialog_SetState(nState = MK_STATE_CHEATS);
            break;
        }
        break;
    case MK_STATE_CHEATS_SWAPITEMPROPS:
        MK_ITM_DISPLAY_Cleanup();
        switch (nAction)
        {
        case 127:
            nState = MK_CHEATS_PrepareDisablingCurrentCheat();
            break;
        default:
            MK_GenericDialog_SetState(nState = MK_STATE_CHEATS);
            break;
        }
        break;
    case MK_STATE_CHEATS_OPENSTORE:
        switch (nAction)
        {
        case 250: // First page
        case 251: // previous page
        case 252: // next page
        case 253: // last page
            MK_2DA_DISPLAY_UpdatePage(nAction);
            break;
        case 255:
            MK_2DA_DISPLAY_Cleanup();
            MK_GenericDialog_SetState(nState = MK_STATE_CHEATS);
            break;
        case 30:
            bReturn = MK_CHEATS_OpenCurrentStore();
            break;
        case 127:
            MK_2DA_DISPLAY_Cleanup();
            nState = MK_CHEATS_PrepareDisablingCurrentCheat();
            break;
        default:
            if ((nAction>=0) && (nAction<MK_2DA_DISPLAY_GetPageLength()))
            {
                int nStoreID = MK_2DA_DISPLAY_GetValueAsInt(nAction);
                int nCurrentStore = MK_CHEATS_GetCurrentStore();
                if (nStoreID!=nCurrentStore)
                {
                    MK_CHEATS_SetCurrentStore(nStoreID);
                }
                else
                {
                    bReturn = MK_CHEATS_OpenCurrentStore();
                }
            }
            break;
        }
        break;
    }

    MK_DEBUG_TRACE("mk_pre_cheats: nState="+IntToString(nState));

    switch (nState)
    {
    case MK_STATE_CHEATS:
    {
        MK_CHEATS_SetCustomTokens();
        break;
    }
    case MK_STATE_CHEATS_LEVEL:
    {
        int nLevel = MK_CHEATS_GetLevel(oPC);
        int bMinLevel = (nLevel==1);
        int bMaxLevel = (nLevel==MK_CHEATS_GetMaxLevel(oPC));
        SetCustomToken(14471, (bMinLevel ? GetLocalString(OBJECT_SELF, MK_DISABLED_OPTIONS_COLOR) : ""));
        SetCustomToken(14472, (bMinLevel ? "</c>" : ""));
        SetCustomToken(14473, (bMaxLevel ? GetLocalString(OBJECT_SELF, MK_DISABLED_OPTIONS_COLOR) : ""));
        SetCustomToken(14474, (bMaxLevel ? "</c>" : ""));
        int nXP = GetLocalInt(oPC, MK_CHEATS_LEVEL_XP);
        MK_GenericDialog_SetConditionRange(28, 31, TRUE);
        MK_GenericDialog_SetCondition(38, nXP!=0);
        MK_GenericDialog_SetCondition(39, nXP!=0);
        SetCustomToken(14421, IntToString(nLevel));
        SetCustomToken(14422, IntToString(GetXP(oPC)));
        SetCustomToken(14423, IntToString(nXP));
        MK_GenericDialog_SetCondition(127, TRUE);
        break;
    }
    case MK_STATE_CHEATS_GOLD:
    {
        int nCurrentGold = GetGold(oPC);
        int nGoldGiven = GetLocalInt(oPC, MK_CHEATS_GOLD_AMOUNT);
        SetCustomToken(14471, (nCurrentGold==0 ? GetLocalString(OBJECT_SELF, MK_DISABLED_OPTIONS_COLOR) : ""));
        SetCustomToken(14472, (nCurrentGold==0 ? "</c>" : ""));
        MK_GenericDialog_SetConditionRange(25, 34, TRUE);
        MK_GenericDialog_SetCondition(38, nGoldGiven!=0);
        MK_GenericDialog_SetCondition(39, nGoldGiven!=0);
        SetCustomToken(14422, IntToString(nCurrentGold));
        SetCustomToken(14423, (nGoldGiven>0 ? "+" : "") + IntToString(nGoldGiven));
        MK_GenericDialog_SetCondition(127, TRUE);
        break;
    }
    case MK_STATE_CHEATS_ALIGNMENT:
    {
        MK_CHEATS_SetAlignmentToken(oPC, 14422, 14424);
//        SetCustomToken(14422, IntToString(nAlignmentGoodEvil));
//        int nAlignmentShiftGoodEvil = GetLocalInt(oPC, MK_CHEATS_ALIGNMENT_GOODEVIL);
//        SetCustomToken(14423, (nAlignmentShiftGoodEvil>0 ? "+" : "") + IntToString(nAlignmentShiftGoodEvil));

//        SetCustomToken(14424, IntToString(nAlignmentLawChaos));
//        int nAlignmentShiftLawChaos = GetLocalInt(oPC, MK_CHEATS_ALIGNMENT_LAWCHAOS);
//        SetCustomToken(14425, (nAlignmentShiftLawChaos>0 ? "+" : "") + IntToString(nAlignmentShiftLawChaos));

        int bAlignmentShifted = (GetLocalInt(oPC, MK_CHEATS_ALIGNMENT_GOODEVIL)!=0)
            || (GetLocalInt(oPC, MK_CHEATS_ALIGNMENT_LAWCHAOS)!=0);
        MK_GenericDialog_SetConditionRange(31, 34, TRUE);
        MK_GenericDialog_SetCondition(35, bAlignmentShifted);
        MK_GenericDialog_SetCondition(36, bAlignmentShifted);

        string sDisabledColor = GetLocalString(OBJECT_SELF, MK_DISABLED_OPTIONS_COLOR);
        string sEndColor = "</c>";
        int nAlignmentGoodEvil = GetGoodEvilValue(oPC);
        int nAlignmentLawChaos = GetLawChaosValue(oPC);
        SetCustomToken(14471, (nAlignmentGoodEvil==100 ? sDisabledColor : ""));
        SetCustomToken(14472, (nAlignmentGoodEvil==100 ? sEndColor : ""));
        SetCustomToken(14473, (nAlignmentGoodEvil==0 ? sDisabledColor : ""));
        SetCustomToken(14474, (nAlignmentGoodEvil==0 ? sEndColor : ""));
        SetCustomToken(14475, (nAlignmentLawChaos==100 ? sDisabledColor : ""));
        SetCustomToken(14476, (nAlignmentLawChaos==100 ? sEndColor : ""));
        SetCustomToken(14477, (nAlignmentLawChaos==0 ? sDisabledColor : ""));
        SetCustomToken(14478, (nAlignmentLawChaos==0 ? sEndColor : ""));

        MK_GenericDialog_SetCondition(127, TRUE);
        break;
    }
    case MK_STATE_CHEATS_FEATS:
        MK_2DA_DISPLAY_DisplayPage(MK_2DA_DISPLAY_GetCurrentPage(), -1, "mk_cb_iprp_ftlbl", TRUE);
        MK_GenericDialog_SetCondition(127, TRUE);
        break;
    case MK_STATE_CHEATS_CURSEDFLAG:
    case MK_STATE_CHEATS_PLOTFLAG:
    case MK_STATE_CHEATS_STOLENFLAG:
    case MK_STATE_CHEATS_NOTIDENTIFIED:
    {
        MK_ITM_DISPLAY_DisplayPage(MK_ITM_DISPLAY_GetCurrentPage(), "mk_cb_iflag_lbl");
        MK_GenericDialog_SetCondition(127, TRUE);
        MK_CHEATS_SetToggleFlagToken(nState);
        int bShowAll = GetLocalInt(oPC, "MK_CHEATS_SHOWALLITEMS");
        MK_GenericDialog_SetCondition(39, !bShowAll);
        MK_GenericDialog_SetCondition(38, bShowAll);
        MK_GenericDialog_SetConditionRange(30, 31, TRUE);
        break;
    }
    case MK_STATE_CHEATS_CHARGES:
    {
        object oItem = MK_CHEATS_GetCurrentItem();
        int bIsValid = GetIsObjectValid(oItem);

        MK_CHEATS_SetCustomToken();

        MK_GenericDialog_SetConditionRange(30, 33, bIsValid);

        if (GetIsObjectValid(oItem))
        {
            int nCharges = GetItemCharges(oItem);
            SetCustomToken(14461, (!GetIsObjectValid(oItem) ? GetLocalString(OBJECT_SELF, MK_DISABLED_OPTIONS_COLOR) : ""));
            SetCustomToken(14462, (!GetIsObjectValid(oItem) || (nCharges<=MK_CHEATS_MIN_CHARGES) ? GetLocalString(OBJECT_SELF, MK_DISABLED_OPTIONS_COLOR) : ""));
            SetCustomToken(14471, (!GetIsObjectValid(oItem) ? "</c>" : ""));
            SetCustomToken(14472, (!GetIsObjectValid(oItem) || (nCharges<=MK_CHEATS_MIN_CHARGES) ? "</c>" : ""));

            SetCustomToken(14424, IntToString(GetItemCharges(oItem)));
            MK_ITM_DISPLAY_HidePage();
            MK_GenericDialog_SetConditionRange(38,39, FALSE);
            MK_GenericDialog_SetCondition(127, FALSE);
        }
        else
        {
            SetCustomToken(14424, "-");
            MK_ITM_DISPLAY_DisplayPage(MK_ITM_DISPLAY_GetCurrentPage(), "mk_cb_ichrg_lbl");
            int bShowAll = GetLocalInt(oPC, "MK_CHEATS_SHOWALLITEMS");
            MK_GenericDialog_SetCondition(39, !bShowAll);
            MK_GenericDialog_SetCondition(38, bShowAll);
//            MK_GenericDialog_SetCondition(37, TRUE);
            MK_GenericDialog_SetCondition(127, TRUE);
        }

        int bModified = MK_CHEATS_GetIsCurrentItemModified();
        MK_GenericDialog_SetCondition(254, bModified);
        MK_GenericDialog_SetCondition(255, !bModified);
        MK_GenericDialog_SetCondition(257, bModified);

        break;
    }
    case MK_STATE_CHEATS_SKILLPOINTS:
        MK_CHEATS_SetSkillsToken();
        MK_2DA_DISPLAY_DisplayPage(MK_2DA_DISPLAY_GetCurrentPage(), MK_CHEATS_GetCurrentSkill(), "mk_cb_iprp_sklbl", FALSE);
        MK_GenericDialog_SetConditionRange(30, 34, TRUE);
        MK_GenericDialog_SetCondition(127, TRUE);
        break;
    case MK_STATE_CHEATS_OPENSTORE:
    {
        MK_2DA_DISPLAY_DisplayPage(MK_2DA_DISPLAY_GetCurrentPage(), MK_CHEATS_GetCurrentStore(), "mk_cb_store_lbl", TRUE);
        SetCustomToken(14422, MK_CHEATS_GetCurrentStoreName());

        SetCustomToken(14460, "");
        SetCustomToken(14470, "");
        object oStore = MK_CHEATS_SearchCurrentStore();
        int nStoreID = MK_CHEATS_GetCurrentStore();
        if (GetIsObjectValid(oStore))
        {
            object oArea = GetArea(oStore);
            SetCustomToken(14424, GetName(oArea));
        }
        else if (nStoreID!=-1)
        {
            int nStrRef = MK_Get2DAInt("mk_cheat_stores", "LOCATION", nStoreID, 7221);
            SetCustomToken(14424, MK_TLK_GetStringByStrRef(nStrRef, GetGender(oPC)));
        }
        else
        {
            SetCustomToken(14460, GetLocalString(OBJECT_SELF, "MK_DISABLED_OPTIONS_COLOR"));
            SetCustomToken(14470, " *no store selected*</c>");
            SetCustomToken(14424, "");
        }
        MK_GenericDialog_SetCondition(30, TRUE);
        MK_GenericDialog_SetCondition(127, TRUE);
        break;
    }
    case MK_STATE_CHEATS_DISABLE:
        // custom token set in MK_CHEATS_PrepareDisablingCurrentCheat()
        break;
    }

    MK_DEBUG_TRACE("mk_pre_cheats: bReturn="+IntToString(bReturn));

    if (bReturn)
    {
        MK_DELIMITER_Initialize();
    }
    else
    {
        ExecuteScript("mk_im_cancel");
    }

    MK_GenericDialog_SetCondition(256, FALSE);

    return bReturn;
}
