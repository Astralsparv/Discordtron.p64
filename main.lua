--[[pod_format="raw",created="2026-02-09 19:00:46",modified="2026-02-13 20:15:59",revision=227,xstickers={}]]
include("functs.lua")
include("data.lua")

fetch("fonts/thin.font"):poke(0x4000)

include("wrap.lua")
include("manager.lua")
discord=include("libs/discord.lua")
gui=include("gui.lua")
include("icons.lua")
window{pauseable=false}

function _init()
	discord:queryChannels(activeGuild)
end

curs={
	x=0,y=0,b=0,lb=0,wx=0,wy=0
}

local messagesToProcess={}

function _update()
	window{cursor=1}
	local mx,my,mb,wx,wy=mouse()
	curs.lb=curs.b
	curs.x,curs.y,curs.b,curs.wx,curs.wy=mx,my,mb,wx,wy
	local dat=discord:update()
	for i=1, #dat do
		local d=dat[i]
		if (d.event=="message") then
			if (not channelData[d.channelid]) then
				channelData[d.channelid]={
					information={
						id=d.channelid,
						label=d.channelname
					},
					messages={}
				}
			end
			add(messagesToProcess,d)
		elseif (d.event=="guild_channels") then
			if (d.guildid==activeGuild) then
				for i=1, #d.channels do
					local id=d.channels[i].id
					if (not channelData[id]) then
						channelData[id]={
							information={
								id=id,
								label=d.channels[i].label,
								type=d.channels[i].type
							},
							messages={}
						}
					end
				end
				gui:refresh("channels")
			end
		elseif (d.event=="channel_feed") then
			if (channelData[d.id]) then
				channelData[d.id].messages={}
				for i=1, #d.messages do
					local v=d.messages[i]
					v.channelid=d.id
					add(messagesToProcess,v)
				end
				gui:refresh("channelFeed")
			end
		end
	end
	gui:update_all()
	
	if (#messagesToProcess>0) then
		local d=messagesToProcess[1]
		add(channelData[d.channelid].messages,{
			author=d.author,
			authorid=d.authorid,
			content=d.content,
			messageid=d.messageid,
			bot=d.bot,
			icon=getIcon(d.icon),
			timestamp=tostr(date("%Y-%m-%d %H:%M:%S", d.timestamp)) or "??-??-???? ??:??:??"
		})
		gui:refresh("channelFeed")
		deli(messagesToProcess,1)
	end
end

function _draw()
	cls()
	gui:draw_all()
--	notify(flr(stat(1)*10000)/100 .."%")
end