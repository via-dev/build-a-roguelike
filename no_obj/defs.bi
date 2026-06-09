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
'Viewport width and height.
#Define vw 40 
#Define vh 53 
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
Const dodver = "0.47.1 (Proc)"
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
Const fbCadmiumYellow = RGB (255, 153, 18)
Const fbOrange = RGB (255, 128, 0)
Const fbMagenta = RGB (255, 0, 255)
Const fbSilver = RGB(192, 192, 192)
Const fbPink = RGB (255, 192, 203)
Const fbBlue = RGB (0, 0, 255)
Const fbCyan = RGB (0, 255, 255)
Const fbTurquoise = RGB (064, 224, 208)
Const fbFlame = RGB(226, 88, 34)

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

'Armor strength ratings.
Const strCloth = 10
Const strLeather = 50
Const strCuirboli = 100
Const strRing = 150
Const strBrigantine = 200
Const strChain = 250
Const strScale = 300
Const strPlate = 350

'Spell ids.
Enum spellid
   splNone        'No effect.
   splMaxHealing  'Heal to max HP.
   splStrongMeat  'Adds bonus to Str for count time.
   splBreadLife   'Cures any poison.
   splMaxMana     'Restore full mana.
   splSerpentBite 'Weapon: Inflict poison damage.
   splRend        'Weapon: Decrease armor of target.
   splSunder      'Weapon: Decrease target weapon damage.
   splReaper      'Weapon: Causes monster to flee in fright.
   splFire        'Weapon: Does fire damage to target for lvl turns.
   splGoliath     'Weapon: Adds str to attack.
   splStun        'Weapon: Stuns target for lvl turns.
   splChaos       'Weapon: Random amount of additonal damage.
   splWraith      'Weapon: Decreases random stat of target.
   splThief       'Weapon: Steals random stat amount from target and adds to character.
   splNoSlash     'Armor: +% from slash attacks.
   splNoCrush     'Armor: +% from crush attacks.
   splNoPierce    'Armor: +% from pierce attacks.
   splNoEnergy    'Armor: +% from energy attacks.
   splNoFire      'Armor: +% from fire attacks.
   splNoAcid      'Armor: +% from acid attacks.
   splNoMagic     'Armor: +% from magic attacks.
   splUCF         'Jewelry: +% to UCF.
   splACF         'Jewelry: +% to ACF.
   splPCF         'Jewelry: +% to PCF.
   splMCF         'Jewelry: +% to MCF.
   splCDF         'Jewelry: +% to CDF.
   splMDF         'Jewelry: +% to MDF.
   splRegenHP     'Jewelry: +% to healing per turn.
   splRegenMana   'Jewelry: +% to mana per turn.
   splAcidFog     'Spellbook: 5 dam over lvl turns
   splFireCloak   'Spellbook: Target gets 10 dam over lvl turns
   splHeal        'Spellbook: 1% x lvl
   splMana        'Spellbook: 1% x lvl (does not consume mana)
   splRecharge    'Spellbook: 1 x lvl recharge on wand
   splFocus       'Spellbook: +lvl to all combat factors for 1 turn
   splLightning   'Spellbook: 2 * lvl damage (ignores armor)
   splBlind       'Spellbook: Blinds target for lvl turns
   splTeleport    'Spellbook: Teleport to location lvl distance away (must be visible).
   splOpen        'Spellbook: Attempts to open a locked door (lvl vs. DR).
   splFear        'Spellbook: Makes monster flee for lvl turns.
   splConfuse     'Spellbook: Confuses monster for lvl turns.
   splFireBomb    'Spellbook: Area damage 20 x lvl. Sets monsters on fire lvl turns. 
   splEntangle    'Spellbook: Immobilze target for lvel turns doing lvl damage each turn.
   splCloudMind   'Spellbook: Target cannot cast spells for lvl turns.
   splFireball    'Spellbook: Area damage 10 x lvl. Sets monsters on fire lvl turns.
   splIceStatue   'Spellbook: Freezes target for lvl turns. If frozen can be killed with single hit.
   splRust        'Spellbook: Reduces armor by lvl x 10%.
   splShatter     'Spellbook: Destroys target weapon, if any.
   splMagicDrain  'Spellbook: Lower target MDF by lvl% and adds to caster for 1 turn.
   splPoison      'Spellbook: Posions target 1 HP for lvl turns.
   splEnfeeble    'Spellbook: Lowers target combat factors lvl x 10%.
   splShout       'Spellbook: Stuns all visible monsters for lvl turns.
   splStealHealth 'Spellbook: Lowers HP lvl% of target and adds to caster.
   splMindBlast   'Spellbook: Lowers target MCF and MDF lvl% for lvl turns.
   splBlink       'Spellbook: Makes character invisible to attack.
   splMonClaw     'Monster: Magic claw that slashes.
   splMonFist     'Monster: Magic fist that crushes.
   splMonFang     'Monster: Magic fang that pierces.
   splMonPoison   'Monster: Poisons character.
   splMonBolt     'Monster: Magic energy.
   splMonFire     'Monster: Magic fire.
   splMonAcid     'Monster: Magic acid.
