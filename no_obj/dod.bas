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
#Include "mainback.bi"
#Include "leatherback.bi"
#Include "title.bi"
#Include "char_dead.bi"
#Include "char_win.bi"
#Include "vec.bi"
#Include "set.bi"
#Include "defs.bi"
#Include "twidgets.bi"
#Include "utils.bi"
#Include "mmenu.bi"
#Include "inv.bi"
#Include "character.bi"
#Include "monster.bi"
#Include "map.bi"
#Include "intro.bi"
#Include "save.bi"

'Displays the game title screen.
Sub DisplayTitle
   Dim As String txt
   Dim As Integer tx, ty
   
   'Set up the copyright notice.
   txt = "Copyright (C) 2011, by Richard D. Clark"
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
Sub DrawMainScreen (db As Integer = FALSE)
   Dim As Integer x, y, j, pct, row, col
   Dim As Double pctd
   Dim As UInteger clr
   Dim As String txt, idesc
   Dim As terrainids terr
   Dim inv As invtype
   Dim spl As spelltype
   
   ScreenLock
	'Set the background for the main screen.
	If db = TRUE Then
	   DrawBackground mainback()
	End If
	'Draw the map.
   DrawMap
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
   txt = "Dungeon Level: " & GetLevelID & " of " & maxlevel
   If GetHasAmulet = TRUE Then
      txt = txt & " (Amulet)"
   EndIf
   DrawStringShadow charw, 0, txt 
   'Draw the character name.
   row = 1
   col = vw + 4
   PutTextShadow CharName, row, col, fbYellowBright
   row += 2 
   'Draw the character health bar.
   pctd = GetCurrHP / GetMaxHP
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
   txt = GetCurrHP & "/" & GetMaxHP
   DrawStringShadow (txcols - (Len(txt) + 2)) * charw, (row - 1) * charh, txt
   'Draw the mana bar.
   row += 2
   pctd = GetCurrMana / MaxMana
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
   txt = GetCurrMana & "/" & MaxMana
   DrawStringShadow (txcols - (Len(txt) + 2)) * charw, (row - 1) * charh, txt
   'Draw the main stats.
   row += 2
   PutText "Stats", row, col, fbYellowBright
   If GetPoisoned = TRUE Then
      PutText "(Poisoned)", row, txcols - Len("(Poisoned)") - 1, fbRedBright
   End If
   row += 2
   If GetBonStr > -1 Then
      txt = " +"
   Else
      txt = " -"
   EndIf
   PutText "Str: " & GetCurrStr & txt & GetBonStr & " (" & GetBonStrCnt & ")", row, col
   row += 1
   If GetBonSta > -1 Then
      txt = " +"
   Else
      txt = " -"
   EndIf
   PutText "Sta: " & GetCurrSta & txt & GetBonSta & " (" & GetBonStaCnt & ")", row, col
   row += 1
   If GetBonDex > -1 Then
      txt = " +"
   Else
      txt = " -"
   EndIf
   PutText "Dex: " & GetCurrDex & txt & GetBonDex & " (" & GetBonDexCnt & ")", row, col
   row += 1
   If GetBonAgl > -1 Then
      txt = " +"
   Else
      txt = " -"
   EndIf
   PutText "Agl: " & GetCurrAgl & txt & GetBonAgl & " (" & GetBonAglCnt & ")", row, col
   row += 1
   If GetBonInt > -1 Then
      txt = " +"
   Else
      txt = " -"
   EndIf
   PutText "Int: " & GetCurrInt & txt & GetBonInt  & " (" & GetBonIntCnt & ")", row, col
   row += 1
   PutText "Curr XP: " & GetCurrXP, row, col 
   
   row += 2
   PutText "Combat Factors", row, col, fbYellowBright
   row += 2
   If GetBonUcf > -1 Then
      txt = " +"
   Else
      txt = " -"
   EndIf
   PutText "UCF: " & GetCurrUcf & txt & GetBonUcf  & " (" & GetBonUcfCnt & ")", row, col
   row += 1
   If GetBonAcf > -1 Then
      txt = " +"
   Else
      txt = " -"
   EndIf
   PutText "ACF: " & CurrAcf & txt & GetBonAcf & " (" & GetBonAcfCnt & ")", row, col
   row += 1
   If GetBonPcf > -1 Then
      txt = " +"
   Else
      txt = " -"
   EndIf
   PutText "PCF: " & GetCurrPcf & txt & GetBonPcf & " (" & GetBonPcfCnt & ")", row, col
   row += 1
   If GetBonMcf > -1 Then
      txt = " +"
   Else
      txt = " -"
   EndIf
   PutText "MCF: " & GetCurrMcf & txt & GetBonMcf & " (" & GetBonMcfCnt & ")", row, col
   row += 1
   If GetBonCdf > -1 Then
      txt = " +"
   Else
      txt = " -"
   EndIf
   PutText "CDF: " & GetCurrCdf & txt & GetBonCdf & " (" & GetBonCdfCnt & ")", row, col
   row += 1
   If GetBonMdf > -1 Then
      txt = " +"
   Else
      txt = " -"
   EndIf
   PutText "MDF: " & CurrMdf & txt & GetBonMdf & " (" & GetBonMdfCnt & ")", row, col
   row += 2
   PutText "Equipment", row, col, fbYellowBright
   row += 2
   PutText "Gold: " & GetCurrGold, row, col
   row += 1
   'Check for held item.
   If HasInvItem(wPrimary) = TRUE Then
      GetInventoryItem wPrimary, inv
      idesc = GetInvItemDesc(inv)
      spl = GetItemSpellW(wPrimary)
      If spl.id <> splNone Then
         idesc &= " (M)"
      EndIf
   Else
      idesc = ""
   EndIf
   PutText "Primary: " & idesc, row, col
   row += 1
   If HasInvItem(wSecondary) = TRUE Then
      GetInventoryItem wSecondary, inv
      idesc = GetInvItemDesc(inv)
      spl = GetItemSpellW(wSecondary)
      If spl.id <> splNone Then
         idesc &= " (M)"
      EndIf
   Else
      idesc = ""
   EndIf
   PutText "Secondary: " & idesc, row, col
   row += 1
   If HasInvItem(wArmor) = TRUE Then
      GetInventoryItem wArmor, inv
      idesc = GetInvItemDesc(inv)
      spl = GetItemSpellW(wArmor)
      If spl.id <> splNone Then
         idesc &= " (M)"
      EndIf
   Else
      idesc = ""
   EndIf
   PutText "Armor: " & idesc, row, col
   row += 1
   If HasInvItem(wNeck) = TRUE Then
      GetInventoryItem wNeck, inv
      idesc = GetInvItemDesc(inv)
      spl = GetItemSpellW(wNeck)
      If spl.id <> splNone Then
         idesc &= " (M)"
      EndIf
   Else
      idesc = ""
   EndIf
   PutText "Neck: " & idesc, row, col
   row += 1
   If HasInvItem(wRingRt) = TRUE Then
      GetInventoryItem wRingRt, inv
      idesc = GetInvItemDesc(inv)
      spl = GetItemSpellW(wRingRt)
      If spl.id <> splNone Then
         idesc &= " (M)"
      EndIf
   Else
      idesc = ""
   EndIf
   PutText "Ring RT: " & idesc, row, col
   row += 1
   If HasInvItem(wRingLt) = TRUE Then
      GetInventoryItem wRingLt, inv
      idesc = GetInvItemDesc(inv)
      spl = GetItemSpellW(wRingLt)
      If spl.id <> splNone Then
         idesc &= " (M)"
      EndIf
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
   row += 2
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
   PutText "d.....Close Door", row, col
   row += 1
   PutText "p.....Pick Lock", row, col
   row += 1
   PutText "b.....Bash Door", row, col
   row += 1
   PutText "r.....Rest (1 Mana = 1 HP)", row, col
   'Check to see if character standing on an item.
   If HasItem(GetLocx, GetLocy) = TRUE Then
      txt = GetItemDescription(GetLocx, GetLocy)
      PrintMessage txt
   Else
      'See if character is on special tile.
      terr = GetTileID(GetLocx, GetLocy)
      If (terr = tstairup) Or (terr = tstairdn) Then
         txt = GetTerrainDescription(GetLocx, GetLocy)
         PrintMessage txt
      End If
   EndIf
   ScreenUnLock
End Sub

