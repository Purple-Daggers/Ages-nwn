//#include "x3_inc_string"
#include "mk_inc_generic"

void MK_DELIMITER_Initialize(int bEnable=TRUE, int nCondition=MK_DELIMITER_CONDITION);

void MK_DELIMITER_Initialize(int bEnable, int nCondition)
{
    bEnable = bEnable && MK_DELIMITER_GetUseDelimiter();
    string sToken="";
    if (bEnable)
    {
//        string sRGB = GetLocalString(OBJECT_SELF, MK_DELIMITER_COLOR);
        string sColorTag = GetLocalString(MK_GetObjectQ(), MK_DELIMITER_COLOR);
        string sColorEnd = "</c>";
        sToken = sColorTag + "--------------------------------------------------" + sColorEnd;
//        sToken = StringToRGBString("--------------------------------------------------",sRGB);
    }
    SetCustomToken(MK_DELIMITER_TOKEN, sToken);

    if (nCondition!=MK_DELIMITER_CONDITION)
    {
        MK_GenericDialog_SetCondition(nCondition, bEnable);
    }
}

/*
void main()
{

}
/**/
