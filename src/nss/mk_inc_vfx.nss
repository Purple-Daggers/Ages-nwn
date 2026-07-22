//////////////////////////////////////////////////////////////////////////////
// mk_inc_vfx.nss
//////////////////////////////////////////////////////////////////////////////

#include "mk_inc_version"
#include "mk_inc_tools"
#include "mk_inc_body"

const string MK_VFX_BIOWARE_2DA = "visualeffects";

const string MK_VFX_MODE = "mk_vfx_mode";

const string MK_VFX_PER_PAGE = "MK_VFX_PER_PAGE";

const string MK_DEF_VFX = "mk_def_vfx";

const string MK_VFX_CURRENT_VFX = "MK_VFX_CURRENT_VFX";
const string MK_VFX_CURRENT_ROW = "MK_VFX_CURRENT_ROW";

const string MK_EFFECT_SCALE = "MK_EFFECT_SCALE";
const string MK_EFFECT_TRANSLATE = "MK_EFFECT_TRANSLATE";
const string MK_EFFECT_ROTATE = "MK_EFFECT_ROTATE";

/*
const int MK_VFX_MODE_GLEYES = 0;
const int MK_VFX_MODE_LIGHTS = 1;
const int MK_VFX_MODE_CEP = 2;
const int MK_VFX_MODE_USER = 3;
const int MK_VFX_MODE_ALL = 4;
const int MK_VFX_MODE_ERROR = -1;
*/

// initializes the vfx filter system
// sets the 2da file used (mk_sys_vfx.2da or mk_def_vfx.2da)
// returns FALSE if none of these files were found.
int MK_VFX_Initialize(object oPC);

//////////////////////////////////////////////////////////////////////////////
string MK_VFX_Get_VFXModeFile(object oPC);

//////////////////////////////////////////////////////////////////////////////
string MK_VFX_Get2DAFile(object oPC, int nVFXmode);

//////////////////////////////////////////////////////////////////////////////
int MK_VFX_GetVFX(object oPC, int nVFXmode, int nRow, object oTarget = OBJECT_SELF);

//////////////////////////////////////////////////////////////////////////////
int MK_VFX_GetVFXIsValid(object oPC, int nVFXmode, int nRow, object oTarget = OBJECT_SELF);

//////////////////////////////////////////////////////////////////////////////
//string MK_VFX_GetValueColumn(int nVFXmode, object oPC = OBJECT_SELF);

//////////////////////////////////////////////////////////////////////////////
string MK_VFX_GetTag(int nVFX);

//////////////////////////////////////////////////////////////////////////////
int MK_VFX_GetHasVFX(object oPC, int nVFX, object oTarget);

//////////////////////////////////////////////////////////////////////////////
int MK_VFX_RemoveVFX(object oPC, int nVFX, object oPC);

//////////////////////////////////////////////////////////////////////////////
int MK_VFX_ApplyVFX(object oPC, int nVFX, object oPC, int nVFXmode=-1, int nRow=-1);

//////////////////////////////////////////////////////////////////////////////
int MK_VFX_GetNumberOfVFXPerPage(object oPC);

//////////////////////////////////////////////////////////////////////////////
void MK_VFX_RemoveAllEffects(object oPC, int nEffectType=EFFECT_TYPE_VISUALEFFECT, int nEffectSubType=0);

//////////////////////////////////////////////////////////////////////////////
int MK_VFX_GetVFXMode(object oPC);

//////////////////////////////////////////////////////////////////////////////
void MK_VFX_SetVFXMode(int nVFXMode, object oPC);


string MK_EFFECT_GetTag(effect e);

effect MK_EFFECT_VisualEffect(int nVisualEffectId, int nMissEffect=FALSE, float fScale=1.0f, vector vTranslate=[0.0,0.0,0.0], vector vRotate=[0.0,0.0,0.0]);

float MK_EFFECT_GetScale(effect e);

vector MK_EFFECT_GetTranslate(effect e);

vector MK_EFFECT_GetRotate(effect e);

effect MK_EFFECT_GetCurrentEffect(object oTarget);

void MK_EFFECT_UpdateEffect(object oTarget, int nVFX, object oPC, float fScale=1.0f, vector vTranslate=[0.0,0.0,0.0], vector vRotate=[0.0,0.0,0.0]);

