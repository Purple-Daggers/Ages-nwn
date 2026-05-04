/* LANGUAGE Library by Gigaschatten */

#include "gs_inc_common"
#include "gs_inc_subrace"
#include "gs_inc_text"

//void main() {}

const string GS_LA_COLOR_EMOTE       = "<cþþþ>";

const int GS_LA_LANGUAGE_INVALID     = -1;
const int GS_LA_LANGUAGE_COMMON      =  0;
const int GS_LA_LANGUAGE_ABYSSAL     =  1;
const int GS_LA_LANGUAGE_ANIMAL      =  2;
const int GS_LA_LANGUAGE_CELESTIAL   =  3;
const int GS_LA_LANGUAGE_DRACONIC    =  4;
const int GS_LA_LANGUAGE_DWARVEN     =  5;
const int GS_LA_LANGUAGE_ELVEN       =  6;
const int GS_LA_LANGUAGE_GNOME       =  7;
const int GS_LA_LANGUAGE_GOBLIN      =  8;
const int GS_LA_LANGUAGE_HALFLING    =  9;
const int GS_LA_LANGUAGE_INFERNAL    = 10;
const int GS_LA_LANGUAGE_ORC         = 11;
const int GS_LA_LANGUAGE_SIGN        = 12;
const int GS_LA_LANGUAGE_THIEF       = 13;
const int GS_LA_LANGUAGE_UNDERCOMMON = 14;

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
//return sString translated to infernal language
string gsLATranslateInfernal(string sString);
//return sString translated to abyssal language
string gsLATranslateAbyssal(string sString);
//return sString translated to celestial language
string gsLATranslateCelestial(string sString);
//return sString translated to goblin language
string gsLATranslateGoblin(string sString);
//return sString translated to draconic language
string gsLATranslateDraconic(string sString);
//return sString translated to dwarf language
string gsLATranslateDwarven(string sString);
//return sString translated to elven language
string gsLATranslateElven(string sString);
//return sString translated to gnome language
string gsLATranslateGnome(string sString);
//return sString translated to halfling language
string gsLATranslateHalfling(string sString);
//return sString translated to orc language
string gsLATranslateOrc(string sString);
//return sString translated to animal language
string gsLATranslateAnimal(string sString);
//return sString translated to thief language
string gsLATranslateThief(string sString);
//return sString translated to undercommon language
string gsLATranslateUndercommon(string sString);

