#include "mk_inc_generic"
#include "mk_inc_editor"
#include "mk_inc_craft"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oTarget = MK_GetCurrentTarget(oPC);
    object oItem = CIGetCurrentModItem(oPC);

    switch (CIGetCurrentModMode(oPC))
    {
    case X2_CI_MODMODE_INVALID:
        //
        CISetCurrentModMode(oPC, MK_CI_MODMODE_CHARACTER);
        MK_SaveCharacterDescription(oTarget);
        // !!! no break !!!
    case MK_CI_MODMODE_CHARACTER:
        oItem = oTarget;
        break;
    }

    int nAction = MK_GenericDialog_GetAction(TRUE);
    switch (nAction)
    {
    case 22:
        // restore original description
        SetDescription(oItem, "");
//        SetName(oItem, "");
        break;
    case 100:
        // pressed OK in the 'edit box' -> get the description
        {
            string sText = MK_TrimString(GetLocalString(oPC, g_varEditorBuffer));
            int bDisableColors = GetLocalInt(oPC, g_varEditorDisableColors);
            if (bDisableColors)
            {
            // We don't want colors, so lets remove them.
            // Just in case the user has used the chat line
            // to enter color tokens.
                sText = MK_RemoveColorTagsFromString(sText);
            }
            else
            {
            // We close all color tags in case the user has forgotten
            // to do so.
                sText = MK_CloseColorTags(sText);
            }
            SetDescription(oItem, sText);
//            SetLocalString(oPC, "MK_NEWNAME", sText);
        }
        MK_Editor_CleanUp(oPC);
        break;
    case 101:
        // pressed Cancel in the 'edit box'
        MK_Editor_CleanUp(oPC);
        break;
/*    case 21:
        // rename item
        SetName(oItem, GetLocalString(oPC, "MK_NEWNAME"));
        break;*/
    }

    MK_InitializeEditDescription(oPC, oItem);

    // In case the editor gets started
    int bUseChatEvent = GetLocalInt(oPC, "MK_EDITOR_USE_CHAT_EVENT");
    MK_PrepareEditor(oPC, 2, 22, 23, "Edit description:", -1, FALSE, FALSE, bUseChatEvent);

//    MK_GenericDialog_SetCondition(100, FALSE);
//    MK_GenericDialog_SetCondition(101, TRUE);
//    MK_GenericDialog_SetCondition(102, FALSE);
//    MK_GenericDialog_SetCondition(103, FALSE);

    MK_SetCustomTokenByItemTypeName(oTarget, oPC);

    return TRUE;
}
