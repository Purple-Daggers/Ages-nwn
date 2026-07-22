#include "mk_inc_tools"

//const int MK_NWN_VERSION_1_68 = 68;
//const int MK_NWN_VERSION_1_69 = 69;
//const int MK_NWN_VERSION_1_74 = 74;
//const int MK_NWN_VERSION_1_79 = 79;

const string MK_NWN_VERSION_2DAFILE = "mk_version";

const string MK_NWN_VERSION_MAJOR = "mk_nwn_version_major";
const string MK_NWN_VERSION_MINOR = "mk_nwn_version_minor";

const int MK_NWN_VERSION_CURRENT_MAJOR = 1;
const int MK_NWN_VERSION_CURRENT_MINOR = 79;

struct MK_VERSION_DATA
{
    int nMajor;
    int nMinor;
};

struct MK_VERSION_DATA MK_VERSION_Initialize(object oPC, int bDisplayMessage);

struct MK_VERSION_DATA MK_VERSION_GetGameVersion(object oPC);

struct MK_VERSION_DATA MK_VERSION_DetectGameVersion(object oPC, int bDisplayProgress=FALSE);

struct MK_VERSION_DATA MK_VERSION_DetectGameVersionEx(object oPC);

int MK_VERSION_GetIsExtendedVersion(object oPC);

int MK_VERSION_GetIsVersionLower(object oPC, int nMajor, int nMinor);

int MK_VERSION_GetIsVersionGreaterEqual(object oPC, int nMajor, int nMinor);

int MK_VERSION_GetIsVersionGreaterEqual_1_80(object oPC = OBJECT_INVALID);

int MK_VERSION_GetIsVersionGreaterEqual_1_75(object oPC = OBJECT_INVALID);

int MK_VERSION_GetIsVersionGreaterEqual_1_74(object oPC = OBJECT_INVALID);

int MK_VERSION_GetIsVersionGreaterEqual_1_69(object oPC = OBJECT_INVALID);

int MK_VERSION_GetIsVersionGreaterEqual_1_67(object oPC = OBJECT_INVALID);

int MK_VERSION_GetIsVersionGreaterEqual_1_66(object oPC = OBJECT_INVALID);

int MK_VERSION_GetIsVersionGreaterEqual_1_64(object oPC = OBJECT_INVALID);

int MK_VERSION_GetIsVersionGreaterEqual_1_61(object oPC = OBJECT_INVALID);

int MK_VERSION_GetIsVersionLower_1_61(object oPC = OBJECT_INVALID);

int MK_VERSION_GetIsVersionLower_1_67(object oPC = OBJECT_INVALID);

int MK_VERSION_GetIsVersionLower_1_68(object oPC = OBJECT_INVALID);

int MK_VERSION_GetIsVersionLower_1_69(object oPC = OBJECT_INVALID);

int MK_VERSION_GetIsVersionLower_1_74(object oPC = OBJECT_INVALID);

int MK_VERSION_GetIsVersionLower_1_79(object oPC = OBJECT_INVALID);

int MK_VERSION_GetIsVersionLower_1_83(object oPC = OBJECT_INVALID);

float MK_VERSION_VersionDataToFloat(struct MK_VERSION_DATA verData);

string MK_VERSION_VersionDataToString(struct MK_VERSION_DATA verData);

struct MK_VERSION_DATA MK_VERSION_StringToVersionData(string sNWNversion);

void MK_VERSION_VersionDataToLocal(struct MK_VERSION_DATA verData, object oPC);

struct MK_VERSION_DATA MK_VERSION_LocalToVersionData(object oPC);

int MK_VERSION_GetIsVersionDataValid(struct MK_VERSION_DATA verData);


int MK_VERSION_GetIsBuildVersionGreaterEqual(object oPC, int nMajor, int nMinor);

// 1.69+ or nStart==0: same as FindSubString
// else Workaround for the missing starting position parameter
int MK_VERSION_FindSubString(string sString, string sSubString, int nStart=0);


object MK_VERSION_GetObject(object oPC)
{
    if (!GetIsObjectValid(oPC))
    {
        oPC = GetPCSpeaker();
    }
    if (!GetIsObjectValid(oPC))
    {
        oPC = OBJECT_SELF;
    }
    return oPC;
}

struct MK_VERSION_DATA MK_VERSION_SetVersion(int nMajor, int nMinor)
{
    struct MK_VERSION_DATA verData;
    verData.nMajor = nMajor;
    verData.nMinor = nMinor;
    return verData;
}

