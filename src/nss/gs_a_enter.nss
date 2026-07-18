#include "gs_inc_boss"
#include "gs_inc_common"
#include "gs_inc_encounter"
#include "gs_inc_justice"
#include "gs_inc_location"
#include "gs_inc_fixture"
#include "gs_inc_flag"
#include "gs_inc_placeable"
#include "gs_inc_sequencer"
#include "gs_inc_text"
#include "gs_inc_time"
#include "gs_inc_worship"
#include "gs_inc_subrace"

const int GS_TIMEOUT = 1200; //TIME UPDATE: 20 minutes

void gsActivateRecreator(object oRecreator)
{
    object oObject = CreateObject(GetLocalInt(oRecreator, "GS_TYPE"),
                                  GetLocalString(oRecreator, "GS_TEMPLATE"),
                                  GetLocation(oRecreator));

    if (GetIsObjectValid(oObject)) SetLocalInt(oObject, "GS_STATIC", TRUE);

    DestroyObject(oRecreator);
}
//----------------------------------------------------------------
void gsActivateActivator(object oObject)
{
    ExecuteScript(GetLocalString(oObject, "GS_SCRIPT"), oObject);
}
//----------------------------------------------------------------
void main()
{
    object oEntering   = GetEnteringObject();
    if (! GetIsPC(oEntering)) return;
    object oModule     = GetModule();
    object oArea       = OBJECT_SELF;
    string sString     = "";
    int nTimestamp     = GetLocalInt(oModule, "GS_TIMESTAMP");
    int nTimestampArea = GetLocalInt(OBJECT_SELF, "GS_TIMESTAMP");
    int nTimeout       = nTimestamp - nTimestampArea > GS_TIMEOUT;
    int nDayTime       = gsTIGetCurrentDayTime();
    int nEnabled       = GetLocalInt(OBJECT_SELF, "GS_ENABLED");
    int nOverrideDeath = gsFLGetAreaFlag("OVERRIDE_DEATH", oEntering);

    //ambience
    if (nDayTime != gsTIGetDayTime()) gsSEAdd("gs_run_ambience", oArea);

    //area flags
    if (gsFLGetAreaFlag("EXPLORE_MAP", oEntering))         ExploreAreaForPlayer(OBJECT_SELF, oEntering);
    if (gsFLGetAreaFlag("PVP", oEntering))                 sString += " [" + GS_T_16777291 + "]";
    if (gsFLGetAreaFlag("REST", oEntering))                sString += " [" + GS_T_16777292 + "]";
    if (! gsFLGetAreaFlag("OVERRIDE_MAGIC", oEntering))    sString += " [" + GS_T_16777446 + "]";
    if (! gsFLGetAreaFlag("OVERRIDE_STATE", oEntering))    sString += " [" + GS_T_16777293 + "]";
    if (! gsFLGetAreaFlag("OVERRIDE_TELEPORT", oEntering)) sString += " [" + GS_T_16777294 + "]";
    if (! gsFLGetAreaFlag("OVERRIDE_TRANSFER", oEntering)) sString += " [" + GS_T_16777444 + "]";
    if (! nOverrideDeath)                                  sString += " [" + GS_T_16777295 + "]";
    if (sString != "")                                     SendMessageToPC(oEntering, GS_T_16777296 + ":" + sString);

    //area description
    sString = GetLocalString(OBJECT_SELF, "GS_TEXT");
    if (sString != "") DelayCommand(2.5, SendMessageToPC(oEntering, "<câÛÂ>" + sString));

    //clean up area
    if (nTimestampArea != nTimestamp)
    {
        object oObject = GetFirstObjectInArea(OBJECT_SELF);
        object oItem   = OBJECT_INVALID;
        string sString = "";

        while (GetIsObjectValid(oObject))
        {
            sString = GetTag(oObject);

            switch (GetObjectType(oObject))
            {
            case OBJECT_TYPE_AREA_OF_EFFECT:

                break;

            case OBJECT_TYPE_CREATURE:

                //dead creature
                if (GetIsDead(oObject))
                {
                    //resurrect creature
                    if (! gsFLGetFlag(GS_FL_MORTAL, oObject) &&
                        GetLocalInt(oObject, "GS_TIMEOUT") < nTimestamp)
                    {
                        gsCMResurrect(oObject);
                    }

                    break;
                }

                //activate ai
                SetAILevel(oObject, AI_LEVEL_LOW);
                break;

            case OBJECT_TYPE_DOOR:

                //close door
                if (GetIsOpen(oObject))
                {
                    AssignCommand(oObject, ActionCloseDoor(oObject));
                }

                //lock door
                if (GetLockLockable(oObject))
                {
                    SetLocked(oObject, TRUE);
                }

                break;

            case OBJECT_TYPE_ENCOUNTER:

            case OBJECT_TYPE_ITEM:

            case OBJECT_TYPE_PLACEABLE:

                //static
                if (! nEnabled)
                {
                    SetLocalInt(oObject, "GS_STATIC", TRUE);
                }

                //close placeable
                if (GetIsOpen(oObject))
                {
                    AssignCommand(oObject, ActionCloseDoor(oObject));
                }

                //lock placeable
                if (GetLockLockable(oObject))
                {
                    SetLocked(oObject, TRUE);
                }

                //recreator
                if (sString == "GS_RECREATOR")
                {
                    if (GetLocalInt(oObject, "GS_TIMEOUT") < nTimestamp)
                    {
                        DelayCommand(0.5, gsActivateRecreator(oObject));
                    }
                }

                //activator
                else if (sString == "GS_ACTIVATOR")
                {
                    DelayCommand(0.5, gsActivateActivator(oObject));
                }

                break;

            case OBJECT_TYPE_STORE:

                oItem = GetFirstItemInInventory(oObject);

                //clean store
                if (GetLocalInt(oObject, "GS_ENABLED"))
                {
                    while (GetIsObjectValid(oItem))
                    {
                        if (! GetLocalInt(oItem, "GS_STORE"))
                        {
                            DestroyObject(oItem);
                        }

                        oItem = GetNextItemInInventory(oObject);
                    }
                }

                //initialize store
                else
                {
                    SetLocalInt(oObject, "GS_ENABLED", TRUE);

                    while (GetIsObjectValid(oItem))
                    {
                        SetLocalInt(oItem, "GS_STORE", TRUE);
                        oItem = GetNextItemInInventory(oObject);
                    }
                }

                break;

            case OBJECT_TYPE_TRIGGER:

                break;

            case OBJECT_TYPE_WAYPOINT:

                break;
            }

            oObject = GetNextObjectInArea(OBJECT_SELF);
        }

        gsSEAdd("gs_run_cleanarea", oArea);
        gsARRegisterArea(OBJECT_SELF);
    }

    //load area
    if (! nEnabled)
    {
        gsENLoadArea();
        gsBOLoadArea();
        gsPLLoadArea();
        gsFXLoadFixture(GetTag(OBJECT_SELF));

        SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);
    }

    SetLocalInt(OBJECT_SELF, "GS_TIMESTAMP", nTimestamp);

    //encounter
    if (nTimeout)
    {
        gsENSetUpArea();
        gsBOSetUpArea();
    }

    if (GetIsPossessedFamiliar(oEntering)) return;
    if (GetIsDMPossessed(oEntering))       return;
    if (GetIsDM(oEntering))
    {
        if (! GetLocalInt(oEntering, "GS_ENABLED"))
        {
            object oTarget = GetObjectByTag("GS_TARGET_DM");

            if (GetIsObjectValid(oTarget))
                AssignCommand(oEntering, JumpToLocation(GetLocation(oTarget)));
            SetLocalInt(oEntering, "GS_ENABLED", TRUE);
        }

        return;
    }

    //mortality
    SetImmortal(oEntering, nOverrideDeath);

    location lLocationExit = GetLocalLocation(oEntering, "GS_LOCATION");

    switch (GetLocalInt(oEntering, "GS_ENABLED"))
    {
    case TRUE:

        //export character
        if (GetPCPublicCDKey(oEntering) != "") ExportSingleCharacter(oEntering);

        //save player location
        if (! gsFLGetAreaFlag("OVERRIDE_LOCATION", oEntering))
        {
            gsLOSetDBLocationOf("GS_LOCATION",
                                gsPCGetPlayerID(oEntering),
                                oEntering);
        }

        SetLocalLocation(oEntering, "GS_LOCATION", GetLocation(oEntering));

        //subrace selection
        if (gsSUGetSubRace(oEntering) == GS_SU_NONE){
            ActionStartConversation(oEntering, "gs_su_select", TRUE, FALSE);
        }
        break;


    case -1:

        //initialisation
        gsSEAdd("gs_run_pc_init", oEntering);
        break;

    default:

        //load player location
        location lLocation = gsLOGetDBLocation("GS_LOCATION", gsPCGetPlayerID(oEntering));

        if (! GetIsObjectValid(GetAreaFromLocation(lLocation)))
            lLocation = GetLocation(GetObjectByTag("GS_TARGET_START"));

        AssignCommand(oEntering, JumpToLocation(lLocation));

        //initialize player state
        AssignCommand(oEntering, gsSTSetInitialState());

        SetLocalInt(oEntering, "GS_ENABLED", -1);
        break;
    }

    //verify deity
    string sDeity = GetDeity(oEntering);

    if (sDeity != "")
    {
        int nDeity = gsWOGetDeityByName(sDeity);

        if (nDeity) nDeity = gsWOGetIsDeityAvailable(nDeity, oEntering);

        if (! nDeity)
        {
            SetDeity(oEntering, "");
            SendMessageToPC(oEntering, GS_T_16777297);
        }
    }

    //banishment
    string sTag = GetLocalString(oArea, "GS_JUSTICE");

    if (sTag != "")
    {
        object oJustice = gsCMGetObject(sTag, OBJECT_TYPE_PLACEABLE);

        if (GetIsObjectValid(oJustice) &&
            gsJUGetIsConvict(oJustice, oEntering))
        {
            object oAreaExit = GetAreaFromLocation(lLocationExit);

            if (GetIsObjectValid(oAreaExit) &&
                oAreaExit != oArea &&
                GetLocalString(oAreaExit, "GS_JUSTICE") != sTag &&
                GetTag(oAreaExit) != "GS_AREA_DEATH")
            {
                AssignCommand(oEntering, JumpToLocation(lLocationExit));
                SendMessageToPC(oEntering, GS_T_16777524);
            }
            else
            {
                object oTargetExit = gsCMGetObject("GS_TARGET_" + sTag);

                if (GetIsObjectValid(oTargetExit))
                {
                    lLocationExit = GetLocation(oTargetExit);
                    oAreaExit     = GetAreaFromLocation(lLocationExit);

                    if (oAreaExit != oArea &&
                        GetLocalString(oAreaExit, "GS_JUSTICE") != sTag)
                    {
                        AssignCommand(oEntering, JumpToLocation(lLocationExit));
                        SendMessageToPC(oEntering, GS_T_16777525);
                    }
                }
            }
        }
    }
}
