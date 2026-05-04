/* CHAIN Library by Gigaschatten */

#include "gs_inc_effect"
#include "gs_inc_text"

//void main() {}

//return TRUE if oChain is put on a target
int gsCHGetHasTarget(object oChain);
//return target that oChain is put on
object gsCHGetTarget(object oChain);
//return TRUE if oTarget is chained up
int gsCHGetHasChain(object oTarget = OBJECT_SELF);
//return chain that oTarget is put in
object gsCHGetChain(object oTarget = OBJECT_SELF);
//put oChain on oTarget
void gsCHApplyChain(object oChain, object oTarget);
//internally used
void _gsCHApplyChain(object oPossessor);
//remove oChain from its target
void gsCHRemoveChain(object oChain);

int gsCHGetHasTarget(object oChain)
{
    return GetIsObjectValid(gsCHGetTarget(oChain));
}
//----------------------------------------------------------------
object gsCHGetTarget(object oChain)
{
    return GetLocalObject(oChain, "GS_CH_TARGET");
}
//----------------------------------------------------------------
int gsCHGetHasChain(object oTarget = OBJECT_SELF)
{
    return GetIsObjectValid(gsCHGetChain(oTarget));
}
//----------------------------------------------------------------
object gsCHGetChain(object oTarget = OBJECT_SELF)
{
    return GetLocalObject(oTarget, "GS_CH_CHAIN");
}
//----------------------------------------------------------------
void gsCHApplyChain(object oChain, object oTarget)
{
    if (! GetIsObjectValid(oChain))                        return;
    object oPossessor = GetItemPossessor(oChain);
    if (! GetIsObjectValid(oPossessor))                    return;
    if (GetObjectType(oPossessor) != OBJECT_TYPE_CREATURE) return;
    if (GetIsDead(oPossessor))                             return;
    if (! GetIsObjectValid(oTarget))                       return;
    if (GetObjectType(oTarget) != OBJECT_TYPE_CREATURE)    return;
    if (GetIsDM(oTarget))                                  return;
    if (GetIsDead(oTarget))                                return;
    if (oPossessor == oTarget)                             return;
    if (gsCHGetHasTarget(oChain))                          return;
    if (gsCHGetHasChain(oTarget))                          return;

    AssignCommand(oTarget, ClearAllActions(TRUE));
    AssignCommand(oTarget, _gsCHApplyChain(oPossessor));

    SendMessageToPC(oTarget, GS_T_16777338);
    AssignCommand(oChain,
        ApplyEffectToObject(
            DURATION_TYPE_PERMANENT,
            ExtraordinaryEffect(
                EffectBeam(VFX_BEAM_CHAIN, oPossessor, BODY_NODE_CHEST)),
            oTarget));

    SetLocalObject(oTarget, "GS_CH_CHAIN", oChain);
    SetLocalObject(oChain, "GS_CH_TARGET", oTarget);
}
//----------------------------------------------------------------
void _gsCHApplyChain(object oPossessor)
{
    if (! GetIsObjectValid(oPossessor) ||
        GetIsDead(oPossessor))
    {
        gsCHRemoveChain(gsCHGetChain());
        return;
    }

    SetCommandable(TRUE);
    if (GetArea(OBJECT_SELF) != GetArea(oPossessor))
        ActionJumpToObject(oPossessor);
    else if (GetDistanceToObject(oPossessor) > 3.0)
        ActionForceMoveToObject(oPossessor, TRUE, 2.0, 12.0);
    else
        ActionWait(6.0);
    ActionDoCommand(_gsCHApplyChain(oPossessor));
    SetCommandable(FALSE);
}
//----------------------------------------------------------------
void gsCHRemoveChain(object oChain)
{
    if (! GetIsObjectValid(oChain))  return;
    object oTarget = gsCHGetTarget(oChain);
    if (! GetIsObjectValid(oTarget)) return;

    SetCommandable(TRUE, oTarget);
    AssignCommand(oTarget, ClearAllActions());

    SendMessageToPC(oTarget, GS_T_16777339);
    gsFXRemoveEffect(oTarget, oChain, EFFECT_TYPE_BEAM, SUBTYPE_EXTRAORDINARY);

    DeleteLocalObject(oTarget, "GS_CH_CHAIN");
    DeleteLocalObject(oChain, "GS_CH_TARGET");
}
