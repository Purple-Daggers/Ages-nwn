/* FIXTURE library by Gigaschatten */

#include "gs_inc_location"

//void main() {}

//load nLimit objects from database sID
void gsFXLoadFixture(string sID, int nLimit = 40);
//save oFixture to database sID containing a maximum of nLimit objects and return TRUE on success
int gsFXSaveFixture(string sID, object oFixture = OBJECT_SELF, int nLimit = 40);
//delete oFixture from database sID containing a maximum of nLimit objects
void gsFXDeleteFixture(string sID, object oFixture = OBJECT_SELF, int nLimit = 40);

void gsFXLoadFixture(string sID, int nLimit = 40)
{
    location lLocation;
    string sTemplate = "";
    string sNth      = "";
    int nNth         = 0;

    for (nNth = 1; nNth <= nLimit; nNth++)
    {
        sNth = IntToString(nNth);

        if (GetCampaignInt("GS_FX_" + sID, "SLOT_" + sNth))
        {
            sTemplate = GetCampaignString("GS_FX_" + sID, "TEMPLATE_" + sNth);
            lLocation = gsLOGetDBLocation("GS_FX_" + sID, "LOCATION_" + sNth);

            CreateObject(OBJECT_TYPE_PLACEABLE, sTemplate, lLocation);
        }
    }
}
//----------------------------------------------------------------
int gsFXSaveFixture(string sID, object oFixture = OBJECT_SELF, int nLimit = 40)
{
    string sNth = "";
    int nNth    = 0;

    for (nNth = 1; nNth <= nLimit; nNth++)
    {
        sNth = IntToString(nNth);

        if (! GetCampaignInt("GS_FX_" + sID, "SLOT_" + sNth))
        {
            SetCampaignInt("GS_FX_" + sID, "SLOT_" + sNth, TRUE);
            SetCampaignString("GS_FX_" + sID, "TEMPLATE_" + sNth, GetResRef(oFixture));
            gsLOSetDBLocationOf("GS_FX_" + sID, "LOCATION_" + sNth, oFixture);
            return TRUE;
        }
    }

    return FALSE;
}
//----------------------------------------------------------------
void gsFXDeleteFixture(string sID, object oFixture = OBJECT_SELF, int nLimit = 40)
{
    struct gsLOLocation gsLocation = gsLOGetLocationX(oFixture);
    string sNth                    = "";
    int nNth                       = 0;

    for (nNth = 1; nNth <= nLimit; nNth++)
    {
        sNth      = IntToString(nNth);

        if (GetCampaignInt("GS_FX_" + sID, "SLOT_" + sNth) &&
            gsLOGetDBLocationX("GS_FX_" + sID, "LOCATION_" + sNth) == gsLocation)
        {
            SetCampaignInt("GS_FX_" + sID, "SLOT_" + sNth, FALSE);
            return;
        }
    }
}
