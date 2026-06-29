#include "gs_inc_pc"

const string AS_RP_REPUTATION_DATABASE = "AS_REPUTATION";

int asRPGetReputation(object oPlayer, string sFaction);
void asRPSetReputation(object oPlayer, string sFaction, int nNewReputation);
void asRPDeleteReputation(object oPlayer, string sFaction);
void asRPAdjustReputation(object oPlayer, string sFaction, int nChange);
json asRPGetReputations(object oPlayer);
int asRPGetNextReputation(json jReputationsList, int nNth);
json _asRPGetReputationJson(object oPlayer);
void _asRPSetReputationJson(object oPlayer, json jNewJson);



int asRPGetReputation(object oPlayer, string sFaction){
    json jReputations = _asRPGetReputationJson(oPlayer);
    if (JsonGetType(jReputations) == JSON_TYPE_OBJECT)
    {
        json jReputation = JsonObjectGet(jReputations, sFaction);
        if(JsonGetType(jReputation) == JSON_TYPE_NULL)
        {
            return 0;
        }
        else
        {
            return JsonGetInt(jReputation);
        }
    }
    else
    {
        return -999;
    }
}

void asRPSetReputation(object oPlayer, string sFaction, int nNewReputation){
    json jReputations = _asRPGetReputationJson(oPlayer);
    JsonObjectSetInplace(jReputations, sFaction, JsonInt(nNewReputation));
    _asRPSetReputationJson(oPlayer, jReputations);
}

void asRPDeleteReputation(object oPlayer, string sFaction){
    json jReputations = _asRPGetReputationJson(oPlayer);
    JsonObjectDelInplace(jReputations, sFaction);
    _asRPSetReputationJson(oPlayer, jReputations);
}

void asRPAdjustReputation(object oPlayer, string sFaction, int nChange){
    json jReputations = _asRPGetReputationJson(oPlayer);
    int nOldReputation = 0;
    json jOldReputationJsonInt = JsonObjectGet(jReputations, sFaction);
    if(JsonGetType(jOldReputationJsonInt) != JSON_TYPE_NULL){
        nOldReputation = JsonGetInt(jOldReputationJsonInt);
    }
    JsonObjectSetInplace(jReputations, sFaction, JsonInt(nOldReputation + nChange));
    _asRPSetReputationJson(oPlayer, jReputations);
}

json asRPGetReputations(object oPlayer)
{
    json jReputations = _asRPGetReputationJson(oPlayer);
    return JsonObjectKeys(jReputations);
}

int asRPGetNextReputation(json jReputationsList, int nNth)
{
    JsonGetType(JsonArrayGet(jReputationsList, nNth + 1)) == JSON_TYPE_NULL ? -1 : nNth + 1;
}

int asRPGetPreviousReputation(json jReputationsList, int nNth)
{
    JsonGetType(JsonArrayGet(jReputationsList, nNth - 1)) == JSON_TYPE_NULL ? -1 : nNth - 1;
}

json _asRPGetReputationJson(object oPlayer){
    string sDatabase = AS_RP_REPUTATION_DATABASE;
    sqlquery sqlCreateReputationTable = SqlPrepareQueryCampaign(sDatabase, "CREATE TABLE IF NOT EXISTS reputations (player_id TEXT PRIMARY KEY, json TEXT);");
    SqlStep(sqlCreateReputationTable);
    sqlquery sqlGetReputationJson = SqlPrepareQueryCampaign(sDatabase, "SELECT json FROM reputations WHERE player_id = @id");
    SqlBindString(sqlGetReputationJson, "@id", gsPCGetPlayerID(oPlayer));
    if(SqlStep(sqlGetReputationJson))
    {
        json jReputations = SqlGetJson(sqlGetReputationJson, 0);
        if (JsonGetType(jReputations) == JSON_TYPE_NULL) {
            return JsonObject();
        }
        return jReputations;
    }
    else
    {
        return JsonObject();
    }
}

void _asRPSetReputationJson(object oPlayer, json jNewJson){
    if(!GetIsPC(oPlayer)){
        return;
    }
    string sDatabase = AS_RP_REPUTATION_DATABASE;
    sqlquery sqlUpdateReputationJson = SqlPrepareQueryCampaign(sDatabase, "UPDATE reputations SET json = @json WHERE player_id = @id");
    SqlBindString(sqlUpdateReputationJson, "@id", gsPCGetPlayerID(oPlayer));
    SqlBindJson(sqlUpdateReputationJson, "@json", jNewJson);
    SqlStep(sqlUpdateReputationJson);
}
