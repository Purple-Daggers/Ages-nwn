// requires
#include "x3_inc_skin"
#include "mk_inc_tools_s"
#include "mk_inc_iaam"
//#include "mk_inc_ccoh_db"
#include "mk_inc_debug"


const int MK_CRAFTBODY_CREATUREPART_NAME = 12220;

const int MK_CREATURE_PART_NEXT = 1;
const int MK_CREATURE_PART_PREV = 2;

const int MK_CRAFTBODY_ERROR = 0;
const int MK_CRAFTBODY_HEAD = 1;

const int MK_CRAFTBODY_TAIL = 3;
const int MK_CRAFTBODY_WINGS = 4;
const int MK_CRAFTBODY_PHENOTYPE = 5;

const int MK_CRAFTBODY_PORTRAIT = 7;
const int MK_CRAFTBODY_BODY = 8;
const int MK_CRAFTBODY_HORSE = 9;

const int MK_CRAFTBODY_COLOR = 10;

const int MK_CRAFTBODY_APPRTYPE = 11;

const int MK_CRAFTBODY_SCALE = 12;

const int MK_CRAFTBODY_FOOTSTEP = 13;

const int MK_CRAFTBODY_DEITY = 14;

const int MK_CRAFTBODY_NUMBER_OF_BODYPARTS = 14;

//const int MK_CRAFTBODY_SAVERESTORE = 21;

const int MK_CRAFTBODY_NUMBER_OF_SLOTS = 10;

const int MK_CRAFTBODY_NEXT = 1;
const int MK_CRAFTBODY_PREV = 2;
const int MK_CRAFTBODY_CLEAR = 3;

const int MK_PORTRAIT_ID_NEXT = 1;
const int MK_PORTRAIT_ID_PREV = 2;
const int MK_PORTRAIT_RESREF_NEXT = 3;
const int MK_PORTRAIT_RESREF_PREV = 4;

const string MK_CRAFTBODY_CURRENT = "MK_CRAFTBODY_CURRENT";
const string MK_CRAFTBODY_SUB = "MK_CRAFTBODY_SUB";
//const string MK_CRAFTBODY_SAVE = "MK_CRAFTBODY_SAVE";

const string MK_CRAFTBODY_HEAD_FILTER = "MK_CRAFTBODY_HEAD_FILTER";

const int MK_CRAFTBODY_TOKEN_NAME = 14422;
const int MK_CRAFTBODY_TOKEN_NUMBER = 14423;

//const string MK_2DA_RIDE_PHENO = "mk_ride_pheno";
//const string MK_2DA_RIDE_HORSES = "mk_horses";

//const string MK_VAR_CURRENT_HORSE = "MK_CurrentHorse";
//const string MK_VAR_CURRENT_TAIL = "MK_CurrentTail";

//const int MK_HORSE_1 = 16;
//const int MK_HORSE_2 = 29;
//const int MK_HORSE_3 = 42;
//const int MK_HORSE_4 = 55;
//const int MK_HORSE_5 = 68;

//const int MK_STATE_BODY = 10;

/*
const int MK_STATE_BODY_SELECT = 10;
const int MK_STATE_BODY_MODIFY = 11;
*/


// ----------------------------------------------------------------------------
// Sets the part of the body to be modified
// - nBodyPart (MK_CRAFTBODY_*)
//      MK_CRAFTBODY_ERROR
//      MK_CRAFTBODY_HEAD
//      MK_CRAFTBODY_TAIL
//      MK_CRAFTBODY_WINGS
//      MK_CRAFTBODY_PHENOTYPE
//      MK_CRAFTBODY_PORTRAIT
//      MK_CRAFTBODY_BODY
// ----------------------------------------------------------------------------
void MK_SetBodyPartToBeModified(object oPC, int nBodyPart, int bSetCamera=FALSE);

// ----------------------------------------------------------------------------
// Returns the body part to be modified
// ----------------------------------------------------------------------------
int MK_GetBodyPartToBeModified(object oCreature);

// ----------------------------------------------------------------------------
// Changes the creature's portrait
// - nMode
//      MK_PORTRAITID_NEXT
//      MK_PORTRAITID_PREV
// ----------------------------------------------------------------------------
void MK_NewPortrait(object oCreature, int nMode, object oPC);

// ----------------------------------------------------------------------------
// Tries to find the portrait ID by searching the portraits.2da
// for a matching resref.
// - bCustom: searches custom portrait list
// ----------------------------------------------------------------------------
int MK_GetPortraitIdFromResRef(object oPC, string sResRef, int bCustom=FALSE);

// ----------------------------------------------------------------------------
// Get the PortraitId of oTarget
// - oTarget: the object for which you are getting the portrait Id.
//
// The function calls GetPortraitId() and if PORTRAIT_INVALID is returned
// it tries GetPortraitResRef() and searches the returned ResRef in
// Portraits.2da.
// - bCustom: searches custom portrait list
//
// ----------------------------------------------------------------------------
int MK_GetPortraitId(object oTarget, object oPC);

// ----------------------------------------------------------------------------
// Get the custom PortraitId of oTarget
// - oTarget: the object for which you are getting the portrait Id.
//
// The function reads the portrait resref and searches MK_Portraits.2da
// for a matching portrait.
// Returns PORTRAIT_INVALID if no matching portrait is found. Otherwise
// it returns the line number.
// ----------------------------------------------------------------------------
int MK_GetCustomPortraitId(object oTarget, object oPC);

// ----------------------------------------------------------------------------
// Returns the current body part number
// ----------------------------------------------------------------------------
int MK_GetBodyPart(object oCreature, object oPC, int nBodyPartToBeModified, int nSubBodyPart=0);

// ----------------------------------------------------------------------------
// Sets the current body part number
// ----------------------------------------------------------------------------
void MK_SetBodyPart(int nBodyPart, object oCreature, int nBodyPartToBeModified, int nSubBodyPart=0);

// ----------------------------------------------------------------------------
// Calculates the save bodypart string
// ----------------------------------------------------------------------------
string MK_GetSaveBodyPartString(object oCreature, int nBodyPart);

// ----------------------------------------------------------------------------
// Restores appearance of bodypart nBodyPart from string sSaveString
// ----------------------------------------------------------------------------
void MK_RestoreBodyPartFromString(object oCreature, int nBodyPart, string sSaveString, float fDelay=0.0);

// ----------------------------------------------------------------------------
// Saves the current body appearance to slot nSlot
// ----------------------------------------------------------------------------
//void MK_SaveBody(object oCreature, int nSlot);

// ----------------------------------------------------------------------------
// Compares the current body appearance with appearance in slot nSlot
// ----------------------------------------------------------------------------
//int MK_CompareBody(object oCreature, int nSlot);

