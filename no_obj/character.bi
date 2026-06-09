/'****************************************************************************
*
* Name: bi
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
#Include "chardecs.bi"

'Returns the best armor based on strength.
Function GetBestArmor() As armorids
   Dim As armorids ret = armArmorNone

   If cinfo.stratt(idxAttr) >= strPlate Then
      ret = armPlate
   ElseIf cinfo.stratt(idxAttr) >= strScale Then
      ret = armScale
   ElseIf cinfo.stratt(idxAttr) >= strChain Then
      ret = armChain   
   ElseIf cinfo.stratt(idxAttr) >= strBrigantine Then
      ret = armBrigantine   
   ElseIf cinfo.stratt(idxAttr) >= strRing Then
      ret = armRing
   ElseIf cinfo.stratt(idxAttr) >= strCuirboli Then
      ret = armCuirboli
   ElseIf cinfo.stratt(idxAttr) >= strLeather Then
      ret = armLeather   
   ElseIf cinfo.stratt(idxAttr) >= strCloth Then
      ret = armCloth
   EndIf
   
   Return ret
End Function

'Returns the character name.
Function CharName() As String
   Return cinfo.cname
End Function

'Sets X coord of 
Sub SetLocx(xx As Integer)
   cinfo.ploc.x = xx
End Sub

'Returns the x coord of the 
Function GetLocx() As Integer
   Return cinfo.ploc.x
End Function

'Sets X coord of      
Sub SetLocy(yy As Integer)
   cinfo.ploc.y = yy
End Sub

'Returns the X coord of 
Function GetLocy() As Integer
   Return cinfo.ploc.y
End Function

'Sets the hp.
Sub SetCurrHP(hp As Integer)
   cinfo.currhp = hp
   If cinfo.currhp > cinfo.maxhp Then
      cinfo.currhp = cinfo.maxhp
   EndIf
End Sub

'Returns the current HP.
Function GetCurrHP() As Integer
   Return cinfo.currhp
End Function

'Returns the max HP.
Function GetMaxHP() As Integer
   Return cinfo.maxhp
End Function

'Sets the mana.
Sub SetCurrMana(mana As Integer)
   cinfo.currmana = mana
   If cinfo.currmana > cinfo.maxmana Then
      cinfo.currmana = cinfo.maxmana
   EndIf
End Sub

'Returns the current mana.
Function GetCurrMana() As Integer
   Return cinfo.currmana
End Function

'Returns the max mana.
Function MaxMana() As Integer
   Return cinfo.maxmana
End Function

'Returns the current strength value.
Function GetCurrStr() As Integer    
   Return cinfo.stratt(idxAttr)
End Function

'Sets the current strength value.
Sub SetCurrStr(amt As Integer) 
   cinfo.stratt(idxAttr) = amt
End Sub

'Returns the current strength bonus value..
Function GetBonStr() As Integer     
   Return cinfo.stratt(idxAttrBon)
End Function

'Sets the current strength bonus value. Any new value replaces the old value.
Sub SetBonStr(amt As Integer)  
   cinfo.stratt(idxAttrBon) = amt
End Sub

'Sets the bonus count amount.
Function GetBonStrCnt() As Integer
   Return cinfo.stratt(idxAttrCnt)
End Function

'Returns the bonus count amount.
Sub SetBonStrCnt(amt As Integer)  
   cinfo.stratt(idxAttrCnt) = amt
End Sub

'Returns the current stamina value.
Function GetCurrSta() As Integer    
   Return cinfo.staatt(idxAttr)
End Function

'Sets the current stamina value.
Sub SetCurrSta(amt As Integer) 
   cinfo.staatt(idxAttr) = amt
End Sub

'Returns the current stamina bonus value..
Function GetBonSta() As Integer     
   Return cinfo.staatt(idxAttrBon)
End Function

'Sets the current stamina bonus value.
Sub SetBonSta(amt As Integer)  
   cinfo.staatt(idxAttrBon) = amt
End Sub

'Returns the current stamina bonus value cnt.
Function GetBonStaCnt() As Integer     
   Return cinfo.staatt(idxAttrCnt)
End Function

'Sets the current stamina bonus value.
Sub SetBonStaCnt(amt As Integer)  
   cinfo.staatt(idxAttrCnt) = amt
End Sub

'Returns the current dexterity value.
Function GetCurrDex() As Integer    
   Return cinfo.dexatt(idxAttr)
End Function

'Sets the current dexterity value.
Sub SetCurrDex(amt As Integer) 
   cinfo.dexatt(idxAttr) = amt
End Sub

'Returns the current dexterity bonus value..
Function GetBonDex() As Integer     
   Return cinfo.dexatt(idxAttrBon)
End Function

'Sets the current dexterity bonus value.
Sub SetBonDex(amt As Integer)  
   cinfo.dexatt(idxAttrBon) = amt
End Sub

'Returns the current dexterity bonus value cnt.
Function GetBonDexCnt() As Integer     
   Return cinfo.dexatt(idxAttrCnt)
End Function

'Sets the current dexterity bonus value cnt.
Sub SetBonDexCnt(amt As Integer)  
   cinfo.dexatt(idxAttrCnt) = amt
End Sub

'Returns the current agility value.
Function GetCurrAgl() As Integer    
   Return cinfo.aglatt(idxAttr)
End Function

'Sets the current agility value.
Sub SetCurrAgl(amt As Integer) 
   cinfo.aglatt(idxAttr) = amt
End Sub

'Returns the current agility bonus value..
Function GetBonAgl() As Integer     
   Return cinfo.aglatt(idxAttrBon)
End Function

'Sets the current agility bonus value.
Sub SetBonAgl(amt As Integer)  
   cinfo.aglatt(idxAttrBon) = amt
End Sub

'Returns the current agility bonus value cnt.
Function GetBonAglCnt() As Integer     
   Return cinfo.aglatt(idxAttrCnt)
End Function

'Sets the current agility bonus value cnt.
Sub SetBonAglCnt(amt As Integer)  
   cinfo.aglatt(idxAttrCnt) = amt
End Sub

'Returns the current intelligence value.
Function GetCurrInt() As Integer    
   Return cinfo.intatt(idxAttr)
End Function

'Sets the current intelligence value.
Sub SetCurrInt(amt As Integer) 
   cinfo.intatt(idxAttr) = amt
End Sub

'Returns the current intelligence bonus value..
Function GetBonInt() As Integer     
   Return cinfo.intatt(idxAttrBon)
End Function

'Sets the current intelligence bonus value.
Sub SetBonInt(amt As Integer)  
   cinfo.intatt(idxAttrBon) = amt
   charint = cinfo.intatt(idxAttr) + cinfo.intatt(idxAttrBon)
End Sub

'Returns the current intelligence bonus value cnt.
Function GetBonIntCnt() As Integer     
   Return cinfo.intatt(idxAttrCnt)
End Function

'Sets the current intelligence bonus value cnt.
Sub SetBonIntCnt(amt As Integer)  
   cinfo.intatt(idxAttrCnt) = amt
End Sub

'Returns the current unarmed combat value.
Function GetCurrUcf() As Integer    
   Return cinfo.ucfsk(idxAttr)
End Function

'Returns the current unarmed bonus value..
Function GetBonUcf() As Integer     
   Return cinfo.ucfsk(idxAttrBon)
End Function

'Sets the current unarmed bonus value.
Sub SetBonUcf(amt As Integer)  
   cinfo.ucfsk(idxAttrBon) = amt
End Sub

'Returns the current unarmed bonus value cnt.
Function GetBonUcfCnt() As Integer     
   Return cinfo.ucfsk(idxAttrCnt)
