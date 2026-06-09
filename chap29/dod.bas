/'****************************************************************************
*
* Name: dod.bas
*
* Synopsis: Dungeon of Doom
*
* Description: A basic roguelike as detailed in the wikibook, Let's Build a 
*              Roguelike. This is the main program file.
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
#Include "fbgfx.bi"
#Include "vec.bi"
#Include "mainback.bi"
#Include "leatherback.bi"
#Include "title.bi"
#Include "defs.bi"
#Include "twidgets.bi"
#Include "utils.bi"
#Include "mmenu.bi"
#Include "inv.bi"
#Include "character.bi"
#Include "monster.bi"
#Include "map.bi"
#Include "intro.bi"

'Displays the game title screen.
Sub DisplayTitle
   Dim As String txt
   Dim As Integer tx, ty
   
   'Set up the copyright notice.
   txt = "Copyright (C) 2010, by Richard D. Clark"
   tx = CenterX(txt)
   ty = txrows - 2
   'Lock the screen while we update it.
   ScreenLock
   'Draw the background.
   DrawBackground title()
   'Draw the copyright notice.
   Draw String (tx * charw, ty * charh), txt, fbYellow
   ScreenUnlock
   Sleep
   'Clear the key buffer.
   ClearKeys
End Sub

'Draws the main game screen.
Sub DrawMainScreen ()
   Dim As Integer x, y, j, pct, row, col
   Dim As Double pctd
   Dim As UInteger clr
   Dim As String txt, idesc
   Dim As terrainids terr
   Dim inv As invtype
   Dim spl As spelltype
   
   ScreenLock
	'Set the background for the main screen.
	DrawBackground mainback()
   level.DrawMap
   'Draw the message area.
   PrintMessage ""
   'Draw the information area.
   y = 2
   For j = 0 To vh - 1
      For x = vw + 3 To txcols - 1
         PutText acBlock, y + j, x, fbBlack
      Next
   Next
   'Draw the level number.
   DrawStringShadow charw, 0, "Dungeon Level: " & level.LevelID & " of " & maxlevel 
   'Draw the character name.
   row = 1
   col = vw + 4
   PutTextShadow pchar.CharName, row, col, fbYellowBright
   row += 2 
   'Draw the character health bar.
   pctd = pchar.CurrHP / pchar.MaxHP
   pct = Int(pctd * 100) 
   If pct > 74 Then
   	clr = fbGreen
   ElseIf (pct > 24) And (pct < 75) Then
   	clr = fbYellow
   Else
   	clr = fbRed
   EndIf
   'Build the health bar.
   txt = String((txcols - 1) - (col + 6), acBlock)
   PutText "      " & txt, row, col, fbBlack
   txt = String((txcols - 1) - (col + 6), Chr(176))
   PutText "      " & txt, row, col, fbGray
   txt = String(Len(txt) * pctd, acBlock)
   PutText "      " & txt, row, col, clr
   PutText "HP:   ", row, col
   'Draw the health amount.
   txt = pchar.CurrHP & "/" & pchar.MaxHP
   DrawStringShadow (txcols - (Len(txt) + 2)) * charw, (row - 1) * charh, txt
   'Draw the mana bar.
   row += 2
   pctd = pchar.CurrMana / pchar.MaxMana
   pct = Int(pctd * 100) 
   If pct > 74 Then
   	clr = fbGreen
   ElseIf (pct > 24) And (pct < 75) Then
   	clr = fbYellow
   Else
   	clr = fbRed
   EndIf
   'Build the health bar.
   txt = String((txcols - 1) - (col + 6), acBlock)
   PutText "      " & txt, row, col, fbBlack
   txt = String((txcols - 1) - (col + 6), Chr(176))
   PutText "      " & txt, row, col, fbGray
   txt = String(Len(txt) * pctd, acBlock)
   PutText "      " & txt, row, col, clr
   PutText "Mana: ", row, col
   'Draw the health amount.
   txt = pchar.CurrMana & "/" & pchar.MaxMana
   DrawStringShadow (txcols - (Len(txt) + 2)) * charw, (row - 1) * charh, txt
   'Draw the main stats.
   row += 2
   PutText "Stats", row, col, fbYellowBright
   If pchar.Poisoned = TRUE Then
      PutText "(Poisoned)", row, txcols - Len("(Poisoned)") - 1, fbRedBright
   End If
   row += 2
   If pchar.BonStr > -1 Then
      txt = " +"
   Else
      txt = " -"
   EndIf
   PutText "Str: " & pchar.CurrStr & txt & pchar.BonStr & " (" & pchar.BonStrCnt & ")", row, col
   row += 1
   If pchar.BonSta > -1 Then
      txt = " +"
   Else
      txt = " -"
   EndIf
   PutText "Sta: " & pchar.CurrSta & txt & pchar.BonSta & " (" & pchar.BonStaCnt & ")", row, col
   row += 1
   If pchar.BonDex > -1 Then
      txt = " +"
   Else
      txt = " -"
   EndIf
   PutText "Dex: " & pchar.CurrDex & txt & pchar.BonDex & " (" & pchar.BonDexCnt & ")", row, col
   row += 1
   If pchar.BonAgl > -1 Then
      txt = " +"
   Else
      txt = " -"
   EndIf
   PutText "Agl: " & pchar.CurrAgl & txt & pchar.BonAgl & " (" & pchar.BonAglCnt & ")", row, col
   row += 1
   If pchar.BonInt > -1 Then
      txt = " +"
   Else
      txt = " -"
   EndIf
   PutText "Int: " & pchar.CurrInt & txt & pchar.BonInt  & " (" & pchar.BonIntCnt & ")", row, col
   row += 1
   PutText "Curr XP: " & pchar.CurrXP, row, col 
   
   row += 2
   PutText "Combat Factors", row, col, fbYellowBright
   row += 2
   If pchar.BonUcf > -1 Then
      txt = " +"
   Else
      txt = " -"
   EndIf
   PutText "UCF: " & pchar.CurrUcf & txt & pchar.BonUcf  & " (" & pchar.BonUcfCnt & ")", row, col
   row += 1
   If pchar.BonAcf > -1 Then
      txt = " +"
   Else
      txt = " -"
   EndIf
   PutText "ACF: " & pchar.CurrAcf & txt & pchar.BonAcf & " (" & pchar.BonAcfCnt & ")", row, col
   row += 1
   If pchar.BonPcf > -1 Then
      txt = " +"
   Else
      txt = " -"
   EndIf
   PutText "PCF: " & pchar.CurrPcf & txt & pchar.BonPcf & " (" & pchar.BonPcfCnt & ")", row, col
   row += 1
   If pchar.BonMcf > -1 Then
      txt = " +"
   Else
      txt = " -"
   EndIf
   PutText "MCF: " & pchar.CurrMcf & txt & pchar.BonMcf & " (" & pchar.BonMcfCnt & ")", row, col
   row += 1
   If pchar.BonCdf > -1 Then
      txt = " +"
   Else
      txt = " -"
   EndIf
   PutText "CDF: " & pchar.CurrCdf & txt & pchar.BonCdf & " (" & pchar.BonCdfCnt & ")", row, col
   row += 1
   If pchar.BonMdf > -1 Then
      txt = " +"
   Else
      txt = " -"
   EndIf
   PutText "MDF: " & pchar.CurrMdf & txt & pchar.BonMdf & " (" & pchar.BonMdfCnt & ")", row, col
   row += 2
   PutText "Equipment", row, col, fbYellowBright
   row += 2
   PutText "Gold: " & pchar.CurrGold, row, col
   row += 1
   'Check for held item.
   If pchar.HasInvItem(wPrimary) = TRUE Then
      pchar.GetInventoryItem wPrimary, inv
      idesc = GetInvItemDesc(inv)
      spl = pchar.GetWeaponSpell(wPrimary)
      If spl.id <> splNone Then
         idesc &= " (M)"
      EndIf
   Else
      idesc = ""
   EndIf
   PutText "Primary: " & idesc, row, col
   row += 1
   If pchar.HasInvItem(wSecondary) = TRUE Then
      pchar.GetInventoryItem wSecondary, inv
      idesc = GetInvItemDesc(inv)
      spl = pchar.GetWeaponSpell(wSecondary)
      If spl.id <> splNone Then
         idesc &= " (M)"
      EndIf
   Else
      idesc = ""
   EndIf
   PutText "Secondary: " & idesc, row, col
   row += 1
   If pchar.HasInvItem(wArmor) = TRUE Then
      pchar.GetInventoryItem wArmor, inv
      idesc = GetInvItemDesc(inv)
   Else
      idesc = ""
   EndIf
   PutText "Armor: " & idesc, row, col
   row += 1
   If pchar.HasInvItem(wNeck) = TRUE Then
      pchar.GetInventoryItem wNeck, inv
      idesc = GetInvItemDesc(inv)
   Else
      idesc = ""
   EndIf
   PutText "Neck: " & idesc, row, col
   row += 1
   If pchar.HasInvItem(wRingRt) = TRUE Then
      pchar.GetInventoryItem wRingRt, inv
      idesc = GetInvItemDesc(inv)
   Else
      idesc = ""
   EndIf
   PutText "Ring RT: " & idesc, row, col
   row += 1
   If pchar.HasInvItem(wRingLt) = TRUE Then
      pchar.GetInventoryItem wRingLt, inv
      idesc = GetInvItemDesc(inv)
   Else
      idesc = ""
   EndIf
   PutText "Ring LT: " & idesc, row, col
   row += 2
   PutText "Commands", row, col, fbYellowBright
   row += 2
   PutText "Move:.Arrows or Numpad", row, col
   row += 1
   PutText "?.....Help", row, col
   row += 1
   PutText "i.....Inventory", row, col
   row += 1
   PutText "x.....Improve Character", row, col
   row += 2
   PutText ">.....Down Level", row, col
   row += 1
   PutText "<.....Up Level", row, col
   row += 1
   PutText "n.....Inspect Tile", row, col
   row += 1
   PutText "s.....Search Area", row, col
   row += 1
   PutText "t.....Target Enemy", row, col
   row += 1
   PutText "l.....Load Projectile", row, col
   row += 1
   PutText "c.....Cast Spell", row, col
   row += 1
   PutText "g.....Get Item", row, col
   row += 1
   PutText "p.....Pick Lock", row, col
   row += 1
   PutText "b.....Bash Door", row, col
   row += 1
   PutText "r.....Rest (1 Mana = 1 HP)", row, col
   'Check to see if character standing on an item.
   If level.HasItem(pchar.Locx, pchar.Locy) = TRUE Then
      txt = level.GetItemDescription(pchar.Locx, pchar.Locy)
      PrintMessage txt
   Else
      'See if character is on special tile.
      terr = level.GetTileID(pchar.Locx, pchar.Locy)
      If (terr = tstairup) Or (terr = tstairdn) Then
         txt = level.GetTerrainDescription(pchar.Locx, pchar.Locy)
         PrintMessage txt
      End If
   EndIf
   ScreenUnLock
