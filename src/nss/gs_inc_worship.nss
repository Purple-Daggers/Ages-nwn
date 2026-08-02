/* WORSHIP Library by Gigaschatten */

#include "gs_inc_boss"
#include "gs_inc_common"
#include "gs_inc_spell"
#include "gs_inc_state"
#include "gs_inc_text"
#include "gs_inc_time"
#include "gs_inc_xp"

//void main() {}

const string GS_WORSHIP_DATABASE = "GS_WORSHIP";

const int GS_WO_TIMEOUT_FAVOR        = 3600; //TIME UPDATE: 1 hour
const int GS_WO_TIMEOUT_RESURRECTION = 14400; //TIME UPDATE: 4 hours

const int GS_WO_COST_LESSER_FAVOR    =     5;
const int GS_WO_COST_GREATER_FAVOR   =    10;
const int GS_WO_COST_RESURRECTION    =    25;

const int GS_WO_PENALTY_PER_LEVEL    =    15;

const int GS_WO_NONE                 =    -1;
const int GS_WO_AKADI                =     1;
const int GS_WO_AURIL                =     2;
const int GS_WO_AZUTH                =     3;
const int GS_WO_BANE                 =     4;
const int GS_WO_BESHABA              =     5;
const int GS_WO_CHAUNTEA             =     6;
const int GS_WO_CYRIC                =     7;
const int GS_WO_DENEIR               =     8;
const int GS_WO_EILISTRAEE           =     9;
const int GS_WO_ELDATH               =    10;
const int GS_WO_FINDER_WYVERNSPUR    =    11;
const int GS_WO_GARAGOS              =    12;
const int GS_WO_GARGAUTH             =    13;
const int GS_WO_GOND                 =    14;
const int GS_WO_GRUMBAR              =    15;
const int GS_WO_GWAERON_WINDSTROM    =    16;
const int GS_WO_HELM                 =    17;
const int GS_WO_HOAR                 =    18;
const int GS_WO_ILMATER              =    19;
const int GS_WO_ISTISHIA             =    20;
const int GS_WO_JERGAL               =    21;
const int GS_WO_KELEMVOR             =    22;
const int GS_WO_KOSSUTH              =    23;
const int GS_WO_LATHANDER            =    24;
const int GS_WO_LLIIRA               =    25;
const int GS_WO_LOLTH                =    26;
const int GS_WO_LOVIATAR             =    27;
const int GS_WO_LURUE                =    28;
const int GS_WO_MALAR                =    29;
const int GS_WO_MASK                 =    30;
const int GS_WO_MIELIKKI             =    31;
const int GS_WO_MILIL                =    32;
const int GS_WO_MYSTRA               =    33;
const int GS_WO_NOBANION             =    34;
const int GS_WO_OGHMA                =    35;
const int GS_WO_RED_KNIGHT           =    36;
const int GS_WO_SAVRAS               =    37;
const int GS_WO_SELUNE               =    38;
const int GS_WO_SHAR                 =    39;
const int GS_WO_SHARESS              =    40;
const int GS_WO_SHAUNDAKUL           =    41;
const int GS_WO_SHIALLIA             =    42;
const int GS_WO_SIAMORPHE            =    43;
const int GS_WO_SILVANUS             =    44;
const int GS_WO_SUNE                 =    45;
const int GS_WO_TALONA               =    46;
const int GS_WO_TALOS                =    47;
const int GS_WO_TEMPUS               =    48;
const int GS_WO_TIAMAT               =    49;
const int GS_WO_TORM                 =    50;
const int GS_WO_TYMORA               =    51;
const int GS_WO_TYR                  =    52;
const int GS_WO_UBTAO                =    53;
const int GS_WO_ULUTIU               =    54;
const int GS_WO_UMBERLEE             =    55;
const int GS_WO_UTHGAR               =    56;
const int GS_WO_VALKUR               =    57;
const int GS_WO_VELSHAROON           =    58;
const int GS_WO_WAUKEEN              =    59;

//return TRUE if nDeity is available for oPlayer
int gsWOGetIsDeityAvailable(int nDeity, object oPlayer = OBJECT_SELF);
//return deity constant resembling sDeity
int gsWOGetDeityByName(string sDeity);
//return name of nDeity
string gsWOGetNameByDeity(int nDeity);
//return presence of sDeity (0-100)
int gsWOGetPresence(string sDeity);
//adjust presence of sDeity by nAmount
void gsWOAdjustPresence(string sDeity, int nAmount);
//process all deities presence
void gsWOProcessPresence();
//return power of sDeity (0-100)
int gsWOGetPower(string sDeity);
//adjust power of sDeity by nAmount
void gsWOAdjustPower(string sDeity, int nAmount);
//process all deities power
void gsWOProcessPower();
//return TRUE if deity grants favor to oTarget
int gsWOGrantFavor(object oTarget = OBJECT_SELF);
//return TRUE if deity resurrects oTarget
int gsWOGrantResurrection(object oTarget = OBJECT_SELF);

