#include "gs_inc_subrace"
void main()
{
    float fScale = GetObjectVisualTransform(OBJECT_SELF, OBJECT_VISUAL_TRANSFORM_SCALE);
    gsSUSavePlayerSubraceScale(OBJECT_SELF, fScale);
}

