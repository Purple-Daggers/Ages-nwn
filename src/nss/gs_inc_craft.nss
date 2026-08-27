/* CRAFT library by Gigaschatten */

// Note: Recipes are configured by logging in as a DM and using the tools in the
// Trade area.

#include "gs_inc_common"
#include "gs_inc_pc"
#include "gs_inc_text"
#include "gs_inc_time"

//void main() {}

const string GS_CRAFTING_DATABASE = "gs_crafting";

const string GS_CR_TEMPLATE_CARPENTER = "gs_item049";
const string GS_CR_TEMPLATE_COOK      = "gs_item052";
const string GS_CR_TEMPLATE_CRAFT_ART = "gs_item431";
const string GS_CR_TEMPLATE_FORGE     = "gs_item432";
const string GS_CR_TEMPLATE_MELD      = "gs_item433";
const string GS_CR_TEMPLATE_SEW       = "gs_item434";
const string GS_CR_TEMPLATE_GADGET       = "gs_item444";
const string GS_CR_TEMPLATE_UNKNOWN       = "TODO";

const int GS_CR_LIMIT_RECIPE          = 500;
const int GS_CR_LIMIT_CATEGORY        = 200;
const int GS_CR_OFFSET_DC             =   0;
const int GS_CR_MODIFIER_DC           = 100;
const int GS_CR_MODIFIER_CRAFT_POINTS = 125;

const int GS_CR_SKILL_CARPENTER       =   1;
const int GS_CR_SKILL_COOK            =   2;
const int GS_CR_SKILL_CRAFT_ART       =   3;
const int GS_CR_SKILL_FORGE           =   4;
const int GS_CR_SKILL_MELD            =   5;
const int GS_CR_SKILL_SEW             =   6;
const int GS_CR_SKILL_GADGET          =   7;
const int GS_CR_SKILL_UNKNOWN         =   8;

struct gsCRRecipe
{
    string sID;
    string sName;
    int nSkill;
    int nCategory;
    int nValue;

    int nInputCount1;
    string sInputResRef1;
    string sInputName1;
    int nInputCount2;
    string sInputResRef2;
    string sInputName2;
    int nInputCount3;
    string sInputResRef3;
    string sInputName3;
    int nInputCount4;
    string sInputResRef4;
    string sInputName4;
    int nInputCount5;
    string sInputResRef5;
    string sInputName5;
    int nInputCount6;
    string sInputResRef6;
    string sInputName6;
    int nInputCount7;
    string sInputResRef7;
    string sInputName7;

    int nOutputCount1;
    string sOutputResRef1;
    string sOutputName1;
    int nOutputCount2;
    string sOutputResRef2;
    string sOutputName2;
    int nOutputCount3;
    string sOutputResRef3;
    string sOutputName3;
    int nOutputCount4;
    string sOutputResRef4;
    string sOutputName4;
    int nOutputCount5;
    string sOutputResRef5;
    string sOutputName5;
    int nOutputCount6;
    string sOutputResRef6;
    string sOutputName6;
    int nOutputCount7;
    string sOutputResRef7;
    string sOutputName7;
};

struct gsCRQuantity
{
    int nCount1;
    int nCount2;
    int nCount3;
    int nCount4;
    int nCount5;
    int nCount6;
    int nCount7;
};

struct gsCRProduction
{
    int nSkill;
    string sRecipe;
    int nCraftPoints;
};

//return rank of oPC at nSkill
int gsCRGetSkillRank(int nSkill, object oPC = OBJECT_SELF);
//return TRUE if oPC is successfull at nSkill against nDC
int gsCRGetIsSkillSuccessful(int nSkill, int nDC, object oPC = OBJECT_SELF);
//return crafting skill points of oPC available for distribution
int gsCRGetSkillPoints(object oPC = OBJECT_SELF);
//internally used
int _gsCRGetSkillPoints(object oPC);
//increase rank of oPC at nSkill by 1
void gsCRIncreaseSkillRank(int nSkill, object oPC = OBJECT_SELF);
//reset skill rank of oPC
void gsCRResetSkillRank(object oPC = OBJECT_SELF);
//return name of nSkill
string gsCRGetSkillName(int nSkill);

//increase craft points of oPC by nValue
void gsCRIncreaseCraftPoints(int nValue = 1, object oPC = OBJECT_SELF);
//decrease craft points of oPC by nValue
void gsCRDecreaseCraftPoints(int nValue = 1, object oPC = OBJECT_SELF);
//set craft points of oPC to nValue
void gsCRSetCraftPoints(object oPC, int nValue);
//return craft points of oPC
int gsCRGetCraftPoints(object oPC);
//set craft timeout of oPC to nValue
void gsCRSetCraftTimeout(object oPC, int nValue);
//return craft timeout of oPC
int gsCRGetCraftTimeout(object oPC);

//add recipe for nSkill using contents of oInputContainer and oOutputContainer, if sID is not given, a random id is created
struct gsCRRecipe gsCRAddRecipe(object oInputContainer, object oOutputContainer, int nSkill, string sID = "");
//internally used
void _gsCRAddRecipe(object oContainer);
//internally used
int __gsCRAddRecipe(struct gsCRRecipe stRecipe);
//return recipe in nSlot of nSkill
struct gsCRRecipe gsCRGetRecipeInSlot(int nSkill, int nSlot);
//return recipe sID of nSkill
struct gsCRRecipe gsCRGetRecipeByID(int nSkill, string sID);
//return slot of first recipe in nCategory of nSkill at or after nSlot, return -1 if at end
int gsCRGetFirstRecipe(int nSkill, int nCategory, int nSlot = 0);
//internally used
int _gsCRGetFirstRecipe(int nSkill, int nCategory, int nSlot, int nStep = 1);
//return slot of recipe in nCategory of nSkill following nSlot, return -1 if at end
int gsCRGetNextRecipe(int nSkill, int nCategory, int nSlot = 0);
//return slot of recipe in nCategory of nSkill preceding nSlot, return -1 if at start
int gsCRGetPreviousRecipe(int nSkill, int nCategory, int nSlot = 0);
//remove recipe in nSlot from nSkill
void gsCRRemoveRecipeInSlot(int nSkill, int nSlot);
//remove recipe sID from nSkill
void gsCRRemoveRecipeByID(int nSkill, string sID);
//return dc of stRecipe
int gsCRGetRecipeDC(struct gsCRRecipe stRecipe);
//return number of craft points needed to finish stRecipe
int gsCRGetRecipeCraftPoints(struct gsCRRecipe stRecipe);
//return list of input material for stRecipe
string gsCRGetRecipeInputList(struct gsCRRecipe stRecipe);
//return list of output products of stRecipe
string gsCRGetRecipeOutputList(struct gsCRRecipe stRecipe);
//load recipe list of nSkill
void gsCRLoadRecipeList(int nSkill);
//internally used
void _gsCRLoadRecipeList(int nSkill, int nStart, int nEnd);
//internally used
int __gsCRLoadRecipeList(int nSkill, int nSlot);

//return first category containing recipes of nSkill at or after nCategory, return -1 if at end
int gsCRGetFirstCategory(int nSkill, int nCategory = 0);
//internally used
int _gsCRGetFirstCategory(int nSkill, int nCategory, int nStep = 1);
//return category containing recipes of nSkill following nCategory, return -1 if at end
int gsCRGetNextCategory(int nSkill, int nCategory = 0);
//return category containing recipes of nSkill preceding nCategory, return -1 if at start
int gsCRGetPreviousCategory(int nSkill, int nCategory = 0);
//increase number of recipes in nCategory of nSkill by 1
void gsCRIncreaseCategoryCount(int nSkill, int nCategory);
//internally used
void _gsCRIncreaseCategoryCount(int nSkill, int nCategory, int nValue = 1);
//decrease number of recipes in nCategory of nSkill by 1
void gsCRDecreaseCategoryCount(int nSkill, int nCategory);
//return number of recipes in nCategory of nSkill
int gsCRGetCategoryCount(int nSkill, int nCategory);
//return name of nCategory
string gsCRGetCategoryName(int nCategory);
//load category list
void gsCRLoadCategoryList();

//return quantity of material in oContainer required for stRecipe
struct gsCRQuantity gsCRGetQuantity(struct gsCRRecipe stRecipe, object oContainer = OBJECT_SELF);
//return TRUE if stQuantity is sufficient for stRecipe
int gsCRGetIsQuantitySufficient(struct gsCRRecipe stRecipe, struct gsCRQuantity stQuantity);
//return list of input material and stQuantity for stRecipe
string gsCRGetQuantityList(struct gsCRRecipe stRecipe, struct gsCRQuantity stQuantity);
//consume material in oContainer required for stRecipe
void gsCRConsumeMaterial(struct gsCRRecipe stRecipe, object oContainer = OBJECT_SELF);
//internally used
int _gsCRConsumeMaterial(object oItem, int nCount);

//return production of stRecipe using material in oContainer
void gsCRCreateProduction(struct gsCRRecipe stRecipe, object oPC, object oContainer = OBJECT_SELF);
//return production data of oItem
struct gsCRProduction gsCRGetProductionData(object oItem);
//return template of production item for nSkill
string gsCRGetProductionTemplate(int nSkill);
//produce oItem in oContainer by oPC using nValue craft points
void gsCRProduce(object oItem, object oPC, int nValue = 1, object oContainer = OBJECT_SELF);
//internally used
void _gsCRProduce(int nCount, string sResRef, object oContainer, object oPC = OBJECT_INVALID);

//play sound for nSkill
void gsCRPlaySound(int nSkill);