// ----------------------------------------------------------------------------
// Returns TRUE if slot nSlot stores a body appearance
// ----------------------------------------------------------------------------
int MK_GetIsUsedSaveBodySlot(object oCreature, int nSlot);

// ----------------------------------------------------------------------------
// Restores the body appearance from slot nSlot
// ----------------------------------------------------------------------------
//void MK_RestoreBody(object oCreature, int nSlot);

// ----------------------------------------------------------------------------
// Saves the current body part so it can be restored
// ----------------------------------------------------------------------------
//void MK_SaveBodyPart(object oCreature);

// ----------------------------------------------------------------------------
// Restores a previously saved body part
// ----------------------------------------------------------------------------
//void MK_RestoreBodyPart(object oCreature);

// ----------------------------------------------------------------------------
// Finishes modifying of creature body
// ----------------------------------------------------------------------------
void MK_DoneBodyPart(object oPC, object oTarget);

// ----------------------------------------------------------------------------
// Some clean up
// ----------------------------------------------------------------------------
void MK_CleanUpBodyPart(object oPC, object oTarget);

// ----------------------------------------------------------------------------
// Returns TRUE if nBodyPart is valid
// ----------------------------------------------------------------------------
int MK_GetIsValidBodyPart(int nPartToBeModfied, int nBodyPart, string sUser2DA="", string sColumn="",
    string sUser2DA2="", string sColumn2="");

// ----------------------------------------------------------------------------
// Returns the name of nBodyPart
// ----------------------------------------------------------------------------
string MK_GetBodyPartName(int nPartToBeModified, int nBodyPart);

// ----------------------------------------------------------------------------
// Returns the name of the current horse
// ----------------------------------------------------------------------------
string MK_GetHorseName(int nHorse);

// ----------------------------------------------------------------------------
// Changes the body part
// - nMode
//      MK_CRAFTBODY_NEXT
//      MK_CRAFTBODY_PREV
//      MK_CRAFTBODY_TOGGLE
//
// ----------------------------------------------------------------------------
void MK_NewBodyPart(object oCreature, int nMode, object oPC=OBJECT_INVALID);


// ----------------------------------------------------------------------------
// Sets the tokens 14422/14423 to current body part name/number
// ----------------------------------------------------------------------------
void MK_SetBodyPartTokens(object oPC, object oTarget=OBJECT_INVALID);

// ----------------------------------------------------------------------------
// Sets the tokens 14422/14423
// ----------------------------------------------------------------------------
void MK_SetBodyPartTokens2(string sPartName, string sBodyPart);

// ----------------------------------------------------------------------------
int MK_GetMaxBodyPartID(object oPC, int nCreaturePart);

string MK_BODY_GetCEPHeadColumn(object oPC);

int MK_BODY_GetCEPHeadFilterExists(object oPC);


void MK_SetColor(object oObject, int nColorChannel, int nColorValue);

/*
// ----------------------------------------------------------------------------
// Initializes the horse selection for oCreature:
// - sets the phenotype to riding
// - sets the tail to the current horse or the starting horse of no
//   current horse exists.
// ----------------------------------------------------------------------------
int MK_InitializeHorseSelection(object oCreature);

// ----------------------------------------------------------------------------
int MK_GetIsRiding(object oCreature);
*/

// ----------------------------------------------------------------------------
// implementation
// ----------------------------------------------------------------------------

void MK_SetColor(object oObject, int nColorChannel, int nColorValue)
{
    SetColor(oObject, nColorChannel, nColorValue);

    if (MK_VERSION_GetIsBuildVersionGreaterEqual(GetPCSpeaker(), 8193, 21) && !MK_VERSION_GetIsBuildVersionGreaterEqual(GetPCSpeaker(), 8193, 22))
    {
        MK_DEBUG_TRACE("8193.21 workaround: removing head to force head to update colors!");
        int nHead = GetCreatureBodyPart(CREATURE_PART_HEAD, oObject);
        SetCreatureBodyPart(CREATURE_PART_HEAD, 255, oObject);
        DelayCommand(0.2, SetCreatureBodyPart(CREATURE_PART_HEAD, nHead, oObject));
    }
}

const int MK_HORSE_CCOH_HORSE_SYSTEM = 1;
const int MK_HORSE_BIOWARE_HORSE_SYSTEM = 2;

int MK_HORSE_GetHorseSystem(object oRider = OBJECT_SELF)
{
    int nHorseSystem = GetLocalInt(oRider, "MK_HORSE_USED_HORSE_SYSTEM");
//    MK_DEBUG_TRACE("MK_HORSE_GetHorseSystem: MK_HORSE_USED_HORSE_SYSTEM("+GetName(oRider)+")="+IntToString(nHorseSystem));
    if (nHorseSystem == 0)
    {
        nHorseSystem = GetLocalInt(GetModule(), "MK_HORSE_HORSE_SYSTEM");
//        MK_DEBUG_TRACE("MK_HORSE_GetHorseSystem: MK_HORSE_HORSE_SYSTEM("+GetName(OBJECT_SELF)+")="+IntToString(nHorseSystem));
    }
    if (nHorseSystem == 0)
    {
        nHorseSystem = MK_HORSE_CCOH_HORSE_SYSTEM;
    }
    return nHorseSystem;
}

string MK_HORSES_Get2DAFile()
{
    string s2DAFile = GetLocalString(GetModule(), "MK_2DA_VALID_HORSES");
    MK_DEBUG_TRACE("MK_HORSES_Get2DAFile(): '"+s2DAFile+"'");
    if (s2DAFile=="") s2DAFile = "mk_horses";

    MK_DEBUG_TRACE(" > '"+s2DAFile+"'");
    return s2DAFile;
}


void MK_HORSE_SetUsedHorseSystem(object oRider, int nHorseSystem)
{
//    MK_DEBUG_TRACE("MK_HORSE_SetHorseSystem: MK_HORSE_USED_HORSE_SYSTEM("+GetName(oRider)+")="+IntToString(nHorseSystem));
    SetLocalInt(oRider, "MK_HORSE_USED_HORSE_SYSTEM", nHorseSystem);
}

