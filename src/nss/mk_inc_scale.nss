// mk_inc_scale.nss

#include "x3_inc_string"
#include "mk_inc_tlk"
#include "mk_inc_generic"
#include "mk_inc_math"
#include "mk_inc_version"

const string MK_CCOH_SCALE_MIN = "MK_SCALE_MIN";
const string MK_CCOH_SCALE_MAX = "MK_SCALE_MAX";

float MK_SCALE_GetScaleFactor(object oObject)
{
    float fScale = 1.0f;
//    if (MK_VERSION_GetIsVersionGreaterEqual_1_75())
    if (MK_VERSION_GetIsBuildVersionGreaterEqual(OBJECT_INVALID, 8193, 21))
    {
        fScale = GetObjectVisualTransform(oObject, OBJECT_VISUAL_TRANSFORM_SCALE);
    }
    return fScale;
}

float MK_SCALE_SetScaleFactor(object oObject, float fScale)
{
//    if (MK_VERSION_GetIsVersionGreaterEqual_1_75())
    if (MK_VERSION_GetIsBuildVersionGreaterEqual(OBJECT_INVALID, 8193, 21))
    {
        fScale = SetObjectVisualTransform(oObject, OBJECT_VISUAL_TRANSFORM_SCALE, fScale);
    }
    else
    {
        fScale = 1.0f;
    }
    return fScale;
}

float MK_SCALE_GetLocalFloat(object oObject, string sVarName, float fDefault=0.0)
{
    float fValue = GetLocalFloat(oObject, sVarName);
    if (fValue == 0.0) fValue = fDefault;
    return fValue;
}

int MK_SCALE_GetIsScaleFactorValid(float fScale)
{
    int bReturn = MK_MATH_GetIsGreaterEqual(fScale, MK_SCALE_GetLocalFloat(OBJECT_SELF, MK_CCOH_SCALE_MIN, 0.1))
                    &&
                  MK_MATH_GetIsLowerEqual(fScale, MK_SCALE_GetLocalFloat(OBJECT_SELF, MK_CCOH_SCALE_MAX, 5.0));
    return bReturn;
}

void  MK_SCALE_DisplayScaleOption(int nCondition, int nStrRef, int nToken, int bEnable)
{
    string sText = MK_TLK_GetStringByStrRef(nStrRef, GetGender(OBJECT_SELF));
    if (!bEnable)
    {
        string sColorTag = GetLocalString(OBJECT_SELF, MK_DISABLED_OPTIONS_COLOR);
        if (sColorTag!="")
        {
            sText = sColorTag + sText + "</c>";
            //StringToRGBString(sText, sRGB);
            bEnable = TRUE;
        }
    }
    SetCustomToken(nToken, sText);
    MK_GenericDialog_SetCondition(nCondition, bEnable);
}

/*
void main()
{

}
/**/
