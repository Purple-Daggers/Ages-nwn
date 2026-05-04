#include "gs_inc_shop"

const int GS_VALUE = 50;

void main()
{
    int nSalePrice = GetLocalInt(OBJECT_SELF, "GS_SH_SALE_PRICE");
    gsSHSetSalePrice(OBJECT_SELF, nSalePrice + GS_VALUE);
}