'Draws the player inventory.
Sub DrawInventoryScreen()
   Dim As Integer col, row, iitem, ret, srow, ssrow, cnt, i, savrow, lvl
   Dim As String txt, txt2, desc
   Dim As invtype inv
   Dim As UInteger clr
   Dim spl As spelltype
   
   ScreenLock
	'Set the background for the inventory screen.
	DrawBackground leatherback()
	'Add the title.
	txt = "Current Inventory for " & Trim(CharName)
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
      iitem = HasInvItem(i)
      If iitem = TRUE Then
         'Get the inv item.
         GetInventoryItem i, inv
         'Is the item evaluated.
         ret = IsEval(inv)
         'Get the description.
         desc = GetInvItemDesc(inv)
         'Get the color of the item.
         clr = inv.iconclr
         'Build the text string.
         txt &= desc
         'If not evaluated, mark so player knows it hasn't been evaluated.
         If (ret = FALSE) And (inv.classid <> clUnavailable) Then
            txt &= "(*)"
         Else
            spl = GetItemSpellI(inv)
            If spl.id <> splNone Then
               txt &= " (M)"
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
   txt2 = " Gold: " & GetCurrGold & " "
   Mid(txt, 80 - Len(txt2)) = txt2
   PutTextShadow txt, row, col, fbYellowBright
   row += 2
   col = 2
   srow = row
   'Print out the inventory items.
   For i = LowInv To HighInv
      'See if character has item in slot.
      iitem = HasInvItem(i)
      If iitem = TRUE Then
         'Get the inv item.
         GetInventoryItem i, inv
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
            spl = GetItemSpellI(inv)
            If spl.id <> splNone Then
               txt &= " (M)"
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
   For i = LowISpell To HighISpell
      txt = Chr(i)
      'Get the spell name if any.
      txt2 = GetCSpellName(i, lvl)
      If Len(txt2) > 0 Then
         txt &= " " & txt2 & "(" & lvl & ")"
      EndIf
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
   For i = LowInv To HighInv
      iitem = HasInvItem(i)
      If iitem = TRUE Then
         'Get the inv item.
         GetInventoryItem i, inv
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
      iitem = HasInvItem(i)
      If iitem = TRUE Then
         'Get the inv item.
         GetInventoryItem i, inv
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
            GetInventoryItem iitem, inv
            'Get the eval DR.
            evalDR = GetEvalDR(inv)
            'Use the intelligence attribute to calculate the eval attempt.
             pint = GetCurrInt + GetBonInt
             'Roll for evaldr.
             rolle = RandomRange(1, evalDR)
             'Roll for player.
             rollp = RandomRange(1, pint)
             'Get the item description.
             desc = GetInvItemDesc(inv)
             'If the player rolls => eval roll, item is evaluated.
             If rollp > rolle Then
               desc &= " was succesfully evaluated."
               ShowMsg "Evaluate", desc, tWidgets.MsgBoxType.gmbOK    
               SetInvEval inv, TRUE 'Set eval to true.
               AddInvItem iitem, inv 'Put item back into inv.
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
   For i = LowInv To HighInv
      iitem = HasInvItem(i)
      If iitem = TRUE Then
         'Get the inv item.
         GetInventoryItem i, inv
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
            GetInventoryItem iitem, inv
            desc = ApplyInvItem(inv) 
            ShowMsg "Eat/Drink", desc, tWidgets.MsgBoxType.gmbOK    
            'Clear the item.
            ClearInv inv
            'Put the item back into inventory.
            AddInvItem iitem, inv
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
   For i = LowInv To HighInv
      iitem = HasInvItem(i)
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
            GetInventoryItem iitem, inv
             'Get the item description.
             desc = GetInvItemDesc(inv)
            'Look for an empty space on the map.
            iret = GetEmptySpot(mvec)
            'Foud an enpty spot.
            If iret = TRUE Then
               'Put the item on the map.
               PutItemOnMap mvec.vx, mvec.vy, inv
               'Clear the item.
               ClearInv inv
               'Put the item back into inventory.
               AddInvItem iitem, inv
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
   For i = LowInv To HighInv
      iitem = HasInvItem(i)
      If iitem = TRUE Then
         'Build the mask.
         mask &= Chr(i)
      EndIf
   Next
   'Add any held items.
   For i = wPrimary To wRingLt
      iitem = HasInvItem(i)
      If iitem = TRUE Then
         'Build the mask.
         mask &= Str(i)
      EndIf
   Next
   'Check the spell list.
   For i = LowISpell To HighISpell
      iitem = HasInvItem(i)
      If iitem = TRUE Then
         'Build the mask.
         mask &= Chr(i)
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
               iitem = Val(ch) 'Get index into held inventory.
            Else
               iitem = Asc(ch) 'Get index into character inventory.
            EndIf
            'Get the inv item.
            GetInventoryItem iitem, inv
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
   Dim As invtype inv, inv2
   Dim As tWidgets.btnID btn
   Dim As tWidgets.tInputbox ib
   Dim As vec mvec
      
   'Make sure there is something to process in the inventory.
   For i = wPrimary To wRingLt
      iitem = HasInvItem(i)
      If iitem = TRUE Then
         'Check for unavailable item.
         GetInventoryItem i, inv
         If inv.classid <> clUnavailable Then
            'Build the mask.
            mask &= Str(i)
         End If
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
            GetInventoryItem iitem, inv
            'Get the item description.
            desc = GetInvItemDesc(inv)
            'Look for an empty inventory slot.
            iret = GetFreeInventoryIndex
            'Did we find an empty slot?
            If iret > -1 Then
               'Put the item back into inventory.
               AddInvItem iret, inv
               'Check for two handed weapon.
               If inv.classid = clWeapon Then
                  If inv.weapon.hands = 2 Then
                     'Clear unavailable slot.
                     If iitem = wPrimary Then
                        GetInventoryItem wSecondary, inv2
                        ClearInv inv2
                        AddInvItem wSecondary, inv2
                     Else
                        GetInventoryItem wPrimary, inv2
                        ClearInv inv2
                        AddInvItem wPrimary, inv2
                     EndIf
                  EndIf
               EndIf
               'Clear the item.
               ClearInv inv
               'Update the held slot.
               AddInvItem iitem, inv
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
   Dim As String res, mask, msg
   Dim As Integer i, iitem, iret, ret = FALSE
   Dim As invtype inv
   Dim As tWidgets.btnID btn
   Dim As tWidgets.tInputbox ib
   Dim As wieldpos slot
      
   'Make sure there is something to process in the inventory.
   For i = LowInv To HighInv
      iitem = HasInvItem(i)
      If iitem = TRUE Then
         'Get the inv item.
         GetInventoryItem i, inv
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
            GetInventoryItem iitem, inv
            'Look for a free slot.
            slot = GetFreeSlot(inv, msg)
            'No empty slots.
            If slot <> wNone Then
               'Put the item wield position.
               AddInvItem slot, inv
               'Clear the item.
               ClearInv inv
               'Update the inv slot.
               AddInvItem iitem, inv
               ret = TRUE
               msg &= " was equipped."
            End If
            ShowMsg "Equip Items", msg, tWidgets.MsgBoxType.gmbOK
         Next
      EndIf
   EndIf
   
   Return ret
End Function

'Process the read command.
Function ProcessRead() As Integer
   Dim As String res, mask, desc
   Dim As Integer i, iret, iitem, ret = FALSE
   Dim As invtype inv
   Dim As tWidgets.btnID btn
   Dim As tWidgets.tInputbox ib
      
   'Make sure there is something to evaluate in the inventory.
   For i = LowInv To HighInv
      iitem = HasInvItem(i)
      If iitem = TRUE Then
         'Get the inv item.
         GetInventoryItem i, inv
         'Is the item evaluated.
         iret = MatchUse(inv, useRead)
         'An item to evaluate.
         If iret = TRUE Then
            'Build the mask.
            mask &= Chr(i)
         End If
      EndIf
   Next
   If Len(mask) = 0 Then
      ShowMsg "Read", "Nothing to read.", tWidgets.MsgBoxType.gmbOK
   Else
      'Draws an input box on screen.
      ib.Title = "Read"
      ib.Prompt = "Select item(s) to read (" & mask & ")"
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
            GetInventoryItem iitem, inv
            If IsEval(inv) = TRUE Then
               desc = ApplyInvItem(inv) 
               ShowMsg "Read", desc, tWidgets.MsgBoxType.gmbOK    
               'Clear the item.
               ClearInv inv
               'Put the item back into inventory.
               AddInvItem iitem, inv
            Else
               ShowMsg "Read", "Cannot read unevaluated spell books.", tWidgets.MsgBoxType.gmbOK
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
         'Process the read item.
         If kch = "R" Then
            ret = ProcessRead()
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
   doorlocked = IsDoorLocked(x, y)
   If doorlocked = FALSE Then
      'Open the door.
      SetTile x, y, tdooropen
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
      statamt = GetMonsterStatAmt(mstat, mx, my)
      rstat = RandomRange(1, statamt - 1)
      'Add stat amount to char for lvl turns.
      Select Case mstat
         Case CombatFactor
            SetBonAcf rstat
            SetBonAcfCnt spl.lvl
         Case CombatDefense
            SetBonCdf rstat
            SetBonCdfCnt spl.lvl
         Case MagicCombat
            SetBonMcf rstat
            SetBonMcfCnt spl.lvl
         Case MagicDefense
            SetBonMdf rstat
            SetBonMdfCnt spl.lvl
      End Select
   Else
      'Apply spell to monster.
      ret = ApplySpell(spl, mx, my)
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
   df = GetMonsterDefense(mx, my)
   mname = GetMonsterName(mx, my)
   'Get monster xp.
   mxp = GetMonsterXP(mx, my)
   'Make sure we got something.
   If df > 0 Then
      'Returns the combat factor based on what the character is holding.
      cf = GetMeleeCombatFactor()
      'Get the rolls.
      croll = RandomRange(1, cf)
      mroll = RandomRange(1, df)
      'See if the character hit monster.      
      If croll > mroll Then
         'Get total weapon damage.
         dam = GetWeaponDamage()
         'Get monster armor rating.
         marm = GetMonsterArmor(mx, my)
         'Adjust the damage value based on arnor rating.
         dam = dam - (dam * marm)
         If dam <= 0 Then dam = 1
         'Check for magic weapon in both slots. Only returns if evaluated.
         spl1 = GetItemSpellW(wPrimary)
         spl2 = GetItemSpellW(wSecondary)
         'Check for goliath spell.
         If spl1.id = splGoliath Then dam += GetCurrStr
         If spl2.id = splGoliath Then dam += GetCurrStr
         'Set the monster hp.
         isdead = ApplyDamage(mx, my, dam)
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
      Else
         txt = CharName & " missed the " & mname & "."
         PrintMessage txt
      EndIf
   EndIf
