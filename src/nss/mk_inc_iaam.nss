#include "mk_inc_tools_s"
#include "mk_inc_tlk"
#include "mk_inc_debug"

const int MK_ITEM_APPR_ARMOR_MODEL_LRSHOULDER = 21;
const int MK_ITEM_APPR_ARMOR_MODEL_LRBICEP = 22;
const int MK_ITEM_APPR_ARMOR_MODEL_LRFOREARM = 23;
const int MK_ITEM_APPR_ARMOR_MODEL_LRHAND = 24;
const int MK_ITEM_APPR_ARMOR_MODEL_LRTHIGH = 25;
const int MK_ITEM_APPR_ARMOR_MODEL_LRSHIN = 26;
const int MK_ITEM_APPR_ARMOR_MODEL_LRFOOT = 27;
const int MK_ITEM_APPR_ARMOR_MODEL_PANTS = 28;
const int MK_ITEM_APPR_ARMOR_MODEL_BREECHES = 29;
const int MK_ITEM_APPR_ARMOR_MODEL_BOOTS = 30;
const int MK_ITEM_APPR_ARMOR_MODEL_SLEEVES = 31;

const int MK_ITEM_APPR_ARMOR_NUM_MODELS = 40;

const string MK_IAAM_2DA_FILE = "mk_iaam_def";


//---------------------------------------------------------------------------
// returns the percentage of parts that are hidden by specified robe
// if bPercentage is FALSE the function returns FALSE (no part is hidden) or
// TRUE (at least 1 part is hidden)
//---------------------------------------------------------------------------
int MK_IAAM_GetIsHiddenByRobe(int nModel, int nRobe, int bPercentage=TRUE);

//---------------------------------------------------------------------------
// returns the percentage of parts for whom
// GetItemAppearance(oArmor, ITEM_APPR_TYPE_ARMOR_MODEL, ...) returns 0 or 1
// if bPercentage is FALSE the function returns FALSE (no part is empty) or
// TRUE (at least 1 part is empty)
//---------------------------------------------------------------------------
int MK_IAAM_GetArmorAppearanceIsNull(int nModel, object oArmor, int bPercentage=TRUE);

//---------------------------------------------------------------------------
// returns TRUE only if for all parts GetItemAppearance(oArmor, ITEM_APPR_TYPE_ARMOR_MODEL, ...)
// returns the same value. Otherwise FALSE is returned.
//---------------------------------------------------------------------------
int MK_IAAM_GetAllPartsHaveIdenticalAppearance(int nModel, object oArmor);

//---------------------------------------------------------------------------
// returns TRUE if the specified model is valid
//---------------------------------------------------------------------------
int MK_IAAM_GetIsValid(int nModel);

//---------------------------------------------------------------------------
// returns TRUE if the specified model is a base model
// means: 0 <= nModel < ITEM_APPR_ARMOR_NUM_MODELS
//---------------------------------------------------------------------------
int MK_IAAM_GetIsBase(int nModel);


//---------------------------------------------------------------------------
// returns TRUE if specified model is creature part
//---------------------------------------------------------------------------
int MK_IAAM_GetIsCreaturePart(int nModel);

//---------------------------------------------------------------------------
// returns TRUE if there is an opposite part
//---------------------------------------------------------------------------
int MK_IAAM_GetHasOpposite(int nModel);

//---------------------------------------------------------------------------
// returns TRUE if specified model contains specified part
//---------------------------------------------------------------------------
int MK_IAAM_GetContainsPart(int nModel, int iPart);

//---------------------------------------------------------------------------
// returns the part count for the specified armor model
//---------------------------------------------------------------------------
int MK_IAAM_GetPartCount(int nModel);

//---------------------------------------------------------------------------
// returns part no nNumber for the specified armor model
//---------------------------------------------------------------------------
int MK_IAAM_GetPart(int nModel, int nNumber);

//---------------------------------------------------------------------------
// returns the strref for the specified armor model and part
//---------------------------------------------------------------------------
int MK_IAAM_GetStrRef(int nModel, int nDescription=FALSE);

