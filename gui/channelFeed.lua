--[[pod_format="raw",created="2026-02-12 18:55:38",modified="2026-02-12 21:40:02",revision=225,xstickers={}]]
--
-- Channel Feed
-- GUI Object
--

local channelFeed={
	width=0,height=0,
	objectLocations={},
	processedChannel=-1,
}

channelFeed.init=function(self,w,h)
	self.width=w
	self.height=h
end

channelFeed.update=function(self,cx,cy)
	
end

local function generateStructure(messages)
	local structure={}
	local lastauthor=""
	local lh=0
	for i=1, #messages do
		local msg=messages[i]
		local built={
			msg=msg,
			index=i,
			authorVisible=(lastauthor!=msg.authorid)
		}
		local h=0
		if (built.authorVisible) then
			h+=12
			if (i+1<=#messages) then
				if (messages[i+1].authorid!=msg.authorid) then
					h+=20
				end
			end
			lastauthor=msg.authorid
		end
		
		local _,contentHeight=stringProportions(msg.content)
		h+=contentHeight
		built.height=h
		add(structure,built)
	end
	return structure
end

channelFeed.draw=function(self,x,y)
	if (false and self.ud and (self.processedChannel==activeChannel)) then
		spr(self.ud,x,y)
	else
		self.processedChannel=activeChannel
		self.ud=userdata("u8",self.width,self.height)
		local messages={}
		if (channelData[activeChannel]) then
			messages=channelData[activeChannel].messages
		end
		local structure=generateStructure(messages)
		local trg=get_draw_target()
		set_draw_target(self.ud)
		cls(0)
		local xx,yy=0,self.height
		local _
		for i=#structure, 1, -1 do
			local block=structure[i]
			local msg=block.msg
			yy-=block.height
			local dy=yy
			if (yy<0) then
				--no longer visible
				--also shorten msgs for memory & performance
--				deli(messages,block.index)
				break
			end
			if (block.authorVisible) then
				spr(msg.icon,xx,dy)
				local label=msg.author
				if (msg.bot) label..=" [bot]"
				label..=" \014"..msg.timestamp
				_,dy=print(label,xx+36,dy,7)
			end
			print(msg.content,xx+36,dy,6)
		end
		set_draw_target()
		spr(self.ud,x,y)
	end
end

return channelFeed