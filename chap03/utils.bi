/'****************************************************************************
*
* Name: utils.bi
*
* Synopsis: Utility routines for DOD.
*
* Description: This file contains misc utility routines used in the program.  
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

'Clears key board buffer.
Sub ClearKeys
   Do:Sleep 1:Loop While Inkey <> ""
End Sub

'Draws a background image using passed color map.
Sub DrawBackground(cmap() As UInteger)
   'Iterate through the array, drawing the block character in the array color.
   For x As Integer = 0 To txcols - 1
      For y As Integer = 0 To txrows - 1
         'Get the color out of the array using the formula.
         Dim clr As UInteger = cmap(x + y * txcols)
         'Use draw string as it is faster and we don't need to worry about locate statements.
         Draw String (x * charw, y * charh), acBlock, clr
      Next
   Next
End Sub
