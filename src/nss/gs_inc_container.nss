/* CONTAINER library by Gigaschatten */

//void main() {}

//load nLimit objects from database sID to oContainer
void gsCOLoad(string sID, object oContainer, int nLimit = 10);
//save nLimit objects within oContainer to database sID
void gsCOSave(string sID, object oContainer, int nLimit = 10);

void gsCOLoad(string sID, object oContainer, int nLimit = 10)
{
    if (GetIsObjectValid(oContainer))
    {
        location lLocation = GetLocation(oContainer);
        string sNth        = "";
        int nNth           = 0;

        for (nNth = 1; nNth <= nLimit; nNth++)
        {
            sNth = IntToString(nNth);

            if (GetCampaignInt("GS_CO_" + sID, "SLOT_" + sNth))
            {
                RetrieveCampaignObject("GS_CO_" + sID,
                                       "OBJECT_" + sNth,
                                       lLocation,
                                       oContainer);
            }
        }
    }
}
//----------------------------------------------------------------
void gsCOSave(string sID, object oContainer, int nLimit = 10)
{
    if (GetIsObjectValid(oContainer) &&
        GetHasInventory(oContainer))
    {
        object oObject = GetFirstItemInInventory(oContainer);
        string sNth    = "";
        int nNth       = 0;

        while (GetIsObjectValid(oObject) &&
               nNth < nLimit)
        {
            sNth    = IntToString(++nNth);
            StoreCampaignObject("GS_CO_" + sID, "OBJECT_" + sNth, oObject);
            SetCampaignInt("GS_CO_" + sID, "SLOT_" + sNth, TRUE);
            oObject = GetNextItemInInventory(oContainer);
        }

        while (nNth < nLimit)
        {
            sNth    = IntToString(++nNth);
            SetCampaignInt("GS_CO_" + sID, "SLOT_" + sNth, FALSE);
        }
    }
}