int gsCRGetSkillRank(int nSkill, object oPC = OBJECT_SELF)
{
    if (GetIsDM(oPC)) return 20;

    string sString = "GS_CR_SKILL_" + IntToString(nSkill);
    int nRank      = GetLocalInt(oPC, sString);

    if (! nRank)
    {
        sqlquery sqlGetSkills = SqlPrepareQueryCampaign(GS_CRAFTING_DATABASE, "SELECT json FROM skill_ranks WHERE id = @id");
        SqlBindString(sqlGetSkills, "@id", gsPCGetPlayerID(oPC));
        if(SqlStep(sqlGetSkills)){
            json jRankJson = SqlGetJson(sqlGetSkills, 0);
            json jRank = JsonObjectGet(jRankJson, IntToString(nSkill));
            if (JsonGetType(jRank) == JSON_TYPE_NULL)
            {
                nRank = 0;
            } else {
                nRank = JsonGetInt(jRank);
            }
        } else {
            sqlquery sqlInitializeSkillRank = SqlPrepareQueryCampaign(GS_CRAFTING_DATABASE, "INSERT INTO skill_ranks (id, json) VALUES (@id, @json);");
            SqlBindString(sqlInitializeSkillRank, "@id", gsPCGetPlayerID(oPC));
            SqlBindJson(sqlInitializeSkillRank, "@json", JsonObject());
            SqlStep(sqlInitializeSkillRank);
            nRank = 0;
        }
       // nRank = GetCampaignInt(sString, gsPCGetPlayerID(oPC));
        SetLocalInt(oPC, sString, nRank == 0 ? -1 : nRank);
        return nRank;
    }

    return nRank < 0 ? 0 : nRank;
}
//----------------------------------------------------------------
int gsCRGetIsSkillSuccessful(int nSkill, int nDC, object oPC = OBJECT_SELF)
{
    int nRank   = gsCRGetSkillRank(nSkill, oPC);
    int nDice   = d20();
    int nResult = nRank + nDice;
    int nFlag   = FALSE;

    while (nDice   !=  1 &&
           nDice   != 20 &&
           nResult == nDC)
    {
        nDice   = d20();
        nResult = nRank + nDice;
    }

    nFlag       = nDice == 20 || (nDice != 1 && nResult > nDC);

    SendMessageToPC(oPC,
                    "<c™þþ>" + GetName(oPC) + " <c fþ>: " +
                    GS_T_16777219 + " (" + gsCRGetSkillName(nSkill) + "<c fþ>) : " +
                    (nFlag ? GS_T_16777217 : GS_T_16777218) + " : " +
                    "(" + IntToString(nRank) + " " +
                    "+ " + IntToString(nDice) + " " +
                    "= " + IntToString(nResult) + " " +
                    GS_T_16777220 + ": " + IntToString(nDC) + ")");

    return nFlag;
}
//----------------------------------------------------------------
int gsCRGetSkillPoints(object oPC = OBJECT_SELF)
{
    return GetHitDice(oPC) * 2 - _gsCRGetSkillPoints(oPC);
}
//----------------------------------------------------------------
int _gsCRGetSkillPoints(object oPC)
{
    return gsCRGetSkillRank(GS_CR_SKILL_CARPENTER, oPC) +
           gsCRGetSkillRank(GS_CR_SKILL_COOK,      oPC) +
           gsCRGetSkillRank(GS_CR_SKILL_CRAFT_ART, oPC) +
           gsCRGetSkillRank(GS_CR_SKILL_FORGE,     oPC) +
           gsCRGetSkillRank(GS_CR_SKILL_MELD,      oPC) +
           gsCRGetSkillRank(GS_CR_SKILL_SEW,       oPC) +
           gsCRGetSkillRank(GS_CR_SKILL_GADGET,       oPC) +
           gsCRGetSkillRank(GS_CR_SKILL_UNKNOWN,       oPC);
}
//----------------------------------------------------------------
void gsCRIncreaseSkillRank(int nSkill, object oPC = OBJECT_SELF)
{
    if (GetIsDM(oPC)) return;

    if (gsCRGetSkillPoints(oPC))
    {
        string sString = "GS_CR_SKILL_" + IntToString(nSkill);
        int nRank      = gsCRGetSkillRank(nSkill, oPC) + 1;

        SetLocalInt(oPC, sString, nRank == 0 ? -1 : nRank);

        sqlquery sqlGetSkills = SqlPrepareQueryCampaign(GS_CRAFTING_DATABASE, "SELECT json FROM skill_ranks WHERE id = @id");
        SqlBindString(sqlGetSkills, "@id", gsPCGetPlayerID(oPC));
        SqlStep(sqlGetSkills);
        json jRankJson = SqlGetJson(sqlGetSkills, 0);
        json jUpdatedJson = JsonObjectSet(jRankJson, IntToString(nSkill), JsonInt(nRank));
        sqlquery sqlUpdateSkills = SqlPrepareQueryCampaign(GS_CRAFTING_DATABASE, "UPDATE skill_ranks SET json = @json WHERE id = @id");
        SqlBindString(sqlUpdateSkills, "@id", gsPCGetPlayerID(oPC));
        SqlBindJson(sqlUpdateSkills, "@json", jUpdatedJson);
        SqlStep(sqlUpdateSkills);

        //SetCampaignInt(sString, gsPCGetPlayerID(oPC), nRank);
        gsCRIncreaseCraftPoints(1, oPC);
    }
}
//----------------------------------------------------------------
void gsCRResetSkillRank(object oPC = OBJECT_SELF)
{
    if (GetIsDM(oPC)) return;

    string sPlayerID = gsPCGetPlayerID(oPC);
    string sString   = "";
    json jUpdatedJson = JsonObject();
    JsonObjectSet(jUpdatedJson, "1", JsonInt(0));
    JsonObjectSet(jUpdatedJson, "2", JsonInt(0));
    JsonObjectSet(jUpdatedJson, "3", JsonInt(0));
    JsonObjectSet(jUpdatedJson, "4", JsonInt(0));
    JsonObjectSet(jUpdatedJson, "5", JsonInt(0));
    JsonObjectSet(jUpdatedJson, "6", JsonInt(0));
    JsonObjectSet(jUpdatedJson, "7", JsonInt(0));
    JsonObjectSet(jUpdatedJson, "8", JsonInt(0));

    sqlquery sqlUpdateSkills = SqlPrepareQueryCampaign(GS_CRAFTING_DATABASE, "UPDATE skill_ranks SET json = @json WHERE id = @id");
    SqlBindString(sqlUpdateSkills, "@id", sPlayerID);
    SqlBindJson(sqlUpdateSkills, "@json", jUpdatedJson);
    SqlStep(sqlUpdateSkills);

    sString          = "GS_CR_SKILL_" + IntToString(GS_CR_SKILL_CARPENTER);
    SetLocalInt(oPC, sString, -1);
    //SetCampaignInt(sString, sPlayerID, 0);

    sString          = "GS_CR_SKILL_" + IntToString(GS_CR_SKILL_COOK);
    SetLocalInt(oPC, sString, -1);
    //SetCampaignInt(sString, sPlayerID, 0);

    sString          = "GS_CR_SKILL_" + IntToString(GS_CR_SKILL_CRAFT_ART);
    SetLocalInt(oPC, sString, -1);
    //SetCampaignInt(sString, sPlayerID, 0);

    sString          = "GS_CR_SKILL_" + IntToString(GS_CR_SKILL_FORGE);
    SetLocalInt(oPC, sString, -1);
    //SetCampaignInt(sString, sPlayerID, 0);

    sString          = "GS_CR_SKILL_" + IntToString(GS_CR_SKILL_MELD);
    SetLocalInt(oPC, sString, -1);
    //SetCampaignInt(sString, sPlayerID, 0);

    sString          = "GS_CR_SKILL_" + IntToString(GS_CR_SKILL_SEW);
    SetLocalInt(oPC, sString, -1);
    //SetCampaignInt(sString, sPlayerID, 0);

    sString          = "GS_CR_SKILL_" + IntToString(GS_CR_SKILL_GADGET);
    SetLocalInt(oPC, sString, -1);
    //SetCampaignInt(sString, sPlayerID, 0);

    sString          = "GS_CR_SKILL_" + IntToString(GS_CR_SKILL_UNKNOWN);
    SetLocalInt(oPC, sString, -1);
    //SetCampaignInt(sString, sPlayerID, 0);
}
//----------------------------------------------------------------
string gsCRGetSkillName(int nSkill)
{
    switch (nSkill)
    {
    case GS_CR_SKILL_CARPENTER: return "<c¡Òš>" + GS_T_16777221 + "<cþþþ>";
    case GS_CR_SKILL_COOK:      return "<cýÄˆ>" + GS_T_16777222 + "<cþþþ>";
    case GS_CR_SKILL_CRAFT_ART: return "<cþ÷˜>" + GS_T_16777223 + "<cþþþ>";
    case GS_CR_SKILL_FORGE:     return "<cmÎö>" + GS_T_16777224 + "<cþþþ>";
    case GS_CR_SKILL_MELD:      return "<c»‹¾>" + GS_T_16777225 + "<cþþþ>";
    case GS_CR_SKILL_SEW:       return "<cÄ›m>" + GS_T_16777226 + "<cþþþ>";
    case GS_CR_SKILL_GADGET:    return "<cÿ?B>" + GS_T_16777651 + "<cþþþ>";
    }

    return "";
}
//----------------------------------------------------------------
void gsCRIncreaseCraftPoints(int nValue = 1, object oPC = OBJECT_SELF)
{
    gsCRSetCraftPoints(oPC, gsCRGetCraftPoints(oPC) + nValue);
}
//----------------------------------------------------------------
void gsCRDecreaseCraftPoints(int nValue = 1, object oPC = OBJECT_SELF)
{
    gsCRIncreaseCraftPoints(-nValue, oPC);
}
//----------------------------------------------------------------
void gsCRSetCraftPoints(object oPC, int nValue)
{   
    sqlquery sqlInsertOrUpdatePointsTable = SqlPrepareQueryCampaign(GS_CRAFTING_DATABASE, "INSERT INTO craft_points (id, points) VALUES (@id, @points) ON CONFLICT (id) DO UPDATE SET points = excluded.points;");  
    SqlBindString(sqlInsertOrUpdatePointsTable, "@id", gsPCGetPlayerID(oPC));
    SqlBindInt(sqlInsertOrUpdatePointsTable, "@points", nValue); 
    SqlStep(sqlInsertOrUpdatePointsTable);

    SetLocalInt(oPC, "GS_CR_CRAFT_POINTS", nValue <= 0 ? -1 : nValue);
    //SetCampaignInt("GS_CR_CRAFT_POINTS", gsPCGetPlayerID(oPC), nValue);
}
//----------------------------------------------------------------
int gsCRGetCraftPoints(object oPC)
{
    if (GetIsDM(oPC)) return 120;

    int nTimestamp = gsTIGetActualTimestamp();
    int nTimeout   = gsCRGetCraftTimeout(oPC);
    int nValue     = 0;

    if (nTimeout < nTimestamp)
    {
        nTimeout = nTimestamp + 28800; //TIME UPDATE: 8 hours
        nValue   = _gsCRGetSkillPoints(oPC);

        gsCRSetCraftTimeout(oPC, nTimeout);
        gsCRSetCraftPoints(oPC, nValue);
    }
    else
    {
        nValue   = GetLocalInt(oPC, "GS_CR_CRAFT_POINTS");

        if (! nValue)
        {
            sqlquery sqlGetCraftPoints = SqlPrepareQueryCampaign(GS_CRAFTING_DATABASE, "SELECT points FROM craft_points WHERE id = @id");
            SqlBindString(sqlGetCraftPoints, "@id", gsPCGetPlayerID(oPC));
            if(SqlStep(sqlGetCraftPoints))
            {
                nValue = SqlGetInt(sqlGetCraftPoints, 0);
            }
            else
            {
                nValue = 0;
            }

            //nValue = GetCampaignInt("GS_CR_CRAFT_POINTS", gsPCGetPlayerID(oPC));
            SetLocalInt(oPC, "GS_CR_CRAFT_POINTS", nValue <= 0 ? -1 : nValue);
            return nValue;
        }
    }

    return nValue < 0 ? 0 : nValue;
}
//----------------------------------------------------------------
void gsCRSetCraftTimeout(object oPC, int nValue)
{
    sqlquery sqlInsertOrUpdateTimeoutTable = SqlPrepareQueryCampaign(GS_CRAFTING_DATABASE, "INSERT INTO craft_timeout (id, timeout) VALUES (@id, @timeout) ON CONFLICT (id) DO UPDATE SET timeout = excluded.timeout;");  
    SqlBindString(sqlInsertOrUpdateTimeoutTable, "@id", gsPCGetPlayerID(oPC));
    SqlBindInt(sqlInsertOrUpdateTimeoutTable, "@timeout", nValue); 
    SqlStep(sqlInsertOrUpdateTimeoutTable);

    SetLocalInt(oPC, "GS_CR_CRAFT_TIMEOUT", nValue <= 0 ? -1 : nValue);
    //SetCampaignInt("GS_CR_CRAFT_TIMEOUT", gsPCGetPlayerID(oPC), nValue);
}
//----------------------------------------------------------------
int gsCRGetCraftTimeout(object oPC)
{
    int nValue = GetLocalInt(oPC, "GS_CR_CRAFT_TIMEOUT");

    if (! nValue)
    {
        sqlquery sqlGetCraftTimeout = SqlPrepareQueryCampaign(GS_CRAFTING_DATABASE, "SELECT timeout FROM craft_timeout WHERE id = @id");
        SqlBindString(sqlGetCraftTimeout, "@id", gsPCGetPlayerID(oPC));
        if(SqlStep(sqlGetCraftTimeout))
        {
            nValue = SqlGetInt(sqlGetCraftTimeout, 0);
        }
        else
        {
            nValue = 0;
        }
        //nValue = GetCampaignInt("GS_CR_CRAFT_TIMEOUT", gsPCGetPlayerID(oPC));
        SetLocalInt(oPC, "GS_CR_CRAFT_TIMEOUT", nValue <= 0 ? -1 : nValue);
        return nValue;
    }

    return nValue < 0 ? 0 : nValue;
}
//----------------------------------------------------------------
struct gsCRRecipe gsCRAddRecipe(object oInputContainer, object oOutputContainer, int nSkill, string sID = "")
{
    object oModule           = GetModule();
    struct gsCRRecipe stRecipe;
    int nSlot                = 0;