End Enum

'Item use id.
Enum itemuse
   useNone      'No Use
   useEatDrink  'Eat or drink item.
   useWieldWear 'Wield or wear.
   useRead      'Can read the item.
End Enum

'Item class ids.
Enum classids
   clNone
   clGold
   clSupplies 
   clArmor
   clShield
   clWeapon
   clAmmo
   clPotion
   clRing
   clNecklace
   clSpellBook
   clSpell
   clUnavailable
End Enum

'Gold item ids.
Enum goldids
   gldGoldNone   'No gold.
   gldGold       'Gold coins.
   gldBagGold    'Bag of gold.
End Enum

'Supply item ids.
Enum supplyids
   supSupplyNone  'No supply id.
   supHealingHerb 'Healing herb-50% of max HP healing effect.
   supHunkMeat    '25% of max HP healing effect.
   supBread       '10% of max HP healing effect.
   supManaOrb     '10% of max mana to mana total.
   supLockPick    'Lock pick set.
   supSkeletonKey 'Skeleton key.
End Enum

'Armor ids
Enum armorids
   armArmorNone
   armCloth        'Cloth armor 1% damage reduction
   armLeather      'Leather armor: 5% damage reduction
   armCuirboli     'Cuirboli armor: 10 % damage reduction
   armRing         'Ring armor: 20% damage reduction
   armBrigantine   'Brigantine armor: 30% dam reduction
   armChain        'Chain armor: 50 % dam reduction
   armScale        'Scale armor: 70% dam reduction
   armPlate        'Plate armor: 90% dam reduction
End Enum

'Shield ids
Enum shieldids
   shldShieldNone
   shldLeather    'Shield amounts same as armor.
   shldCuirboli
   shldRing
   shldBrigantine
   shldChain
   shldScale
   shldPlate
End Enum

