/* COMMON Library by Gigaschatten */

//void main() {}

#include "gs_inc_flag"
#include "gs_inc_location"
#include "gs_inc_pc"
#include "gs_inc_text"

const string GS_CM_TEMPLATE_RECREATOR         = "gs_placeable034";
const string GS_CM_TEMPLATE_GOLD              = "nw_it_gold001";

const int GS_CM_TEMPLATE_TYPE_TREASURE_LOW    =  1;
const int GS_CM_TEMPLATE_TYPE_TREASURE_MEDIUM =  2;
const int GS_CM_TEMPLATE_TYPE_TREASURE_HIGH   =  3;
const int GS_CM_TEMPLATE_TYPE_TREASURE_UNIQUE =  4;
const int GS_CM_TEMPLATE_TYPE_WEAPON_LOW      =  5;
const int GS_CM_TEMPLATE_TYPE_WEAPON_MEDIUM   =  6;
const int GS_CM_TEMPLATE_TYPE_WEAPON_HIGH     =  7;
const int GS_CM_TEMPLATE_TYPE_WEAPON_UNIQUE   =  8;
const int GS_CM_TEMPLATE_TYPE_ARMOR_LOW       =  9;
const int GS_CM_TEMPLATE_TYPE_ARMOR_MEDIUM    = 10;
const int GS_CM_TEMPLATE_TYPE_ARMOR_HIGH      = 11;
const int GS_CM_TEMPLATE_TYPE_ARMOR_UNIQUE    = 12;

//open oStore to oCustomer trading with oMerchant
void gsCMOpenStore(object oStore, object oMerchant, object oCustomer = OBJECT_SELF);
//destroy any object within oObject
void gsCMDestroyInventory(object oObject = OBJECT_SELF);
//transfer any item if nDroppable from oSource to oTarget including Gold
void gsCMTransferInventory(object oSource, object oTarget, int nDroppable = TRUE);
//completely destroy oObject
void gsCMDestroyObject(object oObject = OBJECT_SELF);
//resurrect oObject
void gsCMResurrect(object oCreature = OBJECT_SELF);
//teleport oCreature to oTarget using nVisualEffect
void gsCMTeleportToObject(object oCreature, object oTarget, int nVisualEffect = VFX_IMP_AC_BONUS);
//teleport oCreature to lTarget using nVisualEffect
void gsCMTeleportToLocation(object oCreature, location lTarget, int nVisualEffect = VFX_IMP_AC_BONUS);
//place recreator of oObject to activate after nTimeout
void gsCMCreateRecreator(int nTimeout, object oObject = OBJECT_SELF);
//place recreator of oObject at lLocation to activate after nTimeout
void gsCMCreateRecreatorAtLocation(location lLocation, int nTimeout, object oObject = OBJECT_SELF);
//place recreator for oObject of random nType to activate after nTimeout
void gsCMCreateRecreatorByType(int nType, int nTimeout, object oObject = OBJECT_SELF);
//return random tamplate of nType
string gsCMGetTemplateByType(int nType);
//create nAmount gold on oTarget
void gsCMCreateGold(int nAmount, object oTarget = OBJECT_SELF);
//return nearest object to oTarget of nType having sTag
object gsCMGetNearestObject(string sTag, int nType = OBJECT_TYPE_PLACEABLE, object oTarget = OBJECT_SELF);
//return object of nType having sTag
object gsCMGetObject(string sTag, int nType = OBJECT_TYPE_WAYPOINT);
//set hitpoints of oCreature to nValue
void gsCMSetHitPoints(int nValue, object oCreature);
//return value of oItem
int gsCMGetItemValue(object oItem);
//return item level of nValue
int gsCMGetItemLevelByValue(int nValue);
//return a random string of nLength
string gsCMCreateRandomID(int nLength = 16);
//return TRUE if oCreature has nClass
int gsCMGetHasClass(int nClass, object oCreature = OBJECT_SELF);
//return base armor class of oItem
int gsCMGetItemBaseAC(object oItem);
//return base nSkill of oCreature taking related nAbility into account
int gsCMGetBaseSkillRank(int nSkill, int nAbility, object oCreature = OBJECT_SELF);
//internally used
int _gsCMGetBaseSkillRank(int nSkill, int nAbility, object oItem);
//return maximum mana of creature
void gsCMCalculateMaximumMana(object oCreature);
//send sText to all players
void gsCMSendMessageToAllPCs(string sText);
//return sString exchanging %1 with sReplacement1, %2 with sReplacement2, %3 with sReplacement3 and %4 with sReplacement4
string gsCMReplaceString(string sString, string sReplacement1 = "", string sReplacement2 = "", string sReplacement3 = "", string sReplacement4 = "");
//return nCount concatenations of sRepeat
string gsCMRepeatString(string sRepeat, int nCount);
//remove redundant whitespace from sString
string gsCMCleanWhitespace(string sString);
//reboot server after fDelay seconds
void gsCMRebootServer(float fDelay = 60.0);
//internally used
void _gsCMRebootServer();
//internally used
void __gsCMRebootServer();

