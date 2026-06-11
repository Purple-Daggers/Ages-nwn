/* BOOKSHELF Library by Jamesfelicia, modified from Gigaschatten's forum library. */

#include "gs_inc_pc"

//void main() {};

const int GS_BS_LIMIT = 100;

//load content of oShelf from database
void gsBSLoadContent(object oShelf = OBJECT_SELF);
//return Book id at nPosition from oShelf
string gsBSGetBook(int nPosition = 0, object oShelf = OBJECT_SELF);
//return position of first Book at or after nPosition in oShelf, return -1 if at end
int gsBSGetFirstBook(int nPosition = 0, object oShelf = OBJECT_SELF);
//internally used
int _gsBSGetFirstBook(int nPosition, object oShelf, int nStep = 1);
//return position of Book following nPosition in oShelf, return -1 if at end
int gsBSGetNextBook(int nPosition = 0, object oShelf = OBJECT_SELF);
//return position of Book preceding nPosition in oShelf, return -1 if at start
int gsBSGetPreviousBook(int nPosition = 0, object oShelf = OBJECT_SELF);
//return true on successfully posting sBookID to oShelf by oOwner
int gsBSPostBook(string sBookName, string sBookDesc, object oShelf = OBJECT_SELF);
//remove sBookID from oShelf
void gsBSRemoveBook(string sBookID, object oShelf = OBJECT_SELF);

void gsBSLoadContent(object oShelf = OBJECT_SELF)
{
    string sDatabase = "GS_BS_BOOKSHELVES";
    string sShelfID = "";
    if(GetLocalString(oShelf, "GS_FX_ID") == "")
    {
        sShelfID  = "GS_BS_" + GetTag(oShelf);
    }
    else
    {
        sShelfID = "GS_BS_" + GetLocalString(oShelf, "GS_FX_ID");
    }

    sqlquery sqlCreateTable = SqlPrepareQueryCampaign(sDatabase, "CREATE TABLE IF NOT EXISTS books (id TEXT PRIMARY KEY, shelf_id TEXT, name TEXT, description TEXT, count INTEGER, notebook TEXT);");
    SqlStep(sqlCreateTable);

    string sBookID = "";
    string sName     = "";
    int nCount = 0;
    int nNotebook = FALSE;
    int nNth          = 1;

    sqlquery sqlGetBooks = SqlPrepareQueryCampaign(sDatabase, "SELECT id, name, count FROM books WHERE shelf_id = @shelf_id ORDER BY name COLLATE NOCASE DESC;");
    SqlBindString(sqlGetBooks, "@shelf_id", sShelfID);
    while(SqlStep(sqlGetBooks))
    {
        string sNth = IntToString(nNth);
        sBookID = SqlGetString(sqlGetBooks, 0);
        sName = SqlGetString(sqlGetBooks, 1);
        nCount = SqlGetInt(sqlGetBooks, 2);
        SetLocalString(oShelf, "GS_BS_BOOK_" + sNth, sBookID);
        SetLocalString(oShelf, sBookID + "_INDEX", sNth);
        SetLocalInt(oShelf, sBookID + "_COUNT", nCount);
        SetLocalString(oShelf, sBookID + "_NAME", sName);
        SetLocalInt(oShelf, "GS_BS_OFFSET", nNth);
        nNth++;
    }
}

void gsBSUnloadContent(object oShelf = OBJECT_SELF)
{
    int nNth = 1;
    for (; nNth <= GS_BS_LIMIT; nNth++)
    {
        string sNth = IntToString(nNth);
        string sBookID = GetLocalString(oShelf, "GS_BS_BOOK" + sNth);
        DeleteLocalString(oShelf, "GS_BS_BOOK" + sNth);
        DeleteLocalString(oShelf, sBookID + "_INDEX");
        DeleteLocalInt(oShelf, sBookID + "_COUNT");
        DeleteLocalString(oShelf, sBookID + "_NAME");
    }
    DeleteLocalInt(oShelf, "GS_BS_OFFSET");
    DeleteLocalInt(oShelf, "GS_BOOK");
    DeleteLocalInt(oShelf, "GS_BS_ENABLED");
}