End Function

'Sets the current unarmed bonus value cnt.
Sub SetBonUcfCnt(amt As Integer)  
   cinfo.ucfsk(idxAttrCnt) = amt
End Sub

'Returns the current armed combat value.
Function CurrAcf() As Integer    
   Return cinfo.acfsk(idxAttr)
End Function

'Returns the current armed bonus value.
Function GetBonAcf() As Integer     
   Return cinfo.acfsk(idxAttrBon)
End Function

'Sets the current armed bonus value.
Sub SetBonAcf(amt As Integer)  
   cinfo.acfsk(idxAttrBon) = amt
End Sub

'Returns the current armed bonus value cnt.
Function GetBonAcfCnt() As Integer     
   Return cinfo.acfsk(idxAttrCnt)
End Function

'Sets the current armed bonus value cnt.
Sub SetBonAcfCnt(amt As Integer)  
   cinfo.acfsk(idxAttrCnt) = amt
End Sub

'Returns the current projectile combat value.
Function GetCurrPcf() As Integer    
   Return cinfo.pcfsk(idxAttr)
End Function

'Returns the current projectile bonus value.
Function GetBonPcf() As Integer     
   Return cinfo.pcfsk(idxAttrBon)
End Function

'Sets the current projectile bonus value.
Sub SetBonPcf(amt As Integer)  
   cinfo.pcfsk(idxAttrBon) = amt
End Sub

'Returns the current projectile bonus value cnt.
Function GetBonPcfCnt() As Integer     
   Return cinfo.pcfsk(idxAttrCnt)
End Function

'Sets the current projectile bonus value.
Sub SetBonPcfCnt(amt As Integer)  
   cinfo.pcfsk(idxAttrCnt) = amt
End Sub

'Returns the current magic combat value.
Function GetCurrMcf() As Integer    
   Return cinfo.mcfsk(idxAttr)
End Function

'Returns the current magic bonus value.
Function GetBonMcf() As Integer     
   Return cinfo.mcfsk(idxAttrBon)
End Function

'Sets the current magic bonus value.
Sub SetBonMcf(amt As Integer)  
   cinfo.mcfsk(idxAttrBon) = amt
End Sub

'Returns the current magic bonus value cnt.
Function GetBonMcfCnt() As Integer     
   Return cinfo.mcfsk(idxAttrCnt)
End Function

'Sets the current magic bonus value cnt.
Sub SetBonMcfCnt(amt As Integer)  
   cinfo.mcfsk(idxAttrCnt) = amt
End Sub

'Returns the current combat defense value.
Function GetCurrCdf() As Integer    
   Return cinfo.cdfsk(idxAttr)
End Function

'Returns the current combat defense bonus value.
Function GetBonCdf() As Integer     
   Return cinfo.cdfsk(idxAttrBon)
End Function

'Sets the current combat defense bonus value.
Sub SetBonCdf(amt As Integer)  
   cinfo.cdfsk(idxAttrBon) = amt
End Sub

'Returns the current combat defense bonus value cnt.
Function GetBonCdfCnt() As Integer     
   Return cinfo.cdfsk(idxAttrCnt)
End Function

'Sets the current combat defense bonus value cnt.
Sub SetBonCdfCnt(amt As Integer)  
   cinfo.cdfsk(idxAttrCnt) = amt
End Sub

'Returns the current magic defense value.
Function CurrMdf() As Integer    
   Return cinfo.Mdfsk(idxAttr)
End Function

'Returns the current magic defense bonus value.
Function GetBonMdf() As Integer     
   Return cinfo.mdfsk(idxAttrBon)
End Function

'Sets the current magic defense bonus value.
Sub SetBonMdf(amt As Integer)  
   cinfo.mdfsk(idxAttrBon) = amt
End Sub

'Returns the current magic defense bonus value cnt.
Function GetBonMdfCnt() As Integer     
   Return cinfo.mdfsk(idxAttrCnt)
End Function

'Sets the current magic defense bonus value cnt.
Sub SetBonMdfCnt(amt As Integer)  
   cinfo.mdfsk(idxAttrCnt) = amt
End Sub

'Returns the current xp points.
Function GetCurrXP() As Integer
   Return cinfo.currxp
End Function

'Sets the current xp points.
Sub SetCurrXP(amt As Integer)
   cinfo.currxp = amt
   cinfo.totxp += amt
End Sub

'Returns the total xp points.
Function TotXP() As Integer
   Return cinfo.totxp
End Function

'Returns the current gold amount.
Function GetCurrGold() As Integer
   Return cinfo.currgold
End Function

'Sets the current gold amount.
Sub SetCurrGold(amt As Integer)
   cinfo.currgold = amt
   cinfo.totgold += amt
End Sub

'Returns the max total gold amount.
Function TotGold() As Integer
   Return cinfo.totgold
End Function

'Returns the low index of inv array.
Function LowInv() As Integer
   Return LBound(cinfo.cinv)
End Function

'Returns the high index of inv array.
Function HighInv() As Integer
   Return UBound(cinfo.cinv)
End Function

'Returns the poison flag.
Function GetPoisoned() As Integer
   Return (cinfo.cseffect(cPoison).cnt > 0)
End Function

'Set the poisoned flag.
Sub SetPoisoned(pcnt As Integer)
   cinfo.cseffect(cPoison).cnt = pcnt
End Sub

'Returns the strength of the poison..
Function GetPoisonStr() As Integer
   Return cinfo.cseffect(cPoison).amt
End Function

'Sets the poisoned strength.
Sub SetPoisonStr(pamt As Integer)
   cinfo.cseffect(cPoison).amt = pamt
End Sub

'Returns TRUE if blink is active.
Function BlinkActive() As Integer
   Return (cinfo.cseffect(cBlink).cnt > 0)
End Function

'Returns the low index of spell array.
Function LowISpell() As Integer
   Return LBound(cinfo.cspells)
End Function

'Returns the high index of spell array.
Function HighISpell() As Integer
   Return UBound(cinfo.cspells)
End Function

'Returns state of hasam flag.
Function GetHasAmulet() As Integer
   Return cinfo.hasam
End Function

'Sets the state of the hasam flag.
Sub SetHasAmulet(fnd As Integer)
   cinfo.hasam = fnd
   'If the amulet has been found, bump all the spell levels.
   If fnd = TRUE Then
      'Add 1000 xp.
      cinfo.currhp = cinfo.currhp + 1000
      'Bump all learned spells.
      For i As Integer = LBound(cinfo.cspells) To UBound(cinfo.cspells)
         'Do we have a spell in location.
         If cinfo.cspells(i).spell.id <> splNone Then
            'Bump the spell level.
            cinfo.cspells(i).spell.lvl += 20
         EndIf
      Next
   End If
End Sub