'Weapon ids.
Enum weaponids
   wpNone
   wpClub            '1 hand, dam 4 chr:33
   wpWarclub         '1 hand, dam 4
   wpCudgel          '1 hand, dam 5
   wpDagger          '1 hand, dam 4 chr: 173
   wpLongknife       '1 hand, dam 6
   wpSmallsword      '1 hand, dam 4
   wpShortsword      '1 hand, dam 6
   wpRapier          '1 hand, dam 9
   wpBroadsword      '1 hands, dam 12
   wpScimitar        '1 hand, dam 10
   wpKatana          '2 hands, dam 12
   wpLongsword       '2 hands, dam 14
   wpClaymore        '2 hands, dam 16
   wpGreatsword      '2 hands, dam 18
   wpOdinsword       '2 hands, dam 20
   wpHellguard       '2 hands, dam 30
   wpQuarterstaff    '2 hands, dam 4
   wpLongstaff       '2 hands, dam 6
   wpPolearm         '2 hands, dam 8
   wpLightspear      '2 hands, dam 7 chr: 179
   wpHeavyspear      '2 hands, dam 9
   wpTrident         '2 hands, dam 10
   wpGlaive          '2 hands, dam 12
   wpHandaxe         '1 hand, dam 6 chr: 244
   wpBattleaxe       '1 hand, dam 9
   wpGothicbattleaxe '2 hands, dam 12
   wpWaraxe          '2 hands, dam 14
   wpHalberd         '2 hands, dam 16
   wpPoleaxe         '2 hands, dam 18
   wpGreataxe        '2 hands, dam 20
   wpSmallmace       '1 hand, dam 6 chr: 226
   wpBattlemace      '1 hand, dam 8
   wpSpikedmace      '1 hand, dam 10
   wpDoubleballmace  '1 hand, dam 12
   wpWarhammer       '1 hand, dam 14
   wpMaul            '2 hands, dam 16
   wpGreatMaul       '2 hands, dam 20
   wpHellMaul        '2 hands, dam 30
   wpBullwhip        '1 hand, dam 4 chr: 231
   wpBallflail       '1 hand, dam 6
   wpSpikedflail     '1 hand, dam 8
   wpMorningstar     '1 hand, dam 10
   wpBattleflail     '2 hand, dam 12
   wpBishopsflail    '2 hand, dam 14
   wpSling           '1 hand, dam 2 chr: 125
   wpShortbow        '2 hands, dam 8
   wpLongbow         '2 hands, dam 10
   wpBonebow         '2 hands, dam 14
   wpAdaminebow      '2 hands, dam 20
   wpLightcrossbow   '2 hands, dam 10 chr: 209
   wpHeavycrossbow   '2 hands, dam 14
   wpBarrelcrossbow  '2 hands, dam 18
   wpAdaminecrossbow '2 hands, dam 25
   wpIronWand        '1 hand, dam 10
   wpBrassWand       '1 hand, dam 20
   wpCopperWand      '1 hand, dam 40
   wpSilverWand      '1 hand, dam 80
   wpGoldWand        '1 hand, dam 100
End Enum

'Ammo ids.
Enum ammoids
   amNone
   amBagStones
   amCaseBolts
   amQuiverArrows
End Enum

'Wield slots in character inventory.
Enum wieldpos
   wNone
   wPrimary
   wSecondary
   wArmor
   wNeck
   wRingRt
   wRingLt
   wAny
End Enum

'Weapon type.
Enum weaptype
   wtNone
   wtMelee
   wtProjectile
End Enum

'Weapon damage type.
Enum weapdamtype
   wdNone
   wdSlash
   wdCrush
   wdPierce
   wdEnergy
   wdFire
   wdAcid
   wdPoison
   wdMagicProt
End Enum

'The effect of the potion.
Enum poteffect
   potEffectNone
   potStrength
   potStamina
   potDexterity
   potAgility
   potIntelligence
   potUCF
   potACF
   potPCF
   potMCF
   potCDF
   potMDF
   potHealing
   potMana
End Enum

'Potion ids.
Enum potionids
   potNone
   potWhite 'str
   potBlack 'sta
   potBlue 'dex
   potGreen 'agl
   potCyan 'int
   potRed 'ucf
   potMagenta 'acf
   potYellow 'pcf
   potGray 'mcf
   potSilver 'cdf
   potGold 'mdf
   potOrange 'healing
   potPink 'mana
End Enum

'Jewelry ids
Enum jewleryids
   jewNone
   jewSteel
   jewBronze
   jewCopper
   jewBrass
   jewSilver
   jewGold
   jewAgate
   jewOpal
   jewAmethyst
   jewRuby
   jewEmerald
   jewJade
   jewPearl
   jewQuartz
   jewSapphire
   jewDiamond
End Enum

'Jewelry effects.
Enum jeffects
   jwNone  
   jwUCF  
   jwACF  
   jwPCF  
   jwMCF  
   jwCDF  
   jwMDF  
   jwRegenHP
   jwRegenMana  
End Enum

'Type of jewlery
Enum jewtype
   jNone
   jRing
   jNecklace
End Enum

'Types if spell books.
Enum spellbkids
   bkNone
   bkSpellBlank 'Nothing in it.
   bkSpellBook  'Spell in it.
