local jogo = {}
function jogo.newLoop(jogadores, setup, winningCondition, gameplay)
	local function shallowCopy(t)
		local c = {}
		for i, v in ipairs(t) do
			c[i] = v
		end
		return c
	end
	local loop = {
		jogadores = shallowCopy(jogadores),
		setup = setup,
		winCon = winningCondition,
		gameplay = gameplay,
	}
	function loop:gameplayLoop()
		setup()
		while not winningCondition do
			gameplay()
		end
	end
	return loop
end
return jogo