End Sub

'Displays the input screen.
Function ShowMerchantInput() As String
   Dim As String ret, mask = "bsiq"
   Dim As tWidgets.btnID btn
   Dim As tWidgets.tInputbox ib

      'Draws an input box on screen.
      ib.Title = "Wandering Merchant"
      ib.Prompt = "Do you want to (b)uy, (s)ell, (i)nscribe or (q)uit? (" & mask & ")"
      ib.EditMask = mask
      ib.MaxLen = 1
      ib.InputLen = 1
      btn = ib.Inputbox(ret)
      'Evaluate each item in the list.
      If btn = tWidgets.btnID.gbnCancel Then
         ret = "q"
      End If
      
   Return ret
End Function

'Shows sell list.
Sub ShowMerchantSellList(inv() As invtype, invlist() As tWidgets.listtype)
   Dim As tWidgets.tList lst
   Dim As tWidgets.btnID btn
   Dim As Integer iitem, cidx
   
   'Set up the list window.
   lst.Title = "Select Item to Buy (Gold: " & GetCurrGold & ")"
   lst.Prompt = "Use Up or Dn key to cycle items, Enter to select."
   'Get the player selection.
   btn = lst.Listbox(invlist(), iitem)
   If btn = tWidgets.btnID.gbnOK Then
      'Make sure the character has enough gold.
      If inv(iitem).buy > GetCurrGold Then
         PrintMessage "You do not have enough gold to buy item."
      Else
         'Look for free inventory slot.
         cidx = GetFreeInventoryIndex
         'If found a slot load inventory item.
         If cidx <> -1 Then
            AddInvItem cidx, inv(iitem)
            SetCurrGold GetCurrGold - inv(iitem).buy
            PrintMessage "You bought " & inv(iitem).desc & " for " & inv(iitem).buy & " gold." 
         Else
            PrintMessage "No empty inventory slots."
         End If
      EndIf
   EndIf
End Sub

'Displays the merchant buy list.
Sub ShowMerchantBuyList(inv() As invtype, invlist() As tWidgets.listtype)
   Dim As tWidgets.tList lst
   Dim As tWidgets.btnID btn
   Dim As Integer iitem, cidx
   Dim As invtype tinv
   
   'Set up the list window.
   lst.Title = "Select Item to Sell "
   lst.Prompt = "Use Up or Dn key to cycle items, Enter to select."
   'Get the player selection.
   btn = lst.Listbox(invlist(), iitem)
   If btn = tWidgets.btnID.gbnOK Then
      SetCurrGold GetCurrGold + inv(iitem).sell
      PrintMessage "You sold " & inv(iitem).desc & " for " & inv(iitem).sell & " gold." 
      'Clear the inventory item.
      GetInventoryItem invlist(iitem).ldata, tinv
      ClearInv tinv
      AddInvItem invlist(iitem).ldata, tinv
   EndIf
End Sub

'Displays the inscribe list.
Sub ShowInscribeList(inv() As invtype, invlist() As tWidgets.listtype)
   Dim As invtype binv
   Dim As Integer bidx = -1, iitem
   Dim As tWidgets.tList lst
   Dim As tWidgets.btnID btn
   
   'Make sure the character has a blank spell book in inventory.
   For i As Integer = LowInv To HighInv
      'Get the inventory item.
      GetInventoryItem i, binv
      If binv.classid = clSpellBook Then
         If binv.spellbook.id = bkSpellBlank Then
            bidx = i
            Exit For
         EndIf
      EndIf
   Next
   'Make sure the character has a blank spell book.
   If bidx > -1 Then
      'Set up the list window.
      lst.Title = "Select Spell to Inscribe (Gold: " & GetCurrGold & ")"
      lst.Prompt = "Use Up or Dn key to cycle items, Enter to select."
      'Get the player selection.
      btn = lst.Listbox(invlist(), iitem)
      If btn = tWidgets.btnID.gbnOK Then
         'Make sure character has enough gold.
         If GetCurrGold >= invlist(iitem).ldata Then
            'Deduct gold.
            SetCurrGold GetCurrGold - invlist(iitem).ldata
            'Get the book from inventory.
            GetInventoryItem bidx, binv
            'Set the spell data.
            binv.spellbook.id = bkSpellBook
            binv.spellbook.spell = inv(iitem).spell
            'Put it back into inventory.
            AddInvItem bidx, binv
            PrintMessage "The Merchant inscribed " & inv(iitem).spell.splname & " for " & invlist(iitem).ldata & " gold."
         Else
            PrintMessage "You do not have enough gold."
         EndIf
      EndIf
   Else
      PrintMessage "No blank spell books to inscribe."
   EndIf
End Sub

'Builds the sell list.
Sub BuildMerchantSellList(inv() As invtype, invlist() As tWidgets.listtype)
   Dim As Integer cnt = 0
   Dim spl As spelltype
   Dim As String res, magic
   
   For i As classids = clSupplies To clSpellBook
      'Get an item from each category.
      cnt += 1
      ReDim Preserve inv(1 To cnt) As invtype
      ReDim Preserve invlist(1 To cnt) As tWidgets.listtype
      'Clear inventory item.
      ClearInv inv(cnt)
      'Generate item in category.
      If i = clSpellBook Then
         Do
            GenerateItem inv(cnt), GetLevelID, i
         Loop Until inv(cnt).spellbook.id <> bkSpellBlank
      Else
         GenerateItem inv(cnt), GetLevelID, i   
      EndIf
      'Set the eval to true.
      SetInvEval inv(cnt), TRUE
      'Check for spell item.
      spl = GetItemSpellI(inv(cnt))
      If spl.id <> splNone Then
         magic = " (M)"
      Else
         magic = ""
      EndIf
      'Build the display string.
      invlist(cnt).id = cnt
      If inv(cnt).classid = clSpellbook Then
         invlist(cnt).text = inv(cnt).spellbook.spell.splname & " Price: " & inv(cnt).buy
      Else
         invlist(cnt).text = inv(cnt).desc & magic & " Price: " & inv(cnt).buy
      EndIf
   Next
   
End Sub

'Builds buy list from inventory items.
Function BuildMerchantBuyList(inv() As invtype, invlist() As tWidgets.listtype) As Integer
   Dim As Integer cnt
   Dim spl As spelltype
   Dim As String res, magic
   Dim As invtype tinv
   
   For i As Integer = LowInv To HighInv
      'Get character inventory item.
      GetInventoryItem i, tinv
      'Make sure we have something.
      If (tinv.classid <> clNone) And (tinv.classid <> clUnavailable) then 
         'Get an item from each category.
         cnt += 1
         ReDim Preserve inv(1 To cnt) As invtype
         ReDim Preserve invlist(1 To cnt) As tWidgets.listtype
         'Save the index.
         invlist(cnt).ldata = i
         'Clear inventory item.
         ClearInv inv(cnt)
         'Set item in list.
         inv(cnt) = tinv
         'Check for spell item.
         spl = GetItemSpellI(inv(cnt))
         If spl.id <> splNone Then
            magic = " (M)"
         Else
            magic = ""
         EndIf
         'Build the display string.
         invlist(cnt).id = cnt
         If inv(cnt).classid = clSpellbook Then
            invlist(cnt).text = inv(cnt).spellbook.spell.splname & " Price: " & inv(cnt).sell
         Else
            invlist(cnt).text = inv(cnt).desc & magic & " Price: " & inv(cnt).sell
         EndIf
      End If
   Next
   
   Return cnt
End Function

