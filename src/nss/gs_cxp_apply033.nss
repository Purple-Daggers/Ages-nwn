void main()
{
    object oTarget = GetLocalObject(OBJECT_SELF, "GS_TARGET");

    if (GetIsObjectValid(oTarget))
    {
        object oCorpse = GetLocalObject(oTarget, "GS_CORPSE");

        if (GetIsObjectValid(oCorpse))
        {
            object oPossessor = OBJECT_INVALID;

            switch (GetObjectType(oCorpse))
            {
            case OBJECT_TYPE_ITEM:
                oPossessor = GetItemPossessor(oCorpse);
                if (GetIsObjectValid(oPossessor)) oCorpse = oPossessor;
                break;

            case OBJECT_TYPE_PLACEABLE:
                break;

            default:
                return;
            }

            JumpToObject(oCorpse);
        }
    }
}
