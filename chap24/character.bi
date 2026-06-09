/'****************************************************************************
*
* Name: character.bi
*
* Synopsis: Character related routines for DOD.
*
* Description: This file contains the character generation and management
*              routines used in the program. 
*              
*
* Copyright 2010, Richard D. Clark
*
*                          The Wide Open License (WOL)
*
* Permission to use, copy, modify, distribute and sell this software and its
* documentation for any purpose is hereby granted without fee, provided that
* the above copyright notice and this license appear in all source copies. 
* THIS SOFTWARE IS PROVIDED "AS IS" WITHOUT EXPRESS OR IMPLIED WARRANTY OF
* ANY KIND. See http://www.dspguru.com/wol.htm for more information.
*
*****************************************************************************'/
'Character screen background.
#Include "charback.bi"

'Character attribute type def.
Type characterinfo
   cname As String * 35 'Name of character.
   stratt(3) As Integer 'Strength attribute (0), str bonus (1), bonus length in turns(2)
   staatt(3) As Integer 'Stamina  
   dexatt(3) As Integer 'Dexterity 
   aglatt(3) As Integer 'Agility 
   intatt(3) As Integer 'Intelligence 
   currhp As Integer    'Current HP
   maxhp As Integer     'Max HP
   currmana As Integer  'Current mana
   maxmana As Integer   'Max mana
   ucfsk(3) As Integer  'Unarmed combat skill
   acfsk(3) As Integer  'Armed combat skill
   pcfsk(3) As Integer  'Projectile combat skill
   mcfsk(3) As Integer  'Magic combat skill 
   cdfsk(3) As Integer  'Combat defense skill
   mdfsk(3) As Integer  'Magic defense skill 
   currxp As Integer    'Current spendable XP amount.
   totxp As Integer     'Lifetime XP amount.
   currgold As Integer  'Current gold amount.
   totgold As Integer   'Lifetime gold amount.
   ploc As mcoord       'Character current x and y location.
   cinv(97 To 122) As invtype 'Character inventory-using ascii codes for index values.
   cwield(wPrimary To wRingLt) As invtype 'Active items: 1 = primary weapon, 2 = secondary weapon/shield, 3 = armor, 4 = necklace, 5 = ring rt, 6 = rint lt 
   isPoisoned As Integer  'The Poisoned flag. True = character is poisoned.
   PoisonStr As Integer   'The strength of the poison. Poison is accumlative.
End Type