'Build the spell list to inscribe on a book.
Sub BuildInscribeList(inv() As invtype, invlist() As tWidgets.listtype)
   Dim As Integer cnt, price
   
   For i As spellid = splAcidFog To splBlink
      cnt += 1
      'Expand the arrays.
      ReDim Preserve inv(1 To cnt) As invtype
      ReDim Preserve invlist(1 To cnt) As tWidgets.listtype
      'Get the spell.
      inv(cnt).spell.id = i
      GenerateSpell inv(cnt).spell, 1
      'Calculate the price.
      price = 100 + inv(cnt).spell.dam + RandomRange(1, 10)
      'Load the list data.
      invlist(cnt).id = cnt
      invlist(cnt).ldata = price
      invlist(cnt).text = inv(cnt).spell.splname & " Price: " & price & "."
   Next
   
End Sub

'Shows the wandering merchant screen.
Sub DoWanderingMerchant ()
   Dim As String ret
   Dim As invtype sinv(), binv(), iinv()
   Dim As tWidgets.listtype sinvlist(), binvlist(), iinvlist()
   Dim As Integer cnt
   
   'Build the character buy.
   BuildMerchantSellList sinv(), sinvlist()
   'Build the spell list to inscribe on a book.
   BuildInscribeList iinv(), iinvlist()
   Do
      ret = ShowMerchantInput()
      'Player wants to buy item.
      If ret = "b" Then
         ShowMerchantSellList sinv(), sinvlist()
      ElseIf ret = "s" Then
         'Build the character sell list.
         cnt = BuildMerchantBuyList(binv(), binvlist())
         If cnt > 0 Then
            ShowMerchantBuyList binv(), binvlist()
         Else 
            PrintMessage "Nothing to sell."
         End If
      ElseIf ret = "i" Then
         ShowInscribeList iinv(), iinvlist()
      EndIf
      Sleep 1
   Loop Until ret = "q"
End Sub

'Move the character based on the compass direction.
Function MoveChar(comp As compass) As Integer
   Dim As Integer ret = FALSE, block, tdam, snd, trp, tdr
   Dim As vec vc = vec(GetLocx, GetLocy) 'Creates a vector object.
   Dim As terrainids tileid
   Dim As weapdamtype tdamtype
   Dim As String tdesc
   
   vc+= comp
   'Check to make sure we don't move off map.
   If (vc.vx >= 1) And (vc.vx <= mapw) Then
      If (vc.vy >= 1) And (vc.vy <= maph) Then
         'Check for blocking tile.
         block = IsBlocking(vc.vx, vc.vy)
         'Check for monster.
         If block = FALSE Then
            block = IsMonster(vc.vx, vc.vy)
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
            SetLocx vc.vx
            SetLocy vc.vy
            ret = TRUE
            'Generate the sound map.
            ClearSoundMap
            snd = GetNoise()
            GenSoundMap GetLocx, GetLocy, snd
            'Check for trap at current location.
            trp = IsTrap(GetLocx, GetLocy, tdam, tdamtype, tdr, tdesc)
            If trp = TRUE Then
               ApplyTrap tdr, tdam, tdamtype, tdesc
            EndIf
            'Check to see if character has found amulet.
            If GetLevelID = maxlevel Then
               IsAmulet GetLocx, GetLocy
            End If 
         Else 'Check for special tiles.
            'Get tile id.
            tileid = GetTileID(vc.vx, vc.vy)
            Select Case tileid
               Case tdoorclosed 'Check for closed door.
                  ret = OpenDoor(vc.vx, vc.vy)
                  'If false then print message.
                  If ret = FALSE Then
                     'Print message here.
                     PrintMessage "Door is locked."
                  Else
                     'Set the new character position.
                     SetLocx vc.vx
                     SetLocy vc.vy
                     ret = TRUE
                     'Generate the sound map.
                     ClearSoundMap
                     snd = GetNoise()
                     GenSoundMap(GetLocx, GetLocy, snd)
                  EndIf
               Case tstairup 'Enable move onto up stairs.
                  'Set the new character position.
                  SetLocx vc.vx
                  SetLocy vc.vy
                  ret = TRUE
                  'Generate the sound map.
                  ClearSoundMap
                  snd = GetNoise()
                  GenSoundMap(GetLocx, GetLocy, snd)
               Case twmerch
                  PrintMessage "Wandering Merchant"
                  'Show the wandering merchant screen.
                  DoWanderingMerchant
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
   cman = GetCurrMana
   chp = GetCurrHP
   thp = GetMaxHP
   'Check to see if the character needs to rest.
   If chp = thp Then
      PrintMessage CharName & " doesn't need to rest."
   Else
      'Make sure we have some mana to spend.
      If cman = 0 Then
         PrintMessage CharName & " doesn't have any mana to spend."
      Else
         'Decrement the mana and add to hp.
         cman -= 1
         SetCurrMana cman
         chp += 1
         SetCurrHP chp
         PrintMessage CharName & " spent 1 mana for 1 health point."
      EndIf
   EndIf
End Sub

'Applies XP to character attributes.
Sub ImproveCharacter ()
   Dim As Integer sel, xp, reqamt = 100
   
   'Make sure we have some xp to work with.
   If GetCurrXP > reqamt Then
      Do
         If GetCurrXP > reqamt Then
            'Print Current stats.
            PrintStats
            PutTextShadow "Cost = " & reqamt & " XP for 1 point improvement.", 49, 10
            PutTextShadow "Enter attribute 1 to 5 to improve, enter to exit: ", 51, 10
            'Position input.
            Locate 53, 10
            'Get the input.
            Input sel
            'If attribute selected then Change. 
            If sel = 1 Then
               ChangeStrength 1
               'Subtract the xp amount.
               xp = GetCurrXP
               xp -= reqamt
               SetCurrXP xp 
            EndIf
            If sel = 2 Then
               ChangeStamina 1
               'Subtract the xp amount.
               xp = GetCurrXP
               xp -= reqamt
               SetCurrXP xp 
            EndIf
            If sel = 3 Then
               ChangeDexterity 1
               'Subtract the xp amount.
               xp = GetCurrXP
               xp -= reqamt
               SetCurrXP xp 
            EndIf      
            If sel = 4 Then
               ChangeAgility 1
               'Subtract the xp amount.
               xp = GetCurrXP
               xp -= reqamt
               SetCurrXP xp 
            EndIf
            If sel = 5 Then
               ChangeIntelligence 1
               'Subtract the xp amount.
               xp = GetCurrXP
               xp -= reqamt
               SetCurrXP xp 
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
Function GetTargetCoord(vt As vec, dist As Integer = 0) As Integer
   Dim As String ch, rtl = "*"
   Dim As vec v, vtmp
   Dim As Integer ret = FALSE, tdist
   
   'Set the reticle coordinates.
   v.vx = GetLocx
   v.vy = GetLocy
   'Set new target.
   SetTarget(v.vx, v.vy, Asc(rtl), fbYellowBright)
   DrawMap
   Do
      ch = InKey
      If ch <> "" Then
         If ch = key_up Then
            'Set the current vector.
            vtmp = v
            'Update temp vector.
            vtmp += north
         End If
         If ch = key_dn Then
            'Set the current vector.
            vtmp = v
            'Update temp vector.
            vtmp += south
         End If
         If ch = key_rt Then
            'Set the current vector.
            vtmp = v
            'Update temp vector.
            vtmp += east
         End If
         If ch = key_lt Then
            'Set the current vector.
            vtmp = v
            'Update temp vector.
            vtmp += west
         End If
         'Check the tile visibility.
         If IsTileVisible(vtmp.vx, vtmp.vy) = TRUE Then
            'If we have a distance, check the distance.
            If dist > 0 Then
               tdist = CalcDist(GetLocx, vtmp.vx, GetLocy, vtmp.vy)
               If tdist <= dist Then
                  'Clear previous target space.
                  SetTarget(v.vx, v.vy, 0)
                  'Save the current location.
                  v = vtmp
                  'Set new target.
                  SetTarget(v.vx, v.vy, Asc(rtl), fbYellowBright)
                  'Redraw the map.
                  ScreenLock
                  DrawMap
                  ScreenUnLock
               EndIf
            Else
               'Clear previous target space.
               SetTarget(v.vx, v.vy, 0)
               'Save the current location.
               v = vtmp
               'Set new target.
               SetTarget(v.vx, v.vy, Asc(rtl), fbYellowBright)
               'Redraw the map.
               ScreenLock
               DrawMap
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
   SetTarget(v.vx, v.vy, 0)
   DrawMap   
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
   If ProjectileIsWand(wslot) = TRUE Then
      df = GetMonsterMagicDefense(mx, my)
   Else
      df = GetMonsterDefense(mx, my)
   EndIf
   'Get monster name.
   mname = GetMonsterName(mx, my)
   'Get monster xp.
   mxp = GetMonsterXP(mx, my)
   'Make sure we got something.
   If df > 0 Then
      'Returns the combat factor based on what the character is holding.
      If ProjectileIsWand(wslot) = TRUE Then
         cf = GetMagicCombatFactor()
      Else
         cf = GetProjectileCombatFactor()
      EndIf
      'Get the rolls.
      croll = RandomRange(1, cf)
      mroll = RandomRange(1, df)
      'See if the character hit monster.      
      If croll > mroll Then
         'Get total weapon damage.
         dam = GetWeaponDamage(wslot)
         'Get monster armor rating.
         marm = GetMonsterArmor(mx, my)
         'Adjust the damage value based on armor rating.
         dam = dam - (dam * marm)
         If dam <= 0 Then dam = 1
         'Check for magic weapon in both slots. Only returns if evaluated.
         spl1 = GetItemSpellW(wPrimary)
         spl2 = GetItemSpellW(wSecondary)
         'Check for goliath spell.
         If spl1.id = splGoliath Then dam += GetCurrStr
         If spl2.id = splGoliath Then dam += GetCurrStr
         'Set the monster hp.
         isdead = ApplyDamage(mx, my, dam)
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
      Else
         txt = CharName & " missed the " & mname & "."
         PrintMessage txt
      EndIf
   EndIf