End Sub

'Draws the player inventory.
Sub DrawInventoryScreen()
   Dim As Integer col, row, iitem, ret, srow, ssrow, cnt, i, savrow
   Dim As String txt, txt2, desc
   Dim As invtype inv
   Dim As UInteger clr
   Dim spl As spelltype
   
   ScreenLock
	'Set the background for the inventory screen.
	DrawBackground leatherback()
	'Add the title.
	txt = "Current Inventory for " & Trim(pchar.CharName)
   col = CenterX(txt)
   row = 1
   'Draw title with drop shadow.
   PutTextShadow txt, row, col, fbYellowBright
   'Add the current held equipment.   
   col = 2
   row += 3
   savrow = row 'Save the row location.
   'Iterate through all held items printing descriptions.
   For i = wPrimary To wRingLt
      If i = wPrimary Then
         txt = i & " Primary: "
      ElseIf i = wSecondary Then
         txt = i & " Secondary: "
      ElseIf i = wArmor Then
         txt = i & " Armor: "
      ElseIf i = wNeck Then
         txt = i & " Neck: "
      ElseIf i = wRingRt Then
         txt = i & " Ring Right: "
      ElseIf i = wRingLt Then
         txt = i & " Ring Left: "
      EndIf
      desc = ""
      'See if there is an inventory item.
      iitem = pchar.HasInvItem(i)
      If iitem = TRUE Then
         'Get the inv item.
         pchar.GetInventoryItem i, inv
         'Is the item evaluated.
         ret = IsEval(inv)
         'Get the description.
         desc = GetInvItemDesc(inv)
         'Get the color of the item.
         clr = inv.iconclr
         'Build the text string.
         txt &= desc
         'If not evaluated, mark so player knows it hasn't been evaluated.
         If ret = FALSE Then
            txt &= "(*)"
         Else
            'If magic mark it.
            If inv.classid = clWeapon Then
               If inv.weapon.spell.id <> splNone Then
                  txt &= " (M)"
               End If
            EndIf
         EndIf
      Else
         clr = fbWhite
      End If
      PutTextShadow txt, row, col, clr
      row += 2
      If i = wArmor Then
         col = txcols / 2
         row = savrow
      EndIf
   Next
   'Draw the divider line.
   row += 2
   col = 1 
   txt = String(80, Chr(205))
   Mid(txt, 2) = " Equipment  (*) Not Evaluated - (M) Magic Item "
   txt2 = " Gold: " & pchar.CurrGold & " "
   Mid(txt, 80 - Len(txt2)) = txt2
   PutTextShadow txt, row, col, fbYellowBright
   row += 2
   col = 2
   srow = row
   'Print out the inventory items.
   For i = pchar.LowInv To pchar.HighInv
      'See if character has item in slot.
      iitem = pchar.HasInvItem(i)
      If iitem = TRUE Then
         'Get the inv item.
         pchar.GetInventoryItem i, inv
         'Is the item evaluated.
         ret = IsEval(inv)
         'Get the description.
         desc = GetInvItemDesc(inv)
         'Get the color of the item.
         clr = inv.iconclr
         'Build the text string.
         txt = Chr(i) & " " & desc & " "
         'If not evaluated, mark so player knows it hasn't been evaluated.
         If ret = FALSE Then
            txt &= "(*)"
         Else
            'If we have some ammo print out the amount.
            If inv.classid = clAmmo Then
               txt &= "(" & inv.ammo.cnt & ")"
            EndIf
            'If magic mark it.
            If inv.classid = clWeapon Then
               If inv.weapon.spell.id <> splNone Then
                  txt &= " (M)"
               End If
            EndIf
         EndIf
      Else
         txt = Chr(i)
         clr = fbWhite
      EndIf
      'Move column over when reached half of the list.
      cnt += 1
      If cnt =  14 Then
         col = txcols / 2
         'Save the end of the first column so we can draw line.
         ssrow = row
         row = srow
      EndIf
      'Draw the text.
      PutTextShadow txt, row, col, clr
      row += 2
   Next
   'Draw the divider line.
   row = ssrow + 1
   col = 1
   txt = String(80, Chr(205))
   Mid(txt, 2) = " Spells Learned "
   PutTextShadow txt, row, col, fbYellowBright
   'Draw the spell slots.
   col = 2
   row += 2
   cnt = 0
   srow = row
   For i = 65 To 90
      txt = Chr(i)
      'Draw the text.
      PutTextShadow txt, row, col, clr
      row += 2
      cnt += 1
      'Move column over if list section reached.
      If (cnt Mod 6) = 0 Then
         col += 15
         'Save the end of the first column so we can draw line.
         ssrow = row
         row = srow
      EndIf
   Next
   'Draw the divider line.
   row = ssrow + 1
   col = 1
   txt = String(80, Chr(205))
   Mid(txt, 2) = " Commands "
   PutTextShadow txt, row, col, fbYellowBright
   'Draw the command list
   row += 2
   txt = "(D)rop - E(v)al - E(q)uip - (U)nequip - (R)ead - (E)at/Drink - (I)spect"
   col = CenterX(txt)
   PutTextShadow txt, row, col, fbWhite
   ScreenUnLock