'Character object.
Type character
   Private:
   _cinfo As characterinfo
   Declare Function _GetBestArmor() As armorids 'Returns the best armor based on strength.
   Public:
   Declare Property CharName() As String    'Character name. 
   Declare Property Locx(xx As Integer)     'Sets X coord of character.
   Declare Property Locx() As Integer       'Returns the X coord of character.
   Declare Property Locy(xx As Integer)     'Sets X coord of character.
   Declare Property Locy() As Integer       'Returns the X coord of character.
   Declare Property CurrHP(hp As Integer)   'Sets the hp.
   Declare Property CurrHP() As Integer     'Returns the current HP.
   Declare Property MaxHP() As Integer      'Returns the current HP.
   Declare Property CurrMana(hp As Integer) 'Sets the mana.
   Declare Property CurrMana() As Integer   'Returns the current mana.
   Declare Property MaxMana() As Integer    'Returns the current mana.
   Declare Property CurrStr() As Integer    'Returns the current strength value.
   Declare Property CurrStr(amt As Integer) 'Sets the current strength value. 
   Declare Property BonStr() As Integer     'Returns the current strength bonus value..
   Declare Property BonStr(amt As Integer)  'Sets the current strength bonus value.
   Declare Property BonStrCnt() As Integer     'Returns the current strength bonus value..
   Declare Property BonStrCnt(amt As Integer)  'Sets the current strength bonus value.
   Declare Property CurrSta() As Integer    'Returns the current stamina value.
   Declare Property CurrSta(amt As Integer) 'Sets the current stamina value. 
   Declare Property BonSta() As Integer     'Returns the current stamina bonus value..
   Declare Property BonSta(amt As Integer)  'Sets the current stamina bonus value.
   Declare Property CurrDex() As Integer    'Returns the current dexterity value.
   Declare Property CurrDex(amt As Integer) 'Sets the current dexterity value. 
   Declare Property BonDex() As Integer     'Returns the current dexterity bonus value..
   Declare Property BonDex(amt As Integer)  'Sets the current dexterity bonus value.
   Declare Property CurrAgl() As Integer    'Returns the current agility value.
   Declare Property CurrAgl(amt As Integer) 'Sets the current agility value. 
   Declare Property BonAgl() As Integer     'Returns the current agility bonus value..
   Declare Property BonAgl(amt As Integer)  'Sets the current agility bonus value.
   Declare Property CurrInt() As Integer    'Returns the current intelligence value.
   Declare Property CurrInt(amt As Integer) 'Sets the current intelligence value. 
   Declare Property BonInt() As Integer     'Returns the current intelligence bonus value..
   Declare Property BonInt(amt As Integer)  'Sets the current intelligence bonus value.
   Declare Property CurrUcf() As Integer    'Returns the current unarmed combat value.
   Declare Property BonUcf() As Integer     'Returns the current unarmed combat bonus value..
   Declare Property BonUcf(amt As Integer)  'Sets the current unarmed combat bonus value.
   Declare Property CurrAcf() As Integer    'Returns the current armed combat value.
   Declare Property BonAcf() As Integer     'Returns the current armed combat bonus value..
   Declare Property BonAcf(amt As Integer)  'Sets the current armed combat bonus value.
   Declare Property CurrPcf() As Integer    'Returns the current projectile combat value.
   Declare Property BonPcf() As Integer     'Returns the current projctile combat bonus value..
   Declare Property BonPcf(amt As Integer)  'Sets the current projectile combat bonus value.
   Declare Property CurrMcf() As Integer    'Returns the current magic combat value.
   Declare Property BonMcf() As Integer     'Returns the current magic combat bonus value..
   Declare Property BonMcf(amt As Integer)  'Sets the current magic combat bonus value.
   Declare Property CurrCdf() As Integer    'Returns the current combat defense value.
   Declare Property BonCdf() As Integer     'Returns the current combat defense bonus value..
   Declare Property BonCdf(amt As Integer)  'Sets the current combat defense bonus value.
   Declare Property CurrMdf() As Integer    'Returns the current magic defense value.
   Declare Property BonMdf() As Integer     'Returns the current magic defense bonus value..
   Declare Property BonMdf(amt As Integer)  'Sets the current magic defense bonus value.
   Declare Property CurrXP() As Integer     'Returns the current xp points.
   Declare Property CurrXP(amt As Integer)  'Sets the current xp points.
   Declare Property TotXP() As Integer      'Returns the total xp points.
   Declare Property TotXP(amt As Integer)   'Sets the total total points.
   Declare Property CurrGold() As Integer     'Returns the current gold amount.
   Declare Property CurrGold(amt As Integer)  'Sets the current gold amount.
   Declare Property TotGold() As Integer     'Returns the total gold amount.
   Declare Property TotGold(amt As Integer)  'Sets the total gold amount.
   Declare Property LowInv() As Integer      'Returns the low index of inv array.
   Declare Property HighInv() As Integer      'Returns the high index of inv array.
   Declare Property Poisoned() As Integer     'Returns the poinsoned flag.
   Declare Property Poisoned(flag As Integer) 'Set the poisoned flag.
   Declare Property PoisonStr() As Integer     'Returns the poinsoned flag.
   Declare Property PoisonStr(amt As Integer) 'Set the poisoned flag.
   Declare Sub PrintStats ()                 'Prints out stats for character.
   Declare Sub AddInvItem(idx As Integer, inv As invtype) 'Adds inventory item to character inventory slot.
   Declare Sub GetInventoryItem(idx As Integer, inv As invtype) 'Gets an item from an inventory slot.
   Declare Sub DoTimedActions ()               'Goes through character and decrements bonus counts, etc.
   Declare Sub ImproveStrength(increase As Integer) 'Improves attribute and updates associated stats. 
   Declare Sub ImproveStamina(increase As Integer) 'Improves attribute and updates associated stats. 
   Declare Sub ImproveDexterity(increase As Integer) 'Improves attribute and updates associated stats. 
   Declare Sub ImproveAgility(increase As Integer) 'Improves attribute and updates associated stats. 
   Declare Sub ImproveIntelligence(increase As Integer) 'Improves attribute and updates associated stats.
   Declare Sub DecrementAmmo(slot As wieldpos) 'Decrements the ammo in held weapon. 
   Declare Function HasInvItem(idx As Integer) As Integer 'Returns True if item exists in inventory slot.
   Declare Function GetFreeInventoryIndex() As Integer 'Returns free inventory slot index or -1.
   Declare Function GenerateCharacter() As Integer 'Generates a new character.
   Declare Function CanWear(inv As invtype) As Integer 'Returns True if character can wear item.
   Declare Function GetNoise() As Integer 'Returns the current noise amount.
   Declare Function GetMeleeCombatFactor() As Integer 'Returns the current combat factor.
   Declare Function GetWeaponDamage(wslot As wieldpos = wAny) As Integer 'Returns the amount of weapon damage.
   Declare Function GetDefenseFactor () As Integer 'Returns the character defense factor.
   Declare Function GetArmorValue() As Single 'Returns the current armor value.
   Declare Function GetShieldArmorValue () As Single 'Returns shield armor value.
   Declare Function ProjectileEquipped(slot As wieldpos) As Integer 'Returns True if character has pojectile weapon equipped.
   Declare Function IsLoaded(slot As wieldpos) As Integer 'Returns true if projectile weapon isn slot has ammo.
   Declare Function GetAmmoID(slot As wieldpos) As ammoids 'Returns the id for weapon in slot. 
   Declare Function LoadProjectile(aid As ammoids, slot As wieldpos) As Integer 'Returns True if weapon was loaded.
   Declare Function GetProjectileCombatFactor() As Integer 'Returns projectile combat factor.
   Declare Function GetMagicCombatFactor() As Integer 'Returns magic combat factor.
   Declare Function ProjectileIsWand(slot As wieldpos) As Integer 'Returns state of idwand flag.
End Type

'Returns the best armor based on strength.
Function character._GetBestArmor() As armorids
   Dim As armorids ret = armArmorNone

   If _cinfo.stratt(0) >= strPlate Then
      ret = armPlate
   ElseIf _cinfo.stratt(0) >= strScale Then
      ret = armScale
   ElseIf _cinfo.stratt(0) >= strChain Then
      ret = armChain   
   ElseIf _cinfo.stratt(0) >= strBrigantine Then
      ret = armBrigantine   
   ElseIf _cinfo.stratt(0) >= strRing Then
      ret = armRing
   ElseIf _cinfo.stratt(0) >= strCuirboli Then
      ret = armCuirboli
   ElseIf _cinfo.stratt(0) >= strLeather Then
      ret = armLeather   
   ElseIf _cinfo.stratt(0) >= strCloth Then
      ret = armCloth
   EndIf
   
   Return ret
