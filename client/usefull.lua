screen = Vector2(guiGetScreenSize());
middle = Vector2(screen.x / 2, screen.y / 2);
screenScale = math.min(math.max(screen.y / SCREEN_HEIGHT_BASE, 0.8), 1.2);

function respc(value)
    return value * screenScale
end

_dxDrawText = dxDrawText
function dxDrawText(text, x, y, w, h, ...)
    return _dxDrawText(text, x, y, w + x, h + y, ...)
end

-- optimized vector (no create instance)
function Vector(x, y, z)
    return {x = x, y = y, z = z}
end

-- # https://wiki.multitheftauto.com/wiki/IsMouseInPosition (28/10/23)
function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

-- // font's manager
local fonts = {};
function getFont(font, size, bold, quality)
    size = size or 10;
    bold = bold or false;
    quality = quality or "proof";

    if not fonts[font] then
        fonts[font] = {};
    end
    if not fonts[font][size] then
        fonts[font][size] = {};
    end
    if not fonts[font][size][quality] then
        fonts[font][size][quality] = dxCreateFont("assets/" .. font, respc(size * 0.75), bold, quality);
    end
    return fonts[font][size][quality]
end