void gsCMOpenStore(object oStore, object oMerchant, object oCustomer = OBJECT_SELF)
{
    object oModule    = GetModule();
    string sString    = ObjectToString(oStore);
    int nAppraise     = gsCMGetBaseSkillRank(SKILL_APPRAISE, IP_CONST_ABILITY_INT, oCustomer);
    int nModifierSell = GetLocalInt(oModule, "GS_STORE_MODIFIER_SELL") +
                        GetLocalInt(oStore, "GS_MODIFIER_SELL");
    int nModifierBuy  = GetLocalInt(oModule, "GS_STORE_MODIFIER_BUY") +
                        GetLocalInt(oStore, "GS_MODIFIER_BUY");
    int nIdentifyCost = 0;
    int nMaxBuyPrice  = 0;
    int nValue        = 0;

    if (GetLocalInt(oStore, "GS_STORE_ENABLED"))
    {
        nIdentifyCost = GetLocalInt(oStore, "GS_STORE_IDENTIFY_COST");
        nMaxBuyPrice  = GetLocalInt(oStore, "GS_STORE_MAX_BUY_PRICE");
    }
    else
    {
        nIdentifyCost = GetStoreIdentifyCost(oStore);
        nMaxBuyPrice  = GetStoreMaxBuyPrice(oStore);

        SetLocalInt(oStore, "GS_STORE_IDENTIFY_COST", nIdentifyCost);
        SetLocalInt(oStore, "GS_STORE_MAX_BUY_PRICE", nMaxBuyPrice);
        SetLocalInt(oStore, "GS_STORE_ENABLED", TRUE);
    }

    // Edit by Mithreas. If characters have a modified Appraise of 0 or less
    // then they shouldn't be treated as already having a value. The old logic
    // was meant to check if the character's Appraise skill has improved. The
    // new logic also check for now logic already set for the store. --[
    //if (nAppraise > GetLocalInt(oCustomer, "GS_STORE_APPRAISE_" + sString))
    if (nAppraise > GetLocalInt(oCustomer, "GS_STORE_APPRAISE_" + sString) ||
        GetLocalInt(oCustomer, "GS_STORE_VALUE_" + sString) == 0)
    // ]-- End edit but see further related changes below.
    {
        nValue = (GetSkillRank(SKILL_APPRAISE, oMerchant) + d10()) - (nAppraise + d10());

        if (nValue > 10)       nValue =  10;
        else if (nValue < -10) nValue = -10;

        SetLocalInt(oCustomer, "GS_STORE_APPRAISE_" + sString, nAppraise);
        // Edit by Mithreas - store 0 as -99 so we can distinguish between
        // 0 and no value. --[
        if (nValue == 0)
        {
          SetLocalInt(oCustomer, "GS_STORE_VALUE_" + sString, -99);
        }
        else
        {
          SetLocalInt(oCustomer, "GS_STORE_VALUE_" + sString, nValue);
        }
        // ]-- End edit.
    }
    else
    {
        nValue = GetLocalInt(oCustomer, "GS_STORE_VALUE_" + sString);
        // Edit by Mithreas - convert -99 back to 0. --[
        if (nValue == -99) nValue = 0;
        // ]-- End edit.
    }

    if (nValue > 0)      SendMessageToPC(oCustomer, "<cþë¦>" + GetStringByStrRef(8963));
    else if (nValue < 0) SendMessageToPC(oCustomer, "<cþë¦>" + GetStringByStrRef(8965));
    else                 SendMessageToPC(oCustomer, "<cþë¦>" + GetStringByStrRef(8964));

    if (nIdentifyCost >= 0)
    {
        nIdentifyCost = nIdentifyCost * (100 + nValue) / 100;
        if (nIdentifyCost < 0) nIdentifyCost = 0;
        SetStoreIdentifyCost(oStore, nIdentifyCost);
    }

    if (nMaxBuyPrice >= 0)
    {
        nMaxBuyPrice  = nMaxBuyPrice * (100 - nValue) / 100;
        if (nMaxBuyPrice < 0)  nMaxBuyPrice = 0;
        SetStoreMaxBuyPrice(oStore, nMaxBuyPrice);
    }

    nModifierSell += nValue;
    if (nModifierSell > 100)       nModifierSell =  100;
    else if (nModifierSell < -100) nModifierSell = -100;

    nModifierBuy  -= nValue;
    if (nModifierBuy > 100)        nModifierBuy  =  100;
    else if (nModifierBuy < -99)   nModifierBuy  = -99;

    OpenStore(oStore, oCustomer, nModifierSell, nModifierBuy);
}
//----------------------------------------------------------------
void gsCMDestroyInventory(object oObject = OBJECT_SELF)
{
    object oItem = OBJECT_INVALID;

    if (GetObjectType(oObject) == OBJECT_TYPE_CREATURE)
    {
        //gold
        AssignCommand(oObject, TakeGoldFromCreature(GetGold(oObject), oObject, TRUE));

        //creature slots
        oItem = GetItemInSlot(INVENTORY_SLOT_ARMS,      oObject);
        if (GetIsObjectValid(oItem)) DestroyObject(oItem);
        oItem = GetItemInSlot(INVENTORY_SLOT_ARROWS,    oObject);
        if (GetIsObjectValid(oItem)) DestroyObject(oItem);
        oItem = GetItemInSlot(INVENTORY_SLOT_BELT,      oObject);
        if (GetIsObjectValid(oItem)) DestroyObject(oItem);
        oItem = GetItemInSlot(INVENTORY_SLOT_BOLTS,     oObject);
        if (GetIsObjectValid(oItem)) DestroyObject(oItem);
        oItem = GetItemInSlot(INVENTORY_SLOT_BOOTS,     oObject);
        if (GetIsObjectValid(oItem)) DestroyObject(oItem);
        oItem = GetItemInSlot(INVENTORY_SLOT_BULLETS,   oObject);
        if (GetIsObjectValid(oItem)) DestroyObject(oItem);
        oItem = GetItemInSlot(INVENTORY_SLOT_CHEST,     oObject);
        if (GetIsObjectValid(oItem)) DestroyObject(oItem);
        oItem = GetItemInSlot(INVENTORY_SLOT_CLOAK,     oObject);
        if (GetIsObjectValid(oItem)) DestroyObject(oItem);
        oItem = GetItemInSlot(INVENTORY_SLOT_HEAD,      oObject);
        if (GetIsObjectValid(oItem)) DestroyObject(oItem);
        oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,  oObject);
        if (GetIsObjectValid(oItem)) DestroyObject(oItem);
        oItem = GetItemInSlot(INVENTORY_SLOT_LEFTRING,  oObject);
        if (GetIsObjectValid(oItem)) DestroyObject(oItem);
        oItem = GetItemInSlot(INVENTORY_SLOT_NECK,      oObject);
        if (GetIsObjectValid(oItem)) DestroyObject(oItem);
        oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oObject);
        if (GetIsObjectValid(oItem)) DestroyObject(oItem);
        oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oObject);
        if (GetIsObjectValid(oItem)) DestroyObject(oItem);
    }

    //inventory
    oItem        = GetFirstItemInInventory(oObject);

    while (GetIsObjectValid(oItem))
    {
        DestroyObject(oItem);
        oItem = GetNextItemInInventory(oObject);
    }
}
//----------------------------------------------------------------
void gsCMTransferInventory(object oSource, object oTarget, int nDroppable = TRUE)
{
    object oItem = OBJECT_INVALID;

    if (GetObjectType(oSource) == OBJECT_TYPE_CREATURE)
    {
        //gold
        AssignCommand(oTarget, TakeGoldFromCreature(GetGold(oSource), oSource));

        //creature slots
        oItem = GetItemInSlot(INVENTORY_SLOT_ARMS,      oSource);
        if (GetIsObjectValid(oItem) && (nDroppable || GetDroppableFlag(oItem)))
            AssignCommand(oTarget, ActionTakeItem(oItem, oSource));
        oItem = GetItemInSlot(INVENTORY_SLOT_ARROWS,    oSource);
        if (GetIsObjectValid(oItem) && (nDroppable || GetDroppableFlag(oItem)))
            AssignCommand(oTarget, ActionTakeItem(oItem, oSource));
        oItem = GetItemInSlot(INVENTORY_SLOT_BELT,      oSource);
        if (GetIsObjectValid(oItem) && (nDroppable || GetDroppableFlag(oItem)))
            AssignCommand(oTarget, ActionTakeItem(oItem, oSource));
        oItem = GetItemInSlot(INVENTORY_SLOT_BOLTS,     oSource);
        if (GetIsObjectValid(oItem) && (nDroppable || GetDroppableFlag(oItem)))
            AssignCommand(oTarget, ActionTakeItem(oItem, oSource));
        oItem = GetItemInSlot(INVENTORY_SLOT_BOOTS,     oSource);
        if (GetIsObjectValid(oItem) && (nDroppable || GetDroppableFlag(oItem)))
            AssignCommand(oTarget, ActionTakeItem(oItem, oSource));
        oItem = GetItemInSlot(INVENTORY_SLOT_BULLETS,   oSource);
        if (GetIsObjectValid(oItem) && (nDroppable || GetDroppableFlag(oItem)))
            AssignCommand(oTarget, ActionTakeItem(oItem, oSource));
        oItem = GetItemInSlot(INVENTORY_SLOT_CHEST,     oSource);
        if (GetIsObjectValid(oItem) && (nDroppable || GetDroppableFlag(oItem)))
            AssignCommand(oTarget, ActionTakeItem(oItem, oSource));
        oItem = GetItemInSlot(INVENTORY_SLOT_CLOAK,     oSource);
        if (GetIsObjectValid(oItem) && (nDroppable || GetDroppableFlag(oItem)))
            AssignCommand(oTarget, ActionTakeItem(oItem, oSource));
        oItem = GetItemInSlot(INVENTORY_SLOT_HEAD,      oSource);
        if (GetIsObjectValid(oItem) && (nDroppable || GetDroppableFlag(oItem)))
            AssignCommand(oTarget, ActionTakeItem(oItem, oSource));
        oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,  oSource);
        if (GetIsObjectValid(oItem) && (nDroppable || GetDroppableFlag(oItem)))
            AssignCommand(oTarget, ActionTakeItem(oItem, oSource));
        oItem = GetItemInSlot(INVENTORY_SLOT_LEFTRING,  oSource);
        if (GetIsObjectValid(oItem) && (nDroppable || GetDroppableFlag(oItem)))
            AssignCommand(oTarget, ActionTakeItem(oItem, oSource));
        oItem = GetItemInSlot(INVENTORY_SLOT_NECK,      oSource);
        if (GetIsObjectValid(oItem) && (nDroppable || GetDroppableFlag(oItem)))
            AssignCommand(oTarget, ActionTakeItem(oItem, oSource));
        oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oSource);
        if (GetIsObjectValid(oItem) && (nDroppable || GetDroppableFlag(oItem)))
            AssignCommand(oTarget, ActionTakeItem(oItem, oSource));
        oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oSource);
        if (GetIsObjectValid(oItem) && (nDroppable || GetDroppableFlag(oItem)))
            AssignCommand(oTarget, ActionTakeItem(oItem, oSource));
    }

    //inventory
    oItem        = GetFirstItemInInventory(oSource);

    while (GetIsObjectValid(oItem))
    {
        if (nDroppable || GetDroppableFlag(oItem))
        {
            AssignCommand(oTarget, ActionTakeItem(oItem, oSource));
        }

        oItem = GetNextItemInInventory(oSource);
    }
}
//----------------------------------------------------------------
void gsCMDestroyObject(object oObject = OBJECT_SELF)
{
    switch (GetObjectType(oObject))
    {
    case OBJECT_TYPE_AREA_OF_EFFECT:
        break;

    case OBJECT_TYPE_CREATURE:
        gsCMDestroyInventory(oObject);
        SetIsDestroyable(TRUE, FALSE);
        break;

    case OBJECT_TYPE_DOOR:
        break;

    case OBJECT_TYPE_ENCOUNTER:
        break;

    case OBJECT_TYPE_ITEM:
        break;

    case OBJECT_TYPE_PLACEABLE:
        gsCMDestroyInventory(oObject);
        break;

    case OBJECT_TYPE_STORE:
        break;

    case OBJECT_TYPE_TRIGGER:
        break;

    case OBJECT_TYPE_WAYPOINT:
        break;
    }

    DestroyObject(oObject);
}
//----------------------------------------------------------------
void gsCMResurrect(object oCreature = OBJECT_SELF)
{
    if (! GetIsDead(oCreature)) return;

    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oCreature);
    gsCMSetHitPoints(GetMaxHitPoints(oCreature) + 10, oCreature);

    if (GetIsPC(oCreature))
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RAISE_DEAD), oCreature);
    }
    else
    {
        AssignCommand(oCreature, JumpToLocation(GetLocalLocation(oCreature, "GS_LOCATION")));
    }
}
//----------------------------------------------------------------
void gsCMTeleportToObject(object oCreature, object oTarget, int nVisualEffect = VFX_IMP_AC_BONUS)
{
    if (nVisualEffect) ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(nVisualEffect), GetLocation(oCreature));
    AssignCommand(oCreature, ClearAllActions(TRUE));
    AssignCommand(oCreature, ActionJumpToObject(oTarget));
    AssignCommand(oCreature, ActionDoCommand(SetFacing(GetFacing(oTarget))));
    if (nVisualEffect) AssignCommand(oCreature, ActionDoCommand(ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(nVisualEffect), GetLocation(oCreature))));
}
//----------------------------------------------------------------
void gsCMTeleportToLocation(object oCreature, location lTarget, int nVisualEffect = VFX_IMP_AC_BONUS)
{
    if (nVisualEffect) ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(nVisualEffect), GetLocation(oCreature));
    AssignCommand(oCreature, ClearAllActions(TRUE));
    AssignCommand(oCreature, ActionJumpToLocation(lTarget));
    if (nVisualEffect) AssignCommand(oCreature, ActionDoCommand(ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(nVisualEffect), GetLocation(oCreature))));
}
//----------------------------------------------------------------
void gsCMCreateRecreator(int nTimeout, object oObject = OBJECT_SELF)
{
    gsCMCreateRecreatorAtLocation(GetLocation(oObject), nTimeout, oObject);
}
//----------------------------------------------------------------
void gsCMCreateRecreatorAtLocation(location lLocation, int nTimeout, object oObject = OBJECT_SELF)
{
    object oRecreator = CreateObject(OBJECT_TYPE_PLACEABLE,
                                     GS_CM_TEMPLATE_RECREATOR,
                                     lLocation);

    if (GetIsObjectValid(oRecreator))
    {
        SetLocalString(oRecreator, "GS_TEMPLATE", GetResRef(oObject));
        SetLocalInt(oRecreator, "GS_TYPE", GetObjectType(oObject));
        SetLocalInt(oRecreator, "GS_TIMEOUT", nTimeout);
    }
}
//----------------------------------------------------------------
void gsCMCreateRecreatorByType(int nType, int nTimeout, object oObject = OBJECT_SELF)
{
    object oRecreator = CreateObject(OBJECT_TYPE_PLACEABLE,
                                     GS_CM_TEMPLATE_RECREATOR,
                                     GetLocation(oObject));

    if (GetIsObjectValid(oRecreator))
    {
        SetLocalString(oRecreator, "GS_TEMPLATE", gsCMGetTemplateByType(nType));
        SetLocalInt(oRecreator, "GS_TYPE", GetObjectType(oObject));
        SetLocalInt(oRecreator, "GS_TIMEOUT", nTimeout);
    }
}
//----------------------------------------------------------------
string gsCMGetTemplateByType(int nType)
{
    switch (nType)
    {
    case GS_CM_TEMPLATE_TYPE_TREASURE_LOW:
        switch (Random(9))
        {
        case 0: return "gs_placeable033";
        case 1: return "gs_placeable048";
        case 2: return "gs_placeable049";
        case 3: return "gs_placeable050";
        case 4: return "gs_placeable065";
        case 5: return "gs_placeable066";
        case 6: return "gs_placeable067";
        case 7: return "gs_placeable068";
        case 8: return "gs_placeable069";
        }

    case GS_CM_TEMPLATE_TYPE_TREASURE_MEDIUM:
        switch (Random(9))
        {
        case 0: return "gs_placeable035";
        case 1: return "gs_placeable070";
        case 2: return "gs_placeable071";
        case 3: return "gs_placeable072";
        case 4: return "gs_placeable073";
        case 5: return "gs_placeable074";
        case 6: return "gs_placeable075";
        case 7: return "gs_placeable076";
        case 8: return "gs_placeable077";
        }

    case GS_CM_TEMPLATE_TYPE_TREASURE_HIGH:
        switch (Random(9))
        {
        case 0: return "gs_placeable036";
        case 1: return "gs_placeable078";
        case 2: return "gs_placeable079";
        case 3: return "gs_placeable080";
        case 4: return "gs_placeable081";
        case 5: return "gs_placeable082";
        case 6: return "gs_placeable083";
        case 7: return "gs_placeable084";
        case 8: return "gs_placeable085";
        }

    case GS_CM_TEMPLATE_TYPE_TREASURE_UNIQUE:
        switch (Random(4))
        {
        case 0: return "gs_placeable093";
        case 1: return "gs_placeable094";
        case 2: return "gs_placeable095";
        case 3: return "gs_placeable096";
        }

    case GS_CM_TEMPLATE_TYPE_WEAPON_LOW:
        switch (Random(9))
        {
        case 0: return "gs_placeable116";
        case 1: return "gs_placeable117";
        case 2: return "gs_placeable118";
        case 3: return "gs_placeable119";
        case 4: return "gs_placeable120";
        case 5: return "gs_placeable121";
        case 6: return "gs_placeable122";
        case 7: return "gs_placeable123";
        case 8: return "gs_placeable124";
        }

    case GS_CM_TEMPLATE_TYPE_WEAPON_MEDIUM:
        switch (Random(9))
        {
        case 0: return "gs_placeable107";
        case 1: return "gs_placeable108";
        case 2: return "gs_placeable109";
        case 3: return "gs_placeable110";
        case 4: return "gs_placeable111";
        case 5: return "gs_placeable112";
        case 6: return "gs_placeable113";
        case 7: return "gs_placeable114";
        case 8: return "gs_placeable115";
        }

    case GS_CM_TEMPLATE_TYPE_WEAPON_HIGH:
        switch (Random(9))
        {
        case 0: return "gs_placeable098";
        case 1: return "gs_placeable099";
        case 2: return "gs_placeable100";
        case 3: return "gs_placeable101";
        case 4: return "gs_placeable102";
        case 5: return "gs_placeable103";
        case 6: return "gs_placeable104";
        case 7: return "gs_placeable105";
        case 8: return "gs_placeable106";
        }

    case GS_CM_TEMPLATE_TYPE_WEAPON_UNIQUE:
        switch (Random(4))
        {
        case 0: return "gs_placeable125";
        case 1: return "gs_placeable126";
        case 2: return "gs_placeable127";
        case 3: return "gs_placeable128";
        }

    case GS_CM_TEMPLATE_TYPE_ARMOR_LOW:
        switch (Random(9))
        {
        case 0: return "gs_placeable151";
        case 1: return "gs_placeable152";
        case 2: return "gs_placeable153";
        case 3: return "gs_placeable154";
        case 4: return "gs_placeable155";
        case 5: return "gs_placeable156";
        case 6: return "gs_placeable157";
        case 7: return "gs_placeable158";
        case 8: return "gs_placeable159";
        }

    case GS_CM_TEMPLATE_TYPE_ARMOR_MEDIUM:
        switch (Random(9))
        {
        case 0: return "gs_placeable142";
        case 1: return "gs_placeable143";
        case 2: return "gs_placeable144";
        case 3: return "gs_placeable145";
        case 4: return "gs_placeable146";
        case 5: return "gs_placeable147";
        case 6: return "gs_placeable148";
        case 7: return "gs_placeable149";
        case 8: return "gs_placeable150";
        }

    case GS_CM_TEMPLATE_TYPE_ARMOR_HIGH:
        switch (Random(9))
        {
        case 0: return "gs_placeable133";
        case 1: return "gs_placeable134";
        case 2: return "gs_placeable135";
        case 3: return "gs_placeable136";
        case 4: return "gs_placeable137";
        case 5: return "gs_placeable138";
        case 6: return "gs_placeable139";
        case 7: return "gs_placeable140";
        case 8: return "gs_placeable141";
        }

    case GS_CM_TEMPLATE_TYPE_ARMOR_UNIQUE:
        switch (Random(4))
        {
        case 0: return "gs_placeable160";
        case 1: return "gs_placeable161";
        case 2: return "gs_placeable162";
        case 3: return "gs_placeable163";
        }
    }

    return "";
}
//----------------------------------------------------------------
void gsCMCreateGold(int nAmount, object oTarget = OBJECT_SELF)
{
    if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {
        GiveGoldToCreature(oTarget, nAmount);
    }
    else
    {
        while (nAmount > 50000)
        {
            CreateItemOnObject(GS_CM_TEMPLATE_GOLD, oTarget, 50000);
            nAmount -= 50000;
        }

        if (nAmount > 0) CreateItemOnObject(GS_CM_TEMPLATE_GOLD, oTarget, nAmount);
    }
}
//----------------------------------------------------------------
object gsCMGetNearestObject(string sTag, int nType = OBJECT_TYPE_PLACEABLE, object oTarget = OBJECT_SELF)
{
    object oObject = GetNearestObjectByTag(sTag, oTarget);
    int nNth       = 1;

