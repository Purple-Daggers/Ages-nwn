//constant
const string GS_DELAY     = "GS_HC_D";
const string GS_ENABLED   = "GS_HC_E";
const string GS_FLAG      = "GS_HC_F";

const float GS_INTERVAL_S =    0.25; //check interval in seconds
const int GS_INTERVAL_MS  =  250;    //check interval in milliseconds
const int GS_DELAY_MS     = 6000;    //hips override time

//global
object oPC                = OBJECT_INVALID;
int nDelay                = 0;

//start hide in plain sight check, run only once!
void gsHCRun();

void main()
{
    gsHCRun();
}
//----------------------------------------------------------------
void gsHCRun()
{
    oPC = GetFirstPC();

    while (oPC != OBJECT_INVALID)
    {
        //check for hide in plain sight feature
        if (GetHasFeat(FEAT_HIDE_IN_PLAIN_SIGHT, oPC))
        {
            //check if pc was in stealth mode
            if (GetLocalInt(oPC, GS_ENABLED))
            {
                //check if pc is not in stealth mode
                if (! GetActionMode(oPC, ACTION_MODE_STEALTH))
                {
                    //set timeout and remove stealth mode flag
                    SetLocalInt(oPC, GS_DELAY, GS_DELAY_MS);
                    DeleteLocalInt(oPC, GS_ENABLED);
                }
            }
            else
            {
                //count down timer
                nDelay = GetLocalInt(oPC, GS_DELAY);

                if (nDelay)
                {
                    nDelay -= GS_INTERVAL_MS;

                    //check if override time is elapsed
                    if (nDelay <= 0)
                    {
                        if (GetLocalInt(oPC, GS_FLAG))
                        {
                            SetActionMode(oPC, ACTION_MODE_STEALTH, TRUE);
                        }

                        nDelay = 0;
                        DeleteLocalInt(oPC, GS_DELAY);
                    }
                    else
                    {
                        SetLocalInt(oPC, GS_DELAY, nDelay);
                    }
                }

                //check if pc is in stealth mode
                if (GetActionMode(oPC, ACTION_MODE_STEALTH))
                {
                    //check if stealth mode is allowed yet
                    if (nDelay)
                    {
                        //deactivate stealth mode and set command flag
                        SetActionMode(oPC, ACTION_MODE_STEALTH, FALSE);
                        SetLocalInt(oPC, GS_FLAG, TRUE);

                        //message
                        FloatingTextStringOnCreature(
                            "*You will hide in " +
                            IntToString(nDelay / 1000 + 1) + " seconds.*",
                            oPC,
                            FALSE);
                    }
                    else
                    {
                        //set stealth mode flag
                        SetLocalInt(oPC, GS_ENABLED, TRUE);
                    }
                }
            }
        }

        oPC = GetNextPC();
    }

    DelayCommand(GS_INTERVAL_S, gsHCRun());
}