void MK_SetBodyPartToBeModified(object oPC, int nBodyPart, int bSetCamera)
{
//    MK_DEBUG_TRACE(" MK_SetBodyPartToBeModified(nBodyPart="+IntToString(nBodyPart)+", bSetCamera="+IntToString(bSetCamera)+")");
    SetLocalInt(oPC, MK_CRAFTBODY_CURRENT,nBodyPart);

    if (bSetCamera)
    {
        float fFacing  = GetFacing(oPC) + 180.0;
        float fPitch = 75.0;
        float  fDistance = 3.5f;

        switch (nBodyPart)
        {
        case MK_CRAFTBODY_HEAD:
            fDistance = 2.5f;
            break;
        case MK_CRAFTBODY_TAIL:
            fFacing += 135;
            break;
        case MK_CRAFTBODY_WINGS:
            fFacing += 135;
            break;
        case MK_CRAFTBODY_PHENOTYPE:
            break;
        case MK_CRAFTBODY_BODY:
            break;
        }
        if (fFacing > 359.0)
        {
            fFacing -=359.0;
        }

        switch (GetRacialType(oPC))
        {
        case RACIAL_TYPE_HALFORC:
            fDistance += 1.0f;
            break;
        }
        SetCameraFacing(fFacing, fDistance, fPitch,CAMERA_TRANSITION_TYPE_VERY_FAST) ;
    }
}

void MK_CraftBody_SetDefaultCameraFacing(object oPC)
{
    float fDistance = 3.5f;
    float fPitch =  75.0f;
    float fFacing;
    fFacing  = GetFacing(oPC) + 180.0;
    if (fFacing > 359.0)
    {
        fFacing -=359.0;
    }
    SetCameraFacing(fFacing, fDistance, fPitch,CAMERA_TRANSITION_TYPE_VERY_FAST) ;
}

void MK_SetSubPartToBeModified(object oPC, int nSubPart, int bSetCamera=TRUE)
{
    SetLocalInt(oPC, MK_CRAFTBODY_SUB, nSubPart);

    string sName;
    switch (MK_GetBodyPartToBeModified(oPC))
    {
    case MK_CRAFTBODY_BODY:
    {
        if (MK_IAAM_GetIsCreaturePart(nSubPart))
        {
            if (bSetCamera)
            {
                // * Make the camera float near the PC
                float fFacing  = GetFacing(oPC) + 180.0;
                if (fFacing > 359.0)
                {
                    fFacing -=359.0;
                }

                float fPitch = 75.0;
                float  fDistance = 3.5f;

                if (nSubPart == CREATURE_PART_RIGHT_FOOT || nSubPart == CREATURE_PART_LEFT_FOOT  )
                {
                    fDistance = 3.5f;
                    fPitch = 47.0f;
                }
                else if (nSubPart == CREATURE_PART_LEFT_THIGH || nSubPart == CREATURE_PART_RIGHT_THIGH )
                {
                    fDistance = 2.5f;
                    fPitch = 65.0f;
                }
                else if (nSubPart == CREATURE_PART_RIGHT_SHIN || nSubPart == CREATURE_PART_LEFT_SHIN    )
                {
                    fDistance = 3.5f;
                    fPitch = 95.0f;
                }

                if (GetRacialType(oPC)  == RACIAL_TYPE_HALFORC)
                {
                    fDistance += 1.0f;
                }

                SetCameraFacing(fFacing, fDistance, fPitch,CAMERA_TRANSITION_TYPE_VERY_FAST) ;
            }
            sName = MK_IAAM_GetName(nSubPart);
//            MK_DEBUG_TRACE("MK_SetSubPartToBeModified: sName='"+sName+"'");

        }
        break;
    }
    default:
        if (bSetCamera)
        {
            MK_CraftBody_SetDefaultCameraFacing(oPC);
        }
        break;
    }
    SetCustomToken(MK_CRAFTBODY_CREATUREPART_NAME, sName);
}

int MK_GetBodyPartToBeModified(object oCreature)
{
    return GetLocalInt(oCreature,MK_CRAFTBODY_CURRENT);
}

int MK_GetSubPartToBeModified(object oCreature)
{
    return GetLocalInt(oCreature,MK_CRAFTBODY_SUB);
}

int MK_GetBoneArmBodyPart(int iBoneArm)
{
    int nPart=0;
    switch (iBoneArm)
    {
    case 0:
        nPart = CREATURE_PART_LEFT_BICEP;
        break;
    case 1:
        nPart = CREATURE_PART_LEFT_FOREARM;
        break;
    case 2:
        nPart = CREATURE_PART_LEFT_HAND;
        break;
    }
    return nPart;
}

int MK_GetTattooBodyPart(int iTattoo)
{
    int nPart=0;
    switch (iTattoo)
    {
    case 0:
        nPart = CREATURE_PART_TORSO;
        break;
    case 1:
        nPart = CREATURE_PART_LEFT_BICEP;
        break;
    case 2:
        nPart = CREATURE_PART_RIGHT_BICEP;
        break;
    case 3:
        nPart = CREATURE_PART_LEFT_FOREARM;
        break;
    case 4:
        nPart = CREATURE_PART_RIGHT_FOREARM;
        break;
    case 5:
        nPart = CREATURE_PART_LEFT_THIGH;
        break;
    case 6:
        nPart = CREATURE_PART_RIGHT_THIGH;
        break;
    case 7:
        nPart = CREATURE_PART_LEFT_SHIN;
        break;
    case 8:
        nPart = CREATURE_PART_RIGHT_SHIN;
        break;
    }
    return nPart;
}

string MK_BodyPartToColumn(int nPart)
{
    return Get2DAString("capart", "MDLNAME", nPart);
}

int MK_BodyPart_ID2Model(int nPart, int nID)
{
    string sColumn = MK_BodyPartToColumn(nPart);
    string sModel = Get2DAString("mk_bodyparts", sColumn, nID);
    if (sModel=="") return -1;
    return StringToInt(sModel);
}

int MK_BodyPart_Model2ID(object oPC, int nPart, int nModel)
{
    string sColumn = MK_BodyPartToColumn(nPart);

    int nMin = 0;
    int nMax = MK_GetMaxBodyPartID(oPC, nPart);

    int bFound=FALSE;
    string s2DA = "MK_BodyParts";

    int nId=nMin-1;
    while ((!bFound) && (nId<nMax))
    {
        int nModelQ = MK_Get2DAInt(s2DA, sColumn, ++nId);
        bFound = (nModel==nModelQ);
    }
    if (!bFound)
    {
        nId = -1;
    }
    return nId;
}

int MK_GetCreatureBodyPartID(int nPart, object oCreature, object oPC)
{
    int nModel = GetCreatureBodyPart(nPart, oCreature);

    return MK_BodyPart_Model2ID(oPC, nPart, nModel);
}

