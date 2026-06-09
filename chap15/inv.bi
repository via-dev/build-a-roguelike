/'****************************************************************************
*
* Name: inv.bi
*
* Synopsis: Inventory routines for DOD.
*
* Description: This file contains the the inventory routines used in the game.  
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
'Effects ids.
Enum effectsid
   effEffectNone    'No effect.
   effMaxHealing    'Heal to max HP.
   effStrongMeat    'Adds bonus to Str for count time.
   effBreadLife     'Cures any poison.
   effSeeAll        'Set all tiles to visible.
End Enum

'Item use id.
Enum itemuse
   useNone      'No Use
   useEatDrink  'Eat or drink item.
   useWieldWear 'Wield or wear.
End Enum

'Item class ids.
Enum classids
   clNone
   clGold
   clSupplies 
   clArmor
   clShield
   clWeapon
   clPotion
   clWand
   clLight
   clAmmo
   clScroll
   clSpellBook
   clRing
   clNecklace
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
   supBottleOil   'Used to fill lantern.
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
End Enum

'Gold type.
Type goldtype
   id As goldids    'Type of gold item.
   amt As Integer   'Number of gold coins.
End Type

'Supply type def.
Type supplytype
   id As supplyids      'This indicates what sypply is in the type.
   evaldr As Integer    'Evaluation difficulty rating. Used to evaluate magical effects: 0 = nonMagic.
   eval As Integer      'True if item has been evaluated.
   effect As effectsid  'The type of magical effect.
   sdesc As String * 30 'Secret name/description for magical items. Revealed when evaluated.
   noise As Integer     'The amount of noise item generates, includes use and in character inventory.
   use As itemuse       'How the item is used.
End Type

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

'Armor type
Type armortype
   id As armorids       'Armor type
   evaldr As Integer    'Evaluation difficutly. Evaldr > 0 then magical item.
   eval As Integer      'Is item evaluated.
   effect As Integer    'Magical spell.
   sdesc As String * 30 'Secret name/description for magical items. Revealed when evaluated.
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
   effect As integer    'Magical spell.
   sdesc As String * 30 'Secret name/description for magical items. Revealed when evaluated.
   noise As Integer     'The amount of noise item generates, includes use and in character inventory.
   use As itemuse       'How the item is used.
   dampct As Single     'Percentage of damage reduction.
   struse As Integer    'Strength required to use.
   wslot(1 To 2) As wieldpos 'Slot item is held in. Could be in up to 2 slots.
End Type

'Inventory type.
Type invtype
   classid As classids     'This indicates what class is in the union.
   desc As String * 30     'Plain text description.
   icon As String * 1      'This is the item icon.
   iconclr As UInteger     'This is the item's icon color.
   Union                   'Union of item types.
      gold As goldtype     'Gold coins. 
      supply As supplytype 'Supplies.
      armor As armortype   'Armor
      shield As shieldtype 'Shield
   End Union
End Type

'Clears the inventory type instance. 
Sub ClearInv(inv As invtype)
   
   'If classid is None then nothing to do.
   If inv.classid <> clNone Then
      Select Case inv.classid
         Case clGold
            inv.gold.id = gldGoldNone
            inv.gold.amt = 0
         Case clSupplies
            inv.supply.id = supSupplyNone
            inv.supply.evaldr = 0
            inv.supply.eval = FALSE
            inv.supply.effect = effEffectNone
            inv.supply.sdesc = ""
            inv.supply.noise = 0
            inv.supply.use = useNone
         Case clArmor
            inv.armor.id = armArmorNone
            inv.armor.evaldr = 0
            inv.armor.eval = FALSE
            inv.armor.effect = 0
            inv.armor.sdesc = ""
            inv.armor.noise = 0
            inv.armor.use = UseNone
            inv.armor.dampct = 0
            inv.armor.struse = 0
            inv.armor.wslot(1) = wNone
            inv.armor.wslot(2) = wNone
         Case clShield
            inv.shield.id = shldShieldNone
            inv.shield.evaldr = 0
            inv.shield.eval = FALSE
            inv.shield.effect = 0
            inv.shield.sdesc = ""
            inv.shield.noise = 0
            inv.shield.use = UseNone
            inv.shield.dampct = 0
            inv.shield.struse = 0
            inv.shield.wslot(1) = wNone
            inv.shield.wslot(2) = wNone
      End Select
     'Clear main description.
      inv.desc = ""
      'Clear the classid.
      inv.classid = clNone
      'Clear icon info.
      inv.icon = ""
      inv.iconclr = fbBlack
   EndIf
