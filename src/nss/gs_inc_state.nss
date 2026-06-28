/* STATE Library by Gigaschatten */

#include "gs_inc_text"

//void main() {}

const int GS_ST_FOOD     = 1;
const int GS_ST_WATER    = 2;
const int GS_ST_REST     = 3;
const int GS_ST_SOBRIETY = 4;

//set initial state of caller
void gsSTSetInitialState();
//apply state adjustment to caller, hourly call recommended but we do it every 20 minutes
void gsSTProcessState();
//adjust nState of caller by fValue
void gsSTAdjustState(int nState, float fValue);
//return nState of oCreature
float gsSTGetState(int nState, object oCreature = OBJECT_SELF);
//animate caller depending on state
void gsSTPlayAnimation();

void gsSTSetInitialState()
{
    gsSTAdjustState(GS_ST_FOOD,      75.0 - gsSTGetState(GS_ST_FOOD));
    gsSTAdjustState(GS_ST_WATER,     75.0 - gsSTGetState(GS_ST_WATER));
    gsSTAdjustState(GS_ST_REST,      25.0 - gsSTGetState(GS_ST_REST));
    gsSTAdjustState(GS_ST_SOBRIETY, 100.0 - gsSTGetState(GS_ST_SOBRIETY));
}
//----------------------------------------------------------------
void gsSTProcessState()
{
    if (GetIsDead(OBJECT_SELF)) return;

    gsSTAdjustState(GS_ST_FOOD,  -0.715); //TIME UPDATE: ~48 hours
    gsSTAdjustState(GS_ST_WATER, -1.431); //TIME UPDATE: ~24 hours

    // Addition by Mithreas. If someone is sitting or kneeling, make them get
    // tired more slowly..  --[
    if (GetLocation(OBJECT_SELF) == GetLocalLocation(OBJECT_SELF, "MI_SIT_LOCATION"))
    {
      gsSTAdjustState(GS_ST_REST,  -0.715); //TIME UPDATE: ~48 hours
    }
    else
    {
      gsSTAdjustState(GS_ST_REST,  -1.431); //TIME UPDATE: ~24 hours
    }
    // ]-- end addition
    gsSTAdjustState(GS_ST_SOBRIETY,
                    IntToFloat(GetAbilityScore(OBJECT_SELF, ABILITY_CONSTITUTION)) / 2.0);
}
//----------------------------------------------------------------
void gsSTAdjustState(int nState, float fValue)
{
    if (fValue == 0.0) return;

    string sState   = "";
    string sMessage = "";

    switch (nState)
    {
    case GS_ST_FOOD:
        sState   = "GS_ST_FOOD";
        sMessage = GS_T_16777299;
        break;

    case GS_ST_WATER:
        sState   = "GS_ST_WATER";
        sMessage = GS_T_16777300;
        break;

    case GS_ST_REST:
        sState   = "GS_ST_REST";
        sMessage = GS_T_16777301;
        break;

    case GS_ST_SOBRIETY:
        sState   = "GS_ST_SOBRIETY";
        sMessage = GS_T_16777302;
        break;

    default:
        return;
    }

    //adjustment
    float fState    = GetLocalFloat(OBJECT_SELF, sState);
    float fStateNew = fState + fValue;

    if (fStateNew < -100.0)     fStateNew = -100.0;
    else if (fStateNew > 100.0) fStateNew =  100.0;

    SetLocalFloat(OBJECT_SELF, sState, fStateNew);

    if (fStateNew == fState)    return;

    //message
    sMessage += ": ";
    if (fValue > 0.0) sMessage += "<cªÕþ>+";
    else              sMessage += "<cþ((>";
    sMessage += FloatToString(fValue,    0, 1) + "% (" +
                FloatToString(fStateNew, 0, 1) + "%)";

    SendMessageToPC(OBJECT_SELF, sMessage);

    //effect
    if (GetIsDead(OBJECT_SELF))       return;
    object oCreator    = GetLocalObject(GetModule(), "GS_ST_CREATOR");
    if (! GetIsObjectValid(oCreator)) return;
    object oSelf       = OBJECT_SELF;
    float fConDecrease = 0.0;
    float fDexDecrease = 0.0;
    float fIntDecrease = 0.0;
    float fStrDecrease = 0.0;

    //food
    fState = gsSTGetState(GS_ST_FOOD);

    if (fState == -100.0)
    {
        FloatingTextStringOnCreature(GS_T_16777303, OBJECT_SELF, FALSE);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(FALSE, FALSE), OBJECT_SELF);
        return;
    }
    else if (fState < 0.0)
    {
        if (nState == GS_ST_FOOD)
            FloatingTextStringOnCreature(GS_T_16777304, OBJECT_SELF, FALSE);

        fValue        = fabs(fState) / 10.0;
        fConDecrease += fValue;
        fDexDecrease += fValue;
        fStrDecrease += fValue;
    }
    else if (fState < 15.0)
    {
        if (nState == GS_ST_FOOD)
            FloatingTextStringOnCreature(GS_T_16777305, OBJECT_SELF, FALSE);
    }

    //water
    fState = gsSTGetState(GS_ST_WATER);

    if (fState == -100.0)
    {
        FloatingTextStringOnCreature(GS_T_16777306, OBJECT_SELF, FALSE);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(FALSE, FALSE), OBJECT_SELF);
        return;
    }
    else if (fState < 0.0)
    {
        if (nState == GS_ST_WATER)
            FloatingTextStringOnCreature(GS_T_16777307, OBJECT_SELF, FALSE);

        fValue        = fabs(fState) / 10.0;
        fConDecrease += fValue;
        fDexDecrease += fValue;
        fStrDecrease += fValue;
    }
    else if (fState < 15.0)
    {
        if (nState == GS_ST_WATER)
            FloatingTextStringOnCreature(GS_T_16777308, OBJECT_SELF, FALSE);
    }

    //rest
    fState = gsSTGetState(GS_ST_REST);

    if (fState == -100.0)
    {
        FloatingTextStringOnCreature(GS_T_16777309, OBJECT_SELF, FALSE);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(FALSE, FALSE), OBJECT_SELF);
        return;
    }
    else if (fState < 0.0)
    {
        if (nState == GS_ST_REST)
        {
            FloatingTextStringOnCreature(GS_T_16777310, OBJECT_SELF, FALSE);
            // Edit by Mithreas. Don't put words in characters' mouths, and
            // instead emote a yawn. --[
            //if (GetCurrentAction() != ACTION_REST) PlayVoiceChat(VOICE_CHAT_REST);
            //if (GetCurrentAction() != ACTION_REST) SpeakString(GS_T_16777394);
            //SetPanelButtonFlash(OBJECT_SELF, PANEL_BUTTON_REST, TRUE);
            // ]-- End edit.
        }

        fValue        = fabs(fState) / 10.0;
        fConDecrease += fValue;
        fDexDecrease += fValue;
        fIntDecrease += fValue;
        fStrDecrease += fValue;
    }
    else if (fState < 15.0)
    {
        if (nState == GS_ST_REST)
        {
            FloatingTextStringOnCreature(GS_T_16777311, OBJECT_SELF, FALSE);
            SetPanelButtonFlash(OBJECT_SELF, PANEL_BUTTON_REST, TRUE);
        }
    }

    //sobriety
    fState = gsSTGetState(GS_ST_SOBRIETY);

    if (fState == -100.0)
    {
        FloatingTextStringOnCreature(GS_T_16777312, OBJECT_SELF, FALSE);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(FALSE, FALSE), OBJECT_SELF);
        return;
    }
    else if (fState < 0.0)
    {
        if (nState == GS_ST_SOBRIETY)
            FloatingTextStringOnCreature(GS_T_16777313, OBJECT_SELF, FALSE);

        fValue        = fabs(fState) / 10.0;
        fDexDecrease += fValue;
        fIntDecrease += fValue;
    }

    //limit penalty
    if (fConDecrease > 10.0) fConDecrease = 10.0;
    if (fDexDecrease > 10.0) fDexDecrease = 10.0;
    if (fIntDecrease > 10.0) fIntDecrease = 10.0;
    if (fStrDecrease > 10.0) fStrDecrease = 10.0;

    //remove effect
    effect eEffect = GetFirstEffect(OBJECT_SELF);

    while (GetIsEffectValid(eEffect))
    {
        if (GetEffectCreator(eEffect) == oCreator)
            RemoveEffect(OBJECT_SELF, eEffect);

        eEffect = GetNextEffect(OBJECT_SELF);
    }

    //apply effect
    if (fConDecrease != 0.0)
        AssignCommand(
            oCreator,
            ApplyEffectToObject(
                DURATION_TYPE_PERMANENT,
                ExtraordinaryEffect(
                    EffectAbilityDecrease(ABILITY_CONSTITUTION,
                                          FloatToInt(fConDecrease))),
                oSelf));

    if (fDexDecrease != 0.0)
        AssignCommand(
            oCreator,
            ApplyEffectToObject(
                DURATION_TYPE_PERMANENT,
                ExtraordinaryEffect(
                    EffectAbilityDecrease(ABILITY_DEXTERITY,
                                          FloatToInt(fDexDecrease))),
                oSelf));

    if (fIntDecrease != 0.0)
        AssignCommand(
            oCreator,
            ApplyEffectToObject(
                DURATION_TYPE_PERMANENT,
                ExtraordinaryEffect(
                    EffectAbilityDecrease(ABILITY_INTELLIGENCE,
                                          FloatToInt(fIntDecrease))),
                oSelf));

    if (fStrDecrease != 0.0)
        AssignCommand(
            oCreator,
            ApplyEffectToObject(
                DURATION_TYPE_PERMANENT,
                ExtraordinaryEffect(
                    EffectAbilityDecrease(ABILITY_STRENGTH,
                                          FloatToInt(fStrDecrease))),
                oSelf));
}
//----------------------------------------------------------------
float gsSTGetState(int nState, object oCreature = OBJECT_SELF)
{
    switch (nState)
    {
    case GS_ST_FOOD:     return GetLocalFloat(oCreature, "GS_ST_FOOD");
    case GS_ST_WATER:    return GetLocalFloat(oCreature, "GS_ST_WATER");
    case GS_ST_REST:     return GetLocalFloat(oCreature, "GS_ST_REST");
    case GS_ST_SOBRIETY: return GetLocalFloat(oCreature, "GS_ST_SOBRIETY");
    }

    return 0.0;
}
//----------------------------------------------------------------
void gsSTPlayAnimation()
{
    if (GetIsDead(OBJECT_SELF))        return;
    if (IsInConversation(OBJECT_SELF)) return;
    int nAction   = GetCurrentAction();
    if (nAction == ACTION_REST)        return;
    float fRandom = IntToFloat(Random(100) - 99);

    // Addition by Mithreas. If someone is already sitting or kneeling, don't
    // make them stand up.  --[
    if (GetLocation(OBJECT_SELF) == GetLocalLocation(OBJECT_SELF, "MI_SIT_LOCATION"))
      return;
    // ]-- End edit.
    if (fRandom < -50.0)
    {
        if (fRandom > gsSTGetState(GS_ST_FOOD)  ||
            fRandom > gsSTGetState(GS_ST_WATER) ||
            fRandom > gsSTGetState(GS_ST_REST)  ||
            fRandom > gsSTGetState(GS_ST_SOBRIETY))
        {
            ClearAllActions();
            ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT,    1.0, 3600.0);
        }
    }
    else if (nAction != ACTION_SIT)
    {
        if (fRandom > gsSTGetState(GS_ST_SOBRIETY))
        {
            ClearAllActions();
            PlayVoiceChat(VOICE_CHAT_LAUGH);
            ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING, 1.0,    2.0);
            ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_DRUNK,   1.0, 3598.0);
        }
        else if (fRandom > gsSTGetState(GS_ST_FOOD)  ||
                 fRandom > gsSTGetState(GS_ST_WATER) ||
                 fRandom > gsSTGetState(GS_ST_REST))
        {
            ClearAllActions();
            ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_TIRED,   1.0, 3600.0);
        }
    }
}

