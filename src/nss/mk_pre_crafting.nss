#include "mk_inc_init"
#include "mk_inc_craft"
#include "mk_inc_horse"
#include "mk_inc_body"
#include "mk_inc_generic"
#include "mk_inc_debug"
#include "mk_inc_states"
#include "mk_inc_version"
#include "mk_inc_language"
#include "mk_inc_delimiter"

/*void PrintItem(object oItem)
{
    int nBaseItemType = GetBaseItemType(oItem);
    SendMessageToPC(GetPCSpeaker(),
          "name='"+GetName(oItem)+
        "', type='"+IntToString(nBaseItemType)+
        "', 2DA='"+Get2DAString("baseitems","EquipableSlots", nBaseItemType)+
        "', label='"+Get2DAString("baseitems","label", nBaseItemType)+"'");
//        "', 2DA='"+Get2DAString("baseitem","EquipableSlots", GetBaseItemType(oItem))+"'");
}

void PrintItems(object oPC)
{
    object oItem;
    int iSlot;
    for (iSlot = 0; iSlot<NUM_INVENTORY_SLOTS; iSlot++)
    {
        oItem = GetItemInSlot(iSlot, oPC);
        if (GetIsObjectValid(oItem))
            PrintItem(oItem);
    }
    oItem = GetFirstItemInInventory(oPC);
    while (GetIsObjectValid(oItem))
    {
        PrintItem(oItem);
        oItem = GetNextItemInInventory(oPC);
    }
}*/


int GetIsCraftingDisabled(object oPC, int i)
{
    string sVarName = "MK_DISABLE_CRAFT_" + MK_IntToString(i, 2, "0");
    return (GetLocalInt(oPC, sVarName)==1);
}

