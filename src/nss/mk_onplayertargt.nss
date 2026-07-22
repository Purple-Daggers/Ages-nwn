#include "mk_inc_craft"
#include "mk_inc_debug"
#include "mk_inc_version"

void MK_SetEventScript(object oObject, int nHandler, string sScript)
{
    SetEventScript(oObject, nHandler, sScript);
}

string MK_GetEventScript(object oObject, int nHandler)
{
    return GetEventScript(oObject, nHandler);
}


void main()
{
    MK_DEBUG_TRACE("mk_onplayertargt...");

    MK_RestorePlayerTargetScript();

    object oPC = GetLastPlayerToSelectTarget();
    object oTargetOld = MK_GetCurrentTarget(oPC);
    object oTargetNew = GetTargetingModeSelectedObject();
    int nEnableTarget = GetLocalInt(oPC, "MK_ENABLE_SELECT_TARGET");

    MK_DEBUG_TRACE(" > oPC="+GetName(oPC));
    MK_DEBUG_TRACE(" > oTargetOld="+GetName(oTargetOld));
    MK_DEBUG_TRACE(" > oTargetNew="+GetName(oTargetNew));

    if (GetIsObjectValid(oTargetNew))
    {
        if (GetIsPC(oTargetNew) && (oTargetNew != oPC)) // no PCs allowed
        {
            SendMessageToPC(oPC, "Invalid target! You can't modify other PCs!");
            oTargetNew = oTargetOld;
        }
        else if (nEnableTarget==1) // henchmen only
        {
            if (!MK_GetIsHenchman(oTargetNew, oPC))
            {
                SendMessageToPC(oPC, "Invalid target! Only your own henchmen are allowed!");
                oTargetNew = oTargetOld;
            }
        }

        if (oTargetNew!=oTargetOld)
        {
            MK_SetCurrentTarget(oPC, oTargetNew);
            if (oTargetNew!=oPC)
            {
                AssignCommand(oPC, ActionForceMoveToObject(oTargetNew, FALSE, 1.0f, 5.0f));

                if (MK_VERSION_GetIsVersionGreaterEqual_1_74(oPC))
                {
                    string sOnConversationScript = MK_GetEventScript(oTargetNew, EVENT_SCRIPT_CREATURE_ON_DIALOGUE);
                    if (sOnConversationScript!="")
                    {
                        SetLocalString(oTargetNew, "MK_CCOH_ON_DIALOG_SCRIPT", sOnConversationScript);
                        SetEventScript(oTargetNew, EVENT_SCRIPT_CREATURE_ON_DIALOGUE, "");
                        // safety belt: if dialog does not start for some reason then this will restore the OnConversation script
                        DelayCommand(10.0f, MK_SetEventScript(oTargetNew, EVENT_SCRIPT_CREATURE_ON_DIALOGUE, sOnConversationScript));
                    }
                }
            }
        }
    }
    else
    {
        oTargetNew = oTargetOld;
    }

    AssignCommand(oPC, ActionStartConversation(oTargetNew, "x0_skill_ctrap", TRUE, FALSE));
}
