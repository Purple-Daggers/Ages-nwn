#include "mk_inc_debug"

//const int MK_GENERIC_DIALOG_DEBUG = TRUE;
const int MK_GENERIC_DIALOG_DEBUG = FALSE;

const int MK_GENERIC_DIALOG_NUMBER_OF_VARIABLES = 257;

const int MK_GENERIC_DIALOG_INVALID_ACTION = -1;

const int MK_GENERIC_DIALOG_STATE_DISPLAY_TOKEN = 14400;

const string MK_DISABLED_OPTIONS_COLOR = "MK_DISABLED_OPTIONS_COLOR";

const string MK_GENERIC_ACTION_SCRIPT = "MK_GENERIC_ACTION_SCRIPT";

void MK_GenericDialog_CleanUp();

int MK_GenericDialog_SetState(int nState);

int MK_GenericDialog_GetState(int bClearState=FALSE);

int MK_GenericDialog_StateToCustomToken(int nToken);

int MK_GenericDialog_IsInState(int nState, int bClearState=FALSE);

void MK_GenericDialog_SetCondition(int nCondition, int bIsTrue);

void MK_GenericDialog_SetConditionRange(int nConditionFrom, int nConditionTo, int bTrue);

int MK_GenericDialog_GetCondition(int nCondition, int nReset=TRUE);

void MK_GenericDialog_SetObject(int nObject, object oObject);

object MK_GenericDialog_GetObject(int nObject);

void MK_GenericDialog_SetAction(int nAction);

int MK_GenericDialog_GetAction(int bClearAction=TRUE);

void MK_GenericDialog_SetCurrentPage(int nState, int nPage);

int MK_GenericDialog_GetCurrentPage(int nState);

object MK_GetObjectQ()
{
    object oReturn = GetPCSpeaker();
    if (!GetIsObjectValid(oReturn)) oReturn = OBJECT_SELF;
    return oReturn;
}

void MK_GenericDialog_DEBUG_TRACE(string sMessage)
{
    if (MK_GENERIC_DIALOG_DEBUG)
    {
        MK_DEBUG_TRACE(sMessage);
    }
}

const int MK_DELIMITER_TOKEN = 14401;
const int MK_DELIMITER_CONDITION = 256;
const string MK_USE_DELIMITER = "MK_USE_DELIMITER";
const string MK_DELIMITER_COLOR = "MK_DELIMITER_COLOR";

int MK_DELIMITER_GetUseDelimiter()
{
    return GetLocalInt(MK_GetObjectQ(), MK_USE_DELIMITER);
}


void MK_GenericDialog_CleanUp()
{
    object oObject = MK_GetObjectQ();
    SetCustomToken(MK_GENERIC_DIALOG_STATE_DISPLAY_TOKEN,"");
    int iVar;
    for (iVar=0; iVar<MK_GENERIC_DIALOG_NUMBER_OF_VARIABLES; iVar++)
    {
        DeleteLocalInt(oObject, "MK_CONDITION_"+IntToString(iVar));
        DeleteLocalObject(oObject, "MK_OBJECT_"+IntToString(iVar));
    }
    DeleteLocalInt(oObject, "MK_ACTION");
    DeleteLocalInt(oObject, "MK_STATE");

    DeleteLocalString(oObject, MK_GENERIC_ACTION_SCRIPT);
}

string MK_GenericDialog_GetActionScript(int bClearScript=TRUE)
{
    object oObject = MK_GetObjectQ();
    string sActionScript = GetLocalString(oObject, MK_GENERIC_ACTION_SCRIPT);
    if (bClearScript)
    {
        DeleteLocalString(oObject, MK_GENERIC_ACTION_SCRIPT);
    }
    return sActionScript;
}

void  MK_GenericDialog_SetActionScript(string sActionScript)
{
    object oObject = MK_GetObjectQ();
    SetLocalString(oObject, MK_GENERIC_ACTION_SCRIPT, sActionScript);
}

int MK_GenericDialog_SetState(int nState)
{
    object oObject = MK_GetObjectQ();
    int nOldState = GetLocalInt(oObject, "MK_STATE");
    MK_GenericDialog_DEBUG_TRACE("MK_GenericDialog_SetState("+IntToString(nState)+"), oldState = "+IntToString(nOldState));

    SetLocalInt(oObject, "MK_STATE", nState);
//    SetCustomToken(MK_GENERIC_DIALOG_STATE_DISPLAY_TOKEN, "MK_GenericDialog: current state = <cþ¥ >"+IntToString(nState)+"</c>\n");
    return nOldState;
}