void MK_VFX_ApplyVisualEffect(int nVisualEffectId, object oTarget, int nSubType, int nDurationType, float fDuration=0.0f, string sTag="", int bMissEffect=FALSE, float fScale=1.0f, vector vTranslate=[0.0,0.0,0.0], vector vRotate=[0.0,0.0,0.0], int bDelay=FALSE);

//////////////////////////////////////////////////////////////////////////////

int MK_VFX_Initialize(object oPC)
{
    MK_DEBUG_TRACE("MK_HEAD:Initialize('"+GetName(oPC)+"')");
    int bReturn = TRUE;
    string s2DA = "mk_def_vfx";
    if (Get2DAString(s2DA, "NAME", 0) == "MK_VFX_ALL")
    {
        MK_DEBUG_TRACE(" > "+s2DA+".2DA found ("+Get2DAString(s2DA, "NAME", 0)+").");
        SetLocalString(oPC, MK_DEF_VFX, s2DA);
    }
    else
    {
        s2DA = "mk_sys_vfx";
        if (Get2DAString(s2DA, "NAME", 0) == "MK_VFX_ALL")
        {
            MK_DEBUG_TRACE(" > "+s2DA+".2DA found.");
            SetLocalString(oPC, MK_DEF_VFX, s2DA);
        }
        else
        {
            MK_DEBUG_TRACE(" > "+s2DA+".2DA not found.");
            DeleteLocalString(oPC, MK_DEF_VFX);
            SendMessageToPC(oPC, "VFX filter definition files 'mk_def_vfx.2da' or 'mk_sys_vfx.2da' not found!");
            bReturn = FALSE;
        }
    }
    return bReturn;
}

int MK_VFX_GetCurrentVFX()
{
    return GetLocalInt(OBJECT_SELF, MK_VFX_CURRENT_VFX);
}

void MK_VFX_SetCurrentVFX(int nVFX)
{
    SetLocalInt(OBJECT_SELF, MK_VFX_CURRENT_VFX, nVFX);
}

int MK_VFX_GetCurrentRow()
{
    return GetLocalInt(OBJECT_SELF, MK_VFX_CURRENT_ROW);
}

void MK_VFX_SetCurrentRow(int nRow)
{
    SetLocalInt(OBJECT_SELF, MK_VFX_CURRENT_ROW, nRow);
}

string MK_VFX_Get_VFXModeFile(object oPC)
{
    return GetLocalString(oPC, MK_DEF_VFX);
}

int MK_VFX_GetVFXMode(object oPC)
{
    return GetLocalInt(oPC, MK_VFX_MODE);
}

void MK_VFX_SetVFXMode(int nVFXMode, object oPC)
{
    SetLocalInt(oPC, MK_VFX_MODE, nVFXMode);
}

int MK_VFX_GetVFXIsValid(object oPC, int nVFXmode, int nRow, object oTarget)
{
    int bReturn = FALSE;
    int nVFX = MK_VFX_GetVFX(oPC, nVFXmode, nRow, oTarget);
    if (nVFX!=-1)
    {
        bReturn = (Get2DAString(MK_VFX_BIOWARE_2DA, "Type_FD", nVFX)!="");
    }
    return bReturn;
}

int MK_VFX_GetNumberOfVFXPerPage(object oPC)
{
    return GetLocalInt(oPC, MK_VFX_PER_PAGE);
}

string MK_VFX_Get2DAFile(object oPC, int nVFXmode)
{
    string s2DA = Get2DAString(MK_VFX_Get_VFXModeFile(oPC), "2DAFILE", nVFXmode);
    if (s2DA=="")
    {
        s2DA = MK_VFX_BIOWARE_2DA;
    }
    return s2DA;
}

string MK_VFX_GetRaceGenderColumn(object oTarget)
{
    int nRacialType = GetRacialType(oTarget);
    string sAppearance =Get2DAString("racialtypes", "Appearance", nRacialType);
    if (sAppearance!="")
    {
        nRacialType = MK_Search2DAFile("racialtypes", "Appearance", sAppearance, 50);
    }
    return Get2DAString("racialtypes", "Label", nRacialType)+"_"+MK_GetGenderAsString(oTarget);
}

