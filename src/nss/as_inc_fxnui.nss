#include "nw_inc_nui"
#include "nw_inc_nui_insp"
#include "as_inc_target"
#include "gs_inc_fixture"

const string NUI_MOVE_FIXTURE_WINDOW = "nui_fx_move_fixture_window";

void asFXMoveObjectNUI(object oPlayer)
{

	int nPreviousToken = NuiFindWindow(oPlayer, NUI_MOVE_FIXTURE_WINDOW);
	if (nPreviousToken != 0)
	{
		NuiDestroy(oPlayer, nPreviousToken);
	}

	json jRoot = JsonArray();
	json jRow = JsonArray();

    json jPosXButton = NuiButton(JsonString("+X"));
    jPosXButton = NuiId(jPosXButton, "nui_fx_pos_x");
    jPosXButton = NuiWidth(jPosXButton, 32.0f);
    jPosXButton = NuiHeight(jPosXButton, 32.0f);
    json jPosYButton = NuiButton(JsonString("+Y"));
    jPosYButton = NuiId(jPosYButton, "nui_fx_pos_y");
    jPosYButton = NuiWidth(jPosYButton, 32.0f);
    jPosYButton = NuiHeight(jPosYButton, 32.0f);
    json jPosZButton = NuiButton(JsonString("+Z"));
    jPosZButton = NuiId(jPosZButton, "nui_fx_pos_z");
    jPosZButton = NuiWidth(jPosZButton, 32.0f);
    jPosZButton = NuiHeight(jPosZButton, 32.0f);
    json jPosRButton = NuiButton(JsonString("+R"));
    jPosRButton = NuiId(jPosRButton, "nui_fx_pos_r");
    jPosRButton = NuiWidth(jPosRButton, 32.0f);
    jPosRButton = NuiHeight(jPosRButton, 32.0f);

    json jNegXButton = NuiButton(JsonString("-X"));
    jNegXButton = NuiId(jNegXButton, "nui_fx_neg_x");
    jNegXButton = NuiWidth(jNegXButton, 32.0f);
    jNegXButton = NuiHeight(jNegXButton, 32.0f);
    json jNegYButton = NuiButton(JsonString("-Y"));
    jNegYButton = NuiId(jNegYButton, "nui_fx_neg_y");
    jNegYButton = NuiWidth(jNegYButton, 32.0f);
    jNegYButton = NuiHeight(jNegYButton, 32.0f);
    json jNegZButton = NuiButton(JsonString("-Z"));
    jNegZButton = NuiId(jNegZButton, "nui_fx_neg_z");
    jNegZButton = NuiWidth(jNegZButton, 32.0f);
    jNegZButton = NuiHeight(jNegZButton, 32.0f);
    json jNegRButton = NuiButton(JsonString("-R"));
    jNegRButton = NuiId(jNegRButton, "nui_fx_neg_r");
    jNegRButton = NuiWidth(jNegRButton, 32.0f);
    jNegRButton = NuiHeight(jNegRButton, 32.0f);

    json jMagnitudeInput = NuiTextEdit(JsonString("Magnitude"), NuiBind("magnitude"), 10, FALSE);
    jMagnitudeInput = NuiId(jMagnitudeInput, "nui_fx_magnitude");
    jMagnitudeInput = NuiWidth(jMagnitudeInput, 175.0f);
    jMagnitudeInput = NuiHeight(jMagnitudeInput, 32.0f);

    json jPickupObjectButton = NuiButton(JsonString("Pickup Object"));
    jPickupObjectButton = NuiId(jPickupObjectButton, "nui_fx_pickup_object");
    jPickupObjectButton = NuiWidth(jPickupObjectButton, 175.0f);
    jPickupObjectButton = NuiHeight(jPickupObjectButton, 32.0f);

    json jSelectObjectButton = NuiButton(JsonString("Select Object"));
    jSelectObjectButton = NuiId(jSelectObjectButton, "nui_fx_select_object");
    jSelectObjectButton = NuiWidth(jSelectObjectButton, 175.0f);
    jSelectObjectButton = NuiHeight(jSelectObjectButton, 32.0f);

    json jCurrentObjectLabel = NuiLabel(JsonString("Current Object:"), JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_MIDDLE));
    json jCurrentObjectNameLabel = NuiLabel(NuiBind("object"), JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_MIDDLE));

    jRow       = JsonArrayInsert(jRow, NuiSpacer());
    jRow		= JsonArrayInsert(jRow, jPosXButton);
    jRow		= JsonArrayInsert(jRow, jPosYButton);
    jRow		= JsonArrayInsert(jRow, jPosZButton);
    jRow		= JsonArrayInsert(jRow, jPosRButton);
    jRow       = JsonArrayInsert(jRow, NuiSpacer());
    jRow		= NuiRow(jRow);
    jRoot		= JsonArrayInsert(jRoot, jRow);
    jRow        = JsonArray();

    jRow       = JsonArrayInsert(jRow, NuiSpacer());
    jRow       = JsonArrayInsert(jRow, jNegXButton);
    jRow       = JsonArrayInsert(jRow, jNegYButton);
    jRow       = JsonArrayInsert(jRow, jNegZButton);
    jRow		= JsonArrayInsert(jRow, jNegRButton);
    jRow       = JsonArrayInsert(jRow, NuiSpacer());
    jRow		= NuiRow(jRow);
    jRoot		= JsonArrayInsert(jRoot, jRow);
    jRow        = JsonArray();

    jRow        = JsonArrayInsert(jRow, jMagnitudeInput);
    jRow        = NuiRow(jRow);
    jRoot       = JsonArrayInsert(jRoot, jRow);
    jRow        = JsonArray();

    jRow       = JsonArrayInsert(jRow, NuiSpacer());
    jRow       = JsonArrayInsert(jRow, jSelectObjectButton);
    jRow       = JsonArrayInsert(jRow, NuiSpacer());
    jRow       = NuiRow(jRow);
    jRoot		= JsonArrayInsert(jRoot, jRow);
    jRow        = JsonArray();

    jRow       = JsonArrayInsert(jRow, jCurrentObjectLabel);
    jRow       = NuiRow(jRow);
    jRoot		= JsonArrayInsert(jRoot, jRow);
    jRow        = JsonArray();

    jRow       = JsonArrayInsert(jRow, jCurrentObjectNameLabel);
    jRow       = NuiRow(jRow);
	jRoot		= JsonArrayInsert(jRoot, jRow);
    jRow        = JsonArray();

    jRow       = JsonArrayInsert(jRow, NuiSpacer());
    jRow       = JsonArrayInsert(jRow, jPickupObjectButton);
    jRow       = JsonArrayInsert(jRow, NuiSpacer());
    jRow       = NuiRow(jRow);
	jRoot		= JsonArrayInsert(jRoot, jRow);
    jRow        = JsonArray();

	jRoot = NuiCol(jRoot);

	json nui = NuiWindow(jRoot, JsonString("Move Fixture"), NuiBind("geometry"), NuiBind("resizable"), NuiBind("collapsed"), NuiBind("closable"), NuiBind("transparent"), NuiBind("border"));

	int nToken = NuiCreate(oPlayer, nui, NUI_MOVE_FIXTURE_WINDOW);

	NuiSetBind(oPlayer, nToken, "geometry", NuiRect(-1.0f, -1.0f, 190.0f, 340.0f));
	NuiSetBind(oPlayer, nToken, "collapsed", JsonBool(FALSE));
	NuiSetBind(oPlayer, nToken, "resizable", JsonBool(TRUE));
	NuiSetBind(oPlayer, nToken, "closable", JsonBool(TRUE));
	NuiSetBind(oPlayer, nToken, "transparent", JsonBool(FALSE));
	NuiSetBind(oPlayer, nToken, "border", JsonBool(TRUE));
    NuiSetBind(oPlayer, nToken, "object", JsonString("NONE"));
    NuiSetBind(oPlayer, nToken, "magnitude", JsonString(""));
}

