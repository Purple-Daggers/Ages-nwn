/* MESSAGE Library by Gigaschatten */

#include "gs_inc_common"
#include "gs_inc_pc"
#include "gs_inc_text"
#include "gs_inc_time"

//void main() {}

//set sMessageID to sText by oAuthor described by sTitle
void gsMESetMessage(string sMessageID, string sTitle, string sText, object oAuthor = OBJECT_SELF);
//return timestamp from sMessageID
int gsMEGetTimestamp(string sMessageID);
//return title from sMessageID
string gsMEGetTitle(string sMessageID);
//return text from sMessageID
string gsMEGetText(string sMessageID);
//return author from sMessageID
string gsMEGetAuthor(string sMessageID);
//return formatted sMessageID
string gsMEGetMessage(string sMessageID);

void gsMESetMessage(string sMessageID, string sTitle, string sText, object oAuthor = OBJECT_SELF)
{
    if (! GetIsPC(oAuthor)) return;

    sMessageID = GetStringLeft(sMessageID, 16);

    SetCampaignInt("GS_MESSAGE", sMessageID + "_TIMESTAMP", gsTIGetActualTimestamp());
    SetCampaignString("GS_MESSAGE", sMessageID + "_TITLE", sTitle);
    SetCampaignString("GS_MESSAGE", sMessageID + "_TEXT", sText);
    SetCampaignString("GS_MESSAGE", sMessageID + "_AUTHOR", GetName(oAuthor));
}
//----------------------------------------------------------------
int gsMEGetTimestamp(string sMessageID)
{
    return GetCampaignInt("GS_MESSAGE", sMessageID + "_TIME");
}
//----------------------------------------------------------------
string gsMEGetTitle(string sMessageID)
{
    return GetCampaignString("GS_MESSAGE", sMessageID + "_TITLE");
}
//----------------------------------------------------------------
string gsMEGetText(string sMessageID)
{
    return GetCampaignString("GS_MESSAGE", sMessageID + "_TEXT");
}
//----------------------------------------------------------------
string gsMEGetAuthor(string sMessageID)
{
    return GetCampaignString("GS_MESSAGE", sMessageID + "_AUTHOR");
}
//----------------------------------------------------------------
string gsMEGetMessage(string sMessageID)
{

    string sString = gsMEGetTitle(sMessageID);

    if (sString != "")
    {
        int nTimestamp = gsMEGetTimestamp(sMessageID);

        return "<cþë¦>" + sString + "\n" +
               "<câÛÂ>" + gsMEGetText(sMessageID) + "\n\n" +
               "<c(”þ>        " +
               gsCMReplaceString(GS_T_16777426,
                                 IntToString(gsTIGetHour(nTimestamp)),
                                 IntToString(gsTIGetDay(nTimestamp)),
                                 IntToString(gsTIGetMonth(nTimestamp)),
                                 IntToString(gsTIGetYear(nTimestamp))) + "\n" +
               "<c(”þ>        " +
               gsMEGetAuthor(sMessageID);
    }

    return "";
}
