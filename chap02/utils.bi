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

