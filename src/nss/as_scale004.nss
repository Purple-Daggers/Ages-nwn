#include "gs_inc_subrace"
void main()
{
    int nSubRace = gsSUGetSubRace(OBJECT_SELF);
    float fScale = gsSUGetSubRaceScale(nSubRace);
    float fVariance = gsSUGetSubRaceScaleVariance(nSubRace);
    int sign = Random(2) ? 1 : -1;
    SetObjectVisualTransform(OBJECT_SELF, OBJECT_VISUAL_TRANSFORM_SCALE,
                               fScale + (sign * (Random(101) * ((fVariance/3.0f)/100.0f))));
}
