#include "gs_inc_common"
#include "gs_inc_text"

void main()
{
    object oExiting = GetExitingObject();

    //store health
    SetLocalInt(GetModule(),
                "GS_HEALTH_" + ObjectToString(oExiting),
                GetCurrentHitPoints(oExiting));
}
