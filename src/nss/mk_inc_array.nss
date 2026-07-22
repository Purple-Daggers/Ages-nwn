// mk_inc_array

#include "mk_inc_tools"

///////////////////////////////////////////////////////////////////////////////
// General functions

// Returns the buffer for the specified array
// - oObject: object the array is stored on
// - sArrayName: name of the array
// * return value: buffer of specified array
string MK_ARRAY_GetLocalArrayBuffer(object oObject, string sArrayName);

// Sets the buffer for the specified array
// - oObject: object the array is stored on
// - sArrayName: name of the array
// - sBuffer: buffer the specified array should use.
//   sBuffer is supposed to contain only '0' and '1'.
void MK_ARRAY_SetLocalArrayBuffer(object oObject, string sArrayName, string sBuffer);

// Deletes an array
// - oObject: object the array is stored on
// - sArrayName: name of the array
void MK_ARRAY_DeleteLocalArray(object oObject, string sArrayName);


///////////////////////////////////////////////////////////////////////////
// Sorted Int Array:

// Appends a new element to the end of an array
// - oObject: object to store the array on
// - sArrayName: name of the array
// - nValue: element to be appended
// The element is appended regardless of its value
void MK_ARRAY_AppendLocalArraySortedInt(object oObject, string sArrayName, int nValue);

// returns the length/size of the specified array
// - oObject: object the array is stored on
// - sArrayName: name of the array
// * returns the length/size of the specified array (the number of elements)
int MK_ARRAY_GetLocalArraySortedIntLength(object oObject, string sArrayName);

// returns element at specified position of an sorted int array
// - oObject: object the array is stored on
// - sArrayName: name of the array
// - nPos: position in the array the value should be retrieved from
// * returns the value stored at position nPos
int MK_ARRAY_GetLocalArraySortedInt(object oObject, string sArrayName, int nPos);

// returns the position of an integer in a sorted int array
// - oObject: object the array is stored on
// - sArrayName: name of the array
// - nValue: value to be searched
// * returns position of specified element or -1 if the element is not found
int MK_ARRAY_SearchLocalArraySortedInt(object oObject, string sArrayName, int nValue);


///////////////////////////////////////////////////////////////////////////
// Bool Array:

// Simulates storing a boolean value in an array
// - oObject: object to store the array on
// - sArrayName: name of the array
// - nPos: position/index within the array to store the value in
// - bValue: the (boolean) value (TRUE/FALSE) to store in the array
void MK_ARRAY_SetLocalArrayBool(object oObject, string sArrayName, int nPos, int bValue);

// Simulates retrieving a boolean value from an array
// - oObject: object the array is stored on
// - sArrayName: name of the array
// - nPos: the position/index in the array the value should be retrieved from
// * return value: returns the value found at position/index nPos
int MK_ARRAY_GetLocalArrayBool(object oObject, string sArrayName, int nPos);

// Returns the size/length of an array
// - oObject: object the array is stored on
// - sArrayName: name of the array
// * return value: size/length of an array
int MK_ARRAY_GetLocalArrayBoolLength(object oObject, string sArrayName);


///////////////////////////////////////////////////////////////////////////////
// General functions

string MK_ARRAY_GetLocalArrayBuffer(object oObject, string sArrayName)
{
    return GetLocalString(oObject, sArrayName);
}

void MK_ARRAY_SetLocalArrayBuffer(object oObject, string sArrayName, string sBuffer)
{
    SetLocalString(oObject, sArrayName, sBuffer);
}

void MK_ARRAY_DeleteLocalArray(object oObject, string sArrayName)
{
    DeleteLocalString(oObject, sArrayName);
}

///////////////////////////////////////////////////////////////////////////////
// Sorted Int Array:

const int MK_ARRAY_INTEGER_SIZE = 4;

string MK_ARRAY_LocalArraySortedInt_IntToString(int nValue)
{
    return MK_IntToString(nValue, MK_ARRAY_INTEGER_SIZE, " ");
}

void MK_ARRAY_AppendLocalArraySortedInt(object oObject, string sArrayName, int nValue)
{
    string sBuffer = MK_ARRAY_GetLocalArrayBuffer(oObject, sArrayName);
    sBuffer += MK_ARRAY_LocalArraySortedInt_IntToString(nValue);
    MK_ARRAY_SetLocalArrayBuffer(oObject, sArrayName, sBuffer);
}

