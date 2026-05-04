#include "gs_inc_ai"
#include "gs_inc_boss"
#include "gs_inc_common"
#include "gs_inc_encounter"
#include "gs_inc_event"
#include "gs_inc_flag"
#include "gs_inc_time"

const int GS_TIMEOUT = 7200; //2 hours

void main()
{
    SignalEvent(OBJECT_SELF, EventUserDefined(GS_EV_ON_SPAWN));

    SetAILevel(OBJECT_SELF, AI_LEVEL_LOW);

    //set mortality
    if ((GetLocalInt(OBJECT_SELF, "GS_STATIC") ||
         ! GetLocalInt(GetArea(OBJECT_SELF), "GS_ENABLED")) &&
        ! (gsENGetIsEncounterCreature() || gsBOGetIsBossCreature()))
    {
        SetIsDestroyable(FALSE, TRUE, TRUE);
    }
    else
    {
        gsFLSetFlag(GS_FL_MORTAL);
        SetIsDestroyable(TRUE, TRUE, FALSE);
    }

    //create special items
    int nRacialType = GetRacialType(OBJECT_SELF);

    switch (nRacialType)
    {
    case RACIAL_TYPE_ABERRATION:
        break;

    case RACIAL_TYPE_ANIMAL:
        switch (GetCreatureSize(OBJECT_SELF))
        {
        case CREATURE_SIZE_TINY:
        case CREATURE_SIZE_SMALL:
            SetDroppableFlag(CreateItemOnObject("gs_item895"), TRUE); //skin
            SetDroppableFlag(CreateItemOnObject("gs_item899"), TRUE); //meat
            break;

        case CREATURE_SIZE_MEDIUM:
            SetDroppableFlag(CreateItemOnObject("gs_item896"), TRUE); //skin
            SetDroppableFlag(CreateItemOnObject("gs_item898"), TRUE); //meat
            break;

        case CREATURE_SIZE_LARGE:
        case CREATURE_SIZE_HUGE:
            SetDroppableFlag(CreateItemOnObject("gs_item854"), TRUE); //skin
            SetDroppableFlag(CreateItemOnObject("gs_item897"), TRUE); //meat
            SetDroppableFlag(CreateItemOnObject("gs_item335"), TRUE); //sinew
            break;
        }
        break;

    case RACIAL_TYPE_BEAST:
        break;

    case RACIAL_TYPE_CONSTRUCT:
        break;

    case RACIAL_TYPE_DRAGON:
        SetDroppableFlag(CreateItemOnObject("gs_item824"), TRUE); //blood
        break;

    case RACIAL_TYPE_DWARF:
        break;

    case RACIAL_TYPE_ELEMENTAL:
        break;

    case RACIAL_TYPE_ELF:
        break;

    case RACIAL_TYPE_FEY:
        SetDroppableFlag(CreateItemOnObject("gs_item824"), TRUE); //blood
        break;

    case RACIAL_TYPE_GIANT:
        break;

    case RACIAL_TYPE_GNOME:
        break;

    case RACIAL_TYPE_HALFELF:
        break;

    case RACIAL_TYPE_HALFLING:
        break;

    case RACIAL_TYPE_HALFORC:
        break;

    case RACIAL_TYPE_HUMAN:
        break;

    case RACIAL_TYPE_HUMANOID_GOBLINOID:
        break;

    case RACIAL_TYPE_HUMANOID_MONSTROUS:
        break;

    case RACIAL_TYPE_HUMANOID_ORC:
        break;

    case RACIAL_TYPE_HUMANOID_REPTILIAN:
        break;

    case RACIAL_TYPE_INVALID:
        break;

    case RACIAL_TYPE_MAGICAL_BEAST:
        SetDroppableFlag(CreateItemOnObject("gs_item824"), TRUE); //blood
        break;

    case RACIAL_TYPE_OOZE:
        break;

    case RACIAL_TYPE_OUTSIDER:
        break;

    case RACIAL_TYPE_SHAPECHANGER:
        break;

    case RACIAL_TYPE_UNDEAD:
        break;

    case RACIAL_TYPE_VERMIN:
        break;
    }

    //create inventory
    if (GetAbilityScore(OBJECT_SELF, ABILITY_INTELLIGENCE) >= 6)
    {
        object oInventory = GetObjectByTag("GS_INVENTORY_" + IntToString(nRacialType));

        if (GetIsObjectValid(oInventory))
        {
            object oItem = GetFirstItemInInventory(oInventory);
            object oCopy = OBJECT_INVALID;

            if (GetIsObjectValid(oItem))
            {
                int nRating  = FloatToInt(pow(GetChallengeRating(OBJECT_SELF), 2.0));
                int nRandom  = 0;
                int nValue   = 0;

                GiveGoldToCreature(OBJECT_SELF, Random(nRating));
                nRating     *= 10;

                do
                {
                    nRandom = Random(100);

                    if (nRandom == 99 ||
                        (nRandom >= 90 &&
                         gsCMGetItemValue(oItem) <= nRating))
                    {
                        oCopy  = CopyItem(oItem, OBJECT_SELF);
                        nValue = gsCMGetItemValue(oItem);

                        if (GetIsObjectValid(oCopy))
                        {
                            SetIdentified(oCopy, nValue <= 100);
                            SetDroppableFlag(oCopy, TRUE);
                        }
                    }

                    oItem = GetNextItemInInventory(oInventory);
                }
                while (GetIsObjectValid(oItem));
            }
        }
    }
    else
    {
        gsFLSetFlag(GS_FL_DISABLE_CALL);
    }

    //listen
    SetListenPattern(OBJECT_SELF, "GS_AI_ATTACK_TARGET",         10000);
    SetListenPattern(OBJECT_SELF, "GS_AI_REQUEST_REINFORCEMENT", 10003);
    SetListening(OBJECT_SELF, TRUE);

    //set action matrix
    gsAISetActionMatrix(gsAIGetDefaultActionMatrix());

    //set random facing
    SetFacing(IntToFloat(Random(360)));

    SetLocalLocation(OBJECT_SELF, "GS_LOCATION", GetLocation(OBJECT_SELF));
    SetLocalInt(OBJECT_SELF, "GS_TIMEOUT", gsTIGetActualTimestamp() + GS_TIMEOUT);
}
