/'****************************************************************************
*
* Name: monster.bi
*
* Synopsis: Monster related routines.
*
* Description: This file contains monster related routines used in the program.  
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
'Monster ids.
Enum monids
   monNone
   monDarkangel
   monGiantbat
   monGiantscorpion
   monDragon
   monElfwarrior
   monWisp
   monGiant
   monHarpy
   monIncubus
   monJadegolem
   monKraken
   monLamia
   monManticore
   monNaga
   monOgre
   monPhantomfungus
   monQuorn
   monRockgolem
   monSkeleton
   monTroll
   monUruk
   monVampire
   monWombat
   monXerth
   monYeek
   monZombie
   monFlameangel
   monWerebear
   monGiantcentipede
   monDemonspawn
   monElemental
   monFlamegolem
   monGolem
   monHobgoblin
   monInterloper
   monRovingjelly
   monKobold
   monLich
   monMage
   monNazgul
   monOrc
   monPulsingeye
   monTwinhead
   monRogue
   monShurik
   monGianttarantula
   monGiantbeetle
   monVarghoul
   monWraith
   monXorn
   monYekki
   monGriffon
End Enum

'Monster special attack.
Enum monspecial
   msNone
   msPoison
   msFire
   msParalyse
   msDestroyWeapon
   msDestroyArmor
   msMultiply
   msDestroyItem
   msBlindness
End Enum

'Monster type def. 
Type montype
   id As monids         'Monster id.
   mname As String * 15 'Monster name.
   micon As String * 1  'Icon
   mcolor As UInteger   'Color of icon.
   ismagic As Integer   'Can produce magic spells.
   spell As Integer     'The attack/defense spell
   special As monspecial 'Special attack.
   stratt As Integer    'Strength attribute 
   staatt As Integer    'Stamina  
   dexatt As Integer    'Dexterity 
   aglatt As Integer    'Agility 
   intatt As Integer    'Intelligence 
   ucfsk As Integer     'Unarmed combat skill
   acfsk As Integer     'Armed combat skill
   pcfsk As Integer     'Projectile combat skill
   mcfsk As Integer     'Magic combat skill 
   cdfsk As Integer     'Combat defense skill
   mdfsk As Integer     'Magic defense skill 
   currhp As Integer    'Current HP
   maxhp As Integer     'Max HP
   dropcount As Integer 'The number of items in inventory.
   dropitem(1 To 4) As invtype 'What the monster drops when dead.
   atkdam As Integer    'The monster attack damage.
   armval As Single     'Monster armor value as percentage.   
   atkrange As Integer  'Range of attack. 
   psighted As Integer  'Indicates that monster sighted player.
   srcnode As Integer   'Source node id.
   tgtnode As Integer   'Target node id.
   currcoord As mcoord  'Current coordinates.
   flee As Integer      'Monster is fleeing.
End Type

