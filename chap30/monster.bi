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

'Spell effects on monster.
Enum monSpells
   mePoison
   meFire
   meStun
End Enum

'Spell effects type.
Type monSpellEffects
   cnt As Integer    'The current spell duration count.
   dam As Integer    'The spell damage.
End Type

'Monster stats used in spells.
Enum monStats
   CombatFactor = 1
   CombatDefense
   MagicCombat
   MagicDefense
End Enum

'Monster type def. 
Type montype
   id As monids         'Monster id.
   mname As String * 15 'Monster name.
   micon As String * 1  'Icon
   mcolor As UInteger   'Color of icon.
   ismagic As Integer   'Can produce magic spells.
   spell As spelltype   'The attack/defense spell
   cd As Integer        'The defense factor
   cf As Integer        'The combat factor.
   md As Integer        'The magic defense factor
   mf As Integer        'The magic combat factor.
   currhp As Integer    'Current HP
   xp As Integer        'XP amount character wins.
   dropcount As Integer 'The number of items in inventory.
   dropitem(1 To 4) As invtype 'What the monster drops when dead.
   atkdam As Integer    'The monster attack damage.
   armval As Single     'Monster armor value as percentage.   
   atkrange As Integer  'Range of attack. 
   psighted As Integer  'Indicates that monster sighted player.
   plastloc As mcoord   'The position player last sighted.
   currcoord As mcoord  'Current coordinates.
   flee As Integer      'Monster is fleeing.
   isdead As Integer    'Is the monster dead.
   effects(mePoison To meStun) As monSpellEffects 'The current effects active on monster.
End Type

