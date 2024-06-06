local com = require("component")
local event = require("event")

function registerToggleableComponentHandler(componentTypeName, componentKey)
  local tunnel = nil

  if com.isAvailable("tunnel") then
    print("Registering " .. componentTypeName .. " handler")

    tunnel = com.tunnel

    local function onMessage(...)
      local msg = {...}
      if not com.isAvailable(componentTypeName) then
        tunnel.send(componentKey .. "_UNAVAILABLE")
        return
      end
      local component = com[componentTypeName]
      msg = msg[6]
      if msg == "TOGGLE_" .. componentKey then
        if component.enable(not component.enable()) then
          tunnel.send(componentKey .. "_ENABLED")
        else
          tunnel.send(componentKey .. "_DISABLED")
        end
      elseif msg == "GET_STATE" then
        if component.enable() then
          tunnel.send(componentKey .. "_ENABLED")
        else
          tunnel.send(componentKey .. "_DISABLED")
        end
      end
    end

    event.listen("modem_message", onMessage)
  else
    print("Tunnel not found!")
  end
end
