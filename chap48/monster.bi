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
   mePoison      'Poison damage.
   meFire        'Fire damage.
   meStun        'Mosnter stunned.
   meAcidFog     '5 dam over lvl turns
   meBlind       'Blinds target for lvl turns
   meFear        'Makes monster flee for lvl turns.
   meConfuse     'Confuses monster for lvl turns.
   meEntangle    'Immobilze target for level turns doing lvl damage each turn.
   meCloudMind   'Target cannot cast spells for lvl turns.
   meMagicDrain  'Lower target MDF by lvl% and adds to caster for 1 turn.
   meEnfeeble    'Lowers target combat factors lvl x 10%.
   meIceStatue   'Freezes target for level turns.
   meMDF         'Lowers magic defense.
   meMCF         'Lowers magic defense.
End Enum

'Spell effects type.
Type monSpellEffects
   cnt As Integer    'The current spell duration count.
   dam As Integer    'The spell damage.
   lvl As Integer    'The effect lvl.
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
   spell As spelltype   'Active spell.
   cd As Integer        'The defense factor
   cdtot As Integer     'The total defense factor.
   cf As Integer        'The combat factor.
   cftot As Integer     'The total combat factor.
   md As Integer        'The magic defense factor
   mdtot As Integer     'Total magic defense.
   mf As Integer        'The magic combat factor.
   mftot As Integer     'Total magic combat factor.
   currhp As Integer    'Current HP
   xp As Integer        'XP amount character wins.
   dropcount As Integer 'The number of items in inventory.
   dropitem(1 To 4) As invtype 'What the monster drops when dead.
   atkdam As Integer    'The monster attack damage.
   armval As Single     'Monster armor value as percentage.   
   atkrange As Integer  'Range of attack.
   damtype As weapdamtype 'The type of attack.
   damstr As String * 10 'String that indicates type of damage.
   psighted As Integer  'Indicates that monster sighted player.
   plastloc As mcoord   'The position player last sighted.
   currcoord As mcoord  'Current coordinates.
   flee As Integer      'Monster is fleeing.
   isdead As Integer    'Is the monster dead.
   effects(mePoison To meMCF) As monSpellEffects 'The current effects active on monster.
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
   Dim pct As Single        'Percentage adjustment for monsters.
   Dim As Integer monrange = 20
   
   'Set the monster attributes.
   mon.id = RandomRange(monDarkangel, monGriffon)
   'Check to see if character has amulet.
   If pchar.HasAmulet = FALSE Then
      stratt = GetScaledFactor(pchar.CurrStr, currlevel)
      staatt = GetScaledFactor(pchar.CurrSta, currlevel)
      dexatt = GetScaledFactor(pchar.CurrDex, currlevel)
      aglatt = GetScaledFactor(pchar.CurrAgl, currlevel)
      intatt = GetScaledFactor(pchar.CurrInt, currlevel)
   Else
      stratt = RandomRange(pchar.CurrStr - monrange, pchar.CurrStr + monrange) 
      staatt = RandomRange(pchar.CurrSta - monrange, pchar.CurrSta + monrange)
      dexatt = RandomRange(pchar.CurrDex - monrange, pchar.CurrDex + monrange)
      aglatt = RandomRange(pchar.CurrAgl - monrange, pchar.CurrAgl + monrange)
      intatt = RandomRange(pchar.CurrInt - monrange, pchar.CurrInt + monrange)
   End If
   'Calc the combat factors.
   acfsk = stratt + dexatt 
   pcfsk = dexatt + intatt
   'Set the combat factors.
   mon.cd = stratt + aglatt
   mon.md = aglatt + intatt 
   mon.mf = intatt + staatt
   mon.cf = stratt + aglatt 
   'Set the original totals.
   mon.cdtot = mon.cd
   mon.mdtot = mon.md 
   mon.mftot = mon.mf
   mon.cftot = mon.cf 
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
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 1  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam 'Use weapon damage.
         mon.armval = .8 'Armor rating.
         mon.cf = acfsk 'Combat attack factor.
         mon.damtype = mon.dropitem(1).weapon.damtype 'Damage type.
      Case monGiantbat
         mon.mname = "Giant Bat" 'Name
         mon.micon = "B"          'Map icon.
         mon.ismagic = FALSE 'Magic flag.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .1 'Armor rating.
         mon.damtype = wdPierce
      Case monGiantscorpion
         mon.mname = "Giant Scorpion" 'Name
         mon.micon = "C"          'Map icon.
         mon.ismagic = FALSE 'Magic flag.
         mon.atkrange = 2 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .9 'Armor rating.
         mon.damtype = wdPierce
      Case monDragon
         mon.mname = "Dragon" 'Name
         mon.micon = "D"      'Map icon.
         mon.ismagic = FALSE 'Magic flag.
         mon.atkrange = 6 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .9 'Armor rating.
         mon.cf = pcfsk 'Combt attack factor.
         mon.damtype = wdFire
      Case monElfwarrior
         mon.mname = "Elf Warrior" 'Name
         mon.micon = "E"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
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
         mon.damtype = mon.dropitem(1).weapon.damtype 'Damage type.
      Case monWisp
         mon.mname = "Wisp" 'Name
         mon.micon = "F"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.spell.id = RandomRange(splMonBolt, splMonAcid)
         GenerateSpell mon.spell, currlevel
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .1 'Armor rating.
         mon.damtype = wdEnergy
      Case monGiant
         mon.mname = "Giant" 'Name
         mon.micon = "G"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.atkrange = 1   'Attack range.
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
         mon.damtype = mon.dropitem(1).weapon.damtype 'Damage type.
      Case monHarpy
         mon.mname = "Harpy" 'Name
         mon.micon = "H"      'Map icon.
         mon.ismagic = FALSE 'Magic flag.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .2 'Armor rating.
         mon.damtype = wdPierce
      Case monIncubus
         mon.mname = "Incubus" 'Name
         mon.micon = "I"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .3 'Armor rating.
         mon.cf = ucfsk 'Combt attack factor.
         mon.damtype = wdEnergy
      Case monJadegolem
         mon.mname = "Jade Golem" 'Name
         mon.micon = "J"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .9 'Armor rating.
         mon.cf = ucfsk 'Combt attack factor.
         mon.damtype = wdCrush
      Case monKraken
         mon.mname = "Kraken" 'Name
         mon.micon = "K"      'Map icon.
         mon.ismagic = FALSE 'Magic flag.
         mon.atkrange = 2 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .5 'Armor rating.
         mon.cf = ucfsk 'Combt attack factor.
         mon.damtype = wdSlash
      Case monLamia
         mon.mname = "Lamia" 'Name
         mon.micon = "L"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .1 'Armor rating.
         mon.damtype = wdEnergy
      Case monManticore
         mon.mname = "Manticore" 'Name
         mon.micon = "M"      'Map icon.
         mon.ismagic = FALSE 'Magic flag.
         mon.atkrange = 4 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .5 'Armor rating.
         mon.damtype = wdPierce
      Case monNaga
         mon.mname = "Naga" 'Name
         mon.micon = "N"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .5 'Armor rating.
         mon.damtype = wdEnergy
      Case monOgre
         mon.mname = "Ogre" 'Name
         mon.micon = "O"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
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
         mon.damtype = mon.dropitem(1).weapon.damtype 'Damage type.
      Case monPhantomfungus
         mon.mname = "Phantom Fungus" 'Name
         mon.micon = "P"      'Map icon.
         mon.ismagic = FALSE 'Magic flag.
         mon.atkrange = 6 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .1 'Armor rating.
         mon.damtype = wdAcid
      Case monQuorn
         mon.mname = "Quorn" 'Name
         mon.micon = "Q"      'Map icon.
         mon.ismagic = FALSE 'Magic flag.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .5 'Armor rating.
         mon.damtype = wdSlash
      Case monRockgolem
         mon.mname = "Rock Golem" 'Name
         mon.micon = "R"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .9 'Armor rating.
         mon.damtype = wdCrush
      Case monSkeleton
         mon.mname = "Skeleton" 'Name
         mon.micon = "S"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
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
         mon.damtype = mon.dropitem(1).weapon.damtype 'Damage type.
      Case monTroll
         mon.mname = "Troll" 'Name
         mon.micon = "T"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
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
         mon.damtype = mon.dropitem(1).weapon.damtype 'Damage type.
      Case monUruk
         mon.mname = "Uruk" 'Name
         mon.micon = "U"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
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
         mon.damtype = mon.dropitem(1).weapon.damtype 'Damage type.
      Case monVampire
         mon.mname = "Vampire" 'Name
         mon.micon = "V"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
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
         mon.damtype = mon.dropitem(1).weapon.damtype 'Damage type.
      Case monWombat
         mon.mname = "Wombat" 'Name
         mon.micon = "W"      'Map icon.
         mon.ismagic = FALSE 'Magic flag.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .1 'Armor rating.
         mon.damtype = wdPierce
      Case monXerth
         mon.mname = "Xerth" 'Name
         mon.micon = "X"      'Map icon.
         mon.ismagic = FALSE 'Magic flag.
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
         mon.damtype = mon.dropitem(1).weapon.damtype 'Damage type.
      Case monYeek
         mon.mname = "Yeek" 'Name
         mon.micon = "Y"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
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
         mon.damtype = mon.dropitem(1).weapon.damtype 'Damage type.
      Case monZombie
         mon.mname = "Zombie" 'Name
         mon.micon = "Z"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
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
         mon.damtype = mon.dropitem(1).weapon.damtype 'Damage type.
      Case monFlameangel
         mon.mname = "Flame Angel" 'Name
         mon.micon = "a"          'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 1  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam
         mon.armval = .8 'Armor rating.
         mon.cf = acfsk 'Combt attack factor.
         mon.damtype = mon.dropitem(1).weapon.damtype 'Damage type.
      Case monWerebear
         mon.mname = "Werebear" 'Name
         mon.micon = "b"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .6 'Armor rating.
         mon.damtype = wdPierce
      Case monGiantcentipede
         mon.mname = "Giant Centipede" 'Name
         mon.micon = "c"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.atkrange = 4 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .9 'Armor rating.
         mon.damtype = wdPierce
      Case monDemonspawn
         mon.mname = "Demonspawn" 'Name
         mon.micon = "d"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
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
         mon.damtype = mon.dropitem(1).weapon.damtype 'Damage type.
      Case monElemental
         mon.mname = "Fire Elemental" 'Name
         mon.micon = "e"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.atkrange = 4 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .5 'Armor rating.
         mon.damtype = wdFire
      Case monFlamegolem
         mon.mname = "Flame Golem" 'Name
         mon.micon = "f"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 1  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam
         mon.armval = .9
         mon.cf = acfsk 'Combt attack factor.
         mon.damtype = mon.dropitem(1).weapon.damtype 'Damage type.
      Case monGolem
         mon.mname = "Golem" 'Name
         mon.micon = "g"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 1  'Number of items in inventory.
         GenerateWeapon inv, currlevel, RandomRange(wpSmallsword, wpBishopsflail) 'Weapon. 
         mon.dropitem(1) = inv 'Set the inv item.
         mon.atkdam = mon.dropitem(1).weapon.dam
         mon.armval = .9
         mon.cf = acfsk 'Combt attack factor.
         mon.damtype = mon.dropitem(1).weapon.damtype 'Damage type.
      Case monHobgoblin
         mon.mname = "Hobgoblin" 'Name
         mon.micon = "h"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
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
         mon.damtype = mon.dropitem(1).weapon.damtype 'Damage type.
      Case monInterloper
         mon.mname = "Interloper" 'Name
         mon.micon = "i"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
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
         mon.damtype = mon.dropitem(1).weapon.damtype 'Damage type.
      Case monRovingjelly
         mon.mname = "Roving Jelly" 'Name
         mon.micon = "j"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.atkrange = 2 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4
         mon.armval = .1 'Armor rating.
         mon.damtype = wdAcid
      Case monKobold
         mon.mname = "Kobold" 'Name
         mon.micon = "k"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
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
         mon.damtype = mon.dropitem(1).weapon.damtype 'Damage type.
      Case monLich
         mon.mname = "Lich" 'Name
         mon.micon = "l"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
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
         mon.damtype = mon.dropitem(1).weapon.damtype 'Damage type.
      Case monMage
         mon.mname = "Mage" 'Name
         mon.micon = "m"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
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
         mon.damtype = mon.dropitem(1).weapon.damtype 'Damage type.
      Case monNazgul
         mon.mname = "Nazgul" 'Name
         mon.micon = "n"      'Map icon.
         mon.ismagic = FALSE 'Magic flag.
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
         mon.damtype = mon.dropitem(1).weapon.damtype 'Damage type.
      Case monOrc
         mon.mname = "Orc" 'Name
         mon.micon = "o"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
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
         mon.damtype = mon.dropitem(1).weapon.damtype 'Damage type.
      Case monPulsingeye
         mon.mname = "Pulsing Eye" 'Name
         mon.micon = "p"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.atkrange = 2 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .1 'Armor rating.
         mon.cf = pcfsk 'Combt attack factor.
         mon.damtype = wdEnergy
      Case monTwinhead
         mon.mname = "Twin Head" 'Name
         mon.micon = "q"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
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
         mon.damtype = mon.dropitem(1).weapon.damtype 'Damage type.
      Case monRogue
         mon.mname = "Rogue" 'Name
         mon.micon = "r"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
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
         mon.damtype = mon.dropitem(1).weapon.damtype 'Damage type.
      Case monShurik
         mon.mname = "Shurik" 'Name
         mon.micon = "s"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
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
         mon.damtype = mon.dropitem(1).weapon.damtype 'Damage type.
      Case monGianttarantula
         mon.mname = "Giant Tarantula" 'Name
         mon.micon = "t"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.atkrange = 1 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .1 'Armor rating.
         mon.damtype = wdPierce
      Case monGiantbeetle
         mon.mname = "Giant Beetle" 'Name
         mon.micon = "u"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.atkrange = 2 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .9 'Armor rating.
         mon.damtype = wdPierce
      Case monVarghoul
         mon.mname = "Varghoul" 'Name
         mon.micon = "v"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
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
         mon.damtype = mon.dropitem(1).weapon.damtype 'Damage type.
      Case monWraith
         mon.mname = "Wraith" 'Name
         mon.micon = "w"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
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
         mon.damtype = mon.dropitem(1).weapon.damtype 'Damage type.
      Case monXorn
         mon.mname = "Xorn" 'Name
         mon.micon = "x"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
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
         mon.damtype = mon.dropitem(1).weapon.damtype 'Damage type.
      Case monYekki
         mon.mname = "Yekki" 'Name
         mon.micon = "y"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
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
         mon.damtype = mon.dropitem(1).weapon.damtype 'Damage type.
      Case monGriffon
         mon.mname = "Griffon" 'Name
         mon.micon = "z"      'Map icon.
         mon.ismagic = TRUE 'Magic flag.
         mon.atkrange = 2 'Attack range.
         mon.dropcount = 0  'Number of items in inventory.
         mon.atkdam = stratt / 4 'How much damage mon does.
         mon.armval = .5 'Armor rating.
         mon.damtype = wdSlash
   End Select
   'Get the monster spell.
   If mon.ismagic = TRUE Then
      mon.spell.id = RandomRange(splMonClaw, splMonAcid)
      GenerateSpell mon.spell, currlevel
      mon.spell.dam += mon.atkdam * (mon.spell.lvl / 100)
   EndIf
   'Set the damage string.
   Select Case mon.damtype
      Case wdSlash
         mon.damstr = "slash"
      Case wdCrush
         mon.damstr = "crush"
      Case wdPierce
         mon.damstr = "pierce"
      Case wdEnergy
         mon.damstr = "energy"
      Case wdFire
         mon.damstr = "fire"
      Case wdAcid
         mon.damstr = "acid"
      Case wdPoison
         mon.damstr = "poison"
      Case Else
         mon.damstr = ""
   End Select
   'Set the xp and max hp values.
   mon.xp = mon.currhp
   'Adjust the attack and armor bvalue based on the level.
   If pchar.HasAmulet = FALSE Then
      'Calculate the current percentage based on the level.
      pct = currlevel / maxlevel
      'Adjust the attack value by level percent.
      mon.atkdam = mon.atkdam * pct
      If mon.atkdam < 1 Then mon.atkdam = 1
      'Adjust the armor value by level percent.
      mon.armval = mon.armval * pct
   End If
End Sub

