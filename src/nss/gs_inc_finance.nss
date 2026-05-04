/* FINANCE Library by Gigaschatten */

#include "gs_inc_common"
#include "gs_inc_pc"

//void main() {}

//open account for oPC
void gsFIOpenAccount(object oPC);
//return account balance of oPC
int gsFIGetBalance(object oPC);
//return amount drawn by oPC
//nAmount =  0 //draw full positive amount
//nAmount = -1 //draw full credit limit
int gsFIDraw(object oPC, int nAmount = 0);
//return amount payed in by oPC
//nAmount = 0 //pay in everything
int gsFIPayIn(object oPC, int nAmount = 0);
//transfer nAmount from caller to sPlayerID
void gsFITransfer(string sPlayerID, int nAmount);

void gsFIOpenAccount(object oPC)
{
    string sID = gsPCGetPlayerID(oPC);

    if (sID != "" &&
        ! GetCampaignInt("GS_FINANCE", sID))
    {
        SetCampaignInt("GS_FINANCE", sID, 1001);
    }
}
//----------------------------------------------------------------
int gsFIGetBalance(object oPC)
{
    string sID = gsPCGetPlayerID(oPC);

    if (sID != "")
    {
        int nAmount = GetCampaignInt("GS_FINANCE", sID);
        if (nAmount) return nAmount - 1001;
    }

    return FALSE;
}
//----------------------------------------------------------------
int gsFIDraw(object oPC, int nAmount = 0)
{
    string sID = gsPCGetPlayerID(oPC);

    if (sID != "")
    {
        int nBalance  = GetCampaignInt("GS_FINANCE", sID);

        if (! nBalance) return FALSE; //invalid account
        nBalance     -= 1;

        switch (nAmount)
        {
        case -1: //draw full credit limit
            nAmount = nBalance;
            break;

        case  0: //draw full positive amount
            nAmount = nBalance - 1000;
            if (nAmount < 0)        nAmount = 0;
            break;

        default:
            if (nAmount > nBalance) nAmount = nBalance;
            break;
        }

        nBalance     -= nAmount - 1;

        gsCMCreateGold(nAmount, oPC);
        SetCampaignInt("GS_FINANCE", sID, nBalance);

        return nAmount;
    }

    return FALSE;
}
//----------------------------------------------------------------
int gsFIPayIn(object oPC, int nAmount = 0)
{
    string sID = gsPCGetPlayerID(oPC);

    if (sID != "")
    {
        int nGold = GetGold(oPC);

        if (nAmount > nGold || ! nAmount) nAmount = nGold;
        if (nAmount > 0)
        {
            int nBalance   = GetCampaignInt("GS_FINANCE", sID);

            if (! nBalance)          return FALSE; //invalid account
            nBalance      -= 1;

            int _nBalance  = 10001000 - nBalance; //maximum
            if (nAmount > _nBalance) nAmount = _nBalance;

            if (nAmount > 0)
            {
                TakeGoldFromCreature(nAmount, oPC, TRUE);
                SetCampaignInt("GS_FINANCE", sID, nBalance + nAmount + 1);
                return nAmount;
            }
        }
    }

    return FALSE;
}
//----------------------------------------------------------------
void gsFITransfer(string sPlayerID, int nAmount)
{
    int nBalance   = GetCampaignInt("GS_FINANCE", sPlayerID);
    if (! nBalance)          return; //invalid account
    nBalance      -= 1;

    int nGold = GetGold();
    if (nGold < nAmount)   nAmount = nGold;

    TakeGoldFromCreature(nAmount, OBJECT_SELF, TRUE);

    int _nBalance  = 10001000 - nBalance; //maximum
    if (nAmount > _nBalance) nAmount = _nBalance;

    if (nAmount > 0) SetCampaignInt("GS_FINANCE", sPlayerID, nBalance + nAmount + 1);
}
