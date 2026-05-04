#include "gs_inc_craft"

int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();
    int nSkill      = GetLocalInt(OBJECT_SELF, "GS_SKILL");

    return gsCRGetSkillRank(nSkill, oSpeaker) > 0;
}