struct MK_VERSION_DATA MK_VERSION_Initialize(object oPC, int bDisplayMessage)
{
    struct MK_VERSION_DATA verData;
    string sNWNversion = GetStringLowerCase(GetLocalString(oPC, "MK_NWN_VERSION_DETECTION"));
    if (sNWNversion=="auto")
    {
//        verData = MK_VERSION_DetectGameVersion(oPC, GetLocalInt(oPC, "MK_NWN_VERSION_DEBUG_MESSAGE"));
        verData = MK_VERSION_DetectGameVersionEx(oPC);
        SendMessageToPC(oPC, "NWN version detection: NWN version "+MK_VERSION_VersionDataToString(verData)+" detected.");
    }
    else if (sNWNversion=="")
    {
        verData = MK_VERSION_SetVersion(MK_NWN_VERSION_CURRENT_MAJOR, MK_NWN_VERSION_CURRENT_MINOR);
        SendMessageToPC(oPC, "NWN version detection: NWN version "+MK_VERSION_VersionDataToString(verData)+" assumed.");
    }
    else if (StringToFloat(sNWNversion)>1.0f)
    {
        verData = MK_VERSION_StringToVersionData(sNWNversion);
        SendMessageToPC(oPC, "NWN version detection: NWN version "+MK_VERSION_VersionDataToString(verData)+" assumed.");
    }
    else
    {
        verData = MK_VERSION_SetVersion(MK_NWN_VERSION_CURRENT_MAJOR, MK_NWN_VERSION_CURRENT_MINOR);
        SendMessageToPC(oPC, "NWN version detection: Unrecognized NWN version detection mode: '"+sNWNversion+"'! NWN version "+MK_VERSION_VersionDataToString(verData)+" assumed.");
    }
    MK_VERSION_VersionDataToLocal(verData, oPC);

    return verData;
}

struct MK_VERSION_DATA MK_VERSION_GetGameVersion(object oPC)
{
    oPC = MK_VERSION_GetObject(oPC);
    struct MK_VERSION_DATA verData = MK_VERSION_LocalToVersionData(oPC);
    if (!MK_VERSION_GetIsVersionDataValid(verData))
    {
        verData = MK_VERSION_Initialize(oPC, TRUE);
    }
    return verData;
}

int MK_VERSION_GetIsExtendedVersion(object oPC)
{
    return MK_VERSION_GetIsVersionGreaterEqual_1_74(oPC);
}

int MK_VERSION_GetIsVersionLower(object oPC, int nMajor, int nMinor)
{
    struct MK_VERSION_DATA verData = MK_VERSION_GetGameVersion(oPC);
    return ((verData.nMajor<nMajor) || ((verData.nMajor==nMajor) && (verData.nMinor<nMinor)));
}

int MK_VERSION_GetIsVersionGreaterEqual(object oPC, int nMajor, int nMinor)
{
    struct MK_VERSION_DATA verData = MK_VERSION_GetGameVersion(oPC);
    return ((verData.nMajor>nMajor) || ((verData.nMajor==nMajor) && (verData.nMinor>=nMinor)));
}

int MK_VERSION_GetIsVersionGreaterEqual_1_80(object oPC)
{
    return MK_VERSION_GetIsVersionGreaterEqual(oPC, 1, 80);
}

int MK_VERSION_GetIsVersionGreaterEqual_1_75(object oPC)
{
    return MK_VERSION_GetIsVersionGreaterEqual(oPC, 1, 75);
}

int MK_VERSION_GetIsVersionGreaterEqual_1_74(object oPC)
{
    return MK_VERSION_GetIsVersionGreaterEqual(oPC, 1, 74);
}

int MK_VERSION_GetIsVersionGreaterEqual_1_69(object oPC)
{
    return MK_VERSION_GetIsVersionGreaterEqual(oPC, 1, 69);
}

int MK_VERSION_GetIsVersionGreaterEqual_1_67(object oPC)
{
    return MK_VERSION_GetIsVersionGreaterEqual(oPC, 1, 67);
}

int MK_VERSION_GetIsVersionGreaterEqual_1_66(object oPC)
{
    return MK_VERSION_GetIsVersionGreaterEqual(oPC, 1, 66);
}

int MK_VERSION_GetIsVersionGreaterEqual_1_64(object oPC)
{
    return MK_VERSION_GetIsVersionGreaterEqual(oPC, 1, 64);
}

int MK_VERSION_GetIsVersionGreaterEqual_1_61(object oPC)
{
    return MK_VERSION_GetIsVersionGreaterEqual(oPC, 1, 61);
}

int MK_VERSION_GetIsVersionLower_1_61(object oPC)
{
    return MK_VERSION_GetIsVersionLower(oPC, 1, 67);
}

