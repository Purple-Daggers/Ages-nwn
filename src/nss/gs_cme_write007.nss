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
                                               GetStringLeft("GS_ME_" + sMessageID, 32));

        if (GetIsObjectValid(oObject))
        {
            SetTag(oObject, GetStringLeft("GS_ME_" + sMessageID, 32));
            string sDoubleQuote = GetLocalString(GetModule(), "GS_DOUBLE_QUOTE");
            SetName(oObject, sDoubleQuote + sTitle + sDoubleQuote);
            gsMESetMessage(GetTag(oObject), sTitle, sText);
            DestroyObject(oTarget);
        }
    }
}