End Function

'Returns the character name.
Property character.CharName() As String
   Return _cinfo.cname
End Property

'Sets X coord of character.
Property character.Locx(xx As Integer)
   _cinfo.ploc.x = xx
End Property

'Returns the x coord of the character.
Property character.Locx() As Integer
   Return _cinfo.ploc.x
End Property

'Sets X coord of character.     
Property character.Locy(yy As Integer)
   _cinfo.ploc.y = yy
End Property

'Returns the X coord of character.
Property character.Locy() As Integer
   Return _cinfo.ploc.y
End Property

'Sets the hp.
Property character.CurrHP(hp As Integer)
   _cinfo.currhp = hp
End Property

'Returns the current HP.
Property character.CurrHP() As Integer
   Return _cinfo.currhp
End Property

'Returns the max HP.
Property character.MaxHP() As Integer
   Return _cinfo.maxhp
End Property

'Sets the mana.
Property character.CurrMana(mana As Integer)
   _cinfo.currmana = mana
End Property

'Returns the current mana.
Property character.CurrMana() As Integer
   Return _cinfo.currmana
End Property

'Returns the max mana.
Property character.MaxMana() As Integer
   Return _cinfo.maxmana
End Property

'Returns the current strength value.
Property character.CurrStr() As Integer    
   Return _cinfo.stratt(0)
End Property

'Sets the current strength value.
Property character.CurrStr(amt As Integer) 
   _cinfo.stratt(0) = amt
End Property

'Returns the current strength bonus value..
Property character.BonStr() As Integer     
   Return _cinfo.stratt(1)
End Property

'Sets the current strength bonus value. Any new value replaces the old value.
Property character.BonStr(amt As Integer)  
   _cinfo.stratt(1) = amt
End Property

'Sets the bonus count amount.
property character.BonStrCnt() As Integer
   Return _cinfo.stratt(2)
End Property

'Returns the bonus count amount.
Property character.BonStrCnt(amt As Integer)  
   _cinfo.stratt(2) = amt
End Property

'Returns the current stamina value.
Property character.CurrSta() As Integer    
   Return _cinfo.staatt(0)
End Property

'Sets the current stamina value.
Property character.CurrSta(amt As Integer) 
   _cinfo.staatt(0) = amt
End Property

'Returns the current stamina bonus value..
Property character.BonSta() As Integer     
   Return _cinfo.staatt(1)
End Property

'Sets the current stamina bonus value.
Property character.BonSta(amt As Integer)  
   _cinfo.staatt(1) = amt
End Property

'Returns the current dexterity value.
Property character.CurrDex() As Integer    
   Return _cinfo.dexatt(0)
End Property

'Sets the current dexterity value.
Property character.CurrDex(amt As Integer) 
   _cinfo.dexatt(0) = amt
End Property

'Returns the current dexterity bonus value..
Property character.BonDex() As Integer     
   Return _cinfo.dexatt(1)
End Property

'Sets the current dexterity bonus value.
Property character.BonDex(amt As Integer)  
   _cinfo.dexatt(1) = amt
End Property

'Returns the current agility value.
Property character.CurrAgl() As Integer    
   Return _cinfo.aglatt(0)
End Property

'Sets the current agility value.
Property character.CurrAgl(amt As Integer) 
   _cinfo.aglatt(0) = amt
End Property

'Returns the current agility bonus value..
Property character.BonAgl() As Integer     
   Return _cinfo.aglatt(1)
End Property

'Sets the current agility bonus value.
Property character.BonAgl(amt As Integer)  
   _cinfo.aglatt(1) = amt
End Property

'Returns the current intelligence value.
Property character.CurrInt() As Integer    
   Return _cinfo.intatt(0)
End Property

'Sets the current intelligence value.
Property character.CurrInt(amt As Integer) 
   _cinfo.intatt(0) = amt
End Property

'Returns the current intelligence bonus value..
Property character.BonInt() As Integer     
   Return _cinfo.intatt(1)
End Property

'Sets the current intelligence bonus value.
Property character.BonInt(amt As Integer)  
   _cinfo.intatt(1) = amt
End Property

'Returns the current unarmed combat value.
Property character.CurrUcf() As Integer    
   Return _cinfo.ucfsk(0)
End Property

'Returns the current unarmed bonus value..
Property character.BonUcf() As Integer     
   Return _cinfo.ucfsk(1)
End Property

'Sets the current unarmed bonus value.
Property character.BonUcf(amt As Integer)  
   _cinfo.ucfsk(1) = amt
End Property

'Returns the current armed combat value.
Property character.CurrAcf() As Integer    
   Return _cinfo.acfsk(0)
End Property

'Returns the current armed bonus value..
Property character.BonAcf() As Integer     
   Return _cinfo.acfsk(1)
End Property

'Sets the current armed bonus value.
Property character.BonAcf(amt As Integer)  
   _cinfo.acfsk(1) = amt
End Property

'Returns the current projectile combat value.
Property character.CurrPcf() As Integer    
   Return _cinfo.pcfsk(0)
End Property

'Returns the current projectile bonus value..
Property character.BonPcf() As Integer     
   Return _cinfo.pcfsk(1)
