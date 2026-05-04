#include "gs_inc_craft"

int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();
    int nSkill      = GetLocalInt(OBJECT_SELF, "GS_SKILL");

    SetCustomToken(100, IntToString(gsCRGetSkillRank(nSkill, oSpeaker)));
    SetCustomToken(101, IntToString(gsCRGetCraftPoints(oSpeaker)));

    return TRUE;
}
