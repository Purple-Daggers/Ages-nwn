#include "gs_inc_finance"
#include "gs_inc_text"
#include "gs_inc_worship"

int StartingConditional()
{
    object oTarget = GetLocalObject(OBJECT_SELF, "GS_TARGET");

    if (GetIsObjectValid(oTarget))
    {
        object oMember = GetFirstFactionMember(oTarget);
        string sString = GetDeity(oTarget);
        int nLevel     = GetHitDice(oTarget) + 1;

        SetCustomToken(100, GetName(oTarget));

        switch (GetAlignmentLawChaos(oTarget))
        {
        case ALIGNMENT_LAWFUL:
            SetCustomToken(101, GS_T_16777396);
            break;

        case ALIGNMENT_NEUTRAL:
            SetCustomToken(101, GS_T_16777397);
            break;

        case ALIGNMENT_CHAOTIC:
            SetCustomToken(101, GS_T_16777398);
            break;
        }

        switch (GetAlignmentGoodEvil(oTarget))
        {
        case ALIGNMENT_GOOD:
            SetCustomToken(102, GS_T_16777399);
            break;

        case ALIGNMENT_NEUTRAL:
            SetCustomToken(102, GS_T_16777400);
            break;

        case ALIGNMENT_EVIL:
            SetCustomToken(102, GS_T_16777401);
            break;
        }

        if (sString == "") sString  = "(" + GS_T_16777402 + ")";
        else               sString += " (" + IntToString(gsWOGetPresence(sString)) + "%)";

        SetCustomToken(103, sString);
        SetCustomToken(104, IntToString(GetXP(oTarget)));
        SetCustomToken(105, IntToString(nLevel * (nLevel - 1) / 2 * 1000));
        SetCustomToken(106, IntToString(gsPCGetRolePlay(oTarget)));
        SetCustomToken(107, IntToString(GetGold(oTarget)));
        SetCustomToken(108, IntToString(gsFIGetBalance(oTarget)));

        //party members
        sString        = "";

        while (GetIsObjectValid(oMember))
        {
            sString += GetName(oMember) + ", ";
            oMember  = GetNextFactionMember(oTarget);
        }

        SetCustomToken(109, GetStringLeft(sString, GetStringLength(sString) - 2));
        SetCustomToken(110, GetPCPublicCDKey(oTarget, TRUE));
        return TRUE;
    }

    return FALSE;
}
