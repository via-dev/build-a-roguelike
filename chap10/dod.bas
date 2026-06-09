/'****************************************************************************
*
* Name: dod.bas
*
* Synopsis: Dungeon of Doom
*
* Description: A simple roguelike as detailed in the wikibook, Let's Build a 
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
#Include "mainback.bi"
#Include "title.bi"
#Include "defs.bi"
#Include "utils.bi"
#Include "mmenu.bi"
#Include "character.bi"
#Include "intro.bi"
#Include "map.bi"
#Include "vec.bi"
#Include "commands.bi"

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

Sub ClearMessageArea()
   Dim As Integer y, x, j
   
   y =  1 + vh + 2
   For x = 2 To txcols - 1
      For j = 0 To 3
         PutText acBlock, y + j, x, fbBlack
      Next
   Next
   
End Sub

'Prints any messages to screen.
Sub PrintMessage(txt As String)
   Dim As Integer i, x, y
   
   If Len(txt) > 0 Then
      'Move all messages down by 1.
      For i = 3 To 1 Step -1
         mess(i + 1) = mess(i)
      Next
      mess(1) = txt
   End If
   'Clear current messages.
   ClearMessageArea
   'Print out messages.
   y =  1 + vh + 2
   x = 3
   For i = 1 To 4
      PutText mess(i), y, x, messcolor(i)
      y += 1
   Next
End Sub

'Draws the main game screen.
Sub DrawMainScreen ()
   Dim As Integer x, y, j, pct, row, col
   Dim As Double pctd
   Dim As UInteger clr
   Dim As String txt
   Dim As terrainids terr
   
   ScreenLock
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
   DrawStringShadow charw, 0, "Dungeon Level: " & level.LevelID
   'Draw the character name.
   row = 3
   col = vw + 4
   PutText pchar.CharName, row, col, fbYellowBright
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
   txt = String((txcols - 1) - (col + 4), acBlock)
   PutText "    " & txt, row, col, fbBlack
   txt = String((txcols - 1) - (col + 4), Chr(176))
   PutText "    " & txt, row, col, fbGray
   txt = String(Len(txt) * pctd, acBlock)
   PutText "    " & txt, row, col, clr
   PutText "HP: ", row, col
   'Draw the health amount.
   txt = pchar.CurrHP & "/" & pchar.MaxHP
   DrawStringShadow (txcols - (Len(txt) + 2)) * charw, (row - 1) * charh, txt
   'Draw the main stats.
   row += 2
   PutText "Stats", row, col, fbYellowBright
   row += 2
   If pchar.BonStr > -1 Then
      txt = " +"
   Else
      txt = " -"
   EndIf
   PutText "Str: " & pchar.CurrStr & txt & pchar.BonStr, row, col
   row += 1
   If pchar.BonSta > -1 Then
      txt = " +"
   Else
      txt = " -"
   EndIf
   PutText "Sta: " & pchar.CurrSta & txt & pchar.BonSta, row, col
   row += 1
   If pchar.BonDex > -1 Then
      txt = " +"
   Else
      txt = " -"
   EndIf
   PutText "Dex: " & pchar.CurrDex & txt & pchar.BonDex, row, col
   row += 1
   If pchar.BonAgl > -1 Then
      txt = " +"
   Else
      txt = " -"
   EndIf
   PutText "Agl: " & pchar.CurrAgl & txt & pchar.BonAgl, row, col
   row += 1
   If pchar.BonInt > -1 Then
      txt = " +"
   Else
      txt = " -"
   EndIf
   PutText "Int: " & pchar.CurrInt & txt & pchar.BonInt, row, col
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
   PutText "UCF: " & pchar.CurrUcf & txt & pchar.BonUcf, row, col
   row += 1
   If pchar.BonAcf > -1 Then
      txt = " +"
   Else
      txt = " -"
   EndIf
   PutText "ACF: " & pchar.CurrAcf & txt & pchar.BonAcf, row, col
   row += 1
   If pchar.BonPcf > -1 Then
      txt = " +"
   Else
      txt = " -"
   EndIf
   PutText "PCF: " & pchar.CurrPcf & txt & pchar.BonPcf, row, col
   row += 1
   If pchar.BonMcf > -1 Then
      txt = " +"
   Else
      txt = " -"
   EndIf
   PutText "MCF: " & pchar.CurrMcf & txt & pchar.BonMcf, row, col
   row += 1
   If pchar.BonCdf > -1 Then
      txt = " +"
   Else
      txt = " -"
   EndIf
   PutText "CDF: " & pchar.CurrCdf & txt & pchar.BonCdf, row, col
   row += 1
   If pchar.BonMdf > -1 Then
      txt = " +"
   Else
      txt = " -"
   EndIf
   PutText "MDF: " & pchar.CurrMdf & txt & pchar.BonMdf, row, col
   row += 2
   PutText "Equipment", row, col, fbYellowBright
   row += 2
   PutText "Gold: " & pchar.CurrGold, row, col
   row += 1
   PutText "RT Hand: ", row, col
   row += 1
   PutText "LT Hand: ", row, col
   row += 1
   PutText "Armor: ", row, col
   row += 2
   PutText "Keys", row, col, fbYellowBright
   row += 2
   PutText "Move:.Arrows or Numpad", row, col
   row += 1
   PutText "?.....Help", row, col
   row += 1
   PutText "v.....Inventory", row, col
   row += 1
   PutText "x.....Improve Character", row, col
   row += 1
   PutText "l.....Spell Book", row, col
   row += 1
   PutText ">.....Down Level", row, col
   row += 1
   PutText "<.....Up Level", row, col
   row += 1
   PutText "i.....Inspect Tile", row, col
   row += 1
   PutText "s.....Search Area", row, col
   row += 1
   PutText "t.....Target Enemy", row, col
   row += 1
   PutText "r.....Read Scroll", row, col
   row += 1
   PutText "c.....Cast Spell", row, col
   row += 1
   PutText "e.....Drink/Eat Item", row, col
   row += 1
   PutText "g.....Get Item", row, col
   row += 1
   PutText "d.....Drop Item", row, col
   row += 1
   PutText "p.....Pick Lock", row, col
   row += 1
   PutText "b.....Bash Door", row, col
   'Check to see if character standing on an item.
   If level.HasItem(pchar.Locx, pchar.Locy) = TRUE Then
      'Get item desc.
   Else
      'See if character is on special tile.
      terr = level.GetTileID(pchar.Locx, pchar.Locy)
      If (terr = tstairup) OrElse (terr = tstairdn) Then
         txt = level.GetTerrainDescription(pchar.Locx, pchar.Locy)
         PrintMessage txt
      End If
   EndIf
   ScreenUnLock
