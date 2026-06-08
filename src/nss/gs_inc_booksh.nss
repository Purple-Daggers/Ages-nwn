/* BOOKSHELF Library by Jamesfelicia, modified from Gigaschatten's forum library. */

#include "gs_inc_pc"

//void main() {};

const int GS_BO_LIMIT = 100;

//load content of oShelf from database
void gsBOLoadContent(object oShelf = OBJECT_SELF);
//return Book id at nPosition from oShelf
string gsBOGetBook(int nPosition = 0, object oShelf = OBJECT_SELF);
//return position of first Book at or after nPosition in oShelf, return -1 if at end
int gsBOGetFirstBook(int nPosition = 0, object oShelf = OBJECT_SELF);
//internally used
int _gsBOGetFirstBook(int nPosition, object oShelf, int nStep = 1);
//return position of Book following nPosition in oShelf, return -1 if at end
int gsBOGetNextBook(int nPosition = 0, object oShelf = OBJECT_SELF);
//return position of Book preceding nPosition in oShelf, return -1 if at start
int gsBOGetPreviousBook(int nPosition = 0, object oShelf = OBJECT_SELF);
//return true on successfully posting sBookID to oShelf by oOwner
int gsBOPostBook(string sBookName, string sBookDesc, object oShelf = OBJECT_SELF);
//remove sBookID from oShelf
void gsBORemoveBook(string sBookID, object oShelf = OBJECT_SELF);

void gsBOLoadContent(object oShelf = OBJECT_SELF)
{
    string sDatabase = "";
    if(GetLocalString(oShelf, "GS_FX_ID") == "")
    {
        sDatabase  = "GS_BO_" + GetTag(oShelf);
    }
    else
    {
        sDatabase = "GS_BO_" + GetLocalString(oShelf, "GS_FX_ID");
    }

    sqlquery sqlCreateTable = SqlPrepareQueryCampaign(sDatabase, "CREATE TABLE IF NOT EXISTS books (id TEXT PRIMARY KEY, name TEXT, description TEXT, count INTEGER, notebook INTEGER);");
    SqlStep(sqlCreateTable);

    string sBookID = "";
    string sName     = "";
    string sDesc       = "";
    int nCount = 0;
    int nNotebook = FALSE;
    int nNth          = 1;

    sqlquery sqlGetBooks = SqlPrepareQueryCampaign(sDatabase, "SELECT id FROM books ORDER BY name;");
    while(SqlStep(sqlGetBooks))
    {
        string sNth = IntToString(nNth);
        sBookID = SqlGetString(sqlGetBooks, 0);
        SetLocalString(oShelf, "GS_BO_BOOK_" + sNth, sBookID);
        SetLocalInt(oShelf, "GS_FO_OFFSET", nNth);
        nNth++;
    }
}

void gsBODeleteContent(object oShelf = OBJECT_SELF)
{
    int nNth = 1;
    for (; nNth <= GS_BO_LIMIT; nNth++)
    {
        string sNth = IntToString(nNth);
        DeleteLocalString(oShelf, "GS_BO_BOOK" + sNth);
    }
}