//---------------------------------------------------------------------------
// returns the name of the specified model
//---------------------------------------------------------------------------
string MK_IAAM_GetName(int nModel);

//---------------------------------------------------------------------------
// returns the descriptive name of the specified model
//---------------------------------------------------------------------------
string MK_IAAM_GetDescription(int nModel);

//---------------------------------------------------------------------------
// returns the model no of opposite model
//---------------------------------------------------------------------------
int MK_IAAM_GetOpposite(int nModel);

//---------------------------------------------------------------------------
// returns the column in  parts_robe.2da
//---------------------------------------------------------------------------
string MK_IAAM_GetRobeHideColumn(int nModel);

//---------------------------------------------------------------------------
// returns the name of parts_ 2DA file
//---------------------------------------------------------------------------
string MK_IAAM_GetParts2DAfile(int nModel);

int MK_IAAM_GetPartsMaxID(int nModel);


int MK_IAAM_GetIsValid(int nModel)
{
    int nCount = MK_IAAM_GetPartCount(nModel);
    if (nCount<=0) return FALSE;

    int iNumber;
    for (iNumber=0; iNumber<nCount; iNumber++)
    {
        int iPart = MK_IAAM_GetPart(nModel, iNumber);
        if ((iPart<0) || (iPart>=ITEM_APPR_ARMOR_NUM_MODELS))
            return FALSE;
    }
    return TRUE;
}

int MK_IAAM_GetIsBase(int nModel)
{
    return MK_Get2DAInt(MK_IAAM_2DA_FILE, "Base", nModel);
}

int MK_IAAM_GetPartCount(int nModel)
{
    return MK_Get2DAInt(MK_IAAM_2DA_FILE, "Count", nModel);
}

int MK_IAAM_GetPart(int nModel, int nNumber)
{
    string sColumn = "Part"+IntToString(nNumber);
    return MK_Get2DAInt(MK_IAAM_2DA_FILE, sColumn, nModel);
}

int MK_IAAM_GetStrRef(int nModel, int nDescription)
{
    int nStrRef = -1;
    if (MK_IAAM_GetIsValid(nModel))
    {
        nStrRef = MK_Get2DAInt(MK_IAAM_2DA_FILE, (nDescription ? "Description" : "StrRef"), nModel);
    }
    return nStrRef;
}

string MK_IAAM_GetName(int nModel)
{
    string sName;
    int nStrRef = MK_IAAM_GetStrRef(nModel);
    return MK_TLK_GetStringByStrRef(nStrRef);
}

string MK_IAAM_GetDescription(int nModel)
{
    string sDescription;
    int nStrRef = MK_IAAM_GetStrRef(nModel, TRUE);
    return MK_TLK_GetStringByStrRef(nStrRef);
}

int MK_IAAM_GetHasOpposite(int nModel)
{
    return (MK_IAAM_GetOpposite(nModel)!=-1);
}

int MK_IAAM_GetOpposite(int nModel)
{
    return MK_Get2DAInt(MK_IAAM_2DA_FILE, "Opposite", nModel);
}

string MK_IAAM_GetParts2DAfile(int nModel)
{
    return Get2DAString(MK_IAAM_2DA_FILE, "parts_2da", nModel);
}

int MK_IAAM_GetPartsMaxID(int nModel)
{
    return MK_Get2DAInt(MK_IAAM_2DA_FILE, "MaxID", nModel);
}

string MK_IAAM_GetRobeHideColumn(int nModel)
{
    return Get2DAString(MK_IAAM_2DA_FILE, "parts_robe_column", nModel);
}

int MK_IAAM_GetIsCreaturePart(int nModel)
{
    return MK_Get2DAInt(MK_IAAM_2DA_FILE, "CreaturePart", nModel);
}

int MK_IAAM_GetContainsPart(int nModel, int iPart)
{
    if (!MK_IAAM_GetIsValid(nModel)) return FALSE;

    int nPartCount = MK_IAAM_GetPartCount(nModel);
    int iModel;
    for (iModel=0; iModel<nPartCount; iModel++)
    {
        if (MK_IAAM_GetPart(nModel, iModel)==iPart)
        {
            return TRUE;
        }
    }
    return FALSE;
}