    _gsCRAddRecipe(oInputContainer);
    _gsCRAddRecipe(oOutputContainer);

    stRecipe.sID             = sID == "" ? gsCMCreateRandomID(16) : sID;
    stRecipe.sName           = GetLocalString(oOutputContainer, "GS_CR_NAME");
    stRecipe.nSkill          = nSkill;
    stRecipe.nCategory       = GetLocalInt(oOutputContainer, "GS_CR_CATEGORY");
    stRecipe.nValue          = GetLocalInt(oOutputContainer, "GS_CR_VALUE");

    stRecipe.nInputCount1    = GetLocalInt(oInputContainer, "GS_CR_COUNT_1");
    stRecipe.sInputResRef1   = GetLocalString(oInputContainer, "GS_CR_RESREF_1");
    stRecipe.sInputName1     = GetLocalString(oInputContainer, "GS_CR_NAME_1");
    stRecipe.nInputCount2    = GetLocalInt(oInputContainer, "GS_CR_COUNT_2");
    stRecipe.sInputResRef2   = GetLocalString(oInputContainer, "GS_CR_RESREF_2");
    stRecipe.sInputName2     = GetLocalString(oInputContainer, "GS_CR_NAME_2");
    stRecipe.nInputCount3    = GetLocalInt(oInputContainer, "GS_CR_COUNT_3");
    stRecipe.sInputResRef3   = GetLocalString(oInputContainer, "GS_CR_RESREF_3");
    stRecipe.sInputName3     = GetLocalString(oInputContainer, "GS_CR_NAME_3");
    stRecipe.nInputCount4    = GetLocalInt(oInputContainer, "GS_CR_COUNT_4");
    stRecipe.sInputResRef4   = GetLocalString(oInputContainer, "GS_CR_RESREF_4");
    stRecipe.sInputName4     = GetLocalString(oInputContainer, "GS_CR_NAME_4");
    stRecipe.nInputCount5    = GetLocalInt(oInputContainer, "GS_CR_COUNT_5");
    stRecipe.sInputResRef5   = GetLocalString(oInputContainer, "GS_CR_RESREF_5");
    stRecipe.sInputName5     = GetLocalString(oInputContainer, "GS_CR_NAME_5");
    stRecipe.nInputCount6    = GetLocalInt(oInputContainer, "GS_CR_COUNT_6");
    stRecipe.sInputResRef6   = GetLocalString(oInputContainer, "GS_CR_RESREF_6");
    stRecipe.sInputName6     = GetLocalString(oInputContainer, "GS_CR_NAME_6");
    stRecipe.nInputCount7    = GetLocalInt(oInputContainer, "GS_CR_COUNT_7");
    stRecipe.sInputResRef7   = GetLocalString(oInputContainer, "GS_CR_RESREF_7");
    stRecipe.sInputName7     = GetLocalString(oInputContainer, "GS_CR_NAME_7");

    stRecipe.nOutputCount1   = GetLocalInt(oOutputContainer, "GS_CR_COUNT_1");
    stRecipe.sOutputResRef1  = GetLocalString(oOutputContainer, "GS_CR_RESREF_1");
    stRecipe.sOutputName1    = GetLocalString(oOutputContainer, "GS_CR_NAME_1");
    stRecipe.nOutputCount2   = GetLocalInt(oOutputContainer, "GS_CR_COUNT_2");
    stRecipe.sOutputResRef2  = GetLocalString(oOutputContainer, "GS_CR_RESREF_2");
    stRecipe.sOutputName2    = GetLocalString(oOutputContainer, "GS_CR_NAME_2");
    stRecipe.nOutputCount3   = GetLocalInt(oOutputContainer, "GS_CR_COUNT_3");
    stRecipe.sOutputResRef3  = GetLocalString(oOutputContainer, "GS_CR_RESREF_3");
    stRecipe.sOutputName3    = GetLocalString(oOutputContainer, "GS_CR_NAME_3");
    stRecipe.nOutputCount4   = GetLocalInt(oOutputContainer, "GS_CR_COUNT_4");
    stRecipe.sOutputResRef4  = GetLocalString(oOutputContainer, "GS_CR_RESREF_4");
    stRecipe.sOutputName4    = GetLocalString(oOutputContainer, "GS_CR_NAME_4");
    stRecipe.nOutputCount5   = GetLocalInt(oOutputContainer, "GS_CR_COUNT_5");
    stRecipe.sOutputResRef5  = GetLocalString(oOutputContainer, "GS_CR_RESREF_5");
    stRecipe.sOutputName5    = GetLocalString(oOutputContainer, "GS_CR_NAME_5");
    stRecipe.nOutputCount6   = GetLocalInt(oOutputContainer, "GS_CR_COUNT_6");
    stRecipe.sOutputResRef6  = GetLocalString(oOutputContainer, "GS_CR_RESREF_6");
    stRecipe.sOutputName6    = GetLocalString(oOutputContainer, "GS_CR_NAME_6");
    stRecipe.nOutputCount7   = GetLocalInt(oOutputContainer, "GS_CR_COUNT_7");
    stRecipe.sOutputResRef7  = GetLocalString(oOutputContainer, "GS_CR_RESREF_7");
    stRecipe.sOutputName7    = GetLocalString(oOutputContainer, "GS_CR_NAME_7");