//----------------------------------------------------------------
string gsBSGetBook(int nPosition = 0, object oShelf = OBJECT_SELF)
{
    if (nPosition < 0)            return "";
    if (nPosition >= GS_BS_LIMIT) return "";

    nPosition = GetLocalInt(oShelf, "GS_BS_OFFSET") - nPosition;
    if (nPosition < 1)            nPosition += GS_BS_LIMIT;

    return GetLocalString(oShelf, "GS_BS_BOOK_" + IntToString(nPosition));
}
//----------------------------------------------------------------
int gsBSGetFirstBook(int nPosition = 0, object oShelf = OBJECT_SELF)
{
    return _gsBSGetFirstBook(nPosition, oShelf);
}
//----------------------------------------------------------------
int _gsBSGetFirstBook(int nPosition, object oShelf, int nStep = 1)
{
    string sBookID = "";

    for (; nPosition >= 0 && nPosition < GS_BS_LIMIT; nPosition += nStep)
    {
        sBookID = gsBSGetBook(nPosition, oShelf);
        if (sBookID != "") return nPosition;
    }

    return -1;
}
//----------------------------------------------------------------
int gsBSGetNextBook(int nPosition = 0, object oShelf = OBJECT_SELF)
{
    return _gsBSGetFirstBook(nPosition + 1, oShelf);
}
//----------------------------------------------------------------
int gsBSGetPreviousBook(int nPosition = 0, object oShelf = OBJECT_SELF)
{
    return _gsBSGetFirstBook(nPosition - 1, oShelf, -1);
}
//----------------------------------------------------------------
string gsBSGetBookDescription(string sBookID, object oShelf = OBJECT_SELF)
{
    string sDatabase = "GS_BS_BOOKSHELVES";
    string sShelfID = "";
    if(GetLocalString(oShelf, "GS_FX_ID") == "")
    {
        sShelfID  = "GS_BS_" + GetTag(oShelf);
    }
    else
    {
        sShelfID = "GS_BS_" + GetLocalString(oShelf, "GS_FX_ID");
    }

    sqlquery sqlGetDescription = SqlPrepareQueryCampaign(sDatabase, "SELECT description FROM books WHERE id = @id;");
    SqlBindString(sqlGetDescription, "@id", sBookID);
    SqlStep(sqlGetDescription);
    return SqlGetString(sqlGetDescription, 0);
}
//----------------------------------------------------------------
string gsBSGetBookName(string sBookID, object oShelf = OBJECT_SELF)
{
    string sDatabase = "GS_BS_BOOKSHELVES";
    string sShelfID = "";
    if(GetLocalString(oShelf, "GS_FX_ID") == "")
    {
        sShelfID  = "GS_BS_" + GetTag(oShelf);
    }
    else
    {
        sShelfID = "GS_BS_" + GetLocalString(oShelf, "GS_FX_ID");
    }

    sqlquery sqlGetName = SqlPrepareQueryCampaign(sDatabase, "SELECT name FROM books WHERE id = @id;");
    SqlBindString(sqlGetName, "@id", sBookID);
    SqlStep(sqlGetName);
    return SqlGetString(sqlGetName, 0);
}
//----------------------------------------------------------------
int gsBSPostBook(string sBookName, string sBookDesc, object oShelf = OBJECT_SELF)
{
    string sDatabase = "GS_BS_BOOKSHELVES";
    string sShelfID = "";
    if(GetLocalString(oShelf, "GS_FX_ID") == "")
    {
        sShelfID  = "GS_BS_" + GetTag(oShelf);
    }
    else
    {
        sShelfID = "GS_BS_" + GetLocalString(oShelf, "GS_FX_ID");
    }

    sqlquery sqlCreateTable = SqlPrepareQueryCampaign(sDatabase, "CREATE TABLE IF NOT EXISTS books (id TEXT PRIMARY KEY, shelf_id TEXT, name TEXT, description TEXT, count INTEGER, notebook TEXT);");
    SqlStep(sqlCreateTable);

    sqlquery sqlMatchBook = SqlPrepareQueryCampaign(sDatabase, "SELECT id FROM books WHERE shelf_id = @shelf_id AND name = @name AND description = @desc LIMIT 1;");
    SqlBindString(sqlMatchBook, "@shelf_id", sShelfID);
    SqlBindString(sqlMatchBook, "@name", sBookName);
    SqlBindString(sqlMatchBook, "@desc", sBookDesc);
    if(SqlStep(sqlMatchBook)){
        string sMatchedBookId = SqlGetString(sqlMatchBook, 0);
        sqlquery sqlIncreaseCount = SqlPrepareQueryCampaign(sDatabase, "UPDATE books SET count = count + 1 WHERE id = @id;");
        SqlBindString(sqlIncreaseCount, "@id", sMatchedBookId);
        SqlStep(sqlIncreaseCount);
    }
    else {
        sqlquery sqlCountBooks = SqlPrepareQueryCampaign(sDatabase, "SELECT COUNT(*) FROM books WHERE shelf_id = @shelf_id;");
        SqlBindString(sqlCountBooks, "@shelf_id", sShelfID);
        SqlStep(sqlCountBooks);
        int nCount = SqlGetInt(sqlCountBooks, 0);
        if (nCount >= GS_BS_LIMIT) return FALSE;

        sqlquery sqlInsertBook = SqlPrepareQueryCampaign(sDatabase, "INSERT INTO books (id, shelf_id, name, description, count, notebook) VALUES (@id, @shelf_id, @name, @desc, @count, @notebook);");
        SqlBindString(sqlInsertBook, "@id", GetRandomUUID());
        SqlBindString(sqlInsertBook, "@shelf_id", sShelfID);
        SqlBindString(sqlInsertBook, "@name", sBookName);
        SqlBindString(sqlInsertBook, "@desc", sBookDesc);
        SqlBindInt(sqlInsertBook, "@count", 1);
        SqlBindString(sqlInsertBook, "@notebook", "");
        SqlStep(sqlInsertBook);
    }
    return TRUE;
}

