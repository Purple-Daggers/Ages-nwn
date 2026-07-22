// mk_inc_swp_iprop
#include "mk_inc_debug"
#include "mk_inc_iprp"
#include "mk_inc_states"
#include "mk_inc_ccoh_db"
#include "mk_inc_ipwrkcntn"


void MK_SWAPIPROP_SetItem(object oItem, int nState)
{
    SetLocalObject(GetPCSpeaker(), "MK_SWAPIPROP_ITEM"+IntToString(nState), oItem);
}

object MK_SWAPIPROP_GetItem(int nState)
{
    return GetLocalObject(GetPCSpeaker(), "MK_SWAPIPROP_ITEM"+IntToString(nState));
}

void MK_SWAPIPROP_SwapItemProperties(object oItem1, object oItem2)
{
    string sIASStr1 = MK_CCOH_DB_ItemPropertiesToIASStr(oItem1);
    string sIASStr2 = MK_CCOH_DB_ItemPropertiesToIASStr(oItem2);
    int nCharges1 = GetItemCharges(oItem1);
    int nCharges2 = GetItemCharges(oItem2);
    MK_DEBUG_TRACE("MK_SWAPIPROP_SwapItemProperties('"+GetName(oItem1)+"','"+GetName(oItem2)+"'):");
    MK_DEBUG_TRACE(" > item1(old): sIASStr1='"+sIASStr1+"', nCharges1="+IntToString(nCharges1));
    MK_DEBUG_TRACE(" > item2(old): sIASStr2='"+sIASStr2+"', nCharges2="+IntToString(nCharges2));
    int nProps1New=MK_CCOH_DB_IASStrToItemProperties(oItem1, sIASStr2, TRUE);
    int nPorps2New=MK_CCOH_DB_IASStrToItemProperties(oItem2, sIASStr1, TRUE);
    if (nCharges1>0 || nCharges2>0)
    {
        if ((nCharges1==0) && (nCharges2>1))
        {
            nCharges1 = 1; nCharges2-=1;
        }
        else if ((nCharges2==0) && (nCharges1>1))
        {
            nCharges2 = 1; nCharges1-=1;
        }
        SetItemCharges(oItem1, nCharges2);
        SetItemCharges(oItem2, nCharges1);
    }
    MK_DEBUG_TRACE(" > item1(new): sIASStr1='"+MK_CCOH_DB_ItemPropertiesToIASStr(oItem1)+"', nCharges1="+IntToString(GetItemCharges(oItem1)));
    MK_DEBUG_TRACE(" > item2(new): sIASStr2='"+MK_CCOH_DB_ItemPropertiesToIASStr(oItem2)+"', nCharges2="+IntToString(GetItemCharges(oItem2)));
}


int MK_SWAPIPROP_CalculateItemPropertySwapCost(object oItem1, object oItem2)
{
    object oContainer = MK_IPGetIPWorkContainer();
    int nCost1a = MK_IPRP_CalculateGoldPieceValue(oItem1);
    int nCost2a = MK_IPRP_CalculateGoldPieceValue(oItem2);
    object oItem1Q = CopyItem(oItem1, oContainer);
    object oItem2Q = CopyItem(oItem2, oContainer);
    SetPlotFlag(oItem1Q, TRUE);
    SetPlotFlag(oItem2Q, TRUE);
    MK_SWAPIPROP_SwapItemProperties(oItem1Q, oItem2Q);
    int nCost1b = MK_IPRP_CalculateGoldPieceValue(oItem1Q);
    int nCost2b = MK_IPRP_CalculateGoldPieceValue(oItem2Q);
    DestroyObject(oItem1Q);
    DestroyObject(oItem2Q);

    int nCost1 = (nCost1b-nCost1a);
    int nCost2 = (nCost2b-nCost2a);

    object oPC = GetPCSpeaker();
    float fFactorBuy = GetLocalFloat(oPC, "MK_CHEATS_ITEM_BUY");
    float fFactorSell = GetLocalFloat(oPC, "MK_CHEATS_ITEM_SELL");

    nCost1 = FloatToInt(nCost1 * (nCost1>0 ? fFactorBuy : fFactorSell));
    nCost2 = FloatToInt(nCost2 * (nCost2>0 ? fFactorBuy : fFactorSell));

    int nCost = nCost1 + nCost2;

    return nCost;
}

int MK_SWAPIPROP_GetCost()
{
    return GetLocalInt(GetPCSpeaker(), "MK_SWAPIPROP_COST");
}

void MK_SWAPIPROP_SetCost(int nCost)
{
    SetLocalInt(GetPCSpeaker(), "MK_SWAPIPROP_COST", nCost);
}

void MK_SWAPIPROP_SetCustomToken()
{
    object oPC = OBJECT_SELF;

    object oItem1 = MK_SWAPIPROP_GetItem(MK_STATE_CHEATS_SWAPITEMPROPS_ITEM1);
    int bValid1 = GetIsObjectValid(oItem1);
    SetCustomToken(14422, bValid1 ? GetName(oItem1) : "-");
    object oItem2 = MK_SWAPIPROP_GetItem(MK_STATE_CHEATS_SWAPITEMPROPS_ITEM2);
    int bValid2 = GetIsObjectValid(oItem2);
    SetCustomToken(14423, bValid2 ? GetName(oItem2) : "-");

    string sCost = "-";
    string sToken1 = GetLocalString(oPC, "MK_DISABLED_OPTIONS_COLOR");
    string sToken2 = "</c>";
    if (bValid1 && bValid2)
    {
        int nCost = MK_SWAPIPROP_GetCost();
        int nGold = GetGold(oPC);

        sCost = IntToString(nCost) + " ("+IntToString(nGold)+")";

        if (nCost>nGold)
        {
            sToken2 = MK_TLK_GetStringByStrRef(-474, GetGender(oPC))+sToken2;
        }
    }
    SetCustomToken(14460, sToken1);
    SetCustomToken(14470, sToken2);
    SetCustomToken(14426, sCost);
}


/*
void main()
{
}
/**/
