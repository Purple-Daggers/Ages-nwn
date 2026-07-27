
void main()
{
    if(!(GetLocalInt(OBJECT_SELF, "AS_LOOTED") == TRUE))
    {
        object oUser = GetLastUsedBy();
        DelayCommand(0.0f, PlaySound("it_coins"));
        SetLocalInt(OBJECT_SELF, "AS_LOOTED", TRUE);
        CreateItemOnObject("NW_IT_GOLD001", oUser, Random(401) + 100);
        DestroyObject(OBJECT_SELF, 1.0f);
    }
}
