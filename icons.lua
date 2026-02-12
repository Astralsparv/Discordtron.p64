--[[pod_format="raw",created="2026-02-11 19:04:00",modified="2026-02-12 21:31:21",revision=13,xstickers={}]]
local cachedIcons={}

function getIcon(url)
	if (cachedIcons[url]) return cachedIcons[url]
	local q=url:find("?")
	if (q) then
		url=url:sub(1,q-1)
	end
	local img=fetch(url)
	if (not img) then
		cachedIcons[url]=get_spr(64)
	else
		local ud=userdata("u8",32,32)
		set_draw_target(ud)
		cls(32)
		sspr(img,0,0,img:width(),img:height(),0,0,32,32)
		set_draw_target()
		cachedIcons[url]=ud
	end
	return cachedIcons[url]
end