End Sub

'Processes the eval command.
Function ProcessEval() As Integer
   Dim As String res, mask, desc, ch
   Dim As Integer i, iret, iitem, evaldr, pint, rollp, rolle, ret = FALSE
   Dim As invtype inv
   Dim As tWidgets.btnID btn
   Dim As tWidgets.tInputbox ib
      
   'Make sure there is something to evaluate in the inventory.
   For i = pchar.LowInv To pchar.HighInv
      iitem = pchar.HasInvItem(i)
      If iitem = TRUE Then
         'Get the inv item.
         pchar.GetInventoryItem i, inv
         'Is the item evaluated.
         iret = IsEval(inv)
         'An item to evaluate.
         If iret = FALSE Then
            'Build the mask.
            mask &= Chr(i)
         End If
      EndIf
   Next
   'Add any held items.
   For i = wPrimary To wRingLt
      iitem = pchar.HasInvItem(i)
      If iitem = TRUE Then
         'Get the inv item.
         pchar.GetInventoryItem i, inv
         'Is the item evaluated.
         iret = IsEval(inv)
         'An item to evaluate.
         If iret = FALSE Then
            'Build the mask.
            mask &= Str(i)
         End If
      EndIf
   Next
   If Len(mask) = 0 Then
      ShowMsg "Evaluate", "Nothing to evaluate.", tWidgets.MsgBoxType.gmbOK
   Else
      'Draws an input box on screen.
      ib.Title = "Evaluate"
      ib.Prompt = "Select item(s) to evaluate (" & mask & ")"
      ib.Row = 39
      ib.EditMask = mask
      ib.MaxLen = Len(mask)
      ib.InputLen = Len(mask)
      btn = ib.Inputbox(res)
      'Evaluate each item in the list.
      If (btn <> tWidgets.btnID.gbnCancel) And (Len(res) > 0) Then
         'Evaluate the list of items.
         For i = 1 To Len(res)
            ch = Mid(res, i, 1)
            If InStr("123456", ch) > 0 Then
               iitem = Val(ch) 'Get index into hel inventory.
            Else
               iitem = Asc(ch) 'Get index into character inventory.
            EndIf
            'Get the inv item.
            pchar.GetInventoryItem iitem, inv
            'Get the eval DR.
            evalDR = GetEvalDR(inv)
            'Use the intelligence attribute to calculate the eval attempt.
             pint = pchar.CurrInt + pchar.BonInt
             'Roll for evaldr.
             rolle = RandomRange(0, evalDR)
             'Roll for player.
             rollp = RandomRange(0, pint)
             'Get the item description.
             desc = GetInvItemDesc(inv)
             'If the player rolls => eval roll, item is evaluated.
             If rollp > rolle Then
               desc &= " was succesfully evaluated."
               ShowMsg "Evaluate", desc, tWidgets.MsgBoxType.gmbOK    
               SetInvEval inv, TRUE 'Set eval to true.
               pchar.AddInvItem iitem, inv 'Put item back into inv.
               ret = TRUE 'Flag caller that screen has changed.
             Else
                desc &= " was not evaluated."
               ShowMsg "Evaluate", desc, tWidgets.MsgBoxType.gmbOK    
             EndIf
         Next
      EndIf
   EndIf
   
   Return ret
End Function

'Processes the eat/drink command.
Function ProcessEatDrink() As Integer
   Dim As String res, mask, desc
   Dim As Integer i, iret, iitem, ret = FALSE
   Dim As invtype inv
   Dim As tWidgets.btnID btn
   Dim As tWidgets.tInputbox ib
      
   'Make sure there is something to evaluate in the inventory.
   For i = pchar.LowInv To pchar.HighInv
      iitem = pchar.HasInvItem(i)
      If iitem = TRUE Then
         'Get the inv item.
         pchar.GetInventoryItem i, inv
         'Is the item evaluated.
         iret = MatchUse(inv, useEatDrink)
         'An item to evaluate.
         If iret = TRUE Then
            'Build the mask.
            mask &= Chr(i)
         End If
      EndIf
   Next
   If Len(mask) = 0 Then
      ShowMsg "Eat/Drink", "Nothing to consume.", tWidgets.MsgBoxType.gmbOK
   Else
      'Draws an input box on screen.
      ib.Title = "Eat/Drink"
      ib.Prompt = "Select item(s) to eat/drink (" & mask & ")"
      ib.Row = 39
      ib.EditMask = mask
      ib.MaxLen = Len(mask)
      ib.InputLen = Len(mask)
      btn = ib.Inputbox(res)
      'Evaluate each item in the list.
      If (btn <> tWidgets.btnID.gbnCancel) And (Len(res) > 0) Then
         ret = TRUE
         'Evaluate the list of items.
         For i = 1 To Len(res)
            iitem = Asc(res, i) 'Get index into character inventory.
            'Get the inv item.
            pchar.GetInventoryItem iitem, inv
            desc = pchar.ApplyInvItem(inv) 
            ShowMsg "Eat/Drink", desc, tWidgets.MsgBoxType.gmbOK    
            'Clear the item.
            ClearInv inv
            'Put the item back into inventory.
            pchar.AddInvItem iitem, inv
         Next
      EndIf
   EndIf
   
   Return ret
End Function

