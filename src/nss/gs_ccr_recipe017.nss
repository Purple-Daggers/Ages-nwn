#include "gs_inc_craft"
#include "gs_inc_token"

int StartingConditional()
{
    if (GetObjectType(OBJECT_SELF) == OBJECT_TYPE_PLACEABLE && GetHasInventory(OBJECT_SELF)) return FALSE;

    object oSpeaker = GetPCSpeaker();

    DeleteLocalInt(OBJECT_SELF, "GS_PAGE_START_1");

    SetCustomToken(100, IntToString(GetLocalInt(GetModule(), "GS_CR_RECIPE_COUNT")));
    gsTKSetToken(101, gsCRGetSkillName(GS_CR_SKILL_FORGE));
    gsTKSetToken(102, gsCRGetSkillName(GS_CR_SKILL_CARPENTER));
    gsTKSetToken(103, gsCRGetSkillName(GS_CR_SKILL_SEW));
    gsTKSetToken(104, gsCRGetSkillName(GS_CR_SKILL_MELD));
    gsTKSetToken(105, gsCRGetSkillName(GS_CR_SKILL_CRAFT_ART));
    gsTKSetToken(106, gsCRGetSkillName(GS_CR_SKILL_COOK));
    gsTKSetToken(113, gsCRGetSkillName(GS_CR_SKILL_GADGET));

    gsTKSetToken(107, IntToString(gsCRGetSkillRank(GS_CR_SKILL_FORGE,     oSpeaker)));
    gsTKSetToken(108, IntToString(gsCRGetSkillRank(GS_CR_SKILL_CARPENTER, oSpeaker)));
    gsTKSetToken(109, IntToString(gsCRGetSkillRank(GS_CR_SKILL_SEW,       oSpeaker)));
    gsTKSetToken(110, IntToString(gsCRGetSkillRank(GS_CR_SKILL_MELD,      oSpeaker)));
    gsTKSetToken(111, IntToString(gsCRGetSkillRank(GS_CR_SKILL_CRAFT_ART, oSpeaker)));
    gsTKSetToken(112, IntToString(gsCRGetSkillRank(GS_CR_SKILL_COOK,      oSpeaker)));
    gsTKSetToken(114, IntToString(gsCRGetSkillRank(GS_CR_SKILL_GADGET,      oSpeaker)));

    return TRUE;
}
