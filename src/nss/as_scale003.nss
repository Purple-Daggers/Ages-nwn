#include "gs_inc_subrace"
void main()
{
    int nSubRace = gsSUGetSubRace(OBJECT_SELF);
    float fScale = gsSUGetSubRaceScale(nSubRace);
    float fVariance = gsSUGetSubRaceScaleVariance(nSubRace);
    SetObjectVisualTransform(OBJECT_SELF, OBJECT_VISUAL_TRANSFORM_SCALE,
                               fScale + (fVariance/3.0f) + (Random(101) * ((fVariance - (fVariance/3.0f))/100.0f)));
}
