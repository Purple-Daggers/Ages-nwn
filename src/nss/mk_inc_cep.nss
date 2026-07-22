// mk_inc_cep

#include "mk_inc_tools"


int MK_CEP_GetIsCEPInstalled()
{
    return (MK_Get2DAInt("cepheadmodel", "HEAD_FEMALE_DWARF", 1) == 1);
}

/*
void main()
{

}
/**/
