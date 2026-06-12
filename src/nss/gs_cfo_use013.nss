#include "gs_inc_forum"
#include "gs_inc_message"

const string GS_TEMPLATE_LETTER = "gs_item370";

void main()
{
    int nNth = GetLocalInt(OBJECT_SELF, "GS_FO_MESSAGE");

    if (nNth != -1)
    {
        string sMessageID = gsFOGetMessage(nNth);

        if (sMessageID != "")
        {
            object oSpeaker = GetPCSpeaker();

            if (GetIsDM(oSpeaker) ||
                gsFOGetOwner(sMessageID) == gsPCGetPlayerID(oSpeaker))
            {
                object oObject = CreateItemOnObject(GS_TEMPLATE_LETTER,
                                                    oSpeaker,
                                                    1,
                                                    "GS_ME_" + sMessageID);

                if (GetIsObjectValid(oObject))
                {
                    string sDoubleQuote = GetLocalString(GetModule(), "GS_DOUBLE_QUOTE");

                    SetName(oObject, sDoubleQuote + gsMEGetTitle(sMessageID) + sDoubleQuote);
                    gsFORemoveMessage(sMessageID);
                    DeleteLocalInt(OBJECT_SELF, "GS_FO_MESSAGE");
                }
            }
        }
    }
}
