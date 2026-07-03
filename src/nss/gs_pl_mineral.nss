#include "gs_inc_common"
#include "gs_inc_time"

const int GS_DAMAGE = 25;

int GetAdjustedDamage(int nDamageType)
{
  // GetDamageDealtByType returns -1 if no damage of that type was done.
  int nDamage = GetDamageDealtByType(nDamageType);

  if (nDamage != -1) return nDamage;
  else return 0;
}

void main()
{
    object oDamager  = GetLastDamager();

    // Addition by Mithreas to restrict allowable damage types.
    // Note - weapon damage doesn't count as slashing/piercing/bludgeoning.
    // Yes, that seems odd and counter-intuitive. But that's what testing shows.
    int nActualDamage =
                  GetAdjustedDamage(DAMAGE_TYPE_BASE_WEAPON) +
                  GetAdjustedDamage(DAMAGE_TYPE_PIERCING) +
                  GetAdjustedDamage(DAMAGE_TYPE_BLUDGEONING) +
                  GetAdjustedDamage(DAMAGE_TYPE_SLASHING) +
                  GetAdjustedDamage(DAMAGE_TYPE_FIRE) +
                  GetAdjustedDamage(DAMAGE_TYPE_COLD);

    // There's a biobug which means that the script only "sees" the damage from
    // the last attack of one or more simultaneous attacks. So always heal
    // all the damage done, and destroy the placeable ourselves once we've
    // taken 250 "counted" damage.
    ApplyEffectToObject(DURATION_TYPE_INSTANT,
                        EffectHeal(GetTotalDamageDealt()),
                        OBJECT_SELF);

    int nDamage = nActualDamage + GetLocalInt(OBJECT_SELF, "GS_DAMAGE");
    // End addition but note change below to nDamage.

    if (! GetIsPC(oDamager))              return;
    if (GetIsPossessedFamiliar(oDamager)) return;
    string sTemplate = GetLocalString(OBJECT_SELF, "GS_TEMPLATE");
    if (sTemplate == "")                  return;
    int nChance      = GetLocalInt(OBJECT_SELF, "GS_CHANCE");
    if (nChance < 1)                      return;
    //int nDamage      = GetLocalInt(OBJECT_SELF, "GS_DAMAGE") +
    //                   GetTotalDamageDealt();


    while (nDamage >= GS_DAMAGE)
    {
        object oItem = OBJECT_INVALID;

        if (nChance + Random(100) >= 100)
        {
            oItem = CreateItemOnObject(sTemplate, oDamager);
            SetIdentified(oItem, TRUE);
            SetStolenFlag(oItem, FALSE);
        }

        nDamage -= GS_DAMAGE;
    }

    // Addition by Mithreas - check whether this placeable should be destroyed.
    // Remove this section if you want to allow placeables to be healed...
    int nTotalDamage = nActualDamage +
                       GetLocalInt(OBJECT_SELF, "GS_TOTAL_DAMAGE");
    //SpeakString("Cumulative damage: " + IntToString(nTotalDamage));

    if (nTotalDamage > GetMaxHitPoints() && !GetLocalInt(OBJECT_SELF, "destroyed"))
    {
      SetLocalInt(OBJECT_SELF, "destroyed", 1);
      int GS_TIMEOUT = 2400; //TIME UPDATE: 40 minutes
      gsCMCreateRecreator(gsTIGetActualTimestamp() + GS_TIMEOUT);
      DestroyObject(OBJECT_SELF);
    }
    else  SetLocalInt(OBJECT_SELF, "GS_TOTAL_DAMAGE", nTotalDamage);
    // End addition.

    SetLocalInt(OBJECT_SELF, "GS_DAMAGE", nDamage);
}
