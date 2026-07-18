#include "gs_inc_common"
#include "gs_inc_iprop"
#include "gs_inc_text"
#include "gs_inc_subrace"

void gsUnequipItem(object oItem)
{
    CopyItem(oItem, OBJECT_SELF, TRUE);
    DestroyObject(oItem);
}
//----------------------------------------------------------------
void main()
{
    object oEquippedBy      = GetPCItemLastEquippedBy();
    object oEquipped        = GetPCItemLastEquipped();
    itemproperty ipProperty = GetFirstItemProperty(oEquipped);
    int nType               = 0;
    int nSubType            = 0;
    int nCost               = 0;
    int nParam              = 0;
    int nDurationType       = 0;

    //creature item
    switch (GetBaseItemType(oEquipped))
    {
    case BASE_ITEM_CBLUDGWEAPON:
    case BASE_ITEM_CPIERCWEAPON:
    case BASE_ITEM_CREATUREITEM:
    case BASE_ITEM_CSLASHWEAPON:
    case BASE_ITEM_CSLSHPRCWEAP:
        return;
    }

    //disallowed properties
    /*
    while (GetIsItemPropertyValid(ipProperty))
    {
        if (GetItemPropertyDurationType(ipProperty) == DURATION_TYPE_PERMANENT)
        {
            nType    = GetItemPropertyType(ipProperty);
            nSubType = GetItemPropertySubType(ipProperty);
            nCost    = GetItemPropertyCostTableValue(ipProperty);
            nParam   = GetItemPropertyParam1Value(ipProperty);

            switch (nType)
            {
            case ITEM_PROPERTY_DAMAGE_BONUS:
                if (nSubType == IP_CONST_DAMAGETYPE_MAGICAL)
                    //RemoveItemProperty(oEquipped, ipProperty);
                break;

            case ITEM_PROPERTY_DAMAGE_RESISTANCE:
                if (nSubType == IP_CONST_DAMAGETYPE_MAGICAL)
                {
                    //RemoveItemProperty(oEquipped, ipProperty);
                }
                else if (nSubType == IP_CONST_DAMAGETYPE_BLUDGEONING ||
                         nSubType == IP_CONST_DAMAGETYPE_PIERCING ||
                         nSubType == IP_CONST_DAMAGETYPE_SLASHING)
                {
                    //RemoveItemProperty(oEquipped, ipProperty);
                    //ipProperty = ItemPropertyDamageImmunity(nSubType, IP_CONST_DAMAGEIMMUNITY_5_PERCENT);
                    //gsIPAddItemProperty(oEquipped, ipProperty);
                }
                else if (nCost != IP_CONST_DAMAGERESIST_5)
                {
                    //RemoveItemProperty(oEquipped, ipProperty);
                    //ipProperty = ItemPropertyDamageResistance(nSubType, IP_CONST_DAMAGERESIST_5);
                    //gsIPAddItemProperty(oEquipped, ipProperty);
                }
                break;

            case ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE:
                if (nSubType == IP_CONST_DAMAGETYPE_MAGICAL)
                    //RemoveItemProperty(oEquipped, ipProperty);
                break;

            case ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP:
                if (nParam == IP_CONST_DAMAGETYPE_MAGICAL)
                    //RemoveItemProperty(oEquipped, ipProperty);
                break;

            case ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP:
                if (nParam == IP_CONST_DAMAGETYPE_MAGICAL)
                    //RemoveItemProperty(oEquipped, ipProperty);
                break;

            case ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT:
                if (nParam == IP_CONST_DAMAGETYPE_MAGICAL)
                    //RemoveItemProperty(oEquipped, ipProperty);
                break;

            case ITEM_PROPERTY_DAMAGE_REDUCTION:
                //RemoveItemProperty(oEquipped, ipProperty);
                break;

            case ITEM_PROPERTY_SKILL_BONUS:
                if (nCost > 5)
                {
                    //RemoveItemProperty(oEquipped, ipProperty);
                    //ipProperty = ItemPropertySkillBonus(nSubType, 5);
                    //gsIPAddItemProperty(oEquipped, ipProperty);
                }
                break;
            }
        }

        ipProperty = GetNextItemProperty(oEquipped);
    }
    */

    //Make sure that races with digitigrade legs have an appropriate shin model.
    if(GetBaseItemType(oEquipped) == BASE_ITEM_ARMOR)
    {
        int nLeftShinAppearance = GetItemAppearance(oEquipped, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LSHIN);
        int nRightShinAppearance = GetItemAppearance(oEquipped, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RSHIN);
        int nLeftFootAppearance = GetItemAppearance(oEquipped, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LFOOT);
        int nRightFootAppearance = GetItemAppearance(oEquipped, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RFOOT);
        if(gsSUGetHasDigitigradeLegs(oEquippedBy)) {
            if((nLeftShinAppearance != 136 && nLeftShinAppearance != 137) || (nRightShinAppearance != 136 && nRightShinAppearance != 137) || nLeftFootAppearance != 136 || nRightFootAppearance != 136){
                object oItem1 = CopyItemAndModify(oEquipped, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LSHIN, 136, TRUE);
                DestroyObject(oEquipped);
                object oItem2 = CopyItemAndModify(oItem1, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RSHIN, 136, TRUE);
                DestroyObject(oItem1);
                object oItem3 = CopyItemAndModify(oItem2, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LFOOT, 136, TRUE);
                DestroyObject(oItem2);
                object oItem4 = CopyItemAndModify(oItem3, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RFOOT, 136, TRUE);
                DestroyObject(oItem3);
                AssignCommand(oEquippedBy, ActionEquipItem(oItem4, INVENTORY_SLOT_CHEST));
            }
        } else {
            if((nLeftShinAppearance == 136 || nLeftShinAppearance == 137) || (nRightShinAppearance == 136 || nRightShinAppearance == 137) || nLeftFootAppearance == 136 || nRightFootAppearance == 136){
                object oItem1 = CopyItemAndModify(oEquipped, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LSHIN, 1, TRUE);
                DestroyObject(oEquipped);
                object oItem2 = CopyItemAndModify(oItem1, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RSHIN, 1, TRUE);
                DestroyObject(oItem1);
                object oItem3 = CopyItemAndModify(oItem2, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LFOOT, 1, TRUE);
                DestroyObject(oItem2);
                object oItem4 = CopyItemAndModify(oItem3, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RFOOT, 1, TRUE);
                DestroyObject(oItem3);
                AssignCommand(oEquippedBy, ActionEquipItem(oItem4, INVENTORY_SLOT_CHEST));
            }
        }
    }

    if (! GetIsDM(oEquippedBy))
    {
        //check for polymorph effect
        effect eEffect      = GetFirstEffect(oEquippedBy);
        int nNotPolymorphed = TRUE;

        while (GetIsEffectValid(eEffect))
        {
            if (GetEffectType(eEffect) == EFFECT_TYPE_POLYMORPH)
            {
                nNotPolymorphed = FALSE;
                break;
            }

            eEffect = GetNextEffect(oEquippedBy);
        }

        //item level restriction
        if (nNotPolymorphed)
        {
            int nHitDice   = GetHitDice(oEquippedBy);
            int nItemValue = gsCMGetItemValue(oEquipped);
            int nItemLevel = gsCMGetItemLevelByValue(nItemValue);

            if (nItemLevel > nHitDice)
            {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneParalyze(), oEquippedBy, 0.75);
                DelayCommand(0.5, AssignCommand(oEquippedBy, gsUnequipItem(oEquipped)));

                FloatingTextStringOnCreature(
                    gsCMReplaceString(
                        GS_T_16777535,
                        GetName(oEquipped),
                        IntToString(nItemLevel)),
                    oEquippedBy,
                    FALSE);

                return;
            }
        }

        //movement penalty
        /*
        int nAC      = gsCMGetItemBaseAC(oEquipped);
        int nPenalty = 0;

        switch (GetBaseItemType(oEquipped))
        {
        case BASE_ITEM_ARMOR:
            if (nAC >= 6)      nPenalty = 20;
            else if (nAC >= 4) nPenalty = 10;
            break;
        }

        if (nPenalty)
        {
            AssignCommand(
                oEquipped,
                ApplyEffectToObject(
                    DURATION_TYPE_PERMANENT,
                    ExtraordinaryEffect(
                        EffectMovementSpeedDecrease(nPenalty)),
                    oEquippedBy));
            SendMessageToPC(
                oEquippedBy,
                gsCMReplaceString(
                    GS_T_16777419,
                    IntToString(nPenalty)));
        }
        */
    }
}