int MK_GetBodyPart(object oCreature, object oPC, int nBodyPartToBeModified, int nSubBodyPart=0)
{
    int nBodyPart = 0;
    switch (nBodyPartToBeModified)
    {
    case MK_CRAFTBODY_HEAD:
        nBodyPart = GetCreatureBodyPart(CREATURE_PART_HEAD, oCreature);
        break;
    case MK_CRAFTBODY_BODY:
        nBodyPart = MK_GetCreatureBodyPartID(
                        nSubBodyPart,
//                        GetLocalInt(OBJECT_SELF,"X2_TAILOR_CURRENT_PART"),
                        oCreature,
                        oPC);
        break;
    case MK_CRAFTBODY_TAIL:
        nBodyPart = GetCreatureTailType(oCreature);
        break;
    case MK_CRAFTBODY_HORSE:
        nBodyPart = GetCreatureTailType(oCreature);
        break;
    case MK_CRAFTBODY_WINGS:
        nBodyPart = GetCreatureWingType(oCreature);
        break;
    case MK_CRAFTBODY_PHENOTYPE:
        nBodyPart = GetPhenoType(oCreature);
        break;
    case MK_CRAFTBODY_PORTRAIT:
        nBodyPart = MK_GetPortraitId(oCreature, oPC);
        break;
    case MK_CRAFTBODY_COLOR:
        nBodyPart = GetColor(oCreature, nSubBodyPart);
        break;
    }
    return nBodyPart;
}

void MK_SetCreatureBodyPartFromID(int nPart, int nID, object oCreature)
{
    int nModel = MK_BodyPart_ID2Model(nPart, nID);
    SetCreatureBodyPart(nPart, nModel, oCreature);
}

void MK_SetBodyPart(int nBodyPart, object oCreature, int nBodyPartToBeModified, int nSubBodyPart)
{
    switch (nBodyPartToBeModified)
    {
    case MK_CRAFTBODY_HEAD:
        SetCreatureBodyPart(CREATURE_PART_HEAD, nBodyPart, oCreature);
        break;
    case MK_CRAFTBODY_BODY:
        MK_SetCreatureBodyPartFromID(
            nSubBodyPart,
            nBodyPart,
            oCreature);
        break;
    case MK_CRAFTBODY_TAIL:
        SetCreatureTailType(nBodyPart, oCreature);
        break;
    case MK_CRAFTBODY_HORSE:
        SetCreatureTailType(nBodyPart, oCreature);
        switch (MK_HORSE_GetHorseSystem())
        {
        case MK_HORSE_BIOWARE_HORSE_SYSTEM:
        {
            int nAppearance = MK_Get2DAInt(MK_HORSES_Get2DAFile(), "Appearance", nBodyPart, -1);
            if (nAppearance!=-1)
            {
                SetSkinInt(oCreature, "nX3_HorseAppearance", nAppearance);
            }
            string sResRef = Get2DAString(MK_HORSES_Get2DAFile(), "ResRef", nBodyPart);
            SetSkinString(oCreature, "sX3_HorseResRef", sResRef);
            break;
        }
        }
        break;
    case MK_CRAFTBODY_WINGS:
        SetCreatureWingType(nBodyPart, oCreature);
        break;
    case MK_CRAFTBODY_PHENOTYPE:
        SetPhenoType(nBodyPart, oCreature);
        break;
    case MK_CRAFTBODY_PORTRAIT:
        SetPortraitId(oCreature, nBodyPart);
        break;
    case MK_CRAFTBODY_COLOR:
    {
//        MK_DEBUG_TRACE("MK_SetBodyPart: SetColor()");
        MK_SetColor(oCreature, nSubBodyPart, nBodyPart);
        break;
    }
    }
}

string MK_BODY_GetVarName(int nSlot, int nBodyPart)
{
    return "MK_SaveSlot"+MK_IntToString(nSlot,2,"0")+"_"
        + "Part"+MK_IntToString(nBodyPart,2,"0");
}

string MK_BODY_GetDatabaseString(object oPC, int nSlot, int nBodyPart)
{
//    string sVarName = "MK_SaveSlot"+MK_IntToString(nSlot,2,"0")+"_"
//        + "Part"+MK_IntToString(nBodyPart,2,"0");
//    return MK_CCOH_DB_GetString(oPC, MK_BODY_GetVarName(oPC, nSlot, nBodyPart));
    return GetLocalString(oPC, MK_BODY_GetVarName(nSlot, nBodyPart));
}

void MK_BODY_SetDatabaseString(object oPC, int nSlot, int nBodyPart, string sValue)
{
//   MK_CCOH_DB_SetString(oPC, MK_BODY_GetVarName(oPC, nSlot, nBodyPart), sValue);
   SetLocalString(oPC, MK_BODY_GetVarName(nSlot, nBodyPart), sValue);
}

int MK_GetIsUsedSaveBodySlot(object oCreature, int nSlot)
{
    if (nSlot>=0)
    {
//        string sPrefix = "MK_SaveSlot"+MK_IntToString(nSlot,2,"0")+"_";
        int nBodyPart;
        for (nBodyPart=1; nBodyPart<=MK_CRAFTBODY_NUMBER_OF_BODYPARTS; nBodyPart++)
        {
//            string sVariable = sPrefix+"Part"+MK_IntToString(nBodyPart,2,"0");
//            string sSaveString = GetLocalString(oCreature, sVariable);
//            if (sSaveString!="") return TRUE;
            if (MK_BODY_GetDatabaseString(oCreature, nSlot, nBodyPart)!="")
            {
                return TRUE;
            }
        }
        return FALSE;
    }
    else
    {
        int nSlotQ;
        for (nSlotQ=1; nSlotQ<=MK_CRAFTBODY_NUMBER_OF_SLOTS; nSlotQ++)
        {
            if (MK_GetIsUsedSaveBodySlot(oCreature, nSlotQ))
            {
                return TRUE;
            }
        }
        return FALSE;
    }
}

string MK_GetSaveBodyPartString(object oCreature, int nBodyPart)
{
    string sSave="";
    switch (nBodyPart)
//    switch (MK_GetBodyPartToBeModified(oCreature))
    {
    case MK_CRAFTBODY_HEAD:
        sSave = IntToString(GetCreatureBodyPart(CREATURE_PART_HEAD, oCreature));
        break;
    case MK_CRAFTBODY_BODY:
        {
            int i;
            for (i=0; i<=17; i++)
            {
                sSave+=MK_IntToString(GetCreatureBodyPart(i,oCreature),3);
            }
        }
        break;
    case MK_CRAFTBODY_COLOR:
        {
            int i;
            int nColorChannel;
            for (i=0; i<=3; i++)
            {
                sSave+=MK_IntToString(GetColor(oCreature, i),3);
            }
        }
        break;
    case MK_CRAFTBODY_TAIL:
        sSave = IntToString(GetCreatureTailType(oCreature));
        break;
    case MK_CRAFTBODY_WINGS:
        sSave = IntToString(GetCreatureWingType(oCreature));
        break;
    case MK_CRAFTBODY_PHENOTYPE:
        sSave = IntToString(GetPhenoType(oCreature));
        break;
    case MK_CRAFTBODY_HORSE:
        sSave = MK_IntToString(GetPhenoType(oCreature),3)
              + MK_IntToString(GetCreatureTailType(oCreature),3);
        break;
    case MK_CRAFTBODY_PORTRAIT:
        {
            int nId = GetPortraitId(oCreature);
            if (nId!=PORTRAIT_INVALID)
            {
                sSave="ID="+IntToString(nId);
            }
            else
            {
                sSave="ResRef="+GetPortraitResRef(oCreature);
            }
        }
        break;
    }
    return sSave;
}