int gsWOGetIsDeityAvailable(int nDeity, object oPlayer = OBJECT_SELF)
{
    if (GetIsDM(oPlayer)) return TRUE;

    string sAlignment = "";

    switch (GetAlignmentLawChaos(oPlayer))
    {
    case ALIGNMENT_LAWFUL:  sAlignment = "L"; break;
    case ALIGNMENT_NEUTRAL: sAlignment = "N"; break;
    case ALIGNMENT_CHAOTIC: sAlignment = "C"; break;
    }

    switch (GetAlignmentGoodEvil(oPlayer))
    {
    case ALIGNMENT_GOOD:    sAlignment += "G"; break;
    case ALIGNMENT_NEUTRAL: sAlignment += "N"; break;
    case ALIGNMENT_EVIL:    sAlignment += "E"; break;
    }

    switch (nDeity)
    {
    case GS_WO_NONE:
        return TRUE;

    case GS_WO_AKADI:
        return sAlignment == "CN" ||
               sAlignment == "LN" ||
               sAlignment == "NE";

    case GS_WO_AURIL:
        return sAlignment == "CN" ||
               sAlignment == "LN" ||
               sAlignment == "NE";

    case GS_WO_AZUTH:
        return sAlignment == "LE" ||
               sAlignment == "LG" ||
               sAlignment == "LN";

    case GS_WO_BANE:
        return sAlignment == "LN" ||
               sAlignment == "LE" ||
               sAlignment == "NE";

    case GS_WO_BESHABA:
        return sAlignment == "CE" ||
               sAlignment == "CN" ||
               sAlignment == "NE";

    case GS_WO_CHAUNTEA:
        return sAlignment == "CG" ||
               sAlignment == "LG" ||
               sAlignment == "NN" ||
               sAlignment == "NG";

    case GS_WO_CYRIC:
        return sAlignment == "CE" ||
               sAlignment == "CN" ||
               sAlignment == "NE";

    case GS_WO_DENEIR:
        return sAlignment == "CG" ||
               sAlignment == "LG" ||
               sAlignment == "NG";

    case GS_WO_EILISTRAEE:
        return sAlignment == "CG" ||
               sAlignment == "CN" ||
               sAlignment == "NG";

    case GS_WO_ELDATH:
        return sAlignment == "CG" ||
               sAlignment == "CN" ||
               sAlignment == "NG";

    case GS_WO_FINDER_WYVERNSPUR:
        return sAlignment == "CE" ||
               sAlignment == "CG" ||
               sAlignment == "CN";

    case GS_WO_GARAGOS:
        return sAlignment == "CE" ||
               sAlignment == "CG" ||
               sAlignment == "CN";

    case GS_WO_GARGAUTH:
        return sAlignment == "LE" ||
               sAlignment == "LN" ||
               sAlignment == "NE";

    case GS_WO_GOND:
        return TRUE;

    case GS_WO_GRUMBAR:
        return sAlignment == "CN" ||
               sAlignment == "NN" ||
               sAlignment == "NE" ||
               sAlignment == "NG" ||
               sAlignment == "LN";

    case GS_WO_GWAERON_WINDSTROM:
        return sAlignment == "CG" ||
               sAlignment == "LG" ||
               sAlignment == "NG";

    case GS_WO_HELM:
        return sAlignment == "LE" ||
               sAlignment == "LG" ||
               sAlignment == "LN";

    case GS_WO_HOAR:
        return sAlignment == "LE" ||
               sAlignment == "LG" ||
               sAlignment == "LN";

    case GS_WO_ILMATER:
        return sAlignment == "LG" ||
               sAlignment == "LN" ||
               sAlignment == "NG";

    case GS_WO_ISTISHIA:
        return sAlignment == "CN" ||
               sAlignment == "NN" ||
               sAlignment == "NE" ||
               sAlignment == "LN";

    case GS_WO_JERGAL:
        return sAlignment == "LE" ||
               sAlignment == "LG" ||
               sAlignment == "LN";

    case GS_WO_KELEMVOR:
        return sAlignment == "LG" ||
               sAlignment == "LN" ||
               sAlignment == "NG";

    case GS_WO_KOSSUTH:
        return sAlignment == "CN" ||
               sAlignment == "LE" ||
               sAlignment == "LG" ||
               sAlignment == "LN" ||
               sAlignment == "NN" ||
               sAlignment == "NE" ||
               sAlignment == "NG";

    case GS_WO_LATHANDER:
        return sAlignment == "CG" ||
               sAlignment == "LG" ||
               sAlignment == "NG";

    case GS_WO_LLIIRA:
        return sAlignment == "CG" ||
               sAlignment == "CN" ||
               sAlignment == "NG";

    case GS_WO_LOLTH:
        return sAlignment == "CE" ||
               sAlignment == "CN" ||
               sAlignment == "NE";

    case GS_WO_LOVIATAR:
        return sAlignment == "LE" ||
               sAlignment == "LN" ||
               sAlignment == "NE";

    case GS_WO_LURUE:
        return sAlignment == "CG" ||
               sAlignment == "CN" ||
               sAlignment == "NG";

    case GS_WO_MALAR:
        return sAlignment == "CE" ||
               sAlignment == "CN" ||
               sAlignment == "NE";

    case GS_WO_MASK:
        return sAlignment == "CE" ||
               sAlignment == "LE" ||
               sAlignment == "NE";

    case GS_WO_MIELIKKI:
        return sAlignment == "CG" ||
               sAlignment == "LG" ||
               sAlignment == "NG";

    case GS_WO_MILIL:
        return sAlignment == "CG" ||
               sAlignment == "LG" ||
               sAlignment == "NG";

    case GS_WO_MYSTRA:
        return sAlignment == "CG" ||
               sAlignment == "LE" ||
               sAlignment == "LG" ||
               sAlignment == "LN" ||
               sAlignment == "NG";

    case GS_WO_NOBANION:
        return sAlignment == "LG" ||
               sAlignment == "LN" ||
               sAlignment == "NG";

    case GS_WO_OGHMA:
        return TRUE;

    case GS_WO_RED_KNIGHT:
        return sAlignment == "LE" ||
               sAlignment == "LG" ||
               sAlignment == "LN";

    case GS_WO_SAVRAS:
        return sAlignment == "LE" ||
               sAlignment == "LG" ||
               sAlignment == "LN";

    case GS_WO_SELUNE:
        return sAlignment == "CG" ||
               sAlignment == "CN" ||
               sAlignment == "NG";

    case GS_WO_SHAR:
        return sAlignment == "CE" ||
               sAlignment == "LE" ||
               sAlignment == "NE";

    case GS_WO_SHARESS:
        return sAlignment == "CG" ||
               sAlignment == "CN" ||
               sAlignment == "NG";

    case GS_WO_SHAUNDAKUL:
        return sAlignment == "CE" ||
               sAlignment == "CG" ||
               sAlignment == "CN";

    case GS_WO_SHIALLIA:
        return sAlignment == "CG" ||
               sAlignment == "LG" ||
               sAlignment == "NG";

    case GS_WO_SIAMORPHE:
        return sAlignment == "LE" ||
               sAlignment == "LG" ||
               sAlignment == "LN";

    case GS_WO_SILVANUS:
        return sAlignment == "CN" ||
               sAlignment == "LN" ||
               sAlignment == "NN" ||
               sAlignment == "NE" ||
               sAlignment == "NG";

    case GS_WO_SUNE:
        return sAlignment == "CG" ||
               sAlignment == "CN" ||
               (sAlignment == "LG" &&
                gsCMGetHasClass(CLASS_TYPE_PALADIN, oPlayer)) ||
               sAlignment == "NG";

    case GS_WO_TALONA:
        return sAlignment == "CE" ||
               sAlignment == "CN" ||
               sAlignment == "NE";

    case GS_WO_TALOS:
        return sAlignment == "CE" ||
               sAlignment == "CN" ||
               sAlignment == "NE";

    case GS_WO_TEMPUS:
        return sAlignment == "CE" ||
               sAlignment == "CG" ||
               sAlignment == "CN";

    case GS_WO_TIAMAT:
        return sAlignment == "LE" ||
               sAlignment == "LN" ||
               sAlignment == "NE";

    case GS_WO_TORM:
        return sAlignment == "LG" ||
               sAlignment == "LN" ||
               sAlignment == "NG";

    case GS_WO_TYMORA:
        return sAlignment == "CG" ||
               sAlignment == "CN" ||
               sAlignment == "NG";

    case GS_WO_TYR:
        return sAlignment == "LG" ||
               sAlignment == "LN" ||
               sAlignment == "NG";

    case GS_WO_UBTAO:
        return sAlignment == "CN" ||
               sAlignment == "NN" ||
               sAlignment == "NE" ||
               sAlignment == "NG" ||
               sAlignment == "LN";

    case GS_WO_ULUTIU:
        return sAlignment == "LE" ||
               sAlignment == "LG" ||
               sAlignment == "LN";

    case GS_WO_UMBERLEE:
        return sAlignment == "CE" ||
               sAlignment == "CN" ||
               sAlignment == "NE";

    case GS_WO_UTHGAR:
        return sAlignment == "CG" ||
               sAlignment == "CE" ||
               sAlignment == "CN" ||
               sAlignment == "NN" ||
               sAlignment == "NG";

    case GS_WO_VALKUR:
        return sAlignment == "CG" ||
               sAlignment == "CN" ||
               sAlignment == "NG";

    case GS_WO_VELSHAROON:
        return sAlignment == "CN" ||
               sAlignment == "LN" ||
               sAlignment == "NE";

    case GS_WO_WAUKEEN:
        return sAlignment == "CN" ||
               sAlignment == "LN" ||
               sAlignment == "NN" ||
               sAlignment == "NE" ||
               sAlignment == "NG";
    }

    return FALSE;
}
//----------------------------------------------------------------
int gsWOGetDeityByName(string sDeity)
{
    if (sDeity == "")                  return GS_WO_NONE;
    if (sDeity == "Akadi")             return GS_WO_AKADI;
    if (sDeity == "Auril")             return GS_WO_AURIL;
    if (sDeity == "Azuth")             return GS_WO_AZUTH;
    if (sDeity == "Bane")              return GS_WO_BANE;
    if (sDeity == "Beshaba")           return GS_WO_BESHABA;
    if (sDeity == "Chauntea")          return GS_WO_CHAUNTEA;
    if (sDeity == "Cyric")             return GS_WO_CYRIC;
    if (sDeity == "Deneir")            return GS_WO_DENEIR;
    if (sDeity == "Eilistraee")        return GS_WO_EILISTRAEE;
    if (sDeity == "Eldath")            return GS_WO_ELDATH;
    if (sDeity == "Finder Wyvernspur") return GS_WO_FINDER_WYVERNSPUR;
    if (sDeity == "Garagos")           return GS_WO_GARAGOS;
    if (sDeity == "Gargauth")          return GS_WO_GARGAUTH;
    if (sDeity == "Gond")              return GS_WO_GOND;
    if (sDeity == "Grumbar")           return GS_WO_GRUMBAR;
    if (sDeity == "Gwaeron Windstrom") return GS_WO_GWAERON_WINDSTROM;
    if (sDeity == "Helm")              return GS_WO_HELM;
    if (sDeity == "Hoar")              return GS_WO_HOAR;
    if (sDeity == "Ilmater")           return GS_WO_ILMATER;
    if (sDeity == "Istishia")          return GS_WO_ISTISHIA;
    if (sDeity == "Jergal")            return GS_WO_JERGAL;
    if (sDeity == "Kelemvor")          return GS_WO_KELEMVOR;
    if (sDeity == "Kossuth")           return GS_WO_KOSSUTH;
    if (sDeity == "Lathander")         return GS_WO_LATHANDER;
    if (sDeity == "Lliira")            return GS_WO_LLIIRA;
    if (sDeity == "Lolth")             return GS_WO_LOLTH;
    if (sDeity == "Loviatar")          return GS_WO_LOVIATAR;
    if (sDeity == "Lurue")             return GS_WO_LURUE;
    if (sDeity == "Malar")             return GS_WO_MALAR;
    if (sDeity == "Mask")              return GS_WO_MASK;
    if (sDeity == "Mielikki")          return GS_WO_MIELIKKI;
    if (sDeity == "Milil")             return GS_WO_MILIL;
    if (sDeity == "Mystra")            return GS_WO_MYSTRA;
    if (sDeity == "Nobanion")          return GS_WO_NOBANION;
    if (sDeity == "Oghma")             return GS_WO_OGHMA;
    if (sDeity == "Red Knight")        return GS_WO_RED_KNIGHT;
    if (sDeity == "Savras")            return GS_WO_SAVRAS;
    if (sDeity == "Selune")            return GS_WO_SELUNE;
    if (sDeity == "Shar")              return GS_WO_SHAR;
    if (sDeity == "Sharess")           return GS_WO_SHARESS;
    if (sDeity == "Shaundakul")        return GS_WO_SHAUNDAKUL;
    if (sDeity == "Shiallia")          return GS_WO_SHIALLIA;
    if (sDeity == "Siamorphe")         return GS_WO_SIAMORPHE;
    if (sDeity == "Silvanus")          return GS_WO_SILVANUS;
    if (sDeity == "Sune")              return GS_WO_SUNE;
    if (sDeity == "Talona")            return GS_WO_TALONA;
    if (sDeity == "Talos")             return GS_WO_TALOS;
    if (sDeity == "Tempus")            return GS_WO_TEMPUS;
    if (sDeity == "Tiamat")            return GS_WO_TIAMAT;
    if (sDeity == "Torm")              return GS_WO_TORM;
    if (sDeity == "Tymora")            return GS_WO_TYMORA;
    if (sDeity == "Tyr")               return GS_WO_TYR;
    if (sDeity == "Ubtao")             return GS_WO_UBTAO;
    if (sDeity == "Ulutiu")            return GS_WO_ULUTIU;
    if (sDeity == "Umberlee")          return GS_WO_UMBERLEE;
    if (sDeity == "Uthgar")            return GS_WO_UTHGAR;
    if (sDeity == "Valkur")            return GS_WO_VALKUR;
    if (sDeity == "Velsharoon")        return GS_WO_VELSHAROON;
    if (sDeity == "Waukeen")           return GS_WO_WAUKEEN;

    return FALSE;
}
//----------------------------------------------------------------
string gsWOGetNameByDeity(int nDeity)
{
    switch (nDeity)
    {
    case GS_WO_AKADI:             return "Akadi";
    case GS_WO_AURIL:             return "Auril";
    case GS_WO_AZUTH:             return "Azuth";
    case GS_WO_BANE:              return "Bane";
    case GS_WO_BESHABA:           return "Beshaba";
    case GS_WO_CHAUNTEA:          return "Chauntea";
    case GS_WO_CYRIC:             return "Cyric";
    case GS_WO_DENEIR:            return "Deneir";
    case GS_WO_EILISTRAEE:        return "Eilistraee";
    case GS_WO_ELDATH:            return "Eldath";
    case GS_WO_FINDER_WYVERNSPUR: return "Finder Wyvernspur";
    case GS_WO_GARAGOS:           return "Garagos";
    case GS_WO_GARGAUTH:          return "Gargauth";
    case GS_WO_GOND:              return "Gond";
    case GS_WO_GRUMBAR:           return "Grumbar";
    case GS_WO_GWAERON_WINDSTROM: return "Gwaeron Windstrom";
    case GS_WO_HELM:              return "Helm";
    case GS_WO_HOAR:              return "Hoar";
    case GS_WO_ILMATER:           return "Ilmater";
    case GS_WO_ISTISHIA:          return "Istishia";
    case GS_WO_JERGAL:            return "Jergal";
    case GS_WO_KELEMVOR:          return "Kelemvor";
    case GS_WO_KOSSUTH:           return "Kossuth";
    case GS_WO_LATHANDER:         return "Lathander";
    case GS_WO_LLIIRA:            return "Lliira";
    case GS_WO_LOLTH:             return "Lolth";
    case GS_WO_LOVIATAR:          return "Loviatar";
    case GS_WO_LURUE:             return "Lurue";
    case GS_WO_MALAR:             return "Malar";
    case GS_WO_MASK:              return "Mask";
    case GS_WO_MIELIKKI:          return "Mielikki";
    case GS_WO_MILIL:             return "Milil";
    case GS_WO_MYSTRA:            return "Mystra";
    case GS_WO_NOBANION:          return "Nobanion";
    case GS_WO_OGHMA:             return "Oghma";
    case GS_WO_RED_KNIGHT:        return "Red Knight";
    case GS_WO_SAVRAS:            return "Savras";
    case GS_WO_SELUNE:            return "Selune";
    case GS_WO_SHAR:              return "Shar";
    case GS_WO_SHARESS:           return "Sharess";
    case GS_WO_SHAUNDAKUL:        return "Shaundakul";
    case GS_WO_SHIALLIA:          return "Shiallia";
    case GS_WO_SIAMORPHE:         return "Siamorphe";
    case GS_WO_SILVANUS:          return "Silvanus";
    case GS_WO_SUNE:              return "Sune";
    case GS_WO_TALONA:            return "Talona";
    case GS_WO_TALOS:             return "Talos";
    case GS_WO_TEMPUS:            return "Tempus";
    case GS_WO_TIAMAT:            return "Tiamat";
    case GS_WO_TORM:              return "Torm";
    case GS_WO_TYMORA:            return "Tymora";
    case GS_WO_TYR:               return "Tyr";
    case GS_WO_UBTAO:             return "Ubtao";
    case GS_WO_ULUTIU:            return "Ulutiu";
    case GS_WO_UMBERLEE:          return "Umberlee";
    case GS_WO_UTHGAR:            return "Uthgar";
    case GS_WO_VALKUR:            return "Valkur";
    case GS_WO_VELSHAROON:        return "Velsharoon";
    case GS_WO_WAUKEEN:           return "Waukeen";
    }

    return "";
}
//----------------------------------------------------------------
int gsWOGetPresence(string sDeity)
{
    if (sDeity == "") return FALSE;

    object oModule = GetModule();
    int nPresence  = GetLocalInt(oModule, "GS_WO_PR_" + sDeity);

    if (! nPresence)
    {
        sqlquery sqlGetPresence = SqlPrepareQueryCampaign(GS_WORSHIP_DATABASE, "SELECT presence from deities WHERE name = @name");
        SqlBindString(sqlGetPresence, "@name", sDeity);
        if(SqlStep(sqlGetPresence))
        {
            nPresence = SqlGetInt(sqlGetPresence, 0) + 1;
        } else {
            nPresence = 1;
        }
        //nPresence = GetCampaignInt("GS_WO_PRESENCE", sDeity) + 1;
        SetLocalInt(oModule, "GS_WO_PR_" + sDeity, nPresence);
    }

    return nPresence - 1;
}
//----------------------------------------------------------------
void gsWOAdjustPresence(string sDeity, int nAmount)
{
    if (sDeity == "")       return;
    if (! nAmount)          return;

    int nPresence  = gsWOGetPresence(sDeity);
    nAmount       += nPresence;

    if (nAmount < 0)        nAmount =   0;
    else if (nAmount > 100) nAmount = 100;

    if (nPresence != nAmount)
    {
        SetLocalInt(GetModule(), "GS_WO_PR_" + sDeity, nAmount + 1);
        sqlquery sqlSetPresence = SqlPrepareQueryCampaign(GS_WORSHIP_DATABASE, "INSERT INTO deities (name, presence) VALUES (@name, @presence) ON CONFLICT (name) DO UPDATE SET presence = excluded.presence;");
        SqlBindString(sqlSetPresence, "@name", sDeity);
        SqlBindInt(sqlSetPresence, "@presence", nAmount);
        SqlStep(sqlSetPresence);
        //SetCampaignInt("GS_WO_PRESENCE", sDeity, nAmount);
    }
}
//----------------------------------------------------------------
void gsWOProcessPresence()
{
    int nNth = 1;

    for (; nNth <= 59; nNth++)
        gsWOAdjustPresence(gsWOGetNameByDeity(nNth), -1);
}
//----------------------------------------------------------------
int gsWOGetPower(string sDeity)
{
    if (sDeity == "") return FALSE;

    object oModule = GetModule();
    int nPower     = GetLocalInt(oModule, "GS_WO_PO_" + sDeity);

    if (! nPower)
    {
        sqlquery sqlGetPower = SqlPrepareQueryCampaign(GS_WORSHIP_DATABASE, "SELECT power from deities WHERE name = @name");
        SqlBindString(sqlGetPower, "@name", sDeity);
        if(SqlStep(sqlGetPower))
        {
            nPower = SqlGetInt(sqlGetPower, 0) + 1;
        } else {
            nPower = 1;
        }
        //nPower = GetCampaignInt("GS_WO_POWER", sDeity) + 1;
        SetLocalInt(oModule, "GS_WO_PO_" + sDeity, nPower);
    }

    return nPower - 1;
}
//----------------------------------------------------------------
void gsWOAdjustPower(string sDeity, int nAmount)
{
    if (sDeity == "")       return;
    if (! nAmount)          return;

    int nPower  = gsWOGetPower(sDeity);
    nAmount    += nPower;

    if (nAmount < 0)        nAmount =   0;
    else if (nAmount > 100) nAmount = 100;

    if (nPower != nAmount)
    {
        sqlquery sqlSetPower = SqlPrepareQueryCampaign(GS_WORSHIP_DATABASE, "INSERT INTO deities (name, power) VALUES (@name, @power) ON CONFLICT (name) DO UPDATE SET power = excluded.power;");
        SqlBindString(sqlSetPower, "@name", sDeity);
        SqlBindInt(sqlSetPower, "@power", nAmount);
        SqlStep(sqlSetPower);
        SetLocalInt(GetModule(), "GS_WO_PO_" + sDeity, nAmount + 1);
        //SetCampaignInt("GS_WO_POWER", sDeity, nAmount);
    }
}
//----------------------------------------------------------------
void gsWOProcessPower()
{
    string sDeity = "";
    int nPresence = 0;
    int nNth      = 1;

    for (; nNth <= 59; nNth++)
    {
        sDeity    = gsWOGetNameByDeity(nNth);
        nPresence = gsWOGetPresence(sDeity);

        if (nPresence >= 10) gsWOAdjustPower(sDeity, nPresence / 10);
        else                 gsWOAdjustPower(sDeity, -100);
    }
}
//----------------------------------------------------------------
int gsWOGrantFavor(object oTarget = OBJECT_SELF)
{
    //deity
    string sDeity  = GetDeity(oTarget);

    if (sDeity == "")
    {
        FloatingTextStringOnCreature(GS_T_16777282, oTarget, FALSE);
        return FALSE;
    }

    //timeout
    int nTimestamp = gsTIGetActualTimestamp();

    if (GetLocalInt(oTarget, "GS_WO_TIMEOUT_FAVOR") > nTimestamp)
    {
        FloatingTextStringOnCreature(gsCMReplaceString(GS_T_16777283, sDeity), oTarget, FALSE);
        return FALSE;
    }

    SetLocalInt(oTarget, "GS_WO_TIMEOUT_FAVOR", nTimestamp + GS_WO_TIMEOUT_FAVOR);

    //presence
    int nPresence  = gsWOGetPresence(sDeity);

    if (Random(100) >= nPresence)
    {
        FloatingTextStringOnCreature(gsCMReplaceString(GS_T_16777284, sDeity), oTarget, FALSE);
        return FALSE;
    }

    int nPower     = gsWOGetPower(sDeity);
    int nFlag      = FALSE;

    //greater favor
    if (nPower >= GS_WO_COST_GREATER_FAVOR)
    {
        //remove negative effects
        effect eEffect = GetFirstEffect(oTarget);
        int nHitDice   = GetHitDice(oTarget);

        while (GetIsEffectValid(eEffect))
        {
            switch (GetEffectType(eEffect))
            {
            case EFFECT_TYPE_ABILITY_DECREASE:
            case EFFECT_TYPE_AC_DECREASE:
            case EFFECT_TYPE_ARCANE_SPELL_FAILURE:
            case EFFECT_TYPE_ATTACK_DECREASE:
            case EFFECT_TYPE_BLINDNESS:
            case EFFECT_TYPE_CHARMED:
            case EFFECT_TYPE_CONFUSED:
            case EFFECT_TYPE_CURSE:
            case EFFECT_TYPE_DAMAGE_DECREASE:
            case EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE:
            case EFFECT_TYPE_DAZED:
            case EFFECT_TYPE_DEAF:
            case EFFECT_TYPE_DISEASE:
            case EFFECT_TYPE_DOMINATED:
            case EFFECT_TYPE_ENTANGLE:
            case EFFECT_TYPE_FRIGHTENED:
            case EFFECT_TYPE_NEGATIVELEVEL:
            case EFFECT_TYPE_PARALYZE:
            case EFFECT_TYPE_PETRIFY:
            case EFFECT_TYPE_POISON:
            case EFFECT_TYPE_SAVING_THROW_DECREASE:
            case EFFECT_TYPE_SKILL_DECREASE:
            case EFFECT_TYPE_SLEEP:
            case EFFECT_TYPE_SLOW:
            case EFFECT_TYPE_SPELL_FAILURE:
            case EFFECT_TYPE_SPELL_RESISTANCE_DECREASE:
            case EFFECT_TYPE_STUNNED:
                if (GetEffectSubType(eEffect) != SUBTYPE_EXTRAORDINARY)
                {
                    RemoveEffect(oTarget, eEffect);
                    nFlag = TRUE;
                }
            }

            eEffect = GetNextEffect(oTarget);
        }

        int nCurrentHitPoints = GetCurrentHitPoints(oTarget);
        int nMaxHitPoints     = GetMaxHitPoints(oTarget);

        //heal
        if (nFlag || nCurrentHitPoints < nMaxHitPoints / 3)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                EffectHeal(nMaxHitPoints - nCurrentHitPoints),
                                oTarget);
            nFlag = TRUE;
        }

        //divine wrath
        if (! nFlag)
        {
            location lLocation = GetLocation(oTarget);
            object oEnemy      = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocation, TRUE);
            effect eVisual1    = EffectVisualEffect(VFX_FNF_STRIKE_HOLY);
            effect eVisual2    = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
            string sDeityEnemy = "";
            int nDamage        = 0;
            int nPresenceEnemy = 0;
            int nResistance    = 0;
            int nNth           = 0;

            while (GetIsObjectValid(oEnemy))
            {
                if (gsSPGetIsAffected(GS_SP_TYPE_HARMFUL_SELECTIVE, oTarget, oEnemy) &&
                    ! gsBOGetIsBossCreature(oEnemy))
                {
                    sDeityEnemy = GetDeity(oEnemy);

                    if (sDeityEnemy != sDeity)
                    {
                        if (GetIsPC(oEnemy))
                        {
                            nDamage        = d6(nPresence * nHitDice / 100);
                            nPresenceEnemy = sDeityEnemy == "" ?
                                             0 : gsWOGetPresence(sDeityEnemy);
                            nResistance    = nPresenceEnemy < 1 ?
                                             0 : d6(nPresenceEnemy * GetHitDice(oEnemy) / 100);
                        }
                        else
                        {
                            nDamage        = d6(nPresence);
                            nPresenceEnemy = sDeityEnemy == "" ?
                                             0 : gsWOGetPresence(sDeityEnemy);
                            nResistance    = nPresenceEnemy < 20 ?
                                             d6(20) : d6(nPresenceEnemy);
                        }

                        //visual effect
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual1, oEnemy);

                        if (nResistance < nDamage)
                        {
                            FloatingTextStringOnCreature(GS_T_16777481, oEnemy, FALSE);

                            //apply damage
                            DelayCommand(
                                1.0,
                                ApplyEffectToObject(
                                    DURATION_TYPE_INSTANT,
                                    EffectLinkEffects(
                                        eVisual2,
                                        EffectDamage(
                                            nDamage - nResistance,
                                            DAMAGE_TYPE_DIVINE,
                                            DAMAGE_POWER_ENERGY)),
                                    oEnemy));
                        }
                        else
                        {
                            FloatingTextStringOnCreature(GS_T_16777480, oEnemy, FALSE);
                        }

                        nFlag = TRUE;
                        nNth++;
                    }
                }

                if (nNth >= 3) break; //affects a maximum of 3 creatures

                oEnemy = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocation, TRUE);
            }
        }

        if (nFlag)
        {
            gsWOAdjustPower(sDeity, -GS_WO_COST_GREATER_FAVOR);
            FloatingTextStringOnCreature(gsCMReplaceString(GS_T_16777285, sDeity), oTarget, FALSE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                EffectVisualEffect(VFX_FNF_LOS_HOLY_20),
                                oTarget);

            //apply penalty
            if (GetIsInCombat(oTarget))
            {
                gsXPApplyDeathPenalty(oTarget, nHitDice * GS_WO_PENALTY_PER_LEVEL, TRUE);
            }

            return TRUE;
        }
    }

    //lesser favor
    if (nPower >= GS_WO_COST_LESSER_FAVOR)
    {
        //state
        if (gsSTGetState(GS_ST_FOOD, oTarget)  <= 0.0) gsSTAdjustState(GS_ST_FOOD,  25.0);
        if (gsSTGetState(GS_ST_WATER, oTarget) <= 0.0) gsSTAdjustState(GS_ST_WATER, 25.0);
        if (gsSTGetState(GS_ST_REST, oTarget)  <= 0.0) gsSTAdjustState(GS_ST_REST,  25.0);

        //ability
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            EffectAbilityIncrease(ABILITY_CHARISMA, Random(3)),
                            oTarget,
                            600.0);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            EffectAbilityIncrease(ABILITY_CONSTITUTION, Random(3)),
                            oTarget,
                            600.0);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            EffectAbilityIncrease(ABILITY_DEXTERITY, Random(3)),
                            oTarget,
                            600.0);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            EffectAbilityIncrease(ABILITY_INTELLIGENCE, Random(3)),
                            oTarget,
                            600.0);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            EffectAbilityIncrease(ABILITY_STRENGTH, Random(3)),
                            oTarget,
                            600.0);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            EffectAbilityIncrease(ABILITY_WISDOM, Random(3)),
                            oTarget,
                            600.0);

        gsWOAdjustPower(sDeity, -GS_WO_COST_LESSER_FAVOR);
        FloatingTextStringOnCreature(gsCMReplaceString(GS_T_16777286, sDeity), oTarget, FALSE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,
                            EffectVisualEffect(VFX_FNF_LOS_HOLY_10),
                            oTarget);
        return TRUE;
    }

    FloatingTextStringOnCreature(gsCMReplaceString(GS_T_16777287, sDeity), oTarget, FALSE);
    return FALSE;
}
//----------------------------------------------------------------
int gsWOGrantResurrection(object oTarget = OBJECT_SELF)
{
    if (! GetIsDead(oTarget))                                            return FALSE;
    string sDeity  = GetDeity(oTarget);
    if (sDeity == "")                                                    return FALSE;
    int nTimestamp = gsTIGetActualTimestamp();
    if (GetLocalInt(oTarget, "GS_WO_TIMEOUT_RESURRECTION") > nTimestamp) return FALSE;
    SetLocalInt(oTarget, "GS_WO_TIMEOUT_RESURRECTION", nTimestamp + GS_WO_TIMEOUT_RESURRECTION);
    int nPresence  = gsWOGetPresence(sDeity);
    if (Random(100) >= nPresence)                                        return FALSE;
    if (Random(100) < 10)                                                return FALSE;
    int nPower     = gsWOGetPower(sDeity);
    if (nPower < GS_WO_COST_RESURRECTION)                                return FALSE;

    ApplyEffectToObject(DURATION_TYPE_INSTANT,
                        EffectResurrection(),
                        oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,
                        EffectHeal(GetMaxHitPoints(oTarget) + 10),
                        oTarget);
    ApplyEffectToObject(
        DURATION_TYPE_TEMPORARY,
            ExtraordinaryEffect(
                EffectLinkEffects(
                    EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
                    EffectLinkEffects(
                        EffectVisualEffect(VFX_DUR_SANCTUARY),
                        EffectEthereal()))),
        oTarget,
        6.0);

    gsWOAdjustPower(sDeity, -GS_WO_COST_RESURRECTION);
    FloatingTextStringOnCreature(gsCMReplaceString(GS_T_16777288, sDeity), oTarget, FALSE);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,
                        EffectVisualEffect(VFX_FNF_LOS_HOLY_30),
                        oTarget);

    return TRUE;
}