End Property

'Sets the current projectile bonus value.
Property character.BonPcf(amt As Integer)  
   _cinfo.pcfsk(1) = amt
End Property

'Returns the current magic combat value.
Property character.CurrMcf() As Integer    
   Return _cinfo.mcfsk(0)
End Property

'Returns the current magic bonus value..
Property character.BonMcf() As Integer     
   Return _cinfo.mcfsk(1)
End Property

'Sets the current magic bonus value.
Property character.BonMcf(amt As Integer)  
   _cinfo.mcfsk(1) = amt
End Property

'Returns the current combat defense value.
Property character.CurrCdf() As Integer    
   Return _cinfo.cdfsk(0)
End Property

'Returns the current combat defense bonus value..
Property character.BonCdf() As Integer     
   Return _cinfo.cdfsk(1)
End Property

'Sets the current combat defense bonus value.
Property character.BonCdf(amt As Integer)  
   _cinfo.cdfsk(1) = amt
End Property

'Returns the current magic defense value.
Property character.CurrMdf() As Integer    
   Return _cinfo.Mdfsk(0)
End Property

'Returns the current magic defense bonus value..
Property character.BonMdf() As Integer     
   Return _cinfo.mdfsk(1)
End Property

'Sets the current magic defense bonus value.
Property character.BonMdf(amt As Integer)  
   _cinfo.mdfsk(1) = amt
End Property

'Returns the current xp points.
Property character.CurrXP() As Integer
   Return _cinfo.currxp
End Property

'Sets the current xp points.
Property character.CurrXP(amt As Integer)
   _cinfo.currxp = amt
End Property

'Returns the total xp points.
Property character.TotXP() As Integer
   Return _cinfo.totxp
End Property

'Sets the total xp points.
Property character.TotXP(amt As Integer)
   _cinfo.totxp = amt
End Property

'Returns the current gold amount.
Property character.CurrGold() As Integer
   Return _cinfo.currgold
End Property

'Sets the current gold amount.
Property character.CurrGold(amt As Integer)
   _cinfo.currgold = amt
End Property

'Returns the max total gold amount.
Property character.TotGold() As Integer
   Return _cinfo.totgold
End Property

'Sets the total gold amount.
Property character.TotGold(amt As Integer)
   _cinfo.totgold = amt
End Property

'Returns the low index of inv array.
Property character.LowInv() As Integer
   Return LBound(_cinfo.cinv)
End Property

'Returns the high index of inv array.
Property character.HighInv() As Integer
   Return UBound(_cinfo.cinv)
End Property

'Returns the poison flag.
Property character.Poisoned() As Integer
   Return _cinfo.IsPoisoned
End Property

'Set the poisoned flag.
Property character.Poisoned(flag As Integer)
   _cinfo.IsPoisoned = flag
End Property

'Returns the strength of the poison..
Property character.PoisonStr() As Integer
   Return _cinfo.PoisonStr
End Property

'Sets the poisoned strength.
Property character.PoisonStr(amt As Integer)
   _cinfo.PoisonStr = amt
End Property

'Prints out the current stats for character.
Sub character.PrintStats ()
   Dim As Integer tx, ty, row = 8
   Dim As String sinfo
   
   ScreenLock
   'Draw the background.
   DrawBackground charback()
   'Draw the title.
   sinfo = Trim(_cinfo.cname) & " Attributes and Skills" 
   ty = row * charh
   tx = (CenterX(sinfo)) * charw
   DrawStringShadow tx, ty, sinfo, fbYellowBright
   'Draw the attributes.
   row += 4
   ty = row * charh
   tx = 70
   sinfo = "1 Strength:     " & _cinfo.stratt(0)
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "2 Stamina:      " & _cinfo.staatt(0)
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "3 Dexterity:    " & _cinfo.dexatt(0)
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "4 Agility:      " & _cinfo.aglatt(0)
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "5 Intelligence: " & _cinfo.intatt(0)
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "Max Hit Points:   " & _cinfo.maxhp
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "Max Mana Points:   " & _cinfo.maxmana
   DrawStringShadow tx, ty, sinfo
   row += 3
   ty = row * charh
   sinfo = "Unarmed Combat:    " & _cinfo.ucfsk(0)
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "Armed Combat:      " & _cinfo.acfsk(0)
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "Projectile Combat: " & _cinfo.pcfsk(0)
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "Magic Combat:      " & _cinfo.mcfsk(0)
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "Combat Defense:    " & _cinfo.cdfsk(0)
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "Magic Defense:     " & _cinfo.mdfsk(0)
   DrawStringShadow tx, ty, sinfo
   row += 3
   ty = row * charh
   sinfo = "Experience: " & _cinfo.currxp
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "Gold:       " & _cinfo.currgold
   DrawStringShadow tx, ty, sinfo

   ScreenUnLock
End Sub

'Adds inventory item to character inventory slot.
Sub character.AddInvItem(idx As Integer, inv As invtype)
   'Check to see if the index is in bounds.
   If idx >= LBound(_cinfo.cwield) And idx <= UBound(_cinfo.cwield) Then
      'Clear the inventory slot.
      ClearInv _cinfo.cwield(idx)
      'Set the item in the inv slot.
      _cinfo.cwield(idx) = inv
   Else
      'Validate the inventory index.
      If idx >= LBound(_cinfo.cinv) And idx <= UBound(_cinfo.cinv) Then
         'Clear the inventory slot.
         ClearInv _cinfo.cinv(idx)
         'Set the item in the inv slot.
         _cinfo.cinv(idx) = inv
      End If   
   EndIf
