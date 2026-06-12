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
    sqlquery sqlCreateTable = SqlPrepareQueryCampaign("GS_MESSAGE", "CREATE TABLE IF NOT EXISTS messages (id TEXT PRIMARY KEY, timestamp INTEGER, title TEXT, text TEXT, author TEXT, author_id TEXT);");
    SqlStep(sqlCreateTable);

    sqlquery sqlInsertMessage = SqlPrepareQueryCampaign("GS_MESSAGE", "INSERT INTO messages (id, timestamp, title, text, author, author_id) VALUES (@id, @timestamp, @title, @text, @author, @author_id);");
    SqlBindString(sqlInsertMessage, "@id", sMessageID);
    SqlBindInt(sqlInsertMessage, "@timestamp", gsTIGetActualTimestamp());
    SqlBindString(sqlInsertMessage, "@title", sTitle);
    SqlBindString(sqlInsertMessage, "@text", sText);
    SqlBindString(sqlInsertMessage, "@author", GetName(oAuthor));
    SqlBindString(sqlInsertMessage, "@author_id", gsPCGetPlayerID(oAuthor));
    SqlStep(sqlInsertMessage);
}
//----------------------------------------------------------------
int gsMEGetTimestamp(string sMessageID)
{
    sqlquery sqlGetTimestamp = SqlPrepareQueryCampaign("GS_MESSAGE", "SELECT timestamp FROM messages WHERE id = @id;");
    SqlBindString(sqlGetTimestamp, "@id", sMessageID);
    if(SqlStep(sqlGetTimestamp)){
        return SqlGetInt(sqlGetTimestamp, 0);
    }
    else {
        return 0;
    }
}
//----------------------------------------------------------------
string gsMEGetTitle(string sMessageID)
{
    sqlquery sqlGetTitle = SqlPrepareQueryCampaign("GS_MESSAGE", "SELECT title FROM messages WHERE id = @id;");
    SqlBindString(sqlGetTitle, "@id", sMessageID);
    if(SqlStep(sqlGetTitle)){
        return SqlGetString(sqlGetTitle, 0);
    }
    else {
        return "";
    }
}
//----------------------------------------------------------------
string gsMEGetText(string sMessageID)
{
    sqlquery sqlGetText = SqlPrepareQueryCampaign("GS_MESSAGE", "SELECT text FROM messages WHERE id = @id;");
    SqlBindString(sqlGetText, "@id", sMessageID);
    if(SqlStep(sqlGetText)){
        return SqlGetString(sqlGetText, 0);
    }
    else {
        return "";
    }
}
//----------------------------------------------------------------
string gsMEGetAuthor(string sMessageID)
{
    sqlquery sqlGetAuthor = SqlPrepareQueryCampaign("GS_MESSAGE", "SELECT author FROM messages WHERE id = @id;");
    SqlBindString(sqlGetAuthor, "@id", sMessageID);
    if(SqlStep(sqlGetAuthor)){
        return SqlGetString(sqlGetAuthor, 0);
    }
    else {
        return "";
    }
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
