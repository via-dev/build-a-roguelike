/'****************************************************************************
*
* Name: map.bi
*
* Synopsis: Map related routines.
*
* Description: This file contains map related routines used in the program.  
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
#Include "mapdec.bi"


'Initlaizes object.
Sub InitBlockset ()
   Dim As Integer ret
   
   'Set the level number.
   level.numlevel = 0
   'Create the blocking set.
   ret = blockset.AddToSet(twall)
   ret = blockset.AddToSet(tdoorclosed)
   ret = blockset.AddToSet(tstairup)
   ret = blockset.AddToSet(twmerch)
End Sub

'Sets the current 
Sub LevelID(lvl As Integer)
   level.numlevel = lvl
End sub

'Returns the current level number.
Function GetLevelID() As Integer
   Return level.numlevel
End Function

'Returns True if tile is blocking tile.
Function BlockingTile(tx As Integer, ty As Integer) As Integer
   Dim ret As Integer
   
   'Check to see if tile is in blocking set.
   ret = (blockset.IsMember(level.lmap(tx, ty).terrid) = TRUE)
   
   Return ret
End Function

'Bresenhams line algo
Function LineOfSight(x1 As Integer, y1 As Integer, x2 As Integer, y2 As Integer) As Integer
    Dim As Integer i, deltax, deltay, numtiles
    Dim As Integer d, dinc1, dinc2
    Dim As Integer x, xinc1, xinc2
    Dim As Integer y, yinc1, yinc2
    Dim isseen As Integer = TRUE
    
    deltax = Abs(x2 - x1)
    deltay = Abs(y2 - y1)

    If deltax >= deltay Then
        numtiles = deltax + 1
        d = (2 * deltay) - deltax
        dinc1 = deltay Shl 1
        dinc2 = (deltay - deltax) Shl 1
        xinc1 = 1
        xinc2 = 1
        yinc1 = 0
        yinc2 = 1
    Else
        numtiles = deltay + 1
        d = (2 * deltax) - deltay
        dinc1 = deltax Shl 1
        dinc2 = (deltax - deltay) Shl 1
        xinc1 = 0
        xinc2 = 1
        yinc1 = 1
        yinc2 = 1
    End If

    If x1 > x2 Then
        xinc1 = - xinc1
        xinc2 = - xinc2
    End If
    
    If y1 > y2 Then
        yinc1 = - yinc1
        yinc2 = - yinc2
    End If

    x = x1
    y = y1
    
    For i = 2 To numtiles
      If BlockingTile(x, y) Then
        isseen = FALSE
        Exit For
      End If
      If d < 0 Then
          d = d + dinc1
          x = x + xinc1
          y = y + yinc1
      Else
          d = d + dinc2
          x = x + xinc2
          y = y + yinc2
        End If
    Next
    
    Return isseen
End Function

'Determines if player can see object.
Function CanSee(tx As Integer, ty As Integer) As Integer
   Dim As Integer ret = FALSE, px = GetLocx, py = GetLocy, vis = vh
   Dim As Integer dist
        
	dist = CalcDist(GetLocx, tx, GetLocy, ty)
	If dist <= vis Then
   	ret = LineOfSight(tx, ty, px, py)
	End If
    
   Return ret
End Function

'Caclulate los with post processing.
Sub CalcLOS 
	Dim As Integer i, j, x, y, w = vw / 2, h = vh / 2
	Dim As Integer x1, x2, y1, y2
	
	'Clear the vismap
	For i = 1 To mapw
   	For j = 1 To maph
   		level.lmap(i, j).visible = FALSE
   	Next
	Next
	'Only check within viewport
	x1 = GetLocx - w
	If x1 < 1 Then x1 = 1
	y1 = GetLocy - h
	If y1 < 1 Then y1 = 1
	
	x2 = GetLocx + w
	If x2 > mapw Then x2 = mapw
	y2 = GetLocy + h
	If y2 > maph Then y2 = maph
	'iterate through vision area
	For i = x1 To x2
		For j = y1 To y2
	   	'Don't recalc seen tiles
	      If level.lmap(i, j).visible = FALSE Then
	         If CanSee(i, j) Then
	         	level.lmap(i, j).visible = TRUE
	         	level.lmap(i, j).seen = TRUE
	         End If
	      End If
	  Next
	Next
	'Post process the map to remove artifacts.
	For i = x1 To x2
		For j = y1 To y2
			If (BlockingTile(i, j) = TRUE) And (level.lmap(i, j).visible = FALSE) Then
				x = i
				y = j - 1
				If (x > 0) And (x < mapw + 1) Then
					If (y > 0) And (y < maph + 1) Then
						If (level.lmap(x, y).terrid = tfloor) And (level.lmap(x, y).visible = TRUE) Then
							level.lmap(i, j).visible = TRUE
							level.lmap(i, j).seen = TRUE
						EndIf
					EndIf
				EndIf 
				
				x = i
				y = j + 1
				If (x > 0) And (x < mapw + 1) Then
					If (y > 0) And (y < maph + 1) Then
						If (level.lmap(x, y).terrid = tfloor) And (level.lmap(x, y).visible = TRUE) Then
							level.lmap(i, j).visible = TRUE
							level.lmap(i, j).seen = TRUE
						EndIf
					EndIf
				EndIf 

				x = i + 1
				y = j
				If (x > 0) And (x < mapw + 1) Then
					If (y > 0) And (y < maph + 1) Then
						If (level.lmap(x, y).terrid = tfloor) And (level.lmap(x, y).visible = TRUE) Then
							level.lmap(i, j).visible = TRUE
							level.lmap(i, j).seen = TRUE
						EndIf
					EndIf
				EndIf 

				x = i - 1
				y = j
				If (x > 0) And (x < mapw + 1) Then
					If (y > 0) And (y < maph + 1) Then
						If (level.lmap(x, y).terrid = tfloor) And (level.lmap(x, y).visible = TRUE) Then
							level.lmap(i, j).visible = TRUE
							level.lmap(i, j).seen = TRUE
						EndIf
					EndIf
				EndIf 

				x = i - 1
				y = j - 1
				If (x > 0) And (x < mapw + 1) Then
					If (y > 0) And (y < maph + 1) Then
						If (level.lmap(x, y).terrid = tfloor) And (level.lmap(x, y).visible = TRUE) Then
							level.lmap(i, j).visible = TRUE
							level.lmap(i, j).seen = TRUE
						EndIf
					EndIf
				EndIf 

				x = i + 1
				y = j - 1
				If (x > 0) And (x < mapw + 1) Then
					If (y > 0) And (y < maph + 1) Then
						If (level.lmap(x, y).terrid = tfloor) And (level.lmap(x, y).visible = TRUE) Then
							level.lmap(i, j).visible = TRUE
							level.lmap(i, j).seen = TRUE
						EndIf
					EndIf
				EndIf 

				x = i + 1
				y = j + 1
				If (x > 0) And (x < mapw + 1) Then
					If (y > 0) And (y < maph + 1) Then
						If (level.lmap(x, y).terrid = tfloor) And (level.lmap(x, y).visible = TRUE) Then
							level.lmap(i, j).visible = TRUE
							level.lmap(i, j).seen = TRUE
						EndIf
					EndIf
				EndIf 

				x = i - 1
				y = j + 1
				If (x > 0) And (x < mapw + 1) Then
					If (y > 0) And (y < maph + 1) Then
						If (level.lmap(x, y).terrid = tfloor) And (level.lmap(x, y).visible = TRUE) Then
							level.lmap(i, j).visible = TRUE
							level.lmap(i, j).seen = TRUE
						EndIf
					EndIf
				EndIf
				
			EndIf 
		Next
	Next
End Sub

'Return ascii symbol for tile
Function GetMapSymbol(tile As terrainids) As String
	Dim As String ret
	
   Select Case tile
   	Case twall
   		ret = Chr(178)
   	Case tfloor
   		ret = Chr(249)
      Case tstairup
   		ret = "<"
      Case tstairdn
   		ret = ">"
   	Case tdooropen
   		ret = "'"
   	Case tdoorclosed
   		ret = "\"
      Case twmerch
         ret = "W"
      Case tamulet
         ret = Chr(21)
   	Case Else
            ret = "?"
   End Select
   
   Return ret
End Function

'Returns the color for object.
Function GetMapSymbolColor(tile As terrainids) As UInteger
	Dim ret As UInteger
	
   Select Case tile
   	Case twall
   		ret = fbTan
      Case tfloor
   		ret = fbWhite
      Case tstairup
   		ret = fbYellowBright
      Case tstairdn
   		ret = fbYellowBright
   	Case tdooropen
   		ret = fbTan
   	Case tdoorclosed
   		ret = fbSienna
      Case twmerch
         ret = fbGreen
      Case tamulet
         ret = fbFlame
      Case Else
         ret = fbWhite
   End Select
   
   Return ret
End Function

'Returns terrain description.
Function GetTerrainDesc(x As Integer, y As Integer) As String
	Dim tile As terrainids
   Dim ret As String
   
   'Must be a tile.
   tile = level.lmap(x, y).terrid
   Select Case tile
   	Case twall
   		ret = "Wall"
      Case tfloor
   		ret = "Floor"
      Case tstairup
   		ret = "Stairs up"
      Case tstairdn
   		ret = "Stairs down"
      Case tdooropen
   		ret = "Open door"
   	Case tdoorclosed
   		ret = "Closed door"
      Case twmerch
         ret = "Wandering Merchant"
      Case Else
         ret = "Uknown"
   End Select
   
   Return ret
End Function