End Sub

'Gets an item from an inventory slot.
Sub character.GetInventoryItem(idx As Integer, inv As invtype)
   
   'Clear the inv item.
   ClearInv inv
   'Check st see if the items in a help item.
   If idx >= LBound(_cinfo.cwield) And idx <= UBound(_cinfo.cwield) Then
      'Set the item in the inv slot.
      inv = _cinfo.cwield(idx)
   Else
      'Validate the index.
      If idx >= LBound(_cinfo.cinv) And idx <= UBound(_cinfo.cinv) Then
         inv = _cinfo.cinv(idx)
      End If
   End If
End Sub

'Goes through all bonus settings and adjusts counts, applies poison, etc.
Sub character.DoTimedActions ()
   Dim As Integer roll1, roll2, v1, v2
   
   'Poison will affect character based on strength of poison.
   If _cinfo.IsPoisoned = TRUE Then
      'Get the strength of the poison.
      v1 = _cinfo.PoisonStr
      'Get character stamina + bonus
      v2 = _cinfo.staatt(0) + _cinfo.staatt(1)
      'Roll for the poison.
      roll1 = RandomRange(1, v1)
      roll2 = RandomRange(1, v2)
      'Poison won.
      If roll1 > roll2 Then
         'Take one off the health.
         _cinfo.currhp = _cinfo.currhp - 1 
      EndIf
   EndIf
   'Check the counts
   If _cinfo.stratt(2) > 0 Then
      'Dec the count.
      _cinfo.stratt(2) -= 1
      If _cinfo.stratt(2) <= 0 Then
         'Reset bnous amt.
         _cinfo.stratt(1) = 0
      EndIf
   EndIf
   
   If _cinfo.staatt(2) > 0 Then
      _cinfo.staatt(2) -= 1
      If _cinfo.staatt(2) <= 0 Then
         _cinfo.staatt(1) = 0
      End If
   EndIf

   If _cinfo.dexatt(2) > 0 Then
      _cinfo.dexatt(2) -= 1
      If _cinfo.dexatt(2) <= 0 Then
         _cinfo.dexatt(1) = 0
      End If
   EndIf

   If _cinfo.aglatt(2) > 0 Then
      _cinfo.aglatt(2) -= 1
      If _cinfo.aglatt(2) <= 0 Then
         _cinfo.aglatt(1) = 0
      End If
   EndIf

   If _cinfo.intatt(2) > 0 Then
      _cinfo.intatt(2) -= 1
      If _cinfo.intatt(2) <= 0 Then
         _cinfo.intatt(1) = 0
      End If
   EndIf

   If _cinfo.ucfsk(2) > 0 Then
      _cinfo.ucfsk(2) -= 1
      If _cinfo.ucfsk(2) <= 0 Then
         _cinfo.ucfsk(1) = 0
      End If
   EndIf

   If _cinfo.acfsk(2) > 0 Then
      _cinfo.acfsk(2) -= 1
      If _cinfo.acfsk(2) <= 0 Then
         _cinfo.acfsk(1) = 0
      End If
   EndIf

   If _cinfo.pcfsk(2) > 0 Then
      _cinfo.pcfsk(2) -= 1
      If _cinfo.pcfsk(2) <= 0 Then
         _cinfo.pcfsk(1) = 0
      End If
   EndIf

   If _cinfo.mcfsk(2) > 0 Then
      _cinfo.mcfsk(2) -= 1
      If _cinfo.mcfsk(2) <= 0 Then
         _cinfo.mcfsk(1) = 0
      End If
   EndIf

   If _cinfo.cdfsk(2) > 0 Then
      _cinfo.cdfsk(2) -= 1
      If _cinfo.cdfsk(2) <= 0 Then
         _cinfo.cdfsk(1) = 0
      End If
   EndIf

   If _cinfo.mdfsk(2) > 0 Then
      _cinfo.mdfsk(2) -= 1
      If _cinfo.mdfsk(2) <= 0 Then
         _cinfo.mdfsk(1) = 0
      End If
   EndIf
End Sub

'Improves attribute and updates associated stats.
Sub character.ImproveStrength(increase As Integer)
   'Make sure we have something to update.
   If increase > 0 Then
      'Update the attribute
      _cinfo.stratt(0) = _cinfo.stratt(0) + increase
      'Update the combat factor. 
      _cinfo.currhp = _cinfo.stratt(0) + _cinfo.staatt(0)
      _cinfo.maxhp = _cinfo.currhp 
      _cinfo.ucfsk(0) = _cinfo.stratt(0) + _cinfo.aglatt(0)
      _cinfo.acfsk(0) = _cinfo.stratt(0) + _cinfo.dexatt(0)
      _cinfo.cdfsk(0) = _cinfo.stratt(0) + _cinfo.aglatt(0)
   EndIf
End Sub

'Improves attribute and updates associated stats.
Sub character.ImproveStamina(increase As Integer)
   'Make sure we have something to update.
   If increase > 0 Then
      'Update the attribute
      _cinfo.staatt(0) = _cinfo.staatt(0) + increase
      'Update the combat factor. 
      _cinfo.currhp = _cinfo.stratt(0) + _cinfo.staatt(0)
      _cinfo.maxhp = _cinfo.currhp 
      _cinfo.currmana = _cinfo.intatt(0) + _cinfo.staatt(0) 
      _cinfo.maxmana = _cinfo.currmana
      _cinfo.mcfsk(0) = _cinfo.intatt(0) + _cinfo.staatt(0)
   EndIf
