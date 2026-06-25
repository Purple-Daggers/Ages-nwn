#include "gs_inc_flag"
#include "gs_inc_text"
#include "gs_inc_worship"
#include "gs_inc_spell"
#include "gs_inc_strack"
#include "gs_inc_state"
#include "x2_inc_switches"

void main()
{
    if (GetIsDM(OBJECT_SELF))                return;
    if (GetIsDMPossessed(OBJECT_SELF))       return;

    //spelltracker override
    if (GetLocalInt(OBJECT_SELF, "GS_SPT_OVERRIDE"))
    {
        gsSPSetOverrideSpell();
        SetModuleOverrideSpellScriptFinished();
        return;
    }

    //area flag
    if (gsFLGetAreaFlag("OVERRIDE_MAGIC"))
    {
        if (GetIsPC(OBJECT_SELF)) FloatingTextStringOnCreature(GS_T_16777445, OBJECT_SELF, FALSE);
        gsSPSetOverrideSpell();
        SetModuleOverrideSpellScriptFinished();
        return;
    }

    if (! GetIsPC(OBJECT_SELF))              return;
    if (GetIsPossessedFamiliar(OBJECT_SELF)) return;

    object oTarget   = GetSpellTargetObject();
    location lTarget = GetSpellTargetLocation();
    int nSpell       = GetSpellId();
    int nHarmful     = Get2DAString("spells", "HostileSetting", nSpell) == "1";

    //set target of harmful spell to hostile
    if (GetIsObjectValid(oTarget))
    {
        if (nHarmful) SetPCDislike(OBJECT_SELF, oTarget);
    }
    else
    {
        object oCreature = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE);
        oTarget          = oCreature;

        if (nHarmful)
        {
            while (GetIsObjectValid(oCreature))
            {
                SetPCDislike(OBJECT_SELF, oCreature);
                oCreature = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE);
            }
        }
    }

    if (! GetIsObjectValid(GetSpellCastItem()))
    {
        //spelltracker
        int nMetaMagic = GetMetaMagicFeat();
        gsSPTCast(OBJECT_SELF, nSpell, nMetaMagic);
        int nClass = GetLastSpellCastClass();
        int nLevel = gsSPGetSpellLevel(nSpell, nClass);
        int nCurrentMana = GetLocalInt(OBJECT_SELF, "GS_CURRENT_MANA");
        int nResultingMana = nCurrentMana - (nLevel * 2) - (gsSPGetMetaMagicLevel(nMetaMagic) * 2);

        if (nResultingMana < 0){
                FloatingTextStringOnCreature(
                    gsCMReplaceString(GS_T_16777648, IntToString(nLevel)),
                    OBJECT_SELF,
                    FALSE);
                gsSPSetOverrideSpell();
                SetModuleOverrideSpellScriptFinished();
                ReadySpellLevel(OBJECT_SELF, nLevel, CLASS_TYPE_INVALID, 255);
                return;
        }

        if (nLevel > 5)
        {
            int nCurrentExhaustion = GetLocalInt(OBJECT_SELF, "GS_SPELL_EXHAUSTION_CURRENT");
            int nMaximumExhaustion = GetAbilityModifier(ABILITY_CONSTITUTION, OBJECT_SELF);

            if (nCurrentExhaustion >= nMaximumExhaustion){
                if (FortitudeSave(OBJECT_SELF, 10 + nCurrentExhaustion) == 0)
                {
                    gsSTAdjustState(GS_ST_REST,  -2.083);
                    DelayCommand(0.6, FloatingTextStringOnCreature(
                                      GS_T_16777649,
                                      OBJECT_SELF,
                                      FALSE));
                }
            }
            SetLocalInt(OBJECT_SELF, "GS_SPELL_EXHAUSTION_CURRENT", nCurrentExhaustion + 1);
        }

        int nSurgeChance = 0;
        switch (nClass){
            case CLASS_TYPE_CLERIC:
                nSurgeChance = 1;
            break;
            case CLASS_TYPE_DRUID:
                nSurgeChance = 1;
            break;
            case CLASS_TYPE_WIZARD:
                nSurgeChance = 2;
            break;
            case CLASS_TYPE_BARD:
                nSurgeChance = 2;
            break;
            case CLASS_TYPE_PALADIN:
                nSurgeChance = 2;
            break;
            case CLASS_TYPE_SORCERER:
                nSurgeChance = 20;
            break;
            default:
                nSurgeChance = 0;
            break;
        }

        if(nMetaMagic != METAMAGIC_NONE){
            nSurgeChance *= 2;
        }

        if (d100(1) <= nSurgeChance){
            DelayCommand(0.8, gsSPMagicSurge(OBJECT_SELF, oTarget, lTarget));
        }
        /*
        if (nLevel >= 7)
        {
            //deity
            string sDeity = GetDeity(OBJECT_SELF);

            if (sDeity == "")
            {
                FloatingTextStringOnCreature(
                    gsCMReplaceString(GS_T_16777289, IntToString(nLevel)),
                    OBJECT_SELF,
                    FALSE);
                gsSPSetOverrideSpell();
                SetModuleOverrideSpellScriptFinished();
                return;
            }

            if (! gsWOGetPresence(sDeity))
            {
                FloatingTextStringOnCreature(
                    gsCMReplaceString(GS_T_16777290, sDeity, IntToString(nLevel)),
                    OBJECT_SELF,
                    FALSE);
                gsSPSetOverrideSpell();
                SetModuleOverrideSpellScriptFinished();
                return;
            }

            int nPower    = gsWOGetPower(sDeity);
            int nRequired = 0;

            switch (nLevel)
            {
            case 7: nRequired = 1;
            case 8: nRequired = 2;
            case 9: nRequired = 4;
            }

            if (nPower >= nRequired)
            {
                gsWOAdjustPower(sDeity, -nRequired);
            }
            else
            {
                FloatingTextStringOnCreature(
                    gsCMReplaceString(GS_T_16777447, sDeity, IntToString(nLevel)),
                    OBJECT_SELF,
                    FALSE);
                gsSPSetOverrideSpell();
                SetModuleOverrideSpellScriptFinished();
                return;
            }
        }
        */
        
        FloatingTextStringOnCreature(
                    gsCMReplaceString(GS_T_16777647, IntToString(nResultingMana)),
                    OBJECT_SELF,
                    FALSE);
        SetLocalInt(OBJECT_SELF, "GS_CURRENT_MANA", nResultingMana);
        ReadySpellLevel(OBJECT_SELF, nLevel + gsSPGetMetaMagicLevel(nMetaMagic), CLASS_TYPE_INVALID, 255);
    }
    else if(GetBaseItemType(GetSpellCastItem()) == BASE_ITEM_POTIONS || GetBaseItemType(GetSpellCastItem()) == BASE_ITEM_ENCHANTED_POTION)
    {
        float fConstitution = IntToFloat(GetAbilityScore(OBJECT_SELF, ABILITY_CONSTITUTION));
        float fSobriety = -250.0f / fConstitution;
        gsSTAdjustState(GS_ST_SOBRIETY,  fSobriety);
    }

    //spell information
    gsSPSetLastSpellHarmful(OBJECT_SELF, nHarmful);
    gsSPSetLastSpellTarget(OBJECT_SELF, oTarget);
    gsSPSetSpellCallback();
}