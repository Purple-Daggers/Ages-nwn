void main()
{
    string sMessage = GetStringLeft(GetLocalString(OBJECT_SELF, "GS_CIP_DESC_TEXT_1"), 10000);
    object oItem = GetFirstItemInInventory();
    if (GetIsObjectValid(oItem))
    {
        SetDescription(oItem, sMessage);
        DeleteLocalString(OBJECT_SELF, "GS_CIP_DESC_TEXT_1");
    }
}