End Sub


'Targets an enemy and attacks with projectile weapon.
Sub TargetEnemy ()
   Dim As vec target, source
   Dim As Integer ret
   
   'Check to see if character is carrying projectile weapon.
   If ProjectileEquipped(wAny) = TRUE Then
      'Get target vector.
      ret = GetTargetCoord(target)
      source.vx = GetLocx
      source.vy = GetLocy
      'Player pressed enter.
      If ret = TRUE Then
         'Check first slot to see if it has weapon.
         If ProjectileEquipped(wPrimary) = TRUE Then
            'Make sure it is loaded.
            If IsLoaded(wPrimary) = TRUE Then
               'Fire the weapon.
               AnimateProjectile source, target
               'Remove prjectile from weapon.
               DecrementAmmo wPrimary
               'Make sure we have targeted a monster.
               If IsMonster(target.vx, target.vy) = TRUE Then
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
            If IsLoaded(wSecondary) = FALSE Then
               'Fire the weapon.
               AnimateProjectile source, target
               'Remove prjectile from weapon.
               DecrementAmmo wSecondary
               'Make sure we have targeted a monster.
               If IsMonster(target.vx, target.vy) = TRUE Then
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
   If ProjectileEquipped(wAny) = TRUE Then
      'Check first slot.
      If ProjectileEquipped(wPrimary) = TRUE Then
         If IsLoaded(wPrimary) = FALSE Then
            'Get the ammo id for weapon.
            amid = GetAmmoID(wPrimary)
            'Make sure that we have a valid id.
            If amid <> amNone Then
               'Check the inventory and load weapon if ammo is present.
               ret = LoadProjectile(amid, wPrimary)
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
      If ProjectileEquipped(wSecondary) = TRUE Then
         If IsLoaded(wSecondary) = FALSE Then
            'Check the inventoru and load weapon if ammo is present.
            ret = LoadProjectile(amid, wSecondary)
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

'Cast a spell.
Sub CastSpell ()
   Dim As Integer splcnt, i, iitem, ret, mc, md, rollm, rollp 
   Dim As Integer tmp, snd, cancel = FALSE
   Dim As invtype sinv, iinv
   Dim As tWidgets.listtype splist()
   Dim As tWidgets.btnID btn
   Dim As tWidgets.tList lst
   Dim As vec vt, pt
   Dim tid As terrainids
   
   'Check the spell list.
   For i = LowISpell To HighISpell
      iitem = HasInvItem(i)
      If iitem = TRUE Then
         'Get the inventory item.
         GetInventoryItem i, sinv
         'Add the spell name to the list.
         splcnt += 1
         ReDim Preserve splist(1 To splcnt)
         'Use the index as the id.
         splist(splcnt).id = i
         splist(splcnt).text = sinv.spell.splname 
      EndIf
   Next
   'Make sure we have some spells.
   If splcnt > 0 Then
      'Set the id to 0.
      iitem = 0
      'Set up the list window.
      lst.Title = "Select Spell to Cast"
      lst.Prompt = "Use Up or Dn key to cycle spells, Enter to select."
      'Get the player selection.
      btn = lst.Listbox(splist(), iitem)
      'Check to make sure the player didn't cancel.
      If (btn <> tWidgets.gbnCancel) And (iitem <> 0) Then
         'Get the inventory item based on the returned id.
         GetInventoryItem iitem, sinv
         'Make sure the character has enough mana to cast spell.
         If sinv.spell.manacost > GetCurrMana Then
            ShowMsg "Mana", "You do not have enough Mana to cast spell.", tWidgets.MsgBoxType.gmbOK
         Else
            'Check for target spell.
            ret = splSet.IsMember(sinv.spell.id)
            'This is a target spell.
            If ret = TRUE then
               'Get the target coordinates.
               ret = GetTargetCoord(vt)
               'Make sure player selected target.
               If ret = TRUE Then
                  'Make sure we have a valid target.
                  If IsMonster(vt.vx, vt.vy) = FALSE Then
                     ShowMsg "Target", "Nothing to target!", tWidgets.MsgBoxType.gmbOK
                     cancel = TRUE
                  Else
                     'Animate the spell attack.
                     pt.vx = GetLocx
                     pt.vy = GetLocy
                     AnimateProjectile pt, vt
                     'Get the monster magic defense factor.
                     md = GetMonsterMagicDefense(vt.vx, vt.vy)
                     'Get the character magic offense factor.
                     mc = GetCurrMcf + GetBonMcf
                     'Roll for attack.
                     rollp = RandomRange(1, mc) 'offense
                     rollm = RandomRange(1, md) 'defense
                     'Did the character hit the target?
                     If rollp > rollm Then
                        'Apply spell to monster.
                        ret = ApplySpell(sinv.spell, vt.vx, vt.vy)
                     Else
                        'Message miss.
                        PrintMessage "The " & GetMonsterName(vt.vx, vt.vy) & " dispels the " & sinv.spell.splname & "!"
                     EndIf
                  EndIf
               Else
                  cancel = TRUE
               End If
            Else
               Select Case sinv.spell.id
                  Case splHeal
                     tmp = GetMaxHP * (sinv.spell.lvl / 100)
                     If tmp < 1 Then tmp = 1
                     SetCurrHP GetCurrHP + tmp
                  Case splMana
                     tmp = MaxMana * (sinv.spell.lvl / 100)
                     If tmp < 1 Then tmp = 1
                     SetCurrMana GetCurrMana + tmp
                     cancel = TRUE
                  Case splRecharge
                     'Look for wands in inventory and recharge based on 
                     For i = LowInv To HighInv
                        iitem = HasInvItem(i)
                        If iitem = TRUE Then
                           'Get the inventory item.
                           GetInventoryItem i, iinv
                           'Check to see if it is a weapon.
                           If iinv.classid = clWeapon Then
                              'Check to see if it is a wand.
                              If iinv.weapon.iswand = TRUE Then
                                 'Increase the ammocnt (charges).
                                 iinv.weapon.ammocnt += sinv.spell.lvl
                                 'Make sure we don't go over the capacity.
                                 If iinv.weapon.ammocnt > iinv.weapon.capacity Then
                                    iinv.weapon.ammocnt = iinv.weapon.capacity
                                 EndIf
                                 'Put the item back into the inventory.
                                 AddInvItem iitem, iinv
                              EndIf
                           EndIf
                        End If
                     Next
                     'Check held positions and charge those too if carried.
                     iitem = HasInvItem(wPrimary)
                     If iitem = TRUE Then
                        GetInventoryItem wPrimary, iinv
                        If iinv.classid = clWeapon Then
                           'Check to see if it is a wand.
                           If iinv.weapon.iswand = TRUE Then
                              iinv.weapon.ammocnt += sinv.spell.lvl
                              If iinv.weapon.ammocnt > iinv.weapon.capacity Then
                                 iinv.weapon.ammocnt = iinv.weapon.capacity
                              EndIf
                              AddInvItem wPrimary, iinv
                           EndIf
                        EndIf
                     EndIf
                     'Check held positions and charge those too if carried.
                     iitem = HasInvItem(wSecondary)
                     If iitem = TRUE Then
                        GetInventoryItem wSecondary, iinv
                        If iinv.classid = clWeapon Then
                           'Check to see if it is a wand.
                           If iinv.weapon.iswand = TRUE Then
                              iinv.weapon.ammocnt += sinv.spell.lvl
                              If iinv.weapon.ammocnt > iinv.weapon.capacity Then
                                 iinv.weapon.ammocnt = iinv.weapon.capacity
                              EndIf
                              AddInvItem wSecondary, iinv
                           EndIf
                        EndIf
                     EndIf
                  Case splFocus
                     'Increase all combat factors for 1 turn.
                     SetBonUcf sinv.spell.lvl
                     SetBonUcfCnt 1
                     SetBonAcf sinv.spell.lvl
                     SetBonAcfCnt 1
                     SetBonPcf sinv.spell.lvl
                     SetBonPcfCnt 1
                     SetBonCdf sinv.spell.lvl
                     SetBonCdfCnt 1
                     SetBonMcf sinv.spell.lvl
                     SetBonMcfCnt 1
                     SetBonMdf sinv.spell.lvl
                     SetBonMdfCnt 1
                  Case splTeleport
                     'Get the target coordinates.
                     ret = GetTargetCoord(vt, sinv.spell.lvl)
                     If ret = TRUE Then
                        'Check to see if a monster is at location.
                        If IsMonster(vt.vx, vt.vy) = TRUE Then
                           'Teleport to mosnter killing it.
                           ret = ApplySpell(sinv.spell, vt.vx, vt.vy)
                           'Set the new character position.
                           SetLocx vt.vx
                           SetLocy vt.vy
                           'Generate the sound map.
                           ClearSoundMap
                           snd = GetNoise()
                           GenSoundMap(GetLocx, GetLocy, snd)
                        Else
                           'Make sure it isn't a blocking tile.
                           If IsBlocking(vt.vx, vt.vy) = FALSE Then
                              'Set the new character position.
                              SetLocx vt.vx
                              SetLocy vt.vy
                              'Generate the sound map.
                              ClearSoundMap
                              snd = GetNoise()
                              GenSoundMap(GetLocx, GetLocy, snd)
                           Else
                              ShowMsg "Teleport", "You can't teleport there.", tWidgets.MsgBoxType.gmbOK
                              cancel = TRUE
                           End If   
                        EndIf
                     Else
                        cancel = TRUE
                     EndIf
                  Case splOpen
                     'Get the target coordinates.
                     ret = GetTargetCoord(vt, sinv.spell.lvl)
                     If ret = TRUE Then
                        'Get the terrain id.
                        tid = GetTileID(vt.vx, vt.vy)
                        'Check for closed door.
                        If tid = tDoorClosed Then
                           'See if it is locked.
                           If IsDoorLocked(vt.vx, vt.vy) = TRUE Then
                              ret = OpenLockedDoor(vt.vx, vt.vy, sinv.spell.lvl)
                              If ret = TRUE Then
                                 PrintMessage "Door was opened."
                              EndIf
                           Else
                              'Tell player door isn't locked.
                              ShowMsg "Open Spell", "The door is not locked.", tWidgets.MsgBoxType.gmbOK
                              cancel = TRUE
                           EndIf
                        EndIf
                     Else
                        cancel = TRUE
                     End If
                  Case splBlink
                     'Set the blink efect.
                     SetSpellEffect sinv.spell.id, sinv.spell.lvl, 0
               End Select
            EndIf
            If cancel = FALSE Then
               'Deduct mana cost.
               SetCurrMana GetCurrMana - sinv.spell.manacost
            End If
         EndIf
      EndIf
   Else
      ShowMsg "Spells", "You have not learned any spells.", tWidgets.MsgBoxType.gmbOK
   EndIf