//----------------------------------------------------------------
void gsBSRemoveBook(string sBookID, object oShelf = OBJECT_SELF)
{
    string sDatabase = "GS_BS_BOOKSHELVES";
    string sShelfID = "";
    if(GetLocalString(oShelf, "GS_FX_ID") == "")
    {
        sShelfID  = "GS_BS_" + GetTag(oShelf);
    }
    else
    {
        sShelfID = "GS_BS_" + GetLocalString(oShelf, "GS_FX_ID");
    }

    sqlquery sqlMatchBook = SqlPrepareQueryCampaign(sDatabase, "SELECT count FROM books WHERE id = @id LIMIT 1;");
    SqlBindString(sqlMatchBook, "@id", sBookID);
    if(SqlStep(sqlMatchBook)){
        int sMatchedBookCount = SqlGetInt(sqlMatchBook, 0);
        if (sMatchedBookCount <= 1){
            sqlquery sqlDeleteBook = SqlPrepareQueryCampaign(sDatabase, "DELETE FROM books WHERE id = @id;");
            SqlBindString(sqlDeleteBook, "@id", sBookID);
            SqlStep(sqlDeleteBook);
            DeleteLocalString(oShelf, "GS_BS_BOOK_" + GetLocalString(oShelf, sBookID + "_INDEX"));
            DeleteLocalString(oShelf, sBookID + "_INDEX");
            DeleteLocalInt(oShelf, sBookID + "_COUNT");
            DeleteLocalString(oShelf, sBookID + "_NAME");
            return;
        }
        else
        {
        sqlquery sqlDecreaseCount = SqlPrepareQueryCampaign(sDatabase, "UPDATE books SET count = count - 1 WHERE id = @id;");
        SqlBindString(sqlDecreaseCount, "@id", sBookID);
        SqlStep(sqlDecreaseCount);
        SetLocalInt(oShelf, sBookID + "_COUNT", sMatchedBookCount - 1);
        }
    }
    else
    {
        return;
    }
}
