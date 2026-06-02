#include "gs_inc_listener"

int StartingConditional()
{
    gsLIClearLastMessage();
    DeleteLocalString(OBJECT_SELF, "GS_ME_TEXT_1");
    DeleteLocalString(OBJECT_SELF, "GS_ME_TEXT_2");
    DeleteLocalString(OBJECT_SELF, "GS_ME_TEXT_3");
    DeleteLocalString(OBJECT_SELF, "GS_ME_TEXT_4");
    return TRUE;
}
