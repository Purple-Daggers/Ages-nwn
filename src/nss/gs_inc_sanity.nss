/* SANITY Library by Gigaschatten */

//void main() {}

int gsSACombatProtectionNth = 0;
int gsSABreachableSpellNth  = 0;

//return TRUE if oCreature has spell effect that can be removed by spell breach
int gsSAGetHasBreachableSpell(object oCreature = OBJECT_SELF);
//return first spell that can be removed by spell breach
int gsSAGetFirstBreachableSpell();
//return next spell that can be removed by spell breach
int gsSAGetNextBreachableSpell();
//return positive or negative integer reflecting effects on oCreature
int gsSAGetEffectBalance(object oCreature = OBJECT_SELF);

int gsSAGetHasBreachableSpell(object oCreature = OBJECT_SELF)
{
    int nSpell = gsSAGetFirstBreachableSpell();

    while (nSpell != -1)
    {
        if (GetHasSpellEffect(nSpell, oCreature)) return TRUE;
        nSpell = gsSAGetNextBreachableSpell();
    }

    return FALSE;
}
//----------------------------------------------------------------
int gsSAGetFirstBreachableSpell()
{
    gsSABreachableSpellNth = 0;
    return gsSAGetNextBreachableSpell();
}
//----------------------------------------------------------------
int gsSAGetNextBreachableSpell()
{
    switch (++gsSABreachableSpellNth)
    {
    case  1: return SPELL_GREATER_SPELL_MANTLE;
    case  2: return SPELL_PREMONITION;
    case  3: return SPELL_SPELL_MANTLE;
    case  4: return SPELL_SHADOW_SHIELD;
    case  5: return SPELL_GREATER_STONESKIN;
    case  6: return SPELL_ETHEREAL_VISAGE;
    case  7: return SPELL_GLOBE_OF_INVULNERABILITY;
    case  8: return SPELL_ENERGY_BUFFER;
    case  9: return SPELL_ETHEREALNESS;
    case 10: return SPELL_MINOR_GLOBE_OF_INVULNERABILITY;
    case 11: return SPELL_SPELL_RESISTANCE;
    case 12: return SPELL_STONESKIN;
    case 13: return SPELL_LESSER_SPELL_MANTLE;
    case 14: return SPELL_MESTILS_ACID_SHEATH;
    case 15: return SPELL_MIND_BLANK;
    case 16: return SPELL_ELEMENTAL_SHIELD;
    case 17: return SPELL_PROTECTION_FROM_SPELLS;
    case 18: return SPELL_PROTECTION_FROM_ELEMENTS;
    case 19: return SPELL_RESIST_ELEMENTS;
    case 20: return SPELL_DEATH_ARMOR;
    case 21: return SPELL_GHOSTLY_VISAGE;
    case 22: return SPELL_ENDURE_ELEMENTS;
    case 23: return SPELL_SHADOW_SHIELD;
    case 24: return SPELL_SHADOW_CONJURATION_MAGE_ARMOR;
    case 25: return SPELL_NEGATIVE_ENERGY_PROTECTION;
    case 26: return SPELL_SANCTUARY;
    case 27: return SPELL_MAGE_ARMOR;
    case 28: return SPELL_STONE_BONES;
    case 29: return SPELL_SHIELD;
    case 30: return SPELL_SHIELD_OF_FAITH;
    case 31: return SPELL_LESSER_MIND_BLANK;
    case 32: return SPELL_IRONGUTS;
    case 33: return SPELL_RESISTANCE;
    }

    return -1;
}
//----------------------------------------------------------------
int gsSAGetEffectBalance(object oCreature = OBJECT_SELF)
{
    effect eEffect = GetFirstEffect(oCreature);
    int nEnemy     = FALSE;
    int nValue     = 0;

    while (GetIsEffectValid(eEffect))
    {
        if (GetEffectSpellId(eEffect) != -1 &&
            GetEffectSubType(eEffect) == SUBTYPE_MAGICAL &&
            GetEffectDurationType(eEffect) != DURATION_TYPE_INSTANT)
        {
            switch (GetEffectType(eEffect))
            {
            case EFFECT_TYPE_ABILITY_DECREASE:          nValue--; break;
            case EFFECT_TYPE_ABILITY_INCREASE:          nValue++; break;
            case EFFECT_TYPE_AC_DECREASE:               nValue--; break;
            case EFFECT_TYPE_AC_INCREASE:               nValue++; break;
            case EFFECT_TYPE_ARCANE_SPELL_FAILURE:      nValue--; break;
            case EFFECT_TYPE_AREA_OF_EFFECT:                      break;
            case EFFECT_TYPE_ATTACK_DECREASE:           nValue--; break;
            case EFFECT_TYPE_ATTACK_INCREASE:           nValue++; break;
            case EFFECT_TYPE_BEAM:                                break;
            case EFFECT_TYPE_BLINDNESS:                 nValue--; break;
            case EFFECT_TYPE_CHARMED:                   nValue--; break;
            case EFFECT_TYPE_CONCEALMENT:               nValue++; break;
            case EFFECT_TYPE_CONFUSED:                  nValue--; break;
            case EFFECT_TYPE_CURSE:                     nValue--; break;
            case EFFECT_TYPE_CUTSCENE_PARALYZE:                   break;
            case EFFECT_TYPE_CUTSCENEGHOST:                       break;
            case EFFECT_TYPE_CUTSCENEIMMOBILIZE:                  break;
            case EFFECT_TYPE_DAMAGE_DECREASE:           nValue--; break;
            case EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE:  nValue--; break;
            case EFFECT_TYPE_DAMAGE_IMMUNITY_INCREASE:  nValue++; break;
            case EFFECT_TYPE_DAMAGE_INCREASE:           nValue++; break;
            case EFFECT_TYPE_DAMAGE_REDUCTION:          nValue++; break;
            case EFFECT_TYPE_DAMAGE_RESISTANCE:         nValue++; break;
            case EFFECT_TYPE_DARKNESS:                            break;
            case EFFECT_TYPE_DAZED:                     nValue--; break;
            case EFFECT_TYPE_DEAF:                      nValue--; break;
            case EFFECT_TYPE_DISAPPEARAPPEAR:                     break;
            case EFFECT_TYPE_DISEASE:                   nValue--; break;
            case EFFECT_TYPE_DISPELMAGICALL:                      break;
            case EFFECT_TYPE_DISPELMAGICBEST:                     break;
            case EFFECT_TYPE_DOMINATED:                 nValue--; break;
            case EFFECT_TYPE_ELEMENTALSHIELD:           nValue++; break;
            case EFFECT_TYPE_ENEMY_ATTACK_BONUS:                  break;
            case EFFECT_TYPE_ENTANGLE:                  nValue--; break;
            case EFFECT_TYPE_ETHEREAL:                  nValue++; break;
            case EFFECT_TYPE_FRIGHTENED:                nValue--; break;
            case EFFECT_TYPE_HASTE:                     nValue++; break;
            case EFFECT_TYPE_IMMUNITY:                  nValue++; break;
            case EFFECT_TYPE_IMPROVEDINVISIBILITY:      nValue++; break;
            case EFFECT_TYPE_INVISIBILITY:              nValue++; break;
            case EFFECT_TYPE_INVULNERABLE:              nValue++; break;
            case EFFECT_TYPE_MISS_CHANCE:               nValue--; break;
            case EFFECT_TYPE_MOVEMENT_SPEED_DECREASE:   nValue--; break;
            case EFFECT_TYPE_MOVEMENT_SPEED_INCREASE:   nValue++; break;
            case EFFECT_TYPE_NEGATIVELEVEL:             nValue--; break;
            case EFFECT_TYPE_PARALYZE:                  nValue--; break;
            case EFFECT_TYPE_PETRIFY:                   nValue--; break;
            case EFFECT_TYPE_POISON:                    nValue--; break;
            case EFFECT_TYPE_POLYMORPH:                 nValue++; break;
            case EFFECT_TYPE_REGENERATE:                nValue++; break;
            case EFFECT_TYPE_RESURRECTION:                        break;
            case EFFECT_TYPE_SANCTUARY:                 nValue++; break;
            case EFFECT_TYPE_SAVING_THROW_DECREASE:     nValue--; break;
            case EFFECT_TYPE_SAVING_THROW_INCREASE:     nValue++; break;
            case EFFECT_TYPE_SEEINVISIBLE:              nValue++; break;
            case EFFECT_TYPE_SILENCE:                   nValue--; break;
            case EFFECT_TYPE_SKILL_DECREASE:            nValue--; break;
            case EFFECT_TYPE_SKILL_INCREASE:            nValue++; break;
            case EFFECT_TYPE_SLEEP:                     nValue--; break;
            case EFFECT_TYPE_SLOW:                      nValue--; break;
            case EFFECT_TYPE_SPELL_FAILURE:             nValue--; break;
            case EFFECT_TYPE_SPELL_IMMUNITY:            nValue++; break;
            case EFFECT_TYPE_SPELL_RESISTANCE_DECREASE: nValue--; break;
            case EFFECT_TYPE_SPELL_RESISTANCE_INCREASE: nValue++; break;
            case EFFECT_TYPE_SPELLLEVELABSORPTION:      nValue++; break;
            case EFFECT_TYPE_STUNNED:                   nValue--; break;
            case EFFECT_TYPE_SWARM:                               break;
            case EFFECT_TYPE_TEMPORARY_HITPOINTS:       nValue++; break;
            case EFFECT_TYPE_TRUESEEING:                nValue++; break;
            case EFFECT_TYPE_TURN_RESISTANCE_DECREASE:  nValue--; break;
            case EFFECT_TYPE_TURN_RESISTANCE_INCREASE:  nValue++; break;
            case EFFECT_TYPE_TURNED:                    nValue--; break;
            case EFFECT_TYPE_ULTRAVISION:               nValue++; break;
            case EFFECT_TYPE_VISUALEFFECT:                        break;
            }

            eEffect = GetNextEffect(oCreature);
        }
    }

    return nValue;
}