int MK_VFX_GetVFX(object oPC, int nVFXMode, int nRow, object oTarget)
{
    int nVFX=-1;
    string s2DA = Get2DAString(MK_VFX_Get_VFXModeFile(oPC), "2DAFILE", nVFXMode);
//   MK_DEBUG_TRACE("MK_VFX_GetVFX("+IntToString(nVFXMode)+","+IntToString(nRow)+"): s2DA="+s2DA);
    if (s2DA=="")
    {
        nVFX = nRow;
    }
    else
    {
        string sColumn = MK_VFX_GetRaceGenderColumn(oTarget);
        nVFX = MK_Get2DAInt(s2DA, sColumn, nRow, -1);
//        MK_DEBUG_TRACE(" > sColumn="+sColumn+", nVFX="+IntToString(nVFX));
        if (nVFX == -1)
        {
            nVFX = MK_Get2DAInt(s2DA, "Default", nRow, -1);
//            MK_DEBUG_TRACE(" > nVFX="+IntToString(nVFX));
        }
    }
    return nVFX;
}

string MK_VFX_GetTag(int nVFX)
{
    return "MK_VFX_"+MK_IntToString(nVFX, 5, "0");
}

int MK_VFX_GetHasVFX(object oPC, int nVFX, object oTarget)
{
    if (MK_VERSION_GetIsVersionLower_1_74(oPC))
    {
        return FALSE;
    }

    string sTag = MK_VFX_GetTag(nVFX);

    effect eEff = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eEff))
    {
        if (MK_EFFECT_GetTag(eEff) == sTag)
        {
            return TRUE;
        }
        eEff = GetNextEffect(oTarget);
    }
    return FALSE;
}

int MK_VFX_RemoveVFX(object oTarget, int nVFX, object oPC)
{
    if (MK_VERSION_GetIsVersionLower_1_74(oPC))
    {
        SendMessageToPC(oPC, "EE features are disabled. Can't remove specific effects!");
        return FALSE;
    }

    string sTag = MK_VFX_GetTag(nVFX);

    effect eEff = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eEff))
    {
        if (MK_EFFECT_GetTag(eEff) == sTag)
        {
            RemoveEffect(oTarget, eEff);
            return TRUE;
        }
        eEff = GetNextEffect(oTarget);
    }
//    SendMessageToPC(oPC, "Specified effect not found!");
    return FALSE;
}

int MK_VFX_ApplyVFX(object oTarget, int nVFX, object oPC, int nVFXmode, int nRow)
{
    int nDurationType = DURATION_TYPE_INSTANT;
    int nSubType = SUBTYPE_MAGICAL;
    string s2DAFile = MK_VFX_Get2DAFile(oPC, nVFXmode);
    if (s2DAFile!="")
    {
        if (nRow==-1) nRow = nVFX;
        string sTypeFD = Get2DAString(s2DAFile, "Type_FD", nRow);
        if ((sTypeFD == "D") || (sTypeFD == "B"))
        {
            if (Get2DAString(s2DAFile, "Supernatural", nRow) == "1")
            {
                nSubType = SUBTYPE_SUPERNATURAL;
            }
            nDurationType = DURATION_TYPE_PERMANENT;
        }
    }

    MK_VFX_ApplyVisualEffect(nVFX, oTarget, nSubType, nDurationType, 0.0f, MK_VFX_GetTag(nVFX));
    SendMessageToPC(oPC, "Applying specified vfx (name="+Get2DAString(s2DAFile, "Label", nRow)+","+IntToString(nVFX)+")!");

/*
    effect eEffect = MK_EFFECT_VisualEffect(nVFX);

    int nDurationType = DURATION_TYPE_INSTANT;
    string s2DAFile = MK_VFX_Get2DAFile(nVFXmode);
    if (s2DAFile!="")
    {
        if (nRow==-1) nRow = nVFX;
        string sTypeFD = Get2DAString(s2DAFile, "Type_FD", nRow);
        if ((sTypeFD == "D") || (sTypeFD == "B"))
        {
            if (Get2DAString(s2DAFile, "Supernatural", nRow) == "1")
            {
                eEffect = SupernaturalEffect(eEffect);
            }
            nDurationType = DURATION_TYPE_PERMANENT;
        }
    }
//    if (MK_VERSION_GetIsVersionGreaterEqual_1_74(oPC))
//    {
//        eEffect = TagEffect(eEffect, MK_VFX_GetTag(nVFX));
//    }

    SendMessageToPC(oPC, "Applying specified vfx (name="+Get2DAString(s2DAFile, "Label", nRow)+","+IntToString(nVFX)+")!");

    ApplyEffectToObject(nDurationType, eEffect, oPC);
*/
    return TRUE;
}

