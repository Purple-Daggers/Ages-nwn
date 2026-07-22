//////////////////////////////////////////////////////////////////////////////
// mk_inc_language.nss
//////////////////////////////////////////////////////////////////////////////

#include "mk_inc_debug"

const string MK_LANG_2DA_FILE = "mk_language";
const string MK_LANG_LANGUAGE_ID = "MK_LANG_LANGUAGE_ID";

//int g_nMK_LANG_LanguageID = 0;

//////////////////////////////////////////////////////////////////////////////
// Tries to detect the language by reading strings from dialog.tlk
// returns the detected language (as row number of 'mk_language.2da'
//   0: English
//   1: German
//   2: French
//   3: Spanish
//   4: Italian
//   5: Polish
//  -1: Unknown Language / Language not detected
int MK_LANG_DetectLanguage(object oPC, int bDisplayMessage=FALSE);

//////////////////////////////////////////////////////////////////////////////
// returns language (as row number of 'mk_language.2da'
//   0: English
//   1: German
//   2: French
//   3: Spanish
//   4: Italian
//   5: Polish
// if no language was detected 0 (English) is returned
int MK_LANG_GetLanguage();


object MK_LANG_GetObject()
{
    object oReturn = GetPCSpeaker();
    if (!GetIsObjectValid(oReturn)) oReturn = OBJECT_SELF;
    return oReturn;
}

string MK_LANG_Get2DAString(string sColumn, int nRow)
{
    return Get2DAString(MK_LANG_2DA_FILE, sColumn, nRow);
}

int MK_LANG_Get2DAInt(string sColumn, int nRow)
{
    string s = MK_LANG_Get2DAString(sColumn, nRow);
    if (s=="") return -1;
    return StringToInt(s);
}

int MK_LANG_GetLanguage()
{
    object oPC = MK_LANG_GetObject();
    return GetLocalInt(oPC,  MK_LANG_LANGUAGE_ID);
}

string MK_LANG_GetLanguageID()
{
    int nLanguage = MK_LANG_GetLanguage();
    return MK_LANG_Get2DAString("ID", nLanguage);
}

int MK_LANG_GetLanguageHasDialogF()
{
    int nLanguage = MK_LANG_GetLanguage();
    return MK_LANG_Get2DAInt("DialogF", nLanguage);
}

void MK_LANG_SetLanguage(object oPC, int nLanguage)
{
    SetLocalInt(oPC,  MK_LANG_LANGUAGE_ID, nLanguage);
}

int MK_LANG_DetectLanguage(object oPC, int bDisplayMessage)
{
    string sID;
    int iRow = 0;
    string sValue1, sValue2;
    int nStrRef;
    do
    {
        sID = MK_LANG_Get2DAString("ID", iRow);
        if (sID!="")
        {
            nStrRef = MK_LANG_Get2DAInt("StrRef", iRow);
            if (nStrRef!=-1)
            {
                 sValue1 = MK_LANG_Get2DAString("Value", iRow);
                 sValue2 = GetStringByStrRef(nStrRef);
                 MK_DEBUG_TRACE("MK_LANG_DetectLanguage(): '"+sValue1+"' - '"+sValue2+"'");
                 if (sValue1 == sValue2)
                 {
//                    g_nMK_LANG_LanguageID = iRow;
                    if (bDisplayMessage)
                    {
                        SendMessageToPC(oPC, "Language Detection: detected language is '"+MK_LANG_Get2DAString("Language", iRow)+"'!");
                    }
                    MK_LANG_SetLanguage(oPC, iRow);
                    return iRow;
                 }
            }
        }
        iRow++;
    }
    while (sID!="");
    SendMessageToPC(oPC, "Language Detection: language not found in 'mk_language.2da'!");
    return -1;
}


/*
void main()
{
}
/**/