'Prints out the current stats for 
Sub PrintStats ()
   Dim As Integer tx, ty, row = 8
   Dim As String sinfo
   
   ScreenLock
   'Draw the background.
   DrawBackground charback()
   'Draw the title.
   sinfo = Trim(cinfo.cname) & " Attributes and Skills" 
   ty = row * charh
   tx = (CenterX(sinfo)) * charw
   DrawStringShadow tx, ty, sinfo, fbYellowBright
   'Draw the attributes.
   row += 4
   ty = row * charh
   tx = 70
   sinfo = "1 Strength:     " & cinfo.stratt(0)
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "2 Stamina:      " & cinfo.staatt(0)
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "3 Dexterity:    " & cinfo.dexatt(0)
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "4 Agility:      " & cinfo.aglatt(0)
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "5 Intelligence: " & cinfo.intatt(0)
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "Max Hit Points:   " & cinfo.maxhp
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "Max Mana Points:   " & cinfo.maxmana
   DrawStringShadow tx, ty, sinfo
   row += 3
   ty = row * charh
   sinfo = "Unarmed Combat:    " & cinfo.ucfsk(0)
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "Armed Combat:      " & cinfo.acfsk(0)
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "Projectile Combat: " & cinfo.pcfsk(0)
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "Magic Combat:      " & cinfo.mcfsk(0)
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "Combat Defense:    " & cinfo.cdfsk(0)
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "Magic Defense:     " & cinfo.mdfsk(0)
   DrawStringShadow tx, ty, sinfo
   row += 3
   ty = row * charh
   sinfo = "Experience: " & cinfo.currxp
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "Gold:       " & cinfo.currgold
   DrawStringShadow tx, ty, sinfo

   ScreenUnlock
End Sub

'Adds inventory item to character inventory slot.
Sub AddInvItem(idx As Integer, inv As invtype)
   Dim As invtype inv2
   
   'Check to see if the index is in bounds.
   If idx >= LBound(cinfo.cwield) And idx <= UBound(cinfo.cwield) Then
      'Clear the inventory slot.
      ClearInv cinfo.cwield(idx)
      'Set the item in the inv slot.
      cinfo.cwield(idx) = inv
      'Check for two-handed weapon and set other hand unavaialble.
      If inv.classid = clWeapon Then
         'If two handed weapon set the other hand to unavailable.
         If inv.weapon.hands = 2 Then
            'Get new unavail item.
            GenerateUnavail inv2
            'Set the item in the slot.
            If idx = wPrimary Then
               ClearInv cinfo.cwield(wSecondary)
               cinfo.cwield(wSecondary) = inv2
            Else
               ClearInv cinfo.cwield(wPrimary)
               cinfo.cwield(wPrimary) = inv2
            EndIf
         EndIf
      End If
   Else
      'Validate the inventory index.
      If idx >= LBound(cinfo.cinv) And idx <= UBound(cinfo.cinv) Then
         'Clear the inventory slot.
         ClearInv cinfo.cinv(idx)
         'Set the item in the inv slot.
         cinfo.cinv(idx) = inv
      End If   
   EndIf
End Sub

'Gets an item from an inventory slot.
Sub GetInventoryItem(idx As Integer, inv As invtype)
   
   'Clear the inv item.
   ClearInv inv
   'Check st see if the items in a help item.
   If idx >= LBound(cinfo.cwield) And idx <= UBound(cinfo.cwield) Then
      'Set the item in the inv slot.
      inv = cinfo.cwield(idx)
   Else
      'Validate the index.
      If idx >= LBound(cinfo.cinv) And idx <= UBound(cinfo.cinv) Then
         inv = cinfo.cinv(idx)
      Else
         If idx >= LBound(cinfo.cspells) And idx <= UBound(cinfo.cspells) Then
            inv = cinfo.cspells(idx)
         EndIf
      End If
   End If
End Sub

'Changes attribute and updates associated stats.
Sub ChangeStrength(change As Integer, docurrhp As Integer = FALSE)
   'Update the attribute
   cinfo.stratt(idxAttr) = cinfo.stratt(idxAttr) + change
   If cinfo.stratt(idxAttr) < 1 Then cinfo.stratt(idxAttr) = 1
   'Update the HP. 
   cinfo.maxhp = cinfo.stratt(idxAttr) + cinfo.staatt(idxAttr)
   If docurrhp <> FALSE Then 
      cinfo.currhp = cinfo.maxhp
   End If 
   cinfo.ucfsk(idxAttr) = cinfo.stratt(idxAttr) + cinfo.aglatt(idxAttr)
   cinfo.acfsk(idxAttr) = cinfo.stratt(idxAttr) + cinfo.dexatt(idxAttr)
   cinfo.cdfsk(idxAttr) = cinfo.stratt(idxAttr) + cinfo.aglatt(idxAttr)
End Sub

'Changes attribute and updates associated stats.
Sub ChangeStamina(change As Integer, docurrhp As Integer = FALSE)
      'Update the attribute
      cinfo.staatt(idxAttr) = cinfo.staatt(idxAttr) + change
      If cinfo.staatt(idxAttr) < 1 Then cinfo.staatt(idxAttr) = 1
      'Update the HP. 
      cinfo.maxhp = cinfo.stratt(idxAttr) + cinfo.staatt(idxAttr) 
      If docurrhp <> FALSE Then 
         cinfo.currhp = cinfo.maxhp
      End If 
      cinfo.maxmana = cinfo.intatt(idxAttr) + cinfo.staatt(idxAttr) 
      cinfo.currmana = cinfo.maxmana
      cinfo.mcfsk(idxAttr) = cinfo.intatt(idxAttr) + cinfo.staatt(idxAttr)
End Sub

'Changes attribute and updates associated stats.
Sub ChangeDexterity(change As Integer)
      'Update the attribute
      cinfo.dexatt(idxAttr) = cinfo.dexatt(idxAttr) + change
      If cinfo.dexatt(idxAttr) < 1 Then cinfo.dexatt(idxAttr) = 1
      'Update the combat factor. 
      cinfo.acfsk(idxAttr) = cinfo.stratt(idxAttr) + cinfo.dexatt(idxAttr)
      cinfo.pcfsk(idxAttr) = cinfo.dexatt(idxAttr) + cinfo.intatt(idxAttr)
End Sub

'Changes attribute and updates associated stats.
Sub ChangeAgility(change As Integer)
      'Update the attribute
      cinfo.aglatt(idxAttr) = cinfo.aglatt(idxAttr) + change
      If cinfo.aglatt(idxAttr) < 1 Then cinfo.aglatt(idxAttr) = 1
      'Update the combat factor. 
      cinfo.ucfsk(idxAttr) = cinfo.stratt(idxAttr) + cinfo.aglatt(idxAttr)
      cinfo.mdfsk(idxAttr) = cinfo.aglatt(idxAttr) + cinfo.intatt(idxAttr)
      cinfo.cdfsk(idxAttr) = cinfo.stratt(idxAttr) + cinfo.aglatt(idxAttr)
End Sub

'Changes attribute and updates associated stats. 
Sub ChangeIntelligence(change As Integer)
   'Update the attribute
   cinfo.intatt(idxAttr) = cinfo.intatt(idxAttr) + change
   If cinfo.intatt(idxAttr) < 1 Then cinfo.intatt(idxAttr) = 1
   charint = cinfo.intatt(idxAttr)
   'Update the mana factor. 
   cinfo.maxmana = cinfo.intatt(idxAttr) + cinfo.staatt(idxAttr) 
   'Update the combat factors.
   cinfo.pcfsk(idxAttr) = cinfo.dexatt(idxAttr) + cinfo.intatt(idxAttr)
   cinfo.mcfsk(idxAttr) = cinfo.intatt(idxAttr) + cinfo.staatt(idxAttr)
   cinfo.mdfsk(idxAttr) = cinfo.aglatt(idxAttr) + cinfo.intatt(idxAttr)
End Sub



'Decrements the ammo in held weapon.
Sub DecrementAmmo(slot As wieldpos)
   cinfo.cwield(slot).weapon.ammocnt -= 1
   If cinfo.cwield(slot).weapon.ammocnt < 0 Then 
      cinfo.cwield(slot).weapon.ammocnt = 0
   EndIf
End Sub

