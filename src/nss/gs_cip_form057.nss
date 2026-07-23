const int COLOR_CHANNEL = COLOR_CHANNEL_TATTOO_2;
void main()
{
    object oSpeaker = GetPCSpeaker();
    int nNextColor = GetColor(oSpeaker, COLOR_CHANNEL) - 1 < 0 ? 175 : GetColor(oSpeaker, COLOR_CHANNEL) - 1;
    SetColor(oSpeaker, COLOR_CHANNEL, nNextColor);
}
