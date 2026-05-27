#include "gs_inc_common"
#include "gs_inc_effect"
#include "gs_inc_flag"
#include "gs_inc_text"

const string GS_TEMPLATE_BLOOD = "plc_bloodstain";

void gsDying(int nHeal = FALSE)
{
    int nHitPoints = GetCurrentHitPoints();

    if (nHitPoints > 0)
    {
        if (! nHeal) FadeFromBlack(OBJECT_SELF, FADE_SPEED_SLOWEST);
        SpeakString("GS_AI_ATTACK_TARGET", TALKVOLUME_SILENT_TALK);
        return;
    }

    if (nHitPoints > -10)
    {
        effect eEffect;

        if (! nHeal && Random(100) >= 90)
        {
            nHeal = TRUE;
            FadeFromBlack(OBJECT_SELF, FADE_SPEED_SLOWEST);
            FloatingTextStringOnCreature(GS_T_16777324, OBJECT_SELF, FALSE);
        }

        if (nHeal)
        {
            eEffect = EffectHeal(1);
        }
        else
        {
            eEffect = EffectDamage(1);

            switch (Random(4))
            {
            case 0: PlayVoiceChat(VOICE_CHAT_PAIN1);  break;
            case 1: PlayVoiceChat(VOICE_CHAT_PAIN2);  break;
            case 2: PlayVoiceChat(VOICE_CHAT_PAIN3);  break;
            case 3: PlayVoiceChat(VOICE_CHAT_HEALME); break;
            }
        }

        ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, OBJECT_SELF);

        DelayCommand(6.0, gsDying(nHeal));
    }
}
//----------------------------------------------------------------
void main()
{
    object oDying = GetLastPlayerDying();

    AssignCommand(oDying, gsFXBleed());
    AssignCommand(oDying, PlayVoiceChat(VOICE_CHAT_NEARDEATH));

    if (GetIsPossessedFamiliar(oDying) ||
        gsFLGetAreaFlag("PVP", oDying))
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oDying);
        return;
    }
    else
    {
        CreateObject(OBJECT_TYPE_PLACEABLE, GS_TEMPLATE_BLOOD, GetLocation(oDying));
    }

    FloatingTextStringOnCreature(GS_T_16777438, oDying, FALSE);
    //FadeToBlack(oDying, FADE_SPEED_SLOWEST);
    AssignCommand(oDying, DelayCommand(6.0, gsDying()));
}
