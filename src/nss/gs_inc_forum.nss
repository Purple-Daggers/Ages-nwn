/* FORUM Library by Gigaschatten */

#include "gs_inc_pc"

//void main() {};

const int GS_FO_LIMIT = 100;

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
    string sDatabase  = "GS_FO_" + GetTag(oForum);
    string sMessageID = "";
    string sOwner     = "";
    string sNth       = "";
    int nNth          = 1;

    SetLocalInt(oForum, "GS_FO_OFFSET", GetCampaignInt(sDatabase, "OFFSET"));

    for (; nNth <= GS_FO_LIMIT; nNth++)
    {
        sNth       = IntToString(nNth);
        sMessageID = GetCampaignString(sDatabase, "MESSAGE_" + sNth);

        if (sMessageID != "")
        {
            sOwner = GetCampaignString(sDatabase, sMessageID + "_OWNER");

            SetLocalString(oForum, "GS_FO_MESSAGE_" + sNth, sMessageID);
            SetLocalString(oForum, "GS_FO_" + sMessageID + "_OWNER", sOwner);
        }
    }
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

    string sDatabase = "GS_FO_" + GetTag(oForum);
    string sPlayerID = gsPCGetPlayerID(oOwner);

    nNth             = GetLocalInt(oForum, "GS_FO_OFFSET") + 1;
    if (nNth > GS_FO_LIMIT) nNth -= GS_FO_LIMIT;
    sNth             = IntToString(nNth);

    SetLocalInt(oForum, "GS_FO_OFFSET", nNth);
    SetLocalString(oForum, "GS_FO_MESSAGE_" + sNth, sMessageID);
    SetLocalString(oForum, "GS_FO_" + sMessageID + "_OWNER", sPlayerID);
    SetCampaignInt(sDatabase, "OFFSET", nNth);
    SetCampaignString(sDatabase, "MESSAGE_" + sNth, sMessageID);
    SetCampaignString(sDatabase, sMessageID + "_OWNER", sPlayerID);

    return TRUE;
}
//----------------------------------------------------------------
void gsFORemoveMessage(string sMessageID, object oForum = OBJECT_SELF)
{
    string sDatabase = "GS_FO_" + GetTag(oForum);
    string sNth      = "";
    int nNth         = 1;

    for (; nNth <= GS_FO_LIMIT; nNth++)
    {
        sNth = IntToString(nNth);

        if (GetLocalString(oForum, "GS_FO_MESSAGE_" + sNth) == sMessageID)
        {
            DeleteLocalString(oForum, "GS_FO_MESSAGE_" + sNth);
            SetCampaignString(sDatabase, "MESSAGE_" + sNth, "");
            return;
        }
    }
}
