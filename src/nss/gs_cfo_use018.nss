void main()
{
    SetLocalInt(OBJECT_SELF, "GS_MESSAGE", -1);
    DeleteLocalInt(OBJECT_SELF, "GS_PAGE_START");
    if(GetResRef(OBJECT_SELF) == "gs_fo_helper")
    {
        DestroyObject(OBJECT_SELF);
    }
}
