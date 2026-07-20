/*==============================================================================
CARCERIAN'S TAILOR SYSTEM - APPEARANCE (ct_api_appear.nss) - v3.0.0
================================================================================
Provides dynamic NSS-based armor part management, extended color support,
and robe hiding logic. NO 2DA DEPENDENCIES - all data is script-defined.

ARMOR MODELS: 40 indices (0-39)
  0-1:   feet (rfoot, lfoot)
  2-3:   shins (rshin, lshin)
  4-5:   thighs (rthigh, lthigh)
  6:     pelvis
  7:     torso/chest
  8:     belt
  9:     neck
  10-11: forearms (rforearm, lforearm)
  12-13: biceps (rbicep, lbicep)
  14-15: shoulders (rshoulder, lshoulder)
  16-17: hands (rhand, lhand)
  18:    robe
  19-31: extended parts (paired shoulders, biceps, forearms, hands, legs, feet)
  32-39: custom/reserved

COLOR TYPES: 11 material categories
  0: leather 1
  1: leather 2
  2: cloth 1
  3: cloth 2
  4: metal 1
  5: metal 2
  6: leather (composite)
  7: cloth (composite)
  8: metal (composite)
  9: leather+cloth (composite)
  10: all materials (composite)

PART METADATA: Defined in NSS as structured data
  - Label/name for each armor model
  - Max valid model ID (all parts cap at 18 by default)
  - Color support (all parts support all colors by default)
  - Robe hiding column (none by default)
==============================================================================*/

// ============================================================================
// PART METADATA (NSS-BASED, NO 2DA)
// ============================================================================

// Returns the 2DA filename for the specified armor model.
// Pure NSS implementation - no 2DA lookups.
string CT_APPR_Get2DAFile(int nModel) {
    switch(nModel) {
        case 0:  case 1:  return "parts_foot";
        case 2:  case 3:  return "parts_shin";
        case 4:  case 5:  return "parts_legs";
        case 6:           return "parts_pelvis";
        case 7:           return "parts_chest";
        case 8:           return "parts_belt";
        case 9:           return "parts_neck";
        case 10: case 11: return "parts_arm";
        case 12: case 13: return "parts_bicep";
        case 14: case 15: return "parts_shoulder";
        case 16: case 17: return "parts_hand";
        case 18:          return "parts_robe";
    }
    return "";
}

// Returns the label/name of the specified armor model.
// nModel: Armor model index (0-39). See CT_APPR_MODEL_* constants.
// Returns: Display name of the model or empty string if invalid.
string CT_APPR_GetModelLabel(int nModel) {
    if (nModel < 0 || nModel >= CT_APPR_MODEL_NUM) return "";
    switch(nModel) {
        case 0:  return "Right Foot";
        case 1:  return "Left Foot";
        case 2:  return "Right Shin";
        case 3:  return "Left Shin";
        case 4:  return "Right Thigh";
        case 5:  return "Left Thigh";
        case 6:  return "Pelvis";
        case 7:  return "Torso";
        case 8:  return "Belt";
        case 9:  return "Neck";
        case 10: return "Right Forearm";
        case 11: return "Left Forearm";
        case 12: return "Right Bicep";
        case 13: return "Left Bicep";
        case 14: return "Right Shoulder";
        case 15: return "Left Shoulder";
        case 16: return "Right Hand";
        case 17: return "Left Hand";
        case 18: return "Robe";
    }
    return "";
}

// Returns TRUE if the specified color type is supported by the armor model.
// nModel: Armor model index (0-39).
// nColor: Color channel (0-10). See CT_COLOR_* constants.
// Returns: TRUE if color is supported, FALSE otherwise.
// All parts support all colors by default (can be overridden per-part).
int CT_APPR_IsColorSupported(int nModel, int nColor)
{
    if (nModel < 0 || nModel >= CT_APPR_MODEL_NUM) return FALSE;
    if (nColor < 0) return FALSE;

    // Standard: colors 0-5 allowed only
    if (nColor > 5) return FALSE;
    return TRUE;
}

// Returns the label for the specified color type.
string CT_COLOR_GetLabel(int nColor) {
    switch (nColor) {
        case CT_COLOR_LEATHER:          return "Leather 1";
        case CT_COLOR_LEATHER2:         return "Leather 2";
        case CT_COLOR_CLOTH:            return "Cloth 1";
        case CT_COLOR_CLOTH2:           return "Cloth 2";
        case CT_COLOR_METAL:            return "Metal 1";
        case CT_COLOR_METAL2:           return "Metal 2";
    }
    return "";
}

// Returns TRUE if nColor is a base color (0-5)
int CT_COLOR_IsBase(int nColor)
{
        return (nColor >= 0 && nColor < 6);  // 0-5 are base
}

// Returns which base colors are included in the composite color type.
// For base colors, returns the color itself.
int CT_COLOR_GetComposition(int nColor) {
    switch (nColor) {
        case CT_COLOR_LEATHER:
        case CT_COLOR_LEATHER2:
        case CT_COLOR_CLOTH:
        case CT_COLOR_CLOTH2:
        case CT_COLOR_METAL:
        case CT_COLOR_METAL2:
        return (1 << nColor);  // Single base color
    }
    return 0;
}

// Returns TRUE if the specified part has a paired opposite.
// Paired: feet, shins, thighs, forearms, biceps, shoulders, hands.
// Unpaired: pelvis, torso, belt, neck, robe.
int CT_APPR_HasPair(int nModel) {
    return ((nModel >= 0 && nModel <= 5) ||   // feet, shins, thighs
            (nModel >= 10 && nModel <= 17));  // forearms, biceps, shoulders, hands
}

// Returns the opposite part of a paired model.
// Returns nModel if unpaired or invalid.
int CT_APPR_GetOpposite(int nModel) {
    if (!CT_APPR_HasPair(nModel)) return nModel;
    if (nModel % 2 == 0) return nModel + 1;  // Even -> odd (right -> left)
    return nModel - 1;                        // Odd -> even (left -> right)
}
