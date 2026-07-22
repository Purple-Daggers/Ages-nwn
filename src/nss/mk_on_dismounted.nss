// mk_on_dismounted.nss

#include "mk_inc_horse"
//#include "x3_inc_horse"

// this script is called by the CCOH horse system after dismounting
// it could be used to dismount all the PC's henchmen for example

void main()
{
    object oRider = OBJECT_SELF;
    if (!GetIsPC(oRider)) return;

    SendMessageToPC(OBJECT_SELF, "*** script \"mk_on_dismounted\" called ***");

    int iHench;
    for (iHench=1; iHench<=GetMaxHenchmen(); iHench++)
    {
        object oHench = GetHenchman(oRider, iHench);
        if (GetIsObjectValid(oHench))
        {
            MK_CreatureMountHorse(oHench, 0);
        }
    }
}
