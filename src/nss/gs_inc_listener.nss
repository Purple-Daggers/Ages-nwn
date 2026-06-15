/* LISTENER Library by Gigaschatten */

//void main() {}

//return target of oListener
object gsLIGetTarget(object oListener = OBJECT_SELF);
//destroy listener of oPC
void gsLIDestroyListener(object oPC);
//set last sMessage of oPC
void gsLISetLastMessage(string sMessage, object oPC = OBJECT_SELF);
//return last message of oPC
string gsLIGetLastMessage(object oPC = OBJECT_SELF);
//clear last message of oPC
void gsLIClearLastMessage(object oPC = OBJECT_SELF);

//----------------------------------------------------------------
void gsLISetLastMessage(string sMessage, object oPC = OBJECT_SELF)
{
    SetLocalString(oPC, "GS_LI_MESSAGE", sMessage);
}
//----------------------------------------------------------------
string gsLIGetLastMessage(object oPC = OBJECT_SELF)
{
    return GetLocalString(oPC, "GS_LI_MESSAGE");
}
//----------------------------------------------------------------
void gsLIClearLastMessage(object oPC = OBJECT_SELF)
{
    DeleteLocalString(oPC, "GS_LI_MESSAGE");
}
