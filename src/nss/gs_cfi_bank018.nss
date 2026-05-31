#include "gs_inc_listener"
#include "gs_inc_finance"

int GetStringIsIntegerNumber(string sString)
{
    int nString=StringToInt(sString);
    if (nString!=0) return TRUE;
    
    string sCompare=IntToString(nString);
    return sCompare==sString;
}

void main()
{
    string sMessage = gsLIGetLastMessage();
    if(GetStringIsIntegerNumber(sMessage))
    {
        gsFIDraw(GetPCSpeaker(), StringToInt(sMessage));
    }
    gsLIClearLastMessage();
}