'Returns the next tile closest to x, y.
Function GetNextTile(mx As Integer, my As Integer, x As Integer, y As Integer, flee As Integer = FALSE) As mcoord
   Dim As Integer pdist, mdist, xx, yy
   Dim v As vec
   Dim As mcoord ret
   
   'Set current location.
   xx = mx
   yy = my
   'Set reference number.
   If flee = FALSE Then
      pdist = 1000
   Else
      pdist = 0
   End If
   'Iterate through all local tiles and find closest tile to character.
   For j As compass = north To nwest
      v.vx = mx
      v.vy = my
      v += j
      'Make sure tile isn't a blocking tile.
      If (BlockingTile(v.vx, v.vy) = FALSE) And (level.lmap(v.vx, v.vy).monidx = 0) And (IsLocation(v.vx, v.vy) = FALSE) Then
         'Get the tile distance.
         mdist = CalcDist(v.vx, x, v.vy, y)
         'Moving toward character.
         If flee = FALSE Then
            'If less than last diatance, set new coords.
            If mdist <= pdist Then
               xx = v.vx
               yy = v.vy
               pdist = mdist
            EndIf
         Else
            'Moving away from character.
            If mdist >= pdist Then
               xx = v.vx
               yy = v.vy
               pdist = mdist
            EndIf
         End If
      EndIf
   Next
   ret.x = xx
   ret.y = yy
   
   Return ret
End Function

'Returns the next higher sound tile.
Function GetNextSndTile(x As Integer, y As Integer) As mcoord
   Dim As mcoord ret
   Dim As Integer xx, yy, msnd = 0, psnd = 0
   Dim v As vec
   
   'Set current location.
   xx = x
   yy = y
   'Iterate through all local tiles and find closest tile to character.
   For j As compass = north To nwest
      v.vx = x
      v.vy = y
      v += j
      'Make sure tile isn't a blocking tile.
      If (BlockingTile(v.vx, v.vy) = FALSE) And (level.lmap(v.vx, v.vy).monidx = 0) Then
         'Get the current sound value.
         msnd = level.lmap(v.vx, v.vy).sndvol
         'If greater than last value then save new coords.
         If msnd >= psnd Then
            xx = v.vx
            yy = v.vy
            psnd = msnd
         EndIf
      EndIf
   Next
   ret.x = xx
   ret.y = yy
   
   Return ret
End Function

'Draws the map on the screen.
Sub DrawMap ()
   Dim As Integer i, j, w = vw, h = vh, x, y, px, py, pct, vis = vh, monid
   Dim As UInteger tilecolor, bcolor, trpcolor
   Dim As String mtile, trptile
   Dim As terrainids tile
   
	CalcLOS
	'Get the view coords
	i = GetLocx - (w / 2)
	j = GetLocy - (h / 2)
	If i < 1 Then i = 1
	If j < 1 Then j = 1
	If i + w > mapw Then i = mapw - w
	If j + h > mapw Then j = mapw - h
	'Draw the visible portion of the map.
	 For x = 1 To w
	     For y = 1 To h
	        'Clears current location to black.
	     		tilecolor = fbBlack 
	     		PutText acBlock, y + 1, x + 1, tilecolor
  			   'Get tile id
  			   tile = level.lmap(i + x, j + y).terrid
     		   'Get the tile symbol
      	   mtile = GetMapSymbol(tile)
      	   'Get the tile color
      	   tilecolor = GetMapSymbolColor(tile)
	     		'Print the tile.
	         If level.lmap(i + x, j + y).visible = TRUE Then
	            'Print trap icon if trap is sprung.
	            If level.lmap(i + x, j + y).trap.sprung = TRUE Then
		            'Get the item symbol.
		         	trptile = level.lmap(i + x, j + y).trap.icon
		         	'Get the item color.
		         	trpcolor = level.lmap(i + x, j + y).trap.iconcolor
	            EndIf
	            PutText trptile, y + 1, x + 1, trpcolor
		         'Print the item marker.
		         If HasItem(i + x, j + y) = TRUE Then
		            'Get the item symbol.
		         	mtile = level.linv(i + x, j + y).icon
		         	'Get the item color.
		         	tilecolor = level.linv(i + x, j + y).iconclr
		         EndIf
	            PutText mtile, y + 1, x + 1, tilecolor
		         'If the current location has a monster print that monster.
		         If level.lmap(i + x, j + y).monidx > 0 Then
		         	monid = level.lmap(i + x, j + y).monidx
		         	mtile = level.moninfo(monid).micon
		         	tilecolor = level.moninfo(monid).mcolor
		         	PutText acBlock, y + 1, x + 1, fbBlack
		         	PutText mtile, y + 1, x + 1, tilecolor
		         EndIf
	         Else
	         	'Not in los. Don't print monsters when not in LOS.
	         	If level.lmap(i + x, j + y).seen = TRUE Then
	         		If HasItem(i + x, j + y) = TRUE Then
	         			PutText "?", y + 1, x + 1, fbSlateGrayDark
	         		Else
	            		PutText mtile, y + 1, x + 1, fbSlateGrayDark
	         		End If
	         	End If
	         End If
	         'Print any targets in target map.
	         If level.lmap(i + x, j + y).target.id <> 0 Then
	            tilecolor = level.lmap(i + x, j + y).target.tcolor
	            mtile = Chr(level.lmap(i + x, j + y).target.id)
            	PutText acBlock, y + 1, x + 1, fbBlack
	         	PutText mtile, y + 1, x + 1, tilecolor
	         EndIf
	     Next 
	 Next
	'Don't draw if character on target icon.
	If level.lmap(GetLocx, GetLocy).target.id = 0 Then
      'Draw the player
	   px = (GetLocx - i) + 1
	   py = (GetLocy - j) + 1
   	pct = Int((GetCurrHP / GetMaxHP) * 100) 
   	If pct > 74 Then
   		PutText acBlock, py, px, fbBlack
   		PutText "@", py, px, fbGreen
   	ElseIf (pct > 24) And (pct < 75) Then
   		PutText acBlock, py, px, fbBlack
   		PutText "@", py, px, fbYellow
   	Else
   		PutText acBlock, py, px, fbBlack
   		PutText "@", py, px, fbRed
   	EndIf
	End If
End Sub

'Creates a trap.
Sub BuildTrap(trp As traptype)
   
   'Get the trap type.
   trp.id = RandomRange(trpBlade, trpAcid) 
   trp.icon = Chr(240)
   trp.iconcolor = fbRedBright
   trp.sprung = FALSE
   trp.dr = level.numlevel
   trp.dam = RandomRange(1, level.numlevel)
   'Set data based on type.
   If trp.id = trpBlade Then
      trp.desc = "Blade Trap"
      trp.damtype = wdSlash
   ElseIf trp.id = trpHammer Then
      trp.desc = "Hammer Trap"
      trp.damtype = wdCrush
   ElseIf trp.id = trpSpike Then
      trp.desc = "Spike Trap"
      trp.damtype = wdPierce
   ElseIf trp.id = trpEnergy Then
      trp.desc = "Energy Bolt Trap"
      trp.damtype = wdPierce
   ElseIf trp.id = trpFire Then
      trp.desc = "Fire Trap"
      trp.damtype = wdFire
   ElseIf trp.id = trpAcid Then
      trp.desc = "Acid Trap"
      trp.damtype = wdAcid
   EndIf
   
End Sub

'Init the grid and room arrays
Sub InitGrid()
   Dim As Integer i, j, x, y, gx = 1, gy = 1
	
	'Clear room array.		
   For i = 1 To nroommax
   	rooms(i).roomdim.rwidth = 0
   	rooms(i).roomdim.rheight = 0
   	rooms(i).roomdim.rcoord.x = 0
   	rooms(i).roomdim.rcoord.y = 0
   	rooms(i).tl.x = 0
   	rooms(i).tl.y = 0
   	rooms(i).br.x = 0
   	rooms(i).br.y = 0
   Next 
   'How many rooms
   numrooms = RandomRange(nroommin, nroommax)
   'Build some rooms
   For i = 1 To numrooms
   	rooms(i).roomdim.rwidth = RandomRange(roommin, roommax)
    	rooms(i).roomdim.rheight = RandomRange(roommin, roommax)
   Next
    'Clear the grid array
   For i = 1 To gw 
   	For j = 1 To gh
    		grid(i, j).cellcoord.x = gx
    		grid(i, j).cellcoord.y = gy
     		grid(i, j).Room = emptycell
     		gy += csizeh
   	Next
   	gy = 1
   	gx += csizew
   Next
	'Add rooms to the grid
   For i = 1 To numrooms
   	'Find an empty spot in the grid
   	Do
   		x = RandomRange(2, gw - 1)
   		y = RandomRange(2, gh - 1)
   	Loop Until grid(x, y).Room = emptycell
   	'Room center
   	rooms(i).roomdim.rcoord.x = grid(x, y).cellcoord.x + (rooms(i).roomdim.rwidth \ 2) 
   	rooms(i).roomdim.rcoord.y = grid(x, y).cellcoord.y + (rooms(i).roomdim.rheight \ 2)
		'Set the room rect
		rooms(i).tl.x = grid(x, y).cellcoord.x 
		rooms(i).tl.y = grid(x, y).cellcoord.y 
		rooms(i).br.x = grid(x, y).cellcoord.x + rooms(i).roomdim.rwidth + 1
		rooms(i).br.y = grid(x, y).cellcoord.y + rooms(i).roomdim.rheight + 1
   	'Save the room index
   	grid(x, y).Room = i
   Next
End Sub 

