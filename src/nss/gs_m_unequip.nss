#include "gs_inc_effect"

void main()
{
    object oUnequippedBy = GetPCItemLastUnequippedBy();
    object oUnequipped   = GetPCItemLastUnequipped();

    gsFXRemoveEffect(oUnequippedBy, oUnequipped);
}
