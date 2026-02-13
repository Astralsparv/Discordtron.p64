--[[pod_format="raw",created="2026-02-12 21:11:36",modified="2026-02-13 19:44:00",revision=2,xstickers={}]]
--abledbody's modified function

--Returns text wrapped (with \n)
--@param text The string to wrap
--@param width The width allotted for wrapping
--@param offset for the first line, default 0
--@return string The wrapped string
function wrapText(text,width,offset)
	local ooffset=offset or 0
	local leading=text:match("^[ \t]*") or ""
	local str=""
	local line=text:match("^%s*")
	offset=offset or 0
	local x=stringProportions(line)
	text=text:sub(#line+1)
	for word, whitespace in text:gmatch("(%S+)(%s*)") do
		-- If a word goes over the edge of the window, put it on the next line.
		local w=stringProportions(word)
		if (x+w+offset>width) then
			-- In this case, we definitely have a space before this we don't want to count.
			str..=line.."\n"
			line,x=word,w
			offset=0
		else
			x+=w
			line..=word
		end
		
		-- If a space goes over the edge of the window, just start a new line.
		local space=whitespace:gsub("\n","")
		local spaceWidth=stringProportions(space)
		local nls = whitespace:match("\n") and #whitespace:gsub("[^\n]", "") or 0
		
		if (x+spaceWidth+offset>width) then
			str..=line.."\n"
			line,x="",0
			offset=0
		else
			x+=spaceWidth
			line..=space
		end
		
		if (nls>0) then
			str..=line..string.rep("\n",nls)
			line,x="",0
			offset=0
		end
	end
	
	if (line!="") then
		str..=line
	end
	
--	local removed = max(0, #self.lines - self.max_history)
--	for _ = 1, #self.lines - self.max_history do
--		remove(self.lines, 1)
--	end
--	printh(str)

	--returns the string & the width of the final line (x that is taken up)
	return leading..str,offset+x
end