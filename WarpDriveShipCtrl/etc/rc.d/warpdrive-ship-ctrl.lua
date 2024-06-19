dofile("/usr/lib/warpdrivectrl-toggleable-component.lua")

function start()
    registerToggleableComponentHandler("warpdriveCloakingCore", "CLOAK")
    registerToggleableComponentHandler("warpdriveLift", "LIFT")
    registerToggleableComponentHandler("warpdriveForceFieldProjector", "SHIELD")
end