End Sub

'Returns a door state.
Function DoorState(dt As vec, dstate As doorstates) As Integer
   Dim As Integer ret = FALSE
   Dim As terrainids tile
   
   'Get the tile at location.
   tile = GetTileID(dt.vx, dt.vy)
   'What state are we looking for.
   If dstate = dsLocked Then
   If tile = tDoorClosed Then
         'Check to see if it is locked.
         ret = (IsDoorLocked(dt.vx, dt.vy) = TRUE)
      End If
   ElseIf dstate = dsClosed Then
      If tile = tDoorClosed Then
         'Check to see if it is locked.
         ret = TRUE
      End If
   ElseIf dstate = dsOpen Then
      'Look for open door.
   If tile = tDoorOpen Then
         ret = TRUE
      EndIf
   EndIf
   
   Return ret
End Function

'Looks for a door at each compass point.
Function GetDoorState(dt As vec, dstate As doorstates = dsLocked) As Integer
   Dim As Integer ret = FALSE
   
   'Look at the four compass points, north east, south west.
   For i As compass = north To west Step 2
      'Check for a door next to player.
      dt.vx = GetLocx
      dt.vy = GetLocy
      'Get the new location.
      dt += i
      'Get door state.
      ret = DoorState(dt, dstate)
      If ret = TRUE Then 
         Exit For
      EndIf
   Next
   
   Return ret
End Function

'Attempt to pick a lock.
Sub PickLock ()
   Dim As vec dt
   Dim As Integer ret = FALSE, proll, haslp = FALSE
   Dim As invtype inv
   
   'Get locked door if any.
   ret = GetDoorState(dt)
   'If we found a door, check to see if skeleton key or lock pick in hand.
   If ret = TRUE Then
      'Check primary slot.
      GetInventoryItem wPrimary, inv
      'Lock pick and skeleton key are supplies.
      If inv.classid = clSupplies Then
         If (inv.supply.id = supLockPick) Or (inv.supply.id = supSkeletonKey) Then
            'Have lock pick.
            haslp = TRUE
         End If
      End If
      'Check secondary slot.
      If haslp = FALSE Then
         'Check secondary slot.
         GetInventoryItem wSecondary, inv
         'Lock pick and skeleton key are supplies.
         If inv.classid = clSupplies Then
            If (inv.supply.id = supLockPick) Or (inv.supply.id = supSkeletonKey) Then
               'Have lock pick.
               haslp = TRUE
            End If
         EndIf
      EndIf
      'If lock pick or skeleton key then try and open door.
      If haslp = TRUE Then
         'Check to see if item is evaluated.
         If IsEval(inv) = TRUE Then
            'If item is evaluated the dr is used to supplement the attempt roll.
            proll = GetCurrDex + GetBonDex + inv.supply.evaldr 
         Else
            'Not evaluated.
            proll = GetCurrDex + GetBonDex
         EndIf
         'Attempt to open locked door.
         ret = OpenLockedDoor(dt.vx, dt.vy, proll)
         If ret = TRUE Then
            PrintMessage "You opened the door."
         Else
            PrintMessage "You failed to open the door."
         EndIf
      Else
         PrintMessage "You must equip a lock pick or skeleton key to open a locked door."
      EndIf
   Else
      PrintMessage "No locked doors found."
   EndIf
End Sub

'Attempt to bash a door.
Sub BashDoor
   Dim As vec dt
   Dim As Integer ret, proll
   
   'Check for locked door.
   ret = GetDoorState(dt)
   'Found locked door.
   If ret = TRUE Then
      'Get the character roll.
      proll = GetCurrStr + GetBonStr
      ret = OpenLockedDoor(dt.vx, dt.vy, proll)
      If ret = TRUE Then
         PrintMessage "You bashed open the door."
      Else
         'Subtract 1 from hp.
         PrintMessage "The door remains closed."
         SetCurrHP GetCurrHP - 1
      EndIf
   Else
      PrintMessage "No locked doors found."
   EndIf
End Sub

'Closes door.
Sub CloseDoor ()
   Dim As vec dt
   Dim As Integer ret
   
   'Look for open door.
   ret = GetDoorState(dt, dsOpen)
   If ret = FALSE Then
      PrintMessage "No open doors found."
   Else
      'Make sure we don't have a monster in the doorway.
      If IsMonster(dt.vx, dt.vy) = FALSE Then
         'Set the door to closed.
         SetDoorState(dt.vx, dt.vy, dsClosed)
      Else
         PrintMessage "The door is blocked."
      End If
   EndIf
End Sub

'Search immediate area around character.
Sub DoSearch ()
   Dim As vec dt
   Dim As Integer ret, found = FALSE, dam, tdr, pdat, sroll, proll
   Dim As weapdamtype tdamtype
   Dim As String tdesc
   
   'Get the character's intelligence factor, which is used in searching.
   pdat = GetCurrInt + GetBonInt
   'Look at each compass point.
   For i As compass = north To nwest
      'Check for a door next to player.
      dt.vx = GetLocx
      dt.vy = GetLocy
      'Get the new location.
      dt += i
      'Check for a trap.
      ret = IsTrap(dt.vx, dt.vy, dam, tdamtype, tdr, tdesc)
      If ret = TRUE Then
         proll = RandomRange(1, pdat)
         sroll = RandomRange(1, tdr)
         If proll > sroll Then
            DisArmTrap dt.vx, dt.vy
            'Give the player some experience.
            SetCurrXP GetCurrXP + tdr
            PrintMessage "You found and disarmed a " & tdesc & "!"
            found = TRUE
         End If   
      EndIf
   Next
   If found = FALSE Then
      PrintMessage "You did not find anything."
   EndIf
End Sub

'Manage all timed actions. These are done each turn.
Sub DoTimedEvents()
   'Do any monster or level timed events.
   DoCharTimedEvents 
   DoMapTimedEvents