'Connect all the rooms.
Sub ConnectRooms( r1 As Integer, r2 As Integer)
	Dim As Integer idx, x, y, nid
	Dim As mcoord currcell, lastcell, ncoord
	Dim As Integer wflag
	
	currcell = rooms(r1).roomdim.rcoord
	lastcell = rooms(r2).roomdim.rcoord
		
	x = currcell.x
	If x < lastcell.x Then
		wflag = FALSE
		Do
			x += 1
			If level.lmap(x, currcell.y).terrid = twall Then wflag = TRUE
			If (level.lmap(x, currcell.y).terrid = tfloor) And (wflag = TRUE) Then
				Exit Sub
			EndIf
			level.lmap(x, currcell.y).terrid = tfloor
		Loop Until x = lastcell.x
	End If
	If x > lastcell.x Then
		wflag = FALSE
		Do
			x -= 1
			If level.lmap(x, currcell.y).terrid = twall Then wflag = TRUE
			If (level.lmap(x, currcell.y).terrid = tfloor) And (wflag = TRUE) Then 
				Exit Sub
			EndIf
			level.lmap(x, currcell.y).terrid = tfloor
		Loop Until x = lastcell.x
	EndIf
	y = currcell.y
	If y < lastcell.y Then
		wflag = FALSE
		Do
			y += 1
			If level.lmap(x, y).terrid = twall Then wflag = TRUE
			If (level.lmap(x, y).terrid = tfloor) And (wflag = TRUE) Then 
				Exit Sub
			EndIf
			level.lmap(x, y).terrid = tfloor
		Loop Until y = lastcell.y
	EndIf
	If y > lastcell.y Then
		Do
			y -= 1
			If level.lmap(x, y).terrid = twall Then wflag = TRUE
			If (level.lmap(x, y).terrid = tfloor) And (wflag = TRUE) Then 
				Exit Sub
			EndIf
			level.lmap(x, y).terrid = tfloor
		Loop Until y = lastcell.y
	EndIf
End Sub

'Add doors to a room.
Sub AddDoorsToRoom(i As Integer)
	Dim As Integer row, col, dd1, dd2, nid, roll
	
   'Add the doors.
	For col = rooms(i).tl.x To rooms(i).br.x
		dd1 = rooms(i).tl.y
		dd2 = rooms(i).br.y
		'If a floor space in the wall.
		If level.lmap(col, dd1).terrid = tfloor Then
			'Add door.
			level.lmap(col, dd1).terrid = tdoorclosed
			'Check to see if door is locked.
			roll = RandomRange(0, maxlevel * 2)
		   level.lmap(col, dd1).doorinfo.locked = (roll < level.numlevel)
			If level.lmap(col, dd1).doorinfo.locked = TRUE Then
			   level.lmap(col, dd1).doorinfo.lockdr = level.numlevel
			   level.lmap(col, dd1).doorinfo.dstr = level.numlevel * 10
			End If
		EndIf
		'Iterate along bottom of room.
		If level.lmap(col, dd2).terrid = tfloor Then
			'Add door.
			level.lmap(col, dd2).terrid = tdoorclosed
			'Check to see if door is locked.
			roll = RandomRange(0, maxlevel * 2)
		   level.lmap(col, dd1).doorinfo.locked = (roll < level.numlevel)
			If level.lmap(col, dd2).doorinfo.locked = TRUE Then
			   level.lmap(col, dd2).doorinfo.lockdr = level.numlevel
			   level.lmap(col, dd2).doorinfo.dstr = level.numlevel * 10
			End If
		End If
	Next
	'Iterate along left side of room.
	For row = rooms(i).tl.y To rooms(i).br.y
		dd1 = rooms(i).tl.x
		dd2 = rooms(i).br.x
		If level.lmap(dd1, row).terrid = tfloor Then
			'Add door.
			level.lmap(dd1, row).terrid = tdoorclosed
			'Check to see if door is locked.
			roll = RandomRange(0, maxlevel * 2)
		   level.lmap(col, dd1).doorinfo.locked = (roll < level.numlevel)
			If level.lmap(dd1, row).doorinfo.locked = TRUE Then
			   level.lmap(dd1, row).doorinfo.lockdr = level.numlevel
			   level.lmap(dd1, row).doorinfo.dstr = level.numlevel * 10
			End If
		End If
		'Iterate along right side of room.
		If level.lmap(dd2, row).terrid = tfloor Then
			'Add door.
			level.lmap(dd2, row).terrid = tdoorclosed
			'Check to see if door is locked.
			roll = RandomRange(0, maxlevel * 2)
		   level.lmap(col, dd1).doorinfo.locked = (roll < level.numlevel)
			If level.lmap(dd2, row).doorinfo.locked = TRUE Then
			   level.lmap(dd2, row).doorinfo.lockdr = level.numlevel
			   level.lmap(dd2, row).doorinfo.dstr = level.numlevel * 10
			End If
		EndIf
	Next
	
End Sub

'Adds doors to rooms.
Sub AddDoors()
    For i As Integer = 1 To numrooms
        AddDoorsToRoom i
    Next
End Sub

'Transfer grid data to map array.
Sub DrawMapToArray()
	Dim As Integer i, x, y, pr, rr, rl, ru, kr, nid, moncnt, tcnt
	Dim As mcoord ncoord
	
	'Draw the first room to map array
	For x = rooms(1).tl.x + 1 To rooms(1).br.x - 1
		For y = rooms(1).tl.y + 1 To rooms(1).br.y - 1
			level.lmap(x, y).terrid = tfloor
		Next
	Next
	'Draw the rest of the rooms to the map array and connect them.
	For i = 2 To numrooms
		For x = rooms(i).tl.x + 1 To rooms(i).br.x - 1
			For y = rooms(i).tl.y + 1 To rooms(i).br.y - 1
				level.lmap(x, y).terrid = tfloor
			Next
		Next
		'Get room center.
  	   ncoord.x = rooms(i).roomdim.rcoord.x + 1
  	   ncoord.y = rooms(i).roomdim.rcoord.y + 1
  	   'Add a monster to the room.
      If RandomRange(0, level.numlevel) <= level.numlevel Then
         moncnt += 1
         If moncnt <= nroommax Then
  	         level.nummon = moncnt
  	         GenerateMonster level.moninfo(level.nummon), level.numlevel
  	         level.lmap(ncoord.x, ncoord.y).monidx = level.nummon
  	         level.moninfo(level.nummon).currcoord = ncoord
         End If 
  	   End If
		ConnectRooms i, i - 1
	Next
	'Add doors to selected rooms.
	AddDoors
	'Set up player location.
	x = rooms(1).roomdim.rcoord.x + (rooms(1).roomdim.rwidth \ 2) 
	y = rooms(1).roomdim.rcoord.y + (rooms(1).roomdim.rheight \ 2)
	SetLocx x - 1
	SetLocy y - 1
	'Set up the stairs up.
	level.lmap(GetLocx, GetLocy).terrid = tstairup
	'Add wandering merchant.
	level.lmap(GetLocx - 1, GetLocy).terrid = twmerch
	'Set up stairs down in last room.
	If level.numlevel < maxlevel Then
	   x = rooms(numrooms).roomdim.rcoord.x + (rooms(numrooms).roomdim.rwidth \ 2) 
	   y = rooms(numrooms).roomdim.rcoord.y + (rooms(numrooms).roomdim.rheight \ 2)
	   level.lmap(x - 1, y - 1).terrid = tstairdn
	Else
	   'Don't add a duplicate amulet. 
	   If GetHasAmulet = FALSE Then
	      'Set amulet location.
	      x = rooms(numrooms).roomdim.rcoord.x + (rooms(numrooms).roomdim.rwidth \ 2) 
	      y = rooms(numrooms).roomdim.rcoord.y + (rooms(numrooms).roomdim.rheight \ 2)
	      level.lmap(x - 1, y - 1).terrid = tamulet
	   End If
	End If
	'Add some traps to the 
	tcnt = level.numlevel / 10
	'Add at least one trap.
	If tcnt < 1 Then tcnt = 1
	'Add in the traps.
	For i = 1 To tcnt
	   x = RandomRange(2, mapw - 1)
	   y = RandomRange(2, maph - 1)
	   'See if we have a floor tile.
	   If level.lmap(GetLocx, GetLocy).terrid = tfloor Then
	      BuildTrap level.lmap(GetLocx, GetLocy).trap
	   EndIf
	Next
End Sub

'Generate items for the map.
Sub GenerateItems()
   Dim As Integer i, x, y
   
	'Generate some items for the  
	For i = 1 To 10
	   Do
	      'Get a spot in the dungeon.
	      x = RandomRange(2, mapw - 1)
	      y = RandomRange(2, maph - 1)
	   'Look for floor tile that doesn't have an item on it.
	   Loop Until (level.lmap(x, y).terrid = tfloor) And (HasItem(x, y) = FALSE)
	   'Check for amulet.
	   If GetHasAmulet = FALSE Then
	      GenerateItem level.linv(x, y), level.numlevel
	   Else
	      GenerateItem level.linv(x, y), maxlevel
	   End If
	Next
   
End Sub

'Generate a new dungeon 
Sub GenerateDungeonLevel()
	Dim As Integer x, y, i
   
	'Clear level
	For x = 1 To mapw
		For y = 1 To maph
			level.lmap(x, y).terrid = twall           'Set tile to wall.
			level.lmap(x, y).visible = FALSE          'Not visible.
			level.lmap(x, y).seen = FALSE             'Not seen.
			level.lmap(x, y).monidx = 0               'No monster.
			level.lmap(x, y).doorinfo.locked = FALSE  'Door not locked.
			level.lmap(x, y).doorinfo.lockdr = 0      'No lock DR.
			level.lmap(x, y).doorinfo.dstr = 0        'No door strength.
			level.nummon = 0                          'Set monster count to 0.
			ClearInv level.linv(x,y)                  'Clear inventory slot.
         level.lmap(x, y).trap.id = trpNone        'Clear trap data.
         level.lmap(x, y).trap.icon = ""     
         level.lmap(x, y).trap.iconcolor = fbBlack  
         level.lmap(x, y).trap.desc = ""    
         level.lmap(x, y).trap.sprung = FALSE      
         level.lmap(x, y).trap.dr = 0          
         level.lmap(x, y).trap.dam = 0         
         level.lmap(x, y).trap.damtype = wdNone 
		Next
	Next
	InitGrid
	DrawMapToArray
	GenerateItems
End Sub

'Sets the tile at x, y of map.
Sub SetTile(x As Integer, y As Integer, tileid As terrainids)
   level.lmap(x, y).terrid = tileid