    nSlot                    = __gsCRAddRecipe(stRecipe);
    if (nSlot) __gsCRLoadRecipeList(nSkill, nSlot);

    return stRecipe;
}
//----------------------------------------------------------------
void _gsCRAddRecipe(object oContainer)
{
    object oItem1     = OBJECT_INVALID;
    object oItem2     = OBJECT_INVALID;
    string sName      = "";
    string sResRef1   = "";
    string sResRef2   = "";
    string sNth       = "";
    int nValueTotal   = 0;
    int nValueMaximum = 0;
    int nValue        = 0;
    int nCount        = 0;
    int nNth          = 1;

    //reset list
    for (; nNth <= 7; nNth++)
    {
        sNth = IntToString(nNth);
        DeleteLocalInt(oContainer, "GS_CR_COUNT_" + sNth);
        DeleteLocalString(oContainer, "GS_CR_RESREF_" + sNth);
    }

    //build list
    oItem1 = GetFirstItemInInventory(oContainer);

    while (GetIsObjectValid(oItem1))
    {
        sResRef1     = GetResRef(oItem1);
        nValue       = gsCMGetItemValue(oItem1);
        nValueTotal += nValue;

        //find most valuable item
        if (nValue > nValueMaximum)
        {
            oItem2        = oItem1;
            nValueMaximum = nValue;
        }

        for (nNth = 1; nNth <= 7; nNth++)
        {
            sNth     = IntToString(nNth);
            sResRef2 = GetLocalString(oContainer, "GS_CR_RESREF_" + sNth);

            //not in list
            if (sResRef2 == "")
            {
                SetLocalInt(oContainer, "GS_CR_COUNT_" + sNth, GetItemStackSize(oItem1));
                SetLocalString(oContainer, "GS_CR_RESREF_" + sNth, sResRef1);
                SetLocalString(oContainer, "GS_CR_NAME_" + sNth, GetName(oItem1, TRUE));
                break;
            }

            //already in list, increase count
            if (sResRef1 == sResRef2)
            {
                nCount = GetLocalInt(oContainer, "GS_CR_COUNT_" + sNth) +
                         GetItemStackSize(oItem1);
                SetLocalInt(oContainer, "GS_CR_COUNT_" + sNth, nCount);
                break;
            }
        }

        if (nNth == 8) break;

        oItem1   = GetNextItemInInventory(oContainer);
    }

    SetLocalString(oContainer, "GS_CR_NAME", GetName(oItem2, TRUE));
    SetLocalInt(oContainer, "GS_CR_CATEGORY", GetBaseItemType(oItem2));
    SetLocalInt(oContainer, "GS_CR_VALUE", nValueTotal);
}
//----------------------------------------------------------------
int __gsCRAddRecipe(struct gsCRRecipe stRecipe)
{
    object oModule   = GetModule();
    string sDatabase = "GS_CR_RECIPE_" + IntToString(stRecipe.nSkill);
    string sSlot     = "";
    int nSlot        = 1;

    //find empty slot
    for (; nSlot <= GS_CR_LIMIT_RECIPE; nSlot++)
    {
        sSlot = IntToString(nSlot);
        if (GetLocalString(oModule, sDatabase + "_" + sSlot + "_ID") == "") break;
    }

    if (nSlot > GS_CR_LIMIT_RECIPE) return FALSE; //no empty slot

    sqlquery sqlAddRecipe = SqlPrepareQueryCampaign(GS_CRAFTING_DATABASE, "INSERT INTO recipes (id, skill, slot, json) VALUES (@id, @skill, @slot, @json);");
    SqlBindString(sqlAddRecipe, "@id", stRecipe.sID);
    SqlBindInt(sqlAddRecipe, "@skill", stRecipe.nSkill);
    SqlBindInt(sqlAddRecipe, "@slot", nSlot);

    json jRecipe = JsonObject();
    jRecipe = JsonObjectSet(jRecipe, "sName", JsonString(stRecipe.sName));
    jRecipe = JsonObjectSet(jRecipe, "nCategory", JsonInt(stRecipe.nCategory));
    jRecipe = JsonObjectSet(jRecipe, "nValue", JsonInt(stRecipe.nValue));

    jRecipe = JsonObjectSet(jRecipe, "nInputCount1", JsonInt(stRecipe.nInputCount1));
    jRecipe = JsonObjectSet(jRecipe, "sInputResRef1", JsonString(stRecipe.sInputResRef1));
    jRecipe = JsonObjectSet(jRecipe, "sInputName1", JsonString(stRecipe.sInputName1));
    jRecipe = JsonObjectSet(jRecipe, "nInputCount2", JsonInt(stRecipe.nInputCount2));
    jRecipe = JsonObjectSet(jRecipe, "sInputResRef2", JsonString(stRecipe.sInputResRef2));
    jRecipe = JsonObjectSet(jRecipe, "sInputName2", JsonString(stRecipe.sInputName2));
    jRecipe = JsonObjectSet(jRecipe, "nInputCount3", JsonInt(stRecipe.nInputCount3));
    jRecipe = JsonObjectSet(jRecipe, "sInputResRef3", JsonString(stRecipe.sInputResRef3));
    jRecipe = JsonObjectSet(jRecipe, "sInputName3", JsonString(stRecipe.sInputName3));
    jRecipe = JsonObjectSet(jRecipe, "nInputCount4", JsonInt(stRecipe.nInputCount4));
    jRecipe = JsonObjectSet(jRecipe, "sInputResRef4", JsonString(stRecipe.sInputResRef4));
    jRecipe = JsonObjectSet(jRecipe, "sInputName4", JsonString(stRecipe.sInputName4));
    jRecipe = JsonObjectSet(jRecipe, "nInputCount5", JsonInt(stRecipe.nInputCount5));
    jRecipe = JsonObjectSet(jRecipe, "sInputResRef5", JsonString(stRecipe.sInputResRef5));
    jRecipe = JsonObjectSet(jRecipe, "sInputName5", JsonString(stRecipe.sInputName5));
    jRecipe = JsonObjectSet(jRecipe, "nInputCount6", JsonInt(stRecipe.nInputCount6));
    jRecipe = JsonObjectSet(jRecipe, "sInputResRef6", JsonString(stRecipe.sInputResRef6));
    jRecipe = JsonObjectSet(jRecipe, "sInputName6", JsonString(stRecipe.sInputName6));
    jRecipe = JsonObjectSet(jRecipe, "nInputCount7", JsonInt(stRecipe.nInputCount7));
    jRecipe = JsonObjectSet(jRecipe, "sInputResRef7", JsonString(stRecipe.sInputResRef7));
    jRecipe = JsonObjectSet(jRecipe, "sInputName7", JsonString(stRecipe.sInputName7));

    jRecipe = JsonObjectSet(jRecipe, "nOutputCount1", JsonInt(stRecipe.nOutputCount1));
    jRecipe = JsonObjectSet(jRecipe, "sOutputResRef1", JsonString(stRecipe.sOutputResRef1));
    jRecipe = JsonObjectSet(jRecipe, "sOutputName1", JsonString(stRecipe.sOutputName1));
    jRecipe = JsonObjectSet(jRecipe, "nOutputCount2", JsonInt(stRecipe.nOutputCount2));
    jRecipe = JsonObjectSet(jRecipe, "sOutputResRef2", JsonString(stRecipe.sOutputResRef2));
    jRecipe = JsonObjectSet(jRecipe, "sOutputName2", JsonString(stRecipe.sOutputName2));
    jRecipe = JsonObjectSet(jRecipe, "nOutputCount3", JsonInt(stRecipe.nOutputCount3));
    jRecipe = JsonObjectSet(jRecipe, "sOutputResRef3", JsonString(stRecipe.sOutputResRef3));
    jRecipe = JsonObjectSet(jRecipe, "sOutputName3", JsonString(stRecipe.sOutputName3));
    jRecipe = JsonObjectSet(jRecipe, "nOutputCount4", JsonInt(stRecipe.nOutputCount4));
    jRecipe = JsonObjectSet(jRecipe, "sOutputResRef4", JsonString(stRecipe.sOutputResRef4));
    jRecipe = JsonObjectSet(jRecipe, "sOutputName4", JsonString(stRecipe.sOutputName4));
    jRecipe = JsonObjectSet(jRecipe, "nOutputCount5", JsonInt(stRecipe.nOutputCount5));
    jRecipe = JsonObjectSet(jRecipe, "sOutputResRef5", JsonString(stRecipe.sOutputResRef5));
    jRecipe = JsonObjectSet(jRecipe, "sOutputName5", JsonString(stRecipe.sOutputName5));
    jRecipe = JsonObjectSet(jRecipe, "nOutputCount6", JsonInt(stRecipe.nOutputCount6));
    jRecipe = JsonObjectSet(jRecipe, "sOutputResRef6", JsonString(stRecipe.sOutputResRef6));
    jRecipe = JsonObjectSet(jRecipe, "sOutputName6", JsonString(stRecipe.sOutputName6));
    jRecipe = JsonObjectSet(jRecipe, "nOutputCount7", JsonInt(stRecipe.nOutputCount7));
    jRecipe = JsonObjectSet(jRecipe, "sOutputResRef7", JsonString(stRecipe.sOutputResRef7));
    jRecipe = JsonObjectSet(jRecipe, "sOutputName7", JsonString(stRecipe.sOutputName7));

    SqlBindJson(sqlAddRecipe, "@json", jRecipe);

    SqlStep(sqlAddRecipe);

    //SetCampaignString(sDatabase, "ID_" + sSlot, stRecipe.sID);
    //SetCampaignString(sDatabase, "NAME_" + sSlot, stRecipe.sName);
    //SetCampaignInt(sDatabase, "CATEGORY_" + sSlot, stRecipe.nCategory);
    //SetCampaignInt(sDatabase, "VALUE_" + sSlot, stRecipe.nValue);
    /*
    SetCampaignInt(sDatabase, "INPUT_COUNT_" + sSlot + "_1", stRecipe.nInputCount1);
    SetCampaignString(sDatabase, "INPUT_RESREF_" + sSlot + "_1", stRecipe.sInputResRef1);
    SetCampaignString(sDatabase, "INPUT_NAME_" + sSlot + "_1", stRecipe.sInputName1);
    SetCampaignInt(sDatabase, "INPUT_COUNT_" + sSlot + "_2", stRecipe.nInputCount2);
    SetCampaignString(sDatabase, "INPUT_RESREF_" + sSlot + "_2", stRecipe.sInputResRef2);
    SetCampaignString(sDatabase, "INPUT_NAME_" + sSlot + "_2", stRecipe.sInputName2);
    SetCampaignInt(sDatabase, "INPUT_COUNT_" + sSlot + "_3", stRecipe.nInputCount3);
    SetCampaignString(sDatabase, "INPUT_RESREF_" + sSlot + "_3", stRecipe.sInputResRef3);
    SetCampaignString(sDatabase, "INPUT_NAME_" + sSlot + "_3", stRecipe.sInputName3);
    SetCampaignInt(sDatabase, "INPUT_COUNT_" + sSlot + "_4", stRecipe.nInputCount4);
    SetCampaignString(sDatabase, "INPUT_RESREF_" + sSlot + "_4", stRecipe.sInputResRef4);
    SetCampaignString(sDatabase, "INPUT_NAME_" + sSlot + "_4", stRecipe.sInputName4);
    SetCampaignInt(sDatabase, "INPUT_COUNT_" + sSlot + "_5", stRecipe.nInputCount5);
    SetCampaignString(sDatabase, "INPUT_RESREF_" + sSlot + "_5", stRecipe.sInputResRef5);
    SetCampaignString(sDatabase, "INPUT_NAME_" + sSlot + "_5", stRecipe.sInputName5);
    SetCampaignInt(sDatabase, "INPUT_COUNT_" + sSlot + "_6", stRecipe.nInputCount6);
    SetCampaignString(sDatabase, "INPUT_RESREF_" + sSlot + "_6", stRecipe.sInputResRef6);
    SetCampaignString(sDatabase, "INPUT_NAME_" + sSlot + "_6", stRecipe.sInputName6);
    SetCampaignInt(sDatabase, "INPUT_COUNT_" + sSlot + "_7", stRecipe.nInputCount7);
    SetCampaignString(sDatabase, "INPUT_RESREF_" + sSlot + "_7", stRecipe.sInputResRef7);
    SetCampaignString(sDatabase, "INPUT_NAME_" + sSlot + "_7", stRecipe.sInputName7);

    SetCampaignInt(sDatabase, "OUTPUT_COUNT_" + sSlot + "_1", stRecipe.nOutputCount1);
    SetCampaignString(sDatabase, "OUTPUT_RESREF_" + sSlot + "_1", stRecipe.sOutputResRef1);
    SetCampaignString(sDatabase, "OUTPUT_NAME_" + sSlot + "_1", stRecipe.sOutputName1);
    SetCampaignInt(sDatabase, "OUTPUT_COUNT_" + sSlot + "_2", stRecipe.nOutputCount2);
    SetCampaignString(sDatabase, "OUTPUT_RESREF_" + sSlot + "_2", stRecipe.sOutputResRef2);
    SetCampaignString(sDatabase, "OUTPUT_NAME_" + sSlot + "_2", stRecipe.sOutputName2);
    SetCampaignInt(sDatabase, "OUTPUT_COUNT_" + sSlot + "_3", stRecipe.nOutputCount3);
    SetCampaignString(sDatabase, "OUTPUT_RESREF_" + sSlot + "_3", stRecipe.sOutputResRef3);
    SetCampaignString(sDatabase, "OUTPUT_NAME_" + sSlot + "_3", stRecipe.sOutputName3);
    SetCampaignInt(sDatabase, "OUTPUT_COUNT_" + sSlot + "_4", stRecipe.nOutputCount4);
    SetCampaignString(sDatabase, "OUTPUT_RESREF_" + sSlot + "_4", stRecipe.sOutputResRef4);
    SetCampaignString(sDatabase, "OUTPUT_NAME_" + sSlot + "_4", stRecipe.sOutputName4);
    SetCampaignInt(sDatabase, "OUTPUT_COUNT_" + sSlot + "_5", stRecipe.nOutputCount5);
    SetCampaignString(sDatabase, "OUTPUT_RESREF_" + sSlot + "_5", stRecipe.sOutputResRef5);
    SetCampaignString(sDatabase, "OUTPUT_NAME_" + sSlot + "_5", stRecipe.sOutputName5);
    SetCampaignInt(sDatabase, "OUTPUT_COUNT_" + sSlot + "_6", stRecipe.nOutputCount6);
    SetCampaignString(sDatabase, "OUTPUT_RESREF_" + sSlot + "_6", stRecipe.sOutputResRef6);
    SetCampaignString(sDatabase, "OUTPUT_NAME_" + sSlot + "_6", stRecipe.sOutputName6);
    SetCampaignInt(sDatabase, "OUTPUT_COUNT_" + sSlot + "_7", stRecipe.nOutputCount7);
    SetCampaignString(sDatabase, "OUTPUT_RESREF_" + sSlot + "_7", stRecipe.sOutputResRef7);
    SetCampaignString(sDatabase, "OUTPUT_NAME_" + sSlot + "_7", stRecipe.sOutputName7);

    SetCampaignInt(sDatabase, "SLOT_" + sSlot, TRUE);

    */

    return nSlot;
}
//----------------------------------------------------------------
struct gsCRRecipe gsCRGetRecipeInSlot(int nSkill, int nSlot)
{
    object oModule           = GetModule();
    struct gsCRRecipe stRecipe;
    string sString           = "GS_CR_RECIPE_" +
                               IntToString(nSkill) + "_" +
                               IntToString(nSlot) + "_";
    string sID               = GetLocalString(oModule, sString + "ID");

