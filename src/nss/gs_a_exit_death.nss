#include "gs_inc_effect"

void main()
{
    object oExiting = GetExitingObject();

    gsFXRemoveEffect(oExiting, OBJECT_SELF);

    ExecuteScript("gs_a_enter", OBJECT_SELF);
}
