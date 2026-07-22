// mk_inc_iprp

#include "mk_inc_debug"
#include "mk_inc_version"
#include "mk_inc_tools"
#include "mk_inc_math"
#include "x2_inc_itemprop"

//const int MK_IPRP_DEBUG = TRUE;
const int MK_IPRP_DEBUG = FALSE;


string MK_IPRP_GetSubTypeResRefByID(int nIPropID);

string MK_IPRP_GetSubTypeResRef(itemproperty iProp);


int MK_IPRP_GetCostTableResRefID(itemproperty iProp);

int MK_IPRP_GetCostTableResRefIDByID(int nIPropID);

string MK_IPRP_GetCostTableResRef(itemproperty iProp);

string MK_IPRP_GetCostTableResRefByID(int nIPropID);


int MK_IPRP_GetParam1ResRefIDByID(int nIPropID, int nSubType=-1);

string MK_IPRP_GetParam1ResRefByID(int nIPropID, int nSubType=-1);

int MK_IPRP_GetParam1ResRefID(itemproperty iProp);

string MK_IPRP_GetParam1ResRef(itemproperty iProp);


int MK_IPRP_GetMaxCharges();

int MK_IPRP_ItemPropertyMatch(itemproperty iProp, int nType, int nSubType=-1, int nCostTableValue=-1, int nParam1Value=-1);

itemproperty MK_IPRP_GetItemProperty(object oItem, int nType, int nSubType=-1, int nCostTableValue=-1, int nParam1Value=-1);

itemproperty MK_IPRP_CreateItemPropertyByID(int nIPropID, int nSubType=-1, int nCostTableValue=-1, int nParam1Value=0);

string MK_IPRP_GetItemPropertyName(itemproperty iProp);

int MK_IPRP_CalculateGoldPieceValue(object oItem, int nAdditionalCost=0, int bWriteLog=FALSE);

int MK_IPRP_RemoveAllItemProperties(object oItem, int nType=-1, int nSubType=-1, int nCostTableValue=-1, int nParam1Value=-1);

int MK_IPRP_GetItemPropertyCount(object oItem, int nType=-1, int nSubType=-1, int nCostTableValue=-1, int nParam1Value=-1);

string MK_IPRP_GetItemName(object oItem, int bBaseItemNameIfUnidentified=TRUE);

///////////////////////////////////////////////////////////////////////////////

void MK_IPRP_DEBUG_TRACE(string sMessage)
{
    if (MK_IPRP_DEBUG)
    {
        MK_DEBUG_TRACE(sMessage);
    }
}

string MK_IPRP_GetItemName(object oItem, int bBaseItemNameIfUnidentified)
{
    string sName = "";
    int nObjectType = GetObjectType(oItem);
    if (nObjectType == OBJECT_TYPE_ITEM)
    {
        if (bBaseItemNameIfUnidentified && !GetIdentified(oItem))
        {
            int nBaseItemType = GetBaseItemType(oItem);
            int nStrRef = MK_Get2DAInt("baseitems", "Name", nBaseItemType, 0);
            sName = GetStringByStrRef(nStrRef) + " " + GetStringByStrRef(5548);
        }
        else
        {
            sName = GetName(oItem);
        }
    }
    return sName;
}


int MK_IPRP_GetItemPropertyCount(object oItem, int nType, int nSubType, int nCostTableValue, int nParam1Value)
{
    int nCount = 0;
    if (GetIsObjectValid(oItem))
    {
        itemproperty iProp = GetFirstItemProperty(oItem);
        while (GetIsItemPropertyValid(iProp))
        {
            if ((nType==-1) || MK_IPRP_ItemPropertyMatch(iProp, nType, nSubType, nCostTableValue, nParam1Value))
            {
                nCount++;
            }
            iProp = GetNextItemProperty(oItem);
        }
    }
    return nCount;
}

int MK_IPRP_GetIsNumberOfCastSpellPropsValid(object oItem)
{
    int bResult = FALSE;
    int nBaseItemType = GetBaseItemType(oItem);
    int nMinProps = MK_Get2DAInt("baseitems", "MinProps", nBaseItemType, 0);
    int nMaxProps = MK_Get2DAInt("baseitems", "MaxProps", nBaseItemType, 0);

    int nCastSpellProps = MK_IPRP_GetItemPropertyCount(oItem, ITEM_PROPERTY_CAST_SPELL);

    if ((nMinProps<=nCastSpellProps) && (nMaxProps>=nCastSpellProps))
    {
        bResult = TRUE;
    }
    return bResult;
}


int MK_IPRP_RemoveAllItemProperties(object oItem, int nType, int nSubType, int nCostTableValue, int nParam1Value)
{
    int nCount = 0;
    if (GetIsObjectValid(oItem))
    {
        itemproperty iProp = GetFirstItemProperty(oItem);
        while (GetIsItemPropertyValid(iProp))
        {
            if ((nType==-1) || MK_IPRP_ItemPropertyMatch(iProp, nType, nSubType, nCostTableValue, nParam1Value))
            {
                RemoveItemProperty(oItem, iProp);
                nCount++;
            }
            iProp = GetNextItemProperty(oItem);
        }
    }
    return nCount;
}

int MK_IPRP_ItemPropertyMatch(itemproperty iProp, int nType, int nSubType, int nCostTableValue, int nParam1Value)
{
    int bReturn = FALSE;
    if (GetIsItemPropertyValid(iProp))
    {
        int nTypeQ = GetItemPropertyType(iProp);
        int nSubTypeQ = GetItemPropertySubType(iProp);
        int nCostTableQ = MK_IPRP_GetCostTableResRefID(iProp);
        int nCostTableValueQ = GetItemPropertyCostTableValue(iProp);
//        int nParam1Q1 = GetItemPropertyParam1(iProp);
        int nParam1Q2 = MK_IPRP_GetParam1ResRefID(iProp);
        int nParam1ValueQ = GetItemPropertyParam1Value(iProp);
/*        MK_IPRP_DEBUG_TRACE("MK_IPRP_ItemPropertyMatch('"+MK_IPRP_GetItemPropertyName(iProp)+"):"
                    +", nType=("+IntToString(nType)+","+IntToString(nTypeQ)+")"
                    +", nSubType=("+IntToString(nSubType)+","+IntToString(nSubTypeQ)+")"
                    +", nCostTable=(-,"+IntToString(nCostTableQ)+")"
                    +", nCostTableValue=("+IntToString(nCostTableValue)+","+IntToString(nCostTableValueQ)+")"
                    +", nParam1=(-,"+IntToString(nParam1Q1)+"/"+IntToString(nParam1Q2)+")"
                    +", nParam1Value=("+IntToString(nParam1Value)+","+IntToString(nParam1ValueQ)+")");
*/
        if (nType == nTypeQ)
        {
            string sSubTypeResRef = MK_IPRP_GetSubTypeResRefByID(nType);
            if ((nSubType == -1) || (sSubTypeResRef=="") || (nSubType == nSubTypeQ))
            {
                string sCostTableResRef = MK_IPRP_GetCostTableResRef(iProp);
                if ((nCostTableValue == -1) || (nCostTableQ <= 0) || (sCostTableResRef=="") || (nCostTableValue == nCostTableValueQ))
                {
                    string sParam1ResRef = MK_IPRP_GetParam1ResRef(iProp);
                    if ((nParam1Value == -1) || (nParam1Q2 == -1) || (sParam1ResRef=="") || (nParam1Value == nParam1ValueQ))
                    {
                        bReturn = TRUE;
                    }
                }
            }
        }
    }
    return bReturn;
}

itemproperty MK_IPRP_GetItemProperty(object oItem, int nType, int nSubType, int nCostTableValue, int nParam1Value)
{
    itemproperty iProp;
//    if (!GetItemHasItemProperty(oItem, nType))
//    {
//        return iProp;
//    }
    string s2DAfile = "itempropdef";
    iProp = GetFirstItemProperty(oItem);
    while (GetIsItemPropertyValid(iProp))
    {
        if (MK_IPRP_ItemPropertyMatch(iProp, nType, nSubType, nCostTableValue, nParam1Value))
        {
            return iProp;
        }
        iProp = GetNextItemProperty(oItem);
    }
    return iProp;
}

