#include "gs_inc_flag"
#include "gs_inc_text"
#include "gs_inc_worship"
#include "gs_inc_spell"
#include "gs_inc_strack"
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
        gsSPTCast(OBJECT_SELF, nSpell, GetMetaMagicFeat());

        int nLevel = gsSPGetSpellLevel(nSpell, GetLastSpellCastClass());
        int nCurrentMana = GetLocalInt(OBJECT_SELF, "GS_CURRENT_MANA");
        int nResultingMana = nCurrentMana - (nLevel * 2);

        if (nResultingMana < 0){
                FloatingTextStringOnCreature(
                    gsCMReplaceString(GS_T_16777648, IntToString(nLevel)),
                    OBJECT_SELF,
                    FALSE);
                gsSPSetOverrideSpell();
                SetModuleOverrideSpellScriptFinished();
                return;
        }

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
        
        FloatingTextStringOnCreature(
                    gsCMReplaceString(GS_T_16777647, IntToString(nResultingMana)),
                    OBJECT_SELF,
                    FALSE);
        SetLocalInt(OBJECT_SELF, "GS_CURRENT_MANA", nResultingMana);
    }

    //spell information
    gsSPSetLastSpellHarmful(OBJECT_SELF, nHarmful);
    gsSPSetLastSpellTarget(OBJECT_SELF, oTarget);
    gsSPSetSpellCallback();
}
