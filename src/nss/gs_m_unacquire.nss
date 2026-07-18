#include "gs_inc_fixture"
#include "gs_inc_flag"
#include "gs_inc_text"

const string GS_TEMPLATE_CORPSE = "gs_placeable017";

void main()
{
    object oLostBy = GetModuleItemLostBy();
    object oItem   = GetModuleItemLost();
    string sTag    = GetTag(oItem);

    //override transfer
    if (gsFLGetAreaFlag("OVERRIDE_TRANSFER", oLostBy) &&
        ! (GetIsDM(oLostBy) ||
           GetIsDM(GetItemPossessor(oItem))))
    {
        if (GetBaseItemType(oItem) == BASE_ITEM_TRAPKIT)
        {
            object oTrap = GetNearestTrapToObject(oLostBy, FALSE);
            if (GetTrapCreator(oTrap) == oLostBy) SetTrapDisabled(oTrap);
        }

        CopyItem(oItem, oLostBy, TRUE);
        DestroyObject(oItem);
        return;
    }

    //corpse
    if (sTag == "GS_CORPSE")
    {
        object oTarget = GetLocalObject(oItem, "GS_TARGET");

        if (! GetIsObjectValid(oTarget))
        {
            FloatingTextStringOnCreature(GS_T_16777456, oLostBy, FALSE);
            DestroyObject(oItem);
        }
        else if (! GetIsObjectValid(GetItemPossessor(oItem)))
        {
            object oCorpse = CreateObject(OBJECT_TYPE_PLACEABLE,
                                          GS_TEMPLATE_CORPSE,
                                          GetLocation(oLostBy));

            if (GetIsObjectValid(oCorpse))
            {
                FloatingTextStringOnCreature(GS_T_16777483, oTarget, FALSE);
                SetName(oCorpse, GetName(oItem));
                SetLocalObject(oCorpse, "GS_TARGET", oTarget);
                SetLocalObject(oTarget, "GS_CORPSE", oCorpse);
                SetLocalInt(oCorpse, "GS_GOLD", GetLocalInt(oItem, "GS_GOLD"));
                DestroyObject(oItem);
            }
        }

        return;
    }

    //fixture
    if (GetStringLeft(sTag, 6) == "GS_FX_")
    {
        if (! GetIsObjectValid(GetItemPossessor(oItem)))
        {
            vector vPosition    = GetPosition(oLostBy);
            float fFacing       = GetFacing(oLostBy);
            vPosition          += AngleToVector(fFacing);
            location lLocation  = Location(GetArea(oLostBy), vPosition, fFacing);
            sTag                = GetStringRight(sTag, GetStringLength(sTag) - 6);
            object oFixture     = CreateObject(OBJECT_TYPE_PLACEABLE, sTag, lLocation);
            SetName(oFixture, GetName(oItem));
            SetDescription(oFixture, GetDescription(oItem));
            SetLocalString(oFixture, "GS_FX_CREATOR", GetName(oLostBy));
            SetLocalString(oFixture, "GS_FX_ORIGINAL_TEMPLATE", GetLocalString(oItem, "GS_FX_ORIGINAL_TEMPLATE"));
            
            if(GetLocalString(oItem, "GS_FX_ID") == "")
            {
                SetLocalString(oFixture, "GS_FX_ID", GetRandomUUID());
            }
            else 
            {
                SetLocalString(oFixture, "GS_FX_ID", GetLocalString(oItem, "GS_FX_ID"));
            }

            if (GetIsObjectValid(oFixture) && (GetLocalString(oFixture, "GS_FX_ID") != ""))
            {
                gsFXSaveFixture(GetTag(GetArea(oFixture)), oFixture);
                DestroyObject(oItem);
            } else {
                DestroyObject(oFixture);
            }
        }

        return;
    }
}
