//////////////////////////////////////////////////////////
/*
   Item Appearance Modification Conversation
   Cancel Conversation Script
*/
//////////////////////////////////////////////////////////

//#include "mk_inc_init"
#include "mk_inc_generic"
#include "mk_inc_craft"
#include "mk_inc_ccoh_db"
#include "mk_inc_2da_disp"
#include "mk_inc_ccoh_db"

void main()
{

    object oPC = GetPCSpeaker();

    object oTarget = MK_GetCurrentTarget(oPC);

    MK_DEBUG_TRACE("Executing 'mk_im_cancel' script. Current mod mode is '"+IntToString(CIGetCurrentModMode(oPC))+"!");
//    MK_DEBUG_TRACE(" > oPC: '"+GetName(oPC)+"'");
//    MK_DEBUG_TRACE(" > oTarget: '"+GetName(oTarget)+"'");

//    int bDisableExtendedEditionFeatures = MK_INIT_GetAreEEFeaturesDisabled();

    switch (CIGetCurrentModMode(oPC))
    {
    case X2_CI_MODMODE_INVALID:
        AssignCommand(oPC, ClearAllActions());
        break;
    case MK_CI_MODMODE_CHARACTER:
        MK_RestoreCharacterDescription(oPC);
        SendMessageToPC(oPC, "Canceling character description editing - original description is restored.");
        AssignCommand(oPC,ClearAllActions());
        break;
    case MK_CI_MODMODE_BODY:
        //MK_CCOH_DB_RestoreBody(oTarget);
        //SendMessageToPC(oPC, "Canceling body modifying - original appearance is restored.");
        //MK_DoneBodyPart(oPC, oTarget);
        AssignCommand(oPC,ClearAllActions());
        break;
    case X2_CI_MODMODE_ARMOR:
    case X2_CI_MODMODE_WEAPON:
    case MK_CI_MODMODE_CLOAK:
    case MK_CI_MODMODE_HELMET:
    case MK_CI_MODMODE_SHIELD:
        SendMessageToPC(oPC, "Canceling item modifying - original appearance is restored.");
        MK_CancelModifyItem(oTarget, oPC);
        break;
    case MK_CI_MODMODE_ITEM:
        SendMessageToPC(oPC, "Canceling item modifying - original item is restored.");
        MK_CancelModifyItem(oTarget, oPC);
        break;
    }

    CISetCurrentModMode(oPC,X2_CI_MODMODE_INVALID );

    MK_RemoveTemporaryEffects(oPC, MK_TAG_TEMP_EFFECT, oTarget);

    if (!GetLocalInt(oPC, MK_KEEP_CURRENT_TARGET))
    {
        MK_SetCurrentTarget(oPC, OBJECT_INVALID);
    }
    else
    {
        DeleteLocalInt(oPC, MK_KEEP_CURRENT_TARGET);
    }

    // in case the ESC key was used to exit the dialog
    MK_Editor_CleanUp(oPC);

    MK_CCOH_DB_Cleanup(oPC);
    MK_2DA_DISPLAY_Cleanup();

    MK_GenericDialog_CleanUp();

    MK_INIT_Cleanup(oPC, "MK_CCOH", "MK_CCOH_USER");

    RestoreCameraFacing();

}