    if (sID == "") return stRecipe;

    stRecipe.sID             = sID;
    stRecipe.sName           = GetLocalString(oModule, sString + "NAME");
    stRecipe.nSkill          = nSkill;
    stRecipe.nCategory       = GetLocalInt(oModule, sString + "CATEGORY");
    stRecipe.nValue          = GetLocalInt(oModule, sString + "VALUE");

    stRecipe.nInputCount1    = GetLocalInt(oModule, sString + "INPUT_COUNT_1");
    stRecipe.sInputResRef1   = GetLocalString(oModule, sString + "INPUT_RESREF_1");
    stRecipe.sInputName1     = GetLocalString(oModule, sString + "INPUT_NAME_1");
    stRecipe.nInputCount2    = GetLocalInt(oModule, sString + "INPUT_COUNT_2");
    stRecipe.sInputResRef2   = GetLocalString(oModule, sString + "INPUT_RESREF_2");
    stRecipe.sInputName2     = GetLocalString(oModule, sString + "INPUT_NAME_2");
    stRecipe.nInputCount3    = GetLocalInt(oModule, sString + "INPUT_COUNT_3");
    stRecipe.sInputResRef3   = GetLocalString(oModule, sString + "INPUT_RESREF_3");
    stRecipe.sInputName3     = GetLocalString(oModule, sString + "INPUT_NAME_3");
    stRecipe.nInputCount4    = GetLocalInt(oModule, sString + "INPUT_COUNT_4");
    stRecipe.sInputResRef4   = GetLocalString(oModule, sString + "INPUT_RESREF_4");
    stRecipe.sInputName4     = GetLocalString(oModule, sString + "INPUT_NAME_4");
    stRecipe.nInputCount5    = GetLocalInt(oModule, sString + "INPUT_COUNT_5");
    stRecipe.sInputResRef5   = GetLocalString(oModule, sString + "INPUT_RESREF_5");
    stRecipe.sInputName5     = GetLocalString(oModule, sString + "INPUT_NAME_5");
    stRecipe.nInputCount6    = GetLocalInt(oModule, sString + "INPUT_COUNT_6");
    stRecipe.sInputResRef6   = GetLocalString(oModule, sString + "INPUT_RESREF_6");
    stRecipe.sInputName6     = GetLocalString(oModule, sString + "INPUT_NAME_6");
    stRecipe.nInputCount7    = GetLocalInt(oModule, sString + "INPUT_COUNT_7");
    stRecipe.sInputResRef7   = GetLocalString(oModule, sString + "INPUT_RESREF_7");
    stRecipe.sInputName7     = GetLocalString(oModule, sString + "INPUT_NAME_7");

