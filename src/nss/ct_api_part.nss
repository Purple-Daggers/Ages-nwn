/*
================================================================================
CARCERIAN'S TAILOR SYSTEM - ARMOR PARTS (ct_api_part.nss) - v1.0.0
================================================================================
Armor part model cycling (NEXT/BACK) and bilateral mirroring.
Included by ct_api_sess.nss. Do not include directly in entry points.

All item replacements go through CT_ReplaceItem (ct_api.nss), which uses the
NPC's action queue to serialize unequip/destroy/equip with no DelayCommand.
================================================================================
*/

#include "ct_api"

// ============================================================================
// PROTOTYPES
// ============================================================================

void CT_CustomizeArmorPart(object oSession, int nPart, int nDir);
void CT_StripArmorPart(object oSession, int nPart);
void CT_MirrorArmorPart(object oSession, int nSrcPart);
void CT_MirrorAllParts(object oSession, int nFromEven);

// ============================================================================
// IMPLEMENTATIONS
// ============================================================================

// Cycles one armor part model on the armor equipped on oSession.
// - oSession: The session NPC target.
// - nPart:    Armor part index (0-18). See CT_GetPart2DA for the index map.
// - nDir:     CT_NEXT (1) or CT_BACK (-1). Wraps within the valid 2DA range.
// * TORSO (nPart=1) is AC-locked: only advances to models sharing the same
//   AC value in parts_chest.2da. Empty ACBONUS column bypasses the lock.
// * Skips 2DA rows whose LABEL is "" or "****" (blank/unused model slots).
// * No-ops if no armor is equipped on oSession.
void CT_CustomizeArmorPart(object oSession, int nPart, int nDir) {
    object oArmor = CT_GetItem(oSession, CT_ITEM_ARMOR);
    if (!GetIsObjectValid(oArmor)) return;

    object oPC = GetPCSpeaker();
    object oNew = OBJECT_INVALID;  // Declare at function scope

    int nCurrent = GetItemAppearance(oArmor, ITEM_APPR_TYPE_ARMOR_MODEL, nPart);

    // For armor parts: use fixed min/max range
    // Cache frequently accessed AC values for performance
    int nMin = 1;
    int nMax = 255;

    // Handle starting from 0 by moving to min
    if (nCurrent < nMin || nCurrent > nMax) {
        nCurrent = nMin;
    }

    int iLastChatInt = GetLocalInt(oPC,"LAST_CHAT_INT");
    if (iLastChatInt > 0) {
        // Validate chat input is within reasonable bounds
        if (iLastChatInt > nMax) iLastChatInt = nMax;
        if (iLastChatInt < nMin) iLastChatInt = nMin;
        nCurrent = iLastChatInt;
        SetLocalInt(oPC,"LAST_CHAT_INT",0);
    }

    if (nPart == ITEM_APPR_ARMOR_MODEL_TORSO) {
        // AC-locked: only cycle to models with same AC value (torso constraint)
        string sBaseAC = Get2DAString("parts_chest", "ACBONUS", nCurrent);

        // Always enforce AC locking - if current AC is empty, find first non-empty AC
        if (sBaseAC == "") {
            // Find first model with a valid AC value to establish base AC
            int i;
            for (i = nMin; i <= nMax; i++) {
                string sTestAC = Get2DAString("parts_chest", "ACBONUS", i);
                if (sTestAC != "") {
                    sBaseAC = sTestAC;
                    nCurrent = i;
                    break;
                }
            }
            if (sBaseAC == "") {
                SendMessageToPC(GetPCSpeaker(), CT_Error("TORSO: No valid AC models found."));
                return;
            }
        }

        // AC-locked: only cycle to models with matching AC
        int nNext   = nCurrent;
        int bFound  = FALSE;
        int nSafety = 0;
        while (!bFound && nSafety++ < nMax) {
            nNext += nDir;
            if (nNext > nMax) nNext = nMin;
            if (nNext < nMin) nNext = nMax;
            if (Get2DAString("parts_chest", "ACBONUS", nNext) == sBaseAC) {
                bFound = TRUE;
            }
        }
        if (!bFound) {
            SendMessageToPC(GetPCSpeaker(), CT_Warning("TORSO: no other model at AC " + sBaseAC + "."));
            return;
        }
        nCurrent = nNext;

        // Create copy for AC-locked torso path with validation
        oNew = CopyItemAndModify(oArmor, ITEM_APPR_TYPE_ARMOR_MODEL, nPart, nCurrent, TRUE);
        if (GetIsObjectValid(oNew)) {
            int nVerify = GetItemAppearance(oNew, ITEM_APPR_TYPE_ARMOR_MODEL, nPart);
            if (nVerify != nCurrent) {
                DestroyObject(oNew);
                oNew = OBJECT_INVALID;
            }
        }

        // If validation failed, exit function
        if (!GetIsObjectValid(oNew)) {
            SendMessageToPC(GetPCSpeaker(), CT_Error("TORSO: Failed to create valid model at AC " + sBaseAC + "."));
            return;
        }
    } else
    {
        // Non-torso parts: simple numeric cycling with do/while validation.
        // oNew is kept from the loop - do NOT call CopyItemAndModify again below.
        oNew = OBJECT_INVALID;
        do {
            nCurrent += nDir;
            if (nCurrent > nMax) nCurrent = nMin;
            if (nCurrent < nMin) nCurrent = nMax;
            oNew = CopyItemAndModify(oArmor, ITEM_APPR_TYPE_ARMOR_MODEL, nPart, nCurrent, TRUE);
            // Verify the model was actually set (not a placeholder/error model)
            if (GetIsObjectValid(oNew))
            {
                int nVerify = GetItemAppearance(oNew, ITEM_APPR_TYPE_ARMOR_MODEL, nPart);
                if (nVerify != nCurrent)
                {
                    DestroyObject(oNew);
                    oNew = OBJECT_INVALID;
                }
            }
        } while (!GetIsObjectValid(oNew));
    }

    CT_ReplaceItem(oSession, oArmor, oNew, INVENTORY_SLOT_CHEST);

    // Warn if this part is hidden by the currently equipped robe model.
    int bHiddenByRobe = CT_APPR_IsHiddenByRobe(nPart, oNew);
    if (bHiddenByRobe)
        SendMessageToPC(GetPCSpeaker(), CT_Warning("Note: " + CT_GetPartName(nPart) + " is hidden by the equipped robe."));

    // Get AC value for feedback (torso specific)
    string sAC = "";
    if (nPart == ITEM_APPR_ARMOR_MODEL_TORSO)
    {
        sAC = Get2DAString("parts_chest", "ACBONUS", nCurrent);
        if (sAC == "")
            sAC = "0";
    }

    // Set custom token for display with colors
    string sPartName = CT_Color(CT_LABEL,CT_GetPartName(nPart));
    if (nPart == ITEM_APPR_ARMOR_MODEL_TORSO)
    {
        sPartName += CT_Value(" [AC:" + sAC + "]");  // White
    }

    string sToken = sPartName + CT_Value(": " + IntToString(nCurrent) + "/" + IntToString(nMax));
    SetCustomToken(CT_TOKEN_PARTNUMBER, sToken);
    CT_NotifyCycledItem(GetPCSpeaker(), sPartName, "Model", nCurrent, nMax);
}