'Processes the drop command.
Function ProcessDrop() As Integer
   Dim As String res, mask, desc
   Dim As Integer i, iret, iitem, ret = FALSE
   Dim As invtype inv
   Dim As tWidgets.btnID btn
   Dim As tWidgets.tInputbox ib
   Dim As vec mvec
      
   'Make sure there is something to evaluate in the inventory.
   For i = pchar.LowInv To pchar.HighInv
      iitem = pchar.HasInvItem(i)
      If iitem = TRUE Then
         'Build the mask.
         mask &= Chr(i)
      EndIf
   Next
   If Len(mask) = 0 Then
      ShowMsg "Drop Items", "Nothing to drop.", tWidgets.MsgBoxType.gmbOK
   Else
      'Draws an input box on screen.
      ib.Title = "Drop Items"
      ib.Prompt = "Select item(s) to drop (" & mask & ")"
      ib.Row = 39
      ib.EditMask = mask
      ib.MaxLen = Len(mask)
      ib.InputLen = Len(mask)
      btn = ib.Inputbox(res)
      'Evaluate each item in the list.
      If (btn <> tWidgets.btnID.gbnCancel) And (Len(res) > 0) Then
         'Evaluate the list of items.
         For i = 1 To Len(res)
            iitem = Asc(res, i) 'Get index into character inventory.
            'Get the inv item.
            pchar.GetInventoryItem iitem, inv
             'Get the item description.
             desc = GetInvItemDesc(inv)
            'Look for an empty space on the map.
            iret = level.GetEmptySpot(mvec)
            'Foud an enpty spot.
            If iret = TRUE Then
               'Put the item on the map.
               level.PutItemOnMap mvec.vx, mvec.vy, inv
               'Clear the item.
               ClearInv inv
               'Put the item back into inventory.
               pchar.AddInvItem iitem, inv
               ret = TRUE
               desc &= " was dropped."
               ShowMsg "Drop Items", desc, tWidgets.MsgBoxType.gmbOK
            Else
               'No empty spots.
               desc = "No empty map tiles to drop item."
               ShowMsg "Drop Items", desc, tWidgets.MsgBoxType.gmbOK
               Exit For
            EndIf
         Next
      EndIf
   EndIf
   
   Return ret
End Function

'Print message to user using msgbox.
Sub ShowMsgLines(title As String, mess() As String, mtype As tWidgets.MsgBoxType)
   Dim As tWidgets.tMsgbox mb
   Dim As tWidgets.btnID btn

   mb.MessageStyle = mtype
   mb.Title = title
   btn = mb.MessageBox(mess())
   
End Sub

'Processes the inspect command.
Function ProcessInspect() As Integer
   Dim As String res, mask, desc, ch
   Dim As Integer i, iitem, ret = FALSE
   Dim As invtype inv
   Dim As tWidgets.btnID btn
   Dim As tWidgets.tInputbox ib
   Dim lines() As String
      
   'Make sure there is something to evaluate in the inventory.
   For i = pchar.LowInv To pchar.HighInv
      iitem = pchar.HasInvItem(i)
      If iitem = TRUE Then
         'Build the mask.
         mask &= Chr(i)
      EndIf
   Next
   'Add any held items.
   For i = wPrimary To wRingLt
      iitem = pchar.HasInvItem(i)
      If iitem = TRUE Then
         'Build the mask.
         mask &= Str(i)
      EndIf
   Next
   If Len(mask) = 0 Then
      ShowMsg "Inpsect Items", "Nothing to inspect.", tWidgets.MsgBoxType.gmbOK
   Else
      'Draws an input box on screen.
      ib.Title = "Inspect Items"
      ib.Prompt = "Select item(s) to inspect (" & mask & ")"
      ib.Row = 39
      ib.EditMask = mask
      ib.MaxLen = Len(mask)
      ib.InputLen = Len(mask)
      btn = ib.Inputbox(res)
      'Evaluate each item in the list.
      If (btn <> tWidgets.btnID.gbnCancel) And (Len(res) > 0) Then
         'Evaluate the list of items.
         For i = 1 To Len(res)
            ch = Mid(res, i, 1)
            If InStr("123456", ch) > 0 Then
               iitem = Val(ch) 'Get index into hel inventory.
            Else
               iitem = Asc(ch) 'Get index into character inventory.
            EndIf
            'Get the inv item.
            pchar.GetInventoryItem iitem, inv
            GetFullDesc lines(), inv
            If UBound(lines) > 0 Then
               ShowMsgLines "Inspect Items", lines(), tWidgets.MsgBoxType.gmbOK
            EndIf
         Next
      EndIf
   EndIf
   
   Return ret
End Function

'Process the unequip menu item.
Function ProcessUnEquip() As Integer
   Dim As String res, mask, desc
   Dim As Integer i, iret, iitem, ret = FALSE
   Dim As invtype inv
   Dim As tWidgets.btnID btn
   Dim As tWidgets.tInputbox ib
   Dim As vec mvec
      
   'Make sure there is something to process in the inventory.
   For i = wPrimary To wRingLt
      iitem = pchar.HasInvItem(i)
      If iitem = TRUE Then
         'Build the mask.
         mask &= Str(i)
      EndIf
   Next
   If Len(mask) = 0 Then
      ShowMsg "Unequip Items", "Nothing to unequip.", tWidgets.MsgBoxType.gmbOK
   Else
      'Draws an input box on screen.
      ib.Title = "Unequip Items"
      ib.Prompt = "Select item(s) to unequip (" & mask & ")"
      ib.Row = 39
      ib.EditMask = mask
      ib.MaxLen = Len(mask)
      ib.InputLen = Len(mask)
      btn = ib.Inputbox(res)
      'Evaluate each item in the list.
      If (btn <> tWidgets.btnID.gbnCancel) And (Len(res) > 0) Then
         'Evaluate the list of items.
         For i = 1 To Len(res)
            iitem = Val(Mid(res, i, 1)) 'Get index into character inventory.
            'Get the inv item.
            pchar.GetInventoryItem iitem, inv
            'Get the item description.
            desc = GetInvItemDesc(inv)
            'Look for an empty inventory slot.
            iret = pchar.GetFreeInventoryIndex
            'Did we find an empty slot?
            If iret > -1 Then
               'Put the item back into inventory.
               pchar.AddInvItem iret, inv
               'Clear the item.
               ClearInv inv
               'Update the held slot.
               pchar.AddInvItem iitem, inv
               ret = TRUE
               desc &= " was unequipped."
               ShowMsg "Unequip Items", desc, tWidgets.MsgBoxType.gmbOK
            Else
               'No empty spots.
               desc = "No empty inventory slots to unequip item."
               ShowMsg "Unequip Items", desc, tWidgets.MsgBoxType.gmbOK
               Exit For
            EndIf
         Next
      EndIf
   EndIf
   
   Return ret
End Function

