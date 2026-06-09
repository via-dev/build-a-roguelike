/'****************************************************************************
*
* Name: set.bi
*
* Synopsis: Defines a set object.
*
* Description: This file defines the set object that can be used to create a
*              collection of data items.  
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

'Check for existing defines.
#Ifndef NULL
#Define NULL 0
#EndIf
#Ifndef FALSE
#Define FALSE 0
#Define TRUE (Not FALSE)
#EndIf

Type setobj
   Private:
   _set As Integer Ptr 'The actual set.
   _setcnt As Integer  'The number of elements in the set.
   Declare Sub _DestroySet() 'Clears object and returns memory.
   Public:
   Declare Constructor ()
   Declare Destructor ()
   Declare Function AddToSet (item As Integer)As Integer 'Returns TRUE if item is added.
   Declare Function IsMember(item As integer) As Integer 'Returns TRUE if item is in the set.
End Type

'This clears the object and releases memory.
Sub setobj._DestroySet()
   If _set <> NULL Then
      DeAllocate _set
      _set = NULL
   EndIf
End Sub
'Constructor doesn't do much at the moment.
Constructor setobj ()
   _DestroySet
End Constructor

'Calls the destroy method to clear the object.
Destructor setobj ()
   _DestroySet
End Destructor

'Returns TRUE if item is added.
Function setobj.AddToSet (item As Integer)As Integer
   Dim As Integer ret = TRUE
   
   If _set = NULL Then
      _setcnt += 1
      _set = Callocate(_setcnt, SizeOf(Integer))
      _set[_setcnt - 1] = item 
   Else
      'Check for existing item.
      For i As Integer = 0 To _setcnt - 1
         If _set[i] = item Then
            ret = FALSE
            Exit For
         EndIf
      Next
      'If not found add it.
      If ret = TRUE Then
         _setcnt += 1
         _set = ReAllocate(_set, _setcnt * SizeOf(Integer))
         If _set <> NULL Then
            _set[_setcnt - 1] = item
         EndIf
      EndIf
   EndIf
   
   Return ret
End Function

'Returns TRUE if item is in the set.
Function setobj.IsMember(item As integer) As Integer
   Dim As Integer ret = FALSE
   
   If _set <> NULL Then
      For i As Integer = 0 To _setcnt - 1
         If _set[i] = item Then
            ret = TRUE
            Exit For
         EndIf
      Next
   EndIf
   
   Return ret
End Function
