#include "gs_inc_common"
#include "gs_inc_time"

const int GS_TIMEOUT            = 7200; //TIME UPDATE: 2 hours
const int GS_LIMIT_GOLD         =  2000;
const int GS_LIMIT_VALUE_LOW    =  2500;
const int GS_LIMIT_VALUE_MEDIUM =  7500;
const int GS_LIMIT_VALUE_HIGH   = 22500;
const int GS_LIMIT_ITEM_LOW     =     2;
const int GS_LIMIT_ITEM_MEDIUM  =     3;
const int GS_LIMIT_ITEM_HIGH    =     4;

void main()
{
    //timeout
    int nTimestamp = gsTIGetActualTimestamp();
    int nTimeout   = GetLocalInt(OBJECT_SELF, "GS_TIMEOUT");
    int nOpened    = ! GetIsObjectValid(GetLastKiller());

    if (nTimeout < nTimestamp)
    {
        if (! GetIsObjectValid(GetFirstItemInInventory()))
        {
            string sTag          = GetTag(OBJECT_SELF);
            string sTagInventory = sTag;
            int nLimitValue      = 0;
            int nLimitItem       = 0;
            int nNth             = GetStringLength(sTag);

            //determine item value range
            if (GetStringRight(sTag, 4) == "_LOW")
            {
                nLimitValue   = GS_LIMIT_VALUE_LOW;
                nLimitItem    = GS_LIMIT_ITEM_LOW;
                sTagInventory = GetStringLeft(sTag, nNth - 4);
            }
            else if (GetStringRight(sTag, 7) == "_MEDIUM")
            {
                nLimitValue   = GS_LIMIT_VALUE_MEDIUM;
                nLimitItem    = GS_LIMIT_ITEM_MEDIUM;
                sTagInventory = GetStringLeft(sTag, nNth - 7);
            }
            else if (GetStringRight(sTag, 5) == "_HIGH")
            {
                nLimitValue   = GS_LIMIT_VALUE_HIGH;
                nLimitItem    = GS_LIMIT_ITEM_HIGH;
                sTagInventory = GetStringLeft(sTag, nNth - 5);
            }

            nNth                 = GetStringLength(sTagInventory);
            sTagInventory        = "GS_INVENTORY_" + GetStringRight(sTagInventory, nNth - 3);
            object oInventory    = GetObjectByTag(sTagInventory);

            if (GetIsObjectValid(oInventory))
            {
                object oItem = GetFirstItemInInventory(oInventory);

                if (GetIsObjectValid(oItem))
                {
                    int nGold  = 0;
                    int nValue = 0;
                    int nCount = 0;

                    //generate item list
                    do
                    {
                        nValue = gsCMGetItemValue(oItem);

                        if (nValue <= nLimitValue)
                        {
                            nGold = (nGold + nValue) / 2;

                            SetLocalObject(
                                oInventory,
                                "GS_PL_INVENTORY_ITEM_" + IntToString(nCount++),
                                oItem);
                        }

                        oItem = GetNextItemInInventory(oInventory);
                    }
                    while (GetIsObjectValid(oItem));

                    //create item
                    if (nOpened)
                    {
                        object oCopy   = OBJECT_INVALID;
                        int nItemLimit = Random(nLimitItem + 1);

                        for (nNth = 0; nNth < nItemLimit; nNth++)
                        {
                            oItem = GetLocalObject(
                                oInventory,
                                "GS_PL_INVENTORY_ITEM_" + IntToString(Random(nCount)));
                            oCopy = CopyItem(oItem, OBJECT_SELF);

                            if (GetIsObjectValid(oCopy))
                            {
                                SetIdentified(oCopy, gsCMGetItemValue(oCopy) <= 100);
                                SetStolenFlag(oCopy, FALSE);
                            }
                        }
                    }

                    //create gold
                    nGold /= 10;
                    if (nGold > GS_LIMIT_GOLD) nGold = GS_LIMIT_GOLD;
                    gsCMCreateGold(Random(nGold));
                }
            }
        }

        if (nOpened)
        {
            nTimestamp += GS_TIMEOUT;
            SetLocalInt(OBJECT_SELF, "GS_TIMEOUT", nTimestamp);
            return;
        }
    }

    if (! nOpened)
    {
        string sTag = GetTag(OBJECT_SELF);

        if (! nTimeout) nTimeout = nTimestamp + gsTIGetTimestamp(0, 0, 0, GS_TIMEOUT);

        if (sTag == "GS_TREASURE_LOW")
            gsCMCreateRecreatorByType(GS_CM_TEMPLATE_TYPE_TREASURE_LOW,    nTimeout);
        else if (sTag == "GS_TREASURE_MEDIUM")
            gsCMCreateRecreatorByType(GS_CM_TEMPLATE_TYPE_TREASURE_MEDIUM, nTimeout);
        else if (sTag == "GS_TREASURE_HIGH")
            gsCMCreateRecreatorByType(GS_CM_TEMPLATE_TYPE_TREASURE_HIGH,   nTimeout);
        else if (sTag == "GS_WEAPON_LOW")
            gsCMCreateRecreatorByType(GS_CM_TEMPLATE_TYPE_WEAPON_LOW,      nTimeout);
        else if (sTag == "GS_WEAPON_MEDIUM")
            gsCMCreateRecreatorByType(GS_CM_TEMPLATE_TYPE_WEAPON_MEDIUM,   nTimeout);
        else if (sTag == "GS_WEAPON_HIGH")
            gsCMCreateRecreatorByType(GS_CM_TEMPLATE_TYPE_WEAPON_HIGH,     nTimeout);
        else if (sTag == "GS_ARMOR_LOW")
            gsCMCreateRecreatorByType(GS_CM_TEMPLATE_TYPE_ARMOR_LOW,       nTimeout);
        else if (sTag == "GS_ARMOR_MEDIUM")
            gsCMCreateRecreatorByType(GS_CM_TEMPLATE_TYPE_ARMOR_MEDIUM,    nTimeout);
        else if (sTag == "GS_ARMOR_HIGH")
            gsCMCreateRecreatorByType(GS_CM_TEMPLATE_TYPE_ARMOR_HIGH,      nTimeout);
        else
            gsCMCreateRecreator(nTimeout);
    }
}