End Sub

'Adds item from map to passed inventory type.
Sub GetItemFromMap(x As Integer, y As Integer, inv As invtype)
   If inv.classid <> clNone Then
      ClearInv inv
   EndIf
   inv = level.linv(x, y)
   ClearInv level.linv(x, y)
End Sub

'Puts an item from passed inventory type to map.
Sub PutItemOnMap(x As Integer, y As Integer, inv As invtype)
   ClearInv level.linv(x, y)
   level.linv(x, y) = inv
End Sub

'Moves all living monsters.
Sub MoveMonsters ()
   Dim As mcoord nxt
   Dim As Integer pdist, croll, aroll
         
   'Iterate through each monster.
   For i As Integer = 1 To level.nummon
      'Make sure monster is not dead.
      If (level.moninfo(i).isdead = FALSE) And _
         (level.moninfo(i).effects(meStun).cnt < 1) And _ 
         (level.moninfo(i).effects(meBlind).cnt < 1) And _
         (level.moninfo(i).effects(meEntangle).cnt < 1) And _ 
         (level.moninfo(i).effects(meIceStatue).cnt < 1) And _
         (level.moninfo(i).effects(meConfuse).cnt < 1) Then
         'Is the monster fleeing?
         If level.moninfo(i).flee = FALSE Then
            'Is the character in line of sight?
            If  level.lmap(level.moninfo(i).currcoord.x, level.moninfo(i).currcoord.y).visible = TRUE Then
               'Set the sighted flag.
               level.moninfo(i).psighted = TRUE
               'Set the character location.
               level.moninfo(i).plastloc.x = GetLocx
               level.moninfo(i).plastloc.y = GetLocy
               'Check the distance to character.
               pdist = CalcDist(level.moninfo(i).currcoord.x, GetLocx, level.moninfo(i).currcoord.y, GetLocy)
               'Check the attack range of monster.
               If pdist <= level.moninfo(i).atkrange Then
                  'If magic check for spell cast.
                  If level.moninfo(i).ismagic = TRUE Then
                     'Get the rolls for the attack.
                     croll = RandomRange(1, level.moninfo(i).spell.dam)
                     aroll = RandomRange(0, level.moninfo(i).atkdam) 
                     'Cast spell if magic roll higher.
                     If  croll > aroll Then
                        MonCastSpell(level.moninfo(i).currcoord.x, level.moninfo(i).currcoord.y)
                     Else
                        'Attack character.
                        MonsterAttack level.moninfo(i).currcoord.x, level.moninfo(i).currcoord.y
                     EndIf
                  Else
                     'Not magic, just attack.
                     MonsterAttack level.moninfo(i).currcoord.x, level.moninfo(i).currcoord.y
                  End If
               Else
                  'Is monster magic.
                  If level.moninfo(i).ismagic = TRUE Then
                     'Get the rolls for the attack.
                     croll = RandomRange(1, level.moninfo(i).spell.dam)
                     aroll = RandomRange(0, level.moninfo(i).atkdam) 
                     'Cast spell if magic roll higher otherwise move toward player.
                     If croll > aroll Then
                        MonCastSpell(level.moninfo(i).currcoord.x, level.moninfo(i).currcoord.y)
                     Else
                        'Get the next closest tile to player.
                        nxt = GetNextTile(level.moninfo(i).currcoord.x, level.moninfo(i).currcoord.y, GetLocx, GetLocy)
                        'Set the new coords for monster.
                        level.lmap(level.moninfo(i).currcoord.x, level.moninfo(i).currcoord.y).monidx = 0
                        level.lmap(nxt.x, nxt.y).monidx = i
                        level.moninfo(i).currcoord = nxt
                     EndIf
                  Else
                     'Get the next closest tile to player.
                     nxt = GetNextTile(level.moninfo(i).currcoord.x, level.moninfo(i).currcoord.y, GetLocx, GetLocy)
                     'Set the new coords for monster.
                     level.lmap(level.moninfo(i).currcoord.x, level.moninfo(i).currcoord.y).monidx = 0
                     level.lmap(nxt.x, nxt.y).monidx = i
                     level.moninfo(i).currcoord = nxt
                  End If
               End If   
            Else
               'Character not in line of sight. Was player sighted.
               If level.moninfo(i).psighted = TRUE Then
                  'Make sure we have a location.
                  If (level.moninfo(i).plastloc.x > -1) And (level.moninfo(i).plastloc.y > -1) Then 
                     'Move toward last sighted position.
                     nxt = GetNextTile(level.moninfo(i).currcoord.x, level.moninfo(i).currcoord.y, level.moninfo(i).plastloc.x, level.moninfo(i).plastloc.y)
                     'Set the new monster coordinates.
                     level.lmap(level.moninfo(i).currcoord.x, level.moninfo(i).currcoord.y).monidx = 0
                     level.lmap(nxt.x, nxt.y).monidx = i
                     level.moninfo(i).currcoord = nxt
                     'Are we at the character last coordinates?
                     If (nxt.x = level.moninfo(i).plastloc.x) And (nxt.y = level.moninfo(i).plastloc.y) Then
                        'Reset monster target.
                        level.moninfo(i).psighted = FALSE
                        level.moninfo(i).plastloc.x = -1
                        level.moninfo(i).plastloc.y = -1
                     EndIf
                  Else
                     'Lost sight of character so reset monster target.
                     level.moninfo(i).psighted = FALSE
                     level.moninfo(i).plastloc.x = -1
                     level.moninfo(i).plastloc.y = -1
                  End If
               Else
                  'Check sound map here.
                  If level.lmap(level.moninfo(i).currcoord.x, level.moninfo(i).currcoord.y).sndvol > 0 Then
                     nxt = GetNextSndTile(level.moninfo(i).currcoord.x, level.moninfo(i).currcoord.y)
                     'Set the new monster coordinates.
                     level.lmap(level.moninfo(i).currcoord.x, level.moninfo(i).currcoord.y).monidx = 0
                     level.lmap(nxt.x, nxt.y).monidx = i
                     level.moninfo(i).currcoord = nxt
                  EndIf
               EndIf
            EndIf
         Else
            If (level.moninfo(i).psighted = TRUE) Or (level.lmap(level.moninfo(i).currcoord.x, level.moninfo(i).currcoord.y).visible = TRUE) Then
               'Move away from the character.
               nxt = GetNextTile(level.moninfo(i).currcoord.x, level.moninfo(i).currcoord.y, GetLocx, GetLocy, TRUE)
               'Set the new monster coordinates.
               level.lmap(level.moninfo(i).currcoord.x, level.moninfo(i).currcoord.y).monidx = 0
               level.lmap(nxt.x, nxt.y).monidx = i
               level.moninfo(i).currcoord = nxt
               'Check the distance to character.
               pdist = CalcDist(level.moninfo(i).currcoord.x, GetLocx, level.moninfo(i).currcoord.y, GetLocy)
               'Check the attack range of monster.
               If pdist <= level.moninfo(i).atkrange Then
                  'Attack character.
                  MonsterAttack level.moninfo(i).currcoord.x, level.moninfo(i).currcoord.y
               EndIf
            End If
         End If
      EndIf
   Next
   
End Sub

'Clears the current sound map.
Sub ClearSoundMap()
   For x As Integer = 1 To mapw
      For y As Integer = 1 To maph
         level.lmap(x, y).sndvol = 0
      Next
   Next
End Sub

'Generate the sound map using the passed noise factor.
Sub GenSoundMap(x As Integer, y As Integer, sndvol As Integer)
    Dim csound As Integer
    Dim sdist As Integer
    
    'Set up exit conditions.
    If x < 0 Or x > mapw Then Exit Sub
    If y < 0 Or y > mapw Then Exit Sub
    If sndvol <= 0 Then Exit Sub
    If BlockingTile(x, y) Then Exit Sub
    If level.lmap(x, y).sndvol > 0 Then Exit Sub
    'Attenuate the sound using square of distance.
    sdist = CalcDist(GetLocx, x, GetLocy, y)
    csound = sndvol - (sdist * sdist)
    'No sound so exit.
    If csound <= 0 Then Exit Sub
    'Recursively call the routine to build the map.
    level.lmap(x, y).sndvol = csound
    GenSoundMap x+1, y, csound
    GenSoundMap x, y+1, csound
    GenSoundMap x-1, y, csound 
    GenSoundMap x, y-1, csound 
    GenSoundMap x+1, y+1, csound 
    GenSoundMap x-1, y+1, csound 
    GenSoundMap x-1, y-1, csound 
    GenSoundMap x+1, y-1,  csound
End Sub

'Monster attacks character.
Sub MonsterAttack(mx As Integer, my As Integer)
   Dim As Integer midx, cd, mc, rollc, rollm, chp, dam
   Dim As String txt
   Dim As Single arm
   
   'Make sure there is a monster here.
   If (level.lmap(mx, my).monidx > 0) And (BlinkActive = FALSE) Then
      midx = level.lmap(mx, my).monidx
      'Get character defense factor.
      cd = GetDefenseFactor()
      'Get monster attack factor.
      mc = level.moninfo(midx).cf
      'Get the rolls.
      rollc = RandomRange(1, cd)
      rollm = RandomRange(1, mc)
      'Compare monster roll to character roll.
      If rollm > rollc Then
         'Get the damage.
         dam = level.moninfo(midx).atkdam
         'Get any shield values if any.
         arm = GetShieldArmorValue(level.moninfo(midx).damtype)
         'Make sure the character has some armor.
         If arm > 0 Then
            dam = dam - (dam * arm)
         End If
         'Get the character armor value.
         arm = GetArmorValue (level.moninfo(midx).damtype)
         'Make sure the character has some armor.
         If arm > 0 Then
            dam = dam - (dam * arm)
         End If
         'Get character hp.
         chp = GetCurrHP
         'Subtract damage from it.
         chp -= dam
         If chp < 0 Then chp = 0
         'Reset character hp.
         SetCurrHP chp
         txt = "The " &  level.moninfo(midx).mname & " hits for " & dam & " " & level.moninfo(midx).damstr & " damage points."
         'Set the last monster attack.
         level.lastmon.mname = level.moninfo(midx).mname
      Else
         txt = "The " &  level.moninfo(midx).mname & " misses."
      EndIf
      PrintMessage txt
   End If   
