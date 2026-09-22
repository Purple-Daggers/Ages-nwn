/* LANGUAGE Library by Gigaschatten */

#include "gs_inc_common"
#include "gs_inc_subrace"
#include "gs_inc_text"

//void main() {}

const string GS_LA_COLOR_EMOTE       = "<cþþþ>";

const int GS_LA_LANGUAGE_INVALID      = -1;
const int GS_LA_LANGUAGE_EYNNELIC     =  0;
const int GS_LA_LANGUAGE_ORIS         =  1;
const int GS_LA_LANGUAGE_ADHEAS       =  2;
const int GS_LA_LANGUAGE_DORVIN       =  3;
const int GS_LA_LANGUAGE_VUTA         =  4;
const int GS_LA_LANGUAGE_OLD_DULRIC   =  5;
const int GS_LA_LANGUAGE_LOW_ELDARIS  =  6;
const int GS_LA_LANGUAGE_RUDHEAS      =  7;
const int GS_LA_LANGUAGE_RASHEMI      =  8;
const int GS_LA_LANGUAGE_ROST         =  9;
const int GS_LA_LANGUAGE_BOSHA        =  10;
const int GS_LA_LANGUAGE_VEYDISH      =  11;
const int GS_LA_LANGUAGE_VIVERIC      =  12;



//return TRUE if oPC can speak nLanguage
int gsLAGetCanSpeakLanguage(int nLanguage, object oPC = OBJECT_SELF);
//return language by sKey
int gsLAGetLanguageByKey(string sKey);
//return name of nLanguage
string gsLAGetLanguageName(int nLanguage);
//return key of nLanguage
string gsLAGetLanguageKey(int nLanguage);
//return color code of nLanguage
string gsLAGetLanguageColor(int nLanguage);
//return sString translated to nLanguage
string gsLATranslate(string sString, int nLanguage);
//return sign language
string gsLATranslateSign();

//return sString translated to oris language
string gsLATranslateOris(string sString);
string gsLATranslateAdheas(string sString);
string gsLATranslateDorvin(string sString);
string gsLATranslateVuta(string sString);
string gsLATranslateOldDulric(string sString);
string gsLATranslateLowEldaris(string sString);
string gsLATranslateRudheas(string sString);
string gsLATranslateRashemi(string sString);
string gsLATranslateRost(string sString);
string gsLATranslateBosha(string sString);
string gsLATranslateVeydish(string sString);
string gsLATranslateViveric(string sString);

