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
   Do:Sleep 1:Loop While InKey <> ""
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

'Returns a random number within range.
Function RandomRange(lowerbound As Integer, upperbound As Integer) As Integer
	Return Int((upperbound - lowerbound + 1) * Rnd + lowerbound)
End Function

'Draw a string with drop shadow.
Sub DrawStringShadow(x As Integer, y As Integer, txt As String, fcolor As UInteger = fbWhite)
   Draw String (x + 1, y + 1), txt, fbBlack   
   Draw String (x, y), txt, fcolor   
End Sub

'Writes text at specified row and column.
Sub PutText(txt As String, row As Integer, col As Integer, fcolor As UInteger = fbWhite)
	Dim As Integer x, y
	
	x = (col - 1) * charw
	y = (row - 1) * charh
	Draw String (x, y), txt, fcolor
End Sub

'Writes text at specified row and column with shadow.
Sub PutTextShadow(txt As String, row As Integer, col As Integer, fcolor As UInteger = fbWhite)
	Dim As Integer x, y
	
	x = (col - 1) * charw
	y = (row - 1) * charh
	Draw String (x + 1, y + 1), txt, fbBlack
	Draw String (x, y), txt, fcolor
End Sub

'Splits text InS at sLen and returns clipped string.
Function WordWrap(InS As String, sLen As Integer) As String
    Dim As Integer i = sLen, sl
    Dim As Integer BackFlag = FALSE
    Dim As String sret, ch
    
    'Make sure we have something to work with here.
    sl = Len(InS)
    If sl <= sLen Then
        sret = InS
        InS = ""
    Else
    		'Find the break point in the string, backtracking
    		'to find a space to break the line at if not at a space.
        Do
            'Break is at space, so done.
            ch = Mid(InS, i, 1)
            If ch = Chr(32) Then
                Exit Do
            End If
            'If not backtracking, start backtrack.
            If BackFlag = FALSE Then
                If i + 1 <= sl Then
                    i+= 1
                End If
                BackFlag = TRUE
            Else
                i -= 1
            End If
        Loop Until i = 0 Or ch = Chr(32) 'Backtrack to space.
        'Make sure we still have something to work with.
        If i > 0 Then
        		'Return clipped string.
            sret = Mid(InS, 1, i)
            'Modify the input string: string less clipped.
            InS = Mid(InS, i + 1)
        Else
            sret = ""
        End If 
    End If
    Return sret
End Function

'Calculate the distance between two points.
Function CalcDist(x1 As Integer, x2 As Integer, y1 As Integer, y2 As Integer) As Integer
   
   Return Sqr(((x2 - x1) * (x2 - x1)) + ((y2 - y1) * (y2 - y1)))
   
End Function


'Print message to user using msgbox.
Sub ShowMsg(title As String, mess As String, mtype As tWidgets.MsgBoxType)
   Dim As tWidgets.tMsgbox mb
   Dim As tWidgets.btnID btn

   mb.MessageStyle = mtype
   mb.Title = title
   btn = mb.MessageBox(mess)
   
End Sub

'Clears the message area.
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
   Static msg As String
   
   txt = Trim(txt, Any Chr(32) & Chr(9))
   
   If (Len(txt) > 0) And (txt <> msg) Then
      'Move all messages down by 1.
      For i = 3 To 1 Step -1
         mess(i + 1) = mess(i)
      Next
      mess(1) = txt
      msg = txt
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

'Returns a scaled factor based on passed base value.
Function GetScaledFactor(basevalue As Integer, currlevel As Integer) As Integer
   Dim As Double pct
   Dim As Integer ret, range, fac, fac2 
   
   'Get the percentage factor for the current level.
   pct = currlevel / maxlevel
   'Get the range for the base value.
   range = basevalue * .25
   'Generate the factor based on the range.
   fac = RandomRange(-range, range)
   'Get the value based on the range + basevalue
   ret = basevalue + fac
   'Get the level percentage amount.
   fac2 = (ret * pct) + 1 
   'Add in the percentage of the level.
   ret = ret + fac2
   
   Return ret
End Function

'Used for debug purposes.
Sub DebugMessage (mess As String)
   Dim As tWidgets.tMsgbox mb
   Dim As tWidgets.btnID btn

   mb.MessageStyle = tWidgets.MsgBoxType.gmbOK
   mb.Title = "Debug"
   btn = mb.MessageBox(mess)
End Sub

