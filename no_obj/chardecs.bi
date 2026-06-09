/'****************************************************************************
*
* Name: character.bi
*
* Synopsis: Character related routines for DOD.
*
* Description: This file contains the character generation and management
*  routines used in the program. 
*  
*
* Copyright 2010, Richard D. Clark
*
*  The Wide Open License (WOL)
*
* Permission to use, copy, modify, distribute and sell this software and its
* documentation for any purpose is hereby granted without fee, provided that
* the above copyright notice and this license appear in all source copies. 
* THIS SOFTWARE IS PROVIDED "AS IS" WITHOUT EXPRESS OR IMPLIED WARRANTY OF
* ANY KIND. See http://www.dspguru.com/wol.htm for more information.
*
*****************************************************************************'/
Declare Function GetBestArmor() As armorids 'Returns the best armor based on strength.
Declare Function CharName() As String 'Character name. 
Declare Sub SetLocx(xx As Integer)  'Sets X coord of character.
Declare Function GetLocx() As Integer 'Returns the X coord of character.
Declare Sub SetLocy(xx As Integer)  'Sets X coord of character.
Declare Function GetLocy() As Integer 'Returns the X coord of character.
Declare Sub SetCurrHP(hp As Integer)'Sets the hp.
Declare Function GetCurrHP() As Integer  'Returns the current HP.
Declare Function GetMaxHP() As Integer'Returns the current HP.
Declare Sub SetCurrMana(hp As Integer) 'Sets the mana.
Declare Function GetCurrMana() As Integer'Returns the current mana.
Declare Function MaxMana() As Integer 'Returns the current mana.
Declare Function GetCurrStr() As Integer 'Returns the current strength value.
Declare Sub SetCurrStr(amt As Integer) 'Sets the current strength value. 
Declare Function GetBonStr() As Integer  'Returns the current strength bonus value..
Declare Sub SetBonStr(amt As Integer)  'Sets the current strength bonus value.
Declare Function GetBonStrCnt() As Integer'Returns the current strength bonus value..
Declare Sub SetBonStrCnt(amt As Integer)'Sets the current strength bonus value.
Declare Function GetCurrSta() As Integer 'Returns the current stamina value.
Declare Sub SetCurrSta(amt As Integer) 'Sets the current stamina value. 
Declare Function GetBonSta() As Integer  'Returns the current stamina bonus value..
Declare Sub SetBonSta(amt As Integer)  'Sets the current stamina bonus value.
Declare Function GetBonStaCnt() As Integer  'Returns the current stamina bonus value..
Declare Sub SetBonStaCnt(amt As Integer)  'Sets the current stamina bonus value.
Declare Function GetCurrDex() As Integer 'Returns the current dexterity value.
Declare Sub SetCurrDex(amt As Integer) 'Sets the current dexterity value. 
Declare Function GetBonDex() As Integer  'Returns the current dexterity bonus value..
Declare Sub SetBonDex(amt As Integer)  'Sets the current dexterity bonus value.
Declare Function GetBonDexCnt() As Integer  'Returns the current dexterity bonus value..
Declare Sub SetBonDexCnt(amt As Integer)  'Sets the current dexterity bonus value.
Declare Function GetCurrAgl() As Integer 'Returns the current agility value.
Declare Sub SetCurrAgl(amt As Integer) 'Sets the current agility value. 
Declare Function GetBonAgl() As Integer  'Returns the current agility bonus value..
Declare Sub SetBonAgl(amt As Integer)  'Sets the current agility bonus value.
Declare Function GetBonAglCnt() As Integer  'Returns the current agility bonus value..
Declare Sub SetBonAglCnt(amt As Integer)  'Sets the current agility bonus value.
Declare Function GetCurrInt() As Integer 'Returns the current intelligence value.
Declare Sub SetCurrInt(amt As Integer) 'Sets the current intelligence value. 
Declare Function GetBonInt() As Integer  'Returns the current intelligence bonus value..
Declare Sub SetBonInt(amt As Integer)  'Sets the current intelligence bonus value.
Declare Function GetBonIntCnt() As Integer  'Returns the current intelligence bonus value..
Declare Sub SetBonIntCnt(amt As Integer)  'Sets the current intelligence bonus value.
Declare Function GetCurrUcf() As Integer 'Returns the current unarmed combat value.
Declare Function GetBonUcf() As Integer  'Returns the current unarmed combat bonus value..
Declare Sub SetBonUcf(amt As Integer)  'Sets the current unarmed combat bonus value.
Declare Function GetBonUcfCnt() As Integer  'Returns the current unarmed combat bonus value..
Declare Sub SetBonUcfCnt(amt As Integer)  'Sets the current unarmed combat bonus value.
Declare Function SetCurrAcf() As Integer 'Returns the current armed combat value.
Declare Function GetBonAcf() As Integer  'Returns the current armed combat bonus value..
Declare Sub SetBonAcf(amt As Integer)  'Sets the current armed combat bonus value.
Declare Function GetBonAcfCnt() As Integer  'Returns the current armed combat bonus value..
Declare Sub SetBonAcfCnt(amt As Integer)  'Sets the current armed combat bonus value.
Declare Function GetCurrPcf() As Integer 'Returns the current projectile combat value.
Declare Function GetBonPcf() As Integer  'Returns the current projctile combat bonus value..
Declare Sub SetBonPcf(amt As Integer)  'Sets the current projectile combat bonus value.
Declare Function GetBonPcfCnt() As Integer  'Returns the current projctile combat bonus value..
Declare Sub SetBonPcfCnt(amt As Integer)  'Sets the current projectile combat bonus value.
Declare Function GetCurrMcf() As Integer 'Returns the current magic combat value.
Declare Function GetBonMcf() As Integer  'Returns the current magic combat bonus value..
Declare Sub SetBonMcf(amt As Integer)  'Sets the current magic combat bonus value.
Declare Function GetBonMcfCnt() As Integer  'Returns the current magic combat bonus value..
Declare Sub SetBonMcfCnt(amt As Integer)  'Sets the current magic combat bonus value.
Declare Function GetCurrCdf() As Integer 'Returns the current combat defense value.
Declare Function GetBonCdf() As Integer  'Returns the current combat defense bonus value..
Declare Sub SetBonCdf(amt As Integer)  'Sets the current combat defense bonus value.
Declare Function GetBonCdfCnt() As Integer  'Returns the current combat defense bonus value..
Declare Sub SetBonCdfCnt(amt As Integer)  'Sets the current combat defense bonus value.
Declare Function SetCurrMdf() As Integer 'Returns the current magic defense value.
Declare Function GetBonMdf() As Integer  'Returns the current magic defense bonus value..
Declare Sub SetBonMdf(amt As Integer)  'Sets the current magic defense bonus value.
Declare Function GetBonMdfCnt() As Integer  'Returns the current magic defense bonus value..
Declare Sub SetBonMdfCnt(amt As Integer)  'Sets the current magic defense bonus value.
Declare Function GetCurrXP() As Integer  'Returns the current xp points.
Declare Sub SetCurrXP(amt As Integer)  'Sets the current xp points.
Declare Function TotXP() As Integer 'Returns the total xp points.
Declare Function GetCurrGold() As Integer  'Returns the current gold amount.
Declare Sub SetCurrGold(amt As Integer)  'Sets the current gold amount.
Declare Function TotGold() As Integer  'Returns the total gold amount.
Declare Function LowInv() As Integer'Returns the low index of inv array.
Declare Function HighInv() As Integer'Returns the high index of inv array.
Declare Function GetPoisoned() As Integer  'Returns the poinsoned flag.
Declare Sub SetPoisoned(pcnt As Integer) 'Set the poisoned flag.
Declare Function GetPoisonStr() As Integer  'Returns the poinsoned flag.
Declare Sub SetPoisonStr(pamt As Integer) 'Set the poisoned flag.
Declare Function LowISpell() As Integer'Returns the low index of spell array.
Declare Function HighISpell() As Integer'Returns the high index of spell array.
Declare Function BlinkActive() As Integer 'Returns TRUE if blink is active.
Declare Sub SetHasAmulet(fnd As Integer)  'Sets the state of hasam flag.
Declare Function GetHasAmulet() As Integer'Returns state of hasam flag.
Declare Sub PrintStats ()  'Prints out stats for character.
Declare Sub AddInvItem(idx As Integer, inv As invtype) 'Adds inventory item to character inventory slot.
Declare Sub GetInventoryItem(idx As Integer, inv As invtype) 'Gets an item from an inventory slot.
Declare Sub ChangeStrength(change As Integer, docurrhp As Integer = FALSE) 'Changes attribute and updates associated stats. 
Declare Sub ChangeStamina(change As Integer, docurrhp As Integer = FALSE) 'Changes attribute and updates associated stats. 
Declare Sub ChangeDexterity(change As Integer) 'Changes attribute and updates associated stats. 
Declare Sub ChangeAgility(change As Integer) 'Changes attribute and updates associated stats. 
Declare Sub ChangeIntelligence(change As Integer) 'Changes attribute and updates associated stats.
Declare Sub DecrementAmmo(slot As wieldpos) 'Decrements the ammo in held weapon.
Declare Sub DoTimedEvents() 'Manages any timed events.
Declare Sub SetSpellEffect(splid As cspleffects, scnt As Integer, samt As Integer) 'Sets the spell effect.
Declare Sub ApplyTrap(tdr As Integer, tdam As Integer, tdamtype As weapdamtype, tdesc As String) 'Applies trap damage.
Declare Sub GetCharacterData(cd As characterinfo) 'Gets the character data.
Declare Sub SetCharacterData(cd As characterinfo) 'Sets the character data.
Declare Function ApplyInvItem(inv As invtype) As String 'Applies the inv type to the character. 
Declare Function HasInvItem(idx As Integer) As Integer 'Returns True if item exists in inventory slot.
Declare Function GetFreeInventoryIndex() As Integer 'Returns free inventory slot index or -1.
Declare Function GenerateCharacter() As Integer 'Generates a new character.
Declare Function CanWear(inv As invtype) As Integer 'Returns True if character can wear item.
Declare Function GetNoise() As Integer 'Returns the current noise amount.
Declare Function GetMeleeCombatFactor() As Integer 'Returns the current combat factor.
Declare Function GetJewleryEffect(effect As jeffects, baseamt As Integer) As Integer 'Returns the jewelry effect if any.
Declare Function GetWeaponDamage(wslot As wieldpos = wAny) As Integer 'Returns the amount of weapon damage.
Declare Function GetDefenseFactor () As Integer 'Returns the character defense factor.
Declare Function GetMagicDefenseFactor () As Integer
Declare Function GetArmorValue(wp As weapdamtype = wdNone) As Single 'Returns the current armor value.
Declare Function GetShieldArmorValue (wp As weapdamtype = wdNone) As Single 'Returns shield armor value.
Declare Function ProjectileEquipped(slot As wieldpos) As Integer 'Returns True if character has pojectile weapon equipped.
Declare Function IsLoaded(slot As wieldpos) As Integer 'Returns true if projectile weapon isn slot has ammo.
Declare Function GetAmmoID(slot As wieldpos) As ammoids 'Returns the id for weapon in slot. 
Declare Function LoadProjectile(aid As ammoids, slot As wieldpos) As Integer 'Returns True if weapon was loaded.
Declare Function GetProjectileCombatFactor() As Integer 'Returns projectile combat factor.
Declare Function GetMagicCombatFactor() As Integer 'Returns magic combat factor.
Declare Function GetMagicDefense() As Integer 'Returns magic defense.
Declare Function ProjectileIsWand(slot As wieldpos) As Integer 'Returns state of idwand flag.
Declare Function IsLocation(x As Integer, y As Integer) As Integer 'Returns True if x and y are at char's location.
Declare Function GetItemSpellW (wslot As wieldpos) As spelltype 'Returns spell info.
Declare Function GetItemSpellI (inv As invtype) As spelltype 'Returns spell info.
Declare Function GetCSpellName(idx As Integer, ByRef lvl As Integer) As String 'Returns the spell short name if any.
Declare Function GetFreeSlot(inv As invtype, msg As String) As wieldpos 'Returns an empty weapon slot.
Declare Function GetLearnedSpell(idx As Integer) As spelltype 'Returns the spell at index.
