--[[pod_format="raw",created="2026-02-11 18:18:11",modified="2026-02-12 21:16:18",revision=39,xstickers={}]]
function tableToString(m,unconvertspecialchar)
	local s=""
	if (type(m)=="table") then
		for i=1, #m do
			if (unconvertspecialchar) then
				for j=1, #m[i] do
					if (ord(m[i][j])>=127) then
						s..="\\"..ord(m[i][j])
					else
						if (m[i][j]=="\\") then
							s..="\\092"
						else
							s..=m[i][j]
						end
					end
				end
			else
				s..=m[i]
			end
			if (i!=#m) s..="^\\//n"
		end
	else
		s=m
	end
	return s
end

local bufferUD=userdata("u8",1,1)
function stringProportions(string)
	local trg=get_draw_target()
	set_draw_target(bufferUD)
	local w,h=print(string,0,0)
	set_draw_target(trg)
	return w,h
end