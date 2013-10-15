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

function shuffled(tab)
	local n, order, res = #tab, {}, {}
	 
	for i=1,n do order[i] = { rnd = math.random(), idx = i } end
	table.sort(order, function(a,b) return a.rnd < b.rnd end)
	for i=1,n do res[i] = tab[order[i].idx] end
	return res
end

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

t = shuffled(t)

for i, v in ipairs(t) do

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
	print(str, album, author, title)
	os.execute(str)
	os.execute(string.format('mpg123 "%s"', v))

end