'Generates a monster.
Sub GenerateMonster(mon As montype)
   Dim As Integer rlow, rhigh
   Dim As invtype inv
   
   'Set the monster attributes.
   mon.id = RandomRange(monDarkangel, monGriffon)
   rlow = pchar.CurrStr - (pchar.CurrStr * .5)
   rhigh = pchar.CurrStr + (pchar.CurrStr * .5)
   mon.stratt = RandomRange(rlow, rhigh)
   
   rlow = pchar.CurrSta - (pchar.CurrSta * .5)
   rhigh = pchar.CurrSta + (pchar.CurrSta * .5)
   mon.staatt = RandomRange(rlow, rhigh)
   
   rlow = pchar.CurrDex - (pchar.CurrDex * .5)
   rhigh = pchar.CurrDex + (pchar.CurrDex * .5)
   mon.dexatt = RandomRange(rlow, rhigh)

   rlow = pchar.CurrAgl - (pchar.CurrAgl * .5)
   rhigh = pchar.CurrAgl + (pchar.CurrAgl * .5)
   mon.aglatt = RandomRange(rlow, rhigh)

   rlow = pchar.CurrInt - (pchar.CurrInt * .5)
   rhigh = pchar.CurrInt + (pchar.CurrInt * .5)
   mon.intatt = RandomRange(rlow, rhigh)
   
   'Set the combat factors.
   mon.ucfsk = mon.stratt + mon.aglatt
   mon.acfsk = mon.stratt + mon.dexatt 
   mon.pcfsk = mon.dexatt + mon.intatt
   mon.mcfsk = mon.intatt + mon.staatt
   mon.cdfsk = mon.stratt + mon.aglatt
   mon.mdfsk = mon.aglatt + mon.intatt
   
   'Set the hp.
   mon.currhp = mon.stratt + mon.staatt
   mon.maxhp = mon.currhp
   
   'Not fleeing.
   mon.flee = FALSE
   'Character not sighted.
   mon.psighted = FALSE 
   'Icon color.
   mon.mcolor = fbRedBright       
   
   'Clear any inventory items.
   For i As Integer = LBound(mon.dropitem) To UBound(mon.dropitem)
      ClearInv mon.dropitem(i)
   Next
   
   'Set individual atrributes.
   Select Case mon.id
      Case monDarkangel
         mon.mname = "Dark Angel" 'Name
         mon.micon = "A"          'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msBlindness 'Special attack.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 1  'Number of items in inventory.
         GenerateWeapon inv, currlevel, wpHellguard 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam 'How much damage mon does.
         mon.armval = .8 'Armor rating.
      Case monGiantbat
         mon.mname = "Giant Bat" 'Name
         mon.micon = "B"          'Map icon.
         mon.ismagic = FALSE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msNone 'Special attack.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = RandomRange(1, 10) 'How much damage mon does.
         mon.armval = .1 'Armor rating.
      Case monGiantscorpion
         mon.mname = "Giant Scorpion" 'Name
         mon.micon = "C"          'Map icon.
         mon.ismagic = FALSE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msPoison 'Special attack.
         mon.atkrange = 2 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = RandomRange(10, 20) 'How much damage mon does.
         mon.armval = .9 'Armor rating.
      Case monDragon
         mon.mname = "Dragon" 'Name
         mon.micon = "D"      'Map icon.
         mon.ismagic = FALSE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msFire 'Special attack.
         mon.atkrange = 6 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = RandomRange(10, 20) 'How much damage mon does.
         mon.armval = .9 'Armor rating.
      Case monElfwarrior
         mon.mname = "Elf Warrior" 'Name
         mon.micon = "E"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msNone 'Special attack.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam 'How much damage mon does.
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
      Case monWisp
         mon.mname = "Wisp" 'Name
         mon.micon = "F"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msParalyse 'Special attack.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = RandomRange(1, 5) 'How much damage mon does.
         mon.armval = .1 'Armor rating.
      Case monGiant
         mon.mname = "Giant" 'Name
         mon.micon = "G"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msNone 'Special attack.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam 'How much damage mon does.
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
      Case monHarpy
         mon.mname = "Harpy" 'Name
         mon.micon = "H"      'Map icon.
         mon.ismagic = FALSE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msPoison 'Special attack.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = RandomRange(1, 10) 'How much damage mon does.
         mon.armval = .2 'Armor rating.
      Case monIncubus
         mon.mname = "Incubus" 'Name
         mon.micon = "I"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msParalyse 'Special attack.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = RandomRange(1, 5) 'How much damage mon does.
         mon.armval = .3 'Armor rating.
      Case monJadegolem
         mon.mname = "Jade Golem" 'Name
         mon.micon = "J"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msDestroyWeapon 'Special attack.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = RandomRange(10, 20) 'How much damage mon does.
         mon.armval = .9 'Armor rating.
      Case monKraken
         mon.mname = "Kraken" 'Name
         mon.micon = "K"      'Map icon.
         mon.ismagic = FALSE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msPoison 'Special attack.
         mon.atkrange = 2 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = RandomRange(5, 10) 'How much damage mon does.
         mon.armval = .5 'Armor rating.
      Case monLamia
         mon.mname = "Lamia" 'Name
         mon.micon = "L"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msParalyse 'Special attack.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = RandomRange(1, 10) 'How much damage mon does.
         mon.armval = .1 'Armor rating.
      Case monManticore
         mon.mname = "Manticore" 'Name
         mon.micon = "M"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msPoison 'Special attack.
         mon.atkrange = 4 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = RandomRange(10, 20) 'How much damage mon does.
         mon.armval = .5 'Armor rating.
      Case monNaga
         mon.mname = "Naga" 'Name
         mon.micon = "N"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msDestroyArmor 'Special attack.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = RandomRange(5, 10) 'How much damage mon does.
         mon.armval = .5 'Armor rating.
      Case monOgre
         mon.mname = "Ogre" 'Name
         mon.micon = "O"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msNone 'Special attack.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam 'How much damage mon does.
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
      Case monPhantomfungus
         mon.mname = "Phantom Fungus" 'Name
         mon.micon = "P"      'Map icon.
         mon.ismagic = FALSE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msMultiply 'Special attack.
         mon.atkrange = 6 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = RandomRange(1, 5) 'How much damage mon does.
         mon.armval = .1 'Armor rating.
      Case monQuorn
         mon.mname = "Quorn" 'Name
         mon.micon = "Q"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msParalyse 'Special attack.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = RandomRange(5, 10) 'How much damage mon does.
         mon.armval = .5 'Armor rating.
      Case monRockgolem
         mon.mname = "Rock Golem" 'Name
         mon.micon = "R"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msParalyse 'Special attack.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = RandomRange(10, 20) 'How much damage mon does.
         mon.armval = .9 'Armor rating.
      Case monSkeleton
         mon.mname = "Skeleton" 'Name
         mon.micon = "S"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msNone 'Special attack.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam 'How much damage mon does.
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
      Case monTroll
         mon.mname = "Troll" 'Name
         mon.micon = "T"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msNone 'Special attack.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam 'How much damage mon does.
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
      Case monUruk
         mon.mname = "Uruk" 'Name
         mon.micon = "U"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msNone 'Special attack.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam 'How much damage mon does.
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
      Case monVampire
         mon.mname = "Vampire" 'Name
         mon.micon = "V"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msPoison 'Special attack.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam 'How much damage mon does.
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
      Case monWombat
         mon.mname = "Wombat" 'Name
         mon.micon = "W"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msDestroyItem 'Special attack.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = RandomRange(1, 5) 'How much damage mon does.
         mon.armval = .1 'Armor rating.
      Case monXerth
         mon.mname = "Xerth" 'Name
         mon.micon = "X"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msNone 'Special attack.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam 'How much damage mon does.
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
      Case monYeek
         mon.mname = "Yeek" 'Name
         mon.micon = "Y"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msNone 'Special attack.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam 'How much damage mon does.
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
      Case monZombie
         mon.mname = "Zombie" 'Name
         mon.micon = "Z"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msPoison 'Special attack.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam 'How much damage mon does.
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
      Case monFlameangel
         mon.mname = "Flame Angel" 'Name
         mon.micon = "a"          'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msFire 'Special attack.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 1  'Number of items in inventory.
         GenerateWeapon inv, currlevel, wpHellguard 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam 'How much damage mon does.
         mon.armval = .8 'Armor rating.
      Case monWerebear
         mon.mname = "Werebear" 'Name
         mon.micon = "b"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msPoison 'Special attack.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = RandomRange(10, 15) 'How much damage mon does.
         mon.armval = .6 'Armor rating.
      Case monGiantcentipede
         mon.mname = "Giant Centipede" 'Name
         mon.micon = "c"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msPoison 'Special attack.
         mon.atkrange = 4 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = RandomRange(1, 5) 'How much damage mon does.
         mon.armval = .9 'Armor rating.
      Case monDemonspawn
         mon.mname = "Demonspawn" 'Name
         mon.micon = "d"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msBlindness 'Special attack.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam 'How much damage mon does.
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
      Case monElemental
         mon.mname = "Fire Elemental" 'Name
         mon.micon = "e"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msFire 'Special attack.
         mon.atkrange = 4 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = RandomRange(5, 15) 'How much damage mon does.
         mon.armval = .5 'Armor rating.
      Case monFlamegolem
         mon.mname = "Flame Golem" 'Name
         mon.micon = "f"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msFire 'Special attack.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 1  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam 'How much damage mon does.
         mon.armval = .9
      Case monGolem
         mon.mname = "Golem" 'Name
         mon.micon = "g"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msNone 'Special attack.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 1  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam 'How much damage mon does.
         mon.armval = .9
      Case monHobgoblin
         mon.mname = "Hobgoblin" 'Name
         mon.micon = "h"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msNone 'Special attack.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam 'How much damage mon does.
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
      Case monInterloper
         mon.mname = "Interloper" 'Name
         mon.micon = "i"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msNone 'Special attack.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam 'How much damage mon does.
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
      Case monRovingjelly
         mon.mname = "Roving Jelly" 'Name
         mon.micon = "j"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msMultiply 'Special attack.
         mon.atkrange = 2 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = RandomRange(1, 10) 'How much damage mon does.
         mon.armval = .1 'Armor rating.
      Case monKobold
         mon.mname = "Kobold" 'Name
         mon.micon = "k"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msNone 'Special attack.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam 'How much damage mon does.
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
      Case monLich
         mon.mname = "Lich" 'Name
         mon.micon = "l"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msNone 'Special attack.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, wpHellMaul 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam 'How much damage mon does.
         ClearInv inv
         GenerateArmor inv, currlevel, armPlate
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
      Case monMage
         mon.mname = "Mage" 'Name
         mon.micon = "m"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msNone 'Special attack.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, wpLongstaff 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam 'How much damage mon does.
         ClearInv inv
         GenerateArmor inv, currlevel, armLeather
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
      Case monNazgul
         mon.mname = "Nazgul" 'Name
         mon.micon = "n"      'Map icon.
         mon.ismagic = FALSE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msBlindness 'Special attack.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, wpGreatsword 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam 'How much damage mon does.
         ClearInv inv
         GenerateArmor inv, currlevel, armPlate
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
      Case monOrc
         mon.mname = "Orc" 'Name
         mon.micon = "o"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msNone 'Special attack.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam 'How much damage mon does.
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
      Case monPulsingeye
         mon.mname = "Pulsing Eye" 'Name
         mon.micon = "p"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msParalyse 'Special attack.
         mon.atkrange = 2 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = RandomRange(1, 10) 'How much damage mon does.
         mon.armval = .1 'Armor rating.
      Case monTwinhead
         mon.mname = "Twin Head" 'Name
         mon.micon = "q"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msNone 'Special attack.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam 'How much damage mon does.
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
      Case monRogue
         mon.mname = "Rogue" 'Name
         mon.micon = "r"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msNone 'Special attack.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam 'How much damage mon does.
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
      Case monShurik
         mon.mname = "Shurik" 'Name
         mon.micon = "s"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msNone 'Special attack.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam 'How much damage mon does.
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
      Case monGianttarantula
         mon.mname = "Giant Tarantula" 'Name
         mon.micon = "t"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msParalyse 'Special attack.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = RandomRange(1, 10) 'How much damage mon does.
         mon.armval = .1 'Armor rating.
      Case monGiantbeetle
         mon.mname = "Giant Beetle" 'Name
         mon.micon = "u"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msPoison 'Special attack.
         mon.atkrange = 2 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = RandomRange(1, 10) 'How much damage mon does.
         mon.armval = .9 'Armor rating.
      Case monVarghoul
         mon.mname = "Varghoul" 'Name
         mon.micon = "v"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msBlindness 'Special attack.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam 'How much damage mon does.
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
      Case monWraith
         mon.mname = "Wraith" 'Name
         mon.micon = "w"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msBlindness 'Special attack.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam 'How much damage mon does.
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
      Case monXorn
         mon.mname = "Xorn" 'Name
         mon.micon = "x"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msNone 'Special attack.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam 'How much damage mon does.
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
      Case monYekki
         mon.mname = "Yekki" 'Name
         mon.micon = "y"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msNone 'Special attack.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam 'How much damage mon does.
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
      Case monGriffon
         mon.mname = "Griffon" 'Name
         mon.micon = "z"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell = 0      'If true then spell.
         mon.special = msPoison 'Special attack.
         mon.atkrange = 2 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = RandomRange(10, 15) 'How much damage mon does.
         mon.armval = .5 'Armor rating.
   End Select
End Sub
