function _MathIsValueInTable(t, v)
	for i, n in pairs(t) do
		if n == v then
			return true
		end
	end
	return false
end



function _MathWeightedRandom(weights)
	local t = 0
	for i, w in ipairs(weights) do
		t = t + w
	end
	local rnd = math.random(t) -- from 1 to t, inclusive, integer!!
	local i = 1
	while rnd > weights[i] do
		rnd = rnd - weights[i]
		i = i + 1
	end
	return i
end



function _MathAreKeysInTable(tbl, ...)
    for _, v in pairs({ ... }) do
        tbl = tbl[v]
        if type(tbl) ~= "table" then
            return tbl
        end
    end
    return tbl
end



function _MathRound(value)
	return value % 1 >= 0.5 and math.ceil(value) or math.floor(value)
end



function _MathRoundUp(value, roundTo)
	return math.ceil(value / roundTo) * roundTo
end



function _MathRoundDown(value, roundTo)
	return math.floor(value / roundTo) * roundTo
end