void MK_RestoreBodyPartFromString(object oCreature, int nBodyPart, string sSaveString, float fDelay)
{
    switch (nBodyPart)
    {
    case MK_CRAFTBODY_HEAD:
        SetCreatureBodyPart(CREATURE_PART_HEAD, StringToInt(sSaveString), oCreature);
        break;
    case MK_CRAFTBODY_BODY:
        {
            int i;
            int nNewBodyPart;
            int nCurrentBodyPart;
            for (i=0; i<=17; i++)
            {
                nNewBodyPart = StringToInt(GetSubString(sSaveString,i*3,3));
                nCurrentBodyPart = GetCreatureBodyPart(i, oCreature);

                if (nNewBodyPart!=nCurrentBodyPart)
                {
                    SetCreatureBodyPart(
                        i,
                        nNewBodyPart,
                        oCreature);
                    ActionPauseConversation();
                    ActionWait(fDelay);
                    ActionResumeConversation();
                }
            }
        }
        break;
    case MK_CRAFTBODY_COLOR:
        {
            int i, nNewColor, nCurrentColor;
            for (i=0; i<=3; i++)
            {
                nNewColor = StringToInt(GetSubString(sSaveString,i*3,3));
                nCurrentColor = GetColor(oCreature, i);

                if (nNewColor!=nCurrentColor)
                {
                    SetColor(oCreature, i, nNewColor);

                    ActionPauseConversation();
                    ActionWait(fDelay);
                    ActionResumeConversation();
                }
            }
        }
        break;
    case MK_CRAFTBODY_TAIL:
        SetCreatureTailType(StringToInt(sSaveString), oCreature);
        break;
    case MK_CRAFTBODY_WINGS:
        SetCreatureWingType(StringToInt(sSaveString), oCreature);
        break;
    case MK_CRAFTBODY_PHENOTYPE:
        SetPhenoType(StringToInt(sSaveString), oCreature);
        break;
    case MK_CRAFTBODY_HORSE:
        SetCreatureTailType(StringToInt(GetStringRight(sSaveString,3)), oCreature);
        SetPhenoType(StringToInt(GetStringLeft(sSaveString,3)), oCreature);
        break;
    case MK_CRAFTBODY_PORTRAIT:
        {
            if (GetStringLeft(sSaveString,3)=="ID=")
            {
                int nId = StringToInt(GetSubString(sSaveString,3,GetStringLength(sSaveString)-3));
                SetPortraitId(oCreature,nId);
            }
            else if (GetStringLeft(sSaveString,7)=="ResRef=")
            {
                string sResRef = GetSubString(sSaveString,7,GetStringLength(sSaveString)-7);
                SetPortraitResRef(oCreature, sResRef);
            }
        }
        break;
    }
}

/*
void MK_RestoreBodyPart(object oCreature)
{
    string sSave=GetLocalString(oCreature, MK_CRAFTBODY_SAVE);
    int nBodyPart = MK_GetBodyPartToBeModified(oCreature);

    MK_RestoreBodyPartFromString(oCreature, nBodyPart, sSave);

//    MK_CleanUpBodyPart(oCreature);
}
*/

/*
int MK_GetIsBodyModified(object oCreature)
{
    int bModified=FALSE;

    int nBodyPart = MK_GetBodyPartToBeModified(oCreature);
    if (nBodyPart==MK_CRAFTBODY_SAVERESTORE)
    {
        bModified = !MK_CompareBody(oCreature, 0);
    }
    else
    {
        bModified =
            (MK_GetSaveBodyPartString(oCreature, nBodyPart) != GetLocalString(oCreature, MK_CRAFTBODY_SAVE));
    }
    return bModified;
}
*/

void MK_CleanUpBodyPart(object oPC, object oTarget)
{
//    DeleteLocalString(oTarget, MK_CRAFTBODY_SAVE);
    DeleteLocalInt(oPC, MK_CRAFTBODY_SUB);
    DeleteLocalInt(oPC, MK_CRAFTBODY_CURRENT);
    DeleteLocalInt(oPC, "MK_PORTRAIT_MAX_ID");
    DeleteLocalInt(oPC, "MK_CUSTOM_MAX_ID");
    DeleteLocalInt(oPC, "MK_CURRENT_CUSTOM_PORTRAIT");

    int i;
    for (i=0; i<=17; i++)
    {
        string sColumn = Get2DAString("capart","MDLNAME",i);
        if (sColumn!="")
        {
            DeleteLocalInt(oPC, "MK_"+sColumn+"_MAX_ID");
        }
    }
    for (i=1; i<=MK_CRAFTBODY_NUMBER_OF_BODYPARTS; i++)
    {
//        DeleteLocalInt(oPC, "MK_SaveSlot00_Part"+MK_IntToString(i,2,"0"));
        DeleteLocalInt(oPC, MK_BODY_GetVarName(0, i));
    }
}

void MK_DoneBodyPart(object oPC, object oTarget)
{
    MK_CleanUpBodyPart(oPC, oTarget);
}

string MK_GetBodyPartName(int nPartToBeModified, int nBodyPart)
{
    string s2DA = "";
    string sColumn = "";

    switch (nPartToBeModified)
    {
    case MK_CRAFTBODY_HEAD:
        break;
    case MK_CRAFTBODY_BODY:
        break;
    case MK_CRAFTBODY_TAIL:
        s2DA = "TailModel";
        sColumn = "Label";
        break;
    case MK_CRAFTBODY_HORSE:
        s2DA = "TailModel";
        sColumn = "Label";
        break;
    case MK_CRAFTBODY_WINGS:
        s2DA = "WingModel";
        sColumn = "Label";
        break;
    case MK_CRAFTBODY_PHENOTYPE:
        s2DA = "PhenoType";
        sColumn = "Label";
        break;
    case MK_CRAFTBODY_PORTRAIT:
        s2DA = "Portraits";
        sColumn = "BaseResRef";
        break;
    case MK_CRAFTBODY_COLOR:
        break;
    }

    string sPartName = "";

    if ((s2DA!="") && (sColumn!=""))
    {
        sPartName = Get2DAString(s2DA, sColumn, nBodyPart);
    }
    return sPartName;
}

