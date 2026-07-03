#include "gs_inc_common"
#include "gs_inc_effect"
#include "gs_inc_finance"
#include "gs_inc_text"
#include "dmfi_init_inc"

void main()
{
    object oEntering   = GetEnteringObject();

    // Edit by Mithreas - create on DMs all the tools they want/need. --[
    if (GetIsDM(oEntering))
    {
      if (GetItemPossessedBy(oEntering, "dmfi_exploder") == OBJECT_INVALID)
             CreateItemOnObject("dmfi_exploder", oEntering); // DMFI master
      if (GetItemPossessedBy(oEntering, "obj_setname") == OBJECT_INVALID)
             CreateItemOnObject("obj_setname", oEntering); // Set Name widget
      if (GetItemPossessedBy(oEntering, "gs_item315") == OBJECT_INVALID)
             CreateItemOnObject("gs_item315", oEntering); // DM create encounter
      if (GetItemPossessedBy(oEntering, "gs_item110") == OBJECT_INVALID)
             CreateItemOnObject("gs_item110", oEntering); // DM PC actions
      if (GetItemPossessedBy(oEntering, "gs_item018") == OBJECT_INVALID)
             CreateItemOnObject("gs_item018", oEntering); // DM soulcatcher

      return;
    }
    // ]-- End edit.

    //check if cd key is banned
    object oBanishment = GetLocalObject(OBJECT_SELF, "GS_BANISHMENT");
    string sPlayer     = GetPCPlayerName(oEntering);
    string sCDKey      = GetPCPublicCDKey(oEntering, TRUE);
    string sIP         = GetPCIPAddress(oEntering);
    string sName       = GetName(oEntering);

    if (GetIsObjectValid(oBanishment) &&
        GetIsObjectValid(GetItemPossessedBy(oBanishment, "GS_BA_" + sCDKey)))
    {
        SendMessageToAllDMs(gsCMReplaceString(GS_T_16777425, sPlayer, sCDKey, sIP, sName));
        BootPC(oEntering);
        return;
    }

    //enter message
    SendMessageToAllDMs(gsCMReplaceString(GS_T_16777441, sPlayer, sCDKey, sIP, sName));

    AddJournalQuestEntry("GS_DIARY_001", 1, oEntering, FALSE);
    AddJournalQuestEntry("GS_DIARY_002", 1, oEntering, FALSE);

    if (GetLocalInt(oEntering, "GS_ENABLED"))
    {
        //restore health
        int nHealth = GetLocalInt(OBJECT_SELF, "GS_HEALTH_" + ObjectToString(oEntering));

        //remove polymorph
        gsFXRemoveEffect(oEntering, OBJECT_INVALID, EFFECT_TYPE_POLYMORPH);
        gsFXRemoveEffect(oEntering, OBJECT_INVALID, EFFECT_TYPE_TEMPORARY_HITPOINTS);

        gsCMSetHitPoints(nHealth, oEntering);

        SetLocalInt(oEntering, "GS_ENABLED", -1);
    }

    //open bank account
    gsFIOpenAccount(oEntering);

    //memorize class data
    gsPCMemorizeClassData(oEntering);

    //activity
    SetLocalInt(oEntering, "GS_ACTIVE", TRUE);

    //DMFI
    dmfiInitialize(oEntering);
}
