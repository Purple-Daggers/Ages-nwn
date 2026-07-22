#include "mk_inc_debug"

int MK_HEX_GetIsValidHexChar(string c)
{
    return ((c=="0") || (c=="1") || (c=="2") || (c=="3") || (c=="4") ||
            (c=="5") || (c=="6") || (c=="7") || (c=="8") || (c=="9") ||
            (c=="a") || (c=="b") || (c=="c") || (c=="d") || (c=="e") ||
            (c=="f"));
}

int MK_HEX_GetHexValue(string c)
{
    int nValue = StringToInt(c);
    if (nValue>0)
        return nValue;
    else if (c=="0")
        return 0;
    else if (c=="a")
        return 10;
    else if (c=="b")
        return 11;
    else if (c=="c")
        return 12;
    else if (c=="d")
        return 13;
    else if (c=="e")
        return 14;
    else if (c=="f")
        return 15;
    return -1;
}


int MK_HEX_HexStringToInt(string sHexString)
{
    int nLen = GetStringLength(sHexString);
    int iStart=0;
    if ((nLen>=2) && (GetStringLeft(sHexString,2)=="0x"))
    {
        iStart+=2;
    }
    int iPos;
    int nValue = 0;
    int n;
    for (iPos=iStart; iPos<nLen; iPos++)
    {
        string c = GetSubString(sHexString,iPos,1);
        int h = MK_HEX_GetHexValue(c);
/*      MK_DEBUG_TRACE("> iStart="+IntToString(iStart)+
                       ", iPos="+IntToString(iPos)+
                       ", nLen="+IntToString(nLen)+
                       ", c="+c+
                       ", h="+IntToString(h)+
                       ", nValue="+IntToString(nValue));*/
        if (h==-1)
        {
            return -1;
        }
        nValue*=16;
        nValue+=h;
    }
//    MK_DEBUG_TRACE("MK_HEX_HexStringToInt("+sHexString+")="+IntToString(nValue));
    return nValue;
}

