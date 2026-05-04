#include "gs_inc_encounter"
#include "gs_inc_flag"

void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;

    if (GetLastPerceptionSeen() ||
        GetLastPerceptionHeard())
    {
        object oPerceived = GetLastPerceived();

        if (GetIsPC(oPerceived) &&
            ! (GetIsDM(oPerceived) || GetIsDMPossessed(oPerceived)))
        {
            SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

            object oArea = GetArea(OBJECT_SELF);
            int nChance  = gsENGetEncounterChance(oArea);

            if (nChance > 0)
            {
                location lLocation = GetLocation(OBJECT_SELF);
                string sResRef     = GetLocalString(OBJECT_SELF, "GS_BO_RESREF");
                int nCount         = gsENGetEncounterLimit(oArea);

                if (sResRef != "")
                {
                    //spawn boss
                    object oCreature = CreateObject(OBJECT_TYPE_CREATURE,
                                                    sResRef,
                                                    lLocation);

                    if (GetIsObjectValid(oCreature))
                    {
                        gsFLSetFlag(GS_FL_BOSS, oCreature);

                        //true seeing
                        if (GetChallengeRating(oCreature) >= 15.0)
                        {
                            ApplyEffectToObject(
                                DURATION_TYPE_PERMANENT,
                                ExtraordinaryEffect(EffectTrueSeeing()),
                                oCreature);
                        }

                        //phylactery
                        object oObject = GetNearestObjectByTag("GS_PHYLACTERY", oCreature);
                        int nNth       = 1;

                        while (GetIsObjectValid(oObject) &&
                               GetDistanceBetween(oObject, oCreature) <= 20.0)
                        {
                            if (! GetIsObjectValid(GetLocalObject(oObject, "GS_PHYLACTERY_CREATURE")))
                            {
                                SetLocalObject(oObject, "GS_PHYLACTERY_CREATURE", oCreature);
                                SetImmortal(oCreature, TRUE);
                                ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                                    EffectHeal(1000),
                                                    oObject);
                                break;
                            }

                            oObject = GetNearestObjectByTag("GS_PHYLACTERY", oCreature, ++nNth);
                        }
                    }
                }

                if (nCount > 0)
                {
                    //spawn encounter
                    float fRating1 = gsENGetRatingAtLocation(lLocation);
                    float fRating2 = gsENGetMinimumRating(oArea);

                    if (fRating1 < fRating2) fRating1 = fRating2;

                    if (fRating1 > 0.0)
                    {
                        AssignCommand(
                            oArea,
                            gsENSpawnAtLocation(
                                fRating1,
                                nCount,
                                lLocation,
                                2.5));
                    }
                }
            }

            DestroyObject(OBJECT_SELF);
        }
    }
}
