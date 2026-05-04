#include "gs_inc_spell"

void main()
{
    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();
    effect eEffect;
    int nSpell     = gsSPGetSpellID();
    int nValue     = 0;
    string sString = "GS_SP_" + IntToString(nSpell) + "_";
    int nDamage    = GetLocalInt(OBJECT_SELF, sString + "DAMAGE");
    int nCount     = GetLocalInt(OBJECT_SELF, sString + "COUNT") + 1;

    //affection check
    if (! gsSPGetIsAffected(GS_SP_TYPE_HARMFUL, oCaster, oTarget)) return;

    //raise event
    SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpell));

    //damage
    nValue   = d6(nCount);
    nDamage += nValue;

    if (nDamage > 1000) nValue = nDamage - 1000;

    //apply
    eEffect  = EffectDamage(nValue, DAMAGE_TYPE_PIERCING);
    gsSPApplyEffect(oTarget, eEffect, nSpell);

    if (nDamage >= 1000)
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

    SetLocalInt(OBJECT_SELF, sString + "DAMAGE", nDamage);
}