End Sub

'Monster casts spell.
Sub MonCastSpell(mx As Integer, my As Integer)
   Dim As Integer midx, cd, mc, rollc, rollm, chp, dam
   Dim As String txt
   Dim As Single arm
   Dim As weapdamtype damtype
   
   'Make sure there is a monster here.
   If (level.lmap(mx, my).monidx > 0) And (BlinkActive = FALSE) Then
      midx = level.lmap(mx, my).monidx
      'Get character defense factor.
      cd = GetMagicDefenseFactor()
      'Get monster attack factor.
      mc = level.moninfo(midx).mf
      'Get the rolls.
      rollc = RandomRange(1, cd)
      rollm = RandomRange(1, mc)
      'Compare monster roll to character roll.
      If rollm > rollc Then
         'If poison attack, poison character.
         If level.moninfo(midx).spell.id = splMonPoison Then
            SetPoisoned TRUE
            SetPoisonStr level.moninfo(midx).spell.lvl
            PrintMessage "You are poisoned."
         EndIf
         'Get the damage.
         dam = level.moninfo(midx).spell.dam
         damtype = GetMonSpellEffect(level.moninfo(midx).spell.id)
         'Get any shield values if any.
         arm = GetShieldArmorValue(damtype)
         'Make sure the character has some armor.
         If arm > 0 Then
            dam = dam - (dam * arm)
         End If
         'Get the character armor value.
         arm = GetArmorValue(damtype)
         'Make sure the character has some armor.
         If arm > 0 Then
            dam = dam - (dam * arm)
         End If
         'Get character hp.
         chp = GetCurrHP
         'Subtract damage from it.
         chp -= dam
         If chp < 0 Then chp = 0
         'Reset character hp.
         SetCurrHP chp
         txt = "The " &  level.moninfo(midx).mname & " casts " & GetSpellName(level.moninfo(midx).spell.id) & " for " & dam & " " & level.moninfo(midx).damstr & " damage points."
      Else
         txt = "You dispell the " &  GetSpellName(level.moninfo(midx).spell.id) & " cast by the " & level.moninfo(midx).mname & "."
      EndIf
      PrintMessage txt
   End If   
End Sub

'Sets target map at x, y.
Sub SetTarget(x As Integer, y As Integer, id As Integer, tcolor As UInteger = fbBlack) 
   level.lmap(x, y).target.id = id
   level.lmap(x, y).target.tcolor = tcolor
End Sub

'Animates projectile.
Sub AnimateProjectile (source As vec, target As vec)
   Dim As Integer x = source.vx, y = source.vy, d = 0, dx = target.vx - source.vx 
   Dim As Integer dy = target.vy - source.vy, c, m, xinc = 1, yinc = 1
   Dim As Integer delay = 10
   
   If dx < 0 Then
      xinc = -1
      dx = -dx
   EndIf
   If dy < 0 Then
      yinc = -1
      dy = -dy
   EndIf
   If dy < dx Then
      c = 2 * dx
      m = 2 * dy
      Do While x <> target.vx
         level.lmap(x, y).target.id = 7
         level.lmap(x, y).target.tcolor = fbYellow
         DrawMap
         Sleep delay
         level.lmap(x, y).target.id = 0
         level.lmap(x, y).target.tcolor = fbBlack
         DrawMap
         x += xinc
         d += m
         If d > dx Then
            y += yinc
            d -= c
         EndIf
      Loop
   Else
      c = 2 * dy
      m = 2 * dx
      Do While y <> target.vy
         level.lmap(x, y).target.id = 7
         level.lmap(x, y).target.tcolor = fbYellow
         DrawMap
         Sleep delay
         level.lmap(x, y).target.id = 0
         level.lmap(x, y).target.tcolor = fbBlack
         DrawMap
         y += yinc
         d += m
         If d > dy Then
            x += xinc
            d -= c
         EndIf
      Loop
   EndIf
   level.lmap(x, y).target.id = 249
   level.lmap(x, y).target.tcolor = fbYellow
   DrawMap
   Sleep delay
   level.lmap(x, y).target.id = 0
   level.lmap(x, y).target.tcolor = fbBlack
   DrawMap
End Sub

'Resolves any timed events.
Sub DoMapTimedEvents()
   Dim As String txt
   Dim As Integer tmp
   
   'Iterate through each monster.
   For i As Integer = 1 To level.nummon
      'Make sure monster is not dead.
      If level.moninfo(i).isdead = FALSE Then
         'Examine each effect and apply any damages/effects.
         If level.moninfo(i).effects(mePoison).cnt > 0 Then
            tmp = ApplyDamage(level.moninfo(i).currcoord.x, level.moninfo(i).currcoord.y, level.moninfo(i).effects(mePoison).dam)  
            level.moninfo(i).effects(mePoison).cnt -= 1
         Else
            level.moninfo(i).mcolor = fbRedBright
         EndIf
         
         If level.moninfo(i).effects(meFire).cnt > 0 Then
            tmp = ApplyDamage(level.moninfo(i).currcoord.x, level.moninfo(i).currcoord.y, level.moninfo(i).effects(meFire).dam)
            level.moninfo(i).effects(meFire).cnt -= 1
         Else
            level.moninfo(i).mcolor = fbRedBright
         EndIf
         
         If level.moninfo(i).effects(meStun).cnt > 0 Then
            tmp = ApplyDamage(level.moninfo(i).currcoord.x, level.moninfo(i).currcoord.y, level.moninfo(i).effects(meStun).dam)
            level.moninfo(i).effects(meStun).cnt -= 1
         Else
            level.moninfo(i).mcolor = fbRedBright
         EndIf
         
         If level.moninfo(i).effects(meAcidFog).cnt > 0 Then
            tmp = ApplyDamage(level.moninfo(i).currcoord.x, level.moninfo(i).currcoord.y, level.moninfo(i).effects(meAcidFog).dam)
            level.moninfo(i).effects(meAcidFog).cnt -= 1
         Else
            level.moninfo(i).mcolor = fbRedBright
         EndIf
         
         If level.moninfo(i).effects(meBlind).cnt > 0 Then
            tmp = ApplyDamage(level.moninfo(i).currcoord.x, level.moninfo(i).currcoord.y, level.moninfo(i).effects(meBlind).dam)
            level.moninfo(i).effects(meBlind).cnt -= 1
         Else
            level.moninfo(i).mcolor = fbRedBright
         EndIf
         
         If level.moninfo(i).effects(meFear).cnt > 0 Then
            tmp = ApplyDamage(level.moninfo(i).currcoord.x, level.moninfo(i).currcoord.y, level.moninfo(i).effects(meFear).dam)
            level.moninfo(i).flee = TRUE
            level.moninfo(i).effects(meFear).cnt -= 1
            level.moninfo(i).mcolor = fbMagenta
         Else
            level.moninfo(i).flee = FALSE
         EndIf
         
         If level.moninfo(i).effects(meConfuse).cnt > 0 Then
            tmp = ApplyDamage(level.moninfo(i).currcoord.x, level.moninfo(i).currcoord.y, level.moninfo(i).effects(meConfuse).dam)
            level.moninfo(i).effects(meConfuse).cnt -= 1
         Else
            level.moninfo(i).mcolor = fbRedBright
         EndIf
         
         If level.moninfo(i).effects(meEntangle).cnt > 0 Then
            tmp = ApplyDamage(level.moninfo(i).currcoord.x, level.moninfo(i).currcoord.y, level.moninfo(i).effects(meEntangle).dam)
            level.moninfo(i).effects(meEntangle).cnt -= 1
         Else
            level.moninfo(i).mcolor = fbRedBright
         EndIf
         
         If level.moninfo(i).effects(meCloudMind).cnt > 0 Then
            tmp = ApplyDamage(level.moninfo(i).currcoord.x, level.moninfo(i).currcoord.y, level.moninfo(i).effects(meCloudMind).dam)
            level.moninfo(i).effects(meCloudMind).cnt -= 1
         Else
            level.moninfo(i).mcolor = fbRedBright
         EndIf
         
         If level.moninfo(i).effects(meMagicDrain).cnt > 0 Then
            tmp = ApplyDamage(level.moninfo(i).currcoord.x, level.moninfo(i).currcoord.y, level.moninfo(i).effects(meMagicDrain).dam)
            'Get the percentage totals.
            tmp = level.moninfo(i).md * (level.moninfo(i).effects(meMagicDrain).lvl / 100)
            'Subtract from monster.
            level.moninfo(i).md = level.moninfo(i).md - tmp
            If level.moninfo(i).md < 1 Then level.moninfo(i).md = 1
            'Add the character.
            SetBonMdf tmp
            SetBonMdfCnt 1 
            level.moninfo(i).effects(meMagicDrain).cnt -= 1
         Else
            level.moninfo(i).mcolor = fbRedBright
            'Restore monster total.
            level.moninfo(i).md = level.moninfo(i).mdtot
         EndIf
         
         If level.moninfo(i).effects(meEnfeeble).cnt > 0 Then
            tmp = ApplyDamage(level.moninfo(i).currcoord.x, level.moninfo(i).currcoord.y, level.moninfo(i).effects(meEnfeeble).dam)
            'Lower all combat totals.
            tmp = level.moninfo(i).cd * (level.moninfo(i).effects(meEnfeeble).lvl / 100)
            level.moninfo(i).cd = level.moninfo(i).cd - tmp
            If level.moninfo(i).cd < 1 Then level.moninfo(i).cd = 1
            tmp = level.moninfo(i).md * (level.moninfo(i).effects(meEnfeeble).lvl / 100)
            level.moninfo(i).md = level.moninfo(i).md - tmp
            If level.moninfo(i).md < 1 Then level.moninfo(i).md = 1
            tmp = level.moninfo(i).mf * (level.moninfo(i).effects(meEnfeeble).lvl / 100)
            level.moninfo(i).mf = level.moninfo(i).mf - tmp
            If level.moninfo(i).mf < 1 Then level.moninfo(i).mf = 1
            tmp = level.moninfo(i).cf * (level.moninfo(i).effects(meEnfeeble).lvl / 100)
            level.moninfo(i).cf = level.moninfo(i).cf - tmp
            If level.moninfo(i).cf < 1 Then level.moninfo(i).cf = 1
            level.moninfo(i).effects(meEnfeeble).cnt -= 1
         Else
            level.moninfo(i).mcolor = fbRedBright
            'Restore totals.
            level.moninfo(i).cd = level.moninfo(i).cdtot
            level.moninfo(i).cf = level.moninfo(i).cftot 
            level.moninfo(i).md = level.moninfo(i).mdtot 
            level.moninfo(i).mf = level.moninfo(i).mftot
         EndIf
         
         If level.moninfo(i).effects(meIceStatue).cnt > 0 Then
            level.moninfo(i).effects(meIceStatue).cnt -= 1
         Else
            level.moninfo(i).mcolor = fbRedBright
         EndIf
         
         If level.moninfo(i).effects(meMDF).cnt > 0 Then
            level.moninfo(i).currhp -= level.moninfo(i).effects(meMDF).dam
            tmp = level.moninfo(i).md * (level.moninfo(i).effects(meMDF).lvl / 100)
            level.moninfo(i).md = level.moninfo(i).md - tmp
            If level.moninfo(i).md < 1 Then level.moninfo(i).md = 1
            level.moninfo(i).effects(meMDF).cnt -= 1
         Else
            level.moninfo(i).mcolor = fbRedBright
            level.moninfo(i).md = level.moninfo(i).mdtot 
         EndIf
         
         If level.moninfo(i).effects(meMCF).cnt > 0 Then
            level.moninfo(i).currhp -= level.moninfo(i).effects(meMCF).dam
            tmp = level.moninfo(i).mf * (level.moninfo(i).effects(meMCF).lvl / 100)
            level.moninfo(i).mf = level.moninfo(i).mf - tmp
            If level.moninfo(i).mf < 1 Then level.moninfo(i).mf = 1
            level.moninfo(i).effects(meMCF).cnt -= 1
         Else
            level.moninfo(i).mf = level.moninfo(i).mftot
            level.moninfo(i).mcolor = fbRedBright
         EndIf
      EndIf
   Next