int MK_VERSION_GetIsVersionLower_1_67(object oPC)
{
    return MK_VERSION_GetIsVersionLower(oPC, 1, 67);
}

int MK_VERSION_GetIsVersionLower_1_68(object oPC)
{
    return MK_VERSION_GetIsVersionLower(oPC, 1, 68);
}

int MK_VERSION_GetIsVersionLower_1_69(object oPC)
{
    return MK_VERSION_GetIsVersionLower(oPC, 1, 69);
}

int MK_VERSION_GetIsVersionLower_1_74(object oPC)
{
    return MK_VERSION_GetIsVersionLower(oPC, 1, 74);
}

int MK_VERSION_GetIsVersionLower_1_79(object oPC)
{
    return MK_VERSION_GetIsVersionLower(oPC, 1, 79);
}

int MK_VERSION_GetIsVersionLower_1_83(object oPC)
{
    return MK_VERSION_GetIsVersionLower(oPC, 1, 83);
}

string MK_VERSION_Get2DAString(string sColumn, int nRow)
{
    return Get2DAString(MK_NWN_VERSION_2DAFILE, sColumn, nRow);
}

int MK_VERSION_Get2DAInt(string sColumn, int nRow)
{
    return MK_Get2DAInt(MK_NWN_VERSION_2DAFILE, sColumn, nRow);
}

float MK_VERSION_VersionDataToFloat(struct MK_VERSION_DATA verData)
{
    return (1.0f * verData.nMajor)
        + ( (1.0f * verData.nMinor) / pow(10.0f, 1.0f * GetStringLength(IntToString(verData.nMinor))) );
}

string MK_VERSION_VersionDataToString(struct MK_VERSION_DATA verData)
{
    return IntToString(verData.nMajor)+"."+IntToString(verData.nMinor);
}

struct MK_VERSION_DATA MK_VERSION_StringToVersionData(string sNWNversion)
{
    struct MK_VERSION_DATA verData;
    int n = FindSubString(sNWNversion, ".");
    if (n<=0)
    {
        verData = MK_VERSION_SetVersion(-1,0);
    }
    else
    {
        verData = MK_VERSION_SetVersion(
            StringToInt(GetStringLeft(sNWNversion, n)),
            StringToInt(GetStringRight(sNWNversion, GetStringLength(sNWNversion)-n-1)));
    }
    return verData;
}

void MK_VERSION_VersionDataToLocal(struct MK_VERSION_DATA verData, object oPC)
{
    SetLocalInt(oPC, MK_NWN_VERSION_MAJOR, verData.nMajor);
    SetLocalInt(oPC, MK_NWN_VERSION_MINOR, verData.nMinor);
}

void MK_VERSION_VersionToLocal(int nMajor, int nMinor, object oPC)
{
//    MK_DEBUG_TRACE("MK_VERSION_VersionToLocal("+IntToString(nMajor)+", "+IntToString(nMinor)+")");
    SetLocalInt(oPC, MK_NWN_VERSION_MAJOR, nMajor);
    SetLocalInt(oPC, MK_NWN_VERSION_MINOR, nMinor);
}

struct MK_VERSION_DATA MK_VERSION_LocalToVersionData(object oPC)
{
    struct MK_VERSION_DATA verData;
    verData.nMajor = GetLocalInt(oPC, MK_NWN_VERSION_MAJOR);
    verData.nMinor = GetLocalInt(oPC, MK_NWN_VERSION_MINOR);
    return verData;
}

int MK_VERSION_GetIsVersionDataValid(struct MK_VERSION_DATA verData)
{
    return (verData.nMajor>=1);
}

struct MK_VERSION_DATA MK_VERSION_DetectGameVersion(object oPC, int bDisplayProgress)
{
    int nVersionMajor = 1;
    int nVersionMinor = 0;
    int bOk = TRUE;
    int iRow=0;
    struct MK_VERSION_DATA verData;
    string s2DAFile;
    string s2DACol;
    int n2DARow;
    string s2DAValue;
    int b2DAIsEqual;

