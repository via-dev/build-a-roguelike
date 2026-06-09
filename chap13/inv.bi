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
   effEffectNone  'No effect.
   effMaxHealing  'Heal to max HP.
   effStrongMeat  'Adds bonus to Str for count time.
   effBreadLife   'Cures any poison.
End Enum

'Item use id.
Enum itemuse
   useNone      'No Use
   useDrinkEat  'Eat or drink item.
   useWieldWear 'Wiels or wear.
End Enum

'Item class ids.
Enum classids
   clNone
   clGold
   clSupplies 
   clPotion
   clWand
   clWeapon
   clArmor
   clAmmo
   clShield
   clScrolls
   clSpellBook
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

'Inventory type.
Type invtype
   classid As classids     'This indicates what class is in the union.
   desc As String * 30     'Plain text description.
   icon As String * 1      'This is the item icon.
   iconclr As UInteger     'This is the item's icon color.
   Union                   'Union of item types.
      gold As goldtype     'Gold coins. 
      supply As supplytype 'Supplies.
   End Union
End Type

'Clears the inventory type instance. 
Sub ClearInv(inv As invtype)
   
   'If classid is None then nothing to do.
   If inv.classid <> clNone Then
      'Clear the gold type.
      If inv.classid = clGold Then
         inv.gold.id = gldGoldNone
         inv.gold.amt = 0
      EndIf
      'Clear the supply type.
      If inv.classid = clSupplies Then
         inv.supply.id = supSupplyNone
         inv.supply.evaldr = 0
         inv.supply.eval = FALSE
         inv.supply.effect = effEffectNone
         inv.supply.sdesc = ""
         inv.supply.noise = 0
      EndIf
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

'Generate new supply item.
Sub GenerateSupplies(inv As invtype, currlevel As Integer)
   Dim item As supplyids = RandomRange(supHealingHerb, supBread) 
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
         inv.supply.use = useDrinkEat
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
         inv.supply.use = useDrinkEat
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
         inv.supply.use = useDrinkEat
         'Set the magic properties.
         If isMagic = TRUE Then
            inv.supply.evaldr = RandomRange(currlevel, currlevel * 2)
            inv.supply.effect = effBreadLife
            inv.supply.sdesc = "Bread of Cure Poison"
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
   Dim iclass As classids = RandomRange(clGold, clSupplies)
   
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
   End Select
   
End Sub

'Returns True if item has been evaluated.
Function IsEval(inv As invtype) As Integer
   Dim As Integer ret
   
   'If nothing then mark as evaluated.
   If inv.classid = clNone Then
      ret = TRUE
   Else
      'Selecvt the item type.
      Select Case inv.classid 'Don't need to eval gold.
         Case clGold
            ret = TRUE
         Case clSupplies  'Return supply eval glag.
            ret = inv.supply.eval
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
      End Select
   EndIf
End Sub
