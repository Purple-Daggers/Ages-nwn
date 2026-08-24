#include "gs_inc_event"

void main()
{
    switch (GetUserDefinedEventNumber())
    {
    case GS_EV_ON_BLOCKED:
//................................................................

        break;

    case GS_EV_ON_COMBAT_ROUND_END:
//................................................................

        break;

    case GS_EV_ON_CONVERSATION:
//................................................................

        break;

    case GS_EV_ON_DAMAGED:
//................................................................

        break;

    case GS_EV_ON_DEATH:
//................................................................

        break;

    case GS_EV_ON_DISTURBED:
//................................................................

        break;

    case GS_EV_ON_HEART_BEAT:
//................................................................
        ExecuteScript("gs_run_ai", OBJECT_SELF);

        break;

    case GS_EV_ON_PERCEPTION:
//................................................................

        break;

    case GS_EV_ON_PHYSICAL_ATTACKED:
//................................................................

        break;

    case GS_EV_ON_RESTED:
//................................................................

        break;

    case GS_EV_ON_SPAWN: {
//................................................................
        //Randomize various aspects
        
        //Gender
        int nGender = Random(2);
        SetGender(OBJECT_SELF, nGender);
        if(nGender == GENDER_MALE)
        {
            SetSoundset(OBJECT_SELF, 177 + Random(3));
        } else 
        {
            SetSoundset(OBJECT_SELF, 176);
        }

        //Phenotype
        if(d100(1) >= 80)
        {
            SetPhenoType(2);   
        }

        //Head
        SetCreatureBodyPart(CREATURE_PART_HEAD, Random(19) + 1);

        int nHairColorPercentage = Random(100);
        if(nHairColorPercentage >= 84)
        {
            if(Random(2))
            {
                //Blond
                SetColor(OBJECT_SELF, COLOR_CHANNEL_HAIR, 8 + Random(4));
            }
            else
            {
                //Red
                SetColor(OBJECT_SELF, COLOR_CHANNEL_HAIR, 4 + Random(4));
            }
        }
        else
        {
            if(Random(2))
            {
                //Brown 1st range
                SetColor(OBJECT_SELF, COLOR_CHANNEL_HAIR, Random(4));
            }
            else
            {
                //Brown 2nd range
                SetColor(OBJECT_SELF, COLOR_CHANNEL_HAIR, 12 + Random(4));
            }
        }

        int nSkinColorPercentage = Random(100);
        if(nSkinColorPercentage >= 69)
        {
            //Black or mixed
            SetColor(OBJECT_SELF, COLOR_CHANNEL_SKIN, 4 + Random(4));
        }
        else
        {
            //White
            SetColor(OBJECT_SELF, COLOR_CHANNEL_SKIN, Random(4));
        }

        //Equipment
        int nClass = GetClassByPosition(1);
        int nClass2 = GetClassByPosition(2);
        int nClass3 = GetClassByPosition(3);

        if(nClass == CLASS_TYPE_FIGHTER)
        {
            //Shield
            string sShieldTemplate = "";
            int nShield = Random(4);
            switch(nShield) {
                case 0:
                    //No shield.
                    sShieldTemplate = "";
                break;
                case 1:
                    //Small shield
                    sShieldTemplate = "nw_ashsw001";
                break;
                case 2:
                    //Medium shield
                    sShieldTemplate = "nw_ashlw001";
                break;
                case 3:
                    //Tower shield
                    sShieldTemplate = "nw_ashto001";
                break;
            }

            string sWeaponTemplate = "nw_wswdg001"; // Dagger default
            int nWeapon = Random(4);
            switch(nWeapon) {
                case 0:
                    sWeaponTemplate = "nw_wswgs001"; //Great sword
                    sShieldTemplate = "";
                break;
                case 1:
                    sWeaponTemplate = "nw_wswls001"; //Longsword
                break;
                case 2:
                    sWeaponTemplate = "nw_wblml001"; //Mace
                break;
                case 3:
                    sWeaponTemplate = "nw_wplss001"; //Spear
                break;
            }
            CreateItemOnObject(sWeaponTemplate);
            if(sShieldTemplate != "")
            {
                object oShield = CreateItemOnObject(sShieldTemplate);
                ActionEquipItem(oShield, INVENTORY_SLOT_LEFTHAND);
            }
            ActionEquipMostDamagingMelee();
        }
        if(nClass == CLASS_TYPE_ROGUE)
        {
            string sWeaponTemplate = "nw_wswdg001"; // Dagger default
            int nWeapon = Random(4);
            switch(nWeapon) {
                case 0:
                    sWeaponTemplate = "nw_wswdg001"; //Dagger
                break;
                case 1:
                    sWeaponTemplate = "nw_wswrp001"; //Rapier
                break;
                case 2:
                    sWeaponTemplate = "nw_wswss001"; //Short sword
                break;
                case 3:
                    sWeaponTemplate = "nw_wdbqs001"; //Quarterstaff
                break;
            }
            CreateItemOnObject(sWeaponTemplate);
            ActionEquipMostDamagingMelee();
        }
    }
        break;

    case GS_EV_ON_SPELL_CAST_AT:
//................................................................

        break;
    }
}
