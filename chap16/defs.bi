/'****************************************************************************
*
* Name: defs.bi
*
* Synopsis: Data definitions for DOD.
*
* Description: This file contains the various data definitions used in the game.  
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
'Define true and false.
#Ifndef FALSE
   #Define FALSE 0
#EndIf
#Ifndef TRUE
   #Define TRUE -1
#EndIf
'NULL value.
#Define NULL 0
'Return max of two items.
#Define imax(a,b) IIf( a > b, a, b ) 
'Using 8x8 characters.
#Define charw 8
#Define charh 8
'Graphics screen.
#Define sw 640
#Define sh 480
'Text mode 80x60
#Define txcols 80
#Define txrows 60
'Macro that calculates the center point on the screen.
#Define CenterX(ct) ((txcols / 2) - (Len(ct) / 2))
#Define CenterY(ni)((txrows / 2) - (ni / 2))
'Maximum levls in game (not counting boss level).
#Define maxlevel 50
'Current version.
Const dodver = "0.1.0"
'Colors
Const fbYellow = RGB(200, 200, 0)
Const fbYellowBright = RGB(255, 255, 0)
Const fbWhite = RGB(255, 255, 255)
Const fbWhite1 = RGB(200, 200, 200)
Const fbWhite2 = RGB(150, 150, 150)
Const fbWhite3 = RGB(100, 100, 100)
Const fbBlack = RGB(0, 0, 0)
Const fbGray = RGB(128, 128, 128)
Const fbTan = RGB (210, 180, 140)
Const fbSlateGrayDark = RGB (47, 79, 79)
Const fbGreen = RGB (0, 200, 0)
Const fbRed = RGB (200, 0, 0)
Const fbRedBright = RGB (255, 0, 0)
Const fbSienna = RGB (160, 082, 045)
Const fbGold = RGB (255, 215, 000)
Const fbSalmon = RGB (250, 128, 114)
Const fbHoneydew = RGB (240, 255, 240)
Const fbYellowGreen = RGB (154, 205, 050)
Const fbSteelBlue = RGB (70, 130, 180)
const fbCadmiumYellow = RGB (255, 153, 18)

'Ascii Chars
Const acBlock = Chr(219)
'Key consts
Const xk = Chr(255)
Const key_up = xk & "H"
Const key_dn = xk & "P"
Const key_rt = xk & "M"
Const key_lt = xk & "K"
Const key_close = xk + "k"
Const key_esc = Chr(27)
Const key_enter = Chr(13)
Const key_home = xk & "G"
Const key_end = xk & "O"
Const key_tab = Chr(9)
Const key_bkspc = Chr(8)
Const key_del = xk & "S"

'Message list.
Dim Shared mess(1 To 4) As String
Dim Shared messcolor(1 To 4) As UInteger = {fbWhite, fbWhite1, fbWhite2, fbWhite3}

'Working variables.
Dim As String ckey
Dim As Integer mret
