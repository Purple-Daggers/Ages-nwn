#include "gs_inc_craft"

void main()
{
    object oSpeaker = GetPCSpeaker();
    int nSkill      = GetLocalInt(OBJECT_SELF, "GS_SKILL");

    gsCRIncreaseSkillRank(nSkill, oSpeaker);
}
