#include "mk_inc_generic"
#include "mk_inc_editor"
#include "mk_inc_craft"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oTarget = MK_GetCurrentTarget(oPC);
    object oItem = CIGetCurrentModItem(oPC);

    int nAction = MK_GenericDialog_GetAction(TRUE);
    switch (nAction)
    {
    case 0:
    case -1:
        SetLocalString(oPC, "MK_NEWNAME", "");
        break;
    case 21:
        // rename item
        SetName(oItem, GetLocalString(oPC, "MK_NEWNAME"));
        break;
    case 22:
        // restore original name
        SetName(oItem, "");
        break;
    case 100:
        // pressed OK in the 'edit box' -> get the name
        {
            string sText = MK_TrimString(GetLocalString(oPC, g_varEditorBuffer));
            int bDisableColors = GetLocalInt(oPC, g_varEditorDisableColors);
            if (bDisableColors)
            {
            // We don't want colors, so lets remove them.
            // Just in case the user used the chat line to
            // enter color tokens.
                sText = MK_RemoveColorTagsFromString(sText);
            }
            else
            {
            // We close all color tags in case the user has forgotten
            // to do so.
                sText = MK_CloseColorTags(sText);
            }
            SetLocalString(oPC, "MK_NEWNAME", sText);
        }
        MK_Editor_CleanUp(oPC);
        break;
    case 101:
        // pressed Cancel in the 'edit box'
//        SetLocalString(oPC, "MK_NEWNAME", "");
        MK_Editor_CleanUp(oPC);
        break;
    }

    MK_InitializeRenameItem(oPC, oItem);

    // In case the editor gets started
    int nMaxLength = GetLocalInt(oPC, "MK_ITEM_NAME_MAX_LENGTH");
    int bUseChatEvent = GetLocalInt(oPC, "MK_EDITOR_USE_CHAT_EVENT");
    MK_PrepareEditor(oPC, 1, 20, 21, "Rename item:",
        nMaxLength>0 ? nMaxLength : 30,
        TRUE, FALSE, bUseChatEvent);
//    MK_GenericDialog_SetCondition(100, TRUE);
//    MK_GenericDialog_SetCondition(101, FALSE);
//    MK_GenericDialog_SetCondition(102, FALSE);
//    MK_GenericDialog_SetCondition(103, FALSE);

    MK_SetCustomTokenByItemTypeName(oTarget, oPC);

    return TRUE;
}
