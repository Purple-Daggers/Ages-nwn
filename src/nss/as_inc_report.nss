int asRPTGetReportValue(object oReport)
{
    int nUniqueAreas = GetLocalInt(oReport, "AS_PLACES_VISITED");
    int nKills = GetLocalInt(oReport, "AS_TOTAL_KILLS");
    int nUniqueKills = GetLocalInt(oReport, "AS_UNIQUE_ENEMIES");
    return (nUniqueAreas * 20) + (nKills * 5) + (nUniqueKills * 20);
}