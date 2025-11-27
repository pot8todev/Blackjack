local GREEN = "\27[1;32m"
local RED = "\27[1;31m"
local RESET = "\27[0m"
local jogadores = require("classes.jogadores")
local playingCards = require("classes.playingCards")
local nipes = playingCards.nipes
local baralho = playingCards.baralho.newDeck(true, true)

-- local baralho = baralho_lib.newDeck(true)
local eu = jogadores.newPcharacter()
local bot = jogadores.newNPcharacter("bot")
local mesa = jogadores.newNPcharacter("mesa")

--setup blackjack
eu:draw(2)

local compra = true
local loop = true
while loop do
	while compra == true do
		os.execute("clear")
		if eu.pontos_mao > 21 then
			local A_index = eu.mao:findCardIndex("A", nil, 11)
			if A_index then
				eu.mao.cartas[A_index].pontuacao = 1
				eu:contaPontos()
				io.write(string.format(GREEN .. "PREVENT LOSING: A POINTS set to 1 \n" .. RESET))
			end
		end
		print("player turn, it has " .. eu.pontos_mao .. " pontos")
		print("bot has, " .. bot.pontos_mao .. " pontos")
		bot:showHand()
		eu:showHand()
		if eu.pontos_mao > 21 then
			loop = false
			compra = false
			io.write(string.format(RED .. "YOU ARE OUT" .. RESET))
			break
		end
		compra = eu.decisao()
		if compra == true then
			eu:draw()
		end
	end

	compra = true
	while compra == true and loop do
		os.execute("clear")
		if bot.pontos_mao > 21 then --
			local A_index = bot.mao:findCardIndex("A", nil, 11)
			if A_index then
				bot.mao.cartas[A_index].pontuacao = 1
				bot:contaPontos()
				io.write(string.format(GREEN .. "PREVENT LOSING: A POINTS set to 1 \n" .. RESET))
			end
		end
		print("player has, " .. eu.pontos_mao .. " pontos")
		print("bot turn, it has , " .. bot.pontos_mao .. " pontos")
		eu:showHand()
		bot:showHand() -- inverte as maos
		print()
		local _ = io.write() --useless input

		if bot.pontos_mao > 21 then
			loop = false
			compra = false
			io.write(string.format(RED .. "YOU ARE OUT" .. RESET))
			break
		elseif compra == false then
			loop = false
			io.write(string.format(RED .. "the house allways wins" .. RESET))
			break
		end
		compra = bot.decisao(bot.pontos_mao, eu.pontos_mao)
		if compra == true then
			bot:draw()
		end
	end
	print("end of game")
	loop = false
end
