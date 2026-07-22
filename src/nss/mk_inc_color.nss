// mk_inc_color
#include "mk_inc_debug"
#include "x2_inc_craft"
#include "mk_inc_tools"
#include "mk_inc_modmodes"
#include "mk_inc_body"
#include "mk_inc_tlk"
#include "mk_inc_array"

const string MK_COLOR_2DAFILE = "mk_color";

const int MK_COLOR_NUMBER = 0;
const int MK_COLOR_NEXT = 1;
const int MK_COLOR_PREV = 2;

const string MK_COLOR_VALID_COLORS = "mk_color_valid_colors";


// returns the matching column in 'mk_color.2da'
// - nModMode: either MK_CI_MODMODE_BODY or X2_CI_MODMODE_ARMOR,
//             MK_CI_MODMODE_HELMET or MK_CI_MODMODE_CLOAK
// - nParam1: nModMode == MK_CI_MODMODE_BODY: MK_CRAFTBODY_COLOR
//            else: ignored
// - nParam2: nModMode == MK_CI_MODMODE_BODY: COLOR_CHANNEL_*
//            else: ITEM_APPR_ARMOR_COLOR_*
// * returns column
string MK_COLOR_Get2DAColumn(int nModMode, int nParam1, int nParam2);


// returns TRUE if specified color is valid
// - sColumn: column in 'mk_color.2da'
// - nColor: color number (0..176)
// * returns TRUE if color is valid and FALSE otherwise.
int MK_COLOR_GetIsColorValid(string sColumn, int nColor);

// returns strref for specified color
// - sColumn: column in 'mk_color.2da'
// - nColor: color number (0..176)
// * returns strref if color is valid or 0.
int MK_COLOR_GetStrRef(string sColumn, int nColor);

// returns color name for specified color
// - sColumn: column in 'mk_color.2da'
// - nColor: color number (0..176)
// * returns color name if color is valid or an empty string otherwise.
string MK_COLOR_GetColorName(string sColumn, int nColor);

// returns color name for specified color
// - nModMode: either MK_CI_MODMODE_BODY or X2_CI_MODMODE_ARMOR,
//             MK_CI_MODMODE_HELMET or MK_CI_MODMODE_CLOAK
// - nParam1: nModMode == MK_CI_MODMODE_BODY: MK_CRAFTBODY_COLOR
//            else: ignored
// - nParam2: nModMode == MK_CI_MODMODE_BODY: COLOR_CHANNEL_*
//            else: ITEM_APPR_ARMOR_COLOR_*
// - nColor: color number (0..176)
// * returns color name if color is valid or an empty string otherwise.
string MK_COLOR_GetColorName2(int nModMode, int nParam1, int nParam2, int nColor);

// sets custom tokens to color name and color number
// - sColumn: column in 'mk_color.2da'
// - nColor: color number (0..176)
void MK_COLOR_SetCustomToken(string sColumn, int nColor, int nTokenName=14422, int nTokenNr=14423);


int MK_COLOR_SetColor(object oCreature, int nColorChannel, int nMode, int nColor=-1, object oPC=OBJECT_INVALID);


void MK_COLOR_SetValidColors(object oPC, string sValidColors)
{
    MK_ARRAY_SetLocalArrayBuffer(oPC, MK_COLOR_VALID_COLORS, sValidColors);
}