'Process the equip menu item.
Function ProcessEquip() As Integer
   Dim As String res, mask, desc, msg
   Dim As Integer i, iret, iitem, idx, ret = FALSE, freecnt
   Dim As invtype inv
   Dim As tWidgets.btnID btn
   Dim As tWidgets.tInputbox ib
   Dim As vec mvec
   Dim slot As Integer
      
   'Make sure there is something to process in the inventory.
   For i = pchar.LowInv To pchar.HighInv
      iitem = pchar.HasInvItem(i)
      If iitem = TRUE Then
         'Get the inv item.
         pchar.GetInventoryItem i, inv
         'Is the item evaluated.
         iret = MatchUse(inv, useWieldWear)
         'An item to evaluate.
         If iret = TRUE Then
            'Build the mask.
            mask &= Chr(i)
         End If
      EndIf
   Next
   If Len(mask) = 0 Then
      ShowMsg "Equip Items", "Nothing to equip.", tWidgets.MsgBoxType.gmbOK
   Else
      'Draws an input box on screen.
      ib.Title = "Equip Items"
      ib.Prompt = "Select item(s) to equip (" & mask & ")"
      ib.Row = 39
      ib.EditMask = mask
      ib.MaxLen = Len(mask)
      ib.InputLen = Len(mask)
      btn = ib.Inputbox(res)
      'Evaluate each item in the list.
      If (btn <> tWidgets.btnID.gbnCancel) And (Len(res) > 0) Then
         'Evaluate the list of items.
         For i = 1 To Len(res)
            iitem = Asc(res, i) 'Get index into inventory.
            'Get the inv item.
            pchar.GetInventoryItem iitem, inv
            'Get the item description.
            desc = GetInvItemDesc(inv)
            iret = FALSE
            idx = 0
            'Check slot 1.
            slot = GetInvWSlot(inv, 1)
            If slot <> wNone Then
               'Check character to see if slot is open.
               If pchar.HasInvItem(slot) = FALSE Then
                  idx = slot
                  iret = TRUE
               EndIf
            End If
            'Check second slot.
            If iret = FALSE Then
               'Check slot 2.
               slot = GetInvWSlot(inv, 2)
               If slot <> wNone Then
                  'Check character to see if slot is open.
                  If pchar.HasInvItem(slot) = FALSE Then
                     idx = slot
                     iret = TRUE
                  EndIf
               End If
            EndIf
            'No empty slots.
            If iret = FALSE Then
               msg = "No empty slots to equip " & desc & "."
            Else
               'Check to see if this is a weapon and how many hands it has.
               If inv.classid = clWeapon then
                  freecnt = 0
                  'Check free slots.
                  If pchar.HasInvItem(wPrimary) = FALSE Then
                     freecnt += 1
                  EndIf
                  If pchar.HasInvItem(wSecondary) = FALSE Then
                     freecnt += 1
                  EndIf
                  If inv.weapon.hands > freecnt Then
                     iret = FALSE
                     msg = "Not enough free hands to equip " & desc & "."
                  EndIf
               End If
               'Check to see if character can wear armor
               If inv.classid = clArmor Or inv.classid = clShield Then
                  If pchar.CanWear(inv) = FALSE Then
                     iret = FALSE
                     msg = "Not enough strength to equip " & desc & "."
                  End If
               EndIf
            End If
            'Did we find an empty slot?
            If iret = TRUE Then
               'Put the item wield position.
               pchar.AddInvItem idx, inv
               'Clear the item.
               ClearInv inv
               'Update the held slot.
               pchar.AddInvItem iitem, inv
               ret = TRUE
               desc &= " was equipped."
               ShowMsg "Equip Items", desc, tWidgets.MsgBoxType.gmbOK
            Else
               ShowMsg "Equip Items", msg, tWidgets.MsgBoxType.gmbOK
            End If
         Next
      EndIf
   EndIf
   
   Return ret
End Function

'Manages character inventory.
Sub ManageInventory()
   Dim As String kch, ich
   Dim As Integer ret
   
   DrawInventoryScreen
   Do
      kch = InKey
      kch = UCase(kch)
      'Check to see if we have a key.
      If kch <> "" Then
         'Process the eval command.
         If kch = "V" Then
            ret = ProcessEval()
            'Screen changed.
            If ret = TRUE Then
               DrawInventoryScreen
            EndIf
         EndIf
         'Process the eat and drink command.
         If kch = "E" Then
            ret = ProcessEatDrink()
            'Screen changed.
            If ret = TRUE Then
               DrawInventoryScreen
            EndIf
         EndIf
         'Process drop command.
         If kch = "D" Then
            ret = ProcessDrop()
            'Screen changed.
            If ret = TRUE Then
               DrawInventoryScreen
            EndIf
         EndIf
         'Process inspect command.
         If kch = "I" Then
            ret = ProcessInspect()
            'Screen changed.
            If ret = TRUE Then
               DrawInventoryScreen
            EndIf
         EndIf
         'Process unequip item.
         If kch = "U" Then
            ret = ProcessUnequip()
            'Screen changed.
            If ret = TRUE Then
               DrawInventoryScreen
            EndIf
         EndIf
         'Process equip item.
         If kch = "Q" Then
            ret = ProcessEquip()
            'Screen changed.
            If ret = TRUE Then
               DrawInventoryScreen
            EndIf
         EndIf
      EndIf
      Sleep 1
   Loop Until kch = key_esc
   ClearKeys
End Sub

'Opens a closed door if not locked.
Function OpenDoor (x As Integer, y As Integer) As Integer
   Dim As Integer ret = TRUE, doorlocked
   
  'Check for locked door.
   doorlocked = level.IsDoorLocked(x, y)
   If doorlocked = FALSE Then
      'Open the door.
      level.SetTile x, y, tdooropen
   Else
      'Door is locked and cannot be opened.
      ret = FALSE
   End If
   
   Return ret
End Function

'Applies any active weapon spell.
Function DoWeaponSpell (spl As spelltype, mx As Integer, my As Integer) As Integer
   Dim As Integer ret = FALSE, statamt, rstat
   Dim As monStats mstat
   Dim As String splname
   
   If spl.id = splThief Then
      'Get random stat.
      mstat = RandomRange(CombatFactor, MagicDefense)
      statamt = level.GetMonsterStatAmt(mstat, mx, my)
      rstat = RandomRange(1, statamt - 1)
      'Add stat amount to char for lvl turns.
      Select Case mstat
         Case CombatFactor
            pchar.BonAcf = rstat
            pchar.BonAcfCnt = spl.lvl
         Case CombatDefense
            pchar.BonCdf = rstat
            pchar.BonCdfCnt = spl.lvl
         Case MagicCombat
            pchar.BonMcf = rstat
            pchar.BonMcfCnt = spl.lvl
         Case MagicDefense
            pchar.BonMdf = rstat
            pchar.BonMdfCnt = spl.lvl
      End Select
   Else
      'Apply spell to monster.
      ret = level.ApplySpell(spl, mx, my)
   EndIf
   
   Return ret
      
End Function

'Perform melee combat.
Sub DoMeleeCombat(mx As Integer, my As Integer)
   Dim As Integer cf, df, croll, mroll, dam, isdead, midx, mxp, xp 
   Dim As String txt, mname
   Dim As Single marm
   Dim As spelltype spl1, spl2
   
   'Get the monster defense factor.
   df = level.GetMonsterDefense(mx, my)
   mname = level.GetMonsterName(mx, my)
   'Get monster xp.
   mxp = level.GetMonsterXP(mx, my)
   'Make sure we got something.
   If df > 0 Then
      'Returns the combat factor based on what the character is holding.
      cf = pchar.GetMeleeCombatFactor()
      'Get the rolls.
      croll = RandomRange(1, cf)
      mroll = RandomRange(1, df)
      'See if the character hit monster.      
      If croll > mroll Then
         'Get total weapon damage.
         dam = pchar.GetWeaponDamage()
         'Get monster armor rating.
         marm = level.GetMonsterArmor(mx, my)
         'Adjust the damage value based on arnor rating.
         dam = dam - (dam * marm)
         If dam <= 0 Then dam = 1
         'Check for magic weapon in both slots. Only returns if evaluated.
         spl1 = pchar.GetWeaponSpell(wPrimary)
         spl2 = pchar.GetWeaponSpell(wSecondary)
         'Check for goliath spell.
         If spl1.id = splGoliath Then dam += pchar.CurrStr
         If spl2.id = splGoliath Then dam += pchar.CurrStr
         'Set the monster hp.
         isdead = level.ApplyDamage(mx, my, dam)
         'Make sure monster is still alive.
         If isdead = FALSE Then
            'Apply any spells.
            If spl1.id <> splNone Then
               isdead = DoWeaponSpell(spl1, mx, my)
            EndIf
            If isdead = FALSE Then
               If spl2.id <> splNone Then
                  isdead = DoWeaponSpell(spl2, mx, my)
               End If
            EndIf
         EndIf
         'Print the message.
         If isdead = TRUE Then
            'Add xp amount to character.
            xp = pchar.CurrXP
            xp += mxp
            pchar.CurrXP = xp
            xp = pchar.TotXP
            xp += mxp
            pchar.TotXP = xp
            'Print message.
            txt = pchar.CharName & " killed the " & mname & " with " & dam & " damage points."
            PrintMessage txt
         Else
            txt = pchar.CharName & " hit the " & mname & " for " & dam & " damage points."
            PrintMessage txt
         EndIf
      Else
         txt = pchar.CharName & " missed the " & mname & "."
         PrintMessage txt
      EndIf
   EndIf
