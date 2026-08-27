#include "gs_inc_craft"

void gsCleanContainer(object oContainer)
{
    object oItem = GetFirstItemInInventory(oContainer);

    while (GetIsObjectValid(oItem))
    {
        DestroyObject(oItem);
        oItem = GetNextItemInInventory(oContainer);
    }
}
//----------------------------------------------------------------
void gsUpdateRecipe(int nSkill = GS_CR_SKILL_CARPENTER, int nSlot = 0)
{
    if (++nSlot > GS_CR_LIMIT_RECIPE)
    {
        switch (nSkill)
        {
        case GS_CR_SKILL_CARPENTER:
            nSkill = GS_CR_SKILL_COOK;
            break;

        case GS_CR_SKILL_COOK:
            nSkill = GS_CR_SKILL_CRAFT_ART;
            break;

        case GS_CR_SKILL_CRAFT_ART:
            nSkill = GS_CR_SKILL_FORGE;
            break;

        case GS_CR_SKILL_FORGE:
            nSkill = GS_CR_SKILL_MELD;
            break;

        case GS_CR_SKILL_MELD:
            nSkill = GS_CR_SKILL_SEW;
            break;

        case GS_CR_SKILL_SEW:
            nSkill = GS_CR_SKILL_GADGET;
            break;

        case GS_CR_SKILL_GADGET:
            SendMessageToAllDMs("CRAFT DATABASE: RECONSTRUCTION COMPLETED");
            return;
        }

        nSlot = 1;
    }

    struct gsCRRecipe stRecipe;

    for (; nSlot <= GS_CR_LIMIT_RECIPE; nSlot++)
    {
        stRecipe = gsCRGetRecipeInSlot(nSkill, nSlot);

        if (stRecipe.sID != "")
        {
            object oInput  = GetObjectByTag("GS_CR_INPUT");
            object oOutput = GetObjectByTag("GS_CR_OUTPUT");

            SendMessageToAllDMs("CRAFT DATABASE: PROCESSING RECIPE '" + stRecipe.sName + "' ...");

            _gsCRProduce(stRecipe.nInputCount1, stRecipe.sInputResRef1, oInput);
            _gsCRProduce(stRecipe.nInputCount2, stRecipe.sInputResRef2, oInput);
            _gsCRProduce(stRecipe.nInputCount3, stRecipe.sInputResRef3, oInput);
            _gsCRProduce(stRecipe.nInputCount4, stRecipe.sInputResRef4, oInput);
            _gsCRProduce(stRecipe.nInputCount5, stRecipe.sInputResRef5, oInput);
            _gsCRProduce(stRecipe.nInputCount6, stRecipe.sInputResRef6, oInput);
            _gsCRProduce(stRecipe.nInputCount7, stRecipe.sInputResRef7, oInput);

            _gsCRProduce(stRecipe.nOutputCount1, stRecipe.sOutputResRef1, oOutput);
            _gsCRProduce(stRecipe.nOutputCount2, stRecipe.sOutputResRef2, oOutput);
            _gsCRProduce(stRecipe.nOutputCount3, stRecipe.sOutputResRef3, oOutput);
            _gsCRProduce(stRecipe.nOutputCount4, stRecipe.sOutputResRef4, oOutput);
            _gsCRProduce(stRecipe.nOutputCount5, stRecipe.sOutputResRef5, oOutput);
            _gsCRProduce(stRecipe.nOutputCount6, stRecipe.sOutputResRef6, oOutput);
            _gsCRProduce(stRecipe.nOutputCount7, stRecipe.sOutputResRef7, oOutput);

            gsCRRemoveRecipeInSlot(nSkill, nSlot);
            gsCRAddRecipe(oInput, oOutput, nSkill, stRecipe.sID);

            gsCleanContainer(oInput);
            gsCleanContainer(oOutput);
            break;
        }
    }

    DelayCommand(0.5, gsUpdateRecipe(nSkill, nSlot));
}
//----------------------------------------------------------------
void main()
{
    object oInput  = GetObjectByTag("GS_CR_INPUT");
    if (! GetIsObjectValid(oInput))  return;
    object oOutput = GetObjectByTag("GS_CR_OUTPUT");
    if (! GetIsObjectValid(oOutput)) return;

    SendMessageToAllDMs("CRAFT DATABASE: RECONSTRUCTION INITIALIZED");
    gsCleanContainer(oInput);
    gsCleanContainer(oOutput);
    DelayCommand(0.5, gsUpdateRecipe());
}