End Sub

'Checks to see if x, y has amulet.
Sub IsAmulet(x As Integer, y As Integer)
   
   'Check the location for the amulet.
   If level.lmap(x, y).terrid = tamulet Then
      'Set the amulet flag.
      SetHasAmulet TRUE
      'Reset the map.
      level.lmap(x, y).terrid = tfloor
      'Tell the player they found the amulet.
      PrintMessage "You found the Amulet of Crystal Fire!"
   EndIf
   
End Sub

'Applies spell to monster.
Function ApplySpell(spl As spelltype, mx As Integer, my As Integer) As Integer
   Dim As Integer ret, midx, tmp, dam
   Dim stat As monStats
   Dim As String txt
   Dim As Single pct, armfact
   Dim vm As vec
   
   'Make sure there is a monster here.
   If level.lmap(mx, my).monidx > 0 Then
      'Get the monster index.
      midx = level.lmap(mx, my).monidx
      'Get the armor factor.
      armfact = level.moninfo(midx).armval
      'Calc the damage.
      dam = armfact * spl.dam
      If dam < 1 Then dam = 1
      'Set the monster flags based on spell.
      Select Case spl.id
         Case splSerpentBite 'Weapon: Inflict poison damage.
            ret = ApplyDamage(mx, my, dam)
            'If not dead set the timed flag.
            If ret = FALSE Then
               level.moninfo(midx).effects(mePoison).cnt = spl.lvl
               level.moninfo(midx).effects(mePoison).dam = dam
            EndIf
            txt = "Sperpent Bite Spell does " & dam & " to " & level.moninfo(midx).mname & "."
            PrintMessage txt
            level.moninfo(midx).mcolor = fbMagenta
         Case splRend        'Weapon: Decrease armor of target.
            level.moninfo(midx).armval = level.moninfo(midx).armval - (dam / maxlevel)
            If level.moninfo(midx).armval < 0.0 Then
               level.moninfo(midx).armval = 0.0
            EndIf
            txt = "Rend Spell reduces armor to  " & level.moninfo(midx).armval & " for " & level.moninfo(midx).mname & "."
            PrintMessage txt
            level.moninfo(midx).mcolor = fbMagenta
         Case splSunder      'Weapon: Decrease target weapon damage.
            level.moninfo(midx).atkdam = level.moninfo(midx).atkdam - dam
            If level.moninfo(midx).atkdam < 1 Then
               level.moninfo(midx).atkdam = 1
            EndIf
            txt = "Sunder Spell reduces attack damage to  " & level.moninfo(midx).atkdam & " for " & level.moninfo(midx).mname & "."
            PrintMessage txt
            level.moninfo(midx).mcolor = fbMagenta
         Case splReaper 'Weapon: Causes monster to flee.
            level.moninfo(midx).flee = TRUE
            txt = "Reaper Spell is making " & level.moninfo(midx).mname & " flee."
            PrintMessage txt
            level.moninfo(midx).mcolor = fbMagenta
         Case splFire        'Weapon: Does fire damage to target for lvl turns.
            ret = ApplyDamage(mx, my, dam)
            'If not dead set the timed flag.
            If ret = FALSE Then
               level.moninfo(midx).effects(meFire).cnt = spl.lvl
               level.moninfo(midx).effects(meFire).dam = dam
            EndIf
            txt = "Fire Spell inflicted  " & dam & " to " & level.moninfo(midx).mname & "."
            PrintMessage txt
            level.moninfo(midx).mcolor = fbMagenta
         Case splStun        'Weapon: Stuns target for lvl turns.
            level.moninfo(midx).effects(meStun).cnt = spl.lvl
            level.moninfo(midx).effects(meStun).dam = 0
            txt = "Stun Spell stunned " & level.moninfo(midx).mname & " for " & spl.lvl & " turns."
            PrintMessage txt
            level.moninfo(midx).mcolor = fbMagenta
         Case splChaos       'Weapon: Random amount of additonal damage.
            ret = ApplyDamage(mx, my, dam)
            txt = "Chaos Spell inflicted  " & dam & " additional damage to " & level.moninfo(midx).mname & "."
            PrintMessage txt
            level.moninfo(midx).mcolor = fbMagenta
         Case splWraith      'Weapon: Decreases random stat of target.
            'Get the stat.
            stat = RandomRange(CombatFactor, MagicDefense)
            Select Case stat
               Case CombatFactor
                  level.moninfo(midx).cf = level.moninfo(midx).cf - dam
                  If level.moninfo(midx).cf < 0 Then
                     level.moninfo(midx).cf = 1
                  EndIf
                  txt = "Wraith Spell reduced " & level.moninfo(midx).mname & " combat factor by " & dam & "."
                  PrintMessage txt
                  level.moninfo(midx).mcolor = fbMagenta
               Case CombatDefense
                  level.moninfo(midx).cd = level.moninfo(midx).cd - dam
                  If level.moninfo(midx).cd < 0 Then
                     level.moninfo(midx).cd = 1
                  EndIf
                  txt = "Wraith Spell reduced " & level.moninfo(midx).mname & " combat defense by " & dam & "."
                  PrintMessage txt
                  level.moninfo(midx).mcolor = fbMagenta
               Case MagicCombat
                  level.moninfo(midx).mf = level.moninfo(midx).mf - dam
                  If level.moninfo(midx).mf < 0 Then
                     level.moninfo(midx).mf = 1
                  EndIf
                  txt = "Wraith Spell reduced " & level.moninfo(midx).mname & " magic combat by " & dam & "."
                  PrintMessage txt
                  level.moninfo(midx).mcolor = fbMagenta
               Case MagicDefense
                  level.moninfo(midx).md = level.moninfo(midx).md - dam
                  If level.moninfo(midx).md < 0 Then
                     level.moninfo(midx).md = 1
                  EndIf
                  txt = "Wraith Spell reduced " & level.moninfo(midx).mname & " magic defense by " & dam & "."
                  PrintMessage txt
                  level.moninfo(midx).mcolor = fbMagenta
            End Select
         Case splStealHealth
            ret = ApplyDamage(mx, my, dam)
            SetCurrHP GetCurrHP + dam
            txt = "Steal Health Spell stole  " & dam & " health from " & level.moninfo(midx).mname & "."
            PrintMessage txt
            level.moninfo(midx).mcolor = fbMagenta
         Case splLightning
            ret = ApplyDamage(mx, my, spl.dam)
            txt = "Lightning Spell inflicted  " & spl.dam & " damage to " & level.moninfo(midx).mname & "."
            PrintMessage txt
            level.moninfo(midx).mcolor = fbMagenta
         Case splAcidFog     'Spellbook: 5 dam over lvl turns
            ret = ApplyDamage(mx, my, dam)
            'If not dead set the timed flag.
            If ret = FALSE Then
               level.moninfo(midx).effects(meAcidFog).cnt = spl.lvl
               level.moninfo(midx).effects(meAcidFog).dam = dam
            End If
            txt = "Acid Fog Spell inflicted  " & dam & " damage to " & level.moninfo(midx).mname & " for " & spl.lvl & " turns."
            PrintMessage txt
            level.moninfo(midx).mcolor = fbMagenta
         Case splFireCloak   'Spellbook: Target gets 10 dam over lvl turns
            ret = ApplyDamage(mx, my, dam)
            'If not dead set the timed flag.
            If ret = FALSE Then
               level.moninfo(midx).effects(meFire).cnt = spl.lvl
               level.moninfo(midx).effects(meFire).dam = dam
            End If
            txt = "Fire Cloak Spell inflicted  " & dam & " damage to " & level.moninfo(midx).mname & " for " & spl.lvl & " turns."
            PrintMessage txt
            level.moninfo(midx).mcolor = fbMagenta
         Case splBlind       'Spellbook: Blinds target for lvl turns
            txt = level.moninfo(midx).mname & " is blinded for " & spl.lvl & " turns."
            level.moninfo(midx).effects(meBlind).cnt = spl.lvl
            level.moninfo(midx).effects(meBlind).dam = dam
            PrintMessage txt
            level.moninfo(midx).mcolor = fbMagenta
         Case splFear        'Spellbook: Makes monster flee for lvl turns.
            txt = level.moninfo(midx).mname & " is filled with fear for " & spl.lvl & " turns."
            level.moninfo(midx).effects(meFear).cnt = spl.lvl
            level.moninfo(midx).effects(meFear).dam = dam
            PrintMessage txt
            level.moninfo(midx).mcolor = fbMagenta
         Case splConfuse     'Spellbook: Confuses monster for lvl turns.
            txt = level.moninfo(midx).mname & " is confused for " & spl.lvl & " turns."
            level.moninfo(midx).effects(meConfuse).cnt = spl.lvl
            level.moninfo(midx).effects(meConfuse).dam = spl.lvl
            PrintMessage txt
            level.moninfo(midx).mcolor = fbMagenta
         Case splFireBomb, splFireBall    'Spellbook: Area damage 20 (or 10) x lvl. Sets monsters on fire lvl turns.
            'Check to make sure monster isn't already on fire. 'Prevents infinite loop.
            If level.moninfo(midx).effects(meFire).cnt < 1 Then
               ret = ApplyDamage(mx, my, dam * spl.lvl)
               'If not dead set the timed flag.
               If ret = FALSE Then
                  level.moninfo(midx).effects(meFire).cnt = spl.lvl
                  level.moninfo(midx).effects(meFire).dam = dam
               End If
               'Check for spell type.
               If spl.id = splFireBomb Then
                  txt = "Fire Bomb Spell inflicted  " & dam & " damage to " & level.moninfo(midx).mname & "."
               Else
                  txt = "Fire Ball Spell inflicted  " & dam & " damage to " & level.moninfo(midx).mname & "."
               End If
               PrintMessage txt
               'We will call this recursively to hit any monsters next to target.
               'This will cause a chain reaction hitting all monsters next to
               'each other on the map.
               For i As compass = north To nwest
                  'Set ititial position.
                  vm.vx = mx
                  vm.vy = my
                  'Get new position.
                  vm += i
                  'Recusively call function.
                  tmp = ApplySpell(spl, vm.vx, vm.vy)
               Next
            Else
               txt = level.moninfo(midx).mname & " is already on fire."
               PrintMessage txt
            level.moninfo(midx).mcolor = fbMagenta
            End If
         Case splEntangle    'Spellbook: Immobilze target for lvel turns doing lvl damage each turn.
            ret = ApplyDamage(mx, my, dam)
            'If not dead set the timed flag.
            If ret = FALSE Then
               level.moninfo(midx).effects(meEntangle).cnt = spl.lvl
               level.moninfo(midx).effects(meEntangle).dam = dam
            End If
            txt = "Entangle Spell inflicted  " & dam & " damage to " & level.moninfo(midx).mname & " for " & spl.lvl & " turns."
            PrintMessage txt
            level.moninfo(midx).mcolor = fbMagenta
         Case splCloudMind   'Spellbook: Target cannot cast spells for lvl turns.
            txt = level.moninfo(midx).mname & "mind is clouded for " & spl.lvl & " turns."
            level.moninfo(midx).effects(meEntangle).cnt = spl.lvl
            level.moninfo(midx).effects(meEntangle).dam = dam
            PrintMessage txt
            level.moninfo(midx).mcolor = fbMagenta
         Case splIceStatue   'Spellbook: Freezes target for lvl turns. If frozen can be killed with single hit.
            level.moninfo(midx).effects(meIceStatue).cnt = spl.lvl
            level.moninfo(midx).effects(meIceStatue).dam = dam
            txt = level.moninfo(midx).mname & " is frozen for " & spl.lvl & " turns."
            PrintMessage txt
            level.moninfo(midx).mcolor = fbMagenta
         Case splRust        'Spellbook: Reduces armor by lvl x 10%.
            pct = spl.lvl * .10
            level.moninfo(midx).armval = level.moninfo(midx).armval - pct
            If level.moninfo(midx).armval < 0.0 Then
               level.moninfo(midx).armval = 0.0
            EndIf
            txt = level.moninfo(midx).mname & " armor has been reduced."
            PrintMessage txt
            level.moninfo(midx).mcolor = fbMagenta
         Case splShatter     'Spellbook: Destroys target weapon, if any.
            ret = ApplyDamage(mx, my, spl.lvl)
            'If not dead set the timed flag.
            If ret = FALSE Then
               level.moninfo(midx).atkdam = 0
            End If
            txt = "Shatter Spell destroyed " & level.moninfo(midx).mname & " attack ability."
            PrintMessage txt
            level.moninfo(midx).mcolor = fbMagenta
         Case splMagicDrain  'Spellbook: Lower target MDF by lvl% and adds to caster for 1 turn.
            level.moninfo(midx).effects(meMDF).cnt = spl.lvl
            level.moninfo(midx).effects(meMDF).dam = dam
            txt = "Magic Drain Spell has lowered " & level.moninfo(midx).mname & " magic defense."
            PrintMessage txt
            level.moninfo(midx).mcolor = fbMagenta
         Case splPoison      'Spellbook: Posions target 1 HP for lvl turns.
            ret = ApplyDamage(mx, my, dam)
            'If not dead set the timed flag.
            If ret = FALSE Then
               level.moninfo(midx).effects(mePoison).cnt = spl.lvl
               level.moninfo(midx).effects(mePoison).dam = dam
            EndIf
            txt = "Poison Spell has poisoned " & level.moninfo(midx).mname & " for " & spl.lvl & " turns."
            PrintMessage txt
            level.moninfo(midx).mcolor = fbMagenta
         Case splEnfeeble    'Spellbook: Lowers target combat factors lvl x 10%.
            level.moninfo(midx).effects(meEnfeeble).cnt = spl.lvl
            level.moninfo(midx).effects(meEnfeeble).dam = dam
            txt = "Enfeeble Spell has lowered " & level.moninfo(midx).mname & " combat factors for " & spl.lvl & " turns."
            PrintMessage txt
            level.moninfo(midx).mcolor = fbMagenta
         Case splShout       'Spellbook: Stuns all visible monsters for lvl turns.
            For i As Integer = 1 To level.nummon
               If level.moninfo(i).isdead = FALSE Then
                  If  level.lmap(level.moninfo(i).currcoord.x, level.moninfo(i).currcoord.y).visible = TRUE Then
                     level.moninfo(i).effects(meStun).cnt = spl.lvl
                     level.moninfo(i).effects(meStun).dam = dam
                     txt = "Warrior Shout Spell has stunned " & level.moninfo(i).mname & " for " & spl.lvl & " turns."
                     PrintMessage txt
                  EndIf
               End If
            Next
            level.moninfo(midx).mcolor = fbMagenta
         Case splMindBlast   'Spellbook: Lowers target MCF and MDF lvl% for lvl turns.
            level.moninfo(midx).effects(meMDF).cnt = spl.lvl
            level.moninfo(midx).effects(meMDF).dam = dam
            level.moninfo(midx).effects(meMCF).cnt = spl.lvl
            level.moninfo(midx).effects(meMCF).dam = dam
            txt = "Mind Blast Spell has lowered " & level.moninfo(midx).mname & " magic magic combat factors."
            PrintMessage txt
            level.moninfo(midx).mcolor = fbMagenta
         Case splTeleport
            'Apply enough damage to kill any monster.
            ret = ApplyDamage(mx, my, 1000000)
            txt = "You tleported into " & level.moninfo(midx).mname & " killing it."
            PrintMessage txt
      End Select
   End If
   
   Return ret