End Sub

'Move the character based on the compass direction.
Function MoveChar(comp As compass) As Integer
   Dim As Integer ret = FALSE, block
   Dim As vec vc = vec(pchar.Locx, pchar.Locy) 'Creates a vector object.
   Dim As terrainids tileid
   Dim As Integer snd
   
   vc+= comp
   'Check to make sure we don't move off map.
   If (vc.vx >= 1) And (vc.vx <= mapw) Then
      If (vc.vy >= 1) And (vc.vy <= maph) Then
         'Check for blocking tile.
         block = level.IsBlocking(vc.vx, vc.vy)
         'Check for monster.
         If block = FALSE Then
            block = level.IsMonster(vc.vx, vc.vy)
            'Check to see if we bumped into a monster.
            If block = TRUE Then
               'Attack the monster.
               DoMeleeCombat vc.vx, vc.vy
               ret = TRUE
            EndIf
         EndIf
         'Move character.
         If block = FALSE Then
            'Set the new character position.
            pchar.Locx = vc.vx
            pchar.Locy = vc.vy
            ret = TRUE
            'Generate the sound map.
            level.ClearSoundMap
            snd = pchar.GetNoise()
            level.GenSoundMap(pchar.Locx, pchar.Locy, snd)
         Else 'Check for special tiles.
            'Get tile id.
            tileid = level.GetTileID(vc.vx, vc.vy)
            Select Case tileid
               Case tdoorclosed 'Check for closed door.
                  ret = OpenDoor(vc.vx, vc.vy)
                  'If false then print message.
                  If ret = FALSE Then
                     'print message here.
                  Else
                     'Set the new character position.
                     pchar.Locx = vc.vx
                     pchar.Locy = vc.vy
                     ret = TRUE
                     'Generate the sound map.
                     level.ClearSoundMap
                     snd = pchar.GetNoise()
                     level.GenSoundMap(pchar.Locx, pchar.Locy, snd)
                  EndIf
               Case tstairup 'Enable move onto up stairs.
                  'Set the new character position.
                  pchar.Locx = vc.vx
                  pchar.Locy = vc.vy
                  ret = TRUE
                  'Generate the sound map.
                  level.ClearSoundMap
                  snd = pchar.GetNoise()
                  level.GenSoundMap(pchar.Locx, pchar.Locy, snd)
            End Select
         EndIf
      EndIf
   EndIf
   
   Return ret
End Function

'Rests the character by converting 1 mana to 1 hp.
Sub RestCharacter ()
   Dim As Integer cman, chp, thp
   
   'Get the current mana and hp values.
   cman = pchar.CurrMana
   chp = pchar.CurrHP
   thp = pchar.MaxHP
   'Check to see if the character needs to rest.
   If chp = thp Then
      PrintMessage pchar.CharName & " doesn't need to rest."
   Else
      'Make sure we have some mana to spend.
      If cman = 0 Then
         PrintMessage pchar.CharName & " doesn't have any mana to spend."
      Else
         'Decrement the mana and add to hp.
         cman -= 1
         pchar.CurrMana = cman
         chp += 1
         pchar.CurrHP = chp
         PrintMessage pchar.CharName & " spent 1 mana for 1 health point."
      EndIf
   EndIf
End Sub

'Applies XP to character attributes.
Sub ImproveCharacter ()
   Dim As Integer sel, xp
   
   'Make sure we have some xp to work with.
   If pchar.CurrXP > 10 Then
      Do
         If pchar.CurrXP > 10 Then
            'Print Current stats.
            pchar.PrintStats
            PutTextShadow "Cost = 10 XP for 1 point improvement.", 49, 10
            PutTextShadow "Enter attribute 1 to 5 to improve, enter to exit: ", 51, 10
            'Position input.
            Locate 53, 10
            'Get the input.
            Input sel
            'If attribute selected then Change. 
            If sel = 1 Then
               pchar.ChangeStrength 1
               'Subtract the xp amount.
               xp = pchar.CurrXP
               xp -= 10
               pchar.CurrXP = xp 
            EndIf
            If sel = 2 Then
               pchar.ChangeStamina 1
               'Subtract the xp amount.
               xp = pchar.CurrXP
               xp -= 10
               pchar.CurrXP = xp 
            EndIf
            If sel = 3 Then
               pchar.ChangeDexterity 1
               'Subtract the xp amount.
               xp = pchar.CurrXP
               xp -= 10
               pchar.CurrXP = xp 
            EndIf      
            If sel = 4 Then
               pchar.ChangeAgility 1
               'Subtract the xp amount.
               xp = pchar.CurrXP
               xp -= 10
               pchar.CurrXP = xp 
            EndIf
            If sel = 5 Then
               pchar.ChangeIntelligence 1
               'Subtract the xp amount.
               xp = pchar.CurrXP
               xp -= 10
               pchar.CurrXP = xp 
            EndIf
         Else
            sel = 0
         End If
      Loop Until sel = 0
   Else
      PrintMessage "Not enough XP to spend."
   End If
End Sub

'Returns true if character targeted enemy, false if not. Coords passed through vt.
Function GetTargetCoord(vt As vec) As Integer
   Dim As String ch, rtl = "*"
   Dim As vec v, vtmp
   Dim As Integer ret = FALSE
   
   'Set the reticle coordinates.
   v.vx = pchar.Locx
   v.vy = pchar.Locy
   'Set new target.
   level.SetTarget(v.vx, v.vy, Asc(rtl), fbYellowBright)
   level.DrawMap
   Do
      ch = InKey
      If ch <> "" Then
         If ch = key_up Then
            'Set the current vector.
            vtmp = v
            'Update temp vector.
            vtmp += north
            'Check the tile.
            If level.IsTileVisible(vtmp.vx, vtmp.vy) = TRUE Then
               'Clear previous target space.
               level.SetTarget(v.vx, v.vy, 0)
               'Save the current location.
               v = vtmp
               'Set new target.
               level.SetTarget(v.vx, v.vy, Asc(rtl), fbYellowBright)
               'Redraw the map.
               ScreenLock
               level.DrawMap
               ScreenUnLock
            End If
         EndIf
         If ch = key_dn Then
            'Set the current vector.
            vtmp = v
            'Update temp vector.
            vtmp += south
            'Check the tile.
            If level.IsTileVisible(vtmp.vx, vtmp.vy) = TRUE Then
               'Clear previous target space.
               level.SetTarget(v.vx, v.vy, 0)
               'Save the current location.
               v = vtmp
               'Set new target.
               level.SetTarget(v.vx, v.vy, Asc(rtl), fbYellowBright)
               'Redraw the map.
               ScreenLock
               level.DrawMap
               ScreenUnLock
            End If
         EndIf
         If ch = key_rt Then
            'Set the current vector.
            vtmp = v
            'Update temp vector.
            vtmp += east
            'Check the tile.
            If level.IsTileVisible(vtmp.vx, vtmp.vy) = TRUE Then
               'Clear previous target space.
               level.SetTarget(v.vx, v.vy, 0)
               'Save the current location.
               v = vtmp
               'Set new target.
               level.SetTarget(v.vx, v.vy, Asc(rtl), fbYellowBright)
               'Redraw the map.
               ScreenLock
               level.DrawMap
               ScreenUnLock
            End If
         EndIf
         If ch = key_lt Then
            'Set the current vector.
            vtmp = v
            'Update temp vector.
            vtmp += west
            'Check the tile.
            If level.IsTileVisible(vtmp.vx, vtmp.vy) = TRUE Then
               'Clear previous target space.
               level.SetTarget(v.vx, v.vy, 0)
               'Save the current location.
               v = vtmp
               'Set new target.
               level.SetTarget(v.vx, v.vy, Asc(rtl), fbYellowBright)
               'Redraw the map.
               ScreenLock
               level.DrawMap
               ScreenUnLock
            End If
         EndIf
      EndIf
      Sleep 1
   Loop Until (ch = key_enter) Or (ch = key_esc)
   If ch = key_enter Then 
      ret = TRUE
   EndIf
   'Clear previous target space.
   level.SetTarget(v.vx, v.vy, 0)
   level.DrawMap   
   vt = v
   
   Return ret