int MK_ARRAY_GetLocalArraySortedIntLength(object oObject, string sArrayName)
{
    string sBuffer = MK_ARRAY_GetLocalArrayBuffer(oObject, sArrayName);
    int nLen = GetStringLength(sBuffer) / MK_ARRAY_INTEGER_SIZE;
    return nLen;
}

int MK_ARRAY_GetLocalArraySortedInt(object oObject, string sArrayName, int nPos)
{
    string sBuffer = MK_ARRAY_GetLocalArrayBuffer(oObject, sArrayName);
    string sValue = GetSubString(sBuffer, nPos*MK_ARRAY_INTEGER_SIZE, MK_ARRAY_INTEGER_SIZE);
    return StringToInt(sValue);
}

int MK_ARRAY_SearchLocalArraySortedInt(object oObject, string sArrayName, int nValue)
{
    string sBuffer = MK_ARRAY_GetLocalArrayBuffer(oObject, sArrayName);
    int nPos, nPos0=0, nPos1=GetStringLength(sBuffer) / MK_ARRAY_INTEGER_SIZE;
    int nValueQ;
    while (nPos0<=nPos1)
    {
        nPos = (nPos0 + nPos1) / 2;
        nValueQ = StringToInt(GetSubString(sBuffer, nPos*MK_ARRAY_INTEGER_SIZE, MK_ARRAY_INTEGER_SIZE));
        if (nValue<nValueQ)
        {
            nPos1 = nPos-1;
        }
        else if (nValue>nValueQ)
        {
            nPos0 = nPos+1;
        }
        else
        {
            return nPos;
        }
    }
    return -1;
}

///////////////////////////////////////////////////////////////////////////////
// Bool Array:

int MK_ARRAY_GetLocalArrayBool(object oObject, string sArrayName, int nPos)
{
    string sArray = MK_ARRAY_GetLocalArrayBuffer(oObject, sArrayName);
    return (GetSubString(sArray, nPos, 1)=="1");
}


int MK_ARRAY_GetLocalArrayBoolLength(object oObject, string sArrayName)
{
    string sArray = MK_ARRAY_GetLocalArrayBuffer(oObject, sArrayName);
    return GetStringLength(sArray);
}

int MK_ARRAY_GetIsLocalArrayBoolEqual(object oObject, string sArrayName, int bValue)
{
    string sArray = MK_ARRAY_GetLocalArrayBuffer(oObject, sArrayName);
//    MK_DEBUG_TRACE("MK_ARRAY_GetIsLocalArrayBoolEqual: '"+sArray+"'");
    int iPos;
    int nLength=GetStringLength(sArray);
    string sValue = (bValue ? "1" : "0");
    for (iPos=0; iPos<nLength; iPos++)
    {
        if (GetSubString(sArray, iPos, 1)!=sValue)
        {
            return FALSE;
        }
    }
    return TRUE;
}

void MK_ARRAY_InitializeLocalArrayBool(object oObject, string sArrayName, int nSize, int bValue)
{
    int iPos;
    string sArray="";
    string sValue = ( bValue ? "1" : "0" );
    for (iPos=0; iPos<nSize; iPos++)
    {
        sArray += sValue;
    }
    MK_ARRAY_SetLocalArrayBuffer(oObject, sArrayName, sArray);
}

void MK_ARRAY_SetLocalArrayBool(object oObject, string sArrayName, int nPos, int bValue)
{
    string sArray = MK_ARRAY_GetLocalArrayBuffer(oObject, sArrayName);
    int nLength = GetStringLength(sArray);
    while (nLength < nPos+1)
    {
        sArray+="0";
        nLength++;
    }
    string sPrefix="", sPostfix="";

    if (nPos>0)
    {
        sPrefix = GetStringLeft(sArray, nPos);
    }
    if (nPos+1 < nLength)
    {
        sPostfix = GetStringRight(sArray, (nLength-(nPos+1)));
    }

    sArray = sPrefix + (bValue ? "1" : "0") + sPostfix;

    MK_ARRAY_SetLocalArrayBuffer(oObject, sArrayName, sArray);
}


/*
void main()
{

}
/**/
