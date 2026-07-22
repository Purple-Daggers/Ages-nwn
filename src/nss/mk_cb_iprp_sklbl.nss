#include "mk_inc_debug"
#include "mk_inc_2da_disp"
#include "mk_inc_tlk"
#include "mk_inc_iprp"
#include "mk_inc_cheats"

const string s2DAfile = "skills";
const string sColumnStrRef = "Name";


void main()
{
    object oPC = OBJECT_SELF;
    int nRow = GetLocalInt(OBJECT_SELF, MK_2DA_DISP_CALLBACK_ROW);

    int nSkill = nRow;
    int nStrRef = MK_Get2DAInt(s2DAfile, sColumnStrRef, nRow, -1);

    object oItem = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);

    int nSkillBonus = MK_IPRP_GetSkillBonus(oItem, nSkill, FALSE);
    int nCurrentSkill = MK_CHEATS_GetCurrentSkill();

    int bHighlight = (nSkillBonus>0) || (nSkill==nCurrentSkill);

    string sLabel = GetLocalString(oPC, (bHighlight ? "MK_2DA_DISP_CURRENT_COLOR" : "MK_2DA_DISP_DEFAULT_COLOR"))
        + GetStringByStrRef(nStrRef, GetGender(oPC))
        + (bHighlight ? " ("+IntToString(nSkillBonus)+")" : "")
        + "</c>";

    SetLocalString(OBJECT_SELF, MK_2DA_DISP_CALLBACK_LABEL, sLabel);
}
