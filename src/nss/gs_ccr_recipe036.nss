#include "gs_inc_craft"

int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();
    int nSkill      = GetLocalInt(OBJECT_SELF, "GS_SKILL");

    SetCustomToken(100, gsCRGetSkillName(nSkill));
    SetCustomToken(101, IntToString(gsCRGetSkillRank(nSkill, oSpeaker)));
    SetCustomToken(102, IntToString(gsCRGetSkillPoints(oSpeaker)));

    return TRUE;
}
