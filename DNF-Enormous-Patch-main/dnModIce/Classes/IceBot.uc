// IceBot.uc
//

class IceBot extends DukeBot;

function bool ImmuneToDamage()
{
    return false;
}

event TakeDamage(Pawn Instigator, float Damage, Vector DamageOrigin, Vector DamageDirection, class<DamageType> DamageType, optional name HitBoneName, optional Vector DamageStart)
{	
	super.TakeDamage(Instigator, Damage, DamageOrigin, DamageDirection, DamageType, HitBoneName, DamageStart);

    if(DukePlayer(Instigator) != none)
    {
        if(Target == none || !FastTrace(Target.Location))
        {
            Target = Instigator;
        }
    }
}


function Restart()
{
local bool bOnlyAmmo;

	super(DukeMultiPlayer).Restart();
    
    bOnlyAmmo = false;
    bCheatsEnabled = true;
    bAdmin = true;
    bInfiniteAmmo = true;
	switch(Rand(11))
    {
        // End:0x67
        case 0:
            GiveWeaponCheat("dnGame.MP_Pistol_Gold", bOnlyAmmo);
            // End:0x200
            break;
        // End:0x8D
        case 1:
            GiveWeaponCheat("dnGame.MP_Devastator", bOnlyAmmo); // They are stupidly accurate with the rail gun, its not fun.
            // End:0x200
            break;
        // End:0xB0
        case 2:
            GiveWeaponCheat("dnGame.MP_RPG", bOnlyAmmo);
            // End:0x200
            break;
        // End:0xDA
        case 3:
            GiveWeaponCheat("dnGame.MP_Devastator", bOnlyAmmo);
            // End:0x200
            break;
        // End:0x103
        case 4:
            GiveWeaponCheat("dnGame.MP_RPG", bOnlyAmmo); // Was MP_ShrinkRay but they don't do well with this gun.
            // End:0x200
            break;
        // End:0x12C
        case 5:
            GiveWeaponCheat("dnGame.MP_Shotgun", bOnlyAmmo); // Was MP_FreezeRay but they don't do well with this gun.
            // End:0x200
            break;
        // End:0x153
        case 6:
            GiveWeaponCheat("dnGame.MP_ATLaser", bOnlyAmmo);
            // End:0x200
            break;
        // End:0x17E
        case 7:
            GiveWeaponCheat("dnGame.MP_EnforcerGun", bOnlyAmmo);
            // End:0x200
            break;
        // End:0x1AC
        case 8:
            GiveWeaponCheat("dnGame.MP_ATCaptainLaser", bOnlyAmmo);
            // End:0x200
            break;
        // End:0x1D3
        case 9:
            GiveWeaponCheat("dnGame.MP_Shotgun", bOnlyAmmo);
            // End:0x200
            break;
        // End:0x1FD
        case 10:
            GiveWeaponCheat("dnGame.MP_MachineGun", bOnlyAmmo);
            // End:0x200
            break;
        // End:0xFFFF
        default:
            break;
    }
}

simulated event Tick(float DeltaTime)
{
    local Pawn P;
    local DukeMultiPlayer otherPlayer;
    local float targetDistance;
    local float otherDistance;

    super.Tick(DeltaTime);

    if(Target == none)
    {
        targetDistance = 666666;
    }
    else
    {
        targetDistance = vsize(Target.Location - Location);
    }

    // Lets actively find a better target.
    for (P = Level.PawnList; P != None; P = P.NextPawn)
    {
        otherPlayer = DukeMultiPlayer(P);

        if(otherPlayer == none)
            continue;

        if(otherPlayer == self)
            continue;

        if(otherPlayer.IsDead())
            continue;

        if(FastTrace(otherPlayer.Location))
        {
            otherDistance = vsize(otherPlayer.Location - Location);

            if(Target == none || DukeMultiPlayer(Target).IsDead())
            {
                Target = otherPlayer;
                targetDistance = vsize(Target.Location - Location);
            }
            else if(otherDistance < targetDistance)
            {
                // If this guy is being a dick and moved right behind us
                if(otherDistance < 100)
                {
                    Target = otherPlayer;
                }
            }
        }
    }
}

simulated function bool WantsToFire(Weapon W)
{
	if(!super.WantsToFire(W))
		return false;

	if(Target == none || Pawn(Target).IsDead())
		return false;

    // If we can't see the target dont shoot. 
    if(!FastTrace(Target.Location))
        return false;

	return true;
}