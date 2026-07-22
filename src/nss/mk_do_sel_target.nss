#include "mk_inc_craft"

void main()
{
    object oPC = GetPCSpeaker();
    object oTarget = OBJECT_SELF;

    CISetCurrentModMode(oPC,X2_CI_MODMODE_INVALID );
    MK_GenericDialog_CleanUp();

    MK_SetPlayerTargetScript(MK_CCOH_ONPLAYERTARGETSCRIPT);
    EnterTargetingMode(oPC, OBJECT_TYPE_CREATURE, MOUSECURSOR_MAGIC);
}