End Sub

'Using 640x480 32bit screen with 80x60 text.
ScreenRes 640, 480, 32
Width txcols, txrows
WindowTitle "Dungeon of Doom"
Randomize Timer

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

'Main game loop.
If mm <> mmenu.mQuit Then
   'Set the first level.
   level.LevelID = 1
	'Build the first level of dungeon
	level.GenerateDungeonLevel
	'Set the background for the main screen.
	DrawBackground mainback()
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
         EndIf
         'Check for 9
         If ckey = "9" Then
            mret = MoveChar(neast)
            If mret = TRUE Then DrawMainScreen
         EndIf
         'Check for right arrow or 6.
         If (ckey = key_rt) OrElse (ckey = "6") Then
            mret = MoveChar(east)
            If mret = TRUE Then DrawMainScreen
         EndIf
         'Check for 3
         If ckey = "3" Then
            mret = MoveChar(seast)
            If mret = TRUE Then DrawMainScreen
         EndIf
         'Check for down arrow or 2.
         If (ckey = key_dn) OrElse (ckey = "2") Then
            mret = MoveChar(south)
            If mret = TRUE Then DrawMainScreen
         EndIf
         'Check for 1
         If ckey = "1" Then
            mret = MoveChar(swest)
            If mret = TRUE Then DrawMainScreen
         EndIf
         'Check for left arrow or 4.
         If (ckey = key_lt) OrElse (ckey = "4") Then
            mret = MoveChar(west)
            If mret = TRUE Then DrawMainScreen
         EndIf
         'Check for 7
         If ckey = "7" Then
            mret = MoveChar(nwest)
            If mret = TRUE Then DrawMainScreen
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
      End if
      Sleep 1
   Loop Until ckey = key_esc
EndIf
