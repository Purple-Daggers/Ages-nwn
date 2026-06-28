#include "gs_inc_common"
#include "gs_inc_time"

const int GS_TIMEOUT = 2400; //TIME UPDATE: 20 minutes

void main()
{
    gsCMCreateRecreator(gsTIGetActualTimestamp() + GS_TIMEOUT);
}
