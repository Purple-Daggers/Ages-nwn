// mk_on_dismount

#include "mk_inc_exec"

// this script is called by the CCOH horse system to verify
// if dismounting is allowed at the moment.
//
// Provide TRUE as a parameter to MK_EXEC_INT_SetReturnValue(int nReturn)
// to allow mounting or provide FALSE to disallow mounting


void main()
{
    SendMessageToPC(OBJECT_SELF, "*** script \"mk_on_dismount\" called ***");
    MK_EXEC_INT_SetReturnValue(TRUE);
}