string MK_GetHorseName(int nHorse)
{
    string sHorseName;
    string sUser2DA = GetLocalString(GetPCSpeaker(), "MK_2DA_VALID_HORSES");
    string sColumn = "Horse";

    if (MK_GetIsValidBodyPart(MK_CRAFTBODY_HORSE, nHorse, sUser2DA, sColumn))
    {
        sHorseName=MK_GetBodyPartName(MK_CRAFTBODY_HORSE, nHorse);
    }
    else
    {
        sHorseName="No Horse";
    }
    return sHorseName;
}

string MK_GetRacialTypeAsString(object oCreature)
{
    int nRacialType = GetRacialType(oCreature);
    string sRacialType=Get2DAString("racialtypes", "Label", nRacialType);
/*
    switch (nRacialType)
    {
    case RACIAL_TYPE_DWARF:
        sRacialType = "Dwarf";
        break;
    case RACIAL_TYPE_ELF:
        sRacialType = "Elf";
        break;
    case RACIAL_TYPE_GNOME:
        sRacialType = "Gnome";
        break;
    case RACIAL_TYPE_HALFELF:
        sRacialType = "Halfelf";
        break;
    case RACIAL_TYPE_HALFLING:
        sRacialType = "Halfling";
        break;
    case RACIAL_TYPE_HALFORC:
        sRacialType = "Halforc";
        break;
    case RACIAL_TYPE_HUMAN:
        sRacialType = "Human";
        break;
    default:
        sRacialType = IntToString(nRacialType);
        break;
    }
*/
    return sRacialType;
}

string MK_GetGenderAsString(object oCreature)
{
    string sGender="";
    int nGender = GetGender(oCreature);
    switch (nGender)
    {
    case GENDER_FEMALE:
        sGender = "Female";
        break;
    case GENDER_MALE:
        sGender = "Male";
        break;
    }
    return sGender;
}

int MK_GetIsValidBodyPart(int nPartToBeModified, int nBodyPart, string sUser2DA, string sColumn,
    string sUser2DA2, string sColumn2)
{
    string sPartName = MK_GetBodyPartName(nPartToBeModified, nBodyPart);

    int bOk = FALSE;
    switch (nPartToBeModified)
    {
    case MK_CRAFTBODY_HEAD:
        bOk = TRUE;
        break;
    case MK_CRAFTBODY_BODY:
        bOk = TRUE;
        break;
    case MK_CRAFTBODY_TAIL:
        bOk = (sPartName!="");
        break;
    case MK_CRAFTBODY_WINGS:
        bOk = (sPartName!="");
        break;
    case MK_CRAFTBODY_PHENOTYPE:
        bOk = (sPartName!="");
        break;
    case MK_CRAFTBODY_HORSE:
        bOk = TRUE;
        break;
    case MK_CRAFTBODY_PORTRAIT:
        bOk = TRUE;
        break;
    case MK_CRAFTBODY_COLOR:
        bOk = TRUE;
        break;
    }

    if ((bOk) && ((sUser2DA!="") || (sUser2DA2!="")))
    {
        bOk = ((sUser2DA !="") && (StringToInt(Get2DAString(sUser2DA,  sColumn,  nBodyPart))>0))
                    ||
              ((sUser2DA2!="") && (StringToInt(Get2DAString(sUser2DA2, sColumn2, nBodyPart))>0));
    }

//    MK_DEBUG_TRACE("> MK_GetIsValidBodyPart: nBodyPart="+IntToString(nBodyPart)+", bOk="+IntToString(bOk));
    return bOk;
}

int MK_GetMaxBodyPart(object oPC, int nBodyPart)
{
//    MK_DEBUG_TRACE("MK_GetMaxBodyPart("+IntToString(nBodyPart)+")");
    switch (nBodyPart)
    {
    case MK_CRAFTBODY_HEAD:
        return GetLocalInt(oPC, "MK_HEAD_MAX_ID");
    case MK_CRAFTBODY_PORTRAIT:
        return 0;
    case MK_CRAFTBODY_COLOR:
        return 175;
    }

    string sVarName = "MK_BODYPART_"+IntToString(nBodyPart)+"_MAX_ID";

    int nMax = GetLocalInt(oPC, sVarName);

    if (nMax==0)
    {
        string s2DA="";
        string sColumn="";

        switch (nBodyPart)
        {
        case MK_CRAFTBODY_TAIL:
            s2DA = "tailmodel";
            sColumn = "LABEL";
            break;
        case MK_CRAFTBODY_HORSE:
            s2DA = MK_HORSES_Get2DAFile();
            sColumn = "Horse";
            break;
        case MK_CRAFTBODY_WINGS:
            s2DA = "wingmodel";
            sColumn = "LABEL";
            break;
        case MK_CRAFTBODY_PHENOTYPE:
            s2DA = "phenotype";
            sColumn = "Label";
            break;
        case MK_CRAFTBODY_PORTRAIT:
            break;
        }
//        MK_DEBUG_TRACE(" > nMax="+IntToString(nMax)+", 2DA="+s2DA+", Column="+sColumn);

        if ((s2DA!="") && (sColumn!=""))
        {
            nMax = MK_Get2DALength(s2DA, sColumn, GetLocalInt(oPC, "MK_2DA_MAX_HOLE_SIZE"));
            SetLocalInt(oPC, sVarName, nMax);
        }
    }
    return nMax;
}

void MK_SwapTattooColors(object oPC)
{
    if (!GetIsObjectValid(oPC))
    {
        return;
    }
    int nColor1 = GetColor(oPC, COLOR_CHANNEL_TATTOO_1);
    int nColor2 = GetColor(oPC, COLOR_CHANNEL_TATTOO_2);
    SetColor(oPC, COLOR_CHANNEL_TATTOO_1, nColor2);
    MK_SetColor(oPC, COLOR_CHANNEL_TATTOO_2, nColor1);
}