void MK_VFX_RemoveAllEffects(object oTarget, int nEffectType, int nEffectSubType)
{
    effect eEffect = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eEffect))
    {
        if ( (                         GetEffectType   (eEffect) == nEffectType    ) &&
             ( (nEffectSubType==0) || (GetEffectSubType(eEffect) == nEffectSubType))    )
        {
            RemoveEffect(oTarget, eEffect);
        }
        eEffect = GetNextEffect(oTarget);
    }
}

/*
struct MK_VFX_DESCRIPTION
{
    string sDescription;
    string sPrefix1;
    string sPrefix2;
};

struct MK_VFX_DESCRIPTION MK_VFX_SetDescription(string sName)
{
    struct MK_VFX_DESCRIPTION desc;

    int nPos0 = FindSubString(sName, "_");
    int nPos1 = ( (nPos0 == -1) ? -1 : MK_VERSION_FindSubString(sName, "_", nPos0+1) );
    int nLen = GetStringLength(sName);

    if (nPos1!=-1)
    {
        desc.sPrefix1 = GetStringLeft(sName, nPos0);
        if (desc.sPrefix1 == "SCENE")
        {
            desc.sPrefix2 = "";
            desc.sDescription = GetStringRight(sName, nLen - nPos0 - 1);
        }
        else
        {
            desc.sPrefix2 = GetSubString(sName, nPos0+1, nPos1 - nPos0 -1);
            desc.sDescription = GetStringRight(sName, nLen - nPos1 - 1);
        }
    }
    else if (nPos0!=-1)
    {
        desc.sDescription = GetStringRight(sName, nLen - nPos0 - 1);
        desc.sPrefix1 = GetStringLeft(sName, nPos0);
        desc.sPrefix2 = "";
    }
    else
    {
        desc.sDescription = sName;
        desc.sPrefix1 = "";
        desc.sPrefix2 = "";
    }
    return desc;
}
*/

string MK_VFX_GetDescription(int nVFXmode, int nVFX, string sName)
{
    string sDescription;
    switch (nVFXmode)
    {
    case 0:
    {
        int nLen = GetStringLength(sName);
        int nNewLen = -1;
        if ((nLen>25) && (nVFX>=100))
        {
            nNewLen = 24;
        }
        else if ((nLen>26) && (nVFX>=10))
        {
            nNewLen = 25;
        }
        else if (nLen>27)
        {
            nNewLen = 26;
        }
        if (nNewLen!=-1)
        {
            sName = GetStringLeft(sName, nNewLen)+"..";
        }
        sDescription = sName + " ("+IntToString(nVFX)+")";
        break;
    }
    default:
        sDescription = sName + " ("+IntToString(nVFX)+")";
        break;
    }
/*
    case 1:
    case 2:
    case 3:
        sDescription = sName + " ("+IntToString(nVFX)+")";
        break;
    default:
    {
        struct MK_VFX_DESCRIPTION desc = MK_VFX_SetDescription(sName);
        sDescription = desc.sDescription + " ("+IntToString(nVFX);
        if ((desc.sPrefix1 != "VFX") && (desc.sPrefix1 != ""))
        {
            sDescription += (", " + desc.sPrefix1);
        }
        if (desc.sPrefix2 != "")
        {
            sDescription += (", " + desc.sPrefix2);
        }
        sDescription += ")";
        break;
    }
    }
*/
    return sDescription;
}


