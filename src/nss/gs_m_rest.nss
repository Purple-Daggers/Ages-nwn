#include "gs_inc_common"
#include "gs_inc_encounter"
#include "gs_inc_flag"
#include "gs_inc_state"
#include "gs_inc_strack"
#include "gs_inc_text"

void gsRestMonitor(int nEffect = FALSE)
{
    if (GetCurrentAction() == ACTION_REST)
    {
        gsSTAdjustState(GS_ST_REST, 5.0);
        gsSTAdjustState(GS_ST_SOBRIETY, 5.0);
        gsSTAdjustState(GS_ST_MANA, 5.0f);

        SetLocalInt(OBJECT_SELF, "GS_SPELL_EXHAUSTION_CURRENT", 0);

        /*if (nEffect)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                EffectVisualEffect(VFX_IMP_SLEEP),
                                OBJECT_SELF);
        }*/

        DelayCommand(2.0, gsRestMonitor(! nEffect));
    }
    else
    {
        //FadeFromBlack(OBJECT_SELF);
    }
}
//----------------------------------------------------------------
void gsAmbush()
{
    if (GetCurrentAction() == ACTION_REST)
    {
        int nChance = gsENGetEncounterChance(GetArea(OBJECT_SELF));

        if (nChance > 0 &&
            nChance + Random(100) >= 100)
        {
            location lLocation = GetLocation(OBJECT_SELF);

            //check for guards
            object oCreature   = GetFirstObjectInShape(SHAPE_SPHERE, 20.0, lLocation, TRUE);

            while (GetIsObjectValid(oCreature))
            {
                if (! GetIsDM(oCreature) &&
                    ! GetPlotFlag(oCreature) &&
                    ! GetIsDead(oCreature) &&
                    GetCurrentAction(oCreature) != ACTION_REST &&
                    (GetAssociateType(oCreature) == ASSOCIATE_TYPE_NONE ||
                     GetCurrentAction(GetMaster(oCreature)) != ACTION_REST))
                {
                    return;
                }

                oCreature = GetNextObjectInShape(SHAPE_SPHERE, 20.0, lLocation, TRUE);
            }

            //spawn
            FloatingTextStringOnCreature(GS_T_16777327, OBJECT_SELF);
            gsENSpawnAtLocation(IntToFloat(GetHitDice(OBJECT_SELF)),
                                GS_EN_LIMIT_SPAWN,
                                GetLocation(OBJECT_SELF),
                                7.5);
        }
    }
}
//----------------------------------------------------------------
void main()
{
    object oRested = GetLastPCRested();
    object oArmor  = GetItemInSlot(INVENTORY_SLOT_CHEST, oRested);
    int nLimit     = -1;

    switch (GetLastRestEventType())
    {
    case REST_EVENTTYPE_REST_STARTED:

        //dm
        if (GetIsDM(oRested))
        {
            ForceRest(oRested);
            AssignCommand(oRested, ClearAllActions());
            break;
        }

        //armor
        if (GetIsObjectValid(oArmor) &&
            gsCMGetItemBaseAC(oArmor) >= 4)
        {
            AssignCommand(oRested, ClearAllActions());
            FloatingTextStringOnCreature(GS_T_16777328, oRested, FALSE);
            break;
        }

        //reduced exhaustion limit for spellcaster
        if (! gsFLGetAreaFlag("REST", oRested))
            nLimit = 50 +
                     (GetLevelByClass(CLASS_TYPE_CLERIC, oRested) / 2 +
                      GetLevelByClass(CLASS_TYPE_SORCERER, oRested) +
                      GetLevelByClass(CLASS_TYPE_WIZARD, oRested)) *
                     25 /
                     GetHitDice(oRested);

        //exhaustion limit
        if (nLimit == -1 ||
            FloatToInt(gsSTGetState(GS_ST_REST, oRested)) < nLimit)
        {
            float fDelay = IntToFloat(5000 + Random(4000 + GetHitDice(oRested) * 500)) / 1000.0;

            //FadeToBlack(oRested);
            AssignCommand(oRested, gsRestMonitor());
            AssignCommand(oRested, DelayCommand(fDelay, gsAmbush()));
        }
        else
        {
            AssignCommand(oRested, ClearAllActions());
            FloatingTextStringOnCreature(
                gsCMReplaceString(GS_T_16777329, IntToString(nLimit)),
                oRested,
                FALSE);
        }
        break;

    case REST_EVENTTYPE_REST_CANCELLED:
        break;

    case REST_EVENTTYPE_REST_FINISHED:

        //spelltracker
        if (! GetIsDM(oRested) && ! GetIsDMPossessed(oRested)) gsSPTReset(oRested);
        break;
    }
}
