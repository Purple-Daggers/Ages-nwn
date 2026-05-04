#include "gs_inc_quest"

int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();
    string sPlot    = GetLocalString(OBJECT_SELF, "GS_QU_PLOT");

    return gsQUGetIsPlotEntryActive(sPlot, GS_QU_ENTRY_30, oSpeaker);
}
