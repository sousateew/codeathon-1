local Panel = {};

Panel.size = Vector(respc(525), respc(767));
Panel.position = Vector(middle.x - Panel.size.x / 2, middle.y - Panel.size.y / 2);

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        addEventHandler("onClientRender", root, Panel.draw)
        addEventHandler("onClientClick", root, Panel.click)

        showCursor(true)
    end
)

addEvent("onClientReceiveCodeathonData", true)
addEventHandler("onClientReceiveCodeathonData", root, 
    function(data)
        Panel.users = data;
    end
)

local function formatUserInfo(data)
    local result = "";
    
    for index, value in pairs(data) do
        result = result .. index .. ": " .. value .. "\n";
    end

    return result
end

function Panel.draw()
    -- // Fast variables
    local pos = Panel.position;
    local size = Panel.size;

    -- // Draw main
    dxDrawRectangle(pos.x, pos.y, size.x, size.y, tocolor(28, 28, 28), false)
    dxDrawText("Usuários", pos.x, pos.y + respc(34), size.x, respc(32), tocolor(255, 255, 255), 1, getFont("medium.ttf", 25), "center", "center")

    -- // Draw users
    if (not Panel.users) then
        dxDrawText("Waiting Mockoon...", pos.x, pos.y, size.x, size.y, tocolor(255, 255, 255), 1, getFont("medium.ttf", 20), "center", "center")
        return false;
    end

    local count = 0;
    local row, column = 0, 0;
    for index, data in ipairs(Panel.users) do
        local pos = Vector(pos.x + respc(15 + 250 * row), pos.y + respc(105 + 42 * column));
        local hovering = isMouseInPosition(pos.x, pos.y, respc(246), respc(38));

        dxDrawRectangle(pos.x, pos.y, respc(246), respc(38), tocolor(255, 255, 255, 255 * (hovering and 0.05 or 0.02)), false)
        dxDrawText(data.name, pos.x + respc(29), pos.y, respc(217), respc(38), tocolor(255, 255, 255), 1, getFont("regular.ttf", 14), "left", "center")
        
        dxDrawRectangle(pos.x + respc(10), pos.y + respc(14), respc(10), respc(10), data.isActive and tocolor(141, 227, 74) or tocolor(227, 74, 74), false)

        row = row + 1;
        if (row == 2) then
            row = 0;
            column = column + 1;
        end
    end

    -- // Draw selected user infos
    if (Panel.selected) then
        local user = Panel.selected;

        -- // Draw main
        dxDrawRectangle(pos.x, pos.y, size.x, size.y, tocolor(28, 28, 28, 255 * 0.90), false)
        
        -- // Draw name
        dxDrawText(user.name .. "\n#" .. user.id, pos.x, pos.y + respc(59), size.x, respc(29), tocolor(255, 255, 255), 1, getFont("medium.ttf", 25), "center", "center")
        
        -- // Draw infos
        dxDrawText(user.info, pos.x + respc(50), pos.y + respc(131), respc(409), respc(105), tocolor(255, 255, 255), 1, getFont("regular.ttf", 20), "left", "top", false, true, true)
    end
end

function Panel.click(button, state)
    -- // Fast variables
    local pos = Panel.position;
    local size = Panel.size;

    if (button == "left" and state == "down") then
        -- // Cancel selected user
        if (Panel.selected and isMouseInPosition(pos.x, pos.y, size.x, size.y)) then
            Panel.selected = false;
            return true;
        end

        -- // Select user
        if (not Panel.users) then
            return false;
        end

        local count = 0;
        local row, column = 0, 0;
        for index, data in ipairs(Panel.users) do
            local pos = Vector(pos.x + respc(15 + 250 * row), pos.y + respc(105 + 42 * column));
            if isMouseInPosition(pos.x, pos.y, respc(246), respc(38)) then
                Panel.selected = data;
                
                Panel.selected.info = formatUserInfo({
                    ["E-mail"] = data.email,
                    ["Telefone"] = data.phone,
                    ["Endereço"] = data.address,
                    ["Aniversário"] = data.birthdate,
                });

                return true    
            end

            row = row + 1;
            if (row == 2) then
                row = 0;
                column = column + 1;
            end
        end
    end
end