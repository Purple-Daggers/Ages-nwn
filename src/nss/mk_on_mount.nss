// mk_on_mount.nss

#include "mk_inc_exec"

// this script is called by the CCOH horse system to verify
// if mounting horse is allowed at the moment.
//
// Provide TRUE as a parameter to MK_EXEC_INT_SetReturnValue(int nReturn)
// to allow mounting or provide FALSE to disallow mounting

void main()
{
    SendMessageToPC(OBJECT_SELF, "*** script \"mk_on_mount\" called ***");
//    MK_EXEC_INT_SetReturnValue(TRUE);
    int nReturn = !GetIsAreaInterior(GetArea(OBJECT_SELF));
    if (!nReturn)
    {
        if (GetIsPC(OBJECT_SELF))
            SendMessageToPC(OBJECT_SELF, GetStringByStrRef(112003));
    }
    MK_EXEC_INT_SetReturnValue(nReturn);
}