// Sets an armor part model to 1 (first/default model row).
// - oSession: The session NPC target.
// - nPart:    Armor part index (0-18). Not valid for CT_PART_TORSO (7) -
//             torso is skipped to prevent AC exploit.
// * No-ops if no armor is equipped or if nPart is the torso (7).
void CT_StripArmorPart(object oSession, int nPart)
{
    if (nPart == ITEM_APPR_ARMOR_MODEL_TORSO)
    {
        SendMessageToPC(GetPCSpeaker(), CT_Warning("Torso cannot be reset.")); // Red
        return;
    }
    object oArmor = CT_GetItem(oSession, CT_ITEM_ARMOR);
    if (!GetIsObjectValid(oArmor)) return;
    object oNew = CopyItemAndModify(oArmor, ITEM_APPR_TYPE_ARMOR_MODEL, nPart, 1, TRUE);
    CT_ReplaceItem(oSession, oArmor, oNew, INVENTORY_SLOT_CHEST);
    string s2DA = CT_GetPart2DA(nPart);
    string sMSG =  CT_Action("PART RESET: " + s2DA + " [" + IntToString(nPart) + "] -> 1");
    SendMessageToPC(GetPCSpeaker(), sMSG);

}

// Copies a paired armor part model from nSrcPart to its opposite counterpart.
// - oSession:  The session NPC target.
// - nSrcPart:  Source part index. Paired ranges are 0-5 and 10-17:
//                0/1   = R/L foot       (even=R)
//                2/3   = R/L shin       (even=R)
//                4/5   = L/R thigh      (even=L - engine quirk)
//                10/11 = R/L forearm    (even=R)
//                12/13 = R/L bicep      (even=R)
//                14/15 = R/L shoulder   (even=R)
//                16/17 = R/L hand       (even=R)
//              Pelvis (6), torso (7), belt (8), neck (9), robe (18) are
//              single parts and cannot be mirrored.
// * No-ops if nSrcPart is not in a paired range.
void CT_MirrorArmorPart(object oSession, int nSrcPart) {
    object oArmor = CT_GetItem(oSession, CT_ITEM_ARMOR);
    if (!GetIsObjectValid(oArmor)) return;

    // Paired range check.
    int bPaired = (nSrcPart >= 0 && nSrcPart <= 5) ||
                  (nSrcPart >= 10 && nSrcPart <= 17);
    if (!bPaired) return;

    int nDstPart  = (nSrcPart % 2 == 0) ? nSrcPart + 1 : nSrcPart - 1;
    int nValue    = GetItemAppearance(oArmor, ITEM_APPR_TYPE_ARMOR_MODEL, nSrcPart);
    string s2DA   = CT_GetPart2DA(nSrcPart);

    // Side label depends on parity AND whether this is the thigh pair (4/5),
    // which has the L/R order reversed from the other paired parts.
    int bThigh   = (nSrcPart == 4 || nSrcPart == 5);
    int bSrcEven = (nSrcPart % 2 == 0);
    string sSrc  = bThigh ? (bSrcEven ? "L" : "R") : (bSrcEven ? "R" : "L");
    string sDst  = bThigh ? (bSrcEven ? "R" : "L") : (bSrcEven ? "L" : "R");
    string sLabel = Get2DAString(s2DA, "LABEL", nValue);

    object oNew = CopyItemAndModify(oArmor,
        ITEM_APPR_TYPE_ARMOR_MODEL, nDstPart, nValue, TRUE);
    CT_ReplaceItem(oSession, oArmor, oNew, INVENTORY_SLOT_CHEST);
    SendMessageToPC(GetPCSpeaker(), CT_Action("MIRROR: " + sSrc + " -> " + sDst + " (" + sLabel + ")")); // Green
}

