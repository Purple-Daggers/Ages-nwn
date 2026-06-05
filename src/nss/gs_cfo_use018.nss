#include "gs_inc_forum"
void main()
{
    SetLocalInt(OBJECT_SELF, "GS_MESSAGE", -1);
    DeleteLocalInt(OBJECT_SELF, "GS_PAGE_START");
    if(GetIsPC(OBJECT_SELF)){
        gsFODeleteContent();
    }
}