End Sub

'Print morgue file to screen and file.
Sub PrintMorgueFile(winner As Integer)
   Dim As Integer fh, cnt
   Dim lines() As String * txcols 'Array of lines the width of screen.
   Dim As spelltype spl
   Dim As invtype inv
   Dim mstat As monstat
   
   'First we will build the data and place it in the string array: lines.
   'Use a dynamic array so we do not need to keep track of array size.
   cnt += 1
   ReDim Preserve lines(1 To cnt) As String * txcols
   lines(cnt) = "Dungeon of Doom " & dodver

   cnt += 1
   ReDim Preserve lines(1 To cnt) As String * txcols
   lines(cnt) = "" 

   cnt += 1
   ReDim Preserve lines(1 To cnt) As String * txcols
   lines(cnt) = "Name: " & CharName

   cnt += 1
   ReDim Preserve lines(1 To cnt) As String * txcols
   lines(cnt) = "" 
   
   cnt += 1
   ReDim Preserve lines(1 To cnt) As String * txcols
   If GetHasAmulet = TRUE Then
      lines(cnt) = "Found the Amulet of Crystal Fire"
   Else
      lines(cnt) = "Did not find the Amulet of Crystal Fire"
   EndIf
   
   cnt += 1
   ReDim Preserve lines(1 To cnt) As String * txcols
   If winner = TRUE Then
      lines(cnt) = "Escaped the dungeon."
   Else
      lines(cnt) = "Died on level " & GetLevelID
   End If

   cnt += 1
   ReDim Preserve lines(1 To cnt) As String * txcols
   GetLastMonster mstat
   lines(cnt) = "Last monster encounter was with a " & mstat.mname 

   cnt += 1
   ReDim Preserve lines(1 To cnt) As String * txcols
   lines(cnt) = "" 

   cnt += 1
   ReDim Preserve lines(1 To cnt) As String * txcols
   lines(cnt) = "* Attributes *"

   cnt += 1
   ReDim Preserve lines(1 To cnt) As String * txcols
   lines(cnt) = ""
   
   cnt += 1
   ReDim Preserve lines(1 To cnt) As String * txcols
   lines(cnt) = " Total Exp: " & TotXP

   cnt += 1
   ReDim Preserve lines(1 To cnt) As String * txcols
   lines(cnt) = " Max HP: " & GetMaxHP

   cnt += 1
   ReDim Preserve lines(1 To cnt) As String * txcols
   lines(cnt) = " Max Mana: " & MaxMana

   cnt += 1
   ReDim Preserve lines(1 To cnt) As String * txcols
   lines(cnt) = "Strength: " & GetCurrStr & " (" & GetBonStr & ")"
   
   cnt += 1
   ReDim Preserve lines(1 To cnt) As String * txcols
   lines(cnt) = "Stamina: " & GetCurrSta & " (" & GetBonSta & ")"
   
   cnt += 1
   ReDim Preserve lines(1 To cnt) As String * txcols
   lines(cnt) = "Dexterity: " & GetCurrDex & " (" & GetBonDex & ")"
   
   cnt += 1
   ReDim Preserve lines(1 To cnt) As String * txcols
   lines(cnt) = "Agility: " & GetCurrAgl & " (" & GetBonAgl & ")"
   
   cnt += 1
   ReDim Preserve lines(1 To cnt) As String * txcols
   lines(cnt) = "Intelligence: " & GetCurrInt & " (" & GetBonInt & ")"
   
   cnt += 1
   ReDim Preserve lines(1 To cnt) As String * txcols
   lines(cnt) = ""
   
   cnt += 1
   ReDim Preserve lines(1 To cnt) As String * txcols
   lines(cnt) = "* Held Inventory *"
    
   cnt += 1
   ReDim Preserve lines(1 To cnt) As String * txcols
   lines(cnt) = ""

   cnt += 1
   ReDim Preserve lines(1 To cnt) As String * txcols
   lines(cnt) = "Gold: " & TotGold
   
   cnt += 1
   ReDim Preserve lines(1 To cnt) As String * txcols
   lines(cnt) = ""
   
   'First get the wield items of the character.
   For i As wieldpos = wPrimary To wRingLt
      GetInventoryItem i, inv
      'Make sure we have an item.
      If inv.classid <> clNone Then
         cnt += 1
         ReDim Preserve lines(1 To cnt) As String * txcols
         lines(cnt) = GetWieldString(i) & ": " & GetInvItemDesc(inv) & " (" & GetItemSpell(inv) & ")"
      EndIf
   Next
   
   cnt += 1
   ReDim Preserve lines(1 To cnt) As String * txcols
   lines(cnt) = ""

   cnt += 1
   ReDim Preserve lines(1 To cnt) As String * txcols
   lines(cnt) = "* Backpack Inventory *"
    
   cnt += 1
   ReDim Preserve lines(1 To cnt) As String * txcols
   lines(cnt) = ""

   'Get inventory items in back pack.
   For i As Integer = LowInv To HighInv
      GetInventoryItem i, inv
      'Make sure we have an item.
      If inv.classid <> clNone Then
         cnt += 1
         ReDim Preserve lines(1 To cnt) As String * txcols
         lines(cnt) = GetInvItemDesc(inv) & " (" & GetItemSpell(inv) & ")"
      EndIf
   Next

   cnt += 1
   ReDim Preserve lines(1 To cnt) As String * txcols
   lines(cnt) = ""

   cnt += 1
   ReDim Preserve lines(1 To cnt) As String * txcols
   lines(cnt) = "* Spells Learned *"
    
   cnt += 1
   ReDim Preserve lines(1 To cnt) As String * txcols
   lines(cnt) = ""
   
   'Get any learned spells.
   For i As Integer = LowISpell To HighISpell
      'See if a spell is at index.
      spl = GetLearnedSpell(i)
      If spl.id <> splNone Then
         cnt += 1
         ReDim Preserve lines(1 To cnt) As String * txcols
         lines(cnt) = spl.splname & " (" & spl.lvl & ")"
      EndIf
   Next
   
   cnt += 1
   ReDim Preserve lines(1 To cnt) As String * txcols
   lines(cnt) = ""

   'List killed monsters.
   cnt += 1
   ReDim Preserve lines(1 To cnt) As String * txcols
   lines(cnt) = "* Monsters Vanquished *"
    
   cnt += 1
   ReDim Preserve lines(1 To cnt) As String * txcols
   lines(cnt) = ""
   
   For i As monids = monDarkangel To monGriffon
      'See if monster is in list.
      GetDeadMonster i, mstat
      If mstat.cnt > 0 Then
         cnt += 1
         ReDim Preserve lines(1 To cnt) As String * txcols
         lines(cnt) = mstat.mname & ": " & mstat.cnt
      EndIf
   Next
   
   'Save the data to character file.
   fh = FreeFile
   Open CharName & ".txt" For Output As #fh
   For i As Integer = 1 To UBound(lines)
      Print #fh, Trim(lines(i))
   Next
   Close
   
   cnt = 1
   'Print to screen.
   ScreenLock
	'Set the background.
	DrawBackground leatherback()
   For i As Integer = 1 To UBound(lines)
      cnt += 1
      PutTextShadow Trim(lines(i)), cnt, 2
      If cnt = txrows - 2 Then
         cnt += 1
         PutTextShadow "Press any key...", cnt, 2
         ScreenUnLock
         Sleep
         cnt = 1
         ScreenLock
	      DrawBackground leatherback()
      EndIf
   Next
   cnt += 2
   PutTextShadow "Press any key...", cnt, 2
   ScreenUnLock
   Sleep
End Sub

'Set to GDI to prevent DX issues on Win32.
#Ifdef __FB_WIN32__
   ScreenControl(fb.SET_DRIVER_NAME, "GDI")
#EndIf
'Using 640x480 32bit screen with 80x60 text.
ScreenRes sw, sh, 32
Width txcols, txrows
WindowTitle "Dungeon of Doom"
Randomize Timer 'Seed the rnd generator.
tWidgets.InitWidgets 'Initialzie the widgets.
'Init the blocking tiles.
InitBlockset
'Init the target spell set.
InitTargetSpells
'Draw the title screen.
DisplayTitle
'Get the menu selection
Dim mm As mmenu.mmenuret
'Load flag.
Dim maploaded As Integer = FALSE
'Loop until the user selects New, Load or Quit.
Do
   'Draw the main menu.
    mm = mmenu.MainMenu
   'Process the menu selection.
   If mm = mmenu.mNew Then
      'Generate the character.
      Var ret = GenerateCharacter
      'Do not exit menu when user presses ESC.
      If ret = FALSE Then
         'Set this so we loop.
         mm = mmenu.mInstruction
      Else
         'Do the intro.
         intro.DoIntro
      EndIf
   ElseIf mm = mmenu.mLoad Then
      Dim As tWidgets.tMsgbox sok
      Dim As tWidgets.btnID btn
      
      sok.MessageStyle = tWidgets.MsgBoxType.gmbOK
      sok.Title = "Load Game"
      If LoadGame() = FALSE Then
         btn = sok.MessageBox("Could not load game.")
         mm = mmenu.mInstruction
      Else
         btn = sok.MessageBox("Game loaded.")
         maploaded = TRUE
      EndIf
   ElseIf mm = mmenu.mInstruction Then
      'Print the instructions.
   EndIf
