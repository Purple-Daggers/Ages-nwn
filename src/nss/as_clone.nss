void main()
{
    object oUser = GetLastUsedBy();
    CopyObject(oUser, GetLocation(oUser));
}