itemproperty MK_IPRP_CreateItemPropertyByID(int nIPropID, int nSubType, int nCostTableValue, int nParam1Value)
{
    itemproperty iProp;
    if (MK_VERSION_GetIsBuildVersionGreaterEqual(OBJECT_SELF, 8193, 21))
    {
        iProp = ItemPropertyCustom(nIPropID, nSubType, nCostTableValue, nParam1Value);
        return iProp;
    }

    switch (nIPropID)
    {
    case ITEM_PROPERTY_ABILITY_BONUS: // 0
        iProp = ItemPropertyAbilityBonus(nSubType, nCostTableValue);
        break;
    case ITEM_PROPERTY_AC_BONUS: // 1
        iProp = ItemPropertyACBonus(nCostTableValue);
        break;
    case ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP: // 2
        iProp = ItemPropertyACBonusVsAlign(nSubType, nCostTableValue);
        break;
    case ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE: // 3
        iProp = ItemPropertyACBonusVsDmgType(nSubType, nCostTableValue);
        break;
    case ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP: // 4
        iProp = ItemPropertyACBonusVsRace(nSubType, nCostTableValue);
        break;
    case ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT: // 5
        iProp = ItemPropertyACBonusVsSAlign(nSubType, nCostTableValue);
        break;
    case ITEM_PROPERTY_ENHANCEMENT_BONUS: // 6
        iProp = ItemPropertyEnhancementBonus(nCostTableValue);
        break;
    case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP: // 7
        iProp = ItemPropertyEnhancementBonusVsAlign(nSubType, nCostTableValue);
        break;
    case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP: // 8
        iProp = ItemPropertyEnhancementBonusVsRace(nSubType, nCostTableValue);
        break;
    case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT: // 9
        iProp = ItemPropertyEnhancementBonusVsSAlign(nSubType, nCostTableValue);
        break;
    case ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER: // 10
        iProp = ItemPropertyEnhancementPenalty(nCostTableValue);
        break;
    case ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION: // 11
        iProp = ItemPropertyWeightReduction(nCostTableValue);
        break;
    case ITEM_PROPERTY_BONUS_FEAT:  // 12
        iProp = ItemPropertyBonusFeat(nSubType);
        break;
    case ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N: // 13
        iProp = ItemPropertyBonusLevelSpell(nSubType, nCostTableValue);
        break;
    case 14: // 14 Boomerang
//      iProp = *missing*
        break;
    case ITEM_PROPERTY_CAST_SPELL: // 15
        iProp = ItemPropertyCastSpell(nSubType, nCostTableValue);
        break;
    case ITEM_PROPERTY_DAMAGE_BONUS: // 16
        iProp = ItemPropertyDamageBonus(nSubType, nCostTableValue);
        break;
    case ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP: // 17
        iProp = ItemPropertyDamageBonusVsAlign(nSubType, nParam1Value, nCostTableValue);
        break;
    case ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP: // 18
        iProp = ItemPropertyDamageBonusVsRace(nSubType, nParam1Value, nCostTableValue);
        break;
    case ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT: // 19
        iProp = ItemPropertyDamageBonusVsSAlign(nSubType, nParam1Value, nCostTableValue);
        break;
    case ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE: // 20
        iProp = ItemPropertyDamageImmunity(nSubType, nCostTableValue);
        break;
    case ITEM_PROPERTY_DECREASED_DAMAGE: // 21
        iProp = ItemPropertyDamagePenalty(nCostTableValue);
        break;
    case ITEM_PROPERTY_DAMAGE_REDUCTION: // 22
        iProp = ItemPropertyDamageReduction(nSubType, nCostTableValue);
        break;
    case ITEM_PROPERTY_DAMAGE_RESISTANCE: // 23
        iProp = ItemPropertyDamageResistance(nSubType, nCostTableValue);
        break;
    case ITEM_PROPERTY_DAMAGE_VULNERABILITY: // 24
        iProp = ItemPropertyDamageResistance(nSubType, nCostTableValue);
        break;
    case 25: // 25 Dancing Scimitar
//      iProp = *missing*
        break;
    case ITEM_PROPERTY_DARKVISION: // 26
        iProp = ItemPropertyDarkvision();
        break;
    case ITEM_PROPERTY_DECREASED_ABILITY_SCORE: // 27
        iProp = ItemPropertyDecreaseAbility(nSubType, nCostTableValue);
        break;
    case ITEM_PROPERTY_DECREASED_AC: // 28
        iProp = ItemPropertyDecreaseAC(nSubType, nCostTableValue);
        break;
    case ITEM_PROPERTY_DECREASED_SKILL_MODIFIER: // 29
        iProp = ItemPropertyDecreaseSkill(nSubType, nCostTableValue);
        break;
    case 30: // 30  Double Stack
//      iProp = *missing*
        break;
    case 31: // 31  Enhanced Container: Bonus Slot
//      iProp = *missing*
        break;
    case ITEM_PROPERTY_ENHANCED_CONTAINER_REDUCED_WEIGHT: // 32
        iProp = ItemPropertyContainerReducedWeight(nCostTableValue);
        break;
    case ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE: // 33
        iProp = ItemPropertyExtraMeleeDamageType(nSubType);
        break;
    case ITEM_PROPERTY_EXTRA_RANGED_DAMAGE_TYPE: // 34
        iProp = ItemPropertyExtraRangeDamageType(nSubType);
        break;
    case ITEM_PROPERTY_HASTE: // 35
        iProp = ItemPropertyHaste();
        break;
    case ITEM_PROPERTY_HOLY_AVENGER: // 36
        iProp = ItemPropertyHolyAvenger();
        break;
    case ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS: // 37
        iProp = ItemPropertyImmunityMisc(nSubType);
        break;
    case ITEM_PROPERTY_IMPROVED_EVASION: // 38
        iProp = ItemPropertyImprovedEvasion();
        break;
    case ITEM_PROPERTY_SPELL_RESISTANCE: // 39
        iProp = ItemPropertyBonusSpellResistance(nCostTableValue);
        break;
    case ITEM_PROPERTY_SAVING_THROW_BONUS: // 40
        // item property 40 seemd to be ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC actually
        iProp = ItemPropertyBonusSavingThrowVsX(nSubType, nCostTableValue);
        break;
    case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC: // 41
        // item property 41 seemd to be ITEM_PROPERTY_SAVING_THROW_BONUS actually
        iProp = ItemPropertyBonusSavingThrow(nSubType, nCostTableValue);
        break;
    case 42: // 42 empty
//      iProp = *missing*
        break;
    case ITEM_PROPERTY_KEEN: // 43
        iProp = ItemPropertyKeen();
        break;
    case ITEM_PROPERTY_LIGHT: // 44
        iProp = ItemPropertyLight(nCostTableValue, nParam1Value);
        break;
    case ITEM_PROPERTY_MIGHTY: // 45
        iProp = ItemPropertyMaxRangeStrengthMod(nCostTableValue);
        break;
    case ITEM_PROPERTY_MIND_BLANK: // 46 Mind Blank
        break;
    case ITEM_PROPERTY_NO_DAMAGE: // 47
        iProp = ItemPropertyNoDamage();
        break;
    case ITEM_PROPERTY_ON_HIT_PROPERTIES: // 48
        // nParam1Value = nParam1Value(nSubType)
        iProp = ItemPropertyOnHitProps(nSubType, nCostTableValue, nParam1Value);
        break;
    case ITEM_PROPERTY_DECREASED_SAVING_THROWS: // 49
        // item property 49 seemd to be ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC actually
        iProp = ItemPropertyReducedSavingThrowVsX(nSubType, nCostTableValue);
        break;
    case ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC: // 50
        // item property 50 seemd to be ITEM_PROPERTY_DECREASED_SAVING_THROWS actually
        iProp = ItemPropertyReducedSavingThrow(nSubType, nCostTableValue);
        break;
    case ITEM_PROPERTY_REGENERATION: // 51
        iProp = ItemPropertyRegeneration(nCostTableValue);
        break;
    case ITEM_PROPERTY_SKILL_BONUS: // 52
        iProp = ItemPropertySkillBonus(nSubType, nCostTableValue);
        break;
    case ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL: // 53
        iProp = ItemPropertySpellImmunitySpecific(nCostTableValue);
        break;
    case ITEM_PROPERTY_IMMUNITY_SPELL_SCHOOL: // 54
        iProp = ItemPropertySpellImmunitySchool(nSubType);
        break;
    case ITEM_PROPERTY_THIEVES_TOOLS: // 55
        iProp = ItemPropertyThievesTools(nCostTableValue);
        break;
    case ITEM_PROPERTY_ATTACK_BONUS: // 56
        iProp = ItemPropertyAttackBonus(nCostTableValue);
        break;
    case ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP: // 57
        iProp = ItemPropertyAttackBonusVsAlign(nSubType, nCostTableValue);
        break;
    case ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP:  // 58
        iProp = ItemPropertyAttackBonusVsRace(nSubType, nCostTableValue);
        break;
    case ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT: // 59
        iProp = ItemPropertyAttackBonusVsSAlign(nSubType, nCostTableValue);
        break;
    case ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER: // 60
        iProp = ItemPropertyAttackPenalty(nCostTableValue);
        break;
    case ITEM_PROPERTY_UNLIMITED_AMMUNITION: // 61
        iProp = ItemPropertyUnlimitedAmmo(nCostTableValue);
        break;
    case ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP: // 62
        iProp = ItemPropertyLimitUseByAlign(nSubType);
        break;
    case ITEM_PROPERTY_USE_LIMITATION_CLASS: // 63
        iProp = ItemPropertyLimitUseByClass(nSubType);
        break;
    case ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE: // 64
        iProp = ItemPropertyLimitUseByRace(nSubType);
        break;
    case ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT: // 65
        iProp = ItemPropertyLimitUseBySAlign(nSubType);
        break;
    case ITEM_PROPERTY_USE_LIMITATION_TILESET: // 66 UseLimitationTerrain
        break;
    case ITEM_PROPERTY_REGENERATION_VAMPIRIC: // 67
        iProp = ItemPropertyVampiricRegeneration(nCostTableValue);
        break;
    case 68: // 68 vorpal
//      iProp = *missing*
        break;
    case 69: // 69 wounding
//      iProp = *missing*
        break;
    case ITEM_PROPERTY_TRAP: // 70
        iProp = ItemPropertyTrap(nSubType, nCostTableValue);
        break;
    case ITEM_PROPERTY_TRUE_SEEING: // 71
        iProp = ItemPropertyTrueSeeing();
        break;
    case ITEM_PROPERTY_ON_MONSTER_HIT: // 72
        iProp = ItemPropertyOnMonsterHitProperties(nSubType, nParam1Value);
        break;
    case ITEM_PROPERTY_TURN_RESISTANCE: // 73
        iProp = ItemPropertyTurnResistance(nCostTableValue);
        break;
    case ITEM_PROPERTY_MASSIVE_CRITICALS: // 74
        iProp = ItemPropertyMassiveCritical(nCostTableValue);
        break;
    case ITEM_PROPERTY_FREEDOM_OF_MOVEMENT: // 75
        iProp = ItemPropertyFreeAction();
        break;
    case ITEM_PROPERTY_POISON: // 76 Poison
        break;
    case ITEM_PROPERTY_MONSTER_DAMAGE: // 77
        iProp = ItemPropertyMonsterDamage(nCostTableValue);
        break;
    case ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL: // 78
        iProp = ItemPropertyImmunityToSpellLevel(nCostTableValue);
        break;
    case ITEM_PROPERTY_SPECIAL_WALK: // 79
        iProp = ItemPropertySpecialWalk(nSubType);
        break;
    case ITEM_PROPERTY_HEALERS_KIT: // 80
        iProp = ItemPropertyHealersKit(nCostTableValue);
        break;
    case ITEM_PROPERTY_WEIGHT_INCREASE: // 81
        iProp = ItemPropertyWeightIncrease(nParam1Value);
        break;
    case ITEM_PROPERTY_ONHITCASTSPELL: // 82
        iProp = ItemPropertyOnHitCastSpell(nSubType, nCostTableValue+1);
        break;
    case ITEM_PROPERTY_VISUALEFFECT: // 83
        iProp = ItemPropertyVisualEffect(nSubType);
        break;
    case ITEM_PROPERTY_ARCANE_SPELL_FAILURE: // 84
        iProp = ItemPropertyArcaneSpellFailure(nCostTableValue);
        break;
    case ITEM_PROPERTY_MATERIAL: // 85
        iProp = ItemPropertyMaterial(nCostTableValue);
        break;
    case ITEM_PROPERTY_QUALITY: // 86
        iProp = ItemPropertyQuality(nCostTableValue);
        break;
    case ITEM_PROPERTY_ADDITIONAL: // 87
        iProp = ItemPropertyAdditional(nCostTableValue);
        break;
   }
   return iProp;
}

