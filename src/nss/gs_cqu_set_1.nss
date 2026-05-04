#include "gs_inc_quest"

void main()
{
    object oSpeaker = GetPCSpeaker();
    string sPlot    = GetLocalString(OBJECT_SELF, "GS_QU_PLOT");

    gsQUActivatePlotEntry(sPlot, GS_QU_ENTRY_1, oSpeaker);
}