End Function

'Returns true of tile at x, y is blocking.
Function IsBlocking(x As Integer, y As Integer) As Integer
   Return BlockingTile(x, y)         
End Function

'Returns the tile id at x, y.
Function GetTileID(x As Integer, y As Integer) As terrainids
   Return level.lmap(x, y).terrid         
End Function

'Returns True if door is locked.
Function IsDoorLocked(x As Integer,y As Integer) As Integer
   Return level.lmap(x, y).doorinfo.locked
End Function

'Returns item description at coordinate.
Function GetTerrainDescription(x As Integer, y As Integer) As String
   Return GetTerrainDesc(x, y)
End Function

'Returns True if coordinate has item.
Function HasItem(x As Integer, y As Integer) As Integer
      'Look at inventory slot. If no class id then slot empty.
      If level.linv(x, y).classid = clNone Then
         Return FALSE
      Else
         Return TRUE
      EndIf
End Function

'Returns item description at x, y coordinate.
Function GetItemDescription(x As Integer, y As Integer) As String
   Dim As String ret = "None"
   
   If level.linv(x, y).classid <> clNone Then
      ret = GetInvItemDesc(level.linv(x, y))
   EndIf
   
   Return ret
End Function

'Returns class id for inventory item at x, y.
Function GetInvClassID(x As Integer, y As Integer) As classids
   Return level.linv(x, y).classid
End Function