End Enum


'Spell info type.
Type spelltype
   id As spellid          'The spell id.
   lvl As Integer         'Spell level.
   splname As String * 30 'Spell name.
   splsname As String * 8 'Spell short name.
   spldesc As String * 60 'Spell desc.
   manacost As Integer    'Cost in mana.
   dam As Integer         'The amount of damage the spell does.
End Type

'Spell book type.
Type spellbktype
   id As spellbkids   'Item type.
   evaldr As Integer  'Evaluation difficutly. Evaldr > 0 then magical item.
   eval As Integer    'Is item evaluated.
   use As itemuse     'How the items is used.
   noise As Integer   'How much noise it makes.
   spell As spelltype 'The actual spell type.
End Type

'Armor type
Type jewelrytype
   id As jewleryids          'Jewlery ids
   jtype As jewtype          'Ring or necklace
   evaldr As Integer         'Evaluation difficutly. Evaldr > 0 then magical item.
   eval As Integer           'Is item evaluated.
   spell As spelltype        'Magical spell.
   spelleffect As jeffects   'Jewelry effect.
   noise As Integer          'The amount of noise item generates, includes use and in character inventory.
   use As itemuse            'How the item is used.
   jslot(1 To 2) As wieldpos 'Slot item is held in. Could be in up to 2 slots.
End Type

'Potion type.
Type pottype
   id As potionids
   potname As String * 30 'Name of potion. 
   potdesc As String * 30 'Potion desc.
   evaldr As Integer      'Evaluation difficulty rating. Used to evaluate magical effects: 0 = nonMagic.
   eval As Integer        'True if item has been evaluated.
   noise As Integer       'The amount of noise item generates, includes use and in character inventory.
   use As itemuse         'How the item is used.
   amt As Integer         'Effect amount.
   cnt As Integer         'Effect duration.
   effect As poteffect    'The effect type.
End Type

'Ammo type.
Type ammotype
   id As ammoids
   cnt As Integer
   noise As Integer
   eval As Integer    
End Type

'Gold type.
Type goldtype
   id As goldids    'Type of gold item.
   amt As Integer   'Number of gold coins.
End Type

'Supply type def.
Type supplytype
   id As supplyids      'This indicates what sypply is in the type.
   desc As String * 30  'The supply effect.
   evaldr As Integer    'Evaluation difficulty rating. Used to evaluate magical effects: 0 = nonMagic.
   eval As Integer      'True if item has been evaluated.
   spell As spelltype     'The type of magical effect.
   noise As Integer     'The amount of noise item generates, includes use and in character inventory.
   use As itemuse       'How the item is used.
   sslot(1 To 2) As wieldpos 'For lock picks and skeleton keys.
End Type

'Armor type
Type armortype
   id As armorids       'Armor type
   evaldr As Integer    'Evaluation difficutly. Evaldr > 0 then magical item.
   eval As Integer      'Is item evaluated.
   spell As spelltype   'Magical spell.
   spelleffect As weapdamtype 'The spell effect.
   noise As Integer     'The amount of noise item generates, includes use and in character inventory.
   use As itemuse       'How the item is used.
   dampct As Single     'Percentage of damage reduction.
   struse As Integer    'Strength required to use.
   wslot(1 To 2) As wieldpos 'Slot item is held in. Could be in up to 2 slots.
End Type

'Shield type
Type shieldtype
   id As shieldids       'Shield type
   evaldr As Integer    'Evaluation difficutly. Evaldr > 0 then magical item.
   eval As Integer      'Is item evaluated.
   spell As spelltype    'Magical spell.
   spelleffect As weapdamtype 'The spell effect.
   noise As Integer     'The amount of noise item generates, includes use and in character inventory.
   use As itemuse       'How the item is used.
   dampct As Single     'Percentage of damage reduction.
   struse As Integer    'Strength required to use.
   wslot(1 To 2) As wieldpos 'Slot item is held in. Could be in up to 2 slots.
End Type

