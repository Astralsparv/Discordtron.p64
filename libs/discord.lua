--[[pod_format="raw",created="2026-02-09 19:12:47",modified="2026-02-12 19:39:33",revision=77,xstickers={}]]
local discord={}

tcp,vers=include("libs/tcp.lua")
printh("Running AstralTCP version "..vers)

local connected=false
local attempts=5
for i=1, attempts do
	local success=tcp:client("localhost",4443)
	if (success) then
		printh("Connected!")
		connected=true
		break
	else
		printh("Failed to connect.")
		printh("Attempt: "..i.."/"..attempts)
		for j=1, 5 do flip() end
	end
end
if (not connected) printh("Exiting.") exit()
connected=nil

discord.update=function()
	local msgs,newpeer = tcp:receive()
	local ret={}
	for m in all(msgs) do
		add(ret,unpod(m.message))
	end
	return ret
end

discord.post=function(self,channel,m)
	local message=tableToString(m,true)
	tcp:write("sendmessage;channel:"..channel..";message;"..message)
end

discord.queryChannels=function(self,guild)
	tcp:write("querychannels;"..guild)
end

discord.queryChannelFeed=function(self,id)
	tcp:write("querymessages;"..id)
end

return discord