string MK_IPRP_GetSubTypeResRefByID(int nIPropID)
{
    return Get2DAString("itempropdef", "SubTypeResRef", nIPropID);
}

string MK_IPRP_GetSubTypeResRef(itemproperty iProp)
{
    return Get2DAString("itempropdef", "SubTypeResRef", GetItemPropertyType(iProp));
}

int MK_IPRP_GetParam1ResRefID(itemproperty iProp)
{
    int nType = GetItemPropertyType(iProp);
    int nSubType = GetItemPropertySubType(iProp);
    return MK_IPRP_GetParam1ResRefIDByID(nType, nSubType);
}


int MK_IPRP_GetParam1ResRefIDByID(int nIPropID, int nSubType)
{
    int nParam1ResRef = MK_Get2DAInt("itempropdef", "Param1ResRef", nIPropID, -1);
    if (nSubType!=-1)
    {
        string sSubTypeResRef = MK_IPRP_GetSubTypeResRefByID(nIPropID);
        if (sSubTypeResRef!="")
        {
            string sParam1ResRef = Get2DAString(sSubTypeResRef, "Param1ResRef", nSubType);
            if (sParam1ResRef!="")
            {
                nParam1ResRef = StringToInt(sParam1ResRef);
            }
        }
    }
    return nParam1ResRef;
}

string MK_IPRP_GetParam1ResRef(itemproperty iProp)
{
    int nType = GetItemPropertyType(iProp);
    int nSubType = GetItemPropertySubType(iProp);
    return MK_IPRP_GetParam1ResRefByID(nType, nSubType);
/*
    string sParam1ResRef="";
    int nParam1 = GetItemPropertyParam1(iProp);
    if (nParam1!=-1)
    {
        sParam1ResRef = Get2DAString("iprp_paramtable", "TableResRef", nParam1);
    }
    return sParam1ResRef;*/
}

string MK_IPRP_GetParam1ResRefByID(int nIPropID, int nSubType)
{
    string sParam1ResRef = "";
    int nParam1ResRef = MK_IPRP_GetParam1ResRefIDByID(nIPropID, nSubType);
    if (nParam1ResRef!=-1)
    {
        sParam1ResRef = Get2DAString("iprp_paramtable", "TableResRef", nParam1ResRef);
    }
    return sParam1ResRef;
}

int MK_IPRP_GetCostTableResRefID(itemproperty iProp)
{
    return MK_IPRP_GetCostTableResRefIDByID(GetItemPropertyType(iProp));
}

int MK_IPRP_GetCostTableResRefIDByID(int nIPropID)
{
    return MK_Get2DAInt("itempropdef", "CostTableResRef", nIPropID);
}

string MK_IPRP_GetCostTableResRef(itemproperty iProp)
{
    return MK_IPRP_GetCostTableResRefByID(GetItemPropertyType(iProp));

//    string sCostTableResRef = "";
//    int nCostTableResRef = GetItemPropertyCostTable(iProp);
//    if (nCostTableResRef>0)
//    {
//        sCostTableResRef = Get2DAString("iprp_costtable", "Name", nCostTableResRef);
//        MK_DEBUG_TRACE("MK_IPRP_GetCostTableResRef: "+IntToString(nCostTableResRef)+" ("+sCostTableResRef+")");
//    }
//    return sCostTableResRef;
}

string MK_IPRP_GetCostTableResRefByID(int nIPropID)
{
    string sCostTableResRef="";
    int nCostTableResRef = MK_IPRP_GetCostTableResRefIDByID(nIPropID);
    if (nCostTableResRef>=1)
    {
        sCostTableResRef = Get2DAString("iprp_costtable", "Name", nCostTableResRef);
    }
    return sCostTableResRef;
}