void MK_NewBodyPart(object oCreature, int nMode, object oPC)
{
//    MK_DEBUG_TRACE("MK_NewBodyPart("+GetName(oCreature)+", "+IntToString(nMode)+", "+GetName(oPC)+")");
    if (!GetIsObjectValid(oPC)) oPC = oCreature;

    int nBodyPartToBeModified = MK_GetBodyPartToBeModified(oPC);
    int nSubPartToBeModified = MK_GetSubPartToBeModified(oPC);

    int nMin = 0;
    int nMax = 0;

    switch (nBodyPartToBeModified)
    {
    case MK_CRAFTBODY_BODY:
        nMax = MK_GetMaxBodyPartID(oPC, nSubPartToBeModified);
        break;
    default:
        nMax = MK_GetMaxBodyPart(oPC, nBodyPartToBeModified);
        break;
    }
//    MK_DEBUG_TRACE(" > nMax = "+IntToString(nMax));

    int nBodyPart = MK_GetBodyPart(oCreature, oPC, nBodyPartToBeModified, nSubPartToBeModified);

    string sUser2DA="";
    string sColumn="Default";
    string sUser2DA2="";
    string sColumn2="";

    switch (nBodyPartToBeModified)
    {
    case MK_CRAFTBODY_HEAD:
    {
        int nCurrentFilter = GetLocalInt(oPC, MK_CRAFTBODY_HEAD_FILTER);
//        MK_DEBUG_TRACE("MK_NewBodyPart: nCurrentFilter="+IntToString(nCurrentFilter));
        switch (nCurrentFilter)
        {
        case 0:
            sUser2DA = "";
            sUser2DA2 = "";
            break;
        case 1:
            sUser2DA = "MK_HEADS_DEFAULT";
            sUser2DA2 = "";
            break;
        case 2:
            sUser2DA = GetLocalString(oCreature, "MK_2DA_VALID_HEADS");
            sUser2DA2 = "";
            break;
        case 3:
            sUser2DA = "";
            sUser2DA2 = "cepheadmodel";
            break;
        case 4:
            sUser2DA = GetLocalString(oCreature, "MK_2DA_VALID_HEADS");
            sUser2DA2 = "cepheadmodel";
            break;
        }

        sColumn = MK_GetRacialTypeAsString(oCreature)+"_"+MK_GetGenderAsString(oCreature);
        sColumn2 = MK_BODY_GetCEPHeadColumn(oCreature);
        break;
    }
    case MK_CRAFTBODY_TAIL:
        sUser2DA = GetLocalString(oPC, "MK_2DA_VALID_TAILS");
        break;
    case MK_CRAFTBODY_WINGS:
        sUser2DA = GetLocalString(oPC, "MK_2DA_VALID_WINGS");
        break;
    case MK_CRAFTBODY_PHENOTYPE:
        sUser2DA = GetLocalString(oPC, "MK_2DA_VALID_PHENOTYPES");
        break;
    case MK_CRAFTBODY_HORSE:
        sUser2DA = GetLocalString(oPC, "MK_2DA_VALID_HORSES");
        sColumn = "Horse";
        break;
    }

//    MK_DEBUG_TRACE(" > sUser2DA='"+sUser2DA+"', sCol='"+sColumn+"', sUser2DA2='"+sUser2DA2+"', sCol2='"+sColumn2+"'");

    do
    {
        switch (nMode)
        {
        case MK_CRAFTBODY_NEXT:
            if (++nBodyPart>nMax) nBodyPart=nMin;
            break;
        case MK_CRAFTBODY_PREV:
            if (--nBodyPart<nMin) nBodyPart=nMax;
            break;
        case MK_CRAFTBODY_CLEAR:
            nBodyPart = nMin;
            break;
        }
//        MK_DEBUG_TRACE(" > nBodyPart = "+IntToString(nBodyPart));
    }
    while (!MK_GetIsValidBodyPart(nBodyPartToBeModified, nBodyPart, sUser2DA, sColumn, sUser2DA2, sColumn2) && (nMode != MK_CRAFTBODY_CLEAR));

//    MK_DEBUG_TRACE("MK_NewBodyPart: nMode = "+IntToString(nMode)
//        +", nBodyPart="+IntToString(nBodyPart)
//        +", nBodyPartToBeModified="+IntToString(nBodyPartToBeModified)
//        +", nSubPartToBeModified="+IntToString(nSubPartToBeModified));

    MK_SetBodyPart(nBodyPart,oCreature,nBodyPartToBeModified,nSubPartToBeModified);

    return;
}

void MK_SetBodyPartTokens(object oPC, object oTarget)
{
    if (!GetIsObjectValid(oTarget))
    {
        oTarget = oPC;
    }
    int nToBeModified = MK_GetBodyPartToBeModified(oPC);
    int nSubPartToBeModified = MK_GetSubPartToBeModified(oPC);

//    MK_DEBUG_TRACE("MK_SetBodyPartTokens: nToBeModified="+IntToString(nToBeModified)+
//        ", nSubPartToBeModified="+IntToString(nSubPartToBeModified));

    string sBodyPart="";
    string sPartName="";

    int nBodyPart = MK_GetBodyPart(oTarget, oPC, nToBeModified,
        nSubPartToBeModified);

//    MK_DEBUG_TRACE("MK_SetBodyPartTokens: nToBeModified="+IntToString(nToBeModified)+
//        ", nSubPartToBeModified="+IntToString(nSubPartToBeModified)+
//        ", nBodyPart="+IntToString(nBodyPart));

    switch (nToBeModified)
    {
    case MK_CRAFTBODY_BODY:
        nBodyPart = MK_BodyPart_ID2Model(
            nSubPartToBeModified,
            nBodyPart);
        sBodyPart = IntToString(nBodyPart);
        break;
    case MK_CRAFTBODY_PORTRAIT:
        if (nBodyPart==PORTRAIT_INVALID)
        {
            nBodyPart=MK_GetCustomPortraitId(oTarget, oPC);
            sBodyPart=(nBodyPart==PORTRAIT_INVALID ? "-" : IntToString(nBodyPart)+"C");
            sPartName = GetPortraitResRef(oTarget);
        }
        else
        {
            sBodyPart=IntToString(nBodyPart);
            sPartName = MK_GetBodyPartName(nToBeModified,nBodyPart);
        }
        break;
    default:
        sPartName = MK_GetBodyPartName(nToBeModified,nBodyPart);
        sBodyPart = IntToString(nBodyPart);
    }

//    MK_DEBUG_TRACE("> nBodyPart="+IntToString(nBodyPart)+
//        ", sPartName="+sPartName+", sBodyPart="+sBodyPart);
    MK_SetBodyPartTokens2(sPartName, sBodyPart);
}

void MK_SetBodyPartTokens2(string sPartName, string sBodyPart)
{
    SetCustomToken(MK_CRAFTBODY_TOKEN_NAME, sPartName);
    SetCustomToken(MK_CRAFTBODY_TOKEN_NUMBER, sBodyPart);
}

