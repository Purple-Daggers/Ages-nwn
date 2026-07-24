#include "gs_inc_subrace"
void main()
{
    int nSubRace = gsSUGetSubRace(OBJECT_SELF);
    float fScale = 0.9f;
    float fVariance = gsSUGetSubRaceScaleVariance(nSubRace);
    SetObjectVisualTransform(OBJECT_SELF, OBJECT_VISUAL_TRANSFORM_SCALE,
                               fScale - (Random(101) * ((fVariance - (fVariance/3.0f))/100.0f)));
}
