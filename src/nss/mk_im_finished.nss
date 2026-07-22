//////////////////////////////////////////////////////////
/*
   Item Appearance Modification Conversation
   Finish Conversation Script
*/
//////////////////////////////////////////////////////////

#include "mk_inc_generic"
#include "mk_inc_craft"
#include "mk_inc_body"
#include "mk_inc_horse"
#include "mk_inc_2da_disp"
#include "mk_inc_ccoh_db"

void main()
{
    object oPC = GetPCSpeaker();
    object oTarget = MK_GetCurrentTarget(oPC);
//    MK_DEBUG_TRACE("Executing 'mk_im_finish' script. Current mod mode is '"+IntToString(CIGetCurrentModMode(oPC))+"!");

    switch (CIGetCurrentModMode(oPC))
    {
    case X2_CI_MODMODE_INVALID:
        AssignCommand(oPC, ClearAllActions());
        break;
    case MK_CI_MODMODE_CHARACTER:
        AssignCommand(oPC, ClearAllActions());
        SendMessageToPC(oPC, "Finishing character description editing.");
        break;
    case MK_CI_MODMODE_BODY:
        switch (MK_GetBodyPartToBeModified(oPC))
        {
        case MK_CRAFTBODY_HORSE:
            if (MK_GetIsRiding(oTarget))
            {
                SetLocalInt(oTarget, MK_VAR_CURRENT_HORSE, GetCreatureTailType(oTarget));
            }
            break;
        }
        MK_DoneBodyPart(oPC, oTarget);
        SendMessageToPC(oPC, "Finishing body modifying.");
        break;
    case X2_CI_MODMODE_ARMOR:
    case X2_CI_MODMODE_WEAPON:
    case MK_CI_MODMODE_CLOAK:
    case MK_CI_MODMODE_HELMET:
    case MK_CI_MODMODE_SHIELD:
        MK_FinishModifyItem(oTarget, oPC);
        SendMessageToPC(oPC, "Finishing item modifying.");
        break;
    }
    CISetCurrentModMode(oPC, X2_CI_MODMODE_INVALID );

    MK_RemoveTemporaryEffects(oPC, MK_TAG_TEMP_EFFECT, oTarget);

    MK_SetCurrentTarget(oPC, OBJECT_INVALID);

    MK_CCOH_DB_Cleanup(oPC);
    MK_2DA_DISPLAY_Cleanup();

    MK_GenericDialog_CleanUp();

    MK_INIT_Cleanup(oPC, "MK_CCOH", "MK_CCOH_USER");

    RestoreCameraFacing() ;
}
