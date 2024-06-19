dofile("/usr/lib/warpdrivectrl-toggleable-component.lua")
dofile("/usr/lib/warpdrivectrl-ship-controller.lua")

function start()
    registerToggleableComponentHandler("warpdriveCloakingCore", "CLOAK")
    registerToggleableComponentHandler("warpdriveLift", "LIFT")
    registerToggleableComponentHandler("warpdriveForceFieldProjector", "SHIELD")
    registerShipControllerHandler()
end
