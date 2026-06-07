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
//return owner id of sBookID from oShelf
string gsBOGetOwner(string sBookID, object oShelf = OBJECT_SELF);
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

    string sBookID = "";
    string sOwner     = "";
    string sNth       = "";
    int nNth          = 1;

    SetLocalInt(oShelf, "GS_BO_OFFSET", GetCampaignInt(sDatabase, "OFFSET"));

    for (; nNth <= GS_BO_LIMIT; nNth++)
    {
        sNth       = IntToString(nNth);
        sBookID = GetCampaignString(sDatabase, "Book_" + sNth);

        if (sBookID != "")
        {
            sOwner = GetCampaignString(sDatabase, sBookID + "_OWNER");

            SetLocalString(oShelf, "GS_BO_Book_" + sNth, sBookID);
            SetLocalString(oShelf, "GS_BO_" + sBookID + "_OWNER", sOwner);
        }
    }
}

void gsBODeleteContent(object oShelf = OBJECT_SELF)
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

    string sBookID = "";
    string sNth       = "";
    int nNth          = 1;

    DeleteLocalInt(oShelf, "GS_BO_OFFSET");

    for (; nNth <= GS_BO_LIMIT; nNth++)
    {
        sNth       = IntToString(nNth);
        sBookID = GetCampaignString(sDatabase, "Book_" + sNth);

        if (sBookID != "")
        {
            DeleteLocalString(oShelf, "GS_BO_Book_" + sNth);
            DeleteLocalString(oShelf, "GS_BO_" + sBookID + "_OWNER");
        }
    }

    DeleteLocalString(oShelf, "GS_FX_ID");
    DeleteLocalInt(oShelf, "GS_BO_ENABLED");
}

//----------------------------------------------------------------
string gsBOGetBook(int nPosition = 0, object oShelf = OBJECT_SELF)
{
    if (nPosition < 0)            return "";
    if (nPosition >= GS_BO_LIMIT) return "";

    nPosition = GetLocalInt(oShelf, "GS_BO_OFFSET") - nPosition;
    if (nPosition < 1)            nPosition += GS_BO_LIMIT;

    return GetLocalString(oShelf, "GS_BO_Book_" + IntToString(nPosition));
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
string gsBOGetOwner(string sBookID, object oShelf = OBJECT_SELF)
{
    return GetLocalString(oShelf, "GS_BO_" + sBookID + "_OWNER");
}
//----------------------------------------------------------------
int gsBOPostBook(string sBookName, string sBookDesc, object oShelf = OBJECT_SELF)
{
    string sNth      = "";
    int nNth         = 1;

    string sDatabase = "";
    if(GetLocalString(oShelf, "GS_FX_ID") == "")
    {
        sDatabase  = "GS_BO_" + GetTag(oShelf);
    }
    else
    {
        sDatabase = "GS_BO_" + GetLocalString(oShelf, "GS_FX_ID");
    }

    for (; nNth <= GS_BO_LIMIT; nNth++)
    {
        sNth = IntToString(nNth);
        if (GetLocalString(oShelf, "GS_BO_BOOK_NAME_" + sNth) == sBookName) {
            if (GetLocalString(oShelf, "GS_BO_BOOK_DESC_" + sNth) == sBookDesc) {
                SetLocalInt(oShelf, "GS_BO_BOOK_COUNT_" + sNth, GetLocalInt(oShelf, "GS_BO_BOOK_COUNT_" + sNth));
                SetCampaignInt(sDatabase, "GS_BO_BOOK_COUNT_" + sNth, GetLocalInt(oShelf, "GS_BO_BOOK_COUNT_" + sNth));
                return TRUE;
            }
        }
    }

    nNth             = GetLocalInt(oShelf, "GS_BO_OFFSET") + 1;
    if (nNth > GS_BO_LIMIT) return FALSE;
    sNth             = IntToString(nNth);

    string sBookID = GetRandomUUID();

    SetLocalInt(oShelf, "GS_BO_OFFSET", nNth);
    SetLocalString(oShelf, "BOOK_" + sNth, sBookID);
    SetLocalString(oShelf, "GS_BO_BOOK_NAME_" + sNth, sBookName);
    SetLocalString(oShelf, "GS_BO_BOOK_DESC_" + sNth, sBookDesc);
    SetLocalInt(oShelf, "GS_BO_BOOK_COUNT_" + sNth, 1);
    SetCampaignInt(sDatabase, "OFFSET", nNth);
    SetCampaignString(sDatabase, "BOOK_" + sNth, sBookID);
    SetCampaignString(sDatabase, "GS_BO_BOOK_NAME_" + sNth, sBookName);
    SetCampaignString(sDatabase, "GS_BO_BOOK_DESC_" + sNth, sBookDesc);
    SetCampaignInt(sDatabase, "GS_BO_BOOK_COUNT_" + sNth, 1);

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

    string sNth      = "";
    int nNth         = 1;

    for (; nNth <= GS_BO_LIMIT; nNth++)
    {
        sNth = IntToString(nNth);

        if (GetLocalString(oShelf, "GS_BO_Book_" + sNth) == sBookID)
        {
            DeleteLocalString(oShelf, "GS_BO_Book_" + sNth);
            SetCampaignString(sDatabase, "Book_" + sNth, "");
            return;
        }
    }
}
