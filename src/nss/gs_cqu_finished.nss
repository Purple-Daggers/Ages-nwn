#include "gs_inc_quest"

int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();
    string sPlot    = GetLocalString(OBJECT_SELF, "GS_QU_PLOT");

    return gsQUGetHasFinishedPlot(sPlot, oSpeaker);
}
