#include "mk_inc_debug"
#include "x3_inc_horse"
#include "mk_inc_ccoh_db"
#include "mk_inc_body"
#include "mk_inc_exec"

const string MK_VAR_CURRENT_HORSE = "MK_CurrentHorse";
const string MK_VAR_CURRENT_TAIL = "MK_CurrentTail";
const string MK_VAR_CURRENT_APPR = "MK_CurrentAppr";

const string MK_2DA_RIDE_PHENO = "mk_ride_pheno";
// const string MK_2DA_RIDE_HORSES = "mk_horses";

const string MK_SCRIPT_ON_MOUNT = "mk_on_mount";
const string MK_SCRIPT_ON_DISMOUNT = "mk_on_dismount";
const string MK_SCRIPT_ON_MOUNTED = "mk_on_mounted";
const string MK_SCRIPT_ON_DISMOUNTED = "mk_on_dismounted";

const int MK_HORSE_1 = 16;
const int MK_HORSE_2 = 29;
const int MK_HORSE_3 = 42;
const int MK_HORSE_4 = 55;
const int MK_HORSE_5 = 68;

// ----------------------------------------------------------------------------
// Initializes the horse selection for oCreature:
// - sets the phenotype to riding
// - sets the tail to the current horse or the starting horse of no
//   current horse exists.
// ----------------------------------------------------------------------------
int MK_InitializeHorseSelection(object oCreature);

// ----------------------------------------------------------------------------
int MK_GetIsRiding(object oCreature);

// ----------------------------------------------------------------------------
int MK_PhenoTypeNormal2Ride(int nPhenoType);

// ----------------------------------------------------------------------------
int MK_PhenoTypeRide2Normal(int nPhenoType);


int MK_GetRidingAppearanceType(object oPC)
{
    string sColumn = MK_GetRacialTypeAsString(oPC)+"_"+MK_GetGenderAsString(oPC);
    string sApprType = Get2DAString("mk_ride_appr", sColumn, 0);
    if (sApprType=="")
    {
        return -1;
    }
    return StringToInt(sApprType);
}


int MK_GetIsRiding(object oCreature)
{
    int nResult;
    switch (MK_HORSE_GetHorseSystem(oCreature))
    {
    case MK_HORSE_BIOWARE_HORSE_SYSTEM:
        nResult = HorseGetIsMounted(oCreature);
        break;
    case MK_HORSE_CCOH_HORSE_SYSTEM:
    {
        int nPhenoType = GetPhenoType(oCreature);
        int nPhenoTypeRide = MK_PhenoTypeNormal2Ride(nPhenoType);
        int nPhenoTypeNormal = MK_PhenoTypeRide2Normal(nPhenoType);

        nResult = ((nPhenoTypeRide==-1) && (nPhenoTypeNormal!=-1));
        break;
    }
    }
    return nResult;
}

int MK_GetIsNotRiding(object oCreature)
{
    int nResult;
    switch (MK_HORSE_GetHorseSystem(oCreature))
    {
    case MK_HORSE_BIOWARE_HORSE_SYSTEM:
        nResult = !HorseGetIsMounted(oCreature);
        break;
    case MK_HORSE_CCOH_HORSE_SYSTEM:
    {
        int nPhenoType = GetPhenoType(oCreature);
        int nPhenoTypeRide = MK_PhenoTypeNormal2Ride(nPhenoType);
        int nPhenoTypeNormal = MK_PhenoTypeRide2Normal(nPhenoType);

        nResult = ((nPhenoTypeRide!=-1) && (nPhenoTypeNormal==-1));
        break;
    }
    }
    return nResult;
}

int MK_PhenoTypeNormal2Ride(int nPhenoType)
{
    string s = Get2DAString(MK_2DA_RIDE_PHENO, "Ride", nPhenoType);
    return ( (s=="") ? -1 : StringToInt(s) );
}

int MK_PhenoTypeRide2Normal(int nPhenoType)
{
    string s = Get2DAString(MK_2DA_RIDE_PHENO, "Normal", nPhenoType);
    return ( (s=="") ? -1 : StringToInt(s) );
}

int MK_HORSE_ExecuteScript(string sScript, object oTarget, string sOverrideScript, int nDefault=0)
{
    string sOScript = GetLocalString(GetModule(), sOverrideScript);
    if (sOScript!="") sScript = sOScript;
    return MK_EXEC_INT_ExecuteScript(sScript, oTarget, nDefault);
}

