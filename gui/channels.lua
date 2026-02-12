--[[pod_format="raw",created="2026-02-12 18:33:53",modified="2026-02-12 21:13:34",revision=123,xstickers={}]]
--
-- Channel navbar
-- GUI Object
--

local channels={
	width=0,height=0,
	objectLocations={},
	refreshCallback=function() end
}

channels.init=function(self,w,h,channelFeed,discord)
	self.width=w
	self.height=h
	self.channelFeed=channelFeed
	self.discord=discord
end

channels.update=function(self,cx,cy)
	for i=1, #self.objectLocations do
		local v=self.objectLocations[i]
		if (cx>=v.x1 and cx<=v.x2 and
			cy>=v.y1 and cy<=v.y2) then
			window{cursor="pointer"}
			if (curs.b&0x1==0x1 and curs.lb==0) then
				activeChannel=tostr(v.id)
				self.discord:queryChannelFeed(v.id)
				self.ud=nil
			end
		end
	end
end

channels.draw=function(self,x,y)
	if (false and self.ud) then
		spr(self.ud,x,y)
	else
		self.ud=userdata("u8",self.width,self.height)
		local trg=get_draw_target()
		set_draw_target(self.ud)
		cls(5)
		local xx,yy=0,0
		local x2=0
		self.objectLocations={}
		for k,v in pairs(channelData) do
			if (v.information.type=="text") then
				local o={x1=xx,y1=yy}
				local c=6
				if (activeChannel==tostr(k)) c=7
				x2,yy=print(v.information.label,xx,yy,c)
				o.x2=x2
				o.y2=yy
				o.id=v.information.id
				add(self.objectLocations,o)
			end
		end
		set_draw_target(trg)
		spr(self.ud,x,y)
	end
end

return channels