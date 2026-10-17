-- Double-Click Poison Guard
-- Double-clicking an item in the player inventory runs a "contextual" action
-- (ISInventoryPane:doContextualDblClick): eat food, drink fluids, take pills...
-- Vanilla only looks at the primary fluid of a container and only skips
-- tainted water when FluidContainer:isTaintedStatusKnown() says so, which is
-- false for every mix when the sandbox option EnableTaintedWaterText is off.
-- A water bottle with some bleach mixed in (bleach blends with Beverage
-- fluids, scripts/generated/fluids.txt) still has Water as its primary fluid,
-- so a double-click drinks it, even though the inventory shows a poison icon.
--
-- This wraps doContextualDblClick and refuses the double-click when the item
-- is harmful *and the player can tell*. It never blocks on hidden info
-- (unknown poisonous berries / mushrooms, tainted water without the tainted
-- text option), so a blocked double-click reveals nothing new.
-- The right-click menu is untouched, so you can still consume it on purpose.
--
-- Harmful and visible =
--   Food:  known poison (isKnownPoison), tainted with EnableTaintedWaterText
--          on (vanilla poison icon rule), rotten, dangerous uncooked and not
--          cooked
--   Fluid: any poisonous fluid other than tainted water in the mix (bleach,
--          petrol, cleaning liquid, perfume, dye, acid...: named in the fluid
--          tooltip), or isTaintedStatusKnown()

require "ISUI/ISInventoryPane"

DoubleClickPoisonGuard = DoubleClickPoisonGuard or {}

local function isTaintedTextEnabled()
    return getSandboxOptions():getOptionByName("EnableTaintedWaterText"):getValue()
end

-- Poisonous fluids the player sees by name. Tainted water looks like water
-- unless the sandbox option says otherwise, so it is handled separately.
local visiblePoisonFluids = nil

local function getVisiblePoisonFluids()
    if not visiblePoisonFluids then
        visiblePoisonFluids = {}
        local all = Fluid.getAllFluids()
        for i = 0, all:size() - 1 do
            local fluid = all:get(i)
            if fluid:isPoisonous() and fluid ~= Fluid.TaintedWater then
                table.insert(visiblePoisonFluids, fluid)
            end
        end
    end
    return visiblePoisonFluids
end

local function isHarmfulFluid(fluidContainer)
    if not fluidContainer or fluidContainer:isEmpty() then
        return false
    end
    if fluidContainer:isTaintedStatusKnown() then
        return true
    end
    for _, fluid in ipairs(getVisiblePoisonFluids()) do
        if fluidContainer:contains(fluid) then
            return true
        end
    end
    return false
end

function DoubleClickPoisonGuard.isHarmful(playerObj, item)
    if instanceof(item, "Food") then
        if playerObj:isKnownPoison(item) then return true end
        if item:isTainted() and isTaintedTextEnabled() then return true end
        if item:isRotten() then return true end
        if item:isbDangerousUncooked() and not item:isCooked() then return true end
    end
    return isHarmfulFluid(item:getFluidContainer())
end

local original_doContextualDblClick = ISInventoryPane.doContextualDblClick

function ISInventoryPane:doContextualDblClick(item)
    local playerObj = getSpecificPlayer(self.player)
    if item and playerObj and DoubleClickPoisonGuard.isHarmful(playerObj, item) then
        HaloTextHelper.addBadText(playerObj, getText("IGUI_DoubleClickPoisonGuard_Blocked", item:getDisplayName()))
        return
    end
    return original_doContextualDblClick(self, item)
end
