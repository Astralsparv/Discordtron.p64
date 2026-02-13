--[[pod_format="raw",created="2026-02-12 18:55:38",modified="2026-02-13 20:16:03",revision=262,xstickers={}]]
--
-- Channel Feed
-- GUI Object
--

local channelFeed={
	width=0,height=0,
	objectLocations={},
	processedChannel=-1,
	scroll=0,
	maxScroll=0,
	pscroll=0
}

channelFeed.init=function(self,w,h)
	self.width=w
	self.height=h
end

channelFeed.update=function(self,cx,cy)
	self.scroll-=curs.wy*8
	self.scroll=mid(0,self.scroll,-self.maxScroll)
end

local function generateStructure(messages)
	local structure={}
	local lastauthor=""
	local th=0
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
		th+=h
		add(structure,built)
	end
	return structure,th
end

channelFeed.draw=function(self,x,y)
	if (self.regenerateNeeded!=true and self.ud and (self.processedChannel==activeChannel) and (self.pscroll==self.scroll)) then
		spr(self.ud,x,y)
	else
		self.regenerateNeeded=nil
		self.pscroll=self.scroll
		self.processedChannel=activeChannel
		self.ud=userdata("u8",self.width,self.height)
		local messages={}
		if (channelData[activeChannel]) then
			messages=channelData[activeChannel].messages
		end
		local structure,mh=generateStructure(messages)
		self.maxScroll=mh
		local trg=get_draw_target()
		set_draw_target(self.ud)
		cls(0)
		local xx,yy=0,self.height-self.scroll
		local _
		for i=#structure, 1, -1 do
			local block=structure[i]
			local msg=block.msg
			yy-=block.height
			local dy=yy
			if (dy<=self.height) then
				if (yy<-25) then
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
		end
		set_draw_target()
		spr(self.ud,x,y)
	end
end

return channelFeed