End Sub

'Improves attribute and updates associated stats.
Sub character.ImproveDexterity(increase As Integer)
   'Make sure we have something to update.
   If increase > 0 Then
      'Update the attribute
      _cinfo.dexatt(0) = _cinfo.dexatt(0) + increase
      'Update the combat factor. 
      _cinfo.acfsk(0) = _cinfo.stratt(0) + _cinfo.dexatt(0)
      _cinfo.pcfsk(0) = _cinfo.dexatt(0) + _cinfo.intatt(0)
   EndIf
End Sub

'Improves attribute and updates associated stats.
Sub character.ImproveAgility(increase As Integer)
   'Make sure we have something to update.
   If increase > 0 Then
      'Update the attribute
      _cinfo.aglatt(0) = _cinfo.aglatt(0) + increase
      'Update the combat factor. 
      _cinfo.ucfsk(0) = _cinfo.stratt(0) + _cinfo.aglatt(0)
      _cinfo.mdfsk(0) = _cinfo.aglatt(0) + _cinfo.intatt(0)
      _cinfo.cdfsk(0) = _cinfo.stratt(0) + _cinfo.aglatt(0)
   EndIf
End Sub

'Improves attribute and updates associated stats. 
Sub character.ImproveIntelligence(increase As Integer)
   'Make sure we have something to update.
   If increase > 0 Then
      'Update the attribute
      _cinfo.intatt(0) = _cinfo.intatt(0) + increase
      'Update the mana factor. 
      _cinfo.currmana = _cinfo.intatt(0) + _cinfo.staatt(0) 
      _cinfo.maxmana = _cinfo.currmana
      'Update the combat factors.
      _cinfo.pcfsk(0) = _cinfo.dexatt(0) + _cinfo.intatt(0)
      _cinfo.mcfsk(0) = _cinfo.intatt(0) + _cinfo.staatt(0)
      _cinfo.mdfsk(0) = _cinfo.aglatt(0) + _cinfo.intatt(0)
   EndIf
End Sub

'Decrements the ammo in held weapon.
Sub character.DecrementAmmo(slot As wieldpos)
   _cinfo.cwield(slot).weapon.ammocnt -= 1
   If _cinfo.cwield(slot).weapon.ammocnt < 0 Then 
      _cinfo.cwield(slot).weapon.ammocnt = 0
   EndIf
End Sub

'Returns True if item exists in inventory slot.
Function character.HasInvItem(idx As Integer) As Integer
   'Check held items.
   If idx >= LBound(_cinfo.cwield) And idx <= UBound(_cinfo.cwield) Then
      'Check the class id.
      If _cinfo.cwield(idx).classid = clNone Then
         Return FALSE
      Else
         Return TRUE
      EndIf
   Else
      'Validate the index.
      If idx >= LBound(_cinfo.cinv) And idx <= UBound(_cinfo.cinv) Then
         'Check the class id.
         If _cinfo.cinv(idx).classid = clNone Then
            Return FALSE
         Else
            Return TRUE
         EndIf
      Else
         Return FALSE
      End If   
   EndIf
   
End Function

'Generates a new character.
Function character.GenerateCharacter() As Integer
   Dim As String chname, prompt, skey
   Dim As Integer done = FALSE, ret = TRUE, tx, ty
   Dim As tWidgets.btnID btn
   Dim As tWidgets.tInputbox ib
   Dim inv As invtype
   Dim arm As armorids
   
   'Set up user input prompt.
   prompt = "Press <r> to roll again, <enter> to accept, <esc> to exit to menu."
   tx = CenterX(prompt)
   ty = (txrows - 6)
   ScreenLock   
   'Draw the background.
   DrawBackground charback()
   ScreenUnLock
   ib.Title = "Character Name"
   ib.Prompt = "Enter your character's name:"
   ib.MaxLen = 35
   ib.InputLen = 35
   'Get the name of the character.
   btn = ib.Inputbox(chname)
   If btn = tWidgets.btnID.gbnCancel Then
      ret = FALSE
   EndIf
   If btn = tWidgets.btnID.gbnOK Then
      ret = TRUE
   EndIf
   'Display character.
   If ret = TRUE Then
      'Generate the character data.
      Do
         With _cinfo
            .cname = chname
            .stratt(0) = RandomRange (10, 20) 'Generate new stat.
            .staatt(0) = RandomRange (10, 20)
            .dexatt(0) = RandomRange (10, 20)
            .aglatt(0) = RandomRange (10, 20)
            .intatt(0) = RandomRange (10, 20)
            .stratt(1) = 0                   'Clear any bonuses.
            .staatt(1) = 0
            .dexatt(1) = 0
            .aglatt(1) = 0
            .intatt(1) = 0
            .stratt(2) = 0                   'Clear counts.
            .staatt(2) = 0
            .dexatt(2) = 0
            .aglatt(2) = 0
            .intatt(2) = 0
            .currhp = .stratt(0) + .staatt(0) 
            .maxhp = .currhp
            .currmana = .intatt(0) + .staatt(0) 
            .maxmana = .currmana
            .ucfsk(0) = .stratt(0) + .aglatt(0) 
            .acfsk(0) = .stratt(0) + .dexatt(0) 
            .pcfsk(0) = .dexatt(0) + .intatt(0)
            .mcfsk(0) = .intatt(0) + .staatt(0)
            .cdfsk(0) = .stratt(0) + .aglatt(0)
            .mdfsk(0) = .aglatt(0) + .intatt(0)
            .ucfsk(1) = 0                       'Clear bonuses. 
            .acfsk(1) = 0 
            .pcfsk(1) = 0
            .mcfsk(1) = 0
            .cdfsk(1) = 0
            .mdfsk(1) = 0
            .ucfsk(2) = 0                       'Clear counts.. 
            .acfsk(2) = 0 
            .pcfsk(2) = 0
            .mcfsk(2) = 0
            .cdfsk(2) = 0
            .mdfsk(2) = 0
            .currxp = RandomRange (100, 200)
            .totxp = .currxp
            .currgold = RandomRange (50, 100)
            .totgold = .currgold
            .ploc.x = 0
            .ploc.y = 0
         End With
         'Print out the current character stats.
         PrintStats
         PutTextShadow prompt, ty, tx
         'Get the user command.
         Do
            'Get the key press.
            skey = Inkey
            'Fornat to lower case.
            skey = LCase(skey)
            'If escape exit back to menu.
            If skey = key_esc Then
               done = TRUE
               ret = FALSE
            EndIf
            'If enter continue with game.
            If skey = key_enter Then
               done = TRUE
            EndIf
            Sleep 10
         Loop Until (skey = "r") Or (skey = key_esc) Or (skey = key_enter)
      Loop Until done = TRUE
   End If
   'Add best armor.
   arm = _GetBestArmor
   GenerateArmor inv, 1, arm
   SetInvEval inv, TRUE
   AddInvItem wArmor, inv
   'Add short sword to character
   ClearInv inv
   GenerateWeapon inv, 1, wpShortsword
   SetInvEval inv, TRUE
   AddInvItem wPrimary, inv
   Return ret