int GetIsACPInstalled(object oPC)
{
    int iRow=0;
    string sLabel;
    string sColumn="Label";
    string s2DAfile = "phenotype";
    string sPhenoType = GetLocalString(oPC, "MK_ACP_PHENOTYPE");
    int nMaxRow = GetLocalInt(oPC, "MK_ACP_MAX_ROW");
    do
    {
        sLabel = Get2DAString(s2DAfile, sColumn, iRow++);
        if (sLabel == sPhenoType) return TRUE;
    }
    while (iRow<=nMaxRow);
    return FALSE;
}

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oTarget = MK_GetCurrentTarget(oPC);

    int nState = MK_GenericDialog_GetState();
    int nAction = MK_GenericDialog_GetAction();

    MK_DEBUG_TRACE("mk_pre_crafting: state="+IntToString(nState));

    switch (nState)
    {
    case MK_STATE_INVALID:
        MK_INIT_Initialize(oPC, "MK_CCOH", "MK_CCOH_USER");

        MK_LANG_DetectLanguage(oPC, TRUE);

        MK_VERSION_Initialize(oPC, TRUE);
/*        if (MK_VERSION_GetIsVersionLower_1_61(oPC))
        {
            SendMessageToPC(oPC, "Your game version is far to low for CCOH to run properly! Most likely the CCOH will crash immediately, sorry!");
        }
        else*/

//        SendMessageToPC(oPC, "Last Speaker: "+GetName(GetLastSpeaker()));

        if (MK_VERSION_GetIsVersionLower_1_69(oPC))
        {
            SendMessageToPC(oPC, "Your game version is too low to run the CCOH properly. Most likely CCOH will crash ('stack underflow' errors caused by modified scripting commands)!");
        }
        else if (MK_VERSION_GetIsVersionLower_1_74(oPC))
        {
            SendMessageToPC(oPC, "The CCOH should run without any problems. New features that require NWN EE are disabled of course!");
        }
        else if (MK_VERSION_GetIsVersionLower_1_83(oPC))
        {
            SendMessageToPC(oPC, "The CCOH is compiled with a newer version of NWN toolset but it should run without problems.");
        }

        MK_GenericDialog_CleanUp();

        DeleteLocalInt(oPC, MK_PERPARTCOLORING);

        CISetCurrentModItem(oPC, OBJECT_INVALID);
        CISetCurrentModBackup(oPC, OBJECT_INVALID);

        CISetCurrentModMode(oPC, X2_CI_MODMODE_INVALID);

        MK_GenericDialog_SetState(nState = MK_STATE_INIT);

        MK_SetCurrentTarget(oPC, oTarget = OBJECT_SELF);

        if (oPC!=oTarget)
        {
            if (MK_VERSION_GetIsVersionGreaterEqual_1_74(oPC))
            {
                string sOnConversationScript = GetLocalString(oTarget, "MK_CCOH_ON_DIALOG_SCRIPT");
                if (sOnConversationScript!="")
                {
                    SetEventScript(oTarget, EVENT_SCRIPT_CREATURE_ON_DIALOGUE, sOnConversationScript);
                    DeleteLocalString(oTarget, "MK_CCOH_ON_DIALOG_SCRIPT");
                }
            }
        }

        break;

    case MK_STATE_CHEATS:
        MK_GenericDialog_SetState(nState = MK_STATE_INIT);
        break;

    case MK_STATE_INIT:
        switch (nAction)
        {
        case 30:
            MK_DEBUG_TRACE("Select Target...");
            MK_SetPlayerTargetScript(MK_CCOH_ONPLAYERTARGETSCRIPT);
            EnterTargetingMode(oPC, OBJECT_TYPE_CREATURE, MOUSECURSOR_MAGIC);
            break;
        case 31:
            OpenInventory(oTarget, oPC);
            break;
        }
        break;
    }

    MK_DEBUG_TRACE("OBJECT_SELF: "+GetName(OBJECT_SELF));
    MK_DEBUG_TRACE("PC: "+GetName(oPC));
    MK_DEBUG_TRACE("LastSpeaker: "+GetName(GetLastSpeaker()));
    MK_DEBUG_TRACE("CurrentTarget: "+GetName(oTarget));

    switch (nState)
    {
    case MK_STATE_INIT:
    {
        int bOk=FALSE;

        int nPartBased = MK_GetIsPartBasedAppearanceType(oTarget);

        string sVarName;
        int i;
        int nSlot;
        for (i=1; i<=10; i++)
        {
        // 01-10: modify items (armor, helmet, cloak, shield, weapon)
        // !!! 02,04,06,08,10 are using the previous 01,03,05,07,09 calculation !!!

            switch (i)
            {
            case 1:
                nSlot = INVENTORY_SLOT_CHEST;
                break;
            case 3:
                nSlot = INVENTORY_SLOT_HEAD;
                break;
            case 5:
                nSlot = INVENTORY_SLOT_CLOAK;
                break;
            case 7:
                nSlot = INVENTORY_SLOT_LEFTHAND;
                break;
            case 9:
                nSlot = INVENTORY_SLOT_RIGHTHAND;
                break;
            case 2:
            case 4:
            case 6:
            case 8:
            case 10:
                nSlot = -1;
                bOk = !bOk;
                break;
            }
            if (nSlot!=-1)
            {
                bOk = (nPartBased && (!GetIsCraftingDisabled(oPC, i)));

                switch (nSlot)
                {
                case INVENTORY_SLOT_CLOAK:
                    bOk = bOk && MK_VERSION_GetIsVersionGreaterEqual_1_61(oPC);
                    break;
                }

                if (bOk)
                {
                    object oItem = GetItemInSlot(nSlot, oTarget);

                    bOk = MK_GetIsAllowedToModifyItem(oPC, oItem, oTarget);
                    if (bOk)
                    {
                        switch (i)
                        {
                        case 7:
                            bOk = bOk && MK_GetIsShield(oItem);
                            break;
                        case 9:
                            bOk = bOk && MK_GetIsModifiableWeapon(oItem)
                                      && (!IPGetIsIntelligentWeapon(oItem));
                            break;
                        }
                    }
                }
            }
            MK_GenericDialog_SetCondition(i, bOk);
        }

// riding
        bOk = !GetIsCraftingDisabled(oPC, 20) && MK_VERSION_GetIsVersionGreaterEqual_1_69(oPC);
        if (bOk)
        {
            bOk = (MK_GetIsRiding(oTarget) || MK_GetIsNotRiding(oTarget));
            if (!bOk)
            {
                int nPhenoType = GetPhenoType(oTarget);
                SendMessageToPC(oPC, "Riding is disabled because of unrecognized phenotype '"
                    +IntToString(nPhenoType)+"'. Add/update row '"+IntToString(nPhenoType)
                    +"' of file 'mk_ride_pheno.2da' if you want to ride.");
            }
        }
        MK_GenericDialog_SetCondition(20, bOk);

        MK_GenericDialog_SetCondition(30,
            MK_VERSION_GetIsBuildVersionGreaterEqual(oPC, 8193, 14) && GetLocalInt(oPC, "MK_ENABLE_SELECT_TARGET")); // enable select target

        MK_GenericDialog_SetCondition(35, (oPC == oTarget)); // craft trap

        MK_GenericDialog_SetCondition(31, MK_GetIsHenchman(oTarget, oPC) && GetLocalInt(oPC, "MK_ENABLE_OPEN_INVENTORY")); // open inventory

        MK_GenericDialog_SetCondition(40, (oPC == oTarget) && GetLocalInt(oPC, "MK_ENABLE_CHEATS"));

        MK_GenericDialog_SetCondition(100, (oPC == oTarget) && GetIsACPInstalled(oPC));

        MK_DELIMITER_Initialize();

        break;
    }
    }

    return TRUE;
}
