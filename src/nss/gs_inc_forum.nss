/* FORUM Library by Jamesfelicia, modified from Gigaschatten's forum library.*/

#include "gs_inc_pc"
#include "gs_inc_time"

//void main() {};

const int GS_FO_LIMIT = 35;
const int GS_FO_TRUELIMIT = 100;

//load content of oForum from database
void gsFOLoadContent(object oForum = OBJECT_SELF);
//return message id at nPosition from oForum
string gsFOGetMessage(int nPosition = 0, object oForum = OBJECT_SELF);
//return position of first message at or after nPosition in oForum, return -1 if at end
int gsFOGetFirstMessage(int nPosition = 0, object oForum = OBJECT_SELF);
//internally used
int _gsFOGetFirstMessage(int nPosition, object oForum, int nStep = 1);
//return position of message following nPosition in oForum, return -1 if at end
int gsFOGetNextMessage(int nPosition = 0, object oForum = OBJECT_SELF);
//return position of message preceding nPosition in oForum, return -1 if at start
int gsFOGetPreviousMessage(int nPosition = 0, object oForum = OBJECT_SELF);
//return owner id of sMessageID from oForum
string gsFOGetOwner(string sMessageID, object oForum = OBJECT_SELF);
//return true on successfully posting sMessageID to oForum by oOwner
int gsFOPostMessage(string sMessageID, object oOwner, object oForum = OBJECT_SELF);
//remove sMessageID from oForum
void gsFORemoveMessage(string sMessageID, object oForum = OBJECT_SELF);

void gsFOLoadContent(object oForum = OBJECT_SELF)
{
    string sDatabase = "GS_FO_FORUMS";
    string sForumID = "";
    if(GetLocalString(oForum, "GS_FX_ID") == "" && GetLocalString(oForum, "GS_NB_ID") == "")
    {
        sForumID  = "GS_FO_" + GetTag(oForum);
    }
    else if(GetLocalString(oForum, "GS_NB_ID") == "")
    {
        sForumID = "GS_FO_" + GetLocalString(oForum, "GS_FX_ID");
    }
    else
    {
        sForumID = "GS_FO_" + GetLocalString(oForum, "GS_NB_ID");
    } 

    string sMessageID = "";
    string sOwner     = "";
    string sNth       = "";
    int nNth          = 1;

    sqlquery sqlGetNotes = SqlPrepareQueryCampaign(sDatabase, "SELECT message_id, message_poster, message_owner FROM (SELECT message_id, message_poster, message_owner, timestamp FROM forum_messages WHERE forum_id = @forum_id ORDER BY timestamp DESC LIMIT " + IntToString(GS_FO_LIMIT) + ") ORDER BY timestamp ASC LIMIT " + IntToString(GS_FO_LIMIT) + ";");
    SqlBindString(sqlGetNotes, "@forum_id", sForumID);
    while(SqlStep(sqlGetNotes))
    {
        string sNth = IntToString(nNth);
        sMessageID = SqlGetString(sqlGetNotes, 0);
        sOwner = SqlGetString(sqlGetNotes, 1);
        SetLocalString(oForum, "GS_FO_MESSAGE_" + sNth, sMessageID);
        SetLocalString(oForum, "GS_FO_" + sMessageID + "_OWNER", sOwner);
        SetLocalString(oForum, "GS_FO_" + sMessageID + "_INDEX", sNth);
        SetLocalInt(oForum, "GS_FO_OFFSET", nNth);
        nNth++;
    }
}

void gsFODeleteContent(object oForum = OBJECT_SELF)
{
    string sMessageID = "";
    string sNth       = "";
    int nNth          = 1;

    for (; nNth <= GS_FO_TRUELIMIT; nNth++)
    {
        sNth       = IntToString(nNth);
        sMessageID = GetLocalString(oForum, "GS_FO_MESSAGE_" + sNth);

        if (sMessageID != "")
        {
            DeleteLocalString(oForum, "GS_FO_MESSAGE_" + sNth);
            DeleteLocalString(oForum, "GS_FO_" + sMessageID + "_OWNER");
            DeleteLocalString(oForum, "GS_FO_" + sMessageID + "_INDEX");
        }
    }

    DeleteLocalInt(oForum, "GS_FO_OFFSET");
    //DeleteLocalString(oForum, "GS_FX_ID");
    DeleteLocalInt(oForum, "GS_FO_ENABLED");
}