    stRecipe.nOutputCount1   = GetLocalInt(oModule, sString + "OUTPUT_COUNT_1");
    stRecipe.sOutputResRef1  = GetLocalString(oModule, sString + "OUTPUT_RESREF_1");
    stRecipe.sOutputName1    = GetLocalString(oModule, sString + "OUTPUT_NAME_1");
    stRecipe.nOutputCount2   = GetLocalInt(oModule, sString + "OUTPUT_COUNT_2");
    stRecipe.sOutputResRef2  = GetLocalString(oModule, sString + "OUTPUT_RESREF_2");
    stRecipe.sOutputName2    = GetLocalString(oModule, sString + "OUTPUT_NAME_2");
    stRecipe.nOutputCount3   = GetLocalInt(oModule, sString + "OUTPUT_COUNT_3");
    stRecipe.sOutputResRef3  = GetLocalString(oModule, sString + "OUTPUT_RESREF_3");
    stRecipe.sOutputName3    = GetLocalString(oModule, sString + "OUTPUT_NAME_3");
    stRecipe.nOutputCount4   = GetLocalInt(oModule, sString + "OUTPUT_COUNT_4");
    stRecipe.sOutputResRef4  = GetLocalString(oModule, sString + "OUTPUT_RESREF_4");
    stRecipe.sOutputName4    = GetLocalString(oModule, sString + "OUTPUT_NAME_4");
    stRecipe.nOutputCount5   = GetLocalInt(oModule, sString + "OUTPUT_COUNT_5");
    stRecipe.sOutputResRef5  = GetLocalString(oModule, sString + "OUTPUT_RESREF_5");
    stRecipe.sOutputName5    = GetLocalString(oModule, sString + "OUTPUT_NAME_5");
    stRecipe.nOutputCount6   = GetLocalInt(oModule, sString + "OUTPUT_COUNT_6");
    stRecipe.sOutputResRef6  = GetLocalString(oModule, sString + "OUTPUT_RESREF_6");
    stRecipe.sOutputName6    = GetLocalString(oModule, sString + "OUTPUT_NAME_6");
    stRecipe.nOutputCount7   = GetLocalInt(oModule, sString + "OUTPUT_COUNT_7");
    stRecipe.sOutputResRef7  = GetLocalString(oModule, sString + "OUTPUT_RESREF_7");
    stRecipe.sOutputName7    = GetLocalString(oModule, sString + "OUTPUT_NAME_7");

    return stRecipe;
}
//----------------------------------------------------------------
struct gsCRRecipe gsCRGetRecipeByID(int nSkill, string sID)
{
    string sString = "GS_CR_RECIPE_" + IntToString(nSkill) + "_" + sID;
    int nSlot      = GetLocalInt(GetModule(), sString);

    return gsCRGetRecipeInSlot(nSkill, nSlot);
}
//----------------------------------------------------------------
int gsCRGetFirstRecipe(int nSkill, int nCategory, int nSlot = 0)
{
    return _gsCRGetFirstRecipe(nSkill, nCategory, nSlot);
}
//----------------------------------------------------------------
int _gsCRGetFirstRecipe(int nSkill, int nCategory, int nSlot, int nStep = 1)
{
    object oModule = GetModule();
    string sString = "GS_CR_RECIPE_" + IntToString(nSkill) + "_";
    string sSlot   = "";

    for (; nSlot >= 0 && nSlot < GS_CR_LIMIT_RECIPE; nSlot += nStep)
    {
        sSlot = IntToString(nSlot);

        if (GetLocalString(oModule, sString + sSlot + "_ID") != "" &&
            GetLocalInt(oModule, sString + sSlot + "_CATEGORY") == nCategory)
        {
            return nSlot;
        }
    }

    return -1;
}
//----------------------------------------------------------------
int gsCRGetNextRecipe(int nSkill, int nCategory, int nSlot = 0)
{
    return _gsCRGetFirstRecipe(nSkill, nCategory, nSlot + 1);
}
//----------------------------------------------------------------
int gsCRGetPreviousRecipe(int nSkill, int nCategory, int nSlot = 0)
{
    return _gsCRGetFirstRecipe(nSkill, nCategory, nSlot - 1, -1);
}
//----------------------------------------------------------------
void gsCRRemoveRecipeInSlot(int nSkill, int nSlot)
{
    object oModule   = GetModule();
    string sDatabase = "GS_CR_RECIPE_" + IntToString(nSkill);
    string sSlot     = IntToString(nSlot);
    string sString   = sDatabase + "_" + sSlot + "_";
    string sID       = GetLocalString(oModule, sString + "ID");
    int nCategory    = GetLocalInt(oModule, sString + "CATEGORY");

    DeleteLocalInt(oModule, sDatabase + "_" + sID);
    DeleteLocalString(oModule, sString + "ID");
    //SetCampaignInt(sDatabase, "SLOT_" + sSlot, FALSE);

    sqlquery sqlDeleteRecipe = SqlPrepareQueryCampaign(GS_CRAFTING_DATABASE, "DELETE FROM recipes WHERE id = @id;");
    SqlBindString(sqlDeleteRecipe, "@id", sID);
    SqlStep(sqlDeleteRecipe);

    gsCRDecreaseCategoryCount(nSkill, nCategory);
}
//----------------------------------------------------------------
void gsCRRemoveRecipeByID(int nSkill, string sID)
{
    string sString = "GS_CR_RECIPE_" + IntToString(nSkill) + "_" + sID;
    int nSlot      = GetLocalInt(GetModule(), sString);

    gsCRRemoveRecipeInSlot(nSkill, nSlot);
}
//----------------------------------------------------------------
int gsCRGetRecipeDC(struct gsCRRecipe stRecipe)
{
    int nDC =
        GS_CR_OFFSET_DC +
        gsCMGetItemLevelByValue(
            stRecipe.nValue * GS_CR_MODIFIER_DC);

    return nDC < 1 ? 1 : nDC;
}
//----------------------------------------------------------------
int gsCRGetRecipeCraftPoints(struct gsCRRecipe stRecipe)
{
    int nCraftPoints = stRecipe.nValue / GS_CR_MODIFIER_CRAFT_POINTS;

    return nCraftPoints < 1 ? 1 : nCraftPoints;
}
//----------------------------------------------------------------
string gsCRGetRecipeInputList(struct gsCRRecipe stRecipe)
{
    string sString = "";

    if (stRecipe.nInputCount1)
    {
        sString += IntToString(stRecipe.nInputCount1) + " " +
                   stRecipe.sInputName1;

        if (stRecipe.nInputCount2)
        {
            sString += "\n" + IntToString(stRecipe.nInputCount2) +" " +
                       stRecipe.sInputName2;

            if (stRecipe.nInputCount3)
            {
                sString += "\n" + IntToString(stRecipe.nInputCount3) + " " +
                           stRecipe.sInputName3;

                if (stRecipe.nInputCount4)
                {
                    sString += "\n" + IntToString(stRecipe.nInputCount4) + " " +
                               stRecipe.sInputName4;

                    if (stRecipe.nInputCount5)
                    {
                        sString += "\n" + IntToString(stRecipe.nInputCount5) + " " +
                                   stRecipe.sInputName5;

                        if (stRecipe.nInputCount6)
                        {
                            sString += "\n" + IntToString(stRecipe.nInputCount6) + " " +
                                    stRecipe.sInputName6;

                            if (stRecipe.nInputCount7)
                            {
                                sString += "\n" + IntToString(stRecipe.nInputCount7) + " " +
                                        stRecipe.sInputName7;
                            }
                        }
                    }
                }
            }
        }
    }

    return sString;
}
//----------------------------------------------------------------
string gsCRGetRecipeOutputList(struct gsCRRecipe stRecipe)
{
    string sString = "";

    if (stRecipe.nOutputCount1)
    {
        sString += IntToString(stRecipe.nOutputCount1) + " " +
                   stRecipe.sOutputName1;

        if (stRecipe.nOutputCount2)
        {
            sString += "\n" + IntToString(stRecipe.nOutputCount2) +" " +
                       stRecipe.sOutputName2;

            if (stRecipe.nOutputCount3)
            {
                sString += "\n" + IntToString(stRecipe.nOutputCount3) + " " +
                           stRecipe.sOutputName3;

                if (stRecipe.nOutputCount4)
                {
                    sString += "\n" + IntToString(stRecipe.nOutputCount4) + " " +
                               stRecipe.sOutputName4;

                    if (stRecipe.nOutputCount5)
                    {
                        sString += "\n" + IntToString(stRecipe.nOutputCount5) + " " +
                                   stRecipe.sOutputName5;

                        if (stRecipe.nOutputCount6)
                        {
                            sString += "\n" + IntToString(stRecipe.nOutputCount6) + " " +
                                    stRecipe.sOutputName6;

                            if (stRecipe.nOutputCount7)
                            {
                                sString += "\n" + IntToString(stRecipe.nOutputCount7) + " " +
                                        stRecipe.sOutputName7;
                            }
                        }
                    }
                }
            }
        }
    }

    return sString;
}
//----------------------------------------------------------------
void gsCRLoadRecipeList(int nSkill)
{
    int nStart = 1;
    int nEnd   = 0;

    for (; nStart <= GS_CR_LIMIT_RECIPE; nStart += 50)
    {
        nEnd += 50;
        ActionDoCommand(_gsCRLoadRecipeList(nSkill, nStart, nEnd));
    }
}
//----------------------------------------------------------------
void _gsCRLoadRecipeList(int nSkill, int nStart, int nEnd)
{
    object oModule = GetModule();
    int nCount     = GetLocalInt(oModule, "GS_CR_RECIPE_COUNT");

    for (; nStart <= nEnd; nStart++)
        nCount += __gsCRLoadRecipeList(nSkill, nStart);

    SetLocalInt(oModule, "GS_CR_RECIPE_COUNT", nCount);
}
//----------------------------------------------------------------
int __gsCRLoadRecipeList(int nSkill, int nSlot)
{
    string sSkill    = IntToString(nSkill);
    string sDatabase = "GS_CR_RECIPE_" + sSkill;
    string sSlot     = IntToString(nSlot);

    sqlquery sqlSelectRecipeBySlot = SqlPrepareQueryCampaign(GS_CRAFTING_DATABASE, "SELECT id, json FROM recipes WHERE skill = @skill AND slot = @slot;");
    SqlBindInt(sqlSelectRecipeBySlot, "@skill", nSkill);
    SqlBindInt(sqlSelectRecipeBySlot, "@slot", nSlot);

    if (!SqlStep(sqlSelectRecipeBySlot) /*!GetCampaignInt(sDatabase, "SLOT_" + sSlot)*/) return FALSE;


    object oModule   = GetModule();
    string sString   = sDatabase + "_" + sSlot + "_";
    string sID       = SqlGetString(sqlSelectRecipeBySlot, 0);//GetCampaignString(sDatabase, "ID_" + sSlot);
    json jRecipe     = SqlGetJson(sqlSelectRecipeBySlot, 1);
    string sNth      = "";
    int nCategory    = JsonGetInt(JsonObjectGet(jRecipe, "nCategory"));//GetCampaignInt(sDatabase, "CATEGORY_" + sSlot);
    int nNth         = 1;

    SetLocalInt(oModule, sDatabase + "_" + sID, nSlot);
    SetLocalString(oModule, sString + "ID", sID);
    SetLocalString(oModule, sString + "NAME", JsonGetString(JsonObjectGet(jRecipe, "sName")));
    SetLocalInt(oModule, sString + "CATEGORY", nCategory);
    SetLocalInt(oModule, sString + "VALUE", JsonGetInt(JsonObjectGet(jRecipe, "nValue")));

    for (; nNth <= 7; nNth++)
    {
        sNth = IntToString(nNth);

        SetLocalInt(
            oModule,
            sString + "INPUT_COUNT_" + sNth,
            JsonGetInt(
                JsonObjectGet(jRecipe, "nInputCount" + sNth)
            ));
        SetLocalString(
            oModule,
            sString + "INPUT_RESREF_" + sNth,
            JsonGetString(
                JsonObjectGet(jRecipe, "sInputResRef" + sNth)
            ));
        SetLocalString(
            oModule,
            sString + "INPUT_NAME_" + sNth,
            JsonGetString(
                JsonObjectGet(jRecipe, "sInputName" + sNth)
            ));
        SetLocalInt(
            oModule,
            sString + "OUTPUT_COUNT_" + sNth,
            JsonGetInt(
                JsonObjectGet(jRecipe, "nOutputCount" + sNth)
            ));
        SetLocalString(
            oModule,
            sString + "OUTPUT_RESREF_" + sNth,
            JsonGetString(
                JsonObjectGet(jRecipe, "sOutputResRef" + sNth)
            ));
        SetLocalString(
            oModule,
            sString + "OUTPUT_NAME_" + sNth,
            JsonGetString(
                JsonObjectGet(jRecipe, "sOutputName" + sNth)
            ));
    }

    gsCRIncreaseCategoryCount(nSkill, nCategory);
    return TRUE;
}
//----------------------------------------------------------------
int gsCRGetFirstCategory(int nSkill, int nCategory = 0)
{
    return _gsCRGetFirstCategory(nSkill, nCategory);
}
//----------------------------------------------------------------
int _gsCRGetFirstCategory(int nSkill, int nCategory, int nStep = 1)
{
    for (; nCategory >= 0 && nCategory < GS_CR_LIMIT_CATEGORY; nCategory += nStep)
    {
        if (gsCRGetCategoryCount(nSkill, nCategory)) return nCategory;
    }

    return -1;
}
//----------------------------------------------------------------
int gsCRGetNextCategory(int nSkill, int nCategory = 0)
{
    return _gsCRGetFirstCategory(nSkill, nCategory + 1);
}
//----------------------------------------------------------------
int gsCRGetPreviousCategory(int nSkill, int nCategory = 0)
{
    return _gsCRGetFirstCategory(nSkill, nCategory - 1, -1);
}
//----------------------------------------------------------------
void gsCRIncreaseCategoryCount(int nSkill, int nCategory)
{
    _gsCRIncreaseCategoryCount(nSkill, nCategory);
}
//----------------------------------------------------------------
void _gsCRIncreaseCategoryCount(int nSkill, int nCategory, int nValue = 1)
{
    object oModule = GetModule();
    string sString = "GS_CR_CATEGORY_" +
                     IntToString(nSkill) + "_" +
                     IntToString(nCategory) + "_" +
                     "COUNT";
    int nCount     = GetLocalInt(oModule, sString) + nValue;

    SetLocalInt(oModule, sString, nCount < 0 ? 0 : nCount);
}
//----------------------------------------------------------------
void gsCRDecreaseCategoryCount(int nSkill, int nCategory)
{
    _gsCRIncreaseCategoryCount(nSkill, nCategory, -1);
}
//----------------------------------------------------------------
int gsCRGetCategoryCount(int nSkill, int nCategory)
{
    string sString = "GS_CR_CATEGORY_" +
                     IntToString(nSkill) + "_" +
                     IntToString(nCategory) + "_" +
                     "COUNT";

    return GetLocalInt(GetModule(), sString);
}
//----------------------------------------------------------------
string gsCRGetCategoryName(int nCategory)
{
    string sString = "GS_CR_CATEGORY_" +
                     IntToString(nCategory) + "_" +
                     "NAME";

    return GetLocalString(GetModule(), sString);
}
//----------------------------------------------------------------
void gsCRLoadCategoryList()
{
    object oModule = GetModule();
    string sName   = "";
    string sString = "";
    int nNth       = 0;

    for (; nNth < GS_CR_LIMIT_CATEGORY; nNth++)
    {
        sName = Get2DAString("baseitems", "Name", nNth);

        if (sName != "" && sName != "0")
        {
            sName   = GetStringByStrRef(StringToInt(sName));
            sString = "GS_CR_CATEGORY_" + IntToString(nNth) + "_NAME";

            SetLocalString(oModule, sString, sName);
        }
    }
}
//----------------------------------------------------------------
struct gsCRQuantity gsCRGetQuantity(struct gsCRRecipe stRecipe, object oContainer = OBJECT_SELF)
{
    struct gsCRQuantity stQuantity;
    object oItem   = GetFirstItemInInventory(oContainer);
    string sResRef = "";
    int nCount     = 0;

