/'****************************************************************************
*
* Name: mapdec.bi
*
* Synopsis: Map declarations.
*
* Description: This file contains the map declarations for routines in map.bi.  
*
* Copyright 2010, Richard D. Clark
*
*  The Wide Open License (WOL)
*
* Permission to use, copy, modify, distribute and sell this software and its
* documentation for any purpose is hereby granted without fee, provided that
* the above copyright notice and this license appear in all source copies. 
* THIS SOFTWARE IS PROVIDED "AS IS" WITHOUT EXPRESS OR IMPLIED WARRANTY OF
* ANY KIND. See http://www.dspguru.com/wol.htm for more information.
*
*****************************************************************************'/
Declare Sub CalcLOS () 'Calculates line of sight with post processing to remove artifacts.
Declare Sub InitGrid() 'Inits the grid.
Declare Sub ConnectRooms( r1 As Integer, r2 As Integer) 'Connects rooms.
Declare Sub AddDoorsToRoom(i As Integer) 'Adds doors to a room.
Declare Sub AddDoors() 'Iterates through all rooms adding doors to each room.
Declare Sub DrawMapToArray() 'Transfers room data to map array.
Declare Sub GenerateItems()  'Generates items on the map.
Declare Sub BuildTrap(trp As traptype) 'Creates a trap.
Declare Sub LevelID(lvl As Integer) 'Sets the current level.
Declare Sub DrawMap () 'Draws the map on the screen.
Declare Sub GenerateDungeonLevel() 'Generates a new dungeon level.
Declare Sub SetTile(x As Integer, y As Integer, tileid As terrainids) 'Sets the tile at x, y of map.
Declare Sub GetItemFromMap(x As Integer, y As Integer, inv As invtype) 'Adds item from map to passed inventory type. 
Declare Sub PutItemOnMap(x As Integer, y As Integer, inv As invtype) 'Puts an item from passed inventory type to map.
Declare Sub MoveMonsters () 'Moves all the monsters in the list.
Declare Sub ClearSoundMap () 'Clears the current sound map.
Declare Sub GenSoundMap(x As Integer, y As Integer, sndvol As Integer) 'Generate sound map.
Declare Sub MonsterAttack(mx As Integer, my As Integer) 'Monster attacks character.
Declare Sub MonCastSpell(mx As Integer, my As Integer)
Declare Sub SetTarget(x As Integer, y As Integer, id As Integer, tcolor As UInteger = fbBlack) 'Sets target map at x, y with id.
Declare Sub AnimateProjectile (source As vec, target As vec) 'Animates projectile.
Declare Sub MapDoTimedEvents() 'Resolves any timed events.
Declare Sub SetDoorState(x As Integer, y As Integer, state As doorstates) 'Sets the door state.
Declare Sub DisArmTrap (x As Integer, y As Integer) 'Disarms a trap.
Declare Sub IsAmulet(x As Integer, y As Integer) 'Check for amulet at x, y.
Declare sub GetDeadMonster(monid As monids, mstat As monstat) 'Returns the number of dead monsters for passed monster id.
Declare Sub GetLastMonster(mstat As monstat) 'Returns the name of last monster encountered.
Declare Sub GetLevelData(ld As levelinfo) 'Gets the level information.
Declare Sub SetLevelData(ld As levelinfo) 'Sets the level data.
Declare Function BlockingTile(tx As Integer, ty As Integer) As Integer 'Returns true if blocking tile.
Declare Function LineOfSight(x1 As Integer, y1 As Integer, x2 As Integer, y2 As Integer) As Integer 'Returns true if line of sight to tile.
Declare Function CanSee(tx As Integer, ty As Integer) As Integer 'Can character see tile.
Declare Function GetMapSymbol(tile As terrainids) As String 'Returns the ascii symbol for terrian id.
Declare Function GetMapSymbolColor(tile As terrainids) As UInteger 'Returns color for terrain id.
Declare Function GetTerrainDesc(x As Integer, y As Integer) As String 'Returns item description.
Declare Function GetNextTile(mx As Integer, my As Integer, x As Integer, y As Integer, flee As Integer = FALSE) As mcoord 'Returns the next tile closest to x, y.
Declare Function GetNextSndTile(x As Integer, y As Integer) As mcoord 'Returns the next higher sound tile.
Declare Function GetLevelID() As Integer 'Returns the current level number.
Declare Function ApplySpell(spl As spelltype, mx As Integer, my As Integer) As Integer 'Applies spell to monster.
Declare Function IsBlocking(x As Integer, y As Integer) As Integer 'Returns true of tile at x, y is blocking.
Declare Function GetTileID(x As Integer, y As Integer) As terrainids 'Returns the tile id at x, y.
Declare Function IsDoorLocked(x As Integer,y As Integer) As Integer 'Returns True if door is locked.
Declare Function GetTerrainDescription(x As Integer, y As Integer) As String 'Returns item description at coordinate.
Declare Function HasItem(x As Integer, y As Integer) As Integer 'Returns True if coordinate has item.
Declare Function GetItemDescription(x As Integer, y As Integer) As String 'Returns item description at x, y coordinate.
Declare Function GetInvClassID(x As Integer, y As Integer) As classids 'Returns inv class id at x, y.
Declare Function GetEmptySpot(v As vec) As Integer 'Returns true if an empty spot is found and returns coords in vec.
Declare Function IsMonster(x As Integer, y As Integer) As Integer 'Returns true if monster at location.
Declare Function GetMonsterDefense(mx As Integer, my As Integer) As Integer 'Returns the defense factor of monster.
Declare Function GetMonsterName(mx As Integer, my As Integer) As String 'Returns the monster type.
Declare Function GetMonsterArmor(mx As Integer, my As Integer) As Single 'Returns the monster armor rating.
Declare Function ApplyDamage(mx As Integer, my As Integer, dam As Integer) As Integer 'Applies damage to monsters returns true if dead.
Declare Function GetMonsterCombatFactor(mx As Integer, my As Integer) As Integer 'Returns the monster combat factor.
Declare Function GetMonsterXP(mx As Integer, my As Integer) As Integer 'Returns the monster xp amount.
Declare Function IsTileVisible(x As Integer, y As Integer) As Integer 'Returns True if tile is visible,
Declare Function GetMonsterMagicDefense(mx As Integer, my As Integer) As Integer 'Returns the magic defense of the monster.
Declare Function GetMonsterStatAmt(stat As monStats, mx As Integer, my As Integer) As Integer 'Returns the current monster stat amt.
Declare Function OpenLockedDoor(x As Integer, y As Integer, dr As Integer) As Integer 'Attempts to open a locked door.
Declare Function IsTrap(x As Integer, y As Integer, ByRef dam As Integer, ByRef damtype As weapdamtype, ByRef tdr As Integer, tdesc As String) As Integer 'Returns TRUE if trap at x, y.