End Function

'Perform projectile combat.
Sub DoProjectileCombat(mx As Integer, my As Integer, wslot As wieldpos)
   Dim As Integer cf, df, croll, mroll, dam, isdead, midx, mxp, xp 
   Dim As String txt, mname
   Dim As Single marm
   Dim As spelltype spl1, spl2
   
   'Get the monster defense factor.
   If pchar.ProjectileIsWand(wslot) = TRUE Then
      df = level.GetMonsterMagicDefense(mx, my)
   Else
      df = level.GetMonsterDefense(mx, my)
   EndIf
   'Get monster name.
   mname = level.GetMonsterName(mx, my)
   'Get monster xp.
   mxp = level.GetMonsterXP(mx, my)
   'Make sure we got something.
   If df > 0 Then
      'Returns the combat factor based on what the character is holding.
      If pchar.ProjectileIsWand(wslot) = TRUE Then
         cf = pchar.GetMagicCombatFactor()
      Else
         cf = pchar.GetProjectileCombatFactor()
      EndIf
      'Get the rolls.
      croll = RandomRange(1, cf)
      mroll = RandomRange(1, df)
      'See if the character hit monster.      
      If croll > mroll Then
         'Get total weapon damage.
         dam = pchar.GetWeaponDamage(wslot)
         'Get monster armor rating.
         marm = level.GetMonsterArmor(mx, my)
         'Adjust the damage value based on armor rating.
         dam = dam - (dam * marm)
         If dam <= 0 Then dam = 1
         'Check for magic weapon in both slots. Only returns if evaluated.
         spl1 = pchar.GetWeaponSpell(wPrimary)
         spl2 = pchar.GetWeaponSpell(wSecondary)
         'Check for goliath spell.
         If spl1.id = splGoliath Then dam += pchar.CurrStr
         If spl2.id = splGoliath Then dam += pchar.CurrStr
         'Set the monster hp.
         isdead = level.ApplyDamage(mx, my, dam)
         'Make sure monster is still alive.
         If isdead = FALSE Then
            'Apply any spells.
            If spl1.id <> splNone Then
               isdead = DoWeaponSpell(spl1, mx, my)
            EndIf
            If isdead = FALSE Then
               If spl2.id <> splNone Then
                  isdead = DoWeaponSpell(spl2, mx, my)
               End If
            EndIf
         EndIf
         'Print the message.
         If isdead = TRUE Then
            'Add xp amount to character.
            xp = pchar.CurrXP
            xp += mxp
            pchar.CurrXP = xp
            xp = pchar.TotXP
            xp += mxp
            pchar.TotXP = xp
            'Print message.
            txt = pchar.CharName & " killed the " & mname & " with " & dam & " damage points."
            PrintMessage txt
         Else
            txt = pchar.CharName & " hit the " & mname & " for " & dam & " damage points."
            PrintMessage txt
         EndIf
      Else
         txt = pchar.CharName & " missed the " & mname & "."
         PrintMessage txt
      EndIf
   EndIf
End Sub


'Targets an enemy and attacks with projectile weapon.
Sub TargetEnemy ()
   Dim As vec target, source
   Dim As Integer ret
   
   'Check to see if character is carrying projectile weapon.
   If pchar.ProjectileEquipped(wAny) = TRUE Then
      'Get target vector.
      ret = GetTargetCoord(target)
      source.vx = pchar.Locx
      source.vy = pchar.Locy
      'Player pressed enter.
      If ret = TRUE Then
         'Check first slot to see if it has weapon.
         If pchar.ProjectileEquipped(wPrimary) = TRUE Then
            'Make sure it is loaded.
            If pchar.IsLoaded(wPrimary) = TRUE Then
               'Fire the weapon.
               level.AnimateProjectile source, target
               'Remove prjectile from weapon.
               pchar.DecrementAmmo wPrimary
               'Make sure we have targeted a monster.
               If level.IsMonster(target.vx, target.vy) = TRUE Then
                  'Resolve hit if any.
                  DoProjectileCombat target.vx, target.vy, wPrimary
               Else
                  PrintMessage "No monster at target location."
               End If
            Else
               PrintMessage "Weapon is not loaded."
            EndIf
         Else 'Must be second slot.
            'Check to make sure the weapon is loaded.
            If pchar.IsLoaded(wSecondary) = FALSE Then
               'Fire the weapon.
               level.AnimateProjectile source, target
               'Remove prjectile from weapon.
               pchar.DecrementAmmo wSecondary
               'Make sure we have targeted a monster.
               If level.IsMonster(target.vx, target.vy) = TRUE Then
                  'Resolve hit if any.
                  DoProjectileCombat target.vx, target.vy, wPrimary
               Else
                  PrintMessage "No monster at target location."
               End If
            Else
               PrintMessage "Weapon is not loaded."
            EndIf
         EndIf
      EndIf
   Else
      PrintMessage "Not carrying a projectile weapon."
   EndIf
   
   
End Sub

'Loads ammo into projectile weapon.
Sub LoadAmmo ()
   Dim amid As ammoids
   Dim As Integer ret
   
   'Make sure character has projectile weapon.
   If pchar.ProjectileEquipped(wAny) = TRUE Then
      'Check first slot.
      If pchar.ProjectileEquipped(wPrimary) = TRUE Then
         If pchar.IsLoaded(wPrimary) = FALSE Then
            'Get the ammo id for weapon.
            amid = pchar.GetAmmoID(wPrimary)
            'Make sure that we have a valid id.
            If amid <> amNone Then
               'Check the inventory and load weapon if ammo is present.
               ret = pchar.LoadProjectile(amid, wPrimary)
               If ret = TRUE Then
                  PrintMessage "Weapon is loaded."
               Else
                  PrintMessage "Weapon could not be loaded."
               EndIf
            EndIf
         Else
            PrintMessage "Weapon is already loaded."
         EndIf
      End If
      'Check second slot.
      If pchar.ProjectileEquipped(wSecondary) = TRUE Then
         If pchar.IsLoaded(wSecondary) = FALSE Then
            'Check the inventoru and load weapon if ammo is present.
            ret = pchar.LoadProjectile(amid, wSecondary)
            If ret = TRUE Then
               PrintMessage "Weapon is loaded."
            Else
               PrintMessage "Weapon could not be loaded."
            EndIf
         Else
            PrintMessage "Weapon is already loaded."
         EndIf
      EndIf
   Else
      PrintMessage "Not carrying a projectile weapon."
   EndIf
