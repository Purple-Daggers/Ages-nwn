const int COLOR_CHANNEL = COLOR_CHANNEL_SKIN;
void main()
{
    object oSpeaker = GetPCSpeaker();
    int nNextColor = GetColor(oSpeaker, COLOR_CHANNEL) + 1   >= 175 ? 0 : GetColor(oSpeaker, COLOR_CHANNEL) + 1;
    SetColor(oSpeaker, COLOR_CHANNEL, nNextColor);
}
