#include "gs_inc_area"
#include "gs_inc_boss"
#include "gs_inc_common"
#include "gs_inc_encounter"
#include "gs_inc_flag"

const int GS_TIMEOUT = 3600; //1 hour

void main()
{
    if (! GetLocalInt(OBJECT_SELF, "GS_ENABLED"))
    {
        gsARUnregisterArea(OBJECT_SELF);
        return;
    }

    object oModule     = GetModule();
    int nTimestamp     = GetLocalInt(oModule, "GS_TIMESTAMP");
    int nTimestampArea = GetLocalInt(OBJECT_SELF, "GS_TIMESTAMP");

    //clean up area
    if (nTimestampArea != nTimestamp)
    {
        object oObject  = GetFirstObjectInArea(OBJECT_SELF);
        object oItem    = OBJECT_INVALID;
        string sString  = "";
        int nTimeout    = nTimestamp - nTimestampArea > GS_TIMEOUT;
        int nUnregister = TRUE;

        while (GetIsObjectValid(oObject))
        {
            switch (GetObjectType(oObject))
            {
            case OBJECT_TYPE_AREA_OF_EFFECT:

                break;

            case OBJECT_TYPE_CREATURE:

                //dead creature
                if (GetIsDead(oObject))
                {
                    //destroy creature
                    if (gsFLGetFlag(GS_FL_MORTAL, oObject))
                    {
                        gsCMDestroyObject(oObject);
                    }

                    break;
                }

                //encounter creature
                if (gsENGetIsEncounterCreature(oObject))
                {
                    //destroy creature
                    if (GetLocalInt(oObject, "GS_TIMEOUT") < nTimestamp)
                    {
                        gsCMDestroyObject(oObject);
                        break;
                    }

                    nUnregister = FALSE;
                    break;
                }

                //boss creature
                if (gsBOGetIsBossCreature(oObject))
                {
                    //destroy creature
                    if (GetLocalInt(oObject, "GS_TIMEOUT") < nTimestamp)
                    {
                        gsCMDestroyObject(oObject);
                        break;
                    }

                    nUnregister = FALSE;
                    break;
                }

                sString = GetTag(oObject);

                //dynamic encounter
                if (sString == "GS_ENCOUNTER")
                {
                    //destroy encounter
                    if (nTimeout)
                    {
                        DestroyObject(oObject);
                        break;
                    }

                    nUnregister = FALSE;
                    break;
                }

                //boss encounter
                if (sString == "GS_BOSS")
                {
                    //destroy encounter
                    if (nTimeout)
                    {
                        DestroyObject(oObject);
                        break;
                    }

                    nUnregister = FALSE;
                    break;
                }

                break;

            case OBJECT_TYPE_DOOR:

            case OBJECT_TYPE_ENCOUNTER:

                break;

            case OBJECT_TYPE_ITEM:

                //destroy item
                if (nTimeout)
                {
                    gsCMDestroyObject(oObject);
                    break;
                }

                nUnregister = FALSE;
                break;

            case OBJECT_TYPE_PLACEABLE:

                //dynamic
                if (! GetLocalInt(oObject, "GS_STATIC"))
                {
                    //destroy placeable
                    if (nTimeout)
                    {
                        gsCMDestroyObject(oObject);
                        break;
                    }

                    nUnregister = FALSE;
                }

                break;

            case OBJECT_TYPE_STORE:

                break;

            case OBJECT_TYPE_TRIGGER:

                break;

            case OBJECT_TYPE_WAYPOINT:

                break;
            }

            oObject = GetNextObjectInArea(OBJECT_SELF);
        }

        if (nUnregister) gsARUnregisterArea(OBJECT_SELF);
    }
}