End Sub

'Returns the item desc for item at x, y coordinate.
Function GetInvItemDesc(inv As invtype) As String
   Dim As String ret = "None"
   
   'If classid is None then nothing to do.
   If inv.classid <> clNone Then
      'Get the gold description.
      If inv.classid = clGold Then
         ret = inv.desc
      EndIf
      'Get the supply description. 
      If inv.classid = clSupplies Then
         'If not evaluated, then return main description.
         If inv.supply.eval = FALSE Then
            ret = inv.desc
         Else
            'Return secret description.
            ret = inv.supply.sdesc
         EndIf
      EndIf
      'Get armor description.
      If inv.classid = clArmor Then
         'If not evaluated, then return main description.
         If inv.armor.eval = FALSE Then
            ret = inv.desc
         Else
            'Return secret description.
            ret = inv.armor.sdesc
         EndIf
      EndIf
      'Get shield description.
      If inv.classid = clShield Then
         'If not evaluated, then return main description.
         If inv.shield.eval = FALSE Then
            ret = inv.desc
         Else
            'Return secret description.
            ret = inv.shield.sdesc
         EndIf
      EndIf
      
   EndIf
   
   Return ret
End Function

'Returns True if item is magic.
Function ItemIsMagic(currlevel As Integer) As Integer
   Dim As Integer num
   
   'Get a random number from 1 to 100
   num = RandomRange(1, maxlevel * 2)
   'If number matches or is less than current level, item is magic.
   If num <= currlevel Then
      Return TRUE
   Else
      Return FALSE
   EndIf
   
End Function

'Generate new armor item.
Sub GenerateArmor(inv As invtype, currlevel As Integer, arid As armorids = armArmorNone)
   Dim item As armorids 
   Dim As Integer isMagic = ItemIsMagic(currlevel) 

   'These are the common items.
   If arid = armArmorNone Then
      item = RandomRange(armCloth, armPlate)
      inv.armor.id = item
   Else
      item = arid
      inv.armor.id = item
   End If
   inv.icon = Chr(234)
   inv.iconclr = fbEmeraldGreen
   inv.armor.use = useWieldWear
   inv.armor.eval = FALSE
   inv.armor.wslot(1) = wArmor
   'magic item.
   If IsMagic = TRUE Then
      inv.armor.evaldr = RandomRange(currlevel, currlevel * 2)
      inv.armor.effect = 0
   EndIf
   'Set the armor type and amount.
   Select Case item
      Case armCloth
         inv.desc = "Cloth Armor" 'Cloth armor: 1% damage reduction.
         inv.armor.noise = 1
         inv.armor.dampct = .01
         inv.armor.struse = 10
      Case armLeather 'Leather armor: 5% damage reduction
         inv.desc = "Leather Armor"
         inv.armor.noise = 5
         inv.armor.dampct = .05
         inv.armor.struse = 50
      Case armCuirboli 'Cuirboli armor: 10 % damage reduction
         inv.desc = "Cuirboli Armor"
         inv.armor.noise = 10
         inv.armor.dampct = .10
         inv.armor.struse = 100
      Case armRing  'Ring armor: 20% damage reduction  
         inv.desc = "Ring Armor"
         inv.armor.noise = 15
         inv.armor.dampct = .20
         inv.armor.struse = 150
      Case armBrigantine 'Brigantine armor: 30% dam reduction  
         inv.desc = "Brigantine Armor"
         inv.armor.noise = 20
         inv.armor.dampct = .30
         inv.armor.struse = 200
      Case armChain 'Chain armor: 50 % dam reduction
         inv.desc = "Chain Armor"
         inv.armor.noise = 25
         inv.armor.dampct = .50
         inv.armor.struse = 250
      Case armScale 'Scale armor: 70% dam reduction
         inv.desc = "Scale Armor"
         inv.armor.noise = 30
         inv.armor.dampct = .70
         inv.armor.struse = 300
      Case armPlate 'Plate armor: 90% dam reduction
         inv.desc = "Plate Armor"
         inv.armor.noise = 35
         inv.armor.dampct = .90
         inv.armor.struse = 350
   End Select
   'Set the complete secret description.
   If IsMagic = TRUE Then
      inv.armor.sdesc = inv.desc 
   Else
      inv.armor.sdesc = inv.desc
   EndIf
