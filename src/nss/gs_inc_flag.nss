/* FLAG Library by Gigaschatten */

//void main() {}

const int GS_FL_DISABLE_AI     = 1;
const int GS_FL_DISABLE_CALL   = 2;
const int GS_FL_DISABLE_COMBAT = 3;
const int GS_FL_DISABLE_LOOT   = 4;
const int GS_FL_MORTAL         = 5;
const int GS_FL_ENCOUNTER      = 6;
const int GS_FL_BOSS           = 7;

//enable/disable nFlag for oObject
void gsFLSetFlag(int nFlag, object oObject = OBJECT_SELF, int nValid = TRUE);
//return TRUE if nFlag is enabled for oObject
int gsFLGetFlag(int nFlag, object oObject = OBJECT_SELF);
//enable/disable sFlag for area of oObject
void gsFLSetAreaFlag(string sFlag, object oObject = OBJECT_SELF, int nValid = TRUE);
//return TRUE if sFlag is enabled for area of oObject
int gsFLGetAreaFlag(string sFlag, object oObject = OBJECT_SELF);

void gsFLSetFlag(int nFlag, object oObject = OBJECT_SELF, int nValid = TRUE)
{
    int nNth        = nFlag / 32;
    string sString  = "GS_FL_" + IntToString(nNth);
    int nMatrix     = GetLocalInt(oObject, sString);
    nFlag           = 1 << nFlag % 32;

    if (nValid) nMatrix |= nFlag;
    else        nMatrix &= ~nFlag;

    SetLocalInt(oObject, sString, nMatrix);
}
//----------------------------------------------------------------
int gsFLGetFlag(int nFlag, object oObject = OBJECT_SELF)
{
    int nNth       = nFlag / 32;
    string sString = "GS_FL_" + IntToString(nNth);
    int nMatrix    = GetLocalInt(oObject, sString);
    nFlag          = 1 << nFlag % 32;

    return GetLocalInt(oObject, sString) & nFlag;
}
//----------------------------------------------------------------
void gsFLSetAreaFlag(string sFlag, object oObject = OBJECT_SELF, int nValid = TRUE)
{
    object oArea = GetArea(oObject);

    if (nValid) SetLocalInt(oArea, "GS_FL_" + sFlag, TRUE);
    else        DeleteLocalInt(oArea, "GS_FL_" + sFlag);
}
//----------------------------------------------------------------
int gsFLGetAreaFlag(string sFlag, object oObject = OBJECT_SELF)
{
    object oArea = GetArea(oObject);

    return GetLocalInt(oArea, "GS_FL_" + sFlag);
}
