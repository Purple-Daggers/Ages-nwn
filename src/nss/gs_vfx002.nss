const int GS_LIMIT = 100;

void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

    object oObject = GetFirstObjectInArea();

    while (GetIsObjectValid(oObject))
    {
        if (GetObjectType(oObject) == OBJECT_TYPE_PLACEABLE &&
            GetHasInventory(oObject) &&
            GetStringLeft(GetTag(oObject), 13) == "GS_INVENTORY_")
        {
            SetLocalInt(oObject, "GS_LIMIT", GS_LIMIT);
            ExecuteScript("gs_co_open", oObject);
        }

        oObject = GetNextObjectInArea();
    }

    DestroyObject(OBJECT_SELF);
}
