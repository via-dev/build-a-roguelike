/'****************************************************************************
*
* Name: save.bi
*
* Synopsis: Save and load routines.
*
* Description: This file contains all the save and load data structure and 
*              routines.
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

'This is our load and save type.
Type savedata
   char As characterinfo 'The character data.
   level As levelinfo    'The level data.
End Type

Dim Shared sg As savedata

'The load routine.
Function SaveGame() As Integer
   Dim As Integer ret = TRUE, fh
   
   'Load the character data into the type.
   pchar.GetCharacterData sg.char
   'Load the level data.
   level.GetLevelData sg.level
   'Save the file.
   fh = FreeFile
   If Open("dod.sav" For Binary As #fh) <> 0 Then
      ret = FALSE
   Else
      Put #fh,, sg
   EndIf
   Close
      
   Return ret
End Function

'The save routine.
Function LoadGame() As Integer
   Dim As Integer ret = TRUE, fh
   
   'Check for file on disk.
   If Len(Dir("dod.sav")) = 0 Then
      ret = FALSE
   Else
      'Try to open file.
      fh = FreeFile
      If Open("dod.sav" For Binary As #fh) <> 0 Then
         ret = FALSE
      Else
         Get #fh,,sg 
         'Load the data into the objects.
         pchar.SetCharacterData sg.char
         level.SetLevelData sg.level
      EndIf
   EndIf
   Close
   
   Return ret
End Function
