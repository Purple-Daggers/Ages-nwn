void main()
{
    ExecuteScript("gs_m_enter", OBJECT_SELF);

    object oEntering = GetEnteringObject();
    int nNth         = 0;

    for (; nNth < 10; nNth++)
    {
        AddJournalQuestEntry("CUSTOM" + IntToString(nNth), 1, oEntering, FALSE);
    }
}