    while (GetIsObjectValid(oItem))
    {
        if (GetIdentified(oItem))
        {
            sResRef = GetResRef(oItem);
            nCount  = GetItemStackSize(oItem);

            if (sResRef == stRecipe.sInputResRef1)
                stQuantity.nCount1 += nCount;
            else if (sResRef == stRecipe.sInputResRef2)
                stQuantity.nCount2 += nCount;
            else if (sResRef == stRecipe.sInputResRef3)
                stQuantity.nCount3 += nCount;
            else if (sResRef == stRecipe.sInputResRef4)
                stQuantity.nCount4 += nCount;
            else if (sResRef == stRecipe.sInputResRef5)
                stQuantity.nCount5 += nCount;
            else if (sResRef == stRecipe.sInputResRef6)
                stQuantity.nCount6 += nCount;
            else if (sResRef == stRecipe.sInputResRef7)
                stQuantity.nCount7 += nCount;
        }

        oItem   = GetNextItemInInventory(oContainer);
    }

    return stQuantity;
}
//----------------------------------------------------------------
int gsCRGetIsQuantitySufficient(struct gsCRRecipe stRecipe, struct gsCRQuantity stQuantity)
{
    return stQuantity.nCount1 >= stRecipe.nInputCount1 &&
           stQuantity.nCount2 >= stRecipe.nInputCount2 &&
           stQuantity.nCount3 >= stRecipe.nInputCount3 &&
           stQuantity.nCount4 >= stRecipe.nInputCount4 &&
           stQuantity.nCount5 >= stRecipe.nInputCount5 &&
           stQuantity.nCount6 >= stRecipe.nInputCount6 &&
           stQuantity.nCount7 >= stRecipe.nInputCount7;
}
//----------------------------------------------------------------
string gsCRGetQuantityList(struct gsCRRecipe stRecipe, struct gsCRQuantity stQuantity)
{
    string sString = "";

    if (stRecipe.nInputCount1)
    {
        sString += IntToString(stQuantity.nCount1) + " / " +
                   IntToString(stRecipe.nInputCount1) + " " +
                   stRecipe.sInputName1;

        if (stRecipe.nInputCount2)
        {
            sString += "\n" + IntToString(stQuantity.nCount2) + " / " +
                       IntToString(stRecipe.nInputCount2) + " " +
                       stRecipe.sInputName2;

            if (stRecipe.nInputCount3)
            {
                sString += "\n" + IntToString(stQuantity.nCount3) + " / " +
                           IntToString(stRecipe.nInputCount3) + " " +
                           stRecipe.sInputName3;

                if (stRecipe.nInputCount4)
                {
                    sString += "\n" + IntToString(stQuantity.nCount4) + " / " +
                               IntToString(stRecipe.nInputCount4) + " " +
                               stRecipe.sInputName4;

                    if (stRecipe.nInputCount5)
                    {
                        sString += "\n" + IntToString(stQuantity.nCount5) + " / " +
                                   IntToString(stRecipe.nInputCount5) + " " +
                                   stRecipe.sInputName5;

                        if (stRecipe.nInputCount6)
                        {
                            sString += "\n" + IntToString(stQuantity.nCount6) + " / " +
                                    IntToString(stRecipe.nInputCount6) + " " +
                                    stRecipe.sInputName6;

                            if (stRecipe.nInputCount7)
                            {
                                sString += "\n" + IntToString(stQuantity.nCount7) + " / " +
                                        IntToString(stRecipe.nInputCount7) + " " +
                                        stRecipe.sInputName7;
                            }
                        }
                    }
                }
            }
        }
    }

    return sString;
}
//----------------------------------------------------------------
void gsCRConsumeMaterial(struct gsCRRecipe stRecipe, object oContainer = OBJECT_SELF)
{
    object oItem   = GetFirstItemInInventory(oContainer);
    string sResRef = "";

    while (GetIsObjectValid(oItem))
    {
        if (GetIdentified(oItem))
        {
            sResRef = GetResRef(oItem);

            if (sResRef == stRecipe.sInputResRef1)
                stRecipe.nInputCount1 = _gsCRConsumeMaterial(oItem, stRecipe.nInputCount1);
            else if (sResRef == stRecipe.sInputResRef2)
                stRecipe.nInputCount2 = _gsCRConsumeMaterial(oItem, stRecipe.nInputCount2);
            else if (sResRef == stRecipe.sInputResRef3)
                stRecipe.nInputCount3 = _gsCRConsumeMaterial(oItem, stRecipe.nInputCount3);
            else if (sResRef == stRecipe.sInputResRef4)
                stRecipe.nInputCount4 = _gsCRConsumeMaterial(oItem, stRecipe.nInputCount4);
            else if (sResRef == stRecipe.sInputResRef5)
                stRecipe.nInputCount5 = _gsCRConsumeMaterial(oItem, stRecipe.nInputCount5);
            else if (sResRef == stRecipe.sInputResRef6)
                stRecipe.nInputCount6 = _gsCRConsumeMaterial(oItem, stRecipe.nInputCount6);
            else if (sResRef == stRecipe.sInputResRef7)
                stRecipe.nInputCount7 = _gsCRConsumeMaterial(oItem, stRecipe.nInputCount7);
        }

        oItem   = GetNextItemInInventory(oContainer);
    }
}
//----------------------------------------------------------------
int _gsCRConsumeMaterial(object oItem, int nCount)
{
    int nStackSize = GetItemStackSize(oItem);

    if (nCount > 0)
    {
        if (nStackSize > nCount)
        {
            SetItemStackSize(oItem, nStackSize - nCount);
            nCount  = 0;
        }
        else
        {
            DestroyObject(oItem);
            nCount -= nStackSize;
        }
    }

    return nCount;
}
//----------------------------------------------------------------
void gsCRCreateProduction(struct gsCRRecipe stRecipe, object oPC, object oContainer = OBJECT_SELF)
{
    struct gsCRQuantity stQuantity = gsCRGetQuantity(stRecipe, oContainer);

    //check material quantity
    if (! gsCRGetIsQuantitySufficient(stRecipe, stQuantity)) return;

    gsCRConsumeMaterial(stRecipe, oContainer);

    //check skill
    if (! gsCRGetIsSkillSuccessful(stRecipe.nSkill, gsCRGetRecipeDC(stRecipe), oPC))
    {
        FloatingTextStringOnCreature(GS_T_16777227, oPC, FALSE);
        return;
    }

    //create production item
    string sTemplate = gsCRGetProductionTemplate(stRecipe.nSkill);
    string sTag      = "GS_CR_" +
                       IntToString(stRecipe.nSkill) + "_" +
                       stRecipe.sID + "_" +
                       "0";
    object oItem     = CreateItemOnObject(sTemplate,
                                          oContainer,
                                          1,
                                          sTag);

    if (GetIsObjectValid(oItem))
    {
        SetName(oItem, stRecipe.sName + " (0%)");
    }

    FloatingTextStringOnCreature(GS_T_16777228, oPC, FALSE);
}
//----------------------------------------------------------------
struct gsCRProduction gsCRGetProductionData(object oItem)
{
    struct gsCRProduction stProduction;
    string sTag    = GetTag(oItem); //GS_CR_{skill}_{recipe_id}_{craft_points}

