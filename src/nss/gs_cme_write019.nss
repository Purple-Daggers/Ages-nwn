#include "gs_inc_listener"

void main()
{
    string sMessage = gsLIGetLastMessage();
    sMessage        = GetStringLeft(GetLocalString(OBJECT_SELF, "GS_ME_TEXT_1") + sMessage, 10000);

    gsLIClearLastMessage();
    SetLocalString(OBJECT_SELF, "GS_ME_TEXT_1", sMessage);
}