int MK_COLOR_SetColor(object oCreature, int nColorChannel, int nMode, int nColor, object oPC)
{
    if (!GetIsObjectValid(oPC))
    {
        oPC = oCreature;
    }
    int nNewColor=-1;
    switch (nMode)
    {
    case MK_COLOR_NUMBER:
        nNewColor = nColor;
        break;
    case MK_COLOR_NEXT:
    case MK_COLOR_PREV:
    {
        int nCurrentColor = GetColor(oCreature, nColorChannel);
        int nPosCurrent = MK_ARRAY_SearchLocalArraySortedInt(oPC, MK_COLOR_VALID_COLORS, nCurrentColor);
        int nColorCount = MK_ARRAY_GetLocalArraySortedIntLength(oPC, MK_COLOR_VALID_COLORS);

        int nPosNew=-1;
        if (nPosCurrent==-1)
        {
            nPosNew=0;
        }
        else
        {
            switch (nMode)
            {
            case MK_COLOR_PREV:
                nPosNew = (nPosCurrent + nColorCount - 1) % nColorCount;
                break;
            case MK_COLOR_NEXT:
                nPosNew = (nPosCurrent + 1) % nColorCount;
                break;
            }
        }

        if (nPosNew>=0)
        {
            nNewColor = MK_ARRAY_GetLocalArraySortedInt(oPC, MK_COLOR_VALID_COLORS, nPosNew);
        }

        break;
    }
    }
    if (nNewColor!=-1)
    {
        MK_SetColor(oCreature, nColorChannel, nNewColor);
    }
    return nNewColor;
}

int MK_COLOR_GetStrRef(string sColumn, int nColor)
{
    return MK_Get2DAInt(MK_COLOR_2DAFILE, sColumn, nColor, 0);
}

int MK_COLOR_GetIsColorValid(string sColumn, int nColor)
{
    int nStrRef = MK_COLOR_GetStrRef(sColumn, nColor);
    return (nStrRef!=0);
}

string MK_COLOR_GetColorName(string sColumn, int nColor)
{
    int nStrRef = MK_COLOR_GetStrRef(sColumn, nColor);
    string sColorName = MK_TLK_GetStringByStrRef(nStrRef, GetGender(OBJECT_SELF));
//    MK_DEBUG_TRACE("MK_COLOR_GetColorName('"+sColumn+"',"+IntToString(nColor)+"): nStrRef="+IntToString(nStrRef)+", sName='"+sColorName+"'");
    return sColorName;
}

string MK_COLOR_GetColorName2(int nModMode, int nParam1, int nParam2, int nColor)
{
    string sColumn = MK_COLOR_Get2DAColumn(nModMode, nParam1, nParam2);
    return MK_COLOR_GetColorName(sColumn, nColor);
}

string MK_COLOR_Get2DAColumn(int nModMode, int nParam1, int nParam2)
{
    string sColumn="";
    switch (nModMode)
    {
    case X2_CI_MODMODE_ARMOR:
    case MK_CI_MODMODE_HELMET:
    case MK_CI_MODMODE_CLOAK:
        switch (nParam2)
        {
        case ITEM_APPR_ARMOR_COLOR_LEATHER1:
        case ITEM_APPR_ARMOR_COLOR_LEATHER2:
            sColumn = "Leather";
            break;
        case ITEM_APPR_ARMOR_COLOR_CLOTH1:
        case ITEM_APPR_ARMOR_COLOR_CLOTH2:
            sColumn = "Cloth";
            break;
        case ITEM_APPR_ARMOR_COLOR_METAL1:
        case ITEM_APPR_ARMOR_COLOR_METAL2:
            sColumn = "Metal";
            break;
        }
        break;
    case MK_CI_MODMODE_BODY:
        switch (nParam1)
        {
        case MK_CRAFTBODY_COLOR:
            switch (nParam2)
            {
            case COLOR_CHANNEL_HAIR:
                sColumn="Hair";
                break;
            case COLOR_CHANNEL_SKIN:
                sColumn="Skin";
                break;
            case COLOR_CHANNEL_TATTOO_1:
            case COLOR_CHANNEL_TATTOO_2:
                sColumn="Tattoo";
                break;
            }
            break;
        }
        break;
    }
    return sColumn;
}

void MK_COLOR_SetCustomToken(string sColumn, int nColor, int nTokenName, int nTokenNr)
{
    string sColorName=MK_COLOR_GetColorName(sColumn, nColor);
    SetCustomToken(nTokenName, sColorName);
//    MK_DEBUG_TRACE("SetCustomToken("+IntToString(nTokenName)+",'"+sColorName+"')");
    SetCustomToken(nTokenNr, IntToString(nColor));
//    MK_DEBUG_TRACE("SetCustomToken("+IntToString(nTokenNr)+","+IntToString(nColor)+")");
}

/*
void main()
{

}
/**/
