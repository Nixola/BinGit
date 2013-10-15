local f = io.open('/tmp/music.running', 'r')
local str
if not f then
	str = '"Please open the player before checking."'
else
	local v = f:read '*a'
	str = '"Now playing:" "'..v..'"'
end
os.execute('notify-send -t 1000 '..str)