    if (GetStringLeft(sTag, 6) != "GS_CR_") return stProduction;

    string sString = "";
    string sChar   = "";
    int nCount     = GetStringLength(sTag);
    int nFlag      = 0;
    int nNth       = 6;

    for (; nNth < nCount; nNth++)
    {
        sChar = GetSubString(sTag, nNth, 1);

        if (sChar == "_")
        {
            switch (nFlag)
            {
            case 0:
                stProduction.nSkill  = StringToInt(sString);
                break;

            case 1:
                stProduction.sRecipe = sString;
                break;
            }

            sString  = "";
            nFlag   += 1;
        }
        else
        {
            sString += sChar;
        }
    }

    stProduction.nCraftPoints = StringToInt(sString);
    return stProduction;
}
//----------------------------------------------------------------
string gsCRGetProductionTemplate(int nSkill)
{
    switch (nSkill)
    {
    case GS_CR_SKILL_CARPENTER: return GS_CR_TEMPLATE_CARPENTER;
    case GS_CR_SKILL_COOK:      return GS_CR_TEMPLATE_COOK;
    case GS_CR_SKILL_CRAFT_ART: return GS_CR_TEMPLATE_CRAFT_ART;
    case GS_CR_SKILL_FORGE:     return GS_CR_TEMPLATE_FORGE;
    case GS_CR_SKILL_MELD:      return GS_CR_TEMPLATE_MELD;
    case GS_CR_SKILL_SEW:       return GS_CR_TEMPLATE_SEW;
    case GS_CR_SKILL_GADGET:    return GS_CR_TEMPLATE_GADGET;
    case GS_CR_SKILL_UNKNOWN:    return GS_CR_TEMPLATE_UNKNOWN;
    }

    return "";
}
//----------------------------------------------------------------
void gsCRProduce(object oItem, object oPC, int nValue = 1, object oContainer = OBJECT_SELF)
{
    struct gsCRProduction stProduction  = gsCRGetProductionData(oItem);
    struct gsCRRecipe stRecipe          = gsCRGetRecipeByID(stProduction.nSkill,
                                                            stProduction.sRecipe);

    if (stRecipe.sID == "")                  return;

    int nRecipeDC                       = gsCRGetRecipeDC(stRecipe);
    int nRecipeCraftPoints              = gsCRGetRecipeCraftPoints(stRecipe);
    int nCraftPoints                    = gsCRGetCraftPoints(oPC);
    int nFlag                           = FALSE;
    int nNth                            = 0;

    if (nValue < 1 || nValue > nCraftPoints) nValue = nCraftPoints;

    for (; nNth < nValue; nNth++)
    {
        //check skill
        if (gsCRGetIsSkillSuccessful(stRecipe.nSkill, nRecipeDC, oPC))
        {
            stProduction.nCraftPoints += 1;

            //finish production
            if (stProduction.nCraftPoints >= nRecipeCraftPoints)
            {
                gsCRDecreaseCraftPoints(nNth + 1, oPC);

                _gsCRProduce(stRecipe.nOutputCount1, stRecipe.sOutputResRef1, oContainer, oPC);
                _gsCRProduce(stRecipe.nOutputCount2, stRecipe.sOutputResRef2, oContainer, oPC);
                _gsCRProduce(stRecipe.nOutputCount3, stRecipe.sOutputResRef3, oContainer, oPC);
                _gsCRProduce(stRecipe.nOutputCount4, stRecipe.sOutputResRef4, oContainer, oPC);
                _gsCRProduce(stRecipe.nOutputCount5, stRecipe.sOutputResRef5, oContainer, oPC);
                _gsCRProduce(stRecipe.nOutputCount6, stRecipe.sOutputResRef6, oContainer, oPC);
                _gsCRProduce(stRecipe.nOutputCount7, stRecipe.sOutputResRef7, oContainer, oPC);

                DestroyObject(oItem);

                FloatingTextStringOnCreature(GS_T_16777230, oPC, FALSE);
                return;
            }

            nFlag                      = TRUE; //progress
        }
    }

    gsCRDecreaseCraftPoints(nNth, oPC);

    if (nFlag)
    {
        //create proceeded production
        string sTemplate = gsCRGetProductionTemplate(stRecipe.nSkill);
        string sTag      = "GS_CR_" +
                           IntToString(stRecipe.nSkill) + "_" +
                           stRecipe.sID + "_" +
                           IntToString(stProduction.nCraftPoints);
        object oNew      = CreateItemOnObject(sTemplate,
                                              oContainer,
                                              1,
                                              sTag);

        if (GetIsObjectValid(oNew))
        {
            string sPercent = IntToString(100 * stProduction.nCraftPoints / nRecipeCraftPoints);

            SetName(oNew, stRecipe.sName + " (" + sPercent + "%)");
            DestroyObject(oItem);
        }

        FloatingTextStringOnCreature(GS_T_16777231, oPC, FALSE);
    }
    else
    {
        //no progress
        FloatingTextStringOnCreature(GS_T_16777229, oPC, FALSE);
    }
}
//----------------------------------------------------------------
void _gsCRProduce(int nCount, string sResRef, object oContainer, object oPC = OBJECT_INVALID)
{
    object oItem       = OBJECT_INVALID;
    location lLocation = GetLocation(oContainer);
    int nNth           = 0;

    if (GetIsObjectValid(oPC))
    {
        string sName = GetName(oPC);

        for (; nNth < nCount; nNth++)
        {
            oItem = CreateItemOnObject(sResRef, oContainer);
            SetName(oItem, GetName(oItem, TRUE) + " [" + sName + "]");
            SetIdentified(oItem, TRUE);
        }
    }
    else
    {
        for (; nNth < nCount; nNth++)
        {
            oItem = CreateItemOnObject(sResRef, oContainer);
            SetIdentified(oItem, TRUE);
        }
    }
}
//----------------------------------------------------------------
void gsCRPlaySound(int nSkill)
{
    switch (nSkill)
    {
    case GS_CR_SKILL_CARPENTER:
        PlaySound("as_cv_sawing1");
        break;

    case GS_CR_SKILL_COOK:
        PlaySound("as_cv_shopjugs1");
        break;

    case GS_CR_SKILL_CRAFT_ART:
        PlaySound("as_cv_chiseling2");
        break;

    case GS_CR_SKILL_FORGE:
        PlaySound("as_cv_smithhamr1");
        break;

    case GS_CR_SKILL_MELD:
        PlaySound("al_mg_beaker1");
        break;

    case GS_CR_SKILL_SEW:
        PlaySound("as_na_leafmove1");
        break;

    case GS_CR_SKILL_GADGET:
        PlaySound("as_cv_winch1");
        break;

    case GS_CR_SKILL_UNKNOWN:
        PlaySound("as_na_leafmove1");
        break;
    }
}