'Manages any timed events.
Sub DoCharTimedEvents()
   Dim As Integer roll1, roll2, v1, v2, amt, statamt
   
   'Poison will affect character based on strength of poison.
   If GetPoisoned = TRUE Then
      'Get the strength of the poison.
      v1 = GetPoisonStr
      'Get character stamina + bonus
      v2 = GetCurrSta + GetBonSta
      'Roll for the poison.
      roll1 = RandomRange(1, v1)
      roll2 = RandomRange(1, v2)
      'If poison wins,
      If roll1 > roll2 Then
         'Take one off the health.
         SetCurrHP GetCurrHP - 1 
      EndIf
   EndIf
   'Check stat bonus counts and adjust if necessary.
   'Strength.
   If GetBonStrCnt > 0 Then
      SetBonStrCnt GetBonStrCnt - 1
      If GetBonStrCnt < 1 Then
         SetBonStr 0
      EndIf
   EndIf
   'Stamina
   If GetBonStaCnt > 0 Then
      SetBonStaCnt GetBonStaCnt - 1
      If GetBonStaCnt < 1 Then
         SetBonSta 0
      EndIf
   EndIf
   'Dexterity.
   If GetBonDexCnt > 0 Then
      SetBonDexCnt GetBonDexCnt - 1
      If GetBonDexCnt < 1 Then
         SetBonDex 0
      EndIf
   EndIf
   'Agility
   If GetBonAglCnt > 0 Then
      SetBonAglCnt GetBonAglCnt - 1
      If GetBonAglCnt < 1 Then
         SetBonAgl 0
      EndIf
   EndIf
   'Intelligence.
   If GetBonIntCnt > 0 Then
      SetBonIntCnt GetBonIntCnt - 1
      If GetBonIntCnt < 1 Then
         SetBonInt 0
      EndIf
      charint = cinfo.intatt(idxAttr) + GetBonInt
   EndIf
   'Unarmed combat.
   If GetBonUcfCnt > 0 Then
      SetBonUcfCnt GetBonUcfCnt - 1
      If GetBonUcfCnt < 1 Then
         SetBonUcf 0
      EndIf
   EndIf
   'Armed combat.
   If GetBonAcfCnt > 0 Then
      SetBonAcfCnt GetBonAcfCnt - 1
      If GetBonAcfCnt < 1 Then
         SetBonAcf 0
      EndIf
   EndIf
   'Projectile combat.
   If GetBonPcfCnt > 0 Then
      SetBonPcfCnt GetBonPcfCnt - 1
      If GetBonPcfCnt < 1 Then
         SetBonPcf 0
      EndIf
   EndIf
   'Magic combat.
   If GetBonMcfCnt > 0 Then
      SetBonMcfCnt GetBonMcfCnt - 1
      If GetBonMcfCnt < 1 Then
         SetBonMcf 0
      EndIf
   EndIf
   'Combat defense.
   If GetBonCdfCnt > 0 Then
      SetBonCdfCnt GetBonCdfCnt - 1
      If GetBonCdfCnt < 1 Then
         SetBonCdf 0
      EndIf
   EndIf
   'Magic Defense.
   If GetBonMdfCnt > 0 Then
      SetBonMdfCnt GetBonMdfCnt - 1
      If GetBonMdfCnt < 1 Then
         SetBonMdf 0
      EndIf
   EndIf
   'Check for necklaces and rings.
   statamt = GetMaxHP
   amt = GetJewleryEffect(jwRegenHP, statamt)
   SetCurrHP GetCurrHP + amt
   statamt = MaxMana
   amt = GetJewleryEffect(jwRegenMana, statamt)
   SetCurrMana GetCurrMana + amt
   'Check for blink spell.
   If cinfo.cseffect(cBlink).cnt > 0 Then
      cinfo.cseffect(cBlink).cnt = cinfo.cseffect(cBlink).cnt - 1
      If cinfo.cseffect(cBlink).cnt < 0 Then cinfo.cseffect(cBlink).cnt = 0
   EndIf
End Sub

'Sets the spell effect.
Sub SetSpellEffect(splid As cspleffects, scnt As Integer, samt As Integer)
   Select Case splid
      Case cPoison
         cinfo.cseffect(cPoison).cnt = scnt
         cinfo.cseffect(cPoison).amt = samt
      Case cBlink
         cinfo.cseffect(cBlink).cnt = scnt
         cinfo.cseffect(cBlink).amt = samt
   End Select
End Sub

'Applies trap damage.
Sub ApplyTrap(tdr As Integer, tdam As Integer, tdamtype As weapdamtype, tdesc As String)
   Dim As Integer troll, proll, pagl, lvl, dam
   Dim As weapdamtype armeff
    
   'Get the trap and character rolls.
   troll = RandomRange(1, tdr)
   'Get the character agility and bonus amounts.
   pagl = GetCurrAgl + GetBonAgl
   proll = RandomRange(1, pagl)
   'See who wins.
   If proll > troll Then
      'Character evades trap and gains some experience.
      PrintMessage "You evaded the " & tdesc & "!"
      SetCurrXP GetCurrXP + tdr
   Else
      'Set base damage.
      dam = tdam
      'Get armor spell effect if any.
      If cinfo.cwield(wArmor).classid = clArmor Then
         'Apply armor value to damage.
         dam = tdam - (tdam * cinfo.cwield(wArmor).armor.dampct)
         'Get spell effect.
         armeff = cinfo.cwield(wArmor).armor.spelleffect
         'Get spell level.
         lvl = cinfo.cwield(wArmor).armor.spell.lvl
         'If armor spell matches damage type moderate the damage.
         If tdamtype = armeff Then
            'Get the new damage value.
            dam = dam - (dam * (lvl / 100))
         EndIf
         'Give at least 1 point of damage.
         If dam < 1 Then dam = 1
      EndIf
      'Apply damage to 
      SetCurrHP GetCurrHP - dam
      PrintMessage "The " & tdesc & " did " & dam & " damage points!"   
   EndIf
End Sub

'Gets the character data.
Sub GetCharacterData(cd As characterinfo)
   cd = cinfo
End Sub

'Sets the character data.
Sub SetCharacterData(cd As characterinfo)
   cinfo = cd
End Sub