effect MK_EFFECT_VisualEffect(int nVisualEffectId, int nMissEffect, float fScale, vector vTranslate, vector vRotate)
{
    effect e;

    if (MK_VERSION_GetIsBuildVersionGreaterEqual(OBJECT_SELF, 8193, 14))
    {
        MK_DEBUG_TRACE("EffectVisualEffect("+IntToString(nVisualEffectId)
            +", "+IntToString(nMissEffect)
            +", "+FloatToString(fScale, 7, 3)
            +", ("+FloatToString(vTranslate.x, 7, 3)
            +", "+FloatToString(vTranslate.y, 7, 3)
            +", "+FloatToString(vTranslate.z, 7, 3)+")"
            +", ("+FloatToString(vRotate.x, 7, 3)
            +", "+FloatToString(vRotate.y, 7, 3)
            +", "+FloatToString(vRotate.z, 7, 3)+")");

        e = EffectVisualEffect(nVisualEffectId, nMissEffect, fScale, vTranslate, vRotate);
    }
    else
    {
        MK_DEBUG_TRACE("EffectVisualEffect("+IntToString(nVisualEffectId)+")");
        e = EffectVisualEffect(nVisualEffectId);
    }

    if (MK_VERSION_GetIsVersionGreaterEqual_1_74())
    {
        string sTag = MK_VFX_GetTag(nVisualEffectId);
        if (MK_VERSION_GetIsBuildVersionGreaterEqual(OBJECT_SELF, 8193, 14))
        {
            sTag += "$$$";
            sTag += (FloatToString(fScale, 7, 3) + "§");
            sTag += (FloatToString(vTranslate.x, 9, 3)
                    +FloatToString(vTranslate.y, 9, 3)
                    +FloatToString(vTranslate.z, 9, 3) + "§");
            sTag += (FloatToString(vRotate.x   , 9, 3)
                    +FloatToString(vRotate.y   , 9, 3)
                    +FloatToString(vRotate.z   , 9, 3) + "$");
        }
        MK_DEBUG_TRACE(" > sTag = '"+sTag+"'");
        e = TagEffect(e, sTag);
    }

    return e;
}

string MK_EFFECT_GetTag(effect e)
{
    string sTag = GetEffectTag(e);
    int nPos = FindSubString(sTag, "$$$");
    if (nPos!=-1)
    {
        sTag = GetStringLeft(sTag, nPos);
    }
    return sTag;
}

float MK_EFFECT_GetScale(effect e)
{
    float fScale = 1.0f;
    string sTag = GetEffectTag(e);
    int nPos = FindSubString(sTag, "$$$");
    if (nPos != -1)
    {
        sTag = GetSubString(sTag, nPos+3, 7);
        fScale = StringToFloat(sTag);
    }
    return fScale;
}

vector MK_EFFECT_GetTranslate(effect e)
{
    vector vTrans = [0.0, 0.0, 0.0];
    string sTag = GetEffectTag(e);
    int nPos = FindSubString(sTag, "$$$");
    if (nPos != -1)
    {
        sTag = GetSubString(sTag, nPos+3+10, 28);
        vTrans.x = StringToFloat(GetSubString(sTag,0,9));
        vTrans.y = StringToFloat(GetSubString(sTag,9,9));
        vTrans.z = StringToFloat(GetSubString(sTag,18,9));
    }
    return vTrans;
}

vector MK_EFFECT_GetRotate(effect e)
{
    vector vRotate = [0.0, 0.0, 0.0];
    string sTag = GetEffectTag(e);
    int nPos = FindSubString(sTag, "$$$");
    if (nPos != -1)
    {
        sTag = GetSubString(sTag, nPos+3+10+28, 28);
        vRotate.x = StringToFloat(GetSubString(sTag,0,9));
        vRotate.y = StringToFloat(GetSubString(sTag,9,9));
        vRotate.z = StringToFloat(GetSubString(sTag,18,9));
    }

    return vRotate;
}

effect MK_EFFECT_GetCurrentEffect(object oTarget)
{
    int nVFX = MK_VFX_GetCurrentVFX();
    string sTag = MK_VFX_GetTag(nVFX);

    effect eEff = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eEff))
    {
        if (MK_EFFECT_GetTag(eEff) == sTag)
        {
            return eEff;
        }
        eEff = GetNextEffect(oTarget);
    }
    effect e;
    return e;
}

