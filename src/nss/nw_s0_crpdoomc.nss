#include "gs_inc_spell"

void main()
{
    object oCaster    = GetAreaOfEffectCreator();
    object oTarget    = GetFirstInPersistentObject();
    effect eEffect;
    int nSpell        = gsSPGetSpellID();
    int nCasterLevel  = GetCasterLevel(oCaster);
    if (nCasterLevel > 20) nCasterLevel = 20;
    int nValue        = 0;
    string sString    = "GS_SP_" + IntToString(nSpell) + "_";
    int nDamage       = GetLocalInt(OBJECT_SELF, sString + "DAMAGE");
    int nRound        = GetLocalInt(OBJECT_SELF, sString + "ROUND") + 1;
    int nCount        = GetLocalInt(OBJECT_SELF, sString + "COUNT") + 1;

    //increase damage
    nCasterLevel     /= 2;
    nCount           += nRound;

    if (nCasterLevel < 1)      nCasterLevel = 1;
    if (nCount > nCasterLevel) nCount       = nCasterLevel;

    while (GetIsObjectValid(oTarget))
    {
        //affection check
        if (gsSPGetIsAffected(GS_SP_TYPE_HARMFUL, oCaster, oTarget))
        {
            //raise event
            SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpell));

            //damage
            nValue   = d6(nCount);
            nDamage += nValue;

            if (nDamage > 1000) nValue = nDamage - 1000;

            //apply
            eEffect  = EffectDamage(nValue, DAMAGE_TYPE_PIERCING);
            DelayCommand(gsSPGetRandomDelay(), gsSPApplyEffect(oTarget, eEffect, nSpell));

            if (nDamage >= 1000)
            {
                DestroyObject(OBJECT_SELF);
                return;
            }
        }

        oTarget = GetNextInPersistentObject();
    }

    SetLocalInt(OBJECT_SELF, sString + "DAMAGE", nDamage);
    SetLocalInt(OBJECT_SELF, sString + "ROUND",  nRound);
    SetLocalInt(OBJECT_SELF, sString + "COUNT",  nCount - 1);
}