'Applies the inv type to the 
Function ApplyInvItem(inv As invtype) As String
   Dim As Integer evalstate, amt, amt2, amt3, chk = FALSE
   Dim As String ret
   
   'Check the eval state.
   evalstate =  IsEval(inv)
   
   If inv.classid = clSupplies Then
      'Evaluated magical item.
      If inv.supply.id = supHealingHerb Then
         If (inv.supply.spell.id = splMaxHealing) And (evalstate = TRUE) Then 
            SetCurrHP GetMaxHP
            ret = "The Healing Herb completely healed you!"
         Else
            'Does 50% healing.
            amt = GetMaxHP * .5 'Calc the amount.
            SetCurrHP GetCurrHP + amt
            ret = "The Healing Herb added " & amt & " health!"
         End If
      End If
      If inv.supply.id = supHunkMeat Then
         'Does 25% healing.
         amt = GetMaxHP * .25
         SetCurrHP GetCurrHP + amt 
         ret = "The Hunk of Meat added " & amt & " health!"
         'Evaluated magical item.
         If (inv.supply.spell.id = splStrongMeat) And (evalstate = TRUE) Then
            amt2 = RandomRange(1, GetCurrStr)
            SetBonStr amt2
            amt3 = RandomRange(1, 100)
            SetBonStrCnt amt3  
            ret = "The Hunk of Meat added " & amt & " health and added " & amt2 & " strength for " & amt3 & " turns!" 
         EndIf
      ElseIf inv.supply.id = supBread Then
         'Does 10% healing.
         amt = GetMaxHP * .1
         SetCurrHP GetCurrHP + amt 
         ret = "The Bread added " & amt & " health!"
         'Evaluated magical item.
         If (inv.supply.spell.id = splBreadLife) And (evalstate = TRUE) Then
            'Cure the poison if any.
            If GetPoisoned = TRUE Then
               SetPoisoned FALSE
               SetPoisonStr 0
               ret = "The Bread added " & amt & " health and cured your poison!"
            End If
         EndIf
      ElseIf inv.supply.id = supManaOrb Then
         'Adds 25% mana.
         amt = MaxMana * .25
         SetCurrMana GetCurrMana + amt 
         ret = "The Mana Orb added " & amt & " mana!"
         'Evaluated magical item.
         If (inv.supply.spell.id = splMaxMana) And (evalstate = TRUE) Then
            'Cure the poison if any.
            If GetCurrMana = MaxMana Then
               ret = "The Mana Orb restored all your mana!"
            End If
         EndIf
      EndIf
   ElseIf inv.classid = clPotion Then
      Select Case inv.potion.effect
         Case potStrength
            ChangeStrength inv.potion.amt
            If inv.potion.amt > 0 Then
               ret = "You gained " & inv.potion.amt & " strength!" 
            Else
               ret = "You lost " & inv.potion.amt & " strength!"
            EndIf
         Case potStamina
            ChangeStamina inv.potion.amt
            If inv.potion.amt > 0 Then
               ret = "You gained " & inv.potion.amt & " stamina!" 
            Else
               ret = "You lost " & inv.potion.amt & " stamina!"
            EndIf
         Case potDexterity
            ChangeDexterity inv.potion.amt
            If inv.potion.amt > 0 Then
               ret = "You gained " & inv.potion.amt & " dexterity!" 
            Else
               ret = "You lost " & inv.potion.amt & " dexterity!"
            EndIf
         Case potAgility
            ChangeAgility inv.potion.amt
            If inv.potion.amt > 0 Then
               ret = "You gained " & inv.potion.amt & " agility!" 
            Else
               ret = "You lost " & inv.potion.amt & " agility!"
            EndIf
         Case potIntelligence
            ChangeIntelligence inv.potion.amt
            If inv.potion.amt > 0 Then
               ret = "You gained " & inv.potion.amt & " intelligence!" 
            Else
               ret = "You lost " & inv.potion.amt & " intelligence!"
            EndIf
         Case potUCF
            SetBonUcf inv.potion.amt
            SetBonUcfCnt inv.potion.cnt
            If inv.potion.amt > 0 Then
               ret = "You gained " & inv.potion.amt & " Unarmed Combat for " & inv.potion.cnt & " turns!"
            Else
               ret = "You lost " & inv.potion.amt & " Unarmed Combat for " & inv.potion.cnt & " turns!"
            EndIf
         Case potACF
            SetBonAcf inv.potion.amt
            SetBonAcfCnt inv.potion.cnt
            If inv.potion.amt > 0 Then
               ret = "You gained " & inv.potion.amt & " Armed Combat for " & inv.potion.cnt & " turns!"
            Else
               ret = "You lost " & inv.potion.amt & " Armed Combat for " & inv.potion.cnt & " turns!"
            EndIf
         Case potPCF
            SetBonPcf inv.potion.amt
            SetBonPcfCnt inv.potion.cnt
            If inv.potion.amt > 0 Then
               ret = "You gained " & inv.potion.amt & " Projectile Combat for " & inv.potion.cnt & " turns!"
            Else
               ret = "You lost " & inv.potion.amt & " Projectile Combat for " & inv.potion.cnt & " turns!"
            EndIf
         Case potMCF
            SetBonMcf inv.potion.amt
            SetBonMcfCnt inv.potion.cnt
            If inv.potion.amt > 0 Then
               ret = "You gained " & inv.potion.amt & " Magic Combat for " & inv.potion.cnt & " turns!"
            Else
               ret = "You lost " & inv.potion.amt & " Magic Combat for " & inv.potion.cnt & " turns!"
            EndIf
         Case potCDF
            SetBonCdf inv.potion.amt
            SetBonCdfCnt inv.potion.cnt
            If inv.potion.amt > 0 Then
               ret = "You gained " & inv.potion.amt & " Combat Defense for " & inv.potion.cnt & " turns!"
            Else
               ret = "You lost " & inv.potion.amt & " Combat Defense for " & inv.potion.cnt & " turns!"
            EndIf
         Case potMDF
            SetBonMdf inv.potion.amt
            SetBonMdfCnt inv.potion.cnt
            If inv.potion.amt > 0 Then
               ret = "You gained " & inv.potion.amt & " Magic Defense for " & inv.potion.cnt & " turns!"
            Else
               ret = "You lost " & inv.potion.amt & " Magic Defense for " & inv.potion.cnt & " turns!"
            EndIf
         Case potHealing
            SetCurrHP GetCurrHP + inv.potion.amt
            If inv.potion.amt > 0 Then
               ret = "You gained " & inv.potion.amt & " health!"
            Else
               ret = "You lost " & inv.potion.amt & " health!"
            EndIf
         Case potMana
            SetCurrMana GetCurrMana + inv.potion.amt
            If inv.potion.amt > 0 Then
               ret = "You gained " & inv.potion.amt & " mana!"
            Else
               ret = "You lost " & inv.potion.amt & " mana!"
            EndIf
      End Select
   ElseIf inv.classid = clSpellBook Then
      'Check for blank spellbook.
      If inv.spellbook.id = bkSpellBlank Then
         ret = "The spell book is blank."
      Else
         'First check to see if the spell is already in the list.
         For i As Integer = 65 To 90
            If cinfo.cspells(i).spell.id = inv.spellbook.spell.id Then
               'Bump the level of the learned spell.
               cinfo.cspells(i).spell.lvl += inv.spellbook.spell.lvl
               ret = "You gained a level in " & inv.spellbook.spell.splname & "!"
               chk = TRUE
               Exit For
            EndIf
         Next
         'Not in the list, so add it.
         If chk = FALSE Then
            'Find empty slot.
            For i As Integer = 65 To 90
               If cinfo.cspells(i).spell.id = splNone Then
                  cinfo.cspells(i).classid = clSpell
                  cinfo.cspells(i).spell = inv.spellbook.spell
                  ret = "You learned " & inv.spellbook.spell.splname & "!"
                  Exit For
               EndIf
            Next
         EndIf
      End If
   EndIf
   
   Return ret
End Function

'Returns True if item exists in inventory slot.
Function HasInvItem(idx As Integer) As Integer
   Dim As Integer ret = FALSE
   
   'Check held items.
   If idx >= LBound(cinfo.cwield) And idx <= UBound(cinfo.cwield) Then
      'Check the class id.
      If cinfo.cwield(idx).classid <> clNone Then
         ret = TRUE
      EndIf
   Else
      'Validate the index.
      If idx >= LBound(cinfo.cinv) And idx <= UBound(cinfo.cinv) Then
         'Check the class id.
         If cinfo.cinv(idx).classid <> clNone Then
            ret = TRUE
         EndIf
      Else
         'Check for spells.
         If idx >= LBound(cinfo.cspells) And idx <= UBound(cinfo.cspells) Then
            If cinfo.cspells(idx).spell.id <> splNone Then
               ret = TRUE
            EndIf
         EndIf
      End If   
   EndIf
   
   Return ret   
End Function

