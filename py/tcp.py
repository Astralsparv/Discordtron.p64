import socket
import threading
import p8scii
import pod

process_req=None

def set_process_req(callback):
    global process_req
    process_req=callback

s=socket.socket(socket.AF_INET, socket.SOCK_STREAM)

host="127.0.0.1"
port=4443

s.bind((host, port))
s.listen(5)
print("Discord Server started, awaiting connections.")

clients=[]

def handle_client(c, addr):
    print(f"Client connected from {addr}")
    buffer=""
    while True:
        try:
            data=c.recv(1024)
            if data:
                buffer+=data.decode("utf-8")
                while "\n" in buffer:
                    line,buffer=buffer.split("\n", 1)
                    process_req(line.strip())
            else:
                continue
        except Exception as e:
            print(f"Error with client {addr}: {e}")
            break
    print(f"Client {addr} disconnected")
    clients.remove(c)
    c.close()

def sendTCPMessage(message):
    for c in clients:
        try:
            c.sendall((message + "\n").encode("utf-8"))
        except:
            clients.remove(c)

def receiveMessage(message):
    data=pod.pod({
        "event":"message",
        "channelid":f"{message.channel.id}",
        "channelname":message.channel.name,
        "author":message.author.display_name,
        "authorid":f"{message.author.id}",
        "messageid":f"{message.id}",
        "content":message.content,
        "bot":message.author.bot,
        "icon":message.author.display_avatar.url,
        "timestamp":message.created_at
    })
    sendTCPMessage(data)

def sendChannelData(guild,channels):
    data=pod.pod({
      "event": "guild_channels",
      "guildid": str(guild.id),
      "channels": channels
    })
    sendTCPMessage(data)

def sendChannelFeed(channelId,messages):
    data=pod.pod({
      "event": "channel_feed",
      "id": str(channelId),
      "messages": messages
    })
    sendTCPMessage(data)

def accept_clients():
    while True:
        c, addr = s.accept()
        clients.append(c)
        threading.Thread(target=handle_client, args=(c, addr), daemon=True).start()

threading.Thread(target=accept_clients, daemon=True).start()