    while (bOk)
    {
        verData = MK_VERSION_SetVersion(nVersionMajor, nVersionMinor);

        nVersionMajor = MK_VERSION_Get2DAInt("Major", iRow);
        nVersionMinor = MK_VERSION_Get2DAInt("Minor", iRow);

        if (nVersionMajor>=1)
        {
            s2DAFile = MK_VERSION_Get2DAString("2DA_FILE", iRow);
            s2DACol = MK_VERSION_Get2DAString("2DA_COL", iRow);
            if ((s2DAFile != "") && (s2DACol != ""))
            {
                n2DARow = MK_VERSION_Get2DAInt("2DA_ROW", iRow);
                s2DAValue = MK_VERSION_Get2DAString("2DA_VALUE", iRow);
                b2DAIsEqual = MK_VERSION_Get2DAInt("2DA_EQUAL", iRow);

                string sValue = Get2DAString(s2DAFile, s2DACol, n2DARow);

                bOk = (b2DAIsEqual ? (sValue == s2DAValue) : (sValue != s2DAValue));

                if (bDisplayProgress)
                {
                    if (!bOk)
                    {
                        SendMessageToPC(oPC, "NWN version detection: version '"
                            + MK_VERSION_Get2DAString("Version", iRow)
                            + "' test failed: Get2DAString("+s2DAFile+","+s2DACol+","+IntToString(n2DARow)+")='"
                            + sValue + "' " + (b2DAIsEqual ? "unequal" : "equal") + " '" + s2DAValue + "'");
                    }
                    else
                    {
                        SendMessageToPC(oPC, "NWN version detection: version '"
                            + MK_VERSION_Get2DAString("Version", iRow)
                            + "' test passed: Get2DAString("+s2DAFile+","+s2DACol+","+IntToString(n2DARow)+")='"
                            + sValue + "' " + (b2DAIsEqual ? "equal" : "unequal") + " '" + s2DAValue + "'");
                    }
                }
            }
            else
            {
                bOk = TRUE;
            }
        }
        else
        {
            bOk = FALSE;
        }
        iRow++;
    }
    return verData;
}

int MK_VERSION_FindSubString(string sString, string sSubString, int nStart)
{
    if (nStart==0)
    {
        return FindSubString(sString, sSubString);
    }
    else if (MK_VERSION_GetIsVersionGreaterEqual_1_69())
    {
        return FindSubString(sString, sSubString, nStart);
    }
    string sStringQ = GetStringRight(sString, GetStringLength(sString) - nStart);
    int nReturn = FindSubString(sStringQ, sSubString);
    if (nReturn != -1)
    {
        nReturn+=nStart;
    }
    return nReturn;
}



/*
int MK_SetGameVersion(object oPC, int nGameVersion)
{
    SetLocalInt(oPC, "MK_DETECTED_GAME_VERSION", nGameVersion);
    return nGameVersion;
}
*/

