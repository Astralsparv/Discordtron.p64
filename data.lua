--[[pod_format="raw",created="2026-02-11 18:53:25",modified="2026-02-11 18:54:32",revision=5,xstickers={}]]
mkdir("/appdata/discord/")
local data=fetch("/appdata/discord/data.pod") or {
	botid=-1
}
store("/appdata/discord/data.pod",botid)