#include "as_inc_ear"
int StartingConditional()
{
    SetCustomToken(3000, FloatToString(asEAGetEarScale(OBJECT_SELF)));
    vector vVector = asEAGetEarVector(OBJECT_SELF);
    SetCustomToken(3001, FloatToString(vVector.x));
    SetCustomToken(3002, FloatToString(vVector.y));
    SetCustomToken(3003, FloatToString(vVector.z));
    asEACreateEars(OBJECT_SELF);
    return TRUE;
}