void MK_VERSION_DetectGameVersionQ(object oPC, int bDisplayProgress)
{
    if (bDisplayProgress)
    {
        SendMessageToPC(oPC, "Extended game version detection...");
    }
    int nReturn;
    string sReturn;
    MK_VERSION_VersionToLocal(1, 22, oPC);

    // The follwing function was added in 1.23
    // int GetStealthMode(object oCreature);
    // if we crash we're not running NWN 1.23
    nReturn = GetStealthMode(oPC);
    MK_VERSION_VersionToLocal(1, 23, oPC);

    // No new command in 1.24 unfortunately

    // The follwing function was added in 1.25
    // int GetStealthMode(object oCreature);
    // if we crash we're not running NWN 1.25
    sReturn = GetResRef(oPC);
    MK_VERSION_VersionToLocal(1, 25, oPC);

    // No new command in 1.26 unfortunately

    // The follwing function was added in 1.27
    // int GetDroppableFlag(object oItem);
    // if we crash we're not running NWN 1.27
    nReturn = GetDroppableFlag(oPC);
    MK_VERSION_VersionToLocal(1, 27, oPC);

    // The follwing function was added in 1.28
    // object CopyObject(object oSource, location locLocation, object oOwner = OBJECT_INVALID, string sNewTag = "");
    // if we crash we're not running NWN 1.28
    CopyObject(OBJECT_INVALID, GetLocation(oPC));
    MK_VERSION_VersionToLocal(1, 28, oPC);

    // No new command in 1.29 unfortunately

    // The follwing function was added in 1.30
    // int GetAppearanceType(object oCreature);
    // if we crash we're not running NWN 1.30
    nReturn = GetAppearanceType(oPC);
    MK_VERSION_VersionToLocal(1, 30, oPC);

    // The follwing function was added in 1.31
    // int GetWeather(object oArea);
    // if we crash we're not running NWN 1.31
    nReturn = GetWeather(GetArea(oPC));
    MK_VERSION_VersionToLocal(1, 31, oPC);

    // No new command in 1.32 unfortunately

    // The follwing function was added in 1.61
    // int GetIsCreatureDisarmable(object oCreature)
    // if we crash we're not running NWN 1.61
    nReturn = GetIsCreatureDisarmable(oPC);
    MK_VERSION_VersionToLocal(1, 61, oPC);

    // No new command in 1.62 unfortunately

    // No patch notes for 1.63 (did it acutually exist?)

    // The follwing function was added in 1.64
    // int GetPhenoType(object oCreature)
    // if we crash we're not running NWN 1.64
    nReturn = GetPhenoType(oPC);
    MK_VERSION_VersionToLocal(1, 64, oPC);

    // The follwing function was added in 1.65
    // int GetSkyBox(object oArea=OBJECT_INVALID)
    // if we crash we're not running NWN 1.65
    nReturn = GetSkyBox();
    MK_VERSION_VersionToLocal(1, 65, oPC);

    // The follwing function was added in 1.66
    // int GetPickpocketableFlag(object oItem)
    // if we crash we're not running NWN 1.66
    nReturn = GetPickpocketableFlag(oPC);
    MK_VERSION_VersionToLocal(1, 66, oPC);

    // The follwing function was added in 1.67
    // int GetCreatureWingType(object oCreature=OBJECT_SELF)
    // if we crash we're not running NWN 1.67
    nReturn = GetCreatureWingType(oPC);
    MK_VERSION_VersionToLocal(1, 67, oPC);

    // The follwing function was added in 1.68
    // void SetUseableFlag(object oPlaceable, int nUseableFlag);
    // if we crash we're not running NWN 1.68
    SetUseableFlag(OBJECT_INVALID, FALSE);
    MK_VERSION_VersionToLocal(1, 68, oPC);

    // The follwing function was added in 1.69
    // string GetPCChatMessage()
    // if we crash we're not running NWN 1.69
    sReturn = GetPCChatMessage();
    MK_VERSION_VersionToLocal(1, 69, oPC);

    // The follwing function was added in 1.74
    // object GetFirstArea();
    // if we crash we're not running NWN 1.74
    GetFirstArea();
    MK_VERSION_VersionToLocal(1, 74, oPC);

    // The follwing function was added in 1.75
    // float GetObjectVisualTransform(object oObject, int nTransform);
    // if we crash we're not running NWN 1.75
    //GetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_SCALE);
    //MK_VERSION_VersionToLocal(1, 75, oPC);
    // Build 8193.21 has changed the signature of GetObjectVisualTransform()
    // and also SetObjectVisualTransform() so we would crash here always if
    // we're running on NWN pre 8193.21.
    // As there aren't any other function new to 1.75 we can't detect it
    // anymore unfortunately.

    // no idea how to detect 1.76
    // no idea how to detect 1.77
    // no idea how to detect 1.78

    // The follwing function was added in 1.79
    // string GetRandomUUID();
    // if we crash we're not running NWN 1.79
    sReturn = GetRandomUUID();
    MK_VERSION_VersionToLocal(1, 79, oPC);

    // The follwing function was added in 1.80
    // int GetPlayerBuildVersionMajor(object oPlayer);
    // if we crash we're not running NWN 1.80
    nReturn = GetPlayerBuildVersionMajor(oPC);
    MK_VERSION_VersionToLocal(1, 80, oPC);

    if (!MK_VERSION_GetIsBuildVersionGreaterEqual(oPC, 8193, 13))
    {
        return;
    }
    MK_VERSION_VersionToLocal(1, 81, oPC);

    if (!MK_VERSION_GetIsBuildVersionGreaterEqual(oPC, 8193, 20))
    {
        return;
    }
    MK_VERSION_VersionToLocal(1, 82, oPC);
    if (!MK_VERSION_GetIsBuildVersionGreaterEqual(oPC, 8193, 21))
    {
        return;
    }
    MK_VERSION_VersionToLocal(1, 83, oPC);
}

struct MK_VERSION_DATA MK_VERSION_DetectGameVersionEx(object oPC)
{
    MK_VERSION_VersionToLocal(1, 0, oPC);
    ExecuteScript("mk_get_version", oPC);
    return MK_VERSION_LocalToVersionData(oPC);
}

int MK_VERSION_GetIsBuildVersionGreaterEqual(object oPC, int nMajor, int nMinor)
{
    int nReturn = FALSE;

    oPC = MK_VERSION_GetObject(oPC);

    if (MK_VERSION_GetIsVersionGreaterEqual_1_80(oPC))
    {
        nReturn = (GetPlayerBuildVersionMajor(oPC)>nMajor)
            || ( (GetPlayerBuildVersionMajor(oPC)==nMajor)
                    &&
                 (GetPlayerBuildVersionMinor(oPC)>=nMinor) );
    }
    return nReturn;
}