int MK_IPRP_CreateItemPropertyOnItem(object oItem, int nIPropID, int nSubType=-1, int nCostTableValue=-1, int nParam1Value=-1)
{
    int bResult=FALSE;
    itemproperty iProp = MK_IPRP_CreateItemPropertyByID(nIPropID, nSubType, nCostTableValue, nParam1Value);
/*    MK_IPRP_DEBUG_TRACE("MK_IPRP_CreateItemPropertyOnItem('"+GetName(oItem)
        +"', nIPropID="+IntToString(nIPropID)
        +", nSubType="+IntToString(nSubType)
        +", nParam1Value="+IntToString(nParam1Value)
        +", nCostTableValue="+IntToString(nCostTableValue));*/
    if (GetIsItemPropertyValid(iProp))
    {
        IPSafeAddItemProperty(oItem, iProp);
        bResult=TRUE;
    }
    return bResult;
}

int MK_IPRP_GetSkillBonus(object oItem, int nSkill, int bRemoveProperties=FALSE)
{
    int nSkillBonus = 0;
    if (GetIsObjectValid(oItem))
    {
        if (nSkill!=-1)
        {
            itemproperty iProp;
            iProp = MK_IPRP_GetItemProperty(oItem, ITEM_PROPERTY_SKILL_BONUS, nSkill);
            if (GetIsItemPropertyValid(iProp))
            {
                nSkillBonus += GetItemPropertyCostTableValue(iProp);
                if (bRemoveProperties)
                {
                    RemoveItemProperty(oItem, iProp);
                }
            }
            iProp = MK_IPRP_GetItemProperty(oItem, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, nSkill);
            if (GetIsItemPropertyValid(iProp))
            {
                nSkillBonus -= GetItemPropertyCostTableValue(iProp);
                if (bRemoveProperties)
                {
                    RemoveItemProperty(oItem, iProp);
                }
            }
        }
    }
    return nSkillBonus;
}

int MK_IPRP_GetItemHasFeat(object oItem, int nFeat)
{
    return GetIsItemPropertyValid(MK_IPRP_GetItemProperty(oItem, ITEM_PROPERTY_BONUS_FEAT, nFeat));
}

int MK_IPRP_SetPlotFlag(object oTarget, int bPlotFlag)
{
    int bPlotFlagOld = GetPlotFlag(oTarget);
    if (bPlotFlagOld!=bPlotFlag)
    {
        SetPlotFlag(oTarget, bPlotFlag);
    }
    return bPlotFlagOld;
}

int MK_IPRP_SetIdentified(object oItem, int bIdentified)
{
    int bIdentifiedOld = GetIdentified(oItem);
    if (bIdentifiedOld!=bIdentified)
    {
        SetIdentified(oItem, bIdentified);
    }
    return bIdentifiedOld;
}

int MK_IPRP_SetItemCursedFlag(object oItem, int nCursed)
{
    int nCursedOld = GetItemCursedFlag(oItem);
    if (nCursedOld!=nCursed)
    {
        SetItemCursedFlag(oItem, nCursed);
    }
    return nCursedOld;
}

int MK_IPRP_GetGoldPieceValue(object oItem)
{
    int nValue=0;
    if (GetIsObjectValid(oItem))
    {
        int bPlotFlag = MK_IPRP_SetPlotFlag(oItem, FALSE);
        int bIdentified = MK_IPRP_SetIdentified(oItem, TRUE);
        int nCursed = MK_IPRP_SetItemCursedFlag(oItem, FALSE);
        nValue = GetGoldPieceValue(oItem);
        MK_IPRP_SetItemCursedFlag(oItem, nCursed);
        MK_IPRP_SetIdentified(oItem, bIdentified);
        MK_IPRP_SetPlotFlag(oItem, bPlotFlag);
//        MK_IPRP_DEBUG_TRACE("MK_IPRP_GetGoldPieceValue('"+GetName(oItem)
//            +"'): indentified=("+IntToString(bIdentified)+"/"+IntToString(GetIdentified(oItem))
//            +"), bPlot=("+IntToString(bPlotFlag)+"/"+IntToString(GetPlotFlag(oItem))
//            +"), nCursed=("+IntToString(nCursed)+"/"+IntToString(GetItemCursedFlag(oItem))
//            +") = "+IntToString(nValue) + "("+IntToString(GetGoldPieceValue(oItem))+")");
    }
    return nValue;
}

string MK_IPRP_GetItemPropertyNameByID(int nIPropID, int nSubType=-1, int nCostTableValue=-1, int nParam1Value=-1)
{
    string sPropertyName = "";
    int nGender = GetGender(OBJECT_SELF);
    int nStrRef;
    if (nIPropID!=-1)
    {
        nStrRef = MK_Get2DAInt("itempropdef", "GameStrRef", nIPropID, 0);
        sPropertyName = GetStringByStrRef(nStrRef, GetGender(OBJECT_SELF));

        if (nSubType!=-1)
        {
            string sSubTypeResRef = MK_IPRP_GetSubTypeResRefByID(nIPropID);
            if (sSubTypeResRef!="")
            {
                nStrRef = MK_Get2DAInt(sSubTypeResRef, "Name", nSubType, 0);
                if (nStrRef>0)
                {
                    sPropertyName += (" " + GetStringByStrRef(nStrRef, nGender));
                }
            }
        }

        if (nCostTableValue!=-1)
        {
            string sCostTableResRef = MK_IPRP_GetCostTableResRefByID(nIPropID);
            if (sCostTableResRef!="")
            {
                nStrRef = MK_Get2DAInt(sCostTableResRef, "Name", nCostTableValue, 0);
                if (nStrRef>0)
                {
                    sPropertyName += (" " + GetStringByStrRef(nStrRef, nGender));
                }
            }
        }

        if (nParam1Value!=-1)
        {
            string sParam1ResRef = MK_IPRP_GetParam1ResRefByID(nIPropID, nSubType);
            if (sParam1ResRef!="")
            {
                nStrRef = MK_Get2DAInt(sParam1ResRef, "Name", nParam1Value, 0);
                if (nStrRef>0)
                {
                    sPropertyName += (" " + GetStringByStrRef(nStrRef, nGender));
                }
            }
        }
    }
    return sPropertyName;
}

string MK_IPRP_GetItemPropertyName(itemproperty iProp)
{
    string sPropertyName="";
    if (GetIsItemPropertyValid(iProp))
    {
        int nType = GetItemPropertyType(iProp);
        int nSubType = GetItemPropertySubType(iProp);
        int nCostTableValue = GetItemPropertyCostTableValue(iProp);
        int nParam1Value = GetItemPropertyParam1Value(iProp);

        sPropertyName = MK_IPRP_GetItemPropertyNameByID(nType, nSubType, nCostTableValue, nParam1Value);
    }
    return sPropertyName;
}

float MK_IPRP_CalculateItemPropertyCost(itemproperty iProp, int nCharges=-1)
{
    float fValue = 0.0f;
    if (GetIsItemPropertyValid(iProp))
    {
        int nType = GetItemPropertyType(iProp);
        int nSubType = GetItemPropertySubType(iProp);
        int nCostTableValue = GetItemPropertyCostTableValue(iProp);
//        int nParam1Value = GetItemPropertyParam1Value(iProp);

        string sTypeResRef = "itempropdef";
        string sSubTypeResRef = MK_IPRP_GetSubTypeResRef(iProp);
        string sCostTableResRef = MK_IPRP_GetCostTableResRef(iProp);
//        string sParam1ResRef = MK_IPRP_GetParam1ResRef(iProp);

        string sIPropCost = Get2DAString(sTypeResRef, "Cost", nType);
        string sSubTypeCost = Get2DAString(sSubTypeResRef, "Cost", nSubType);
        string sCostTableCost = Get2DAString(sCostTableResRef, "Cost", nCostTableValue);
//        string sParam1Cost = Get2DAString(sParam1ResRef, "Cost", nParam1Value);

        float fCharges = 1.0f;

        switch (nType)
        {
        case ITEM_PROPERTY_CAST_SPELL:
            fValue = (StringToFloat(sSubTypeCost) * StringToFloat(sCostTableCost));
            switch (nCostTableValue)
            {
            case IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE:
            case IP_CONST_CASTSPELL_NUMUSES_2_CHARGES_PER_USE:
            case IP_CONST_CASTSPELL_NUMUSES_3_CHARGES_PER_USE:
            case IP_CONST_CASTSPELL_NUMUSES_4_CHARGES_PER_USE:
            case IP_CONST_CASTSPELL_NUMUSES_5_CHARGES_PER_USE:
                fCharges = (IntToFloat(nCharges) / MK_IPRP_GetMaxCharges());
                fValue *= fCharges;
                break;
            }
            break;
        default:
            fValue = StringToFloat(sIPropCost!="" ? sIPropCost : sSubTypeCost) * (sCostTableCost!="" ? StringToFloat(sCostTableCost) : 1.0f);
            break;
        }
        MK_IPRP_DEBUG_TRACE("   > '"+sIPropCost+"("+ (sIPropCost!="" ? FloatToString(StringToFloat(sIPropCost)): "") +")"
            +"', '"+sSubTypeCost+"('"+sSubTypeResRef+"':"+ (sSubTypeCost!="" ? FloatToString(StringToFloat(sSubTypeCost)): "") +")"
            +"', '"+sCostTableCost+"('"+sCostTableResRef+"':"+ (sCostTableCost!="" ? FloatToString(StringToFloat(sCostTableCost)): "") +")"
            +"', "+FloatToString(fCharges)+" = "+FloatToString(fValue)+"' ('"+MK_IPRP_GetItemPropertyName(iProp)+"' ("+
            IntToString(nType)+","+IntToString(nSubType)+","+IntToString(nCostTableValue)+","+IntToString(GetItemPropertyParam1Value(iProp))
            +"))");

    }
    return fValue;
}

