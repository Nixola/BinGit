#!/usr/bin/lua
local f = io.open('/tmp/music.shuffle', 'r')
if f then
	f:close()
	os.execute 'rm /tmp/music.shuffle'
else
	local f = io.open('/tmp/music.shuffle', 'w')
	f:write ' '
	f:close()
end