End Function

'Returns free inventory slot index or -1.
Function character.GetFreeInventoryIndex() As Integer
   Dim As Integer ret = -1
   
   'Look for an empty inventory slot.
   For i As Integer = LBound(_cinfo.cinv) To UBound(_cinfo.cinv)
      'Examine class id.
      If _cinfo.cinv(i).classid = clNone Then
         'Empty slot.
         ret = i
         Exit For
      EndIf
   Next
   
   Return ret
End Function

'Returns True if character can wear item.
Function character.CanWear(inv As invtype) As Integer
   Dim As Integer ret = TRUE
   
   If inv.classid = clArmor Then
      If inv.armor.struse > _cinfo.stratt(0) Then
         ret = FALSE
      EndIf
   EndIf

   If inv.classid = clShield Then
      If inv.shield.struse > _cinfo.stratt(0) Then
         ret = FALSE
      EndIf
   EndIf
   
   Return ret
End Function

'Returns the current noise volume.
Function character.GetNoise() As Integer
   Dim As Integer ret = 0
   
   'Get gold amount.
   ret = _cinfo.currgold / 10
   'Get inventory amounts.
   For i As Integer = LBound(_cinfo.cinv) To UBound(_cinfo.cinv) 
      ret += GetItemNoise(_cinfo.cinv(i))
   Next
   'Get held amounts.
   For i As Integer = LBound(_cinfo.cwield) To UBound(_cinfo.cwield) 
      ret += GetItemNoise(_cinfo.cwield(i))
   Next
   
   Return ret
End Function

'Returns the current combat factor based on what the character is wielding.
Function character.GetMeleeCombatFactor() As Integer
   Dim As Integer ret
   
   'Unarmed combat.
   If (_cinfo.cwield(wPrimary).classid <> clWeapon) And (_cinfo.cwield(wSecondary).classid <> clWeapon) Then
      ret = CurrUcf + BonUcf
   Else
      'Check primary slot.
      If _cinfo.cwield(wPrimary).classid = clWeapon Then
         'Wielding a melee weapon.
         If _cinfo.cwield(wPrimary).weapon.weapontype <> wtProjectile Then
            ret = CurrAcf + BonAcf
         Else
          'Return UCF as projectile weapon isn't melee weapon.
           ret = CurrUcf + BonUcf
         EndIf
      Else
         If _cinfo.cwield(wSecondary).classid = clWeapon Then
            'Wielding a melee weapon.
            If _cinfo.cwield(wSecondary).weapon.weapontype <> wtProjectile Then
               ret = CurrAcf + BonAcf
            Else
               'Return UCF as projectile weapon isn't melee weapon.
               ret = CurrUcf + BonUcf
            End If
         EndIf
      End If
   EndIf

    Return ret     
End Function

'Return projectile combat factor.
Function character.GetProjectileCombatFactor() As Integer
   Return CurrPCF + BonPcf
End Function

'Return magic combat factor.
Function character.GetMagicCombatFactor() As Integer
   Return CurrMCF + BonMcf
End Function

'Returns the amount of weapon damage.
Function character.GetWeaponDamage(wslot As wieldpos = wAny) As Integer
   Dim As Integer ret = 0
   
   'See if we have any weapons.
   If (_cinfo.cwield(wPrimary).classid <> clWeapon) And (_cinfo.cwield(wSecondary).classid <> clWeapon) Then
      'If no weapon get the stength value plus bonus.
      ret = (_cinfo.stratt(0) + _cinfo.stratt(1)) / 2
   Else
      If wslot = wAny Then
         'Have one or more weapons.
         If _cinfo.cwield(wPrimary).classid = clWeapon Then
            'Get the current weapon damage.
            ret = _cinfo.cwield(wPrimary).weapon.dam
         EndIf
         If _cinfo.cwield(wSecondary).classid = clWeapon Then
            ret += _cinfo.cwield(wSecondary).weapon.dam
         EndIf
      Else
         ret = _cinfo.cwield(wSlot).weapon.dam
      End If
   EndIf
   
   Return ret