int MK_IPRP_GetArmorType(object oItem)
{
    int nArmorType = -1;
    if (GetIsObjectValid(oItem))
    {
        int nChest = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO);
        nArmorType = FloatToInt(MK_Get2DAFloat("parts_chest", "ACBONUS", nChest, -1.0f));
    }
    return nArmorType;
}

int MK_IPRP_GetItemBaseCost(object oItem)
{
    int nBaseCost = 0;
    if (GetIsObjectValid(oItem))
    {
        int nBaseItemType = GetBaseItemType(oItem);
        switch (nBaseItemType)
        {
        case BASE_ITEM_ARMOR:
        {
            int nArmorType = MK_IPRP_GetArmorType(oItem);
            if (nArmorType!=-1)
            {
                nBaseCost = MK_Get2DAInt("armor", "COST", nArmorType);
            }
            break;
        }
        default:
            nBaseCost = MK_Get2DAInt("baseitems", "BaseCost", nBaseItemType, 0);
            break;
        }
    }
    return nBaseCost;
}

int MK_IPRP_GetItemHasItemPropertyOfDurationType(object oItem, int nItemPropertyType)
{
    if (GetIsObjectValid(oItem))
    {
        itemproperty iProp = GetFirstItemProperty(oItem);
        while (GetIsItemPropertyValid(iProp))
        {
            if (GetItemPropertyDurationType(iProp)==nItemPropertyType)
            {
                return TRUE;
            }
            iProp = GetNextItemProperty(oItem);
        }
    }
    return FALSE;

}

int MK_IPRP_GetBaseItemValue(object oItem /*, int bIgnoreStackSize=TRUE*/)
{
    int nBaseItemValue;
    int nBaseCost = MK_IPRP_GetItemBaseCost(oItem);
    int nBaseItemType = GetBaseItemType(oItem);
    float fItemMultiplier = MK_Get2DAFloat("baseitems", "ItemMultiplier", nBaseItemType, 1.0);
//    int nItemStackSize = (bIgnoreStackSize ? 1 : GetItemStackSize(oItem));

    nBaseItemValue = FloatToInt(nBaseCost * fItemMultiplier);
    if (nBaseItemValue==0)
    {
        switch (nBaseItemType)
        {
        case BASE_ITEM_ARROW:  // 20
        case BASE_ITEM_BOLT:   // 25
        case BASE_ITEM_BULLET: // 27
            // category = 6
            break;
        case BASE_ITEM_DART:   // 31
        case BASE_ITEM_SHURIKEN: // 59
        case BASE_ITEM_THROWINGAXE: // 63
            // category = 7
            break;
        case BASE_ITEM_POTIONS: // 49
        case BASE_ITEM_BLANK_POTION: // 101
        case BASE_ITEM_ENCHANTED_POTION: // 104
            // category = 9
            break;
//        case BASE_ITEM_SCROLL: // 54
        case BASE_ITEM_SPELLSCROLL: // 75
        case BASE_ITEM_BLANK_SCROLL: // 102
        case BASE_ITEM_ENCHANTED_SCROLL: // 105
            // category = 10
            break;
        case BASE_ITEM_THIEVESTOOLS: // 62
            // category = 11
            break;
        case BASE_ITEM_GEM: // 77
            // category = 17
            break;
        default:
            nBaseItemValue = 1;
            break;
        }
//        int nCategory = MK_Get2DAInt("baseitems", "Category", nBaseItemType, -1);
/*        switch (nCategory)
        {
        case 6: // ammunition ?
        case 7: // throwing ?
        case 9: // potions ?
        case 10: // scrolls ?
//        case 11: // thieves's tools
        case 17: // gems
//        case 19: // medi kits
        {
//            int nMaxStackSize = MK_Get2DAInt("baseitems", "Stacking", nBaseItemType, 1);
//            if (nItemStackSize==nMaxStackSize) nBaseItemValue = 1;
            break;
        }
        default:
//            nBaseItemValue = nItemStackSize;
            nBaseItemValue = 1;
            break;
        }
*/
    }
//    else
//    {
//        nBaseItemValue *= nItemStackSize;
//    }


//    MK_IPRP_DEBUG_TRACE("MK_IPRP_GetBaseItemValue('"+GetName(oItem)+/*"', "+IntToString(bIgnoreStackSize)+*/"):");
//    MK_IPRP_DEBUG_TRACE(" > nBaseItemType="+IntToString(nBaseItemType));
//    MK_IPRP_DEBUG_TRACE(" > nCategory="+IntToString(MK_Get2DAInt("baseitems", "Category", nBaseItemType, -1)));
//    MK_IPRP_DEBUG_TRACE(" > nBaseCost="+IntToString(nBaseCost));
//    MK_IPRP_DEBUG_TRACE(" > nfItemMultiplier="+FloatToString(fItemMultiplier));
//    MK_IPRP_DEBUG_TRACE(" > nItemStackSize="+IntToString(nItemStackSize));
//    MK_IPRP_DEBUG_TRACE(" > nMaxStackSize="+IntToString(MK_Get2DAInt("baseitems", "Stacking", nBaseItemType, 1)));
//    MK_IPRP_DEBUG_TRACE(" > nBaseItemValue = "+IntToString(nBaseItemValue));

    return nBaseItemValue;
}


