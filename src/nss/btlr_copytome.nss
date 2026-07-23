//:://////////////////////////////////////////////
//::  BODY TAILOR:  copy to me
//::                          onconv bodytailor
//:://////////////////////////////////////////////
/*
   gather the model info
   and copy to the pc

*/
//:://////////////////////////////////////////////
//:: Created By: bloodsong
//:: based on the Mil_Tailor by Milambus Mandragon
//:://////////////////////////////////////////////
#include "btlr__inc"

void main()
{
    object oPC = GetPCSpeaker();
    object oSelf = OBJECT_SELF;
    int iNewApp;

//--HEAD:
    iNewApp = GetCreatureBodyPart(CREATURE_PART_HEAD);
    SetCreatureBodyPart(CREATURE_PART_HEAD, iNewApp, oPC);

//--PHENOTYPE
   SetPhenoType(GetPhenoType(oSelf), oPC);

}