'Generates a new 
Function GenerateCharacter() As Integer
   Dim As String chname, prompt, skey
   Dim As Integer done = FALSE, ret = TRUE, tx, ty, idx
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
   ScreenUnlock
   ib.Title = "Character Name"
   ib.Prompt = "Enter your character's name:"
   ib.MaxLen = 35
   ib.InputLen = 35
   'Get the name of the 
   btn = ib.Inputbox(chname)
   If btn = tWidgets.btnID.gbnCancel Then
      ret = FALSE
   EndIf
   If btn = tWidgets.btnID.gbnOK Then
      ret = TRUE
   EndIf
   'Display 
   If ret = TRUE Then
      'Generate the character data.
      Do
         With cinfo
            .cname = chname
            .stratt(idxAttr) = RandomRange (10, 20) 'Generate new stat.
            .staatt(idxAttr) = RandomRange (10, 20)
            .dexatt(idxAttr) = RandomRange (10, 20)
            .aglatt(idxAttr) = RandomRange (10, 20)
            .intatt(idxAttr) = RandomRange (10, 20)
            charint = .intatt(idxAttr) 
            .stratt(idxAttrBon) = 0                   'Clear any bonuses.
            .staatt(idxAttrBon) = 0
            .dexatt(idxAttrBon) = 0
            .aglatt(idxAttrBon) = 0
            .intatt(idxAttrBon) = 0
            .stratt(idxAttrCnt) = 0                   'Clear counts.
            .staatt(idxAttrCnt) = 0
            .dexatt(idxAttrCnt) = 0
            .aglatt(idxAttrCnt) = 0
            .intatt(idxAttrCnt) = 0
            .maxhp = .stratt(idxAttr) + .staatt(idxAttr) 
            .currhp = .maxhp
            .maxmana = .intatt(idxAttr) + .staatt(idxAttr) 
            .currmana = .maxmana
            .ucfsk(idxAttr) = .stratt(idxAttr) + .aglatt(idxAttr) 
            .acfsk(idxAttr) = .stratt(idxAttr) + .dexatt(idxAttr) 
            .pcfsk(idxAttr) = .dexatt(idxAttr) + .intatt(idxAttr)
            .mcfsk(idxAttr) = .intatt(idxAttr) + .staatt(idxAttr)
            .cdfsk(idxAttr) = .stratt(idxAttr) + .aglatt(idxAttr)
            .mdfsk(idxAttr) = .aglatt(idxAttr) + .intatt(idxAttr)
            .ucfsk(idxAttrBon) = 0                       'Clear bonuses. 
            .acfsk(idxAttrBon) = 0 
            .pcfsk(idxAttrBon) = 0
            .mcfsk(idxAttrBon) = 0
            .cdfsk(idxAttrBon) = 0
            .mdfsk(idxAttrBon) = 0
            .ucfsk(idxAttrCnt) = 0                       'Clear counts.. 
            .acfsk(idxAttrCnt) = 0 
            .pcfsk(idxAttrCnt) = 0
            .mcfsk(idxAttrCnt) = 0
            .cdfsk(idxAttrCnt) = 0
            .mdfsk(idxAttrCnt) = 0
            .currxp = RandomRange (100, 200)
            .totxp = .currxp
            .currgold = RandomRange (100, 500)
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
   arm = GetBestArmor
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
Function GetFreeInventoryIndex() As Integer
   Dim As Integer ret = -1
   
   'Look for an empty inventory slot.
   For i As Integer = LBound(cinfo.cinv) To UBound(cinfo.cinv)
      'Examine class id.
      If cinfo.cinv(i).classid = clNone Then
         'Empty slot.
         ret = i
         Exit For
      EndIf
   Next
   
   Return ret
End Function

'Returns True if character can wear item.
Function CanWear(inv As invtype) As Integer
   Dim As Integer ret = TRUE
   
   If inv.classid = clArmor Then
      If inv.armor.struse > cinfo.stratt(idxAttr) Then
         ret = FALSE
      EndIf
   EndIf

   If inv.classid = clShield Then
      If inv.shield.struse > cinfo.stratt(idxAttr) Then
         ret = FALSE
      EndIf
   EndIf
   
   Return ret
End Function

'Returns the current noise volume.
Function GetNoise() As Integer
   Dim As Integer ret = 0
   
   'Get gold amount.
   ret = cinfo.currgold / 10
   'Get inventory amounts.
   For i As Integer = LBound(cinfo.cinv) To UBound(cinfo.cinv) 
      ret += GetItemNoise(cinfo.cinv(i))
   Next
   'Get held amounts.
   For i As Integer = LBound(cinfo.cwield) To UBound(cinfo.cwield) 
      ret += GetItemNoise(cinfo.cwield(i))
   Next
   
   Return ret
End Function

'Returns the spell effect of any jewlery.
Function GetJewleryEffect(effect As jeffects, baseamt As Integer) As Integer
   Dim As Integer ret = 0
   
   'Check for necklace or ring.
   If cinfo.cwield(wNeck).classid = clNecklace Then
      'Make sure it is evaluated.
      If cinfo.cwield(wNeck).jewelry.eval = TRUE Then
         'Check for spell.
         If cinfo.cwield(wNeck).jewelry.spell.id <> splNone Then
            'Check for effect.
            If cinfo.cwield(wNeck).jewelry.spelleffect = effect Then
               'Add in the spell amount.
               ret += Int((cinfo.cwield(wNeck).jewelry.spell.lvl / 100) * baseamt) + 1
            EndIf
         End If
      EndIf
   EndIf
   If cinfo.cwield(wRingRt).classid = clRing Then
      'Make sure it is evaluated.
      If cinfo.cwield(wRingRt).jewelry.eval = TRUE Then
         'Check for spell.
         If cinfo.cwield(wRingRt).jewelry.spell.id <> splNone Then
            'Check for effect.
            If cinfo.cwield(wRingRt).jewelry.spelleffect = effect Then
               'Add in the spell amount.
               ret += Int((cinfo.cwield(wRingRt).jewelry.spell.lvl / 100) * baseamt) + 1
            EndIf
         End If
      EndIf
   EndIf
   If cinfo.cwield(wRingLt).classid = clRing Then
      'Make sure it is evaluated.
      If cinfo.cwield(wRingLt).jewelry.eval = TRUE Then
         'Check for spell.
         If cinfo.cwield(wRingLt).jewelry.spell.id <> splNone Then
            'Check for effect.
            If cinfo.cwield(wRingLt).jewelry.spelleffect = effect Then
               'Add in the spell amount.
               ret += Int((cinfo.cwield(wRingLt).jewelry.spell.lvl / 100) * baseamt) + 1
            EndIf
         End If
      EndIf
   EndIf
   
   Return ret
End Function

'Returns the current combat factor based on what the character is wielding.
Function GetMeleeCombatFactor() As Integer
   Dim As Integer ret
   
   'Unarmed combat.
   If (cinfo.cwield(wPrimary).classid <> clWeapon) And (cinfo.cwield(wSecondary).classid <> clWeapon) Then
      ret = GetCurrUcf + GetBonUcf
      ret += GetJewleryEffect(jwUCF, ret)
   Else
      'Check primary slot.
      If cinfo.cwield(wPrimary).classid = clWeapon Then
         'Wielding a melee weapon.
         If cinfo.cwield(wPrimary).weapon.weapontype <> wtProjectile Then
            ret = CurrAcf + GetBonAcf
            ret += GetJewleryEffect(jwACF, ret)
         Else
          'Return UCF as projectile weapon isn't melee weapon.
           ret = GetCurrUcf + GetBonUcf
           ret += GetJewleryEffect(jwACF, ret)
         EndIf
      Else
         If cinfo.cwield(wSecondary).classid = clWeapon Then
            'Wielding a melee weapon.
            If cinfo.cwield(wSecondary).weapon.weapontype <> wtProjectile Then
               ret = CurrAcf + GetBonAcf
               ret += GetJewleryEffect(jwACF, ret)
            Else
               'Return UCF as projectile weapon isn't melee weapon.
               ret = GetCurrUcf + GetBonUcf
               ret += GetJewleryEffect(jwACF, ret)
            End If
         EndIf
      End If
   EndIf

    Return ret     
