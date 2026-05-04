#include "gs_inc_common"

void main()
{
    object oTarget = GetLocalObject(OBJECT_SELF, "GS_TARGET");

    if (GetIsObjectValid(oTarget))
    {
        int nSpell = GetLastSpell();

        switch (nSpell)
        {
        case SPELL_RAISE_DEAD:
        case SPELL_RESURRECTION:
            gsCMCreateGold(GetLocalInt(OBJECT_SELF, "GS_GOLD"), oTarget);
            gsCMSetHitPoints(nSpell == SPELL_RAISE_DEAD ? 1 : GetMaxHitPoints(oTarget), oTarget);
            gsCMTeleportToLocation(oTarget, GetLocation(OBJECT_SELF), VFX_IMP_RAISE_DEAD);
            DestroyObject(OBJECT_SELF);
        }
    }
}