'Returns true if an empty spot is found and returns coords in vec.
Function GetEmptySpot(v As vec) As Integer
   Dim As Integer ret = FALSE, hi
   Dim As vec ev
   Dim As terrainids tid
   
   'Check character spot.
   ev.vx = GetLocx
   ev.vy = GetLocy
   hi = HasItem(ev.vx, ev.vy) 
   If  hi = FALSE Then
      ret = TRUE
      v = ev
   Else
      'Check each tile around character.
      For i As compass = north To nwest
         ev.vx = GetLocx
         ev.vy = GetLocy
         ev += i
         'Get the tile type. 
         tid = GetTileID(ev.vx, ev.vy)
         'Check to see if it already has an item.
         hi = HasItem(ev.vx, ev.vy)
         'If floor and no item, found space.
         If (tid = tfloor) And (hi = FALSE) Then
            v = ev
            ret = TRUE
            Exit For
         EndIf
      Next
   EndIf
   
   Return ret
End Function

'Returns true if monster at location.
Function IsMonster(x As Integer, y As Integer) As Integer
   Dim As Integer ret = FALSE
   
   If level.lmap(x, y).monidx > 0 Then
      ret = TRUE
   EndIf
   
   Return ret
End Function

'Returns the defense factor of monster.
Function GetMonsterDefense(mx As Integer, my As Integer) As Integer
   Dim As Integer ret = 0, midx = 0
   
   'Make sure there is a monster here.
   If level.lmap(mx, my).monidx > 0 Then
      midx = level.lmap(mx, my).monidx
      ret = level.moninfo(midx).cd
   EndIf
   
   Return ret
End Function

'Returns the magic defense of the monster.
Function GetMonsterMagicDefense(mx As Integer, my As Integer) As Integer
   Dim As Integer ret = 0, midx = 0
   
   'Make sure there is a monster here.
   If level.lmap(mx, my).monidx > 0 Then
      midx = level.lmap(mx, my).monidx
      ret = level.moninfo(midx).md
   EndIf
   
   Return ret
End Function

'Returns the monster type.
Function GetMonsterName(mx As Integer, my As Integer) As String
   Dim As String ret
   Dim As Integer midx
   
   'Make sure there is a monster here.
   If level.lmap(mx, my).monidx > 0 Then
      midx = level.lmap(mx, my).monidx
      ret = level.moninfo(midx).mname
   EndIf
   
   Return ret
End Function

'Returns the monster armor rating.
Function GetMonsterArmor(mx As Integer, my As Integer) As Single
   Dim As Single ret
   Dim As Integer midx
   
   'Make sure there is a monster here.
   If level.lmap(mx, my).monidx > 0 Then
      midx = level.lmap(mx, my).monidx
      ret = level.moninfo(midx).armval
   EndIf
   
   Return ret
End Function

'Applies damage to monsters. Returns true if monster is dead.
Function ApplyDamage(mx As Integer, my As Integer, dam As Integer) As Integer
   Dim As Integer midx, i, ret = FALSE
   Dim As vec v
   Dim As String txt
   
   'Make sure there is a monster here.
   If level.lmap(mx, my).monidx > 0 Then
      midx = level.lmap(mx, my).monidx
      level.moninfo(midx).currhp = level.moninfo(midx).currhp - dam
      'Check for flee.
      If level.moninfo(midx).currhp < 2 Then level.moninfo(midx).flee = TRUE 
      'Check to see if monster is dead.
      If (level.moninfo(midx).currhp < 1) Or (level.moninfo(midx).effects(meIceStatue).cnt > 0) Then
         'Bump the number of killed monsters.
         level.killedmon(level.moninfo(midx).id).cnt += 1
         level.killedmon(level.moninfo(midx).id).mname = level.moninfo(midx).mname
         'Add some experience to the character.
         SetCurrXP GetCurrXP + level.moninfo(midx).xp
         'Monster is dead.
         ret = TRUE
         'Flag the monster as dead.
         level.moninfo(midx).isdead = TRUE
         'Remove from map.
         level.lmap(mx, my).monidx = 0
         'Drop any items.
         If level.moninfo(midx).dropcount > 0 Then
            For i = 1 To level.moninfo(midx).dropcount
               For j As compass = north To nwest
                  v.vx = mx
                  v.vy = my
                  v += j
                  'If empty drop item.
                  If (level.lmap(v.vx, v.vy).terrid = tFloor) And (level.linv(v.vx, v.vy).classid = clNone) Then
                     PutItemOnMap v.vx, v.vy, level.moninfo(midx).dropitem(i)
                     Exit For
                  EndIf
               Next
               ClearInv level.moninfo(midx).dropitem(i)
            Next
         EndIf
      EndIf
     'Print the result of the combat.
      If level.moninfo(midx).isdead = TRUE Then
         txt = CharName & " killed the " & level.moninfo(midx).mname & " with " & dam & " damage points."
      Else
         txt = CharName & " hit the " & level.moninfo(midx).mname & " for " & dam & " damage points."
      EndIf
      PrintMessage txt
   EndIf
   
   Return ret
End Function

'Returns the monster xp amount.
Function GetMonsterXP(mx As Integer, my As Integer) As Integer
   Dim As Integer midx, ret
   
   'Make sure there is a monster here.
   If level.lmap(mx, my).monidx > 0 Then
      midx = level.lmap(mx, my).monidx
      ret = level.moninfo(midx).xp
   EndIf
   
   Return ret
End Function

'Returns True if tile is visible,
Function IsTileVisible(x As Integer, y As Integer) As Integer
   Return level.lmap(x, y).visible
End Function

'Returns the current monster stat amt.
Function GetMonsterStatAmt(stat As monStats, mx As Integer, my As Integer) As Integer
   Dim As Integer midx, ret = 0
   
   If level.lmap(mx, my).monidx > 0 Then
      midx = level.lmap(mx, my).monidx
      If stat = CombatFactor Then
         ret = level.moninfo(midx).cf 
      ElseIf stat = CombatDefense Then
         ret = level.moninfo(midx).cd
      ElseIf stat = MagicCombat Then
         ret = level.moninfo(midx).mf
      ElseIf stat = MagicDefense Then
         ret = level.moninfo(midx).md
      EndIf
   End If
   
   Return ret
End Function

'Attempts to open a locked door. 
Function OpenLockedDoor(x As Integer, y As Integer, dr As Integer) As Integer
   Dim As Integer ret = TRUE, ddr, rolld, rollp
   Dim tid As terrainids
   
   'Make sure we have a door.
   tid = GetTileID(x, y)
   If tid = tDoorClosed Then
     If IsDoorLocked(x, y) = TRUE Then
        'Get the difficulty rating of the door.
        ddr = level.lmap(x, y).doorinfo.lockdr
        'Get the rolls.
        rollp = RandomRange(1, dr)
        rolld = RandomRange(1, ddr)
        If rollp > rolld Then
           'Open door.
           level.lmap(x, y).doorinfo.locked = FALSE
           SetTile x, y, tdooropen
           'Give the character some experience points.
           SetCurrXP GetCurrXP + ddr 
        Else
           'Didn't open the door.
           ret = FALSE
        EndIf
     EndIf
   EndIf
   
   Return ret
End Function

'Sets the door state.
Sub SetDoorState(x As Integer, y As Integer, state As doorstates)
   Dim tid As terrainids
   
   'Make sure we have a door.
   tid = GetTileID(x, y)
   If tid = tDoorClosed Then
      If state = dsOpen Then
         level.lmap(x, y).terrid = tDoorOpen
      ElseIf state = dsLocked Then
         level.lmap(x, y).doorinfo.locked = TRUE
	      level.lmap(x, y).doorinfo.lockdr = level.numlevel
			level.lmap(x, y).doorinfo.dstr = level.numlevel * 10
      EndIf
   ElseIf tid = tDoorOpen Then
      If state = dsClosed Then
         level.lmap(x, y).terrid = tDoorClosed
      ElseIf state = dsLocked Then
         level.lmap(x, y).terrid = tDoorClosed
         level.lmap(x, y).doorinfo.locked = TRUE
	      level.lmap(x, y).doorinfo.lockdr = level.numlevel
			level.lmap(x, y).doorinfo.dstr = level.numlevel * 10
      EndIf
   End If
End Sub

'Disarms a trap.
Sub DisArmTrap (x As Integer, y As Integer)
   
   'Do we have a trap at the current location?
   If level.lmap(x, y).trap.id <> trpNone Then
      'Spring trap.
      level.lmap(x, y).trap.sprung = TRUE
   End If
   
End Sub

'Returns TRUE if trap at x, y.
Function IsTrap(x As Integer, y As Integer, ByRef dam As Integer, ByRef damtype As weapdamtype, ByRef tdr As Integer, tdesc As String) As Integer
   Dim As Integer ret
   
   'Do we have a trap at the current location?
   If level.lmap(x, y).trap.id <> trpNone Then
      'Is it sprung yet?
      If level.lmap(x, y).trap.sprung = FALSE Then
         'There is a trap. Spring it and return damage amt and type.
         ret = TRUE
         level.lmap(x, y).trap.sprung = TRUE
         dam = level.lmap(x, y).trap.dam
         damtype = level.lmap(x, y).trap.damtype
         tdr = level.lmap(x, y).trap.dr
         tdesc = level.lmap(x, y).trap.desc
      EndIf
   EndIf
   
   Return ret
End Function

'Returns the number and name of dead monster for passed monster id.
Sub GetDeadMonster(monid As monids, mstat As monstat)
   
   'Verify the passed id.
   If (monid >= monDarkangel) And (monid <= monGriffon) Then
      mstat = level.killedmon(monid)
   EndIf
End Sub

'Returns the stat for last monster encounter.
Sub GetLastMonster(mstat As monstat)
   
   mstat = level.lastmon
   
End Sub

'Get the level information.
Sub GetLevelData(ld As levelinfo)
   'Get the level number.
   ld  = level
End Sub

'Get the level information.
Sub SetLevelData(ld As levelinfo)
   'Get the level number.
   level = ld
End Sub

