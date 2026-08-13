#include "gs_inc_spell"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget   = GetSpellTargetObject();
    effect eEffect;
    int nSpell       = GetSpellId();

    //affection check
    if (! gsSPGetIsAffected(GS_SP_TYPE_BENEFICIAL, OBJECT_SELF, oTarget)) return;

    //raise event
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));

    //open conversation
    if(GetIsPC(oTarget) || GetIsDMPossessed(oTarget) || GetIsPossessedFamiliar(oTarget))
    {
        AssignCommand(oTarget, ActionStartConversation(OBJECT_SELF, "as_te_prasinos", TRUE, FALSE));
    }
}
