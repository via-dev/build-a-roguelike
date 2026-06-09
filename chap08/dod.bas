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
#Include "title.bi"
#Include "defs.bi"
#Include "utils.bi"
#Include "mmenu.bi"
#Include "character.bi"
#Include "intro.bi"
#Include "map.bi"


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
   
   ScreenLock
   Cls
   level.DrawMap
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
	'Build the first level of dungeon
	level.GenerateDungeonLevel
   'Display the main screen.
   DrawMainScreen
   'Get key input until user exits.
EndIf

Sleep
