#include "nw_inc_nui"
#include "nw_inc_nui_insp"

const string NUI_MOVE_FIXTURE_WINDOW = "nui_fx_move_fixture_window";

void asFXMoveObjectNui(object oPlayer)
{

	int nPreviousToken = NuiFindWindow(oPlayer, NUI_MOVE_FIXTURE_WINDOW);
	if (nPreviousToken != 0)
	{
		NuiDestroy(oPlayer, nPreviousToken);
	}

	json jRoot = JsonArray();
	json jRow1 = JsonArray();
    json jRow2 = JsonArray();
    json jRow3 = JsonArray();
    json jRow4 = JsonArray();
    json jRow5 = JsonArray();

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

    json jSelectObjectButton = NuiButton(JsonString("Select Object"));
    jSelectObjectButton = NuiId(jSelectObjectButton, "nui_fx_select_object");
    jSelectObjectButton = NuiWidth(jSelectObjectButton, 175.0f);
    jSelectObjectButton = NuiHeight(jSelectObjectButton, 32.0f);

    json jCurrentObjectLabel = NuiLabel(JsonString("Current Object:"), JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_MIDDLE));
    json jCurrentObjectNameLabel = NuiLabel(NuiBind("object"), JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_MIDDLE));

    jRow1       = JsonArrayInsert(jRow1, NuiSpacer());
    jRow1		= JsonArrayInsert(jRow1, jPosXButton);
    jRow1		= JsonArrayInsert(jRow1, jPosYButton);
    jRow1		= JsonArrayInsert(jRow1, jPosZButton);
    jRow1       = JsonArrayInsert(jRow1, NuiSpacer());
    jRow1		= NuiRow(jRow1);

    jRow2       = JsonArrayInsert(jRow2, NuiSpacer());
    jRow2       = JsonArrayInsert(jRow2, jNegXButton);
    jRow2       = JsonArrayInsert(jRow2, jNegYButton);
    jRow2       = JsonArrayInsert(jRow2, jNegZButton);
    jRow2       = JsonArrayInsert(jRow2, NuiSpacer());
    jRow2		= NuiRow(jRow2);

    jRow3       = JsonArrayInsert(jRow3, NuiSpacer());
    jRow3       = JsonArrayInsert(jRow3, jSelectObjectButton);
    jRow3       = JsonArrayInsert(jRow3, NuiSpacer());
    jRow3       = NuiRow(jRow3);

    jRow4       = JsonArrayInsert(jRow4, jCurrentObjectLabel);
    jRow4       = NuiRow(jRow4);

    jRow5       = JsonArrayInsert(jRow5, jCurrentObjectNameLabel);
    jRow5       = NuiRow(jRow5);

	jRoot		= JsonArrayInsert(jRoot, jRow1);
    jRoot       = JsonArrayInsert(jRoot, jRow2);
    jRoot       = JsonArrayInsert(jRoot, jRow3);
    jRoot       = JsonArrayInsert(jRoot, jRow4);
    jRoot       = JsonArrayInsert(jRoot, jRow5);

	jRoot = NuiCol(jRoot);

	json nui = NuiWindow(jRoot, JsonString("Move Fixture"), NuiBind("geometry"), NuiBind("resizable"), NuiBind("collapsed"), NuiBind("closable"), NuiBind("transparent"), NuiBind("border"));

	int nToken = NuiCreate(oPlayer, nui, NUI_MOVE_FIXTURE_WINDOW);

	NuiSetBind(oPlayer, nToken, "geometry", NuiRect(-1.0f, -1.0f, 220.0f, 240.0f));
	NuiSetBind(oPlayer, nToken, "collapsed", JsonBool(FALSE));
	NuiSetBind(oPlayer, nToken, "resizable", JsonBool(TRUE));
	NuiSetBind(oPlayer, nToken, "closable", JsonBool(TRUE));
	NuiSetBind(oPlayer, nToken, "transparent", JsonBool(FALSE));
	NuiSetBind(oPlayer, nToken, "border", JsonBool(TRUE));
    NuiSetBind(oPlayer, nToken, "object", JsonString("NONE"));
}