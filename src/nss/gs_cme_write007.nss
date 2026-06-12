#include "gs_inc_common"
#include "gs_inc_message"

const string GS_TEMPLATE_LETTER = "gs_item370";

void main()
{
    object oTarget = GetLocalObject(OBJECT_SELF, "GS_TARGET");

    if (GetIsObjectValid(oTarget))
    {
        string sTitle     = GetLocalString(OBJECT_SELF, "GS_ME_TITLE");
        string sText      = GetLocalString(OBJECT_SELF, "GS_ME_TEXT_1");
        string sLine      = GetLocalString(OBJECT_SELF, "GS_ME_TEXT_2");

        if (sLine != "")
        {
            sText += "\n" + sLine;
            sLine  = GetLocalString(OBJECT_SELF, "GS_ME_TEXT_3");

            if (sLine != "")
            {
                sText += "\n" + sLine;
                sLine  = GetLocalString(OBJECT_SELF, "GS_ME_TEXT_4");

                if (sLine != "") sText += "\n" + sLine;
            }
        }

        string sMessageID = GetRandomUUID();
        object oObject    = CreateItemOnObject(GS_TEMPLATE_LETTER,
                                               OBJECT_SELF,
                                               1,
                                               "GS_ME_" + sMessageID);

        if (GetIsObjectValid(oObject))
        {
            string sDoubleQuote = GetLocalString(GetModule(), "GS_DOUBLE_QUOTE");
            sMessageID = GetTag(oObject);

            SetName(oObject, sDoubleQuote + sTitle + sDoubleQuote);
            gsMESetMessage(GetStringRight(sMessageID, 6), sTitle, sText);
            DestroyObject(oTarget);
        }
    }
}
