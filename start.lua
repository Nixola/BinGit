#!/usr/bin/lua
local f = io.open("/tmp/music.running", 'r')
if f then
	os.execute("rm /tmp/music.running")
	os.execute "next"
	return
else
	f = io.open("/tmp/music.running", 'w')
	f:write ' '
	f:close()
end

math.randomseed(os.time())
math.random();math.random();math.random();math.random();math.random();

local f = io.popen "find -L ~/Music -type f -name \*.mp3"
t = {}

while true do
	local v = f:read '*l'
	if v then
		table.insert(t, v)
	else
		break
	end
end

f:close()

i = 0
while true do

	local rnd = io.open('/tmp/music.shuffle', 'r')
	if rnd then
		i = math.random(#t)
	else
		i = i%(#t+1)+1
	end

--	print(i)

	local v = t[i]

	local f = io.open("/tmp/music.running", 'r')
	if not f then break end

	local Falbum = io.popen('id3v2 -R "'..v..'" | grep TALB')
	local Fauthor = io.popen('id3v2 -R "'..v..'" | grep TPE1')
	local Ftitle = io.popen('id3v2 -R "'..v..'" | grep TIT2')

	local album = (Falbum:read '*a'):sub(7, -1)
	local author = (Fauthor:read '*a'):sub(7, -1)
	local title = (Ftitle:read '*a'):sub(7, -1)

	Falbum:close()
	Fauthor:close()
	Ftitle:close()

	local str = string.format('notify-send -t 1000 "Now playing:" "\n%s\n%s\n%s"',title, author, album)
	os.execute(str)
	os.execute(string.format('mpg123 "%s"', v))

end