#include "gs_inc_ambience"
#include "gs_inc_time"

void main()
{
    //time
    SetLocalInt(OBJECT_SELF, "GS_YEAR", GetCalendarYear());

    int nTimestamp = GetCampaignInt("GS_SYSTEM", "TIMESTAMP");

    if (nTimestamp) gsTISetTime(nTimestamp);

    //restart timeout
    int nTimeout   = GetLocalInt(OBJECT_SELF, "GS_RESTART_TIMEOUT");

    if (nTimeout)
    {
        nTimeout = nTimestamp + gsTIGetGameTimestamp(nTimeout);
        SetLocalInt(OBJECT_SELF, "GS_RESTART_TIMEOUT", nTimeout);
    }

    //spellscript
    SetLocalString(OBJECT_SELF, "X2_S_UD_SPELLSCRIPT", "gs_spellscript");

    //hide in plain sight check
    //ExecuteScript("gs_run_hipscheck", OBJECT_SELF);

    //ambience
    gsAMInitialize();
}
