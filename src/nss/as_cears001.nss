#include "as_inc_ear"
int StartingConditional()
{
    SetCustomToken(3000, asEAGetEarScale(OBJECT_SELF));
    vVector = asEAGetEarVector(OBJECT_SELF);
    SetCustomToken(3001, vVector.x);
    SetCustomToken(3002, vVector.y);
    SetCustomToken(3003, vVector.z);
    asEACreateEars(OBJECT_SELF)
    return TRUE;
}