'Generates a monster.
Sub GenerateMonster(mon As montype, currlevel As Integer)
   Dim As invtype inv
   Dim stratt As Integer    'Strength attribute 
   Dim staatt As Integer    'Stamina  
   Dim dexatt As Integer    'Dexterity 
   Dim aglatt As Integer    'Agility 
   Dim intatt As Integer    'Intelligence 
   Dim ucfsk As Integer     'Unarmed combat skill
   Dim acfsk As Integer     'Armed combat skill
   Dim pcfsk As Integer     'Projectile combat skill
   Dim pct As Double        'Percentage adjustment for monsters.
   
   'Calculate the current percentage based on the level.
   pct = currlevel / maxlevel
   'Set the monster attributes.
   mon.id = RandomRange(monDarkangel, monGriffon)
   stratt = GetScaledFactor(pchar.CurrStr, currlevel)
   staatt = GetScaledFactor(pchar.CurrSta, currlevel)
   dexatt = GetScaledFactor(pchar.CurrDex, currlevel)
   aglatt = GetScaledFactor(pchar.CurrAgl, currlevel)
   intatt = GetScaledFactor(pchar.CurrInt, currlevel)
   'Calc the combat factors.
   acfsk = stratt + dexatt 
   pcfsk = dexatt + intatt
   'Set the combat factors.
   mon.cd = stratt + aglatt
   mon.md = aglatt + intatt 
   mon.mf = intatt + staatt
   mon.cf = stratt + aglatt 
   
   'Set the hp.
   mon.currhp = stratt + staatt
   
   'Not fleeing.
   mon.flee = FALSE
   'Character not sighted.
   mon.psighted = FALSE
   'No character last location.
   mon.plastloc.x = 0
   mon.plastloc.y = 0  
   'Icon color.
   mon.mcolor = fbRedBright
   'Monster not dead.       
   mon.isdead = FALSE
   
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
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 1  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam 'Use weapon damage.
         mon.armval = .8 'Armor rating.
         mon.cf = acfsk 'Combat attack factor.
      Case monGiantbat
         mon.mname = "Giant Bat" 'Name
         mon.micon = "B"          'Map icon.
         mon.ismagic = FALSE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .1 'Armor rating.
      Case monGiantscorpion
         mon.mname = "Giant Scorpion" 'Name
         mon.micon = "C"          'Map icon.
         mon.ismagic = FALSE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 2 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .9 'Armor rating.
      Case monDragon
         mon.mname = "Dragon" 'Name
         mon.micon = "D"      'Map icon.
         mon.ismagic = FALSE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 6 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .9 'Armor rating.
         mon.cf = pcfsk 'Combt attack factor.
      Case monElfwarrior
         mon.mname = "Elf Warrior" 'Name
         mon.micon = "E"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
         mon.cf = acfsk 'Combt attack factor.
      Case monWisp
         mon.mname = "Wisp" 'Name
         mon.micon = "F"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .1 'Armor rating.
      Case monGiant
         mon.mname = "Giant" 'Name
         mon.micon = "G"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam
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
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .2 'Armor rating.
      Case monIncubus
         mon.mname = "Incubus" 'Name
         mon.micon = "I"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .3 'Armor rating.
         mon.cf = ucfsk 'Combt attack factor.
      Case monJadegolem
         mon.mname = "Jade Golem" 'Name
         mon.micon = "J"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .9 'Armor rating.
         mon.cf = ucfsk 'Combt attack factor.
      Case monKraken
         mon.mname = "Kraken" 'Name
         mon.micon = "K"      'Map icon.
         mon.ismagic = FALSE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 2 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .5 'Armor rating.
         mon.cf = ucfsk 'Combt attack factor.
      Case monLamia
         mon.mname = "Lamia" 'Name
         mon.micon = "L"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .1 'Armor rating.
      Case monManticore
         mon.mname = "Manticore" 'Name
         mon.micon = "M"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 4 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .5 'Armor rating.
      Case monNaga
         mon.mname = "Naga" 'Name
         mon.micon = "N"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .5 'Armor rating.
      Case monOgre
         mon.mname = "Ogre" 'Name
         mon.micon = "O"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
         mon.cf = acfsk 'Combt attack factor.
      Case monPhantomfungus
         mon.mname = "Phantom Fungus" 'Name
         mon.micon = "P"      'Map icon.
         mon.ismagic = FALSE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 6 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .1 'Armor rating.
      Case monQuorn
         mon.mname = "Quorn" 'Name
         mon.micon = "Q"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .5 'Armor rating.
      Case monRockgolem
         mon.mname = "Rock Golem" 'Name
         mon.micon = "R"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .9 'Armor rating.
      Case monSkeleton
         mon.mname = "Skeleton" 'Name
         mon.micon = "S"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
         mon.cf = acfsk 'Combt attack factor.
      Case monTroll
         mon.mname = "Troll" 'Name
         mon.micon = "T"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
         mon.cf = acfsk 'Combt attack factor.
      Case monUruk
         mon.mname = "Uruk" 'Name
         mon.micon = "U"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
         mon.cf = acfsk 'Combt attack factor.
      Case monVampire
         mon.mname = "Vampire" 'Name
         mon.micon = "V"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
         mon.cf = acfsk 'Combt attack factor.
      Case monWombat
         mon.mname = "Wombat" 'Name
         mon.micon = "W"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .1 'Armor rating.
      Case monXerth
         mon.mname = "Xerth" 'Name
         mon.micon = "X"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
         mon.cf = acfsk 'Combt attack factor.
      Case monYeek
         mon.mname = "Yeek" 'Name
         mon.micon = "Y"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
         mon.cf = acfsk 'Combt attack factor.
      Case monZombie
         mon.mname = "Zombie" 'Name
         mon.micon = "Z"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
         mon.cf = acfsk 'Combt attack factor.
      Case monFlameangel
         mon.mname = "Flame Angel" 'Name
         mon.micon = "a"          'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 1  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam
         mon.armval = .8 'Armor rating.
         mon.cf = acfsk 'Combt attack factor.
      Case monWerebear
         mon.mname = "Werebear" 'Name
         mon.micon = "b"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .6 'Armor rating.
      Case monGiantcentipede
         mon.mname = "Giant Centipede" 'Name
         mon.micon = "c"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 4 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .9 'Armor rating.
      Case monDemonspawn
         mon.mname = "Demonspawn" 'Name
         mon.micon = "d"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
         mon.cf = acfsk 'Combt attack factor.
      Case monElemental
         mon.mname = "Fire Elemental" 'Name
         mon.micon = "e"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 4 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .5 'Armor rating.
      Case monFlamegolem
         mon.mname = "Flame Golem" 'Name
         mon.micon = "f"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 1  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam
         mon.armval = .9
         mon.cf = acfsk 'Combt attack factor.
      Case monGolem
         mon.mname = "Golem" 'Name
         mon.micon = "g"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 1  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam
         mon.armval = .9
         mon.cf = acfsk 'Combt attack factor.
      Case monHobgoblin
         mon.mname = "Hobgoblin" 'Name
         mon.micon = "h"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
         mon.cf = acfsk 'Combt attack factor.
      Case monInterloper
         mon.mname = "Interloper" 'Name
         mon.micon = "i"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
         mon.cf = acfsk 'Combt attack factor.
      Case monRovingjelly
         mon.mname = "Roving Jelly" 'Name
         mon.micon = "j"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 2 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4
         mon.armval = .1 'Armor rating.
      Case monKobold
         mon.mname = "Kobold" 'Name
         mon.micon = "k"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
         mon.cf = acfsk 'Combt attack factor.
      Case monLich
         mon.mname = "Lich" 'Name
         mon.micon = "l"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam
         ClearInv inv
         GenerateArmor inv, currlevel, armPlate
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
         mon.cf = acfsk 'Combt attack factor.
      Case monMage
         mon.mname = "Mage" 'Name
         mon.micon = "m"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, wpLongstaff 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam
         ClearInv inv
         GenerateArmor inv, currlevel, armLeather
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
         mon.cf = acfsk 'Combt attack factor.
      Case monNazgul
         mon.mname = "Nazgul" 'Name
         mon.micon = "n"      'Map icon.
         mon.ismagic = FALSE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, wpGreatsword 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam
         ClearInv inv
         GenerateArmor inv, currlevel, armPlate
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
         mon.cf = acfsk 'Combt attack factor.
      Case monOrc
         mon.mname = "Orc" 'Name
         mon.micon = "o"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
         mon.cf = acfsk 'Combt attack factor.
      Case monPulsingeye
         mon.mname = "Pulsing Eye" 'Name
         mon.micon = "p"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 2 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .1 'Armor rating.
         mon.cf = pcfsk 'Combt attack factor.
      Case monTwinhead
         mon.mname = "Twin Head" 'Name
         mon.micon = "q"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
         mon.cf = acfsk 'Combt attack factor.
      Case monRogue
         mon.mname = "Rogue" 'Name
         mon.micon = "r"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
         mon.cf = acfsk 'Combt attack factor.
      Case monShurik
         mon.mname = "Shurik" 'Name
         mon.micon = "s"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
         mon.cf = acfsk 'Combt attack factor.
      Case monGianttarantula
         mon.mname = "Giant Tarantula" 'Name
         mon.micon = "t"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .1 'Armor rating.
      Case monGiantbeetle
         mon.mname = "Giant Beetle" 'Name
         mon.micon = "u"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 2 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .9 'Armor rating.
      Case monVarghoul
         mon.mname = "Varghoul" 'Name
         mon.micon = "v"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
         mon.cf = acfsk 'Combt attack factor.
      Case monWraith
         mon.mname = "Wraith" 'Name
         mon.micon = "w"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
         mon.cf = acfsk 'Combt attack factor.
      Case monXorn
         mon.mname = "Xorn" 'Name
         mon.micon = "x"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
         mon.cf = acfsk 'Combt attack factor.
      Case monYekki
         mon.mname = "Yekki" 'Name
         mon.micon = "y"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 3  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam
         ClearInv inv
         GenerateArmor inv, currlevel, RandomRange(armCloth, armPlate)
         mon.dropitem(2) = inv 
         mon.armval = mon.dropitem(2).armor.dampct 'Armor rating.
         ClearInv inv 'Extra item.
         GenerateSupplies inv, currlevel
         mon.dropitem(3) = inv
         mon.cf = acfsk 'Combt attack factor.
      Case monGriffon
         mon.mname = "Griffon" 'Name
         mon.micon = "z"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = splNone      'Castable spell.
         mon.atkrange = 2 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .5 'Armor rating.
   End Select
   'Set the xp and max hp values.
   mon.xp = mon.currhp
   'Adjust the attack value by level percent.
   mon.atkdam = mon.atkdam * pct
   If mon.atkdam < 1 Then mon.atkdam = 1
   'Adjust the armor value by level percent.
   mon.armval = mon.armval * pct
End Sub

