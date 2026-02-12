--[[pod_format="raw",created="2026-02-09 19:45:40",modified="2026-02-12 21:41:24",revision=180,xstickers={}]]
local gui={
	channels=include("gui/channels.lua"),
	channelFeed=include("gui/channelFeed.lua")
}

gui.channelFeed:init(420,230)
gui.channels:init(60,270,gui.channelFeed,discord)

local kgui=create_gui{}
messagebox=kgui:attach_text_editor{
	x=60,y=230,
	width=420,height=40,
	bgcol=5,
	fgcol=7,
	update=function(self)
		if (stat(305)) then
			local t=tableToString(messagebox:get_text())
			t=t:gsub("%Â%£","\127")
			messagebox:set_text(t)
		end
	end,
	key_callback={
		enter=function(self)
			discord:post(activeChannel,self:get_text())
			self:set_text("")
		end
	}
}

gui.update_all=function(self)
	self.channels:update(curs.x,curs.y)
	self.channelFeed:update(curs.x+60,curs.y)
	kgui:update_all()
end

gui.refresh=function(self,object)
	if (object=="channels") self.channels.ud=nil
	if (object=="channelFeed") self.channelFeed.ud=ni
end

gui.draw_all=function(self,x,y)
	x=x or 0
	y=y or 0
	self.channels:draw(x,y)
	self.channelFeed:draw(x+60,y)
	kgui:draw_all()
end

return gui

--[[
messages=gui:attach{
	x=60,y=0,
	width=420,height=230,
	draw=function(self)
		rectfill(0,0,self.width-1,self.height-1,0)
		local messages={}
		if (channels[activeChannel]) then
			messages=channels[activeChannel].messages
		end
		local x,y=0,0
		local _
		local lastauthor=""
		for i=1, #messages do
			if (lastauthor!=messages[i].authorid) then
				if (y!=0) y+=15
				local label=messages[i].author
				spr(messages[i].icon,x,y)
				if (messages[i].bot) label..=" [bot]"
				label..=" \014"..messages[i].timestamp
				_,y=print(label,x+36,y,7)
				lastauthor=messages[i].authorid
			end
			_,y=print(messages[i].content,x+36,y,6)
			if (y>self.height) return
		end
	end
}

messagebox=gui:attach_text_editor{
	x=60,y=230,
	width=420,height=40,
	bgcol=5,
	fgcol=7,
	update=function(self)
		if (stat(305)) then
			local t=tableToString(messagebox:get_text())
			t=t:gsub("%Â%£","\127")
			messagebox:set_text(t)
		end
	end,
	key_callback={
		enter=function(self)
			discord:post(activeChannel,self:get_text())
			self:set_text("")
		end
	}
}]]