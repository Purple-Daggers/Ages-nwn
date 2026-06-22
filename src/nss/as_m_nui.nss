#include "nw_inc_nui"
#include "as_inc_fxnui"

void main() {
	
	object oPlayer	 = NuiGetEventPlayer();
	int nToken	 = NuiGetEventWindow();
	string sEvent	 = NuiGetEventType();
	string sElement	 = NuiGetEventElement();
	int nIndex	 = NuiGetEventArrayIndex();
	string sWindowId = NuiGetWindowId(oPlayer, nToken);

	if (sWindowId == "nui_fx_move_fixture_window") 
	{
		asFXProcessEvent(oPlayer, nToken, sEvent, sElement, nIndex, sWindowId);
		return;
	}

	// This only displays if we get an event that wasn't handled above.
	SendMessageToPC(oPlayer, "WARNING: Receive an OnNuiEvent, but nothing handled (claimed) it.  Please check.  Player: " + GetName(oPlayer) + " nToken: " + IntToString(nToken) + " sEvent: " + sEvent + " sElement: " + sElement + " nIndex: " + IntToString(nIndex) + " sWindowId: " + sWindowId);
}