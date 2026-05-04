#include "gs_inc_common"

const string GS_TEMPLATE_CORPSE_FEMALE = "gs_item016";
const string GS_TEMPLATE_CORPSE_MALE   = "gs_item017";

void main()
{
    object oSpeaker = GetPCSpeaker();
    object oTarget  = GetLocalObject(OBJECT_SELF, "GS_TARGET");

    if (GetIsObjectValid(oTarget))
    {
        object oCorpse = CreateItemOnObject(GetGender(oTarget) == GENDER_FEMALE ?
                                            GS_TEMPLATE_CORPSE_FEMALE :
                                            GS_TEMPLATE_CORPSE_MALE,
                                            oSpeaker);

        if (GetIsObjectValid(oCorpse))
        {
            AssignCommand(oSpeaker, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 1.0));

            switch (GetCreatureSize(oTarget))
            {
            case CREATURE_SIZE_HUGE:
                AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS),
                                oCorpse);
                AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS),
                                oCorpse);
                break;

            case CREATURE_SIZE_LARGE:
                AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS),
                                oCorpse);
                AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_50_LBS),
                                oCorpse);
                break;

            case CREATURE_SIZE_MEDIUM:
                AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS),
                                oCorpse);
                break;

            case CREATURE_SIZE_SMALL:
                AddItemProperty(DURATION_TYPE_PERMANENT,
                                ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_50_LBS),
                                oCorpse);
                break;

            case CREATURE_SIZE_TINY:
                break;
            }

            SetLocalObject(oCorpse, "GS_TARGET", oTarget);
            SetLocalObject(oTarget, "GS_CORPSE", oCorpse);
            SetLocalInt(oCorpse, "GS_GOLD", GetLocalInt(OBJECT_SELF, "GS_GOLD"));
        }
    }
    else
    {
        FloatingTextStringOnCreature(GS_T_16777456, oSpeaker, FALSE);
    }

    DestroyObject(OBJECT_SELF);
}