'Weapon type def.
Type weapontype
   id As weaponids           'Weapon type
   evaldr As Integer         'Evaluation difficutly. Evaldr > 0 then magical item.
   eval As Integer           'Is item evaluated.
   spell As spelltype        'Magical spell.
   noise As Integer          'The amount of noise item generates, includes use and in character inventory.
   use As itemuse            'How the item is used.
   dam As integer            'Damage weapons does.
   hands As Integer          'Number of hands weapon requires.
   wslot(1 To 2) As wieldpos 'Slot item is held in. Could be in up to 2 slots.
   weapontype As weaptype    'Type of weapon: melee, projectile.
   damtype As weapdamtype    'Type of damage infflicted.
   capacity As Integer       'The number of rounds the weapon uses.
   ammotype As ammoids       'Type of ammo used.
   ammocnt As Integer        'Weapon ammo. Can be loaded to capacity.
   iswand As Integer         'Marks item as a wand.
End Type

'Inventory type.
Type invtype
   classid As classids     'This indicates what class is in the union.
   desc As String * 30     'Plain text description.
   icon As String * 1      'This is the item icon.
   iconclr As UInteger     'This is the item's icon color.
   buy As Integer          'How much it costs to buy.
   sell As Integer         'How much it sells for.
   Union                   'Union of item types.
      gold As goldtype     'Gold coins. 
      supply As supplytype 'Supplies.
      armor As armortype   'Armor
      shield As shieldtype 'Shield
      weapon As weapontype 'Weapon
      ammo As ammotype     'Ammo for projectile weapons.
      potion As pottype    'Potion.
      jewelry As jewelrytype 'Rings and necklaces
      spellbook As spellbktype 'Spell book.
      spell As spelltype     'Spells
   End Union
End Type

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

'Size of the map.
#Define mapw 100
#Define maph 100
'Min and max room dimensions
#Define roommax 8 
#Define roommin 4
#Define nroommin 20
#Define nroommax 50
'Empty cell flag.
#Define emptycell 0
'Grid cell size (width and height)
#Define csizeh 10
#Define csizew 10
'Grid dimensions.
Const gw = mapw \ csizew
Const gh = maph \ csizeh

'The types of terrain in the map.
Enum terrainids
   tfloor = 0  'Walkable terrain.
   twall       'Impassable terrain.
   tdooropen   'Open door.
   tdoorclosed 'Closed door.
   tstairup    'Stairs up.
   tstairdn   'Stairs down.
   twmerch    'Wandering Merchant.
   tamulet    'The amulet.
End Enum

'Room dimensions.
Type rmdim
	rwidth As Integer
	rheight As Integer
	rcoord As mcoord
End Type

'Room information
Type roomtype
	roomdim As rmdim  'Room width and height.
	tl As mcoord      'Room rect
	br As mcoord
	secret As Integer         
End Type

'Grid cell structure.
Type celltype
	cellcoord As mcoord 'The cell position.
	Room As Integer     'Room id. This is an index into the room array.
End Type

'Door states.
Enum doorstates
   dsNone
   dsLocked
   dsOpen
   dsClosed
End Enum

'Door type.
Type doortype
   locked As Integer   'True if locked.
   lockdr As Integer   'Lock pick difficulty.
   dstr As Integer     'Strength of door (for bashing).
End Type

'Target type.
Type targettype
   id As Integer      'Ascii code of icon.
   tcolor As UInteger 'Color of icon.
End Type

'Trap ids.
Enum trapid
   trpNone
   trpBlade  'Slash trap.
   trpHammer 'Crush trap.
   trpSpike  'Pierce trap.
   trpEnergy 'Energy trap.
   trpFire   'Fire trap.
   trpAcid   'Acid trap. 
End Enum

'Trap types.
Type traptype
   id As trapid           'The trap id.
   icon As String * 1     'Map icon.
   iconcolor As UInteger  'Icon color.
   desc As String * 20    'The trap description.
   sprung As Integer      'FALSE = not triggered or found.
   dr As Integer          'The trap DR; compared to character agility.
   dam As Integer         'Damage trap does.
   damtype As weapdamtype 'The type of damage.
End Type