End Sub

'Generate new shield item.
Sub GenerateShield(inv As invtype, currlevel As Integer)
   Dim item As shieldids = RandomRange(shldLeather, shldPlate) 
   Dim As Integer isMagic = ItemIsMagic(currlevel) 

   'These are the common items.
   inv.shield.id = item
   inv.icon = Chr(233)
   inv.iconclr = fbEmeraldGreen
   inv.shield.use = useWieldWear
   inv.shield.eval = FALSE
   inv.shield.wslot(1) = wPrimary
   inv.shield.wslot(2) = wSecondary
   'magic item.
   If IsMagic = TRUE Then
      inv.shield.evaldr = RandomRange(currlevel, currlevel * 2)
      inv.shield.effect = 0
   EndIf
   'Set the shield type and amount.
   Select Case item
      Case shldLeather 'Leather shield: 5% damage reduction
         inv.desc = "Leather Shield"
         inv.shield.noise = 5
         inv.shield.dampct = .05
         inv.shield.struse = 50
      Case shldCuirboli 'Cuirboli shield: 10 % damage reduction
         inv.desc = "Cuirboli Shield"
         inv.shield.noise = 10
         inv.shield.dampct = .10
         inv.shield.struse = 100
      Case shldRing  'Ring shield: 20% damage reduction  
         inv.desc = "Ring Shield"
         inv.shield.noise = 15
         inv.shield.dampct = .20
         inv.shield.struse = 150
      Case shldBrigantine 'Brigantine shield: 30% dam reduction  
         inv.desc = "Brigantine Shield"
         inv.shield.noise = 20
         inv.shield.dampct = .30
         inv.shield.struse = 200
      Case shldChain 'Chain shield: 50 % dam reduction
         inv.desc = "Chain Shield"
         inv.shield.noise = 25
         inv.shield.dampct = .50
         inv.shield.struse = 250
      Case shldScale 'Scale shield: 70% dam reduction
         inv.desc = "Scale Shield"
         inv.shield.noise = 30
         inv.shield.dampct = .70
         inv.shield.struse = 300
      Case shldPlate 'Plate shield: 90% dam reduction
         inv.desc = "Plate Shield"
         inv.shield.noise = 35
         inv.shield.dampct = .90
         inv.shield.struse = 350
   End Select
   'Set the complete secret description.
   If IsMagic = TRUE Then
      inv.shield.sdesc = inv.desc 
   Else
      inv.shield.sdesc = inv.desc
   EndIf
   
End Sub

