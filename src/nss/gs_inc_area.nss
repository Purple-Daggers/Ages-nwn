/* AREA Library by Gigaschatten */

//void main() {}

//register oArea
void gsARRegisterArea(object oArea);
//return registered area by nIndex
object gsARGetRegisteredArea(int nIndex);
//unregister oArea
void gsARUnregisterArea(object oArea);
//return number of registered areas
int gsARGetRegisteredAreaCount();
//return TRUE if oArea is active
int gsARGetIsAreaActive(object oArea);
//return x size of oArea
float gsARGetSizeX(object oArea);
//return y size of oArea
float gsARGetSizeY(object oArea);

void gsARRegisterArea(object oArea)
{
    if (GetLocalInt(oArea, "GS_AR_INDEX")) return;

    object oModule = GetModule();
    int nIndex     = gsARGetRegisteredAreaCount() + 1;

    SetLocalObject(oModule, "GS_AR_" + IntToString(nIndex), oArea);
    SetLocalInt(oModule, "GS_AR_COUNT", nIndex);
    SetLocalInt(oArea, "GS_AR_INDEX", nIndex);
}
//----------------------------------------------------------------
object gsARGetRegisteredArea(int nIndex)
{
    return GetLocalObject(GetModule(), "GS_AR_" + IntToString(nIndex));
}
//----------------------------------------------------------------
void gsARUnregisterArea(object oArea)
{
    object oModule = GetModule();
    int nIndex     = GetLocalInt(oArea, "GS_AR_INDEX");
    int nCount     = gsARGetRegisteredAreaCount();

    if (nIndex >= 1 && nIndex <= nCount)
    {
        if (nIndex < nCount)
        {
            object oObject = GetLocalObject(oModule, "GS_AR_" + IntToString(nCount));

            SetLocalObject(oModule, "GS_AR_" + IntToString(nIndex), oObject);
            SetLocalInt(oObject, "GS_AR_INDEX", nIndex);
            nIndex         = nCount;
        }

        DeleteLocalObject(oModule, "GS_AR_" + IntToString(nIndex));
        SetLocalInt(oModule, "GS_AR_COUNT", nCount - 1);
    }

    DeleteLocalInt(oArea, "GS_AR_INDEX");
}
//----------------------------------------------------------------
int gsARGetRegisteredAreaCount()
{
    return GetLocalInt(GetModule(), "GS_AR_COUNT");
}
//----------------------------------------------------------------
int gsARGetIsAreaActive(object oArea)
{
    return GetLocalInt(oArea, "GS_ENABLED") &&
           GetLocalInt(oArea, "GS_TIMESTAMP") == GetLocalInt(GetModule(), "GS_TIMESTAMP");
}
//----------------------------------------------------------------
float gsARGetSizeX(object oArea)
{
    return IntToFloat(GetAreaSize(AREA_WIDTH, oArea) * 10);
}
//----------------------------------------------------------------
float gsARGetSizeY(object oArea)
{
    return IntToFloat(GetAreaSize(AREA_HEIGHT, oArea) * 10);
}