int MK_CreatureMountHorse(object oCreature, int nHorse)
{
//    int nPhenoTypeNormal, nPhenoTypeRide, nTailType;
    if (nHorse==0)
    {
        if (MK_GetIsRiding(oCreature))
        {
            if (MK_HORSE_ExecuteScript(MK_SCRIPT_ON_DISMOUNT, oCreature, "MK_SCRIPT_ON_DISMOUNT", TRUE))
            {
                switch (MK_HORSE_GetHorseSystem(oCreature))
                {
                case MK_HORSE_BIOWARE_HORSE_SYSTEM:
                    HorseInstantDismount(oCreature);
                    DeleteSkinInt(oCreature, "nX3_HorseAppearance");
                    break;
                case MK_HORSE_CCOH_HORSE_SYSTEM:
                {
                    // no horse selected and riding: unmount
                    string sIAStr = GetLocalString(oCreature, "MK_RIDING_PHENOTAIL_SAVE");
                    if (sIAStr!="")
                    {
                        DeleteLocalString(oCreature, "MK_RIDING_PHENOTAIL_SAVE");
                        MK_CCOH_DB_IAStrToBodyAppearance(oCreature, sIAStr, MK_CCOH_DB_BODY_APPR_HORSE);
                    }
                    else
                    {
                        int nPhenoTypeNormal = MK_PhenoTypeRide2Normal(GetPhenoType(oCreature));

                        int nTailType = GetLocalInt(oCreature, MK_VAR_CURRENT_TAIL);
                        int nApprType = GetLocalInt(oCreature, MK_VAR_CURRENT_APPR);

                        SetPhenoType(nPhenoTypeNormal, oCreature);
                        SetCreatureTailType(nTailType, oCreature);
                        SetCreatureAppearanceType(oCreature, nApprType);
                    }
                    break;
                }
                }
                MK_HORSE_SetUsedHorseSystem(oCreature, 0);
                MK_HORSE_ExecuteScript(MK_SCRIPT_ON_DISMOUNTED, oCreature, "MK_SCRIPT_ON_DISMOUNTED");
            }
        }
    }
    else if (nHorse>0)
    {
        if (MK_GetIsNotRiding(oCreature))
        {
            // we're not riding yet so change phenotype
            if (MK_HORSE_ExecuteScript(MK_SCRIPT_ON_MOUNT, oCreature, "MK_SCRIPT_ON_MOUNT", TRUE))
            {
                switch (MK_HORSE_GetHorseSystem(oCreature))
                {
                case MK_HORSE_BIOWARE_HORSE_SYSTEM:
                {
                    string s2DAFile = MK_HORSES_Get2DAFile();
                    string sResRef = Get2DAString(s2DAFile, "ResRef", nHorse);
                    HorseInstantMount(oCreature, nHorse, FALSE, sResRef);
                    int nAppearanceType = MK_Get2DAInt(s2DAFile, "Appearance", nHorse);
                    SetSkinInt(oCreature, "nX3_HorseAppearance", nAppearanceType);
                    MK_DEBUG_TRACE("SetSkinInt("+GetName(oCreature)+", \"nX3_HorseAppearance\", "+IntToString(nAppearanceType));
                    break;
                }
                case MK_HORSE_CCOH_HORSE_SYSTEM:
                {
                    string sIAStr = MK_CCOH_DB_BodyAppearanceToIAStr(oCreature, MK_CCOH_DB_BODY_APPR_HORSE);
                    if (sIAStr!="")
                    {
                        SetLocalString(oCreature, "MK_RIDING_PHENOTAIL_SAVE", sIAStr);
                    }
                    else
                    {
                        SetLocalInt(oCreature, MK_VAR_CURRENT_TAIL, GetCreatureTailType(oCreature));
                        SetLocalInt(oCreature, MK_VAR_CURRENT_APPR, GetAppearanceType(oCreature));
                    }
                    int nPhenoTypeRide = MK_PhenoTypeNormal2Ride(GetPhenoType(oCreature));
                    if (nPhenoTypeRide!=-1)
                    {
                        SetPhenoType(nPhenoTypeRide, oCreature);
                    }
                    int nApprType = MK_GetRidingAppearanceType(oCreature);
                    if (nApprType!=-1)
                    {
                        SetCreatureAppearanceType(oCreature, nApprType);
                    }
                    SetFootstepType(FOOTSTEP_TYPE_HORSE, oCreature);
                    SetCreatureTailType(nHorse, oCreature);

                    break;
                }
                }

                MK_HORSE_SetUsedHorseSystem(oCreature, MK_HORSE_GetHorseSystem(oCreature));

                MK_HORSE_ExecuteScript(MK_SCRIPT_ON_MOUNTED, oCreature, "MK_SCRIPT_ON_MOUNTED");
            }
        }
        else
        {
            SetCreatureTailType(nHorse, oCreature);
            switch (MK_HORSE_GetHorseSystem(oCreature))
            {
            case MK_HORSE_BIOWARE_HORSE_SYSTEM:
            {
                string s2DAFile = MK_HORSES_Get2DAFile();
                string sResRef = Get2DAString(s2DAFile, "ResRef", nHorse);
                SetSkinString(oCreature, "sX3_HorseResRef", sResRef);
                int nAppearanceType = MK_Get2DAInt(s2DAFile, "Appearance", nHorse);
                SetSkinInt(oCreature, "nX3_HorseAppearance", nAppearanceType);
                MK_DEBUG_TRACE("MK_CreatureMountHorse("+IntToString(nHorse)+"): sResRef="+sResRef+", nAppearanceType="+IntToString(nAppearanceType));
                break;
            }
            }
        }
    }
    return TRUE;
}

void MK_SetCustomTokenToHorseName(int nCustomTokenNumber, int nHorse)
{
    string sHorseName = MK_GetHorseName(nHorse);
    SetCustomToken(nCustomTokenNumber,
        sHorseName + "(" + IntToString(nHorse) + ")");
}

int MK_InitializeHorseSelection(object oCreature)
{
    int bIsRiding = MK_GetIsRiding(oCreature);
    int nCurrentHorse = GetLocalInt(oCreature, MK_VAR_CURRENT_HORSE);

    if (nCurrentHorse != 0)
    {
        MK_SetCustomTokenToHorseName(14440,nCurrentHorse);
    }
    MK_SetCustomTokenToHorseName(14441,MK_HORSE_1);
    MK_SetCustomTokenToHorseName(14442,MK_HORSE_2);
    MK_SetCustomTokenToHorseName(14443,MK_HORSE_3);
    MK_SetCustomTokenToHorseName(14444,MK_HORSE_4);
    MK_SetCustomTokenToHorseName(14445,MK_HORSE_5);

    return TRUE;
}

/*
void main()
{

}
/**/