'Generate new supply item.
Sub GenerateSupplies(inv As invtype, currlevel As Integer)
   Dim item As supplyids = RandomRange(supHealingHerb, armPlate) 
   Dim As Integer isMagic = ItemIsMagic(currlevel) 
   
   'Set the supply item id.
   inv.supply.id = item
   Select Case item
      Case supHealingHerb 
         inv.desc = "Healing Herb"
         inv.supply.noise = 1
         inv.icon = Chr(157)
         inv.iconclr = fbGreen
         inv.supply.eval = FALSE
         inv.supply.use = useEatDrink
         'Set the magic properties.
         If isMagic = TRUE Then
            inv.supply.evaldr = RandomRange(currlevel, currlevel * 2)
            inv.supply.effect = effMaxHealing
            inv.supply.sdesc = "Herb of Max Health"
         Else 
            'Set secret description to main desciption.
            inv.supply.sdesc = inv.desc
         EndIf
      Case supHunkMeat
         inv.desc = "Hunk of Meat"
         inv.supply.noise = 1
         inv.icon = Chr(224)
         inv.iconclr = fbSalmon
         inv.supply.eval = FALSE
         inv.supply.use = useEatDrink
         'Set the magic properties.
         If isMagic = TRUE Then
            inv.supply.evaldr = RandomRange(currlevel, currlevel * 2)
            inv.supply.effect = effStrongMeat
            inv.supply.sdesc = "Hunk of Strong Meat"
         Else 
            'Set secret description to main desciption.
            inv.supply.sdesc = inv.desc
         EndIf
      Case supBread       
         inv.desc = "Loaf of Bread"
         inv.supply.noise = 1
         inv.icon = Chr(247)
         inv.iconclr = fbHoneydew
         inv.supply.eval = FALSE 
         inv.supply.use = useEatDrink
         'Set the magic properties.
         If isMagic = TRUE Then
            inv.supply.evaldr = RandomRange(currlevel, currlevel * 2)
            inv.supply.effect = effBreadLife
            inv.supply.sdesc = "Bread of Cure Poison"
         Else 
            'Set secret description to main desciption.
            inv.supply.sdesc = inv.desc
         EndIf
      Case supBottleOil   
         inv.desc = "Bottle of Oil"
         inv.supply.noise = 4
         inv.icon = Chr(229)
         inv.iconclr = fbYellowGreen
         inv.supply.eval = FALSE
         inv.supply.use = useNone
         'Set the magic properties.
         If isMagic = TRUE Then
            inv.supply.evaldr = RandomRange(currlevel, currlevel * 2)
            inv.supply.effect = effSeeAll
            inv.supply.sdesc = "Oil of All-Seeing"
         Else 
            'Set secret description to main desciption.
            inv.supply.sdesc = inv.desc
         EndIf
   End Select
End Sub

'Generate new gold item.
Sub GenerateGold(inv As invtype)
   Dim As Integer rng = RandomRange(1, 10)
   
   'Set the gold item id.
   If rng = 1 Then 
      inv.gold.id = gldBagGold
   Else
      inv.gold.id = gldGold
   EndIf
   Select Case inv.gold.id
      Case gldGold
         inv.desc = "Gold Coins"
         inv.gold.amt = RandomRange(1, 10)
         inv.icon = Chr(147)
         inv.iconclr = fbGold
      Case gldBagGold
         inv.desc = "Bag of Gold"
         inv.gold.amt = RandomRange(10, 100)
         inv.icon = Chr(147)
         inv.iconclr = fbGold
   End Select
End Sub

'Generates a new item and places it into the invetory slot.
Sub GenerateItem(inv As invtype, currlevel As Integer)
   Dim iclass As classids = RandomRange(clGold, clShield)
   
   'Make sure we generated an item.
   If iclass <> clNone Then
      'Clear current item if not cleared.
      If inv.classid <> clNone Then
         ClearInv inv
      EndIf
      'Set the item class.
      inv.classid = iclass
      'Generate item based on class id.
      Select Case iclass
         Case clGold
            GenerateGold inv
         Case clSupplies
            GenerateSupplies inv, currlevel
         Case clArmor
            GenerateArmor inv, currlevel
         Case clShield
            GenerateShield inv, currlevel
      End Select
   End If