int MK_GetMaxPortraitId(object oPC, int bCustom=FALSE)
{
    string sVarName = (bCustom ? "MK_CUSTOM_MAX_ID" : "MK_PORTRAIT_MAX_ID");

    int nMax = GetLocalInt(oPC, sVarName);
    if (nMax==0)
    {
        string s2DA = (bCustom ? "MK_Portraits" : "Portraits");
        int bContinue=TRUE;
        int nEmpty=1;
        int nMaxEmpty = GetLocalInt(oPC, "MK_2DA_MAX_HOLE_SIZE");
        while (bContinue)
        {
            if (Get2DAString(s2DA, "BaseResRef", nMax+nEmpty)!="")
            {
                nMax+=nEmpty;
                nEmpty=1;
            }
            else
            {
                nEmpty++;
            }
            bContinue = (nEmpty<=nMaxEmpty);
        }
        SetLocalInt(oPC, sVarName, nMax);
    }
    return nMax;
}

int MK_GetPortraitIdFromResRef(object oPC, string sResRef, int bCustom=FALSE)
{
    int nMin = 1;
    int nMax = MK_GetMaxPortraitId(oPC, bCustom);

    int bFound=FALSE;
    string sResRef0=GetStringLowerCase(sResRef);
    string sResRef1;

    string s2DA = (bCustom ? "MK_Portraits" : "Portraits");

    int iId=nMin-1;
    while ((!bFound) && (iId<nMax))
    {
        sResRef1=GetStringLowerCase(
            Get2DAString(s2DA, "BaseResRef", ++iId));
        bFound = (sResRef0==sResRef1);
    }

    if (!bFound)
    {
        iId = PORTRAIT_INVALID;
    }
    return iId;
}

int MK_GetPortraitId(object oTarget, object oPC)
{
    int nId = GetPortraitId(oTarget);

    if (nId==PORTRAIT_INVALID)
    {
        string sResRef = GetPortraitResRef(oTarget);

        if (sResRef!="")
        {
            if (GetStringLowerCase(GetStringLeft(sResRef,3))=="po_")
            {
                sResRef=GetSubString(sResRef,3,GetStringLength(sResRef)-3);
                nId = MK_GetPortraitIdFromResRef(oPC, sResRef);
            }
        }
    }
    return nId;
}

int MK_GetCustomPortraitId(object oTarget, object oPC)
{
    int nId = PORTRAIT_INVALID;

    string sResRef = GetPortraitResRef(oTarget);
    if (sResRef!="")
    {
        nId = MK_GetPortraitIdFromResRef(oPC, sResRef, TRUE);
    }
    return nId;
}



void MK_NewPortrait(object oCreature, int nMode, object oPC)
{
    int bCustom = (nMode==MK_PORTRAIT_RESREF_NEXT)||(nMode==MK_PORTRAIT_RESREF_PREV);
    int nMin = 1;
    int nMax = MK_GetMaxPortraitId(oPC, bCustom);

    string sRace = IntToString(GetRacialType(oCreature));
    string sGender = IntToString(GetGender(oCreature));

    int bIgnoreGender = GetLocalInt(oPC, "MK_PORTRAIT_IGNORE_GENDER");
    int bIgnoreRace =  GetLocalInt(oPC, "MK_PORTRAIT_IGNORE_RACE");

    int nCurrId;
    if (bCustom)
    {
        nCurrId = GetLocalInt(oCreature, "MK_CURRENT_CUSTOM_PORTRAIT");
        if ((nCurrId==PORTRAIT_INVALID) || (nCurrId==0))
        {
            nCurrId = MK_GetCustomPortraitId(oCreature, oPC);
        }
    }
    else
    {
        SetLocalInt(oCreature, "MK_CURRENT_CUSTOM_PORTRAIT", PORTRAIT_INVALID);
        nCurrId = MK_GetPortraitId(oCreature, oPC);
    }

    string s2DA = (bCustom ? "MK_Portraits" : "Portraits");
    string sColResRef = "BaseResRef";
    string sColGender = "Sex";
    string sColRace = "Race";

    int bPortraitIsValid=TRUE;

    string sResRef;

    do
    {
        switch (nMode)
        {
        case MK_PORTRAIT_ID_NEXT:
        case MK_PORTRAIT_RESREF_NEXT:
            if ((nCurrId==PORTRAIT_INVALID) || (++nCurrId > nMax))
            {
                nCurrId=nMin;
            }
            break;
        case MK_PORTRAIT_ID_PREV:
        case MK_PORTRAIT_RESREF_PREV:
            if ((nCurrId==PORTRAIT_INVALID) || (--nCurrId < nMin))
            {
                nCurrId=nMax;
            }
            break;
        }
        sResRef = Get2DAString(s2DA, sColResRef, nCurrId);
        bPortraitIsValid = (sResRef!="");

        bPortraitIsValid&=((bIgnoreGender)|(Get2DAString(s2DA, sColGender, nCurrId)==sGender));
        bPortraitIsValid&=((bIgnoreRace)|(Get2DAString(s2DA, sColRace, nCurrId)==sGender));
    }
    while (!bPortraitIsValid);

    if (bCustom)
    {
        SetPortraitResRef(oCreature, sResRef);
    }
    else
    {
        SetPortraitId(oCreature, nCurrId);
    }
}

int MK_GetMaxBodyPartID(object oPC, int nCreaturePart)
{
    string sColumn = Get2DAString("capart", "MDLNAME", nCreaturePart);
    if (sColumn=="") return -1;

    string sVarName = "MK_"+sColumn+"_MAX_ID";
    int nMax = GetLocalInt(oPC, sVarName);

    if (nMax==0)
    {
        string s2DA = "MK_BodyParts";
        int bContinue=TRUE;
        int nEmpty=1;
        int nMaxEmpty=1;
        while (bContinue)
        {
            if (Get2DAString(s2DA, sColumn, nMax+nEmpty)!="")
            {
                nMax+=nEmpty;
                nEmpty=1;
            }
            else
            {
                nEmpty++;
            }
            bContinue = (nEmpty<=nMaxEmpty);
        }
        SetLocalInt(oPC, sVarName, nMax);
    }
    return nMax;
}



string MK_BODY_GetCEPHeadColumn(object oTarget)
{
    int nRacialType = GetRacialType(oTarget);
    string sGender = MK_GetGenderAsString(oTarget);
//    MK_DEBUG_TRACE("MK_BODY_GetCEPHeadColumn: sGender='"+sGender+"', nRacialType="+IntToString(nRacialType));
    string sColumn = Get2DAString("mk_head_cep_col", "Label_"+sGender, nRacialType);
//    MK_DEBUG_TRACE("MK_BODY_GetCEPHeadColumn: sCol='"+sColumn+"'");
    return sColumn;
}

int MK_BODY_GetCEPHeadFilterExists(object oTarget)
{
    string sCol = MK_BODY_GetCEPHeadColumn(oTarget);
    return (StringToInt(Get2DAString("cepheadmodel", sCol, 1))!=0);
}

/*
void main()
{

}
/**/