'Map info type
Type mapinfotype
	terrid As terrainids  'The terrain type.
	monidx As Integer     'Index into monster array.
	visible As Integer    'Character can see cell.
	seen As Integer       'Character has seen cell.
	doorinfo As doortype  'Door information.
	sndvol As Integer     'Sound volume at current tile.
	target As targettype  'Target and projectile map.
	trap As traptype      'Trap.
End Type

'Type monstat
Type monstat
   cnt As Integer
   mname As String * 15
End Type

'Dungeon level information.
Type levelinfo
   numlevel As Integer                       'Current level number.
   lmap(1 To mapw, 1 To maph) As mapinfotype 'Map array.
   linv(1 To mapw, 1 To maph) As invtype     'Map inventory type.
   nummon As Integer                         'Number of monsters on the map.
   moninfo(1 To nroommax) As montype         'Array of monsters.   
   killedmon(monDarkangel To monGriffon) As monstat     'The list of vanquished monsters.
   lastmon As monstat 'Last monster encountered.
End Type

'Indexes into attribute/factor arrays.
Enum attrindex
   idxAttr = 0 'Attribute/factor
   idxAttrBon 'Bonus
   idxAttrCnt 'Count
   idxArrMax 'Array max index. Insert new index before this entry.
End Enum

'Spell effects.
Enum cspleffects
   cPoison
   cBlink
End Enum

'Effects type.
Type cspleftype
   cnt As Integer    'The duration.
   amt As Integer    'The amt of effect.
End Type

'Character attribute type def.
Type characterinfo
   cname As String * 35 'Name of character.
   stratt(idxArrMax) As Integer 'Strength attribute (0), str bonus (1), bonus length in turns(2)
   staatt(idxArrMax) As Integer 'Stamina  
   dexatt(idxArrMax) As Integer 'Dexterity 
   aglatt(idxArrMax) As Integer 'Agility 
   intatt(idxArrMax) As Integer 'Intelligence 
   currhp As Integer    'Current HP
   maxhp As Integer     'Max HP
   currmana As Integer  'Current mana
   maxmana As Integer   'Max mana
   ucfsk(idxArrMax) As Integer  'Unarmed combat skill
   acfsk(idxArrMax) As Integer  'Armed combat skill
   pcfsk(idxArrMax) As Integer  'Projectile combat skill
   mcfsk(idxArrMax) As Integer  'Magic combat skill 
   cdfsk(idxArrMax) As Integer  'Combat defense skill
   mdfsk(idxArrMax) As Integer  'Magic defense skill 
   currxp As Integer    'Current spendable XP amount.
   totxp As Integer     'Lifetime XP amount.
   currgold As Integer  'Current gold amount.
   totgold As Integer   'Lifetime gold amount.
   ploc As mcoord       'Character current x and y location.
   cinv(97 To 122) As invtype 'Character inventory-using ascii codes a-z for index values.
   cspells(65 To 90) As invtype 'Character spells-using ascii codes A-Z for index values.
   cwield(wPrimary To wRingLt) As invtype 'Active items: 1 = primary weapon, 2 = secondary weapon/shield, 3 = armor, 4 = necklace, 5 = ring rt, 6 = rint lt
   cseffect(cPoison To cBlink) As cspleftype 'Spell effects array. 
   hasam As Integer 'TRUE if the character has found the amulet.
End Type

'Set up our character variable.
Dim Shared cinfo As characterinfo

'Dungeon level objects.
Dim Shared level As levelinfo                 'The level map structure.
Dim Shared numrooms As Integer                'The number of rooms in the 
Dim Shared rooms(1 To nroommax) As roomtype   'Room information.
Dim Shared grid(1 To gw, 1 To gh) As celltype 'Grid infromation.
Dim Shared Blockset As setobj                 'Blocking set.

'Message list.
Dim Shared mess(1 To 4) As String
Dim Shared messcolor(1 To 4) As UInteger = {fbWhite, fbWhite1, fbWhite2, fbWhite3}
'Spell set.
Dim Shared splSet As setobj

'Working variables.
Dim As String ckey
Dim As Integer mret