End Sub

'Returns True if item has been evaluated.
Function IsEval(inv As invtype) As Integer
   Dim As Integer ret
   
   'If nothing then mark as evaluated.
   If inv.classid = clNone Then
      ret = TRUE
   Else
      'Select the item type.
      Select Case inv.classid 'Don't need to eval gold.
         Case clGold
            ret = TRUE
         Case clSupplies  'Return supply eval glag.
            ret = inv.supply.eval
         Case clArmor
            ret = inv.armor.eval
         Case clShield
            ret = inv.shield.eval
      End Select
   EndIf
   
   Return ret
End Function

'Returns the eval difficulty rating.
Function GetEvalDR(inv As invtype) As Integer
   Dim As Integer ret
   
   'If nothing then evaldr is 0.
   If inv.classid = clNone Then
      ret = 0
   Else
      'Select the item.
      Select Case inv.classid
         Case clGold 'Don't need to eval gold.
            ret = 0
         Case clSupplies
            ret = inv.supply.evaldr 'Return supply eval dr.
         Case clArmor
            ret = inv.armor.evaldr 'Return armor eval dr.
         Case clShield
            ret = inv.shield.evaldr 'Return shield eval dr.
      End Select
   EndIf
   
   Return ret
End Function

'Sets eval state to passed type.
Sub SetInvEval(inv As invtype, state As Integer)
   
   'If nothing then no eval.
   If inv.classid <> clNone Then
      'Select the item.
      Select Case inv.classid
         Case clSupplies
            inv.supply.eval = state 'Set the eval state.
         Case clArmor
            inv.armor.eval = state 
         Case clShield
            inv.shield.eval = state 
      End Select
   EndIf
   
End Sub

'Returns True if item matches the use flag.
Function MatchUse(inv As invtype, whatuse As itemuse) As Integer
   Dim As Integer ret = FALSE
   
   'If nothing then no use.
   If inv.classid <> clNone Then
      'Select the item.
      Select Case inv.classid
         'Compare the passed use to the flag use.
         Case clSupplies
            If inv.supply.use = whatuse Then
               ret = TRUE
            EndIf
         Case clArmor
            If inv.armor.use = whatuse Then
               ret = TRUE
            EndIf
         Case clShield
            If inv.shield.use = whatuse Then
               ret = TRUE
            EndIf
      End Select
   EndIf
   
   Return ret
End Function

