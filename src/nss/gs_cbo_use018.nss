#include "gs_inc_booksh"
#include "gs_inc_forum"
void main()
{
    SetLocalInt(OBJECT_SELF, "GS_BOOK", -1);
    DeleteLocalInt(OBJECT_SELF, "GS_PAGE_START");
    if(GetLocalString(OBJECT_SELF, "GS_NB_ID") != ""){
        gsFODeleteContent();
        DeleteLocalString(OBJECT_SELF, "GS_NB_ID");
    }
}