End Function

'Return projectile combat factor.
Function GetProjectileCombatFactor() As Integer
   Dim As Integer ret
   
   ret = GetCurrPCF + GetBonPcf
   ret += GetJewleryEffect(jwPCF, ret)
   
   Return ret
End Function

'Return magic combat factor.
Function GetMagicCombatFactor() As Integer
   Dim As Integer ret
   
   ret = GetCurrMCF + GetBonMcf
   ret += GetJewleryEffect(jwMCF, ret)
   
   Return ret 
End Function

'Return magic defense factor.
Function GetMagicDefense() As Integer
   Dim As Integer ret
   
   ret = CurrMdf + GetBonMdf
   'Check for any jewelry effects.
   ret += GetJewleryEffect(jwMDF, ret)
   'Check for armor effect.
   If cinfo.cwield(wArmor).classid = clArmor Then
      'Is the armor evaluated?
      If cinfo.cwield(wArmor).armor.eval = TRUE Then
         'Does the armor have a spell?
         If cinfo.cwield(wArmor).armor.spell.id <> splNone Then
            'Check for magic protection spell.
            If cinfo.cwield(wArmor).armor.spell.id = splNoMagic Then
               'Add in level percentage protection.
               ret += (CurrMDF + GetBonMdf) * (cinfo.cwield(wArmor).armor.spell.lvl / 100)
            EndIf
         EndIf
      End If
   EndIf
   
   Return ret 
End Function

'Returns the amount of weapon damage.
Function GetWeaponDamage(wslot As wieldpos = wAny) As Integer
   Dim As Integer ret = 0
   
   'See if we have any weapons.
   If (cinfo.cwield(wPrimary).classid <> clWeapon) And (cinfo.cwield(wSecondary).classid <> clWeapon) Then
      'If no weapon get the stength value plus bonus.
      ret = (cinfo.stratt(idxAttr) + cinfo.stratt(idxAttrBon)) / 2
   Else
      If wslot = wAny Then
         'Have one or more weapons.
         If cinfo.cwield(wPrimary).classid = clWeapon Then
            'Get the current weapon damage.
            ret = cinfo.cwield(wPrimary).weapon.dam
         EndIf
         If cinfo.cwield(wSecondary).classid = clWeapon Then
            ret += cinfo.cwield(wSecondary).weapon.dam
         EndIf
      Else
         ret = cinfo.cwield(wSlot).weapon.dam
      End If
   EndIf
   
   Return ret
End Function

'Returns the character's defense factor.
Function GetDefenseFactor () As Integer
   Dim As Integer ret
   
   ret = GetCurrCdf + GetBonCdf
   ret += GetJewleryEffect(jwCDF, ret)
   
   Return ret
End Function

'Returns the character's defense factor.
Function GetMagicDefenseFactor () As Integer
   Dim As Integer ret
   
   ret = CurrMdf + GetBonMdf
   ret += GetJewleryEffect(jwMDF, ret)
   'Check for 
   
   Return ret
End Function

'Returns the current armor value.
Function GetArmorValue(wp As weapdamtype = wdNone) As Single
   Dim As Single ret = 0.0
   
   'Check for armor.
   If cinfo.cwield(wArmor).classid <> clNone Then
      ret = cinfo.cwield(wArmor).armor.dampct
      'Check to make sure we have an attack type.
      If wp <> wdNone Then
         'Check for magical shield.
         If cinfo.cwield(wArmor).armor.eval = TRUE Then
            'Does shield have a spell.
            If cinfo.cwield(wArmor).armor.spell.id <> splNone Then
               'Does effect match attack effect.
               If cinfo.cwield(wArmor).armor.spelleffect = wp Then
                  'Add in the value.
                  ret += (cinfo.cwield(wArmor).armor.spell.lvl / 100)
               EndIf
            EndIf
         EndIf
      End If
   EndIf
   
   Return ret
End Function

'Returns any shield armor value.
Function GetShieldArmorValue (wp As weapdamtype = wdNone) As Single
   Dim As Single ret = 0.0
   Dim As Integer cnt
      
   'Check for any shields.
   If cinfo.cwield(wPrimary).classid = clShield Then
      ret += cinfo.cwield(wPrimary).shield.dampct
      cnt = 1
      'Check to make sure we have an attack type.
      If wp <> wdNone Then
         'Check for magical shield.
         If cinfo.cwield(wPrimary).shield.eval = TRUE Then
            'Does shield have a spell.
            If cinfo.cwield(wPrimary).shield.spell.id <> splNone Then
               'Does effect match attack effect.
               If cinfo.cwield(wPrimary).shield.spelleffect = wp Then
                  'Add in the value.
                  ret += (cinfo.cwield(wPrimary).shield.spell.lvl / 100)
                  cnt += 1 
               EndIf
            EndIf
         EndIf
      End If
   EndIf   
   If cinfo.cwield(wSecondary).classid = clShield Then
      ret += cinfo.cwield(wSecondary).shield.dampct
      cnt += 1
      'Make sure we have an attack type.
      If wp <> wdNone Then
         'Check for magical shield.
         If cinfo.cwield(wSecondary).shield.eval = TRUE Then
            'Does shield have a spell.
            If cinfo.cwield(wSecondary).shield.spell.id <> splNone Then
               'Does effect match attack effect.
               If cinfo.cwield(wSecondary).shield.spelleffect = wp Then
                  'Add in the value.
                  ret += (cinfo.cwield(wSecondary).shield.spell.lvl / 100)
                  cnt += 1 
               EndIf
            EndIf
         EndIf
      End If
   EndIf
   
   'Get the average of the values if any.
   If cnt > 0 Then
      ret = ret / cnt
   EndIf
   
   Return ret
End Function

'Returns True if character has pojectile weapon equipped.
Function ProjectileEquipped(slot As wieldpos) As Integer 
   Dim As Integer ret = FALSE
   
   'Make sure the classid is a weapon.
   If cinfo.cwield(wPrimary).classid = clWeapon Then
      'Make sure the weapon is a projectile.
      If cinfo.cwield(wPrimary).weapon.weapontype = wtProjectile Then
         'Check the slot.
         If (slot = wAny) Or (slot = wPrimary) Then
            ret = TRUE
         End If
      EndIf
   Else
      'Make sure the classid is a weapon.
      If cinfo.cwield(wSecondary).classid = clWeapon Then
         'Make sure the weapon is a projectile.
         If cinfo.cwield(wSecondary).weapon.weapontype = wtProjectile Then
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
Function IsLoaded(slot As wieldpos) As Integer
   Dim As Integer ret = FALSE
   
   'Make sure we have a weapon.
   If cinfo.cwield(slot).classid = clWeapon Then
      'Make sure it is a projectile.
      If cinfo.cwield(slot).weapon.weapontype = wtProjectile Then
         'Check the loaded flag.
         ret = (cinfo.cwield(slot).weapon.ammocnt > 0)
      EndIf
   EndIf
   
   Return ret