int gsLAGetCanSpeakLanguage(int nLanguage, object oPC = OBJECT_SELF)
{
    if (GetIsDM(oPC))            return TRUE;
    if (GetIsDMPossessed(oPC))   return TRUE;

    string sTag      = "GS_LA_LANGUAGE_" + IntToString(nLanguage);
    object oItem     = GetItemPossessedBy(oPC, sTag);
    if (GetIsObjectValid(oItem)) return TRUE;

    int nRace        = GetRacialType(oPC);
    int nSubRace     = gsSUGetSubRaceByName(GetSubRace(oPC));
    int nAlignmentGE = GetAlignmentGoodEvil(oPC);
    int nAlignmentLC = GetAlignmentLawChaos(oPC);

    switch (nLanguage)
    {
    case GS_LA_LANGUAGE_COMMON:
        return TRUE;

    case GS_LA_LANGUAGE_ABYSSAL:
        return nAlignmentGE == ALIGNMENT_EVIL &&
               nAlignmentLC != ALIGNMENT_LAWFUL &&
               (nSubRace == GS_SU_PLANETOUCHED_TIEFLING ||
                gsCMGetHasClass(CLASS_TYPE_CLERIC, oPC) ||
                gsCMGetHasClass(CLASS_TYPE_BLACKGUARD, oPC));

    case GS_LA_LANGUAGE_ANIMAL:
        return nSubRace == GS_SU_SPECIAL_FEY ||
               gsCMGetHasClass(CLASS_TYPE_DRUID, oPC) ||
               gsCMGetHasClass(CLASS_TYPE_RANGER, oPC);

    case GS_LA_LANGUAGE_CELESTIAL:
        return nSubRace == GS_SU_PLANETOUCHED_AASIMAR ||
               (nAlignmentGE == ALIGNMENT_GOOD &&
                gsCMGetHasClass(CLASS_TYPE_CLERIC, oPC)) ||
                gsCMGetHasClass(CLASS_TYPE_PALADIN, oPC);

    case GS_LA_LANGUAGE_DRACONIC:
        return nSubRace == GS_SU_SPECIAL_KOBOLD ||
               gsCMGetHasClass(CLASS_TYPE_DRAGON_DISCIPLE, oPC) ||
               gsCMGetHasClass(CLASS_TYPE_WIZARD, oPC);

    case GS_LA_LANGUAGE_DWARVEN:
        return nRace == RACIAL_TYPE_DWARF;

    case GS_LA_LANGUAGE_ELVEN:
        return nRace == RACIAL_TYPE_ELF ||
               nRace == RACIAL_TYPE_HALFELF;

    case GS_LA_LANGUAGE_GNOME:
        return nRace == RACIAL_TYPE_GNOME;

    case GS_LA_LANGUAGE_GOBLIN:
        return nSubRace == GS_SU_SPECIAL_GOBLIN;

    case GS_LA_LANGUAGE_HALFLING:
        return nRace == RACIAL_TYPE_HALFLING &&
               nSubRace != GS_SU_SPECIAL_FEY &&
               nSubRace != GS_SU_SPECIAL_GOBLIN &&
               nSubRace != GS_SU_SPECIAL_KOBOLD;

    case GS_LA_LANGUAGE_INFERNAL:
        return nAlignmentGE == ALIGNMENT_EVIL &&
               nAlignmentLC == ALIGNMENT_LAWFUL &&
               (nSubRace == GS_SU_PLANETOUCHED_TIEFLING ||
                gsCMGetHasClass(CLASS_TYPE_CLERIC, oPC) ||
                gsCMGetHasClass(CLASS_TYPE_BLACKGUARD, oPC));

    case GS_LA_LANGUAGE_ORC:
        return nRace == RACIAL_TYPE_HALFORC;

    case GS_LA_LANGUAGE_SIGN:
        return nSubRace == GS_SU_ELF_DROW;

    case GS_LA_LANGUAGE_THIEF:
        return gsCMGetHasClass(CLASS_TYPE_ROGUE, oPC);

    case GS_LA_LANGUAGE_UNDERCOMMON:
        return nSubRace == GS_SU_DWARF_GRAY ||
               nSubRace == GS_SU_ELF_DROW ||
               nSubRace == GS_SU_GNOME_DEEP ||
               nSubRace == GS_SU_SPECIAL_GOBLIN ||
               nSubRace == GS_SU_SPECIAL_KOBOLD;;
    }

    return FALSE;
}
//----------------------------------------------------------------
int gsLAGetLanguageByKey(string sKey)
{
    sKey = GetStringLowerCase(sKey);

    if (sKey == GS_T_16777530) return GS_LA_LANGUAGE_COMMON;
    if (sKey == GS_T_16777357) return GS_LA_LANGUAGE_ABYSSAL;
    if (sKey == GS_T_16777358) return GS_LA_LANGUAGE_ANIMAL;
    if (sKey == GS_T_16777359) return GS_LA_LANGUAGE_CELESTIAL;
    if (sKey == GS_T_16777360) return GS_LA_LANGUAGE_DRACONIC;
    if (sKey == GS_T_16777361) return GS_LA_LANGUAGE_DWARVEN;
    if (sKey == GS_T_16777362) return GS_LA_LANGUAGE_ELVEN;
    if (sKey == GS_T_16777363) return GS_LA_LANGUAGE_GNOME;
    if (sKey == GS_T_16777364) return GS_LA_LANGUAGE_GOBLIN;
    if (sKey == GS_T_16777365) return GS_LA_LANGUAGE_HALFLING;
    if (sKey == GS_T_16777366) return GS_LA_LANGUAGE_INFERNAL;
    if (sKey == GS_T_16777367) return GS_LA_LANGUAGE_ORC;
    if (sKey == GS_T_16777368) return GS_LA_LANGUAGE_SIGN;
    if (sKey == GS_T_16777369) return GS_LA_LANGUAGE_THIEF;
    if (sKey == GS_T_16777439) return GS_LA_LANGUAGE_UNDERCOMMON;

    return GS_LA_LANGUAGE_INVALID;
}
//----------------------------------------------------------------
string gsLAGetLanguageName(int nLanguage)
{
    switch (nLanguage)
    {
    case GS_LA_LANGUAGE_COMMON:      return GS_T_16777529;
    case GS_LA_LANGUAGE_ABYSSAL:     return GS_T_16777344;
    case GS_LA_LANGUAGE_ANIMAL:      return GS_T_16777355;
    case GS_LA_LANGUAGE_CELESTIAL:   return GS_T_16777345;
    case GS_LA_LANGUAGE_DRACONIC:    return GS_T_16777346;
    case GS_LA_LANGUAGE_DWARVEN:     return GS_T_16777347;
    case GS_LA_LANGUAGE_ELVEN:       return GS_T_16777348;
    case GS_LA_LANGUAGE_GNOME:       return GS_T_16777349;
    case GS_LA_LANGUAGE_GOBLIN:      return GS_T_16777350;
    case GS_LA_LANGUAGE_HALFLING:    return GS_T_16777351;
    case GS_LA_LANGUAGE_INFERNAL:    return GS_T_16777352;
    case GS_LA_LANGUAGE_ORC:         return GS_T_16777353;
    case GS_LA_LANGUAGE_SIGN:        return GS_T_16777356;
    case GS_LA_LANGUAGE_THIEF:       return GS_T_16777354;
    case GS_LA_LANGUAGE_UNDERCOMMON: return GS_T_16777440;
    }

    return "";
}
//----------------------------------------------------------------
string gsLAGetLanguageKey(int nLanguage)
{
    switch (nLanguage)
    {
    case GS_LA_LANGUAGE_COMMON:      return GS_T_16777530;
    case GS_LA_LANGUAGE_ABYSSAL:     return GS_T_16777357;
    case GS_LA_LANGUAGE_ANIMAL:      return GS_T_16777358;
    case GS_LA_LANGUAGE_CELESTIAL:   return GS_T_16777359;
    case GS_LA_LANGUAGE_DRACONIC:    return GS_T_16777360;
    case GS_LA_LANGUAGE_DWARVEN:     return GS_T_16777361;
    case GS_LA_LANGUAGE_ELVEN:       return GS_T_16777362;
    case GS_LA_LANGUAGE_GNOME:       return GS_T_16777363;
    case GS_LA_LANGUAGE_GOBLIN:      return GS_T_16777364;
    case GS_LA_LANGUAGE_HALFLING:    return GS_T_16777365;
    case GS_LA_LANGUAGE_INFERNAL:    return GS_T_16777366;
    case GS_LA_LANGUAGE_ORC:         return GS_T_16777367;
    case GS_LA_LANGUAGE_SIGN:        return GS_T_16777368;
    case GS_LA_LANGUAGE_THIEF:       return GS_T_16777369;
    case GS_LA_LANGUAGE_UNDERCOMMON: return GS_T_16777439;
    }

    return "";
}
//----------------------------------------------------------------
string gsLAGetLanguageColor(int nLanguage)
{
    switch (nLanguage)
    {
    case GS_LA_LANGUAGE_COMMON:      return "";
    case GS_LA_LANGUAGE_ABYSSAL:     return "<cT  >";
    case GS_LA_LANGUAGE_ANIMAL:      return "<c^|@>";
    case GS_LA_LANGUAGE_CELESTIAL:   return "<cþì•>";
    case GS_LA_LANGUAGE_DRACONIC:    return "<c»#K>";
    case GS_LA_LANGUAGE_DWARVEN:     return "<c‰‡y>";
    case GS_LA_LANGUAGE_ELVEN:       return "<cÊßt>";
    case GS_LA_LANGUAGE_GNOME:       return "<cÃ™V>";
    case GS_LA_LANGUAGE_GOBLIN:      return "<ct¦L>";
    case GS_LA_LANGUAGE_HALFLING:    return "<cÖ¹G>";
    case GS_LA_LANGUAGE_INFERNAL:    return "<c². >";
    case GS_LA_LANGUAGE_ORC:         return "<c]nD>";
    case GS_LA_LANGUAGE_SIGN:        return "<chYj>";
    case GS_LA_LANGUAGE_THIEF:       return "";
    case GS_LA_LANGUAGE_UNDERCOMMON: return "<c€2¡>";
    }

    return "";
}
//----------------------------------------------------------------
string gsLATranslate(string sString, int nLanguage)
{
    switch (nLanguage)
    {
    case GS_LA_LANGUAGE_COMMON:      return sString;
    case GS_LA_LANGUAGE_ABYSSAL:     return gsLATranslateAbyssal(sString);
    case GS_LA_LANGUAGE_ANIMAL:      return gsLATranslateAnimal(sString);
    case GS_LA_LANGUAGE_CELESTIAL:   return gsLATranslateCelestial(sString);
    case GS_LA_LANGUAGE_DRACONIC:    return gsLATranslateDraconic(sString);
    case GS_LA_LANGUAGE_DWARVEN:     return gsLATranslateDwarven(sString);
    case GS_LA_LANGUAGE_ELVEN:       return gsLATranslateElven(sString);
    case GS_LA_LANGUAGE_GNOME:       return gsLATranslateGnome(sString);
    case GS_LA_LANGUAGE_GOBLIN:      return gsLATranslateGoblin(sString);
    case GS_LA_LANGUAGE_HALFLING:    return gsLATranslateHalfling(sString);
    case GS_LA_LANGUAGE_INFERNAL:    return gsLATranslateInfernal(sString);
    case GS_LA_LANGUAGE_ORC:         return gsLATranslateOrc(sString);
    case GS_LA_LANGUAGE_SIGN:        return gsLATranslateSign();
    case GS_LA_LANGUAGE_THIEF:       return gsLATranslateThief(sString);
    case GS_LA_LANGUAGE_UNDERCOMMON: return gsLATranslateUndercommon(sString);
    }

    return sString;
}
//----------------------------------------------------------------
string gsLATranslateSign()
{
    return gsLAGetLanguageColor(GS_LA_LANGUAGE_SIGN) + GS_T_16777403;
}
//----------------------------------------------------------------
string gsLATranslateInfernal(string sString)
{
    string sColor       = gsLAGetLanguageColor(GS_LA_LANGUAGE_INFERNAL);
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
string gsLATranslateAbyssal(string sString)
{
    string sColor       = gsLAGetLanguageColor(GS_LA_LANGUAGE_ABYSSAL);
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
string gsLATranslateCelestial(string sString)
{
    string sColor       = gsLAGetLanguageColor(GS_LA_LANGUAGE_CELESTIAL);
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
string gsLATranslateGoblin(string sString)
{
    string sColor       = gsLAGetLanguageColor(GS_LA_LANGUAGE_GOBLIN);
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
string gsLATranslateDraconic(string sString)
{
    string sColor       = gsLAGetLanguageColor(GS_LA_LANGUAGE_DRACONIC);
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
string gsLATranslateDwarven(string sString)
{
    string sColor       = gsLAGetLanguageColor(GS_LA_LANGUAGE_DWARVEN);
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
string gsLATranslateElven(string sString)
{
    string sColor       = gsLAGetLanguageColor(GS_LA_LANGUAGE_ELVEN);
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
string gsLATranslateGnome(string sString)
{
    string sColor       = gsLAGetLanguageColor(GS_LA_LANGUAGE_GNOME);
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
string gsLATranslateHalfling(string sString)
{
    string sColor       = gsLAGetLanguageColor(GS_LA_LANGUAGE_HALFLING);
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
string gsLATranslateOrc(string sString)
{
    string sColor       = gsLAGetLanguageColor(GS_LA_LANGUAGE_ORC);
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
string gsLATranslateAnimal(string sString)
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
}
//----------------------------------------------------------------
string gsLATranslateThief(string sString)
{
    string sColor = gsLAGetLanguageColor(GS_LA_LANGUAGE_THIEF);
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
string gsLATranslateUndercommon(string sString)
{
    string sColor       = gsLAGetLanguageColor(GS_LA_LANGUAGE_UNDERCOMMON);
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
