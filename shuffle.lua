#!/usr/bin/lua
local f = io.open('/tmp/music.shuffle', 'r')
if f then
	f:close()
	os.execute 'rm /tmp/music.shuffle'
	os.execute 'notify-send -t 1500 "Shuffling off"'
else
	local f = io.open('/tmp/music.shuffle', 'w')
	f:write ' '
	f:close()
	os.execute 'notify-send -t 1500 "Shuffling on"'
end