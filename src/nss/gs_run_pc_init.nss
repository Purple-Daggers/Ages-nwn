#include "gs_inc_chain"
#include "gs_inc_common"
#include "gs_inc_listener"
#include "gs_inc_strack"
#include "gs_inc_text"
#include "mi_inc_checker"

const int GS_EXPERIENCE_BASE = 1000; //level 2

void gsCreateBaseInventory()
{
    object oInventory = GetObjectByTag("GS_INVENTORY_PLAYER");

    if (GetIsObjectValid(oInventory))
    {
        object oItem  = GetFirstItemInInventory(oInventory);
        object oCopy  = OBJECT_INVALID;
        object oDress = OBJECT_INVALID;

        while (GetIsObjectValid(oItem))
        {
            oCopy = CopyItem(oItem, OBJECT_SELF);

            if (GetIsObjectValid(oCopy))
            {
                SetIdentified(oCopy, TRUE);
                SetStolenFlag(oCopy, FALSE);

                if (! GetIsObjectValid(oDress) &&
                    GetBaseItemType(oCopy) == BASE_ITEM_ARMOR)
                {
                    oDress = oCopy;
                }
            }

            oItem = GetNextItemInInventory(oInventory);
        }

        if (GetIsObjectValid(oDress))
            ActionEquipItem(oDress, INVENTORY_SLOT_CHEST);
    }
}
//----------------------------------------------------------------
void gsInitialize()
{
    SetCommandable(TRUE);

    if (! GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CARMOUR)))
    {
        if (GetHitDice(OBJECT_SELF) == 1)
        {
            // Edit by Mithreas: enable this block to check if character is
            // valid before initialising them.  You may need to raise the
            // server TMI (too many instructions) limit if yours is low.
            /*
            if (!miCharacterIsLegal(OBJECT_SELF))
            {
              SendMessageToPC(OBJECT_SELF, "!!!Illegal character!!!");
            }
            else
            {
              SendMessageToPC(OBJECT_SELF, "Character is legal.");
            } */

            //remove gold
            TakeGoldFromCreature(GetGold(), OBJECT_SELF, TRUE);

            //remove inventory
            gsCMDestroyInventory();

            //give base experience
            if (GetXP(OBJECT_SELF) < GS_EXPERIENCE_BASE)
                GiveXPToCreature(OBJECT_SELF, GS_EXPERIENCE_BASE);

            //remove tattoos
            SetCreatureBodyPart(CREATURE_PART_LEFT_BICEP,    CREATURE_MODEL_TYPE_SKIN);
            SetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM,  CREATURE_MODEL_TYPE_SKIN);
            SetCreatureBodyPart(CREATURE_PART_LEFT_SHIN,     CREATURE_MODEL_TYPE_SKIN);
            SetCreatureBodyPart(CREATURE_PART_LEFT_THIGH,    CREATURE_MODEL_TYPE_SKIN);
            SetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP,   CREATURE_MODEL_TYPE_SKIN);
            SetCreatureBodyPart(CREATURE_PART_RIGHT_FOREARM, CREATURE_MODEL_TYPE_SKIN);
            SetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN,    CREATURE_MODEL_TYPE_SKIN);
            SetCreatureBodyPart(CREATURE_PART_RIGHT_THIGH,   CREATURE_MODEL_TYPE_SKIN);
            SetCreatureBodyPart(CREATURE_PART_TORSO,         CREATURE_MODEL_TYPE_SKIN);

            //remove tail
            SetCreatureTailType(CREATURE_TAIL_TYPE_NONE);

            //remove wings
            SetCreatureWingType(CREATURE_WING_TYPE_NONE);
        }

        //clean inventory
        else
        {
            string sItemStripScript = GetLocalString(GetModule(), "GS_ITEM_STRIP_SCRIPT");

            if (sItemStripScript != "") ExecuteScript(sItemStripScript, OBJECT_SELF);
        }

        //create base inventory
        DelayCommand(0.5, gsCreateBaseInventory());

        //subrace selection
        ActionStartConversation(OBJECT_SELF, "gs_su_select", TRUE, FALSE);
    }

    //chain
    else if (gsCHGetHasChain())
    {
        object oChain = gsCHGetChain();

        gsCHRemoveChain(oChain);
        gsCHApplyChain(oChain, OBJECT_SELF);
    }

    //listener
    gsLICreateListener(OBJECT_SELF);

    SendMessageToPC(OBJECT_SELF, GS_T_16777216);

    //mana system for magic

    gsCMCalculateMaximumMana(OBJECT_SELF);

    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);
}
//----------------------------------------------------------------
void main()
{
    //spelltracker
    gsSPTActionApply();

    ActionDoCommand(gsInitialize());
    SetCommandable(FALSE);
}
