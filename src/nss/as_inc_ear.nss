#include "gs_inc_pc"

const string AS_EAR_DATABASE = "AS_EARS";
const int VFX_CAT_EARS = 10100;
const float AS_EAR_SCALE_UPPER_LIMIT = 1.5;
const float AS_EAR_SCALE_LOWER_LIMIT = 0.5;
const float AS_EAR_TRANSLATE_LIMIT = 0.5;

void asEACreateDatabase();
void asEAInitializeEarRecord(object oPlayer);
float asEAGetEarScale(object oPlayer);
vector asEAGetEarVector(object oPlayer);
void asEASetEarScale(object oPlayer, float fScale);
void asEASetEarVector(object oPlayer, vector vEarVector);
void asEATransformEarScale(object oPlayer, float fChangeScale);
void asEATransformEarVector(object oPlayer, float fChangeX, float fChangeY, float fChangeZ);
void asEARemoveEars(object oPlayer);
void asEACreateEars(object oPlayer);

void asEACreateDatabase()
{
    sqlquery sqlCreateTable = SqlPrepareQueryCampaign(AS_EAR_DATABASE, "CREATE TABLE IF NOT EXISTS ears (id TEXT PRIMARY KEY, scale REAL, translate BLOB, type INTEGER);");
    SqlStep(sqlCreateTable);
}

void asEAInitializeEarRecord(object oPlayer)
{
    asEACreateDatabase();
    sqlquery sqlInitializeEars = SqlPrepareQueryCampaign(AS_EAR_DATABASE, "INSERT INTO ears (id, scale, translate, type) VALUES (@id, @scale, @translate, @type);");
    SqlBindString(sqlInitializeEars, "@id", gsPCGetPlayerID(oPlayer));
    SqlBindFloat(sqlInitializeEars, "@scale", 0.0f);
    SqlBindVector(sqlInitializeEars, "@translate", Vector(0.0f, 0.0f, 0.0f));
    SqlBindInt(sqlInitializeEars, "@type", VFX_CAT_EARS);
    SqlStep(sqlInitializeEars);
}

float asEAGetEarScale(object oPlayer)
{
    sqlquery sqlGetEarScale = SqlPrepareQueryCampaign(AS_EAR_DATABASE, "SELECT scale from ears WHERE id = @id");
    SqlBindString(sqlGetEarScale, "@id", gsPCGetPlayerID(oPlayer));
    if(SqlStep(sqlGetEarScale))
    {
        return SqlGetFloat(sqlGetEarScale, 0);
    }
    else
    {
        asEAInitializeEarRecord(oPlayer);
        return 0.0f;
    }
}

vector asEAGetEarVector(object oPlayer)
{
    sqlquery sqlGetEarVector = SqlPrepareQueryCampaign(AS_EAR_DATABASE, "SELECT translate from ears WHERE id = @id");
    SqlBindString(sqlGetEarVector, "@id", gsPCGetPlayerID(oPlayer));
    if(SqlStep(sqlGetEarVector))
    {
        return SqlGetVector(sqlGetEarVector, 0);
    }
    else
    {
        asEAInitializeEarRecord(oPlayer);
        return Vector(0.0f, 0.0f, 0.0f);
    }
}

void asEASetEarScale(object oPlayer, float fScale)
{
    sqlquery sqlSetEarScale = SqlPrepareQueryCampaign(AS_EAR_DATABASE, "UPDATE ears SET scale = @scale WHERE id = @id;");
    SqlBindString(sqlSetEarScale, "@id", gsPCGetPlayerID(oPlayer));
    SqlBindFloat(sqlSetEarScale, "@scale", fScale);
    SqlStep(sqlSetEarScale);
}

void asEASetEarVector(object oPlayer, vector vEarVector)
{
    sqlquery sqlSetEarVector = SqlPrepareQueryCampaign(AS_EAR_DATABASE, "UPDATE ears SET translate = @translate WHERE id = @id;");
    SqlBindString(sqlSetEarVector, "@id", gsPCGetPlayerID(oPlayer));
    SqlBindVector(sqlSetEarVector, "@translate", vEarVector);
    SqlStep(sqlSetEarVector);
}

void asEATransformEarScale(object oPlayer, float fChangeScale)
{
    float fChangedScale = asEAGetEarScale(oPlayer);
    fChangedScale = fChangedScale + fChangeScale;
    if(fChangedScale > AS_EAR_SCALE_UPPER_LIMIT){
        fChangedScale = AS_EAR_SCALE_UPPER_LIMIT;
    }
    if(fChangedScale < AS_EAR_SCALE_LOWER_LIMIT){
        fChangedScale = AS_EAR_SCALE_LOWER_LIMIT;
    }
    asEASetEarScale(oPlayer, fChangedScale);
}

void asEATransformEarVector(object oPlayer, float fChangeX, float fChangeY, float fChangeZ)
{
    vector vChangedVector = asEAGetEarVector(oPlayer);
    vChangedVector.x = vChangedVector.x + fChangeX;
    vChangedVector.y = vChangedVector.y + fChangeY;
    vChangedVector.z = vChangedVector.z + fChangeZ;
    
    if(vChangedVector.x > AS_EAR_TRANSLATE_LIMIT){
        vChangedVector.x = AS_EAR_TRANSLATE_LIMIT;
    }
    if(vChangedVector.y > AS_EAR_TRANSLATE_LIMIT){
        vChangedVector.y = AS_EAR_TRANSLATE_LIMIT;
    }
    if(vChangedVector.z > AS_EAR_TRANSLATE_LIMIT){
        vChangedVector.z = AS_EAR_TRANSLATE_LIMIT;
    }

    if(vChangedVector.x < (-1 * AS_EAR_TRANSLATE_LIMIT)){
        vChangedVector.x = (-1 * AS_EAR_TRANSLATE_LIMIT);
    }
    if(vChangedVector.y < (-1 * AS_EAR_TRANSLATE_LIMIT)){
        vChangedVector.y = (-1 * AS_EAR_TRANSLATE_LIMIT);
    }
    if(vChangedVector.z < (-1 * AS_EAR_TRANSLATE_LIMIT)){
        vChangedVector.z = (-1 * AS_EAR_TRANSLATE_LIMIT);
    }

    asEASetEarVector(oPlayer, vChangedVector);
}

void asEARemoveEars(object oPlayer)
{
    effect eLoop = GetFirstEffect(oPlayer);
    while(GetIsEffectValid(eLoop))
    {
        if(GetEffectType(eLoop) == EFFECT_TYPE_VISUALEFFECT)
            if(GetEffectInteger(eLoop, 0) == VFX_CAT_EARS)
            {
                RemoveEffect(oPlayer, eLoop);
            }
        eLoop = GetNextEffect(oPlayer);
    }
}

void asEACreateEars(object oPlayer)
{
    float fScale = asEAGetEarScale(oPlayer);
    vector vTranslate = asEAGetEarVector(oPlayer);
    asEARemoveEars(oPlayer);
    DelayCommand(0.01f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_CAT_EARS, FALSE, fScale, vTranslate), oPlayer));
}