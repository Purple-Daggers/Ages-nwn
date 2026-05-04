void main()
{
  string sSaid   = GetMatchedSubstring(0);
  object oTarget = GetLocalObject (OBJECT_SELF, "target");

  SetName(oTarget, sSaid);
  DestroyObject(OBJECT_SELF);
}
