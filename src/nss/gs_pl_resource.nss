#include "gs_inc_common"
#include "gs_inc_time"

const int GS_TIMEOUT = 10800; //3 hours
const int GS_LIMIT   =     5;

void main()
{
    string sTemplate = GetLocalString(OBJECT_SELF, "GS_TEMPLATE");
    if (sTemplate == "") return;
    int nChance      = GetLocalInt(OBJECT_SELF, "GS_CHANCE");
    if (nChance < 1)     return;
    int nTimestamp   = gsTIGetActualTimestamp();
    int nTimeout     = GetLocalInt(OBJECT_SELF, "GS_TIMEOUT");
    int nOpened      = ! GetIsObjectValid(GetLastKiller());

    if (nTimeout < nTimestamp)
    {
        if (! GetIsObjectValid(GetFirstItemInInventory()))
        {
            object oItem = OBJECT_INVALID;
            int nNth     = 0;

            for (; nNth < GS_LIMIT; nNth++)
            {
                if (nChance + Random(100) >= 100)
                {
                    oItem = CreateItemOnObject(sTemplate);
                    SetIdentified(oItem, TRUE);
                    SetStolenFlag(oItem, FALSE);
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

    if (! nOpened) gsCMCreateRecreator(nTimeout);
}
