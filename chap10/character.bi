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
   stratt(2) As Integer 'Strength attribute (0), str bonus (1)
   staatt(2) As Integer 'Stamina attribute (0), sta bonus (1)
   dexatt(2) As Integer 'Dexterity attribute (0), dex bonus (1)
   aglatt(2) As Integer 'Agility attribute (0), sta bonus (1)
   intatt(2) As Integer 'Intelligence attribute (0), int bonus (1)
   currhp As Integer    'Current HP
   maxhp As Integer     'Max HP
   ucfsk(2) As Integer  'Unarmed combat skill (0), ucf bonus (1)
   acfsk(2) As Integer  'Armed combat skill (0), acf bonus (1)
   pcfsk(2) As Integer  'Projectile combat skill (0), pcf bonus (1)
   mcfsk(2) As Integer  'Magic combat skill (0), mcf bonus (1)
   cdfsk(2) As Integer  'Combat defense skill (0), cdf bonus (1)
   mdfsk(2) As Integer  'Magic defense skill (0), mdf bonus (1)
   currxp As Integer    'Current spendable XP amount.
   totxp As Integer     'Lifetime XP amount.
   currgold As Integer  'Current gold amount.
   totgold As Integer   'Lifetime gold amount.
   ploc As mcoord     'Character current x and y location.
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
   Declare Property CurrStr() As Integer    'Returns the current strength value.
   Declare Property CurrStr(amt As Integer) 'Sets the current strength value. 
   Declare Property BonStr() As Integer     'Returns the current strength bonus value..
   Declare Property BonStr(amt As Integer)  'Sets the current strength bonus value.
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
   Declare Sub PrintStats ()
   Declare Function GenerateCharacter() As Integer
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

'Sets the current strength bonus value.
Property character.BonStr(amt As Integer)  
   _cinfo.stratt(1) = amt
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

'Generates a new character.
Function character.GenerateCharacter() As Integer
   Dim As String chname, prompt, skey
   Dim As Integer done = FALSE, ret = TRUE, tx, ty
   
   'Set up user input prompt.
   prompt = "Press <r> to roll again, <enter> to accept, <esc> to exit to menu."
   tx = (CenterX(prompt)) * charw
   ty = (txrows - 6) * charh   
   'Get the name of the character.
   Do
      Cls
      'Using simple input here.
      Input "Enter your character's name (35 chars max):",chname
      'Validate the name here. 
      If Len(chname) > 0 And Len(chname) < 41 Then
         done = TRUE
      Else
         'Let the user know what they did wrong.
         Cls
         If Len(chname) = 0 Then
            Print "Name is required. <Press any key.>"
            Sleep
            ClearKeys
         EndIf
         If Len(chname) > 40 Then
            Print "Name is too long. 40 chars max. <Press any key.>"
            Sleep
            ClearKeys
         EndIf
      EndIf
      Sleep 10
   Loop Until done = TRUE
   done = FALSE
   'Generate the character data.
   Do
      With _cinfo
         .cname = chname
         .stratt(0) = RandomRange (1, 20)
         .staatt(0) = RandomRange (1, 20)
         .dexatt(0) = RandomRange (1, 20)
         .aglatt(0) = RandomRange (1, 20)
         .intatt(0) = RandomRange (1, 20)
         .currhp = .stratt(0) + .staatt(0) 
         .maxhp = .currhp
         .ucfsk(0) = .stratt(0) + .aglatt(0) 
         .acfsk(0) = .stratt(0) + .dexatt(0) 
         .pcfsk(0) = .dexatt(0) + .intatt(0)
         .mcfsk(0) = .intatt(0) + .staatt(0)
         .cdfsk(0) = .stratt(0) + .aglatt(0)
         .mdfsk(0) = .aglatt(0) + .intatt(0)
         .currxp = RandomRange (100, 200)
         .totxp = .currxp
         .currgold = RandomRange (50, 100)
         .totgold = .currgold
         .ploc.x = 0
         .ploc.y = 0
      End With
      'Print out the current character stats.
      PrintStats
      DrawStringShadow tx, ty, prompt
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
   Return ret
End Function

'Set up our character variable.
Dim Shared pchar As character
 