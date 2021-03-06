#!/usr/bin/lua
local args = {...}
local param = args[1]

if param == 'start' then
	local f = io.open("/tmp/music.running", 'r')
	if f then
		os.execute("rm /tmp/music.running")
		os.execute "next"
		return
	end

	local first = true

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

		local filename = v:match ".+/(.-)%.mp3$"

		local f = io.open("/tmp/music.running", 'r')
		if not f and not first then break end
		first = nil

		local Falbum = io.popen('id3v2 -R "'..v..'" | grep TALB')
		local Fauthor = io.popen('id3v2 -R "'..v..'" | grep TPE1')
		local Ftitle = io.popen('id3v2 -R "'..v..'" | grep TIT2')

		local album = (Falbum:read '*a'):sub(7, -1)
		local author = (Fauthor:read '*a'):sub(7, -1)
		local title = (Ftitle:read '*a'):sub(7, -1)

		local f = io.open("/tmp/music.running", 'w')
		f:write('\n')
		f:write(title ~= '' and title or filename)
		f:write('\n')
		f:write(author)
		f:write('\n')
		f:write(album)
		f:close()

		Falbum:close()
		Fauthor:close()
		Ftitle:close()

		--local str = string.format('notify-send -t 1000 "Now playing:" "\n%s\n%s\n%s"',title, author, album)
		--os.execute(str)
		os.execute 'check.lua'
		os.execute(string.format('mpg123 "%s"', v))

	end
elseif param == 'next' then
	os.execute 'killall -s SIGINT mpg123'
elseif param == 'shuffle' then
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
elseif param == 'check' then
	local f = io.open('/tmp/music.running', 'r')
	local str
	if not f then
		str = '"Please open the player before checking."'
	else
		local v = f:read '*a'
		str = '"Now playing:" "'..v..'"'
	end
	os.execute('notify-send --expire-time 3500 '..str)
end