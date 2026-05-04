#include "gs_inc_text"
#include "nw_i0_spells"
#include "x2_i0_spells"
#include "x2_inc_spellhook"

void main()
{
    if (! X2PreSpellCastCode())         return;

    int nDuration    = GetCasterLevel(OBJECT_SELF);
    int nCasterLevel = nDuration / 3;
    int nMetaMagic   = GetMetaMagicFeat();

    if(nCasterLevel > 5)                nCasterLevel  = 5;
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration    *= 2;

    object oItem     = IPGetTargetedOrEquippedMeleeWeapon();

    if (GetIsObjectValid(oItem))
    {
        itemproperty ipProperty = GetFirstItemProperty(oItem);

        while (GetIsItemPropertyValid(ipProperty))
        {
            if (GetItemPropertyDurationType(ipProperty) == DURATION_TYPE_PERMANENT)
            {
                FloatingTextStringOnCreature(GS_T_16777330, OBJECT_SELF, FALSE);
                return;
            }

            ipProperty = GetNextItemProperty(oItem);
        }

        int nValue              = 0;
        ipProperty              = GetFirstItemProperty(oItem);

        while (GetIsItemPropertyValid(ipProperty))
        {
            if (GetItemPropertyDurationType(ipProperty) == DURATION_TYPE_TEMPORARY)
            {
                switch (GetItemPropertyType(ipProperty))
                {
                case ITEM_PROPERTY_ENHANCEMENT_BONUS:
                case ITEM_PROPERTY_HOLY_AVENGER:
                case ITEM_PROPERTY_KEEN:
                    RemoveItemProperty(oItem, ipProperty);
                    break;

                case ITEM_PROPERTY_ONHITCASTSPELL:
                    nValue = GetItemPropertySubType(ipProperty);

                    if (nValue == IP_CONST_ONHIT_CASTSPELL_ONHIT_DARKFIRE ||
                        nValue == IP_CONST_ONHIT_CASTSPELL_ONHIT_FIREDAMAGE)
                    {
                        RemoveItemProperty(oItem, ipProperty);
                    }

                    break;

                case ITEM_PROPERTY_VISUALEFFECT:
                    nValue = GetItemPropertySubType(ipProperty);

                    if (nValue == ITEM_VISUAL_FIRE)
                    {
                        RemoveItemProperty(oItem, ipProperty);
                    }

                    break;
                }
            }

            ipProperty = GetNextItemProperty(oItem);
        }

        object oPossessor = GetItemPossessor(oItem);
        float fDuration   = HoursToSeconds(nDuration);

        SignalEvent(oPossessor, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

        ApplyEffectToObject(
            DURATION_TYPE_INSTANT,
            EffectVisualEffect(VFX_IMP_SUPER_HEROISM),
            oPossessor);
        ApplyEffectToObject(
            DURATION_TYPE_TEMPORARY,
            EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
            oPossessor,
            fDuration);

        IPSafeAddItemProperty(
            oItem,
            ItemPropertyEnhancementBonus(nCasterLevel),
            fDuration,
            X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,
            FALSE,
            TRUE);
    }
    else
    {
        FloatingTextStrRefOnCreature(83615, OBJECT_SELF, FALSE);
    }
}
