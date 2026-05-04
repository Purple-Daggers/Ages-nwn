#include "gs_inc_area"

const int BA_COUNT = 16;

void gsRun()
{
    object oArea = GetArea(OBJECT_SELF);

    if (! gsARGetIsAreaActive(oArea))
    {
        DeleteLocalInt(OBJECT_SELF, "BA_ENABLED");
        return;
    }

    SetLocalInt(OBJECT_SELF, "BA_RANDOM", Random(BA_COUNT));
    SpeakOneLinerConversation();

    DelayCommand(20.0, gsRun());
}
//----------------------------------------------------------------
void main()
{
    if (GetLocalInt(OBJECT_SELF, "BA_ENABLED")) return;
    SetLocalInt(OBJECT_SELF, "BA_ENABLED", TRUE);

    gsRun();
}