void asFXProcessEvent(object oPlayer, int nToken, string sEvent, string sElement, int nIndex, string sWindowId){
    SendMessageToPC(oPlayer, "Move fixture window: " + sElement + " Event type: " + sEvent);
    if(sEvent == "open" || sEvent == "close"){
        DeleteLocalObject(oPlayer, "AS_FX_TARGET_OBJECT");
        DeleteLocalObject(oPlayer, "AS_FX_MAGNITUDE");
        return;
    }
    if(sEvent == "blur"){
        float fMagnitude = StringToFloat(JsonGetString(NuiGetBind(oPlayer, nToken, "magnitude")));
        if(fMagnitude > 5.0f){
            fMagnitude = 5.0f;
        }
        if(fMagnitude < -5.0f){
            fMagnitude = -5.0f;
        }
        SendMessageToPC(oPlayer, "Set magnitude to: " + FloatToString(fMagnitude));
        SetLocalFloat(oPlayer, "AS_FX_MAGNITUDE", fMagnitude);
        return;
    }
    if(sEvent == "mouseup")
    {
        if(sElement == "nui_fx_select_object")
        {
            SetLocalInt(oPlayer, "AS_TARGET_MODE_ID", TARGETING_MODE_MOVE_FIXTURE);
            EnterTargetingMode(oPlayer, OBJECT_TYPE_PLACEABLE);
            return;
        }
        if(sElement == "nui_fx_pickup_object")
        {
            return;
        }
        float fMagnitude = GetLocalFloat(oPlayer, "AS_FX_MAGNITUDE");
        object oFixture = GetLocalObject(oPlayer, "AS_FX_TARGET_OBJECT");
        if(GetIsObjectValid(oFixture)){

            vector vPosition = GetPosition(oFixture);
            float fDirection = GetFacing(oFixture);
            if(sElement == "nui_fx_pos_x"){
                vPosition.x = vPosition.x + fMagnitude;
            }
            if(sElement == "nui_fx_pos_y"){
                vPosition.y = vPosition.y + fMagnitude;
            }
            if(sElement == "nui_fx_pos_z"){
                vPosition.z = vPosition.z + fMagnitude;
            }
            if(sElement == "nui_fx_pos_r"){
                fDirection = fDirection + fMagnitude;
            }
            if(sElement == "nui_fx_neg_x"){
                vPosition.x = vPosition.x - fMagnitude;
            }
            if(sElement == "nui_fx_neg_y"){
                vPosition.y = vPosition.y - fMagnitude;
            }
            if(sElement == "nui_fx_neg_z"){
                vPosition.z = vPosition.z - fMagnitude;
            }
            if(sElement == "nui_fx_neg_r"){
                fDirection = fDirection - fMagnitude;
            }
            object oNewFixture = gsFXMoveFixture(oFixture, vPosition, fDirection);
            SendMessageToPC(oPlayer, "Attempting to update fixture: " + GetName(oFixture));
            SetLocalObject(oPlayer, "AS_FX_TARGET_OBJECT", oNewFixture);

            if(oNewFixture == OBJECT_INVALID){
                SendMessageToPC(oPlayer, "Move fixture returned invalid.");
            }
        } else {
            SendMessageToPC(oPlayer, "Selected fixture is not valid.");
        }
    }
}

void asFXSetObjectSelection(object oPlayer, object oSelection){
    int nToken = NuiFindWindow(oPlayer, NUI_MOVE_FIXTURE_WINDOW);
    if (nToken == 0)
	{
		return;
	}
    if(GetLocalString(oSelection, "GS_FX_ID") == "")
    {
        SendMessageToPC(oPlayer, "Selected object is not a fixture.");
        return;
    }
    SetLocalObject(oPlayer, "AS_FX_TARGET_OBJECT", oSelection);
    NuiSetBind(oPlayer, nToken, "object", JsonString(GetName(oSelection)));
}