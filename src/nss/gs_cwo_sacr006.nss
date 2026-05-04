#include "gs_inc_text"
#include "gs_inc_worship"

const int GS_GOLD = 500;

void main()
{
    object oSpeaker = GetPCSpeaker();

    //deity
    string sDeity   = GetDeity(oSpeaker);

    if (sDeity == "")
    {
        SendMessageToPC(oSpeaker, GS_T_16777282);
        return;
    }

    //gold
    int nGold       = GetGold(oSpeaker);

    if (nGold < GS_GOLD)
    {
        SendMessageToPC(oSpeaker, GS_T_16777238);
        return;
    }

    TakeGoldFromCreature(GS_GOLD, oSpeaker, TRUE);

    gsWOAdjustPresence(sDeity, GS_GOLD / 100);
    FloatingTextStringOnCreature(gsCMReplaceString(GS_T_16777298, sDeity), oSpeaker, FALSE);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,
                        EffectVisualEffect(VFX_IMP_HOLY_AID),
                        OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,
                        EffectVisualEffect(VFX_FNF_LOS_HOLY_30),
                        OBJECT_SELF);
}
