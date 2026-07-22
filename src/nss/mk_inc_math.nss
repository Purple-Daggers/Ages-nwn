// mk_inc_math
#include "mk_inc_debug"


const float MK_MATH_fDelta = 0.0001;

int MK_MATH_GetIsEqual(float f1, float f2)
{
    return (fabs(f1-f2)<MK_MATH_fDelta);
}

int MK_MATH_GetIsGreaterEqual(float f1, float f2)
{
    return ((f1-f2) > -MK_MATH_fDelta);
}

int MK_MATH_GetIsLowerEqual(float f1, float f2)
{
    return ((f2-f1) > -MK_MATH_fDelta);
}

float MK_MATH_Log10(float f)
{
    return log(f) / log(10.0);
}

int MK_MATH_CeilQ(float f, float p)
{
    int nResult;
    int nLog10 = FloatToInt(MK_MATH_Log10(f));
    if (nLog10<FloatToInt(p))
    {
        float d = 1.0f - pow(0.1, p-nLog10);
        nResult = FloatToInt(f+d);
/*        MK_DEBUG_TRACE("MK_MATH_Ceil("+FloatToString(f)+","+FloatToString(p)+")"
            +": log10="+FloatToString(MK_MATH_Log10(f))
            +", nLog10="+IntToString(nLog10)
            +", p-nLog10="+FloatToString(p-nLog10)
            +", pow(0.1, p-nLog10)="+FloatToString(pow(0.1, p-nLog10))
            +", d=1.0-pow()="+FloatToString(d)
            +", f+d="+FloatToString(f+d)
            +", nResult="+IntToString(nResult));*/
    }
    else
    {
        nResult = FloatToInt(f);
/*        MK_DEBUG_TRACE("MK_MATH_Ceil("+FloatToString(f)+"): nLog10="+IntToString(nLog10)
            +", nResult="+IntToString(nResult));*/
    }
    return nResult;
}

int MK_MATH_Ceil(float f)
{
//    MK_MATH_CeilQ(f, 8.0);
//    MK_MATH_CeilQ(f, 7.0);
    int nResult = MK_MATH_CeilQ(f, 6.0);
//    MK_MATH_CeilQ(f, 5.0);
//    MK_MATH_CeilQ(f, 4.0);
    return nResult;
}

int MK_MATH_Floor(float f)
{
    int nResult = FloatToInt(f);
    return nResult;
}

int MK_MATH_Round(float f)
{
    int nResult = FloatToInt(f + 0.5f);
    return nResult;
}

int MK_MATH_MaxInt(int n1, int n2)
{
    return (n1>n2?n1:n2);
}

int MK_MATH_MinInt(int n1, int n2)
{
    return (n1<n2?n1:n2);
}

/*
void main()
{
}
/**/

