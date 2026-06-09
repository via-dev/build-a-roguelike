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
   Declare Function HasInvItem(idx As Integer) As Integer 'Returns True if item exists in inventory slot.
   Declare Function GetFreeInventoryIndex() As Integer 'Returns free inventory slot index or -1.
   Declare Function GenerateCharacter() As Integer 'Generates a new character.
   Declare Function CanWear(inv As invtype) As Integer 'Returns True if character can wear item.
End Type

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
   sinfo = "Strength:     " & _cinfo.stratt(0)
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "Stamina:      " & _cinfo.staatt(0)
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "Dexterity:    " & _cinfo.dexatt(0)
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "Agility:      " & _cinfo.aglatt(0)
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "Intelligence: " & _cinfo.intatt(0)
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "Hit Points:   " & _cinfo.currhp
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
   'Check st see if the items in a help item.
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
   'Add cloth armor to character.
   inv.classid = clArmor
   GenerateArmor inv, 1, armCloth
   SetInvEval inv, TRUE
   AddInvItem wArmor, inv
   'Add daggar to character
   
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

'Set up our character variable.
Dim Shared pchar As character