// Copies all paired part models from one side to the other in one pass.
// - oSession:  The session NPC target.
// - nFromEven: TRUE copies even -> odd. FALSE copies odd -> even.
// * Paired part indices are 0-5 (foot/shin/thigh) and 10-17 (forearm,
//   bicep, shoulder, hand). Single parts (pelvis 6, torso 7, belt 8,
//   neck 9, robe 18) are skipped.
// * For most pairs even=R, odd=L. For the thigh pair (4/5) the order is
//   reversed: 4=L, 5=R. nFromEven applies uniformly to numeric parity.
// * Chains all CopyItemAndModify calls, destroying intermediates immediately.
//   One CT_ReplaceItem at the end covers all part changes.
void CT_MirrorAllParts(object oSession, int nFromEven) {
    object oArmor = CT_GetItem(oSession, CT_ITEM_ARMOR);
    if (!GetIsObjectValid(oArmor)) return;
    object oPC = GetPCSpeaker();
    int nOffset  = nFromEven ? 1 : -1;
    object oOrig = oArmor;
    int i;

    // Iterate paired range 0-5 (foot, shin, thigh).
    for (i = 0; i <= 5; i++) {
        if ((i % 2 == 0) != nFromEven) continue;
        int nValue = GetItemAppearance(oArmor,
            ITEM_APPR_TYPE_ARMOR_MODEL, i);
        object oPrev = oArmor;
        oArmor = CopyItemAndModify(oArmor,
            ITEM_APPR_TYPE_ARMOR_MODEL, i + nOffset, nValue, TRUE);
        if (oPrev != oOrig) DestroyObject(oPrev);
    }

    // Iterate paired range 10-17 (forearm, bicep, shoulder, hand).
    for (i = 10; i <= 17; i++) {
        if ((i % 2 == 0) != nFromEven) continue;
        int nValue = GetItemAppearance(oArmor,
            ITEM_APPR_TYPE_ARMOR_MODEL, i);
        object oPrev = oArmor;
        oArmor = CopyItemAndModify(oArmor,
            ITEM_APPR_TYPE_ARMOR_MODEL, i + nOffset, nValue, TRUE);
        if (oPrev != oOrig) DestroyObject(oPrev);
    }

    string sDir = nFromEven ? "R -> L" : "L -> R";
    CT_ReplaceItem(oSession, oOrig, oArmor, INVENTORY_SLOT_CHEST);
    SendMessageToPC(oPC, CT_Action("ALL PARTS MIRRORED " + sDir));
}


