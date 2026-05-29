
void main()
{
    string sMessage        = GetStringLeft(GetLocalString(OBJECT_SELF, "GS_ME_TEXT_1") + "\n", 10000);

    SetLocalString(OBJECT_SELF, "GS_ME_TEXT_1", sMessage);
}
