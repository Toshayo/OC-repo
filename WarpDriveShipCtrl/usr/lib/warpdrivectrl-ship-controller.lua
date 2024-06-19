local com = require("component")
local event = require("event")

local componentKey = "SHIPCTRL"
local componentTypeName = "warpdriveShipController"


function registerShipControllerHandler()
  local tunnel = nil

  if com.isAvailable("tunnel") then
    print("Registering Ship Controller handler")

    tunnel = com.tunnel

    local function onMessage(...)
      local msg = {...}
      if not com.isAvailable(componentTypeName) then
        tunnel.send(componentKey .. "_UNAVAILABLE")
        return
      end
      local component = com[componentTypeName]
      local command = msg[6]
      if command == componentKey .. "_TELEPORT" then
        component.targetName(msg[7])
        component.command("SUMMON")
        component.enable(true)
      elseif msg == "GET_STATE" then
        tunnel.send(componentKey .. "_PRESENT")
      end
    end

    event.listen("modem_message", onMessage)
  else
    print("Tunnel not found!")
  end
end