int gsLAGetCanSpeakLanguage(int nLanguage, object oPC = OBJECT_SELF)
{
    if (GetIsDM(oPC))            return TRUE;
    if (GetIsDMPossessed(oPC))   return TRUE;

    string sTag      = "GS_LA_LANGUAGE_" + IntToString(nLanguage);
    object oItem     = GetItemPossessedBy(oPC, sTag);
    if (GetIsObjectValid(oItem)) return TRUE;

    int nRace        = GetRacialType(oPC);
    int nSubRace     = gsSUGetSubRace(oPC);
    int nAlignmentGE = GetAlignmentGoodEvil(oPC);
    int nAlignmentLC = GetAlignmentLawChaos(oPC);

    switch (nLanguage)
    {
    case GS_LA_LANGUAGE_EYNNELIC:
        return TRUE;
    case GS_LA_LANGUAGE_ORIS:
        return nSubRace == GS_SU_HUMAN_ORI;
    case GS_LA_LANGUAGE_ADHEAS:
        return nSubRace == GS_SU_ADHEAN_JUDHEAN || nSubRace == GS_SU_ADHEAN_RUDHEAN;
    case GS_LA_LANGUAGE_DORVIN:
        return nSubRace == GS_SU_HUMAN_ARCHONBLOODED_ASHLANDER || nSubRace == GS_SU_HUMAN_CIVITAS_ASHLANDER;
    case GS_LA_LANGUAGE_VUTA:
        return nSubRace == GS_SU_HUMAN_INEN || nSubRace == GS_SU_HUMAN_ASHARI;
    case GS_LA_LANGUAGE_OLD_DULRIC:
        return nSubRace == GS_SU_MALARI_ASHFORGED || nSubRace == GS_SU_MALARI_TUSKKIN || nSubRace == GS_SU_MALARI_UNBOWED || nSubRace == GS_SU_MALARI_VARTOARI;
    case GS_LA_LANGUAGE_LOW_ELDARIS:
        return nSubRace == GS_SU_MALOSARI_EMERALD || nSubRace == GS_SU_MALOSARI_FREESWORN || nSubRace == GS_SU_MALOSARI_GREENSWORN || nSubRace == GS_SU_MALOSARI_HORNSWORN ||
                nSubRace == GS_SU_ELDARI_ALARI || nSubRace == GS_SU_ELDARI_AURARI || nSubRace == GS_SU_ELDARI_EMAELARI;
    case GS_LA_LANGUAGE_RUDHEAS:
        return nSubRace == GS_SU_ADHEAN_RUDHEAN;
    case GS_LA_LANGUAGE_RASHEMI:
        return nSubRace == GS_SU_HUMAN_NAVARREE;
    case GS_LA_LANGUAGE_ROST:
        return nSubRace == GS_SU_HUMAN_FYRSTUMEN || nSubRace == GS_SU_HUMAN_KALANORF;
    case GS_LA_LANGUAGE_BOSHA:
        return gsSUGetHasCatModel(nSubRace) || gsSUGetHasCatTail(nSubRace) || gsSUGetHasCatEars(nSubRace) || gsSUGetHasDigitigradeLegs(nSubRace) || gsSUGetHasTigerFace(nSubRace);
    case GS_LA_LANGUAGE_VEYDISH:
        return nSubRace == GS_SU_HUMAN_ARCHONBLOODED_DAVURI || nSubRace == GS_SU_HUMAN_CIVITAS_DAVURI;
    case GS_LA_LANGUAGE_VIVERIC:
        return FALSE;
    }

    return FALSE;
}
//----------------------------------------------------------------
int gsLAGetLanguageByKey(string sKey)
{
    sKey = GetStringLowerCase(sKey);

    if (sKey == GS_T_16777530) return GS_LA_LANGUAGE_EYNNELIC;
    if (sKey == GS_T_16777664) return GS_LA_LANGUAGE_ORIS;
    if (sKey == GS_T_16777665) return GS_LA_LANGUAGE_ADHEAS;
    if (sKey == GS_T_16777666) return GS_LA_LANGUAGE_DORVIN;
    if (sKey == GS_T_16777667) return GS_LA_LANGUAGE_VUTA;
    if (sKey == GS_T_16777668) return GS_LA_LANGUAGE_OLD_DULRIC;
    if (sKey == GS_T_16777669) return GS_LA_LANGUAGE_LOW_ELDARIS;
    if (sKey == GS_T_16777670) return GS_LA_LANGUAGE_RUDHEAS;
    if (sKey == GS_T_16777671) return GS_LA_LANGUAGE_RASHEMI;
    if (sKey == GS_T_16777672) return GS_LA_LANGUAGE_ROST;
    if (sKey == GS_T_16777673) return GS_LA_LANGUAGE_BOSHA;
    if (sKey == GS_T_16777674) return GS_LA_LANGUAGE_VEYDISH;
    if (sKey == GS_T_16777675) return GS_LA_LANGUAGE_VIVERIC;


    return GS_LA_LANGUAGE_INVALID;
}
//----------------------------------------------------------------
string gsLAGetLanguageName(int nLanguage)
{
    switch (nLanguage)
    {
    case GS_LA_LANGUAGE_EYNNELIC:      return GS_T_16777651;
    case GS_LA_LANGUAGE_ORIS:          return GS_T_16777652;
    case GS_LA_LANGUAGE_ADHEAS:        return GS_T_16777653;
    case GS_LA_LANGUAGE_DORVIN:        return GS_T_16777654;
    case GS_LA_LANGUAGE_VUTA:          return GS_T_16777655;
    case GS_LA_LANGUAGE_OLD_DULRIC:    return GS_T_16777656;
    case GS_LA_LANGUAGE_LOW_ELDARIS:   return GS_T_16777657;
    case GS_LA_LANGUAGE_RUDHEAS:       return GS_T_16777658;
    case GS_LA_LANGUAGE_RASHEMI:       return GS_T_16777659;
    case GS_LA_LANGUAGE_ROST:          return GS_T_16777660;
    case GS_LA_LANGUAGE_BOSHA:         return GS_T_16777661;
    case GS_LA_LANGUAGE_VEYDISH:       return GS_T_16777662;
    case GS_LA_LANGUAGE_VIVERIC:       return GS_T_16777663;
    }

    return "";
}
//----------------------------------------------------------------
string gsLAGetLanguageKey(int nLanguage)
{
    switch (nLanguage)
    {
    case GS_LA_LANGUAGE_EYNNELIC:      return GS_T_16777530;
    case GS_LA_LANGUAGE_ORIS:          return GS_T_16777664;
    case GS_LA_LANGUAGE_ADHEAS:        return GS_T_16777665;
    case GS_LA_LANGUAGE_DORVIN:        return GS_T_16777666;
    case GS_LA_LANGUAGE_VUTA:          return GS_T_16777667;
    case GS_LA_LANGUAGE_OLD_DULRIC:    return GS_T_16777668;
    case GS_LA_LANGUAGE_LOW_ELDARIS:   return GS_T_16777669;
    case GS_LA_LANGUAGE_RUDHEAS:       return GS_T_16777670;
    case GS_LA_LANGUAGE_RASHEMI:       return GS_T_16777671;
    case GS_LA_LANGUAGE_ROST:          return GS_T_16777672;
    case GS_LA_LANGUAGE_BOSHA:         return GS_T_16777673;
    case GS_LA_LANGUAGE_VEYDISH:       return GS_T_16777674;
    case GS_LA_LANGUAGE_VIVERIC:       return GS_T_16777675;
    }

    return "";
}
//----------------------------------------------------------------
string gsLAGetLanguageColor(int nLanguage)
{
    switch (nLanguage)
    {
    case GS_LA_LANGUAGE_EYNNELIC:      return "";
    case GS_LA_LANGUAGE_ORIS:     return "<cT  >";
    case GS_LA_LANGUAGE_ADHEAS:      return "<c^|@>";
    case GS_LA_LANGUAGE_DORVIN:   return "<cþì•>";
    case GS_LA_LANGUAGE_VUTA:    return "<c»#K>";
    case GS_LA_LANGUAGE_OLD_DULRIC:     return "<c‰‡y>";
    case GS_LA_LANGUAGE_LOW_ELDARIS:       return "<cÊßt>";
    case GS_LA_LANGUAGE_RUDHEAS:       return "<cÃ™V>";
    case GS_LA_LANGUAGE_RASHEMI:      return "<ct¦L>";
    case GS_LA_LANGUAGE_ROST:    return "<cÖ¹G>";
    case GS_LA_LANGUAGE_BOSHA:    return "<c². >";
    case GS_LA_LANGUAGE_VEYDISH:         return "<c]nD>";
    case GS_LA_LANGUAGE_VIVERIC:        return "<chYj>";
    /*case GS_LA_LANGUAGE_THIEF:       return "";
    case GS_LA_LANGUAGE_UNDERCOMMON: return "<c€2¡>";*/
    }

    return "";
}
//----------------------------------------------------------------
string gsLATranslate(string sString, int nLanguage)
{
    switch (nLanguage)
    {
    case GS_LA_LANGUAGE_EYNNELIC:      return sString;
    case GS_LA_LANGUAGE_ORIS:     return gsLATranslateOris(sString);
    case GS_LA_LANGUAGE_ADHEAS:   return gsLATranslateAdheas(sString);
    case GS_LA_LANGUAGE_DORVIN:    return gsLATranslateDorvin(sString);
    case GS_LA_LANGUAGE_VUTA:     return gsLATranslateVuta(sString);
    case GS_LA_LANGUAGE_OLD_DULRIC:       return gsLATranslateOldDulric(sString);
    case GS_LA_LANGUAGE_LOW_ELDARIS:       return gsLATranslateLowEldaris(sString);
    case GS_LA_LANGUAGE_RUDHEAS:      return gsLATranslateRudheas(sString);
    case GS_LA_LANGUAGE_RASHEMI:    return gsLATranslateRashemi(sString);
    case GS_LA_LANGUAGE_ROST:    return gsLATranslateRost(sString);
    case GS_LA_LANGUAGE_BOSHA:         return gsLATranslateBosha(sString);
    case GS_LA_LANGUAGE_VEYDISH:       return gsLATranslateVeydish(sString);
    case GS_LA_LANGUAGE_VIVERIC: return gsLATranslateViveric(sString);
    }

    return sString;
}
//----------------------------------------------------------------
/*string gsLATranslateSign()
{
    return gsLAGetLanguageColor(GS_LA_LANGUAGE_SIGN) + GS_T_16777403;
}*/
//----------------------------------------------------------------
string gsLATranslateOris(string sString)
{
    string sColor       = gsLAGetLanguageColor(GS_LA_LANGUAGE_ORIS);
    string sTranslation = sColor;
    string sC           = ""; //character
    string sCU          = ""; //character uppercase
    string sCL          = ""; //character lowercase
    string sCT          = ""; //character translation
    int nFlag           = TRUE;
    int nNth            = 0;
    int nCount          = GetStringLength(sString);

    for (; nNth < nCount; nNth++)
    {
        sC = GetSubString(sString, nNth, 1);

        if (sC == "*")
        {
            sC    = nFlag ? GS_LA_COLOR_EMOTE + "*" : "*" + sColor;
            nFlag = ! nFlag;
        }

        if (nFlag)
        {
            if (sC == "ä")       sC  = "a";
            else if (sC == "Ä")  sC  = "A";
            else if (sC == "ö")  sC  = "o";
            else if (sC == "Ö")  sC  = "O";
            else if (sC == "ü")  sC  = "u";
            else if (sC == "Ü")  sC  = "U";

            sCU = GetStringUpperCase(sC);
            sCL = GetStringLowerCase(sC);
            sCT = "";

            if (sCL == "a")      sCT = "o";
            else if (sCL == "b") sCT = "c";
            else if (sCL == "c") sCT = "r";
            else if (sCL == "d") sCT = "j";
            else if (sCL == "e") sCT = "a";
            else if (sCL == "f") sCT = "v";
            else if (sCL == "g") sCT = "k";
            else if (sCL == "h") sCT = "r";
            else if (sCL == "i") sCT = "y";
            else if (sCL == "j") sCT = "z";
            else if (sCL == "k") sCT = "g";
            else if (sCL == "l") sCT = "m";
            else if (sCL == "m") sCT = "z";
            else if (sCL == "n") sCT = "r";
            else if (sCL == "o") sCT = "y";
            else if (sCL == "p") sCT = "k";
            else if (sCL == "q") sCT = "r";
            else if (sCL == "r") sCT = "n";
            else if (sCL == "s") sCT = "k";
            else if (sCL == "t") sCT = "d";
            else if (sCL == "u") sCT = "'";
            else if (sCL == "v") sCT = "r";
            else if (sCL == "w") sCT = "'";
            else if (sCL == "x") sCT = "k";
            else if (sCL == "y") sCT = "i";
            else if (sCL == "z") sCT = "g";

            if (sCT == "")       sCT = sC;
            else if (sC == sCU)  sCT = GetStringUpperCase(sCT);
        }
        else
        {
            sCT = sC;
        }

        sTranslation += sCT;
    }

    return sTranslation;
}
//----------------------------------------------------------------
string gsLATranslateAdheas(string sString)
{
    string sColor       = gsLAGetLanguageColor(GS_LA_LANGUAGE_ADHEAS);
    string sTranslation = sColor;
    string sC           = ""; //character
    string sCU          = ""; //character uppercase
    string sCL          = ""; //character lowercase
    string sCT          = ""; //character translation
    int nFlag           = TRUE;
    int nNth            = 0;
    int nCount          = GetStringLength(sString);

    for (; nNth < nCount; nNth++)
    {
        sC = GetSubString(sString, nNth, 1);

        if (sC == "*")
        {
            sC    = nFlag ? GS_LA_COLOR_EMOTE + "*" : "*" + sColor;
            nFlag = ! nFlag;
        }

        if (nFlag)
        {
            if (sC == "ä")       sC  = "a";
            else if (sC == "Ä")  sC  = "A";
            else if (sC == "ö")  sC  = "o";
            else if (sC == "Ö")  sC  = "O";
            else if (sC == "ü")  sC  = "u";
            else if (sC == "Ü")  sC  = "U";

            sCU = GetStringUpperCase(sC);
            sCL = GetStringLowerCase(sC);
            sCT = "";

            if (sCL == "a")      sCT = "oo";
            else if (sCL == "b") sCT = "n";
            else if (sCL == "c") sCT = "m";
            else if (sCL == "d") sCT = "g";
            else if (sCL == "e") sCT = "a";
            else if (sCL == "f") sCT = "k";
            else if (sCL == "g") sCT = "s";
            else if (sCL == "h") sCT = "d";
            else if (sCL == "i") sCT = "oo";
            else if (sCL == "j") sCT = "h";
            else if (sCL == "k") sCT = "b";
            else if (sCL == "l") sCT = "l";
            else if (sCL == "m") sCT = "p";
            else if (sCL == "n") sCT = "t";
            else if (sCL == "o") sCT = "e";
            else if (sCL == "p") sCT = "b";
            else if (sCL == "q") sCT = "ch";
            else if (sCL == "r") sCT = "n";
            else if (sCL == "s") sCT = "m";
            else if (sCL == "t") sCT = "g";
            else if (sCL == "u") sCT = "ae";
            else if (sCL == "v") sCT = "ts";
            else if (sCL == "w") sCT = "b";
            else if (sCL == "x") sCT = "bb";
            else if (sCL == "y") sCT = "ee";

            if (sCT == "")
            {
                sCT = sC;
            }
            else if (sC == sCU)
            {
                if (GetStringLength(sCT) == 1)
                    sCT = GetStringUpperCase(sCT);
                else
                    sCT = GetStringUpperCase(GetStringLeft(sCT, 1)) +
                          GetStringRight(sCT, 1);
            }
        }
        else
        {
            sCT = sC;
        }

        sTranslation += sCT;
    }

    return sTranslation;
}
//----------------------------------------------------------------
string gsLATranslateDorvin(string sString)
{
    string sColor       = gsLAGetLanguageColor(GS_LA_LANGUAGE_DORVIN);
    string sTranslation = sColor;
    string sC           = ""; //character
    string sCU          = ""; //character uppercase
    string sCL          = ""; //character lowercase
    string sCT          = ""; //character translation
    int nFlag           = TRUE;
    int nNth            = 0;
    int nCount          = GetStringLength(sString);

    for (; nNth < nCount; nNth++)
    {
        sC = GetSubString(sString, nNth, 1);

        if (sC == "*")
        {
            sC    = nFlag ? GS_LA_COLOR_EMOTE + "*" : "*" + sColor;
            nFlag = ! nFlag;
        }

        if (nFlag)
        {
            if (sC == "ä")       sC  = "a";
            else if (sC == "Ä")  sC  = "A";
            else if (sC == "ö")  sC  = "o";
            else if (sC == "Ö")  sC  = "O";
            else if (sC == "ü")  sC  = "u";
            else if (sC == "Ü")  sC  = "U";

            sCU = GetStringUpperCase(sC);
            sCL = GetStringLowerCase(sC);
            sCT = "";

            if (sCL == "a")      sCT = "a";
            else if (sCL == "b") sCT = "p";
            else if (sCL == "c") sCT = "v";
            else if (sCL == "d") sCT = "t";
            else if (sCL == "e") sCT = "el";
            else if (sCL == "f") sCT = "b";
            else if (sCL == "g") sCT = "w";
            else if (sCL == "h") sCT = "r";
            else if (sCL == "i") sCT = "i";
            else if (sCL == "j") sCT = "m";
            else if (sCL == "k") sCT = "x";
            else if (sCL == "l") sCT = "h";
            else if (sCL == "m") sCT = "s";
            else if (sCL == "n") sCT = "c";
            else if (sCL == "o") sCT = "u";
            else if (sCL == "p") sCT = "q";
            else if (sCL == "q") sCT = "d";
            else if (sCL == "r") sCT = "n";
            else if (sCL == "s") sCT = "l";
            else if (sCL == "t") sCT = "y";
            else if (sCL == "u") sCT = "o";
            else if (sCL == "v") sCT = "j";
            else if (sCL == "w") sCT = "f";
            else if (sCL == "x") sCT = "g";
            else if (sCL == "y") sCT = "z";
            else if (sCL == "z") sCT = "k";

            if (sCT == "")
            {
                sCT = sC;
            }
            else if (sC == sCU)
            {
                if (GetStringLength(sCT) == 1)
                    sCT = GetStringUpperCase(sCT);
                else
                    sCT = GetStringUpperCase(GetStringLeft(sCT, 1)) +
                          GetStringRight(sCT, 1);
            }
        }
        else
        {
            sCT = sC;
        }

        sTranslation += sCT;
    }

    return sTranslation;
}
//----------------------------------------------------------------
string gsLATranslateVuta(string sString)
{
    string sColor       = gsLAGetLanguageColor(GS_LA_LANGUAGE_VUTA);
    string sTranslation = sColor;
    string sC           = ""; //character
    string sCU          = ""; //character uppercase
    string sCL          = ""; //character lowercase
    string sCT          = ""; //character translation
    int nFlag           = TRUE;
    int nNth            = 0;
    int nCount          = GetStringLength(sString);

    for (; nNth < nCount; nNth++)
    {
        sC = GetSubString(sString, nNth, 1);

        if (sC == "*")
        {
            sC    = nFlag ? GS_LA_COLOR_EMOTE + "*" : "*" + sColor;
            nFlag = ! nFlag;
        }

        if (nFlag)
        {
            if (sC == "ä")       sC  = "a";
            else if (sC == "Ä")  sC  = "A";
            else if (sC == "ö")  sC  = "o";
            else if (sC == "Ö")  sC  = "O";
            else if (sC == "ü")  sC  = "u";
            else if (sC == "Ü")  sC  = "U";

            sCU = GetStringUpperCase(sC);
            sCL = GetStringLowerCase(sC);
            sCT = "";

            if (sCL == "a")      sCT = "u";
            else if (sCL == "b") sCT = "p";
            else if (sCL == "c") sCT = "";
            else if (sCL == "d") sCT = "t";
            else if (sCL == "e") sCT = "'";
            else if (sCL == "f") sCT = "v";
            else if (sCL == "g") sCT = "k";
            else if (sCL == "h") sCT = "r";
            else if (sCL == "i") sCT = "o";
            else if (sCL == "j") sCT = "z";
            else if (sCL == "k") sCT = "g";
            else if (sCL == "l") sCT = "m";
            else if (sCL == "m") sCT = "s";
            else if (sCL == "n") sCT = "";
            else if (sCL == "o") sCT = "u";
            else if (sCL == "p") sCT = "b";
            else if (sCL == "q") sCT = "";
            else if (sCL == "r") sCT = "n";
            else if (sCL == "s") sCT = "k";
            else if (sCL == "t") sCT = "d";
            else if (sCL == "u") sCT = "u";
            else if (sCL == "v") sCT = "";
            else if (sCL == "w") sCT = "'";
            else if (sCL == "x") sCT = "";
            else if (sCL == "y") sCT = "o";
            else if (sCL == "z") sCT = "w";

            if (sCT == "")       sCT = sC;
            else if (sC == sCU)  sCT = GetStringUpperCase(sCT);
        }
        else
        {
            sCT = sC;
        }

        sTranslation += sCT;
    }

    return sTranslation;
}
//----------------------------------------------------------------
string gsLATranslateOldDulric(string sString)
{
    string sColor       = gsLAGetLanguageColor(GS_LA_LANGUAGE_OLD_DULRIC);
    string sTranslation = sColor;
    string sC           = ""; //character
    string sCU          = ""; //character uppercase
    string sCL          = ""; //character lowercase
    string sCT          = ""; //character translation
    int nFlag           = TRUE;
    int nNth            = 0;
    int nCount          = GetStringLength(sString);

    for (; nNth < nCount; nNth++)
    {
        sC = GetSubString(sString, nNth, 1);

        if (sC == "*")
        {
            sC    = nFlag ? GS_LA_COLOR_EMOTE + "*" : "*" + sColor;
            nFlag = ! nFlag;
        }

        if (nFlag)
        {
            if (sC == "ä")       sC  = "a";
            else if (sC == "Ä")  sC  = "A";
            else if (sC == "ö")  sC  = "o";
            else if (sC == "Ö")  sC  = "O";
            else if (sC == "ü")  sC  = "u";
            else if (sC == "Ü")  sC  = "U";

            sCU = GetStringUpperCase(sC);
            sCL = GetStringLowerCase(sC);
            sCT = "";

            if (sCL == "a")      sCT = "e";
            else if (sCL == "b") sCT = "po";
            else if (sCL == "c") sCT = "st";
            else if (sCL == "d") sCT = "ty";
            else if (sCL == "e") sCT = "i";
            else if (sCL == "f") sCT = "w";
            else if (sCL == "g") sCT = "k";
            else if (sCL == "h") sCT = "ni";
            else if (sCL == "i") sCT = "un";
            else if (sCL == "j") sCT = "vi";
            else if (sCL == "k") sCT = "go";
            else if (sCL == "l") sCT = "ch";
            else if (sCL == "m") sCT = "li";
            else if (sCL == "n") sCT = "ra";
            else if (sCL == "o") sCT = "y";
            else if (sCL == "p") sCT = "ba";
            else if (sCL == "q") sCT = "x";
            else if (sCL == "r") sCT = "hu";
            else if (sCL == "s") sCT = "my";
            else if (sCL == "t") sCT = "dr";
            else if (sCL == "u") sCT = "on";
            else if (sCL == "v") sCT = "fi";
            else if (sCL == "w") sCT = "zi";
            else if (sCL == "x") sCT = "qu";
            else if (sCL == "y") sCT = "an";
            else if (sCL == "z") sCT = "ji";

            if (sCT == "")
            {
                sCT = sC;
            }
            else if (sC == sCU)
            {
                if (GetStringLength(sCT) == 1)
                    sCT = GetStringUpperCase(sCT);
                else
                    sCT = GetStringUpperCase(GetStringLeft(sCT, 1)) +
                          GetStringRight(sCT, 1);
            }
        }
        else
        {
            sCT = sC;
        }

        sTranslation += sCT;
    }

    return sTranslation;
}
//----------------------------------------------------------------
string gsLATranslateLowEldaris(string sString)
{
    string sColor       = gsLAGetLanguageColor(GS_LA_LANGUAGE_LOW_ELDARIS);
    string sTranslation = sColor;
    string sC           = ""; //character
    string sCU          = ""; //character uppercase
    string sCL          = ""; //character lowercase
    string sCT          = ""; //character translation
    int nFlag           = TRUE;
    int nNth            = 0;
    int nCount          = GetStringLength(sString);

    for (; nNth < nCount; nNth++)
    {
        sC = GetSubString(sString, nNth, 1);

        if (sC == "*")
        {
            sC    = nFlag ? GS_LA_COLOR_EMOTE + "*" : "*" + sColor;
            nFlag = ! nFlag;
        }

        if (nFlag)
        {
            if (sC == "ä")       sC  = "a";
            else if (sC == "Ä")  sC  = "A";
            else if (sC == "ö")  sC  = "o";
            else if (sC == "Ö")  sC  = "O";
            else if (sC == "ü")  sC  = "u";
            else if (sC == "Ü")  sC  = "U";

            sCU = GetStringUpperCase(sC);
            sCL = GetStringLowerCase(sC);
            sCT = "";

            if (sCL == "a")      sCT = "az";
            else if (sCL == "b") sCT = "po";
            else if (sCL == "c") sCT = "zi";
            else if (sCL == "d") sCT = "t";
            else if (sCL == "e") sCT = "a";
            else if (sCL == "f") sCT = "wa";
            else if (sCL == "g") sCT = "k";
            else if (sCL == "h") sCT = "'";
            else if (sCL == "i") sCT = "a";
            else if (sCL == "j") sCT = "dr";
            else if (sCL == "k") sCT = "g";
            else if (sCL == "l") sCT = "n";
            else if (sCL == "m") sCT = "l";
            else if (sCL == "n") sCT = "r";
            else if (sCL == "o") sCT = "ur";
            else if (sCL == "p") sCT = "rh";
            else if (sCL == "q") sCT = "k";
            else if (sCL == "r") sCT = "h";
            else if (sCL == "s") sCT = "th";
            else if (sCL == "t") sCT = "k";
            else if (sCL == "u") sCT = "'";
            else if (sCL == "v") sCT = "g";
            else if (sCL == "w") sCT = "zh";
            else if (sCL == "x") sCT = "q";
            else if (sCL == "y") sCT = "o";
            else if (sCL == "z") sCT = "j";

            if (sCT == "")
            {
                sCT = sC;
            }
            else if (sC == sCU)
            {
                if (GetStringLength(sCT) == 1)
                    sCT = GetStringUpperCase(sCT);
                else
                    sCT = GetStringUpperCase(GetStringLeft(sCT, 1)) +
                          GetStringRight(sCT, 1);
            }
        }
        else
        {
            sCT = sC;
        }

        sTranslation += sCT;
    }

    return sTranslation;
}
//----------------------------------------------------------------
string gsLATranslateRudheas(string sString)
{
    string sColor       = gsLAGetLanguageColor(GS_LA_LANGUAGE_RUDHEAS);
    string sTranslation = sColor;
    string sC           = ""; //character
    string sCU          = ""; //character uppercase
    string sCL          = ""; //character lowercase
    string sCT          = ""; //character translation
    int nFlag           = TRUE;
    int nNth            = 0;
    int nCount          = GetStringLength(sString);

    for (; nNth < nCount; nNth++)
    {
        sC = GetSubString(sString, nNth, 1);

        if (sC == "*")
        {
            sC    = nFlag ? GS_LA_COLOR_EMOTE + "*" : "*" + sColor;
            nFlag = ! nFlag;
        }

        if (nFlag)
        {
            if (sC == "ä")       sC  = "a";
            else if (sC == "Ä")  sC  = "A";
            else if (sC == "ö")  sC  = "o";
            else if (sC == "Ö")  sC  = "O";
            else if (sC == "ü")  sC  = "u";
            else if (sC == "Ü")  sC  = "U";

            sCU = GetStringUpperCase(sC);
            sCL = GetStringLowerCase(sC);
            sCT = "";

            if (sCL == "a")      sCT = "il";
            else if (sCL == "b") sCT = "f";
            else if (sCL == "c") sCT = "ny";
            else if (sCL == "d") sCT = "w";
            else if (sCL == "e") sCT = "a";
            else if (sCL == "f") sCT = "o";
            else if (sCL == "g") sCT = "v";
            else if (sCL == "h") sCT = "ir";
            else if (sCL == "i") sCT = "e";
            else if (sCL == "j") sCT = "qu";
            else if (sCL == "k") sCT = "n";
            else if (sCL == "l") sCT = "c";
            else if (sCL == "m") sCT = "s";
            else if (sCL == "n") sCT = "l";
            else if (sCL == "o") sCT = "e";
            else if (sCL == "p") sCT = "ty";
            else if (sCL == "q") sCT = "h";
            else if (sCL == "r") sCT = "m";
            else if (sCL == "s") sCT = "la";
            else if (sCL == "t") sCT = "an";
            else if (sCL == "u") sCT = "y";
            else if (sCL == "v") sCT = "el";
            else if (sCL == "w") sCT = "am";
            else if (sCL == "x") sCT = "'";
            else if (sCL == "y") sCT = "a";
            else if (sCL == "z") sCT = "j";

            if (sCT == "")
            {
                sCT = sC;
            }
            else if (sC == sCU)
            {
                if (GetStringLength(sCT) == 1)
                    sCT = GetStringUpperCase(sCT);
                else
                    sCT = GetStringUpperCase(GetStringLeft(sCT, 1)) +
                          GetStringRight(sCT, 1);
            }
        }
        else
        {
            sCT = sC;
        }

        sTranslation += sCT;
    }

    return sTranslation;
}
//----------------------------------------------------------------
string gsLATranslateRashemi(string sString)
{
    string sColor       = gsLAGetLanguageColor(GS_LA_LANGUAGE_RASHEMI);
    string sTranslation = sColor;
    string sC           = ""; //character
    string sCU          = ""; //character uppercase
    string sCL          = ""; //character lowercase
    string sCT          = ""; //character translation
    int nFlag           = TRUE;
    int nNth            = 0;
    int nCount          = GetStringLength(sString);

    for (; nNth < nCount; nNth++)
    {
        sC = GetSubString(sString, nNth, 1);

        if (sC == "*")
        {
            sC    = nFlag ? GS_LA_COLOR_EMOTE + "*" : "*" + sColor;
            nFlag = ! nFlag;
        }

        if (nFlag)
        {
            if (sC == "ä")       sC  = "a";
            else if (sC == "Ä")  sC  = "A";
            else if (sC == "ö")  sC  = "o";
            else if (sC == "Ö")  sC  = "O";
            else if (sC == "ü")  sC  = "u";
            else if (sC == "Ü")  sC  = "U";

            sCU = GetStringUpperCase(sC);
            sCL = GetStringLowerCase(sC);
            sCT = "";

            if (sCL == "a")      sCT = "y";
            else if (sCL == "b") sCT = "p";
            else if (sCL == "c") sCT = "l";
            else if (sCL == "d") sCT = "t";
            else if (sCL == "e") sCT = "a";
            else if (sCL == "f") sCT = "v";
            else if (sCL == "g") sCT = "k";
            else if (sCL == "h") sCT = "r";
            else if (sCL == "i") sCT = "e";
            else if (sCL == "j") sCT = "z";
            else if (sCL == "k") sCT = "g";
            else if (sCL == "l") sCT = "m";
            else if (sCL == "m") sCT = "s";
            else if (sCL == "n") sCT = "h";
            else if (sCL == "o") sCT = "u";
            else if (sCL == "p") sCT = "b";
            else if (sCL == "q") sCT = "x";
            else if (sCL == "r") sCT = "n";
            else if (sCL == "s") sCT = "c";
            else if (sCL == "t") sCT = "d";
            else if (sCL == "u") sCT = "i";
            else if (sCL == "v") sCT = "j";
            else if (sCL == "w") sCT = "f";
            else if (sCL == "x") sCT = "q";
            else if (sCL == "y") sCT = "o";
            else if (sCL == "z") sCT = "w";

            if (sCT == "")       sCT = sC;
            else if (sC == sCU)  sCT = GetStringUpperCase(sCT);
        }
        else
        {
            sCT = sC;
        }

        sTranslation += sCT;
    }

    return sTranslation;
}
//----------------------------------------------------------------
string gsLATranslateRost(string sString)
{
    string sColor       = gsLAGetLanguageColor(GS_LA_LANGUAGE_ROST);
    string sTranslation = sColor;
    string sC           = ""; //character
    string sCU          = ""; //character uppercase
    string sCL          = ""; //character lowercase
    string sCT          = ""; //character translation
    int nFlag           = TRUE;
    int nNth            = 0;
    int nCount          = GetStringLength(sString);

    for (; nNth < nCount; nNth++)
    {
        sC = GetSubString(sString, nNth, 1);

        if (sC == "*")
        {
            sC    = nFlag ? GS_LA_COLOR_EMOTE + "*" : "*" + sColor;
            nFlag = ! nFlag;
        }

        if (nFlag)
        {
            if (sC == "ä")       sC  = "a";
            else if (sC == "Ä")  sC  = "A";
            else if (sC == "ö")  sC  = "o";
            else if (sC == "Ö")  sC  = "O";
            else if (sC == "ü")  sC  = "u";
            else if (sC == "Ü")  sC  = "U";

            sCU = GetStringUpperCase(sC);
            sCL = GetStringLowerCase(sC);
            sCT = "";

            if (sCL == "a")      sCT = "e";
            else if (sCL == "b") sCT = "p";
            else if (sCL == "c") sCT = "s";
            else if (sCL == "d") sCT = "t";
            else if (sCL == "e") sCT = "i";
            else if (sCL == "f") sCT = "w";
            else if (sCL == "g") sCT = "k";
            else if (sCL == "h") sCT = "n";
            else if (sCL == "i") sCT = "u";
            else if (sCL == "j") sCT = "v";
            else if (sCL == "k") sCT = "g";
            else if (sCL == "l") sCT = "c";
            else if (sCL == "m") sCT = "l";
            else if (sCL == "n") sCT = "r";
            else if (sCL == "o") sCT = "y";
            else if (sCL == "p") sCT = "b";
            else if (sCL == "q") sCT = "x";
            else if (sCL == "r") sCT = "h";
            else if (sCL == "s") sCT = "m";
            else if (sCL == "t") sCT = "d";
            else if (sCL == "u") sCT = "o";
            else if (sCL == "v") sCT = "f";
            else if (sCL == "w") sCT = "z";
            else if (sCL == "x") sCT = "q";
            else if (sCL == "y") sCT = "a";
            else if (sCL == "z") sCT = "j";

            if (sCT == "")       sCT = sC;
            else if (sC == sCU)  sCT = GetStringUpperCase(sCT);
        }
        else
        {
            sCT = sC;
        }

        sTranslation += sCT;
    }

    return sTranslation;
}
//----------------------------------------------------------------
string gsLATranslateBosha(string sString)
{
    string sColor       = gsLAGetLanguageColor(GS_LA_LANGUAGE_BOSHA);
    string sTranslation = sColor;
    string sC           = ""; //character
    string sCU          = ""; //character uppercase
    string sCL          = ""; //character lowercase
    string sCT          = ""; //character translation
    int nFlag           = TRUE;
    int nNth            = 0;
    int nCount          = GetStringLength(sString);

    for (; nNth < nCount; nNth++)
    {
        sC = GetSubString(sString, nNth, 1);

        if (sC == "*")
        {
            sC    = nFlag ? GS_LA_COLOR_EMOTE + "*" : "*" + sColor;
            nFlag = ! nFlag;
        }

        if (nFlag)
        {
            if (sC == "ä")       sC  = "a";
            else if (sC == "Ä")  sC  = "A";
            else if (sC == "ö")  sC  = "o";
            else if (sC == "Ö")  sC  = "O";
            else if (sC == "ü")  sC  = "u";
            else if (sC == "Ü")  sC  = "U";

            sCU = GetStringUpperCase(sC);
            sCL = GetStringLowerCase(sC);
            sCT = "";

            if (sCL == "a")      sCT = "ha";
            else if (sCL == "b") sCT = "p";
            else if (sCL == "c") sCT = "z";
            else if (sCL == "d") sCT = "t";
            else if (sCL == "e") sCT = "o";
            else if (sCL == "f") sCT = "";
            else if (sCL == "g") sCT = "k";
            else if (sCL == "h") sCT = "r";
            else if (sCL == "i") sCT = "a";
            else if (sCL == "j") sCT = "m";
            else if (sCL == "k") sCT = "g";
            else if (sCL == "l") sCT = "h";
            else if (sCL == "m") sCT = "r";
            else if (sCL == "n") sCT = "k";
            else if (sCL == "o") sCT = "u";
            else if (sCL == "p") sCT = "b";
            else if (sCL == "q") sCT = "k";
            else if (sCL == "r") sCT = "h";
            else if (sCL == "s") sCT = "g";
            else if (sCL == "t") sCT = "n";
            else if (sCL == "u") sCT = "";
            else if (sCL == "v") sCT = "g";
            else if (sCL == "w") sCT = "r";
            else if (sCL == "x") sCT = "r";
            else if (sCL == "y") sCT = "'";
            else if (sCL == "z") sCT = "m";

            if (sCT == "")
            {
                sCT = sC;
            }
            else if (sC == sCU)
            {
                if (GetStringLength(sCT) == 1)
                    sCT = GetStringUpperCase(sCT);
                else
                    sCT = GetStringUpperCase(GetStringLeft(sCT, 1)) +
                          GetStringRight(sCT, 1);
            }
        }
        else
        {
            sCT = sC;
        }

        sTranslation += sCT;
    }

    return sTranslation;
}
//----------------------------------------------------------------
/*string gsLATranslateAnimal(string sString)
{
    string sColor       = gsLAGetLanguageColor(GS_LA_LANGUAGE_ANIMAL);
    string sTranslation = sColor;
    string sC           = ""; //character
    string sCL          = ""; //character lowercase
    string sCT          = ""; //character translation
    int nFlag           = TRUE;
    int nNth            = 0;
    int nCount          = GetStringLength(sString);

    for (; nNth < nCount; nNth++)
    {
        sC = GetSubString(sString, nNth, 1);

        if (sC == "*")
        {
            sC    = nFlag ? GS_LA_COLOR_EMOTE + "*" : "*" + sColor;
            nFlag = ! nFlag;
        }

        if (nFlag)
        {
            if (sC == "ä")       sC  = "a";
            else if (sC == "Ä")  sC  = "A";
            else if (sC == "ö")  sC  = "o";
            else if (sC == "Ö")  sC  = "O";
            else if (sC == "ü")  sC  = "u";
            else if (sC == "Ü")  sC  = "U";

            sCL = GetStringLowerCase(sC);

            if (sCL == "a")      sCT = "'";
            else if (sCL == "b") sCT = "'";
            else if (sCL == "c") sCT = "'";
            else if (sCL == "d") sCT = "'";
            else if (sCL == "e") sCT = "'";
            else if (sCL == "f") sCT = "'";
            else if (sCL == "g") sCT = "'";
            else if (sCL == "h") sCT = "'";
            else if (sCL == "i") sCT = "'";
            else if (sCL == "j") sCT = "'";
            else if (sCL == "k") sCT = "'";
            else if (sCL == "l") sCT = "'";
            else if (sCL == "m") sCT = "'";
            else if (sCL == "n") sCT = "'";
            else if (sCL == "o") sCT = "'";
            else if (sCL == "p") sCT = "'";
            else if (sCL == "q") sCT = "'";
            else if (sCL == "r") sCT = "'";
            else if (sCL == "s") sCT = "'";
            else if (sCL == "t") sCT = "'";
            else if (sCL == "u") sCT = "'";
            else if (sCL == "v") sCT = "'";
            else if (sCL == "w") sCT = "'";
            else if (sCL == "x") sCT = "'";
            else if (sCL == "y") sCT = "'";
            else if (sCL == "z") sCT = "'";
            else                 sCT = sC;
        }
        else
        {
            sCT = sC;
        }

        sTranslation += sCT;
    }

    return sTranslation;
}*/
//----------------------------------------------------------------
string gsLATranslateVeydish(string sString)
{
    string sColor = gsLAGetLanguageColor(GS_LA_LANGUAGE_VEYDISH);
    string sC     = GetStringLeft(sString, 1);
    string sCL    = GetStringLowerCase(sC);

    if (sCL == "a") return sColor + GS_T_16777370;
    if (sCL == "b") return sColor + GS_T_16777371;
    if (sCL == "c") return sColor + GS_T_16777372;
    if (sCL == "d") return sColor + GS_T_16777373;
    if (sCL == "e") return sColor + GS_T_16777374;
    if (sCL == "f") return sColor + GS_T_16777375;
    if (sCL == "g") return sColor + GS_T_16777376;
    if (sCL == "h") return sColor + GS_T_16777377;
    if (sCL == "i") return sColor + GS_T_16777378;
    if (sCL == "j") return sColor + GS_T_16777379;
    if (sCL == "k") return sColor + GS_T_16777380;
    if (sCL == "l") return sColor + GS_T_16777381;
    if (sCL == "m") return sColor + GS_T_16777382;
    if (sCL == "n") return sColor + GS_T_16777383;
    if (sCL == "o") return sColor + GS_T_16777384;
    if (sCL == "p") return sColor + GS_T_16777385;
    if (sCL == "q") return sColor + GS_T_16777386;
    if (sCL == "r") return sColor + GS_T_16777387;
    if (sCL == "s") return sColor + GS_T_16777388;
    if (sCL == "t") return sColor + GS_T_16777389;
    if (sCL == "u") return sColor + GS_T_16777390;
    if (sCL == "v") return sColor + GS_T_16777391;
    if (sCL == "w") return sColor + GS_T_16777392;
    if (sCL == "x") return sColor + GS_T_16777393;
    if (sCL == "y") return sColor + GS_T_16777394;
    if (sCL == "z") return sColor + GS_T_16777395;

    return sColor + GS_T_16777383;
}
//----------------------------------------------------------------
string gsLATranslateViveric(string sString)
{
    string sColor       = gsLAGetLanguageColor(GS_LA_LANGUAGE_VIVERIC);
    string sTranslation = sColor;
    string sC           = ""; //character
    string sCU          = ""; //character uppercase
    string sCL          = ""; //character lowercase
    string sCT          = ""; //character translation
    int nFlag           = TRUE;
    int nNth            = 0;
    int nCount          = GetStringLength(sString);

    for (; nNth < nCount; nNth++)
    {
        sC = GetSubString(sString, nNth, 1);

        if (sC == "*")
        {
            sC    = nFlag ? GS_LA_COLOR_EMOTE + "*" : "*" + sColor;
            nFlag = ! nFlag;
        }

        if (nFlag)
        {
            if (sC == "ä")       sC  = "a";
            else if (sC == "Ä")  sC  = "A";
            else if (sC == "ö")  sC  = "o";
            else if (sC == "Ö")  sC  = "O";
            else if (sC == "ü")  sC  = "u";
            else if (sC == "Ü")  sC  = "U";

            sCU = GetStringUpperCase(sC);
            sCL = GetStringLowerCase(sC);
            sCT = "";

            if (sCL == "a")      sCT = "il";
            else if (sCL == "b") sCT = "f";
            else if (sCL == "c") sCT = "st";
            else if (sCL == "d") sCT = "w";
            else if (sCL == "e") sCT = "a";
            else if (sCL == "f") sCT = "o";
            else if (sCL == "g") sCT = "v";
            else if (sCL == "h") sCT = "ir";
            else if (sCL == "i") sCT = "e";
            else if (sCL == "j") sCT = "vi";
            else if (sCL == "k") sCT = "go";
            else if (sCL == "l") sCT = "c";
            else if (sCL == "m") sCT = "li";
            else if (sCL == "n") sCT = "l";
            else if (sCL == "o") sCT = "e";
            else if (sCL == "p") sCT = "ty";
            else if (sCL == "q") sCT = "r";
            else if (sCL == "r") sCT = "m";
            else if (sCL == "s") sCT = "la";
            else if (sCL == "t") sCT = "an";
            else if (sCL == "u") sCT = "y";
            else if (sCL == "v") sCT = "el";
            else if (sCL == "w") sCT = "ky";
            else if (sCL == "x") sCT = "'";
            else if (sCL == "y") sCT = "a";
            else if (sCL == "z") sCT = "p'";

            if (sCT == "")
            {
                sCT = sC;
            }
            else if (sC == sCU)
            {
                if (GetStringLength(sCT) == 1)
                    sCT = GetStringUpperCase(sCT);
                else
                    sCT = GetStringUpperCase(GetStringLeft(sCT, 1)) +
                          GetStringRight(sCT, 1);
            }
        }
        else
        {
            sCT = sC;
        }

        sTranslation += sCT;
    }

    return sTranslation;
}
