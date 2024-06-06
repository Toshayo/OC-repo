dofile("../../usr/lib/WarpDriveShipCtrl/toggleable-component.lua")

function start()
   registerToggleableComponentHandler("warpdriveCloakingCore", "CLOAK")
    registerToggleableComponentHandler("warpdriveLift", "LIFT")
end
