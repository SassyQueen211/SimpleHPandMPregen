/**
 * Restores 1% of maximum HP and 1% of maximum MP per second outside combat.
 * The player state applies it when the loaded world starts, including in
 * existing saves.
 */
class UGE_SassyQueen_AutoRestore : UScriptGameplayEffect
{
    default DurationPolicy = EGameplayEffectDurationType::Infinite;
    default bExecutePeriodicEffectOnApplication = true;
    default Period.Value = 1.0f;

    // The game grants State_Combat while the player is in combat. GAS suspends
    // the periodic effect while this tag is present, then resumes it afterward.
    default TargetTagRequirements.OngoingTagRequirements.IgnoreTags.AddTag(GameplayTag::State_Combat);

    FGameplayModifierInfo healthModifier;
    default healthModifier.Attribute = GetAttribute(UAttributeSet_Health::StaticClass(), n"Health");
    default healthModifier.ModifierOp = EGameplayModOp::Additive;
    default healthModifier.ModifierMagnitude.MagnitudeCalculationType = EGameplayEffectMagnitudeCalculation::AttributeBased;
    default healthModifier.ModifierMagnitude.AttributeBasedMagnitude.BackingAttribute.AttributeToCapture = GetAttribute(UAttributeSet_Health::StaticClass(), n"MaxHealth");
    default healthModifier.ModifierMagnitude.AttributeBasedMagnitude.BackingAttribute.AttributeSource = EGameplayEffectAttributeCaptureSource::Target;
    default healthModifier.ModifierMagnitude.AttributeBasedMagnitude.Coefficient.Value = 0.01f;
    default Modifiers.Add(healthModifier);

    FGameplayModifierInfo manaModifier;
    default manaModifier.Attribute = GetAttribute(UAttributeSet_Mana::StaticClass(), n"Mana");
    default manaModifier.ModifierOp = EGameplayModOp::Additive;
    default manaModifier.ModifierMagnitude.MagnitudeCalculationType = EGameplayEffectMagnitudeCalculation::AttributeBased;
    default manaModifier.ModifierMagnitude.AttributeBasedMagnitude.BackingAttribute.AttributeToCapture = GetAttribute(UAttributeSet_Mana::StaticClass(), n"MaxMana");
    default manaModifier.ModifierMagnitude.AttributeBasedMagnitude.BackingAttribute.AttributeSource = EGameplayEffectAttributeCaptureSource::Target;
    default manaModifier.ModifierMagnitude.AttributeBasedMagnitude.Coefficient.Value = 0.01f;
    default Modifiers.Add(manaModifier);
}

UCLASS(meta=(ReplaceParentClass))
class AG1RPlayerState_SassyQueen_AutoRestore : AG1RPlayerState
{
    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        UGothicAbilitySystemComponent GothicASC = AbilitySystemComponent;
        if (IsValid(GothicASC))
        {
            GothicASC.ApplyGameplayEffectToSelf(
                UGE_SassyQueen_AutoRestore::StaticClass(),
                1,
                GothicASC.MakeEffectContext()
            );
        }
    }
}
