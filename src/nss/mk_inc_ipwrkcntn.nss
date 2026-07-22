#include "x2_inc_itemprop"
#include "mk_inc_vfx"

object MK_IPGetIPWorkContainer(object oCaller = OBJECT_SELF)
{
    object oRet = GetObjectByTag(X2_IP_WORK_CONTAINER_TAG);
    if (oRet == OBJECT_INVALID)
    {
        oRet = CreateObject(OBJECT_TYPE_PLACEABLE,X2_IP_WORK_CONTAINER_TAG,GetLocation(oCaller));

//        effect eInvis =  EffectVisualEffect( VFX_DUR_CUTSCENE_INVISIBILITY);
//        eInvis = ExtraordinaryEffect(eInvis);
//        ApplyEffectToObject(DURATION_TYPE_PERMANENT,eInvis,oRet);
        if (oRet == OBJECT_INVALID)
        {
            WriteTimestampedLogEntry("mk_inc_ipwrkcntn - critical: Missing container with tag " +X2_IP_WORK_CONTAINER_TAG + "!!");
        }
        else
        {
            MK_VFX_ApplyVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY, oRet, SUBTYPE_EXTRAORDINARY, DURATION_TYPE_PERMANENT);
        }
    }

    return oRet;
}


/*
void main()
{

}
/**/