End Function

'Returns the character's defense factor.
Function character.GetDefenseFactor () As Integer
   Return currCdf + BonCdf
End Function

'Returns the current armor value.
Function character.GetArmorValue() As Single
   Dim As Single ret = 0.0
   
   'Check for armor.
   If _cinfo.cwield(wArmor).classid <> clNone Then
      ret = _cinfo.cwield(wArmor).armor.dampct 
   EndIf
   
   Return ret
End Function

'Returns any shield armor value.
Function character.GetShieldArmorValue () As Single
   Dim As Single ret = 0.0
   Dim As Integer cnt
      
   'Check for any shields.
   If _cinfo.cwield(wPrimary).classid = clShield Then
      ret += _cinfo.cwield(wPrimary).shield.dampct
      cnt = 1
   EndIf   
   If _cinfo.cwield(wSecondary).classid = clShield Then
      ret += _cinfo.cwield(wSecondary).shield.dampct
      cnt += 1
   EndIf
   
   'Get the average of the values if any.
   If cnt > 0 Then
      ret = ret / cnt
   EndIf
   
   Return ret
End Function

'Returns True if character has pojectile weapon equipped.
Function character.ProjectileEquipped(slot As wieldpos) As Integer 
   Dim As Integer ret = FALSE
   
   'Make sure the classid is a weapon.
   If _cinfo.cwield(wPrimary).classid = clWeapon Then
      'Make sure the weapon is a projectile.
      If _cinfo.cwield(wPrimary).weapon.weapontype = wtProjectile Then
         'Check the slot.
         If (slot = wAny) Or (slot = wPrimary) Then
            ret = TRUE
         End If
      EndIf
   Else
      'Make sure the classid is a weapon.
      If _cinfo.cwield(wSecondary).classid = clWeapon Then
         'Make sure the weapon is a projectile.
         If _cinfo.cwield(wSecondary).weapon.weapontype = wtProjectile Then
            'Check the slot.
            If (slot = wAny) Or (slot = wSecondary) Then
               ret = TRUE
            End If
         EndIf
      EndIf
   EndIf
   
   Return ret
End Function

'Returns true if projectile weapon in slot has ammo.
Function character.IsLoaded(slot As wieldpos) As Integer
   Dim As Integer ret = FALSE
   
   'Make sure we have a weapon.
   If _cinfo.cwield(slot).classid = clWeapon Then
      'Make sure it is a projectile.
      If _cinfo.cwield(slot).weapon.weapontype = wtProjectile Then
         'Check the loaded flag.
         ret = (_cinfo.cwield(slot).weapon.ammocnt > 0)
      EndIf
   EndIf
   
   Return ret
End Function

'Returns the ammoid for projectile weapon in slot.
Function character.GetAmmoID(slot As wieldpos) As ammoids
   Dim ret As armorids
   
   'Check to see if slot is holding a weapon.
   If _cinfo.cwield(slot).classid = clWeapon Then
      'Make sure it is projectile weapon.
      If _cinfo.cwield(slot).weapon.weapontype = wtProjectile Then
         ret = _cinfo.cwield(slot).weapon.ammotype
      Else
         ret = amNone
      EndIf
   Else
      ret = amNone
   EndIf
   Return ret
End Function

'Returns True if weapon was loaded.
Function character.LoadProjectile(aid As ammoids, slot As wieldpos) As Integer 
   Dim As Integer ret = FALSE, i, iitem
   Dim As invtype inv
   
   'Look through the inventory and see if we have any ammo matching ammo id.
   For i = LowInv To HighInv
      'If the weapon is full, then exit.
      If _cinfo.cwield(slot).weapon.ammocnt = _cinfo.cwield(slot).weapon.capacity Then
         Exit For
      EndIf
      iitem = HasInvItem(i)
      If iitem = TRUE Then
         'Get the inv item.
         GetInventoryItem i, inv
         'Check the class id.
         If inv.classid = clAmmo Then
            'See if it is the same ammo as passed id.
            If inv.ammo.id = aid Then
               'Load weapon to capacity.
               Do While _cinfo.cwield(slot).weapon.ammocnt < _cinfo.cwield(slot).weapon.capacity
                  'Load the weapon.
                  _cinfo.cwield(slot).weapon.ammocnt += 1
                  inv.ammo.cnt -= 1
                  'If no more ammo then exit.
                  If inv.ammo.cnt = 0 Then
                     Exit Do
                  EndIf
               Loop
               'Update the inventory.
               If inv.ammo.cnt > 0 Then
                  AddInvItem i,inv
               Else
                  ClearInv inv
                  AddInvItem i,inv
               EndIf
               'Does the weapon have ammo?
               If _cinfo.cwield(slot).weapon.ammocnt > 0 Then
                  ret = TRUE
               EndIf
            EndIf
         EndIf
      EndIf
   Next
   
   Return ret
End Function

'Returns state of idwand flag.
Function character.ProjectileIsWand(slot As wieldpos) As Integer
   Return _cinfo.cwield(slot).weapon.iswand
End Function


'Set up our character variable.
Dim Shared pchar As character


