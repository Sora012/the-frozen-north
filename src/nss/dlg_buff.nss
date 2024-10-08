#include "inc_debug"
void main()
{
    object oPC = GetPCSpeaker();

    if (GetIsDeveloper(oPC))
    {
        SendDiscordLogMessage(GetName(oPC) + " used the developer menu to apply various OP buffs to themselves, permanently.");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAttackIncrease(20), oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamageIncrease(30), oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectMovementSpeedIncrease(99), oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectTemporaryHitpoints(200), oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectHaste(), oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillIncrease(SKILL_SEARCH, 50), oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillIncrease(SKILL_LORE, 50), oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillIncrease(SKILL_PERSUADE, 50), oPC);
    }
}