itemproperty MK_IPRP_CreateItemProperty(int nBaseItemType, int nMinValue=1)
{
    int nPropColumn = MK_Get2DAInt("baseitems", "PropColumn", nBaseItemType, -1);
    float fItemMultiplier = MK_Get2DAFloat("baseitems", "ItemMultiplier", nBaseItemType, 1.0f);
    if (nPropColumn!=-1)
    {
        int nIPropID = -1;
        int nSubType = -1;
        int nCostTableValue = -1;
        int nParam1Value = 0;
        string sPropColumn = Get2DAString("mk_iprp_cols", "Column", nPropColumn);
        int nLength1 = MK_Get2DALength("itemprops", sPropColumn, 100);
        int nStart1 = 0;
//        int iRow1;
        for (nIPropID = nStart1; nIPropID<nLength1; nIPropID++)
        {
            if (MK_Get2DAInt("itemprops", sPropColumn, nIPropID, 0))
            {
//                int nIPropID = iRow;
                int nStart2, nLength2;
                string sSubTypeResRef = MK_IPRP_GetSubTypeResRefByID(nIPropID);
                if (sSubTypeResRef!="")
                {
                    nStart2 = 0;
                    nLength2 = MK_Get2DALength(sSubTypeResRef, "Label", 5);
                }
                else
                {
                    nStart2 = -1;
                    nLength2 = 0;
                }
                for (nSubType=nStart2; nSubType<nLength2; nSubType++)
                {
//                    nSubType = iPos2;

                    string sCostTableResRef = MK_IPRP_GetCostTableResRefByID(nIPropID);
                    int nStart3, nLength3;
                    if (sCostTableResRef !="")
                    {
                        nStart3 = 0;
                        nLength3 = MK_Get2DALength(sCostTableResRef, "Label", 5);
                    }
                    else
                    {
                        nStart3 = -1;
                        nLength3 = 0;
                    }
                    for (nCostTableValue = nStart3; nCostTableValue<nLength3; nCostTableValue++)
                    {
//                        nCostTableValue = iPos3;
                        int nStart4, nLength4;
                        string sParam1ResRef = MK_IPRP_GetParam1ResRefByID(nIPropID, nSubType);
                        if (sParam1ResRef!="")
                        {
                            nStart4 = 0;
                            nLength4 = MK_Get2DALength(sParam1ResRef, "Label", 5);
                        }
                        else
                        {
                            nStart4 = 0;
                            nLength4 = 1;
                        }
                        for (nParam1Value = nStart4; nParam1Value < nLength4; nParam1Value++)
                        {
//                            nParam1 = iPos4;
                            itemproperty iProp = MK_IPRP_CreateItemPropertyByID(nIPropID, nSubType, nCostTableValue, nParam1Value);
                            if (GetIsItemPropertyValid(iProp))
                            {
                                float fCost = MK_IPRP_CalculateItemPropertyCost(iProp);
                                int nValue;
                                switch (nIPropID)
                                {
                                case ITEM_PROPERTY_CAST_SPELL:
                                    nValue = MK_MATH_Round(FloatToInt(fCost) * fItemMultiplier);
                                    break;
                                default:
                                    nValue = FloatToInt(FloatToInt(fCost*fCost*1000) * fItemMultiplier);
                                    break;
                                }
                                if (nValue > nMinValue)
                                {
                                    return iProp;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    itemproperty iProp;
    return iProp;
}

int MK_IPRP_GetItemAdditionalCostValue(object oItem)
{
    int nAdditionalCostValue=-1;
    if (GetIsObjectValid(oItem))
    {
//        int nBaseCost = MK_IPRP_GetItemBaseCost(oItem);
//        int nItemStackSize = GetItemStackSize(oItem);
//        float fItemMultiplier = MK_Get2DAFloat("baseitems", "ItemMultiplier", nBaseItemType, 1.0);

        if (MK_IPRP_GetItemHasItemPropertyOfDurationType(oItem, DURATION_TYPE_PERMANENT))
        {
            SendMessageToPC(OBJECT_SELF, "Can't calculate additional cost for items with properties!");
        }
        else if (GetItemStackSize(oItem)!=1)
        {
            SendMessageToPC(OBJECT_SELF, "Can't calculate additional cost for items with stack size other than 1!");
        }
        else
        {
            int nItemValue = MK_IPRP_GetGoldPieceValue(oItem);
            int nBaseItemValue = MK_IPRP_GetBaseItemValue(oItem/*, FALSE*/);
            if ((nBaseItemValue == 0) && (nItemValue == 1))
            {
                int nBaseItemType = GetBaseItemType(oItem);
                int nMaxStackSize = MK_Get2DAInt("baseitems", "Stacking", nBaseItemType, 1);
                if (MK_Get2DAInt("baseitems", "Stacking", nBaseItemType, 1) == 1)
                {
                    // here we have a problem. ItemValue could be 1 gold because
                    // of additional cost = 1 gold or because it was set to 1 because
                    // of StackSize (=1) = Stacking(=1). So either it's
                    // BaseItemValue = 1 and AdditionalCostValue = 0
                    // or
                    // BaseItemValue = 0 and AdditionalCostValue = 1
                    // To decide which is true we have to make oItem more valuable
                    // Unfortunately we can't increase stacksize (because MaxStackSize=1)
                    // So we have to add a property.
                    object oPC = OBJECT_SELF;
                    itemproperty iProp = MK_IPRP_CreateItemProperty(nBaseItemType, 1);
                    if (GetIsItemPropertyValid(iProp))
                    {
                        AddItemProperty(DURATION_TYPE_PERMANENT, iProp, oItem);
                        int nItemValueQ = MK_IPRP_GetGoldPieceValue(oItem);
                        int nCalcValueQ = MK_IPRP_CalculateGoldPieceValue(oItem, 0);
                        if (nItemValueQ>1)
                        {
                            if (nItemValueQ==nCalcValueQ)
                            {
                                MK_IPRP_DEBUG_TRACE("MK_IPRP_GetItemAdditionalCostValue('"+GetName(oItem)+"'): iProp="+MK_IPRP_GetItemPropertyName(iProp)+", nItemValueQ="+IntToString(nItemValueQ)+", nCalcValueQ="+IntToString(nCalcValueQ));
                                nBaseItemValue = 1;
                            }
                            else if (nItemValueQ==nCalcValueQ+1)
                            {
                                MK_IPRP_DEBUG_TRACE("MK_IPRP_GetItemAdditionalCostValue('"+GetName(oItem)+"'): iProp="+MK_IPRP_GetItemPropertyName(iProp)+", nItemValueQ="+IntToString(nItemValueQ)+", nCalcValueQ="+IntToString(nCalcValueQ));
                                nBaseItemValue = 0;
                            }
                            else
                            {
                                MK_IPRP_DEBUG_TRACE("MK_IPRP_GetItemAdditionalCostValue('"+GetName(oItem)+"'): iProp="+MK_IPRP_GetItemPropertyName(iProp)+", nItemValueQ="+IntToString(nItemValueQ)+", nCalcValueQ="+IntToString(nCalcValueQ));
                                SendMessageToPC(oPC, "Can't calculate additional cost for this item (there seems something wrong with the item value calculation algorithm).");
                                return -1;
                            }
                        }
                        else
                        {
                            MK_IPRP_DEBUG_TRACE("MK_IPRP_GetItemAdditionalCostValue('"+GetName(oItem)+"'): iProp="+MK_IPRP_GetItemPropertyName(iProp)+", nItemValueQ="+IntToString(nItemValueQ)+", nCalcValueQ="+IntToString(nCalcValueQ));
                            SendMessageToPC(oPC, "Can't calculate additional cost for this item (created IP did not make item valuable).");
                            return -1;
                        }
                    }
                    else
                    {
                        SendMessageToPC(oPC, "Can't calculate additional cost for this item (can't create IP to make item valuable).");
                        return -1;
                    }
                }
            }

            nAdditionalCostValue = MK_MATH_MaxInt(nItemValue - nBaseItemValue, 0);

/*
            int nCalculatedValue = FloatToInt(fItemMultiplier * nBaseCost);

            int nCategory = MK_Get2DAInt("baseitems", "Category", nBaseItemType, -1);
            if (nCalculatedValue==0)
            {
                switch (nCategory)
                {
                case 6: // ammunition ?
                case 7: // throwing ?
                case 9: // potions ?
                case 10: // scrolls ?
                    if (nItemStackSize==nMaxStackSize) nCalculatedValue = 1;
                    break;
                default:
                    nCalculatedValue = 1;
                    break;
                }
            }
            nAdditionalCostValue = MK_MATH_MaxInt(nItemValue - nCalculatedValue, 0);
*/

//            if (nItemStackSize>0)
//            {
//                nAdditionalCostValue = FloatToInt(IntToFloat(nAdditionalCostValue) / IntToFloat(nItemStackSize));
//            }
            MK_IPRP_DEBUG_TRACE("MK_IPRP_GetItemAdditionalCostValue('"+GetName(oItem)+"'):");
            int nBaseItemType = GetBaseItemType(oItem);
            MK_IPRP_DEBUG_TRACE(" > nBaseItemType ="+IntToString(nBaseItemType));
            MK_IPRP_DEBUG_TRACE(" > nStacking = "+IntToString(MK_Get2DAInt("baseitems", "Stacking", nBaseItemType, 1)));
            MK_IPRP_DEBUG_TRACE(" > nItemValue = "+IntToString(nItemValue));
            MK_IPRP_DEBUG_TRACE(" > nBaseItemValue = "+IntToString(nBaseItemValue));
//            MK_IPRP_DEBUG_TRACE(" > nItemStackSize="+IntToString(GetItemStackSize(oItem)));
            MK_IPRP_DEBUG_TRACE(" > nAdditionalCostValue="+IntToString(nAdditionalCostValue));

//            nAdditionalCostValue = MK_MATH_MaxInt(nItemValue - MK_MATH_MaxInt(FloatToInt(nBaseCost * fItemMultiplier), (nMaxStackSize==1 ? 1 : 0)), 0);
/*
            MK_IPRP_DEBUG_TRACE("MK_IPRP_GetItemAdditionalCostValue('"+GetName(oItem)+"'):");
            MK_IPRP_DEBUG_TRACE(" > nBaseItemType="+IntToString(nBaseItemType));
            MK_IPRP_DEBUG_TRACE(" > nCategory="+IntToString(nCategory));
            MK_IPRP_DEBUG_TRACE(" > nBaseCost="+IntToString(nBaseCost));
            MK_IPRP_DEBUG_TRACE(" > nfItemMultiplier="+FloatToString(fItemMultiplier));
            MK_IPRP_DEBUG_TRACE(" > bIdentified="+IntToString(GetIdentified(oItem)));
            MK_IPRP_DEBUG_TRACE(" > bPlot="+IntToString(GetPlotFlag(oItem)));
            MK_IPRP_DEBUG_TRACE(" > nItemValue(without properties)="+IntToString(nItemValue));
            MK_IPRP_DEBUG_TRACE(" > nItemStackSize="+IntToString(nItemStackSize));
            MK_IPRP_DEBUG_TRACE(" > nCalculatedValue="+IntToString(nCalculatedValue));
            MK_IPRP_DEBUG_TRACE(" > nAdditionalCostValue="+IntToString(nAdditionalCostValue));
*/
        }
    }
    return nAdditionalCostValue;
}

int MK_IPRP_GetMaxCharges()
{
    if (MK_VERSION_GetIsVersionGreaterEqual_1_74())
    {
        return 250;
    }
    else
    {
        return 50;
    }
}

int MK_IPRP_FloatToInt(float fNumber, int nRoundUp)
{
    int nNumber = FloatToInt(fNumber);;
    string sNumber = FloatToString(fNumber);
    int nPos = FindSubString(sNumber, ".");
    if (nPos != -1)
    {
        if (nRoundUp>1)
        {
            if (StringToInt(GetSubString(sNumber, nPos+1, 1))>=nRoundUp)
            {
                nNumber++;
            }
        }
        else
        {
            string sFractionalPart = GetSubString(sNumber, nPos+1, GetStringLength(sNumber)-nPos);
            if (StringToInt(sFractionalPart)>0)
            {
                nNumber++;
            }
        }
    }
    return nNumber;
}


int MK_IPRP_CalculateGoldPieceValue(object oItem, int nAdditionalCost, int bWriteLog)
{
    int nItemValue=-1;
    if (GetIsObjectValid(oItem))
    {
        MK_IPRP_DEBUG_TRACE("MK_IPRP_CalculateItemValue('"+GetName(oItem)+":");

        int nBaseItemType = GetBaseItemType(oItem);

        // get the base cost from either baseitems.2da (everything but armor)
        // or armor.2da (armor)
//        int nBaseCost = MK_IPRP_GetItemBaseCost(oItem);

        float fItemMultiplier = MK_Get2DAFloat("baseitems", "ItemMultiplier", nBaseItemType, 0.0);

        int nCharges = GetItemCharges(oItem);

        float fIPCost = 0.0f;

        float fSpellCost1  = 0.0f;
        float fSpellCost2 = 0.0f;
        float fSpellCostR = 0.0f;

        itemproperty iProp = GetFirstItemProperty(oItem);
        while (GetIsItemPropertyValid(iProp))
        {
            if (GetItemPropertyDurationType(iProp) == DURATION_TYPE_PERMANENT)
            {
                switch (GetItemPropertyType(iProp))
                {
                case ITEM_PROPERTY_CAST_SPELL:
                {
                    float fSpellCost = MK_IPRP_CalculateItemPropertyCost(iProp, nCharges);

                    if (fSpellCost>fSpellCost1)
                    {
                        // *****************************************************
                        // The following line is somewhat queer as it makes
                        // the item value depend on the order in which 'Cast-
                        // Spell' properties are added to the item. If they are
                        // added in order from most expensive first and least
                        // expensive last the item will become more expensive as
                        // if they were added in reverse order. The original
                        // Bioware documentation (BioWare Aurora Engine Item
                        // Format) hints that following was supposed to happen:
                        //
                        //  - fSpellCost1: highest spell cost
                        //  - fSpellCost2: 2nd highest spell cost
                        //  - fSpellCostR: the rest
                        //
                        // The highest spell cost is multiplied by 1.0, the 2nd
                        // highest is multiplied by 0.75 and the rest is
                        // multiplied by 0.5.
                        //
                        // But if the CastSpell property with the highest cost
                        // is added after the 2nd highest then when no. 1 and
                        // no. 2 fight for first place no. 2 will not go to 2nd
                        // place but to the rest instead. So at the end 2nd
                        // place will be given tot he wrong SpellCast property.
                        // It's even possible that 2nd place remains empty.
                        //
                        fSpellCostR += fSpellCost1;
                        //
                        // Using these two lines instead of the previous one
                        // would fix that.
                        //  fSpellCastR += fSpellCast2;
                        //  fSpellCast2 = fSpellCast1;

                        fSpellCost1  = fSpellCost;

                        // *****************************************************
                    }
                    else if (fSpellCost>fSpellCost2)
                    {
                        fSpellCostR += fSpellCost2;
                        fSpellCost2  = fSpellCost;
                    }
                    else
                    {
                        fSpellCostR += fSpellCost;
                    }

                    break;
                }
                default:
                    // Properties that aren't CastSpell properties
                    fIPCost += MK_IPRP_CalculateItemPropertyCost(iProp);
                    break;
                }
            }
            iProp = GetNextItemProperty(oItem);
        }

        int nBaseItemValue = MK_IPRP_GetBaseItemValue(oItem);

        // For the next line the order of the multiplicands is important.
        //
        // Actually 1000*fIPCost*fIPCost would give us the correct result but
        // unfortunately for some fIPCost that would be not the result the
        // official NWN item value calculation apparently gets sometimes (result-1).
        //
        // More precisely for every fIPCost where the IEEE 754 floating
        // point represenation is lower than fIPCost. That is for example 0.7,
        // 0.9, 1.4, 1.8, 2.1, 2.8, 3.3, 3.6, ...
        // In game this can be seen on any melee weapon+1 with no other IPs.
        // Its gold piece value is two gold to low (two because of the item
        // multiplier which is 2 for any weapon).
        //
        // For example for a simple dagger+1 we have:
        //   - basecost is 2,
        //   - item multiplier is 2,
        //   - fIPCost is StringToFloat("0.9") (IEEE 754 presentation is 0.899999976).
        // Calculating the better but wrong way would give us:
        //   - 1000 * 0.899999976 * 0.899999976 = 900.000 * 0.899999976 = 810.000 = 810
        //     Item value then would be 2*(2 + 810) = 2*812 = 1624
        // Doing the calculation as it's apparently done in NWN we get:
        //   - 0.899999976 * 0.899999976 * 1000 = 0.809999943 * 1000 = 809.999938 = 809
        //     That makes the item value 2*(2 + 809) = 2*811 = 1622 (two less than it should be)
        //
        int nIPCost =FloatToInt(fIPCost*fIPCost*1000);
        int nIPCostValue = FloatToInt(nIPCost*fItemMultiplier);

        // To calculate nSpellCostValue we have round down the product
        // fSpellCost*fItemMultiplier if the first number after the decimal point
        // is 0,1,2,3,4,5,6,7 and we have to round up if it's 8 or 9.
        // This looks simple but unfortunately it's not. For example
        //
        //   nSpellCostValue = FloatToInt(fSpellCost*fItemMultiplier + 0.2f);
        //
        // won't work always. Example:
        //
        //   FloatToInt(266.799987793 + 0.2f)
        //     = FloatToInt(267.000000)
        //     = 267 # 266
        //
        //  nSpellCostValue = FloatToInt((fSpellCost*fItemMultiplier*10 + 2.0) / 10);
        //
        // does not work too. Example
        //
        //   FloatToInt((266.799987793 * 10 + 2) / 10)
        //      = FloatToInt((2668.0000 + 2) / 10)
        //      = FloatToInt( 2670 / 10 )
        //      = 267 # 266
        //
        // In the end we have to convert the product into a string, search for the
        // decimal point and look at character following the decimal point.
//        int nSpellCostValue = MK_IPRP_FloatToInt(fSpellCost * fItemMultiplier, 8);
//        MK_IPRP_DEBUG_TRACE("   > fSpellCost*fIMulti="+FloatToString(fSpellCost * fItemMultiplier));
//        MK_IPRP_DEBUG_TRACE("   > (fSpellCost+1)*fIMulti="+FloatToString((fSpellCost+1) * fItemMultiplier));
//        MK_IPRP_DEBUG_TRACE("   > FloatToInt(fSpellCost+1)*fIMulti)="+IntToString(FloatToInt((fSpellCost+1) * fItemMultiplier)));
//        int nSpellCost = FloatToInt(fSpellCost1 + 0.75f*fSpellCost2 + 0.5f*fSpellCostR);
//        int nSpellCost = MK_MATH_Round(fSpellCost1 + 0.75f*fSpellCost2 + 0.5f*fSpellCostR);
//        float fSpellCost = fSpellCost1 + 0.75f*fSpellCost2 + 0.5f*fSpellCostR;
//        int nSpellCost = FloatToInt(fSpellCost1) + FloatToInt(0.75f*fSpellCost2) + FloatToInt(0.5f*fSpellCostR);

        float fSpellCost1q = fSpellCost1;
        float fSpellCost2q = 0.75f*fSpellCost2;
        float fSpellCostRq = 0.5f*fSpellCostR;

        int nSpellCost1 = FloatToInt(fSpellCost1q);  float fSpellCost1r = fSpellCost1q-nSpellCost1;
        int nSpellCost2 = FloatToInt(fSpellCost2q);  float fSpellCost2r = fSpellCost2q-nSpellCost2;
        int nSpellCostR = FloatToInt(fSpellCostRq);  float fSpellCostRr = fSpellCostRq-nSpellCostR;

        float fSpellCostRes = (fSpellCost1r+fSpellCost2r+fSpellCostRr);
        int nSpellCostRes = FloatToInt(fSpellCostRes);
        int nSpellCostS = nSpellCost1+nSpellCost2+nSpellCostR;

//        float fSpellCost = nSpellCost1+nSpellCost2+nSpellCostR + (fSpellCost1r+fSpellCost2r+fSpellCostRr);
//        int nSpellCost = nSpellCost1+nSpellCost2+nSpellCostR + FloatToInt(fSpellCost1r+fSpellCost2r+fSpellCostRr);

        float fSpellCost = fSpellCost1 + (7.5f*fSpellCost2/10) + 0.5f*fSpellCostR;
        int nSpellCost = FloatToInt(fSpellCost);
        float fSpellCostValue = (nSpellCost + 1) * fItemMultiplier - FloatToInt(fItemMultiplier);
        int nSpellCostValue = FloatToInt(fSpellCostValue);


        int nStackSize = GetItemStackSize(oItem);

        nItemValue = (nBaseItemValue + nIPCostValue + nSpellCostValue + nAdditionalCost) * nStackSize;

        if (nItemValue==0)
        {
            int nMaxStack = MK_Get2DAInt("baseitems", "Stacking", nBaseItemType, 1);
            if (nStackSize>=nMaxStack)
            {
                nItemValue = 1;
            }
        }

        if (bWriteLog)
        {
            itemproperty iProp = GetFirstItemProperty(oItem);
            string sMsg="";
            string sSubTypeCosts="";
            string sCostTableCosts="";
            while (GetIsItemPropertyValid(iProp))
            {
                if (GetItemPropertyType(iProp) == ITEM_PROPERTY_CAST_SPELL)
                {
                    int nSubType = GetItemPropertySubType(iProp);
                    sMsg += (";"+IntToString(nSubType));
                    sSubTypeCosts += (";"+FloatToString(MK_Get2DAFloat("iprp_spells", "Cost", nSubType)));
                    sCostTableCosts += (";"+FloatToString(MK_Get2DAFloat("iprp_chargecost", "Cost", GetItemPropertyCostTableValue(iProp))));
                }
                iProp = GetNextItemProperty(oItem);
            }
            sMsg += sSubTypeCosts;
            sMsg += sCostTableCosts;
            sMsg += (";"+FloatToString(fSpellCost1)+";"+FloatToString(fSpellCost2)+";"+FloatToString(fSpellCostR)+";"
                +FloatToString(fSpellCost1q)+";"+FloatToString(fSpellCost2q)+";"+FloatToString(fSpellCostRq)+";"
                +IntToString(nSpellCost1)+";"+IntToString(nSpellCost2)+";"+IntToString(nSpellCostR)+";"
                +FloatToString(fSpellCost1r)+";"+FloatToString(fSpellCost2r)+";"+FloatToString(fSpellCostRr)+";"
                +IntToString(nSpellCostS)+";"+FloatToString(fSpellCostRes)+";"+IntToString(nSpellCostRes)+";"
                +FloatToString(fSpellCost)+";"+IntToString(nSpellCost)+";"+FloatToString(fSpellCostValue)+";"
                +IntToString(nSpellCostValue)+";"
                +FloatToString(fItemMultiplier)+";"+IntToString(nItemValue-nAdditionalCost-nBaseItemValue)+";"+IntToString(GetGoldPieceValue(oItem)-nAdditionalCost-nBaseItemValue));
            WriteTimestampedLogEntry(sMsg);
        }

        MK_IPRP_DEBUG_TRACE(" > nBaseItemValue = "+IntToString(nBaseItemValue));
        MK_IPRP_DEBUG_TRACE("   > fItemMultiplier="+FloatToString(fItemMultiplier));
        MK_IPRP_DEBUG_TRACE(" > nIPCostValue = "+IntToString(nIPCostValue)+ " (fIPCost="+FloatToString(fIPCost)+")");
        MK_IPRP_DEBUG_TRACE(" > nSpellCostValue = "+IntToString(nSpellCostValue));
        MK_IPRP_DEBUG_TRACE("   > fSpellCost1,2,R="+FloatToString(fSpellCost1)+", "+FloatToString(fSpellCost2)+", "+FloatToString(fSpellCostR));
        MK_IPRP_DEBUG_TRACE("   > 1*fSpC1/0,75*fSpC2/0,5*fSpCR="+FloatToString(1.0*fSpellCost1)+", "+FloatToString(0.75*fSpellCost2)+", "+FloatToString(0.5*fSpellCostR));
        MK_IPRP_DEBUG_TRACE("   > 1*fSpC1+0,75*fSpC2+0,5*fSpCR="+FloatToString(fSpellCost));
        MK_IPRP_DEBUG_TRACE("   > nSpellCost="+IntToString(nSpellCost));
        MK_IPRP_DEBUG_TRACE("   > fSpellCostValue [ =(nSpellCost + 1) * fItemMultiplier - FloatToInt(fItemMultiplier) ]="+FloatToString(fSpellCostValue));

        MK_IPRP_DEBUG_TRACE(" > nAdditionalCost = "+IntToString(nAdditionalCost));
        int nMaxStack = MK_Get2DAInt("baseitems", "Stacking", nBaseItemType, 1);
        MK_IPRP_DEBUG_TRACE(" > nStackSize/nStackMax="+IntToString(nStackSize)+"/"+IntToString(nMaxStack));
        MK_IPRP_DEBUG_TRACE(" > nItemValue = "+IntToString(nItemValue));

    }
    return nItemValue;
}

int MK_IPRP_GetItemPropertyType(itemproperty iProp)
{
    return GetItemPropertyType(iProp);
}

int MK_IPRP_GetItemPropertySubType(itemproperty iProp)
{
    return ((MK_IPRP_GetSubTypeResRef(iProp)!="") ? GetItemPropertySubType(iProp) : 0);
}

int MK_IPRP_GetItemPropertyCostTableValue(itemproperty iProp)
{
    return ((MK_IPRP_GetCostTableResRef(iProp)!="") ? GetItemPropertyCostTableValue(iProp) : 0);
}

int MK_IPRP_GetItemPropertyParam1Value(itemproperty iProp)
{
    return ((MK_IPRP_GetParam1ResRef(iProp)!="") ? GetItemPropertyParam1Value(iProp) : 0);
}

/*
void main()
{

}
/**/
