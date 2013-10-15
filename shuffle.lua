#!/usr/bin/lua
local t = {}

function shuffled(tab)
	local n, order, res = #tab, {}, {}
	 
	for i=1,n do order[i] = { rnd = math.random(), idx = i } end
	table.sort(order, function(a,b) return a.rnd < b.rnd end)
	for i=1,n do res[i] = tab[order[i].idx] end
	return res
end

while true do
	local l = io.read '*l'
	if l then
		table.insert(t,l)
	else
		break
	end
end

t = shuffled(t)

--print(table.concat(t, '\n'))

for i, v in ipairs(t) do

	print('"'..v..'"')

end