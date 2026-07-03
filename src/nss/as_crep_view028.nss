void main()
{
    DeleteLocalInt(OBJECT_SELF, "AS_REP_REPUTATION");
    DeleteLocalInt(OBJECT_SELF, "AS_REP_LOADED");
    DeleteLocalInt(OBJECT_SELF, "AS_REP_PAGE_START");
    int nSlot         = 1;
    while (TRUE)
    {
    DeleteLocalInt(OBJECT_SELF, "AS_REP_SLOT_" + IntToString(nSlot));
    if (++nSlot > 10) break;
    }
    DeleteLocalInt(OBJECT_SELF, "AS_REP_PAGE_END");
}
