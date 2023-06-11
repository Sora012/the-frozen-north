//::///////////////////////////////////////////////
//:: Gaze: Dominate
//:: NW_S1_GazeDomn
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Cone shape that affects all within the AoE if they
    fail a Will Save.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 9, 2001
//:://////////////////////////////////////////////
/*
Pach 1.72
- fixed casting the spell on self not finding any targets in AoE
Patch 1.71
- blinded/sightless creatures are not affected anymore
- wrong target check (could affect other NPCs)
- wrong duration and effect calculation (cumulative for each target in AoE)
*/

#include "70_inc_spells"
#include "x0_i0_spells"

void main()
{
    if(GZCanNotUseGazeAttackCheck(OBJECT_SELF))
    {
        return;
    }

    //Declare major variables
    int nHD ;
    int nDuration;
    int nDC;
    // shifter
    nHD = GetHitDice(OBJECT_SELF);
    nDuration = 1 + (nHD / 3);
    nDC = 10 + (nHD/2);

    location lTargetLocation = GetSpellTargetLocation();
    if(lTargetLocation == GetLocation(OBJECT_SELF))
    {
        vector vFinalPosition = GetPositionFromLocation(lTargetLocation);
        vFinalPosition.x+= cos(GetFacing(OBJECT_SELF));
        vFinalPosition.y+= sin(GetFacing(OBJECT_SELF));
        lTargetLocation = Location(GetAreaFromLocation(lTargetLocation),vFinalPosition,GetFacingFromLocation(lTargetLocation));
    }
    effect eGaze = EffectDominated();
    effect eVis = EffectVisualEffect(VFX_IMP_DOMINATE_S);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eVisDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);

    effect eLink = EffectLinkEffects(eDur, eVisDur);

    //Get first target in spell area
    object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE);
    effect scaledEffect;
    int scaledDuration;
    while(GetIsObjectValid(oTarget))
    {
        if(oTarget != OBJECT_SELF && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_GAZE_DOMINATE));
            //Determine effect delay
            float fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
            if(GetIsAbleToSee(oTarget) && !MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay))
            {
                scaledDuration = GetScaledDuration(nDuration, oTarget);
                scaledEffect = GetScaledEffect(eGaze, oTarget);
                scaledEffect = EffectLinkEffects(eLink, scaledEffect);

                //Apply the VFX impact and effects
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, scaledEffect, oTarget, RoundsToSeconds(scaledDuration)));
            }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE);
    }
}