'Returns an extended description of an item.
Sub GetFullDesc(lines() As String, inv As invtype)
   Dim As Integer idx = 0
   
   'Reset the array.
   ReDim lines(0 To idx) As String
   'Make sure we have something to inspect.
   If inv.classid <> clNone Then
      'Select the item.
      Select Case inv.classid
         Case clSupplies 
            idx += 1
            ReDim Preserve lines(0 to idx) As String
            lines(idx) = GetInvItemDesc(inv)
            Select Case inv.supply.id
               Case supHealingHerb
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Adds 50% max HP to current HP"
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Magic: Max healing"
               Case supHunkMeat
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Adds 25% max HP to current HP"
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Magic: Bonus to STR stat"
               Case supBread
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Adds 10% max HP to current HP"
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Magic: Cure poison"
               Case supBottleOil
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Fuel for lantern"
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Magic: See all tiles on map"
            End Select
            idx += 1
            ReDim Preserve lines(0 to idx) As String
            If IsEval(inv) = TRUE Then
               lines(idx) = "* Item is evaluated"
            Else
               lines(idx) = "* Item is not evaluated"
            End If
         Case clArmor
            idx += 1
            ReDim Preserve lines(0 to idx) As String
            lines(idx) = GetInvItemDesc(inv)
            Select Case inv.armor.id
               Case armCloth
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* " & (inv.armor.dampct * 100) & "% damage reduction"
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Strength Required: " & inv.armor.struse
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Magic: Defense and Healing"
               Case armLeather
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* " & (inv.armor.dampct * 100) & "% damage reduction"
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Strength Required: " & inv.armor.struse
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Magic: Defense and Healing"
               Case armCuirboli
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "*  " & (inv.armor.dampct * 100) & "% damage reduction"
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Strength Required: " & inv.armor.struse
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Magic: Defense and Healing"
               Case armRing
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* " & (inv.armor.dampct * 100) & "% damage reduction"
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Strength Required: " & inv.armor.struse
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Magic: Defense and Healing"
               Case armBrigantine
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* " & (inv.armor.dampct * 100) & "% damage reduction"
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Strength Required: " & inv.armor.struse
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Magic: Defense and Healing"
               Case armChain
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* " & (inv.armor.dampct * 100) & "% damage reduction"
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Strength Required: " & inv.armor.struse
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Magic: Defense and Healing"
               Case armScale
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* " & (inv.armor.dampct * 100) & "% damage reduction"
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Strength Required: " & inv.armor.struse
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Magic: Defense and Healing"
               Case armPlate
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* " & (inv.armor.dampct * 100) & "% damage reduction"
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Strength Required: " & inv.armor.struse
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Magic: Defense and Healing"
            End Select
            idx += 1
            ReDim Preserve lines(0 to idx) As String
            If IsEval(inv) = TRUE Then
               lines(idx) = "* Item is evaluated"
            Else
               lines(idx) = "* Item is not evaluated"
            End If
         Case clShield
            idx += 1
            ReDim Preserve lines(0 to idx) As String
            lines(idx) = GetInvItemDesc(inv)
            Select Case inv.armor.id
               Case shldLeather
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* " & (inv.shield.dampct * 100) & "% damage reduction"
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Strength Required: " & inv.shield.struse
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Magic: Defense and Healing"
               Case shldCuirboli
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* " & (inv.shield.dampct * 100) & "% damage reduction"
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Strength Required: " & inv.shield.struse
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Magic: Defense and Healing"
               Case shldRing
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* " & (inv.shield.dampct * 100) & "% damage reduction"
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Strength Required: " & inv.shield.struse
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Magic: Defense and Healing"
               Case shldBrigantine
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* " & (inv.shield.dampct * 100) & "% damage reduction"
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Strength Required: " & inv.shield.struse
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Magic: Defense and Healing"
               Case shldChain
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* " & (inv.shield.dampct * 100) & "% damage reduction"
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Strength Required: " & inv.shield.struse
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Magic: Defense and Healing"
               Case shldScale
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* " & (inv.shield.dampct * 100) & "% damage reduction"
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Strength Required: " & inv.shield.struse
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Magic: Defense and Healing"
               Case shldPlate
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* " & (inv.shield.dampct * 100) & "% damage reduction"
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Strength Required: " & inv.shield.struse
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Magic: Defense and Healing"
            End Select
            idx += 1
            ReDim Preserve lines(0 to idx) As String
            If IsEval(inv) = TRUE Then
               lines(idx) = "* Item is evaluated"
            Else
               lines(idx) = "* Item is not evaluated"
            End If
      End Select
   EndIf
   
End Sub

'Returns the inventory slots for wield items.
Function GetInvWSlot(inv As invtype, slotnum As Integer) As Integer
   Dim As Integer ret = wNone
   
   If inv.classid = clArmor Then
      If slotnum >= LBound(inv.armor.wslot) And slotnum <= UBound(inv.armor.wslot) Then 
         ret = inv.armor.wslot(slotnum)
      End If
   ElseIf inv.classid = clShield Then
      If slotnum >= LBound(inv.shield.wslot) And slotnum <= UBound(inv.shield.wslot) Then 
         ret = inv.shield.wslot(slotnum)
      End If
   EndIf
   
   Return ret
End Function