void MK_EFFECT_UpdateEffect(object oTarget, int nVFX, object oPC, float fScale, vector vTranslate, vector vRotate)
{
    MK_DEBUG_TRACE("UpdateEffect(...,"+IntToString(nVFX)+", "+FloatToString(fScale, 7, 3)+")");

    if (nVFX!=-1)
    {
        string sTag = MK_VFX_GetTag(nVFX);
        effect e = GetFirstEffect(oTarget);
        while (GetIsEffectValid(e))
        {
            if (MK_EFFECT_GetTag(e) == sTag)
            {
                MK_DEBUG_TRACE("  > effect found!");
                int nSubType = GetEffectSubType(e);
                int nDurationType = GetEffectDurationType(e);
                int nDurationRemaining = GetEffectDurationRemaining(e);

                RemoveEffect(oTarget, e);

                effect eEff =  MK_EFFECT_VisualEffect(nVFX, FALSE, fScale, vTranslate, vRotate);

                switch (nSubType)
                {
                case SUBTYPE_SUPERNATURAL:
                    eEff = SupernaturalEffect(eEff);
                    break;
                case SUBTYPE_MAGICAL:
                    eEff = MagicalEffect(eEff);
                    break;
                case SUBTYPE_EXTRAORDINARY:
                    eEff = ExtraordinaryEffect(eEff);
                    break;
                }

                MK_DEBUG_TRACE(" > nDurationType="+IntToString(nDurationType));

                SetLocalString(oPC, MK_EFFECT_SCALE, FloatToString(fScale, 7, 3));
                SetLocalString(oPC, MK_EFFECT_TRANSLATE, "("+FloatToString(vTranslate.x,7,3)+
                                                             FloatToString(vTranslate.y, 7, 3)+
                                                             FloatToString(vTranslate.z, 7, 3)+")");
                SetLocalString(oPC, MK_EFFECT_ROTATE,    "("+FloatToString(vRotate.x,7,3)+
                                                             FloatToString(vRotate.y, 7, 3)+
                                                             FloatToString(vRotate.z, 7, 3)+")");

                DelayCommand(0.0f, ApplyEffectToObject(nDurationType, eEff, oTarget, IntToFloat(nDurationRemaining)));

//                ApplyEffectToObject(nDurationType, eEff, oPC, IntToFloat(nDurationRemaining));

                return;
            }
            e = GetNextEffect(oTarget);
        }
        MK_DEBUG_TRACE("  > effect not found!");
    }
}

void MK_VFX_ApplyVisualEffect(int nVisualEffectId, object oTarget, int nSubType, int nDurationType, float fDuration, string sTag, int bMissEffect, float fScale, vector vTranslate, vector vRotate, int bDelay)
{
    if (MK_VERSION_GetIsBuildVersionGreaterEqual(OBJECT_SELF, 8193, 14))
    {
        effect e = EffectVisualEffect(nVisualEffectId, bMissEffect, fScale, vTranslate, vRotate);

        switch (nSubType)
        {
        case SUBTYPE_EXTRAORDINARY:
            e = ExtraordinaryEffect(e);
            break;
        case SUBTYPE_SUPERNATURAL:
            e = SupernaturalEffect(e);
            break;
        }

        if (sTag!="")
        {
            e = TagEffect(e, sTag);
        }

        if (bDelay)
        {
            DelayCommand(0.0f, ApplyEffectToObject(nDurationType, e, oTarget, fDuration));
        }
        else
        {
            ApplyEffectToObject(nDurationType, e, oTarget, fDuration);
        }
    }
    else
    {
        string sScript="mk_apply_vis_eff";
        object oObject = oTarget;
        SetLocalInt(oObject,    "PARAM_01", nVisualEffectId);
        SetLocalObject(oObject, "PARAM_02", oTarget);
        SetLocalInt(oObject,    "PARAM_03", nSubType);
        SetLocalInt(oObject,    "PARAM_04", nDurationType);
        SetLocalFloat(oObject,  "PARAM_05", fDuration);
        SetLocalString(oObject, "PARAM_06", sTag);
        SetLocalInt(oObject,    "PARAM_07", bDelay);
        ExecuteScript(sScript, oObject);
    }
}


/*
void main()
{
}
/**/
