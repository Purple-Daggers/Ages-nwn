#include "mk_inc_debug"
#include "mk_inc_2DA_disp"

void main()
{
    object oPC = OBJECT_SELF;
    int nRow = GetLocalInt(OBJECT_SELF, MK_2DA_DISP_CALLBACK_ROW);

    int bIgnoreRacialType = GetLocalInt(oPC, "MK_DEITY_IGNORE_RACIALTYPE");
    int bIgnoreAlignment = GetLocalInt(oPC, "MK_DEITY_IGNORE_ALIGNMENT");
    int bIgnoreClasses = GetLocalInt(oPC, "MK_DEITY_IGNORE_CLASSES");
    int bIgnoreGender = GetLocalInt(oPC, "MK_DEITY_IGNORE_GENDER");

    string s2DA = GetLocalString(oPC, "MK_DEITY_2DAFILE");
    if (s2DA == "") s2DA = "mk_deities";

    int bCheckRacialType = TRUE;
    if (!bIgnoreRacialType)
    {
        bCheckRacialType = MK_Get2DAInt(s2DA, "AllRaces", nRow, 0)
            || MK_Get2DAInt("mk_deities", GetLocalString(oPC, "MK_BODY_DEITY_RACIAL_COLUMN"), nRow, 0);
    }

    int nAlignmentGenderAdjustment = ( GetLocalInt(oPC, "MK_BODY_DEITY_ALIGNMENTGENDER_ADJUST") ? 1 : 0 );

    int bCheckAlignment = TRUE;
    if (!bIgnoreAlignment)
    {
         int nAlignment = MK_Get2DAInt(s2DA, GetLocalString(oPC, "MK_BODY_DEITY_ALIGNMENT_COLUMN"), nRow, 0);
         if ((nAlignment>0) && (!bIgnoreClasses))
         {
            nAlignment-=nAlignmentGenderAdjustment;
         }
         bCheckAlignment = nAlignment;
    }

    int bCheckGender = TRUE;
    if (!bIgnoreGender)
    {
         int nAlignment = MK_Get2DAInt(s2DA, GetLocalString(oPC, "MK_BODY_DEITY_GENDER_COLUMN"), nRow, 0);
         if ((nAlignment>0) && (!bIgnoreClasses))
         {
            nAlignment-=nAlignmentGenderAdjustment;
         }
         bCheckGender = nAlignment;
    }

    int bCheckClasses = TRUE;
    if (!bIgnoreClasses)
    {
        int iClass;
        for (iClass = 1; iClass<=3; iClass++)
        {
            string sColumn = GetLocalString(oPC, "MK_BODY_DEITY_CLASS"+IntToString(iClass)+"_COLUMN");
            if (sColumn!="")
            {
                bCheckClasses = bCheckClasses && MK_Get2DAInt(s2DA, sColumn, nRow);
            }
        }
    }

    MK_DEBUG_TRACE("mk_cb_deity_chk: "+Get2DAString("mk_deities", "LABEL", nRow)+"["+IntToString(nRow)+"]: "+IntToString(bCheckRacialType)+", "+IntToString(bCheckAlignment)+", "+IntToString(bCheckGender)+", "+IntToString(bCheckClasses));
    int bCheck = bCheckRacialType && bCheckAlignment && bCheckGender && bCheckClasses;

    SetLocalInt(OBJECT_SELF, MK_2DA_DISP_CALLBACK_CHECK, bCheck);
}
