//::///////////////////////////////////////////////
//:: Average Spike Trap
//:: NW_T1_SpikeAvgC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Strikes the entering object with a spike for
    3d6 damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 4th , 2001
//:://////////////////////////////////////////////
/*
Patch 1.70

- DC adjusted, was fixed 15 for all spike traps
*/

#include "70_inc_spells"
#include "inc_trap"

void main()
{
    //1.72: fix for bug where traps are being triggered where they really aren't
    if(GetObjectType(OBJECT_SELF) == OBJECT_TYPE_TRIGGER && !GetIsInSubArea(GetEnteringObject()))
    {
        return;
    }
    //Declare major variables
    object oTarget = GetEnteringObject();

    int nRealDamage = GetSavingThrowAdjustedDamage(d6(3), oTarget, 18, SAVING_THROW_REFLEX, SAVING_THROW_TYPE_TRAP, OBJECT_SELF);
    if (nRealDamage > 0)
    {
        effect eDam = EffectDamage(nRealDamage, DAMAGE_TYPE_PIERCING);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
        SetTrapTriggeredOnCreature(oTarget, "average spike trap");
    }
    effect eVis = EffectVisualEffect(VFX_IMP_SPIKE_TRAP, FALSE, TRAP_VFX_SIZE_AVERAGE);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));
}
