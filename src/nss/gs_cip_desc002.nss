#include "gs_inc_listener"

void main()
{
    string sMessage = gsLIGetLastMessage(GetPCSpeaker());
    sMessage        = GetStringLeft(GetLocalString(OBJECT_SELF, "GS_CIP_DESC_TEXT_1") + sMessage, 10000);

    gsLIClearLastMessage(GetPCSpeaker());
    SetLocalString(OBJECT_SELF, "GS_CIP_DESC_TEXT_1", sMessage);
}

