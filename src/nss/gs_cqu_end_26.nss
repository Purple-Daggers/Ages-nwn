#include "gs_inc_quest"

void main()
{
    object oSpeaker = GetPCSpeaker();
    string sPlot    = GetLocalString(OBJECT_SELF, "GS_QU_PLOT");

    gsQUFinishPlot(sPlot, GS_QU_ENTRY_26, oSpeaker);
}
