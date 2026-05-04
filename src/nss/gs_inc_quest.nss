/* QUEST Library by Gigaschatten */

//void main() {}

#include "gs_inc_xp"

const int GS_QU_ENTRY_1  =  1;
const int GS_QU_ENTRY_2  =  2;
const int GS_QU_ENTRY_3  =  3;
const int GS_QU_ENTRY_4  =  4;
const int GS_QU_ENTRY_5  =  5;
const int GS_QU_ENTRY_6  =  6;
const int GS_QU_ENTRY_7  =  7;
const int GS_QU_ENTRY_8  =  8;
const int GS_QU_ENTRY_9  =  9;
const int GS_QU_ENTRY_10 = 10;
const int GS_QU_ENTRY_11 = 11;
const int GS_QU_ENTRY_12 = 12;
const int GS_QU_ENTRY_13 = 13;
const int GS_QU_ENTRY_14 = 14;
const int GS_QU_ENTRY_15 = 15;
const int GS_QU_ENTRY_16 = 16;
const int GS_QU_ENTRY_17 = 17;
const int GS_QU_ENTRY_18 = 18;
const int GS_QU_ENTRY_19 = 19;
const int GS_QU_ENTRY_20 = 20;
const int GS_QU_ENTRY_21 = 21;
const int GS_QU_ENTRY_22 = 22;
const int GS_QU_ENTRY_23 = 23;
const int GS_QU_ENTRY_24 = 24;
const int GS_QU_ENTRY_25 = 25;
const int GS_QU_ENTRY_26 = 26;
const int GS_QU_ENTRY_27 = 27;
const int GS_QU_ENTRY_28 = 28;
const int GS_QU_ENTRY_29 = 29;
const int GS_QU_ENTRY_30 = 30;
const int GS_QU_ENTRY_31 = 31;

//activate nEntry of sPlot on each member of oPC's faction nearby
void gsQUActivatePlotEntry(string sPlot, int nEntry, object oPC = OBJECT_SELF);
//return TRUE is nEntry of oPlot is active on oPC
int gsQUGetIsPlotEntryActive(string sPlot, int nEntry, object oPC = OBJECT_SELF);
//finish sPlot with nEntry for each member of oPC's faction nearby
void gsQUFinishPlot(string sPlot, int nEntry, object oPC = OBJECT_SELF);
//return TRUE if oPC has finished sPlot
int gsQUGetHasFinishedPlot(string sPlot, object oPC = OBJECT_SELF);

void gsQUActivatePlotEntry(string sPlot, int nEntry, object oPC = OBJECT_SELF)
{
    if (! GetIsPC(oPC)) return;

    object oArea   = GetArea(oPC);
    object oMember = OBJECT_INVALID;
    int nMatrix    = 0;
    int nBit       = 1 << (nEntry - 1);

    oMember        = GetFirstFactionMember(oPC);

    while (GetIsObjectValid(oMember))
    {
        int nMatrix = GetLocalInt(oMember, "GS_QU_PLOT_" + sPlot);

        if (GetArea(oMember) == oArea &&
            ! (nMatrix & nBit || nMatrix & 0x80000000))
        {
            AddJournalQuestEntry(sPlot, nEntry, oMember, FALSE, FALSE, TRUE);
            SetLocalInt(oMember, "GS_QU_PLOT_" + sPlot, nMatrix | nBit);
        }

        oMember = GetNextFactionMember(oPC);
    }
}
//----------------------------------------------------------------
int gsQUGetIsPlotEntryActive(string sPlot, int nEntry, object oPC = OBJECT_SELF)
{
    if (! GetIsPC(oPC)) return FALSE;

    int nBit = 1 << (nEntry - 1);

    return GetLocalInt(oPC, "GS_QU_PLOT_" + sPlot) & nBit > 0;
}
//----------------------------------------------------------------
void gsQUFinishPlot(string sPlot, int nEntry, object oPC = OBJECT_SELF)
{
    if (! GetIsPC(oPC)) return;

    object oArea   = GetArea(oPC);
    object oMember = OBJECT_INVALID;
    int nMatrix    = 0;
    int nXP        = GetJournalQuestExperience(sPlot);

    oMember        = GetFirstFactionMember(oPC);

    while (GetIsObjectValid(oMember))
    {
        int nMatrix = GetLocalInt(oMember, "GS_QU_PLOT_" + sPlot);

        if (GetArea(oMember) == oArea &&
            ! nMatrix & 0x80000000)
        {
            AddJournalQuestEntry(sPlot, nEntry, oMember, FALSE, FALSE, TRUE);
            gsXPGiveExperience(oMember, nXP);
            SetLocalInt(oMember, "GS_QU_PLOT_" + sPlot, nMatrix | 0x80000000);
        }

        oMember = GetNextFactionMember(oPC);
    }
}
//----------------------------------------------------------------
int gsQUGetHasFinishedPlot(string sPlot, object oPC = OBJECT_SELF)
{
    return gsQUGetIsPlotEntryActive(sPlot, 32, oPC);
}
