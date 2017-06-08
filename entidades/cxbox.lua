local title = "Participantes:"
local message = "Witna, Ster"
local buttons = {"OK", "No!", "Help", escapebutton = 2}

local pressedbutton = love.window.showMessageBox(title, message, buttons)
if pressedbutton == 1 then
    -- "OK" was pressed
elseif pressedbutton == 2 then
    -- etc.
end