//----------------------------------------------------------------
string gsFOGetMessage(int nPosition = 0, object oForum = OBJECT_SELF)
{
    if (nPosition < 0)            return "";
    if (nPosition >= GS_FO_LIMIT) return "";

    nPosition = GetLocalInt(oForum, "GS_FO_OFFSET") - nPosition;
    if (nPosition < 1)            nPosition += GS_FO_LIMIT;

    return GetLocalString(oForum, "GS_FO_MESSAGE_" + IntToString(nPosition));
}
//----------------------------------------------------------------
int gsFOGetFirstMessage(int nPosition = 0, object oForum = OBJECT_SELF)
{
    return _gsFOGetFirstMessage(nPosition, oForum);
}
//----------------------------------------------------------------
int _gsFOGetFirstMessage(int nPosition, object oForum, int nStep = 1)
{
    string sMessageID = "";

    for (; nPosition >= 0 && nPosition < GS_FO_LIMIT; nPosition += nStep)
    {
        sMessageID = gsFOGetMessage(nPosition, oForum);
        if (sMessageID != "") return nPosition;
    }

    return -1;
}
//----------------------------------------------------------------
int gsFOGetNextMessage(int nPosition = 0, object oForum = OBJECT_SELF)
{
    return _gsFOGetFirstMessage(nPosition + 1, oForum);
}
//----------------------------------------------------------------
int gsFOGetPreviousMessage(int nPosition = 0, object oForum = OBJECT_SELF)
{
    return _gsFOGetFirstMessage(nPosition - 1, oForum, -1);
}
//----------------------------------------------------------------
string gsFOGetOwner(string sMessageID, object oForum = OBJECT_SELF)
{
    return GetLocalString(oForum, "GS_FO_" + sMessageID + "_OWNER");
}
//----------------------------------------------------------------
int gsFOPostMessage(string sMessageID, object oOwner, object oForum = OBJECT_SELF)
{
    string sNth      = "";
    int nNth         = 1;

    for (; nNth <= GS_FO_LIMIT; nNth++)
    {
        sNth = IntToString(nNth);
        if (GetLocalString(oForum, "GS_FO_MESSAGE_" + sNth) == sMessageID) return FALSE;
    }

    string sDatabase = "GS_FO_FORUMS";
    string sForumID = "";
    if(GetLocalString(oForum, "GS_FX_ID") == "" && GetLocalString(oForum, "GS_NB_ID") == "")
    {
        sForumID  = "GS_FO_" + GetTag(oForum);
    }
    else if(GetLocalString(oForum, "GS_NB_ID") == "")
    {
        sForumID = "GS_FO_" + GetLocalString(oForum, "GS_FX_ID");
    }
    else
    {
        sForumID = "GS_FO_" + GetLocalString(oForum, "GS_NB_ID");
    } 

    string sPlayerID = gsPCGetPlayerID(oOwner);

    nNth             = GetLocalInt(oForum, "GS_FO_OFFSET") + 1;
    if (nNth > GS_FO_TRUELIMIT) return FALSE;
    sNth             = IntToString(nNth);

    SetLocalInt(oForum, "GS_FO_OFFSET", nNth);
    SetLocalString(oForum, "GS_FO_MESSAGE_" + sNth, sMessageID);
    SetLocalString(oForum, "GS_FO_" + sMessageID + "_OWNER", sPlayerID);

    sqlquery sqlInsertMessage = SqlPrepareQueryCampaign(sDatabase, "INSERT INTO forum_messages (forum_id, message_id, timestamp, message_poster, message_owner) VALUES (@forum_id, @message_id, @timestamp, @message_poster, @message_owner);");
    SqlBindString(sqlInsertMessage, "@forum_id", sForumID);
    SqlBindString(sqlInsertMessage, "@message_id", sMessageID);
    SqlBindInt(sqlInsertMessage, "@timestamp", gsTIGetActualTimestamp());
    SqlBindString(sqlInsertMessage, "@message_poster", sPlayerID);
    SqlBindString(sqlInsertMessage, "@message_owner", sPlayerID);
    SqlStep(sqlInsertMessage);
    return TRUE;
}
//----------------------------------------------------------------
void gsFORemoveMessage(string sMessageID, object oForum = OBJECT_SELF)
{
    string sDatabase = "GS_FO_FORUMS";
    string sForumID = "";
    if(GetLocalString(oForum, "GS_FX_ID") == "" && GetLocalString(oForum, "GS_NB_ID") == "")
    {
        sForumID  = "GS_FO_" + GetTag(oForum);
    }
    else if(GetLocalString(oForum, "GS_NB_ID") == "")
    {
        sForumID = "GS_FO_" + GetLocalString(oForum, "GS_FX_ID");
    }
    else
    {
        sForumID = "GS_FO_" + GetLocalString(oForum, "GS_NB_ID");
    } 

    string sNth      = "";
    int nNth         = 1;

    sqlquery sqlDeleteMessage = SqlPrepareQueryCampaign(sDatabase, "DELETE FROM forum_messages WHERE forum_id = @forum_id AND message_id = @message_id;");
    SqlBindString(sqlDeleteMessage, "@forum_id", sForumID);
    SqlBindString(sqlDeleteMessage, "@message_id", sMessageID);
    SqlStep(sqlDeleteMessage);
    gsFODeleteContent(oForum);
}
