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

            //Shield
            string sShieldTemplate = "";
            int nShield = Random(5);
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
                    //No shield.
                    sShieldTemplate = "";
                break;
                case 4:
                    //No shield.
                    sShieldTemplate = "";
                break;
            }

            string sWeaponTemplate = "nw_wswdg001"; // Dagger default
            int nWeapon = Random(7);
            switch(nWeapon) {
                case 0:
                    sWeaponTemplate = "nw_wswdg001"; //Dagger
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
                case 4:
                    sWeaponTemplate = "nw_wswss001"; //Short Sword
                break;
                case 5:
                    sWeaponTemplate = "nw_wblcl001"; //Club
                break;
                case 6:
                    sWeaponTemplate = "nw_wblhl001"; //Light hammer
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
        break;

    case GS_EV_ON_SPELL_CAST_AT:
//................................................................

        break;
    }
}