End Sub

'Manage all timed actions. These are done each turn.
Sub DoTimedEvents()
   'Do any monster or level timed events.
   pchar.DoTimedEvents 
   level.DoTimedEvents
End Sub

'Using 640x480 32bit screen with 80x60 text.
ScreenRes sw, sh, 32
Width txcols, txrows
WindowTitle "Dungeon of Doom"
Randomize Timer 'Seed the rnd generator.
tWidgets.InitWidgets 'Initialzie the widgets.

'Draw the title screen.
DisplayTitle
'Get the menu selection
Dim mm As mmenu.mmenuret
'Loop until the user selects New, Load or Quit.
Do
   'Draw the main menu.
    mm = mmenu.MainMenu
   'Process the menu selection.
   If mm = mmenu.mNew Then
      'Generate the character.
      Var ret = pchar.GenerateCharacter
      'Do not exit menu when user presses ESC.
      If ret = FALSE Then
         'Set this so we loop.
         mm = mmenu.mInstruction
      Else
         'Do the intro.
         intro.DoIntro
      EndIf
   ElseIf mm = mmenu.mLoad Then
      'Load the save game.
   ElseIf mm = mmenu.mInstruction Then
      'Print the instructions.
   EndIf
Loop Until mm <> mmenu.mInstruction

'Set the dead flag.
Dim As Integer isdead = FALSE
'Main game loop.
If mm <> mmenu.mQuit Then
   'Set the first level.
   level.LevelID = 1
	'Build the first level of dungeon
	level.GenerateDungeonLevel
   'Display the main screen.
   DrawMainScreen
   Do
      ckey = InKey
      If ckey <> "" Then
         'Get direction key from numpad or arrows.
         'Check for up arrow or 8
         If (ckey = key_up) OrElse (ckey = "8") Then
            mret = MoveChar(north)
            If mret = TRUE Then DrawMainScreen
            level.MoveMonsters
            DrawMainScreen
            ClearKeys
         EndIf
         'Check for 9
         If ckey = "9" Then
            mret = MoveChar(neast)
            If mret = TRUE Then DrawMainScreen
            level.MoveMonsters
            DrawMainScreen
            ClearKeys
         EndIf
         'Check for right arrow or 6.
         If (ckey = key_rt) OrElse (ckey = "6") Then
            mret = MoveChar(east)
            If mret = TRUE Then DrawMainScreen
            level.MoveMonsters
            DrawMainScreen
            ClearKeys
         EndIf
         'Check for 3
         If ckey = "3" Then
            mret = MoveChar(seast)
            If mret = TRUE Then DrawMainScreen
            level.MoveMonsters
            DrawMainScreen
            ClearKeys
         EndIf
         'Check for down arrow or 2.
         If (ckey = key_dn) OrElse (ckey = "2") Then
            mret = MoveChar(south)
            If mret = TRUE Then DrawMainScreen
            level.MoveMonsters
            DrawMainScreen
            ClearKeys
         EndIf
         'Check for 1
         If ckey = "1" Then
            mret = MoveChar(swest)
            If mret = TRUE Then DrawMainScreen
            level.MoveMonsters
            DrawMainScreen
            ClearKeys
         EndIf
         'Check for left arrow or 4.
         If (ckey = key_lt) OrElse (ckey = "4") Then
            mret = MoveChar(west)
            If mret = TRUE Then DrawMainScreen
            level.MoveMonsters
            DrawMainScreen
            ClearKeys
         EndIf
         'Check for 7
         If ckey = "7" Then
            mret = MoveChar(nwest)
            If mret = TRUE Then DrawMainScreen
            level.MoveMonsters
            DrawMainScreen
            ClearKeys
         EndIf
         'Check for down stairs.
         If ckey = ">" Then
            'Check to make sure on down stairs.
            If level.GetTileID(pchar.Locx, pchar.Locy) = tstairdn Then
               'Set the level id.
               level.LevelID = level.LevelID + 1
               'Build a new level.
           	   level.GenerateDungeonLevel
               'Draw Screen.
               DrawMainScreen
            End If
         EndIf
         'Get an item from the dungeon and put into character's inventory.
         If ckey = "g" Then
           'Inventory type.
            Dim inv As invtype
            'Make sure character is standing on an item.
            If level.HasItem(pchar.Locx, pchar.Locy) = TRUE Then
               'Check for gold. Just add gold to gold total.
               Dim iclass As classids = level.GetInvClassID(pchar.Locx, pchar.Locy)
               If iclass = clGold Then
                  'Get the gold from the map.
                  level.GetItemFromMap pchar.Locx, pchar.Locy, inv
                  'Add to gold total.
                  pchar.CurrGold = pchar.CurrGold + inv.gold.amt
                  pchar.TotGold = pchar.TotGold + inv.gold.amt
                  'Add to experience.
                  pchar.CurrXP = pchar.CurrXP + inv.gold.amt
                  pchar.TotXP = pchar.TotXP + inv.gold.amt
                  'Message player. 
                  PrintMessage inv.gold.amt & " gold coins collected."
                  DrawMainScreen
               Else
                  'Look for free inventory slot.
                  Dim As Integer cidx = pchar.GetFreeInventoryIndex
                  'If found a slot load inventory item.
                  If cidx <> -1 Then
                     level.GetItemFromMap pchar.Locx, pchar.Locy, inv
                     'Put it into character inventory.
                     pchar.AddInvItem cidx, inv
                     PrintMessage "Item added to inventory."
                  Else  
                     'No slots open.
                     PrintMessage "No free inventory slots."
                  EndIf
               EndIf
            Else
               PrintMessage "Nothing to get."
            EndIf
         EndIf
         'Draw the inventory screen.
         If ckey = "i" Then
            ManageInventory
            'Need to redraw back ground here.
	         DrawBackground mainback()
            DrawMainScreen
         EndIf
         'Rest the character.
         If ckey = "r" Then
            RestCharacter
            DrawMainScreen
            level.MoveMonsters
         EndIf
         'Improve the character.
         If ckey = "x" Then
            ImproveCharacter
            'Need to redraw back ground here.
	         DrawBackground mainback()
            DrawMainScreen
         EndIf
         'Target enemy for projectile weapon.
         If ckey = "t" Then
            TargetEnemy
            level.MoveMonsters
            DrawMainScreen
         EndIf
         'Load projectile weapon.
         If ckey = "l" Then
            LoadAmmo
            level.MoveMonsters
            DrawMainScreen
         EndIf
         'Since the player pressed a key, do any timed actions.
         DoTimedEvents
         'Check for whether character is dead.
         If pchar.CurrHP <= 0 Then
            isdead = TRUE
         EndIf
      End If
      Sleep 1
   Loop Until (ckey = key_esc) Or (isdead = TRUE)
EndIf
'Print dead mesage.
If isdead = TRUE Then
   Cls
   Print pchar.CharName & " has died."
   Sleep
EndIf