int MK_GenericDialog_GetState(int bClearState=FALSE)
{
    object oObject = MK_GetObjectQ();
    int nState = GetLocalInt(oObject, "MK_STATE");
    if (bClearState)
    {
        MK_GenericDialog_SetState(-1);
    }
    return nState;
}

int MK_GenericDialog_IsInState(int nState, int bClearState=FALSE)
{
    return MK_GenericDialog_GetState()==nState;
}

void MK_GenericDialog_SetCondition(int nCondition, int bIsTrue)
{
//    if (nCondition==20) MK_DEBUG_TRACE("MK_GenericDialog_SetCondition("+IntToString(nCondition)+", "+IntToString(bIsTrue)+")");
    object oObject = MK_GetObjectQ();
//    MK_GenericDialog_DEBUG_TRACE("MK_GenericDialog_SetCondition("+IntToString(nCondition)+", "+IntToString(bIsTrue)+")");
    SetLocalInt(oObject, "MK_CONDITION_"+IntToString(nCondition), bIsTrue);
}

void MK_GenericDialog_SetConditionRange(int nConditionFrom, int nConditionTo, int bIsTrue)
{
    int iCondition;
    for (iCondition=nConditionFrom; iCondition<=nConditionTo; iCondition++)
    {
        MK_GenericDialog_SetCondition(iCondition, bIsTrue);
    }
}

int MK_GenericDialog_GetCondition(int nCondition, int nReset)
{
    if (nReset && (nCondition!=256)) MK_GenericDialog_DEBUG_TRACE("MK_GenericDialog_GetCondition("+IntToString(nCondition)+", "+IntToString(nReset)+")");
    object oObject = MK_GetObjectQ();
    string sVarName = "MK_CONDITION_"+IntToString(nCondition);
    int nReturn = GetLocalInt(oObject, sVarName);
//    if (nCondition==20) MK_DEBUG_TRACE(" > nReturn = "+IntToString(nReturn));
    if (nReturn)
    {
        if (nReset || (nCondition==MK_DELIMITER_CONDITION))
        {
            DeleteLocalInt(oObject, sVarName);
//            if (nCondition==20) MK_DEBUG_TRACE(" > deleting "+sVarName);
        }
        if ((nCondition!=MK_DELIMITER_CONDITION) && MK_DELIMITER_GetUseDelimiter())
        {
            MK_GenericDialog_SetCondition(MK_DELIMITER_CONDITION, TRUE);
        }
    }
    return nReturn;
}

void MK_GenericDialog_SetObject(int nObject, object oObject)
{
    object oObjectQ = MK_GetObjectQ();
    SetLocalObject(oObjectQ, "MK_OBJECT_"+IntToString(nObject), oObject);
}

object MK_GenericDialog_GetObject(int nObject)
{
    object oObject = MK_GetObjectQ();
    return GetLocalObject(oObject, "MK_OBJECT_"+IntToString(nObject));
}

void MK_GenericDialog_SetAction(int nAction)
{
    object oObject = MK_GetObjectQ();
    SetLocalInt(oObject, "MK_ACTION", nAction+1);
    string sActionScript = MK_GenericDialog_GetActionScript();
    MK_GenericDialog_DEBUG_TRACE("MK_GenericDialog_SetAction("+IntToString(nAction)+"[,'"+sActionScript+"'])");
    if (sActionScript!="")
    {
        ExecuteScript(sActionScript, oObject);
    }
}

int MK_GenericDialog_GetAction(int bClearAction=TRUE)
{
    object oObject = MK_GetObjectQ();
    int nAction = GetLocalInt(oObject, "MK_ACTION") - 1;
    if (bClearAction)
    {
        SetLocalInt(oObject, "MK_ACTION", MK_GENERIC_DIALOG_INVALID_ACTION);
    }
    return nAction;
}

void MK_GenericDialog_SetCurrentPage(int nState, int nPage)
{
    object oObject = MK_GetObjectQ();
    SetLocalInt(oObject, "MK_GENERIC_CURRENTPAGE_"+IntToString(nState), nPage);
}

int MK_GenericDialog_GetCurrentPage(int nState)
{
    object oObject = MK_GetObjectQ();
    return GetLocalInt(oObject, "MK_GENERIC_CURRENTPAGE_"+IntToString(nState));
}


/*
void main()
{

}
/**/
