--[[pod_format="raw",created="2026-02-12 21:47:17",modified="2026-02-12 21:47:33",revision=1,xstickers={}]]
import asyncio
import discord,json
import discord.ext
from discord import app_commands
import tcp
import p8scii

intents=discord.Intents.default()
intents.message_content = True
intents.members = True
client=discord.Client(intents=intents)

@client.event
async def on_ready():
    print("setting up")
    print(f'Logged in as {client.user}')

@client.event
async def on_message(message):
#    if message.author == client.user:
#        return
    tcp.receiveMessage(message)

async def send_discord_message(channel_id, content):
    channel=client.get_channel(int(channel_id))
    if channel:
        await channel.send(content)

async def fetch_last_messages(channel_id):
    channel=client.get_channel(int(channel_id))

    if not channel:
        print(f"Channel {channel_id} requested but not found")
        return

    messages=[]
    async for message in channel.history(limit=16):
        messages.append({
            "channelid": f"{message.channel.id}",
            "channelname": message.channel.name,
            "author": message.author.display_name,
            "authorid": f"{message.author.id}",
            "messageid": f"{message.id}",
            "content": message.content,
            "bot": message.author.bot,
            "icon": message.author.display_avatar.url,
            "timestamp": str(message.created_at)
        })
    messages.reverse()
    tcp.sendChannelFeed(channel_id, messages)

def process_req(cmd):
    # sendmessage;channel:1234567890;message;Hello world
    print(cmd)
    if cmd.startswith("sendmessage;"):
        try:
            _,rest=cmd.split(";",1)

            channel_part,message_content=rest.split(";message;", 1)

            channel_id=channel_part.split(":")[1]
            
            message_content=p8scii.correct(message_content)
            
            asyncio.run_coroutine_threadsafe(
                send_discord_message(channel_id, message_content),
                client.loop
            )
        except Exception as e:
            print("Failed to process request:", e)
    if cmd.startswith("querychannels;"):
        print("Channels queried.")
        try:
            _,serverid=cmd.split(";",1)
            guild=client.get_guild(int(serverid))
            if (not guild):
                print(f"Guild with id {serverid} was requested but can't be found.")
                return
            
            channel_data=[]
            for channel in guild.channels:
                channel_data.append({
                    "id": str(channel.id)
                    ,
                    "label": channel.name,
                    "type": str(channel.type)
                })
            tcp.sendChannelData(guild,channel_data)
        except Exception as e:
            print("Failed to process request:", e)
    if cmd.startswith("querymessages;"):
        print("Messages queried.")
        try:
            _,channelid=cmd.split(";",1)
            asyncio.run_coroutine_threadsafe(
                fetch_last_messages(channelid),
                client.loop
            )
        except Exception as e:
            print("Failed to process request:", e)
tcp.set_process_req(process_req)

print("Running client")
client.run('BOT_TOKEN_HERE")