Loop Until mm <> mmenu.mInstruction

'Set the dead flag.
Dim As Integer isdead = FALSE, didwin = FALSE, done = FALSE
'Main game loop.
If mm <> mmenu.mQuit Then
   'If we loaded game, we don't need to generate it.
   If maploaded = FALSE Then
      'Set the first 
      LevelID 1
	   'Build the first level of dungeon
	   GenerateDungeonLevel
   End If
   'Display the main screen.
   DrawMainScreen TRUE
   Do
      ckey = InKey
      If ckey <> "" Then
         'Get direction key from numpad or arrows.
         'Check for up arrow or 8
         If (ckey = key_up) OrElse (ckey = "8") Then
            mret = MoveChar(north)
            If mret = TRUE Then DrawMainScreen
            MoveMonsters
            DrawMainScreen
            ClearKeys
         EndIf
         'Check for 9
         If ckey = "9" Then
            mret = MoveChar(neast)
            If mret = TRUE Then DrawMainScreen
            MoveMonsters
            DrawMainScreen
            ClearKeys
         EndIf
         'Check for right arrow or 6.
         If (ckey = key_rt) OrElse (ckey = "6") Then
            mret = MoveChar(east)
            If mret = TRUE Then DrawMainScreen
            MoveMonsters
            DrawMainScreen
            ClearKeys
         EndIf
         'Check for 3
         If ckey = "3" Then
            mret = MoveChar(seast)
            If mret = TRUE Then DrawMainScreen
            MoveMonsters
            DrawMainScreen
            ClearKeys
         EndIf
         'Check for down arrow or 2.
         If (ckey = key_dn) OrElse (ckey = "2") Then
            mret = MoveChar(south)
            If mret = TRUE Then DrawMainScreen
            MoveMonsters
            DrawMainScreen
            ClearKeys
         EndIf
         'Check for 1
         If ckey = "1" Then
            mret = MoveChar(swest)
            If mret = TRUE Then DrawMainScreen
            MoveMonsters
            DrawMainScreen
            ClearKeys
         EndIf
         'Check for left arrow or 4.
         If (ckey = key_lt) OrElse (ckey = "4") Then
            mret = MoveChar(west)
            If mret = TRUE Then DrawMainScreen
            MoveMonsters
            DrawMainScreen
            ClearKeys
         EndIf
         'Check for 7
         If ckey = "7" Then
            mret = MoveChar(nwest)
            If mret = TRUE Then DrawMainScreen
            MoveMonsters
            DrawMainScreen
            ClearKeys
         EndIf
         'Check for down stairs.
         If ckey = ">" Then
            'Check to make sure on down stairs.
            If GetTileID(GetLocx, GetLocy) = tstairdn Then
               'Set the level id.
               LevelID GetLevelID + 1
               'Build a new 
           	   GenerateDungeonLevel
               'Draw Screen.
               DrawMainScreen TRUE
            End If
         EndIf
         'Check for up stairs.
         If ckey = "<" Then
            'Check to make sure on up stairs.
            If GetTileID(GetLocx, GetLocy) = tstairup Then
               'If on first level and no amulet block escape.
               If (GetLevelID = 1) And (GetHasAmulet = FALSE) Then
                  PrintMessage "The way is magically blocked."
               'If on first level and has amulet, then set win and exit flag.
               ElseIf (GetLevelID = 1) And (GetHasAmulet = FALSE) Then
                  didwin = TRUE
                  done = TRUE
               Else
                  'Set the level id.
                  LevelID GetLevelID - 1
                  'Build a new 
              	   GenerateDungeonLevel
                  'Draw Screen.
                  DrawMainScreen TRUE
               EndIf
            End If
         EndIf
         'Get an item from the dungeon and put into character's inventory.
         If ckey = "g" Then
           'Inventory type.
            Dim inv As invtype
            'Make sure character is standing on an item.
            If HasItem(GetLocx, GetLocy) = TRUE Then
               'Check for gold. Just add gold to gold total.
               Dim iclass As classids = GetInvClassID(GetLocx, GetLocy)
               If iclass = clGold Then
                  'Get the gold from the map.
                  GetItemFromMap GetLocx, GetLocy, inv
                  'Add to gold total.
                  SetCurrGold GetCurrGold + inv.gold.amt
                  'Add to experience.
                  SetCurrXP GetCurrXP + inv.gold.amt
                  'Message player. 
                  PrintMessage inv.gold.amt & " gold coins collected."
                  DrawMainScreen
               Else
                  'Look for free inventory slot.
                  Dim As Integer cidx = GetFreeInventoryIndex
                  'If found a slot load inventory item.
                  If cidx <> -1 Then
                     GetItemFromMap GetLocx, GetLocy, inv
                     'Put it into character inventory.
                     AddInvItem cidx, inv
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
            MoveMonsters
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
            ClearKeys
            MoveMonsters
            DrawMainScreen
         EndIf
         'Load projectile weapon.
         If ckey = "l" Then
            LoadAmmo
            ClearKeys
            MoveMonsters
            DrawMainScreen
         EndIf
         'Cast a spell.
         If ckey = "c" Then
            CastSpell
            ClearKeys
            MoveMonsters
            DrawMainScreen
         EndIf
         'Pick as lock.
         If ckey = "p" Then
            PickLock
            ClearKeys
            MoveMonsters
            DrawMainScreen
         EndIf
         'Bash door.
         If ckey = "b" Then
            BashDoor
            ClearKeys
            MoveMonsters
            DrawMainScreen
         EndIf
         'Close door.
         If ckey = "d" Then
            CloseDoor
            ClearKeys
            MoveMonsters
            DrawMainScreen
         EndIf
         'Close door.
         If ckey = "s" Then
            DoSearch
            ClearKeys
            MoveMonsters
            DrawMainScreen
         EndIf
         'Check for escape key.
         If ckey = key_esc Then
            Dim As tWidgets.tMsgbox conf
            Dim As tWidgets.tMsgbox sav
            Dim As tWidgets.tMsgbox sok
            Dim As tWidgets.btnID btn
            
            'Ask the player if he wants to quit.
            conf.MessageStyle = tWidgets.MsgBoxType.gmbYesNo
            conf.Title = "Confirm Exit"
            btn = conf.MessageBox("Do you wish to quit?")
            If btn = tWidgets.btnID.gbnYes Then
               done = TRUE
               'Ask for save game.
               sav.MessageStyle = tWidgets.MsgBoxType.gmbYesNo
               sav.Title = "Confirm Exit"
               btn = sav.MessageBox("Do you wish to save the game?")
               If btn = tWidgets.btnID.gbnYes Then
                  sok.MessageStyle = tWidgets.MsgBoxType.gmbOK
                  sok.Title = "Save Game"
                  If SaveGame() = FALSE Then
                     btn = sok.MessageBox("Could not save game.")
                  Else
                     btn = sok.MessageBox("Game saved.")
                  EndIf
               EndIf
            EndIf
         EndIf
         'Since the player pressed a key, do any timed actions.
         DoTimedEvents
         'Check for whether character is dead.
         If GetCurrHP <= 0 Then
            isdead = TRUE
            done = TRUE
         EndIf
      End If
      Sleep 1
   Loop Until done = TRUE
EndIf
ClearKeys
'Print dead mesage.
If isdead = TRUE Then
   DrawBackground char_dead()
   ckey = CharName & " has died in the depths of the dungeon."
   PutTextShadow ckey, 20, (txcols / 2) - (Len(ckey) / 2)
   ckey = "Rest in peace valiant warrior!"
   PutTextShadow ckey, 22, (txcols / 2) - (Len(ckey) / 2)
   Sleep
   ClearKeys
   'Print the moegue file.
   PrintMorgueFile didwin
EndIf
'Print the win screen.
If didwin = TRUE Then
   DrawBackground char_win()
   ckey = CharName & " has escaped the dungeon with the Amulet!"
   PutTextShadow ckey, 12, (txcols / 2) - (Len(ckey) / 2)
   ckey = "The Kingdom will be saved! Long live King " & CharName & "!"
   PutTextShadow ckey, 14, (txcols / 2) - (Len(ckey) / 2)
   ckey = "All Hail King " & CharName & "!"
   PutTextShadow ckey, 16, (txcols / 2) - (Len(ckey) / 2)
   Sleep
   ClearKeys
   'Print the moegue file.
   PrintMorgueFile didwin
EndIf