int MK_IAAM_GetIsValidForModelModify(int nModel)
{
    if (!MK_IAAM_GetIsValid(nModel)) return FALSE;
    return MK_Get2DAInt(MK_IAAM_2DA_FILE, "Model", nModel);
}

int MK_IAAM_GetIsValidForColorModify(int nModel)
{
    if (!MK_IAAM_GetIsValid(nModel)) return FALSE;
    return MK_Get2DAInt(MK_IAAM_2DA_FILE, "Color", nModel);
}

int MK_IAAM_GetIsHiddenByRobe(int nModel, int nRobe, int bPercentage)
{
    if (!MK_IAAM_GetIsValid(nModel))
    {
        return 0;
    }
    string s2DAfile = MK_IAAM_GetParts2DAfile(ITEM_APPR_ARMOR_MODEL_ROBE);
    int nPartCount = MK_IAAM_GetPartCount(nModel);
    int iModel;
    int nCount=0;
    string sColumn;
    int iPart;

    for (iModel=0; ((bPercentage || (nCount==0)) && (iModel<nPartCount)); iModel++)
    {
        iPart = MK_IAAM_GetPart(nModel, iModel);
        sColumn = MK_IAAM_GetRobeHideColumn(iPart);
        if (sColumn!="")
        {
            if (Get2DAString(s2DAfile, sColumn, nRobe)=="1")
            {
                nCount++;
            }
        }
    }
    int nResult = (bPercentage ? (100 * nCount) / nPartCount : nCount);
//    MK_DEBUG_TRACE("MK_IAAM_GetIsHiddenByRobe("+IntToString(nModel)+", "+IntToString(nRobe)+", "+IntToString(bPercentage)+")="+IntToString(nResult));
    return nResult;
}

int MK_IAAM_GetArmorAppearanceIsNull(int nModel, object oArmor, int bPercentage)
{
    if (!MK_IAAM_GetIsValid(nModel))
    {
        return 0;
    }
    if (!GetIsObjectValid(oArmor))
    {
        return 0;
    }
    int nPartCount = MK_IAAM_GetPartCount(nModel);
    int iModel;
    int nCount=0;
    int nAppr;
    int iPart;

    for (iModel=0; ((bPercentage || (nCount==0)) && (iModel<nPartCount)); iModel++)
    {
        iPart = MK_IAAM_GetPart(nModel, iModel);
        nAppr = GetItemAppearance(oArmor, ITEM_APPR_TYPE_ARMOR_MODEL, iPart);
        if ((nAppr==0) || (nAppr==1))
        {
            nCount++;
        }
    }
    int nResult = (bPercentage ? (100 * nCount) / nPartCount : nCount);
//    MK_DEBUG_TRACE("MK_IAAM_GetArmorAppearanceIsNull("+IntToString(nModel)+",'+GetName(oArmor)+', "+IntToString(bPercentage)+")="+IntToString(nResult));
    return nResult;
}

int MK_IAAM_GetAllPartsHaveIdenticalAppearance(int nModel, object oArmor)
{
    if (!MK_IAAM_GetIsValid(nModel))
    {
        return 0;
    }
    if (!GetIsObjectValid(oArmor))
    {
        return 0;
    }
    int nPartCount = MK_IAAM_GetPartCount(nModel);
    int nAppr = GetItemAppearance(oArmor, ITEM_APPR_TYPE_ARMOR_MODEL, MK_IAAM_GetPart(nModel, 0));
    int iModel;
    int iPart;
    int iAppr;
    int nResult = TRUE;
    for (iModel = 1; (nResult && (iModel<nPartCount)); iModel++)
    {
        iAppr = GetItemAppearance(oArmor, ITEM_APPR_TYPE_ARMOR_MODEL, MK_IAAM_GetPart(nModel, iModel));
        nResult = (nAppr == iAppr);
    }
    return nResult;
}

/*
void main()
{

}
/**/