    while (GetIsObjectValid(oObject))
    {
        if (GetObjectType(oObject) == nType) return oObject;
        oObject = GetNearestObjectByTag(sTag, oTarget, ++nNth);
    }

    return gsCMGetObject(sTag, nType);
}
//----------------------------------------------------------------
object gsCMGetObject(string sTag, int nType = OBJECT_TYPE_WAYPOINT)
{
    object oObject = GetObjectByTag(sTag);
    int nNth       = 0;

    while (GetIsObjectValid(oObject))
    {
        if (GetObjectType(oObject) == nType) return oObject;
        oObject = GetObjectByTag(sTag, ++nNth);
    }

    return OBJECT_INVALID;
}
//----------------------------------------------------------------
void gsCMSetHitPoints(int nValue, object oCreature)
{
    int nHitPoints = GetCurrentHitPoints(oCreature);
    effect eEffect;

    if (nValue < nHitPoints)      eEffect = EffectDamage(nHitPoints - nValue);
    else if (nValue > nHitPoints) eEffect = EffectHeal(nValue - nHitPoints);
    else                          return;

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oCreature);
}
//----------------------------------------------------------------
int gsCMGetItemValue(object oItem)
{
    int nPlot    = GetPlotFlag(oItem);
    int nUnknown = ! GetIdentified(oItem);
    int nValue   = 0;

    if (nPlot)    SetPlotFlag(oItem, FALSE);
    if (nUnknown) SetIdentified(oItem, TRUE);

    nValue       = GetGoldPieceValue(oItem);

    if (nPlot)    SetPlotFlag(oItem, TRUE);
    if (nUnknown) SetIdentified(oItem, FALSE);

    return nValue;
}
//----------------------------------------------------------------
int gsCMGetItemLevelByValue(int nValue)
{
    object oModule  = GetModule();
    string sString  = "";
    int nValueLevel = 0;
    int nNth        = 0;

    while (nNth < 60)
    {
        sString     = IntToString(nNth);
        nValueLevel = GetLocalInt(oModule, "GS_CM_ITEMVALUE_" + sString);

        if (! nValueLevel)
        {
            nValueLevel = StringToInt(Get2DAString("itemvalue", "MAXSINGLEITEMVALUE", nNth));
            SetLocalInt(oModule, "GS_CM_ITEMVALUE_" + sString, nValueLevel);
        }

        nNth++;

        if (nValue <= nValueLevel) break;
    }

    return nNth;
}
//----------------------------------------------------------------
string gsCMCreateRandomID(int nLength = 16)
{
    string sString = "";
    int nNth       = 0;

    for (; nNth < nLength; nNth++)
    {
        switch (Random(36))
        {
        case  0: sString += "A"; break;
        case  1: sString += "B"; break;
        case  2: sString += "C"; break;
        case  3: sString += "D"; break;
        case  4: sString += "E"; break;
        case  5: sString += "F"; break;
        case  6: sString += "G"; break;
        case  7: sString += "H"; break;
        case  8: sString += "I"; break;
        case  9: sString += "J"; break;
        case 10: sString += "K"; break;
        case 11: sString += "L"; break;
        case 12: sString += "M"; break;
        case 13: sString += "N"; break;
        case 14: sString += "O"; break;
        case 15: sString += "P"; break;
        case 16: sString += "Q"; break;
        case 17: sString += "R"; break;
        case 18: sString += "S"; break;
        case 19: sString += "T"; break;
        case 20: sString += "U"; break;
        case 21: sString += "V"; break;
        case 22: sString += "W"; break;
        case 23: sString += "X"; break;
        case 24: sString += "Y"; break;
        case 25: sString += "Z"; break;
        case 26: sString += "0"; break;
        case 27: sString += "1"; break;
        case 28: sString += "2"; break;
        case 29: sString += "3"; break;
        case 30: sString += "4"; break;
        case 31: sString += "5"; break;
        case 32: sString += "6"; break;
        case 33: sString += "7"; break;
        case 34: sString += "8"; break;
        case 35: sString += "9"; break;
        }
    }

    return sString;
}
//----------------------------------------------------------------
int gsCMGetHasClass(int nClass, object oCreature = OBJECT_SELF)
{
    return GetClassByPosition(1, oCreature) == nClass ||
           GetClassByPosition(2, oCreature) == nClass ||
           GetClassByPosition(3, oCreature) == nClass;
}
//----------------------------------------------------------------
int gsCMGetItemBaseAC(object oItem)
{
    int nAC                 = GetItemACValue(oItem);
    itemproperty ipProperty = GetFirstItemProperty(oItem);

    while (GetIsItemPropertyValid(ipProperty))
    {
        if (GetItemPropertyType(ipProperty) == ITEM_PROPERTY_AC_BONUS)
            nAC -= GetItemPropertyCostTableValue(ipProperty);

        ipProperty = GetNextItemProperty(oItem);
    }

    return nAC < 0 ? 0 : nAC;
}
//----------------------------------------------------------------
int gsCMGetBaseSkillRank(int nSkill, int nAbility, object oCreature = OBJECT_SELF)
{
    object oItem   = OBJECT_INVALID;
    int nSkillRank = GetSkillRank(nSkill, oCreature);
    if (nSkillRank < 0) nSkillRank = 0;

    oItem          = GetItemInSlot(INVENTORY_SLOT_ARMS, oCreature);
    if (GetIsObjectValid(oItem)) nSkillRank -= _gsCMGetBaseSkillRank(nSkill, nAbility, oItem);
    oItem          = GetItemInSlot(INVENTORY_SLOT_ARROWS, oCreature);
    if (GetIsObjectValid(oItem)) nSkillRank -= _gsCMGetBaseSkillRank(nSkill, nAbility, oItem);
    oItem          = GetItemInSlot(INVENTORY_SLOT_BELT, oCreature);
    if (GetIsObjectValid(oItem)) nSkillRank -= _gsCMGetBaseSkillRank(nSkill, nAbility, oItem);
    oItem          = GetItemInSlot(INVENTORY_SLOT_BOLTS, oCreature);
    if (GetIsObjectValid(oItem)) nSkillRank -= _gsCMGetBaseSkillRank(nSkill, nAbility, oItem);
    oItem          = GetItemInSlot(INVENTORY_SLOT_BOOTS, oCreature);
    if (GetIsObjectValid(oItem)) nSkillRank -= _gsCMGetBaseSkillRank(nSkill, nAbility, oItem);
    oItem          = GetItemInSlot(INVENTORY_SLOT_BULLETS, oCreature);
    if (GetIsObjectValid(oItem)) nSkillRank -= _gsCMGetBaseSkillRank(nSkill, nAbility, oItem);
    oItem          = GetItemInSlot(INVENTORY_SLOT_CHEST, oCreature);
    if (GetIsObjectValid(oItem)) nSkillRank -= _gsCMGetBaseSkillRank(nSkill, nAbility, oItem);
    oItem          = GetItemInSlot(INVENTORY_SLOT_CLOAK, oCreature);
    if (GetIsObjectValid(oItem)) nSkillRank -= _gsCMGetBaseSkillRank(nSkill, nAbility, oItem);
    oItem          = GetItemInSlot(INVENTORY_SLOT_HEAD, oCreature);
    if (GetIsObjectValid(oItem)) nSkillRank -= _gsCMGetBaseSkillRank(nSkill, nAbility, oItem);
    oItem          = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature);
    if (GetIsObjectValid(oItem)) nSkillRank -= _gsCMGetBaseSkillRank(nSkill, nAbility, oItem);
    oItem          = GetItemInSlot(INVENTORY_SLOT_LEFTRING, oCreature);
    if (GetIsObjectValid(oItem)) nSkillRank -= _gsCMGetBaseSkillRank(nSkill, nAbility, oItem);
    oItem          = GetItemInSlot(INVENTORY_SLOT_NECK, oCreature);
    if (GetIsObjectValid(oItem)) nSkillRank -= _gsCMGetBaseSkillRank(nSkill, nAbility, oItem);
    oItem          = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCreature);
    if (GetIsObjectValid(oItem)) nSkillRank -= _gsCMGetBaseSkillRank(nSkill, nAbility, oItem);
    oItem          = GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oCreature);
    if (GetIsObjectValid(oItem)) nSkillRank -= _gsCMGetBaseSkillRank(nSkill, nAbility, oItem);

    return nSkillRank;
}
//----------------------------------------------------------------
int _gsCMGetBaseSkillRank(int nSkill, int nAbility, object oItem)
{
    itemproperty ipProperty = GetFirstItemProperty(oItem);
    int nValue              = 0;

    while (GetIsItemPropertyValid(ipProperty))
    {
        switch (GetItemPropertyType(ipProperty))
        {
        case ITEM_PROPERTY_SKILL_BONUS:
            if (GetItemPropertySubType(ipProperty) == nSkill)
                nValue += GetItemPropertyCostTableValue(ipProperty) * 2;
            break;

        case ITEM_PROPERTY_ABILITY_BONUS:
            if (GetItemPropertySubType(ipProperty) == nAbility)
                nValue += GetItemPropertyCostTableValue(ipProperty);
            break;

        case ITEM_PROPERTY_DECREASED_ABILITY_SCORE:
            if (GetItemPropertySubType(ipProperty) == nAbility)
                nValue -= GetItemPropertyCostTableValue(ipProperty);
            break;
        }

        ipProperty = GetNextItemProperty(oItem);
    }

    return nValue / 2;
}
//----------------------------------------------------------------
void gsCMCalculateMaximumMana(object oCreature)
{
    int nMaximumMana = 0;
    int nMaximumClassMana = 0;

    switch(GetLevelByClass(CLASS_TYPE_CLERIC, oCreature))
    {
        case 0:
            nMaximumClassMana = 0;
        break;
        case 1:
            nMaximumClassMana = 4;
        break;
        case 2:
            nMaximumClassMana = 6;
        break;
        case 3:
            nMaximumClassMana = 14;
        break;
        case 4:
            nMaximumClassMana = 17;
        break;
        case 5:
            nMaximumClassMana = 27;
        break;
        case 6:
            nMaximumClassMana = 32;
        break;
        case 7:
            nMaximumClassMana = 38;
        break;
        case 8:
            nMaximumClassMana = 44;
        break;
        case 9:
            nMaximumClassMana = 57;
        break;
        case 10:
            nMaximumClassMana = 64;
        break;
        case 11:
            nMaximumClassMana = 73;
        break;
        case 12:
            nMaximumClassMana = 73;
        break;
        case 13:
            nMaximumClassMana = 83;
        break;
        case 14:
            nMaximumClassMana = 83;
        break;
        case 15:
            nMaximumClassMana = 94;
        break;
        case 16:
            nMaximumClassMana = 94;
        break;
        case 17:
            nMaximumClassMana = 107;
        break;
        case 18:
            nMaximumClassMana = 114;
        break;
        case 19:
            nMaximumClassMana = 123;
        break;
        case 20:
            nMaximumClassMana = 133;
        break;
        default:
            nMaximumClassMana = 133;
        break;
    }

    if (nMaximumMana < nMaximumClassMana){
        nMaximumMana = nMaximumClassMana; 
    }

    switch(GetLevelByClass(CLASS_TYPE_WIZARD, oCreature))
    {
        case 0:
            nMaximumClassMana = 0;
        break;
        case 1:
            nMaximumClassMana = 4;
        break;
        case 2:
            nMaximumClassMana = 6;
        break;
        case 3:
            nMaximumClassMana = 14;
        break;
        case 4:
            nMaximumClassMana = 17;
        break;
        case 5:
            nMaximumClassMana = 27;
        break;
        case 6:
            nMaximumClassMana = 32;
        break;
        case 7:
            nMaximumClassMana = 38;
        break;
        case 8:
            nMaximumClassMana = 44;
        break;
        case 9:
            nMaximumClassMana = 57;
        break;
        case 10:
            nMaximumClassMana = 64;
        break;
        case 11:
            nMaximumClassMana = 73;
        break;
        case 12:
            nMaximumClassMana = 73;
        break;
        case 13:
            nMaximumClassMana = 83;
        break;
        case 14:
            nMaximumClassMana = 83;
        break;
        case 15:
            nMaximumClassMana = 94;
        break;
        case 16:
            nMaximumClassMana = 94;
        break;
        case 17:
            nMaximumClassMana = 107;
        break;
        case 18:
            nMaximumClassMana = 114;
        break;
        case 19:
            nMaximumClassMana = 123;
        break;
        case 20:
            nMaximumClassMana = 133;
        break;
        default:
            nMaximumClassMana = 133;
        break;
    }

    if (nMaximumMana < nMaximumClassMana){
        nMaximumMana = nMaximumClassMana; 
    }

    switch(GetLevelByClass(CLASS_TYPE_DRUID, oCreature))
    {
        case 0:
            nMaximumClassMana = 0;
        break;
        case 1:
            nMaximumClassMana = 4;
        break;
        case 2:
            nMaximumClassMana = 6;
        break;
        case 3:
            nMaximumClassMana = 14;
        break;
        case 4:
            nMaximumClassMana = 17;
        break;
        case 5:
            nMaximumClassMana = 27;
        break;
        case 6:
            nMaximumClassMana = 32;
        break;
        case 7:
            nMaximumClassMana = 38;
        break;
        case 8:
            nMaximumClassMana = 44;
        break;
        case 9:
            nMaximumClassMana = 57;
        break;
        case 10:
            nMaximumClassMana = 64;
        break;
        case 11:
            nMaximumClassMana = 73;
        break;
        case 12:
            nMaximumClassMana = 73;
        break;
        case 13:
            nMaximumClassMana = 83;
        break;
        case 14:
            nMaximumClassMana = 83;
        break;
        case 15:
            nMaximumClassMana = 94;
        break;
        case 16:
            nMaximumClassMana = 94;
        break;
        case 17:
            nMaximumClassMana = 107;
        break;
        case 18:
            nMaximumClassMana = 114;
        break;
        case 19:
            nMaximumClassMana = 123;
        break;
        case 20:
            nMaximumClassMana = 133;
        break;
        default:
            nMaximumClassMana = 133;
        break;
    }

    if (nMaximumMana < nMaximumClassMana){
        nMaximumMana = nMaximumClassMana; 
    }

    switch(GetLevelByClass(CLASS_TYPE_SORCERER, oCreature))
    {
        case 0:
            nMaximumClassMana = 0;
        break;
        case 1:
            nMaximumClassMana = 5;
        break;
        case 2:
            nMaximumClassMana = 8;
        break;
        case 3:
            nMaximumClassMana = 17;
        break;
        case 4:
            nMaximumClassMana = 21;
        break;
        case 5:
            nMaximumClassMana = 32;
        break;
        case 6:
            nMaximumClassMana = 40;
        break;
        case 7:
            nMaximumClassMana = 47;
        break;
        case 8:
            nMaximumClassMana = 55;
        break;
        case 9:
            nMaximumClassMana = 71;
        break;
        case 10:
            nMaximumClassMana = 80;
        break;
        case 11:
            nMaximumClassMana = 91;
        break;
        case 12:
            nMaximumClassMana = 91;
        break;
        case 13:
            nMaximumClassMana = 103;
        break;
        case 14:
            nMaximumClassMana = 103;
        break;
        case 15:
            nMaximumClassMana = 117;
        break;
        case 16:
            nMaximumClassMana = 117;
        break;
        case 17:
            nMaximumClassMana = 133;
        break;
        case 18:
            nMaximumClassMana = 142;
        break;
        case 19:
            nMaximumClassMana = 153;
        break;
        case 20:
            nMaximumClassMana = 166;
        break;
        default:
            nMaximumClassMana = 166;
        break;
    }

    if (nMaximumMana < nMaximumClassMana){
        nMaximumMana = nMaximumClassMana; 
    }

    switch(GetLevelByClass(CLASS_TYPE_BARD, oCreature))
    {
        case 0:
            nMaximumClassMana = 0;
        break;
        case 1:
            nMaximumClassMana = 5;
        break;
        case 2:
            nMaximumClassMana = 8;
        break;
        case 3:
            nMaximumClassMana = 17;
        break;
        case 4:
            nMaximumClassMana = 21;
        break;
        case 5:
            nMaximumClassMana = 32;
        break;
        case 6:
            nMaximumClassMana = 40;
        break;
        case 7:
            nMaximumClassMana = 47;
        break;
        case 8:
            nMaximumClassMana = 55;
        break;
        case 9:
            nMaximumClassMana = 71;
        break;
        case 10:
            nMaximumClassMana = 80;
        break;
        case 11:
            nMaximumClassMana = 91;
        break;
        case 12:
            nMaximumClassMana = 91;
        break;
        case 13:
            nMaximumClassMana = 103;
        break;
        case 14:
            nMaximumClassMana = 103;
        break;
        case 15:
            nMaximumClassMana = 117;
        break;
        case 16:
            nMaximumClassMana = 117;
        break;
        case 17:
            nMaximumClassMana = 133;
        break;
        case 18:
            nMaximumClassMana = 142;
        break;
        case 19:
            nMaximumClassMana = 153;
        break;
        case 20:
            nMaximumClassMana = 166;
        break;
        default:
            nMaximumClassMana = 166;
        break;
    }

    if (nMaximumMana < nMaximumClassMana){
        nMaximumMana = nMaximumClassMana; 
    }

    switch(GetLevelByClass(CLASS_TYPE_PALADIN, oCreature))
    {
        case 0:
            nMaximumClassMana = 0;
        break;
        case 1:
            nMaximumClassMana = 0;
        break;
        case 2:
            nMaximumClassMana = 4;
        break;
        case 3:
            nMaximumClassMana = 5;
        break;
        case 4:
            nMaximumClassMana = 6;
        break;
        case 5:
            nMaximumClassMana = 10;
        break;
        case 6:
            nMaximumClassMana = 14;
        break;
        case 7:
            nMaximumClassMana = 15;
        break;
        case 8:
            nMaximumClassMana = 17;
        break;
        case 9:
            nMaximumClassMana = 22;
        break;
        case 10:
            nMaximumClassMana = 27;
        break;
        case 11:
            nMaximumClassMana = 29;
        break;
        case 12:
            nMaximumClassMana = 32;
        break;
        case 13:
            nMaximumClassMana = 35;
        break;
        case 14:
            nMaximumClassMana = 38;
        break;
        case 15:
            nMaximumClassMana = 41;
        break;
        case 16:
            nMaximumClassMana = 44;
        break;
        case 17:
            nMaximumClassMana = 50;
        break;
        case 18:
            nMaximumClassMana = 57;
        break;
        case 19:
            nMaximumClassMana = 60;
        break;
        case 20:
            nMaximumClassMana = 64;
        break;
        default:
            nMaximumClassMana = 64;
        break;
    }

    if (nMaximumMana < nMaximumClassMana){
        nMaximumMana = nMaximumClassMana; 
    }
    SetLocalInt(oCreature, "GS_MAXIMUM_MANA", nMaximumMana);
    SetLocalInt(oCreature, "GS_CURRENT_MANA", nMaximumMana);
}
//----------------------------------------------------------------
void gsCMSendMessageToAllPCs(string sText)
{
    object oPC = GetFirstPC();

    while (GetIsObjectValid(oPC))
    {
        FloatingTextStringOnCreature(sText, oPC, FALSE);
        oPC = GetNextPC();
    }
}
//----------------------------------------------------------------
string gsCMReplaceString(string sString, string sReplacement1 = "", string sReplacement2 = "", string sReplacement3 = "", string sReplacement4 = "")
{
    string sReplacement = "";
    int nPosition       = 0;
    int nNth            = 1;

    for (; nNth <= 4; nNth++)
    {
        nPosition = FindSubString(sString, "%" + IntToString(nNth));

        if (nPosition != -1)
        {
            switch (nNth)
            {
            case 1: sReplacement = sReplacement1; break;
            case 2: sReplacement = sReplacement2; break;
            case 3: sReplacement = sReplacement3; break;
            case 4: sReplacement = sReplacement4; break;
            }

            sString = GetStringLeft(sString, nPosition) +
                      sReplacement +
                      GetStringRight(sString, GetStringLength(sString) - nPosition - 2);
        }
    }

    return sString;
}
//----------------------------------------------------------------
string gsCMRepeatString(string sRepeat, int nCount)
{
    string sString = "";
    int nNth       = 0;

    for (; nNth < nCount; nNth++) sString += sRepeat;

    return sString;
}
//----------------------------------------------------------------
string gsCMCleanWhitespace(string sString)
{
    string sClean = "";
    string sChar  = "";
    int nCount    = GetStringLength(sString);
    int nNth      = 0;
    int nFlag     = FALSE;

    for (; nNth < nCount; nNth++)
    {
        sChar  = GetSubString(sString, nNth, 1);

        if (sChar == " ")
        {
            nFlag   = TRUE;
        }
        else if (nFlag)
        {
            sClean += " " + sChar;
            nFlag   = FALSE;
        }
        else
        {
            sClean += sChar;
        }
    }

    if (GetSubString(sClean, 0, 1) == " ")
    {
        nCount = GetStringLength(sClean);
        sClean = GetStringRight(sClean, nCount - 1);
    }

    return sClean;
}
//----------------------------------------------------------------
void gsCMRebootServer(float fDelay = 60.0)
{
    if (fDelay > 0.0)
    {
        gsCMSendMessageToAllPCs(
            gsCMReplaceString(
                GS_T_16777233,
                FloatToString(fDelay, 0, 0)));

        DelayCommand(fDelay, gsCMRebootServer(0.0));
    }
    else
    {
        object oPC = GetFirstPC();

        while (GetIsObjectValid(oPC))
        {
            if (! GetIsDM(oPC)) AssignCommand(oPC, _gsCMRebootServer());
            oPC = GetNextPC();
        }

        DelayCommand(30.0, __gsCMRebootServer());
    }
}
//----------------------------------------------------------------
void _gsCMRebootServer()
{
    //cancel actions
    ClearAllActions(TRUE);
    ActionJumpToLocation(GetLocation(OBJECT_SELF));
    SetCommandable(FALSE);

    //save location
    if (! gsFLGetAreaFlag("OVERRIDE_LOCATION"))
    {
        gsLOSetDBLocationOf("GS_LOCATION", gsPCGetPlayerID(OBJECT_SELF));
    }

    //export
    ExportSingleCharacter(OBJECT_SELF);

    //fade
    SetCutsceneMode(OBJECT_SELF);
    FadeToBlack(OBJECT_SELF, FADE_SPEED_SLOWEST);
}
//----------------------------------------------------------------
void __gsCMRebootServer()
{
    object oModule = GetModule();

    //try shutdown using nwnx_gigaschatten.dll
    SetLocalString(oModule, "NWNX!GIGASCHATTEN!SHUTDOWN_SERVER", "1");

    if (GetLocalString(oModule, "NWNX!GIGASCHATTEN!SHUTDOWN_SERVER") != "+OK")
    {
        //reload module if nwnx_gigaschatten.dll not installed
        StartNewModule(GetName(oModule));
    }
}
