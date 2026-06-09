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

'Displays the game title screen.
Sub DisplayTitle
   Dim As String txt
   Dim As Integer tx, ty
   
   'Set up the copyright notice.
   txt = "Copyright (C) 2010, by Richard D. Clark"
   tx = (txcols / 2) - (Len(txt) / 2)
   ty = txrows - 2
   
   'Lock the screen while we update it.
   ScreenLock
   Cls
   'Iterate through the array, drawing the block character in the array color.
   For x As Integer = 0 To titlew - 1
      For y As Integer = 0 To titleh - 1
         'Get the color out of the array using the formula.
         Dim clr As UInteger = title(x + y * titlew)
         'Use draw string as it is faster and we don't need to worry about locate statements.
         Draw String (x * charw, y * charh), acBlock, clr 
      Next
   Next
   'Draw the copyright notice.
   Draw String (tx * charw, ty * charw), txt, fbYellow
   ScreenUnlock
   Sleep
   'Clear the key buffer.
   Do:Sleep 1:Loop While Inkey <> ""
End Sub


'Using 640x480 32bit screen with 80x60 text.
ScreenRes 640, 480, 32
Width charw, charh
WindowTitle "Dungeon of Doom"

'Draw the title screen.
DisplayTitle


