// mk_on_mounted.nss

#include "mk_inc_horse"
//#include "x3_inc_horse"

// this script is called by the CCOH horse system after smounting
// it could be used to mount all the PC's henchmen for example


void main()
{
    object oRider = OBJECT_SELF;
    if (!GetIsPC(oRider)) return;

    SendMessageToPC(OBJECT_SELF, "*** script \"mk_on_mounted\" called ***");

    int iHench;
    for (iHench=1; iHench<=GetMaxHenchmen(); iHench++)
    {
        object oHench = GetHenchman(oRider, iHench);
        if (!HorseGetIsMounted(oHench))
        {
            int nHorse = GetLocalInt(oHench, MK_VAR_CURRENT_HORSE);
            if (nHorse<=0)
            {
                nHorse = 17 + ((iHench-1) % 4) * 13;
            }
            MK_CreatureMountHorse(oHench, nHorse);
        }
    }

}