//----------------------------------------------------------------
string gsBOGetBook(int nPosition = 0, object oShelf = OBJECT_SELF)
{
    if (nPosition < 0)            return "";
    if (nPosition >= GS_BO_LIMIT) return "";

    nPosition = GetLocalInt(oShelf, "GS_BO_OFFSET") - nPosition;
    if (nPosition < 1)            nPosition += GS_BO_LIMIT;

    return GetLocalString(oShelf, "GS_BO_BOOK_" + IntToString(nPosition));
}
//----------------------------------------------------------------
int gsBOGetFirstBook(int nPosition = 0, object oShelf = OBJECT_SELF)
{
    return _gsBOGetFirstBook(nPosition, oShelf);
}
//----------------------------------------------------------------
int _gsBOGetFirstBook(int nPosition, object oShelf, int nStep = 1)
{
    string sBookID = "";

    for (; nPosition >= 0 && nPosition < GS_BO_LIMIT; nPosition += nStep)
    {
        sBookID = gsBOGetBook(nPosition, oShelf);
        if (sBookID != "") return nPosition;
    }

    return -1;
}
//----------------------------------------------------------------
int gsBOGetNextBook(int nPosition = 0, object oShelf = OBJECT_SELF)
{
    return _gsBOGetFirstBook(nPosition + 1, oShelf);
}
//----------------------------------------------------------------
int gsBOGetPreviousBook(int nPosition = 0, object oShelf = OBJECT_SELF)
{
    return _gsBOGetFirstBook(nPosition - 1, oShelf, -1);
}
//----------------------------------------------------------------
int gsBOPostBook(string sBookName, string sBookDesc, object oShelf = OBJECT_SELF)
{
    string sNth      = "";
    int nNth         = 1;
    int nOpenSlot = -1;

    string sDatabase = "";
    if(GetLocalString(oShelf, "GS_FX_ID") == "")
    {
        sDatabase  = "GS_BO_" + GetTag(oShelf);
    }
    else
    {
        sDatabase = "GS_BO_" + GetLocalString(oShelf, "GS_FX_ID");
    }

    sqlquery sqlCreateTable = SqlPrepareQueryCampaign(sDatabase, "CREATE TABLE IF NOT EXISTS books (id TEXT PRIMARY KEY, name TEXT, description TEXT, count INTEGER, notebook INTEGER);");
    SqlStep(sqlCreateTable);

    sqlquery sqlMatchBook = SqlPrepareQueryCampaign(sDatabase, "SELECT id FROM books WHERE name = @name AND description = @desc LIMIT 1;");
    SqlBindString(sqlMatchBook, "@name", sBookName);
    SqlBindString(sqlMatchBook, "@desc", sBookDesc);
    if(SqlStep(sqlMatchBook)){
        string sMatchedBookId = SqlGetString(sqlMatchBook, 0);
        sqlquery sqlIncreaseCount = SqlPrepareQueryCampaign(sDatabase, "UPDATE books SET count = count + 1 WHERE id = @id;");
        SqlBindString(sqlIncreaseCount, "@id", sMatchedBookId);
        SqlStep(sqlIncreaseCount);
    }
    else {
        sqlquery sqlCountBooks = SqlPrepareQueryCampaign(sDatabase, "SELECT COUNT(*) FROM books;");
        SqlStep(sqlCountBooks);
        int nCount = SqlGetInt(sqlCountBooks, 0);
        if (nCount >= GS_BO_LIMIT) return FALSE;

        sqlquery sqlInsertBook = SqlPrepareQueryCampaign(sDatabase, "INSERT INTO books (id, name, description, count, notebook) VALUES (@id, @name, @desc, @count, @notebook);");
        SqlBindString(sqlInsertBook, "@id", GetRandomUUID());
        SqlBindString(sqlInsertBook, "@name", sBookName);
        SqlBindString(sqlInsertBook, "@desc", sBookDesc);
        SqlBindInt(sqlInsertBook, "@count", 1);
        SqlBindInt(sqlInsertBook, "@notebook", FALSE);
    }
    return TRUE;
}

//----------------------------------------------------------------
void gsBORemoveBook(string sBookID, object oShelf = OBJECT_SELF)
{
    string sDatabase = "";
    if(GetLocalString(oShelf, "GS_FX_ID") == "")
    {
        sDatabase  = "GS_BO_" + GetTag(oShelf);
    }
    else
    {
        sDatabase = "GS_BO_" + GetLocalString(oShelf, "GS_FX_ID");
    }

    sqlquery sqlDeleteBook = SqlPrepareQueryCampaign(sDatabase, "DELETE FROM books WHERE id = @id;");
    SqlBindString(sqlDeleteBook, "@id", sBookID);
    SqlStep(sqlDeleteBook);

}