End Function

'Returns the ammoid for projectile weapon in slot.
Function GetAmmoID(slot As wieldpos) As ammoids
   Dim ret As armorids
   
   'Check to see if slot is holding a weapon.
   If cinfo.cwield(slot).classid = clWeapon Then
      'Make sure it is projectile weapon.
      If cinfo.cwield(slot).weapon.weapontype = wtProjectile Then
         ret = cinfo.cwield(slot).weapon.ammotype
      Else
         ret = amNone
      EndIf
   Else
      ret = amNone
   EndIf
   Return ret
End Function

'Returns True if weapon was loaded.
Function LoadProjectile(aid As ammoids, slot As wieldpos) As Integer 
   Dim As Integer ret = FALSE, i, iitem
   Dim As invtype inv
   
   'Look through the inventory and see if we have any ammo matching ammo id.
   For i = LowInv To HighInv
      'If the weapon is full, then exit.
      If cinfo.cwield(slot).weapon.ammocnt = cinfo.cwield(slot).weapon.capacity Then
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
               Do While cinfo.cwield(slot).weapon.ammocnt < cinfo.cwield(slot).weapon.capacity
                  'Load the weapon.
                  cinfo.cwield(slot).weapon.ammocnt += 1
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
               If cinfo.cwield(slot).weapon.ammocnt > 0 Then
                  ret = TRUE
               EndIf
            EndIf
         EndIf
      EndIf
   Next
   
   Return ret
End Function

'Returns state of idwand flag.
Function ProjectileIsWand(slot As wieldpos) As Integer
   Return cinfo.cwield(slot).weapon.iswand
End Function

'Returns True if x and y are at char's location.
Function IsLocation(x As Integer, y As Integer) As Integer
   Dim As Integer ret = FALSE
   
   If (x = GetLocX) And (y = GetLocY) Then
      ret = TRUE
   EndIf
   
   Return ret   
End Function

'Returns spell info.
Function GetItemSpellW(wslot As wieldpos) As spelltype
   Dim ret As spelltype
   
   'Clearsa the spell type.
   ClearSpell ret
         
   'Check to see if we have a weapon in slot.
   If cinfo.cwield(wslot).classid = clWeapon Then
      'Check to see if weapon is evaluated.
      If cinfo.cwield(wslot).weapon.eval = TRUE Then
         'Return the spell; may be splNone.
         ret = cinfo.cwield(wslot).weapon.spell
      End If
   ElseIf cinfo.cwield(wslot).classid = clShield Then
      'Check to see if weapon is evaluated.
      If cinfo.cwield(wslot).shield.eval = TRUE Then
         'Return the spell; may be splNone.
         ret = cinfo.cwield(wslot).shield.spell
      End If
   ElseIf cinfo.cwield(wslot).classid = clArmor Then
      'Check to see if weapon is evaluated.
      If cinfo.cwield(wslot).armor.eval = TRUE Then
         'Return the spell; may be splNone.
         ret = cinfo.cwield(wslot).armor.spell
      End If
   ElseIf cinfo.cwield(wslot).classid = clRing Then
      'Check to see if weapon is evaluated.
      If cinfo.cwield(wslot).jewelry.eval = TRUE Then
         'Return the spell; may be splNone.
         ret = cinfo.cwield(wslot).jewelry.spell
      End If
   ElseIf cinfo.cwield(wslot).classid = clNecklace Then
      'Check to see if weapon is evaluated.
      If cinfo.cwield(wslot).jewelry.eval = TRUE Then
         'Return the spell; may be splNone.
         ret = cinfo.cwield(wslot).jewelry.spell
      End If
   End If
   
   Return ret
End Function

'Returns spell info.
Function GetItemSpellI(inv As invtype) As spelltype
   Dim ret As spelltype
   
   'Clearsa the spell type.
   ClearSpell ret
         
   'Check to see if we have a weapon in slot.
   If inv.classid = clWeapon Then
      'Check to see if weapon is evaluated.
      If inv.weapon.eval = TRUE Then
         'Return the spell; may be splNone.
         ret = inv.weapon.spell
      End If
   ElseIf inv.classid = clShield Then
      'Check to see if weapon is evaluated.
      If inv.shield.eval = TRUE Then
         'Return the spell; may be splNone.
         ret = inv.shield.spell
      End If
   ElseIf inv.classid = clArmor Then
      'Check to see if weapon is evaluated.
      If inv.armor.eval = TRUE Then
         'Return the spell; may be splNone.
         ret = inv.armor.spell
      End If
   ElseIf inv.classid = clRing Then
      'Check to see if weapon is evaluated.
      If inv.jewelry.eval = TRUE Then
         'Return the spell; may be splNone.
         ret = inv.jewelry.spell
      End If
   ElseIf inv.classid = clNecklace Then
      'Check to see if weapon is evaluated.
      If inv.jewelry.eval = TRUE Then
         'Return the spell; may be splNone.
         ret = inv.jewelry.spell
      End If
   ElseIf inv.classid = clSupplies Then
      If inv.supply.eval = TRUE Then
         ret = inv.supply.spell
      EndIf
   End If
   
   Return ret
End Function

'Returns the spell short name if any.
Function GetCSpellName(idx As Integer, ByRef lvl As Integer) As String
   Dim As String ret = ""
   
   If idx >= LBound(cinfo.cspells) And idx <= UBound(cinfo.cspells) Then
      If cinfo.cspells(idx).spell.id <> splNone Then
         lvl = cinfo.cspells(idx).spell.lvl
         ret = cinfo.cspells(idx).spell.splsname
      EndIf
   EndIf
   
   Return ret   
End Function

'Returns an empty slot or wNone.
Function GetFreeSlot(inv As invtype, msg As String) As wieldpos
   Dim As wieldpos rslot
   Dim As String desc
   Dim As invtype inv2
   
   'Get item description.
   desc = GetInvItemDesc(inv)
   msg = desc
   'Get the slot for the inventory item.
   rslot = GetInvWSlot(inv, 1)
   If rslot <> wNone Then
      'Check character to see if slot is open.
      If HasInvItem(rslot) = TRUE Then
         rslot = wNone
      EndIf
   End If
   'Check slot two.
   If rslot = wNone Then
      rslot = GetInvWSlot(inv, 2)
      If rslot <> wNone Then
         'Check character to see if slot is open.
         If HasInvItem(rslot) = TRUE Then
            rslot = wNone
         End If
      EndIf
   EndIf
   'Found an empty slot.
   If rslot <> wNone Then
      'Check to see if this is a weapon and how many hands it has.
      If inv.classid = clWeapon Then
         If inv.weapon.hands = 2 Then
            If (HasInvItem(wPrimary) = TRUE) Or (HasInvItem(wSecondary) = TRUE) Then
               msg = "Not enough free hands to equip " & desc & "."
               rslot = wNone
            EndIf
         EndIf
      ElseIf (inv.classid = clArmor) Or (inv.classid = clShield) Then
         If CanWear(inv) = FALSE Then
            msg = "Not enough strength to equip " & desc & "."
            rslot = wNone
         End If
      End If
   Else
      msg = "No empty slots to equip " & desc & "."
   EndIf
   
   Return rslot
End Function

'Returns the spell at index.
Function GetLearnedSpell(idx As Integer) As spelltype
   Dim As spelltype ret
   
   'Validate the index.
   If (idx >= LBound(cinfo.cspells)) And (idx <= UBound(cinfo.cspells)) Then
      ret = cinfo.cspells(idx).spell
   EndIf
   
   Return ret
End Function



