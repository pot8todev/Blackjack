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

local function setup(prompt, totalMoney)
	eu:draw(2)
	bot:draw(2)
	bot.mao.cartas[2]:flip()
	os.execute("clear")
	io.write(GREEN .. string.format("\nvoce possui ") .. RESET)
	io.write(RED .. string.format("%d dinheiros", eu.dinheiro) .. RESET)
	io.write(GREEN .. string.format(" mas a casa sempre vence....") .. RESET)
	while true do
		io.write(prompt)
		local input = io.read("*l")
		local n = tonumber(input)
		if n ~= nil and n <= totalMoney and n > 0 then
			return n
		end
		print("Entrada inválida, digite um valor que consiga pagar.")
	end
end
eu.dinheiro = 100
local compra = true
local loop = true
local payback = 1.5

while loop do
	local investimento = setup("\nQuanto deseja investir(juros: " .. payback .. "):", eu.dinheiro)
	eu.dinheiro = eu.dinheiro - investimento

	local botWin = false
	local playerWin = false

	----------// turno do jogador //--------------
	while compra == true do
		os.execute("clear")
		io.write(string.format("\nvoce possui "))
		io.write(GREEN .. string.format("%d dinheiros", eu.dinheiro) .. RESET)
		io.write(string.format("restantes"))
		if eu.pontos_mao > 21 then
			local A_index = eu.mao:findCardIndex("A", nil, 11)
			if A_index then
				eu.mao.cartas[A_index].pontuacao = 1
				eu:contaPontos()
				io.write(string.format(GREEN .. "\nPREVENT LOSING: A POINTS set to 1 \n" .. RESET))
			end
		end
		print("\nplayer turn, it has " .. RED .. eu.pontos_mao .. RESET .. " pontos")
		print("bot has, " .. RED .. "??" .. RESET .. " pontos")
		bot:showHand()
		eu:showHand()
		if eu.pontos_mao > 21 then
			io.write(string.format(RED .. "\nYOU ARE OUT" .. RESET))
			botWin = true

			break
		end
		io.write(string.format("\nvoce deseja comprar outra carta?"))
		compra = eu.decisao()
		if compra == true then
			eu:draw()
		end
	end

	compra = true
	bot.mao.cartas[2]:flip()
	----------// turno do bot //--------------
	while compra == true and not botWin do
		os.execute("clear")
		if bot.pontos_mao > 21 then --
			local A_index = bot.mao:findCardIndex("A", nil, 11)
			if A_index then
				bot.mao.cartas[A_index].pontuacao = 1
				bot:contaPontos()
				io.write(string.format(GREEN .. "\nPREVENT LOSING: A POINTS set to 1 \n" .. RESET))
			end
		end
		print("\nplayer has, " .. RED .. eu.pontos_mao .. RESET .. " pontos")
		print("bot turn, it has " .. RED .. bot.pontos_mao .. RESET .. " pontos")
		eu:showHand()
		bot:showHand() -- inverte as maos
		print()
		local _ = io.read() --useless input

		if bot.pontos_mao > 21 then
			playerWin = true

			io.write(string.format(RED .. "\nBOT IS OUT\n" .. RESET))
			break
		elseif compra == false then
			io.write(string.format(RED .. "\nthe house allways wins" .. RESET))
			break
		end
		compra = bot.decisao(bot.pontos_mao, eu.pontos_mao)
		if compra == true then
			bot:draw()
		end
	end
	----------// decidido o ganhador //--------------

	if botWin then -- ou o jagador estourou
		os.execute("clear")
		print("\nplayer has, " .. RED .. eu.pontos_mao .. RESET .. " pontos")
		print("bot has " .. RED .. bot.pontos_mao .. RESET .. " pontos")
		print("house allways wins")
		loop = eu:decisao()
	elseif playerWin then -- ou o bot estourou tentando ganhar
		io.write(
			GREEN
				.. string.format("\ninvestiu %.2f voce ganhow %.2f dinheiro", investimento, investimento * payback)
				.. RESET
		)
		investimento = investimento * payback
		payback = payback * payback
		io.write(GREEN .. string.format("\njuros de vitoria aumentado: %.2f", payback) .. RESET)
		io.write(string.format("\ndeseja continuar?"))
		eu.dinheiro = eu.dinheiro + investimento
		loop = eu:decisao()
	end
	if eu.dinheiro <= 0 then -- acabou o dinheiro
		print(RED .. "voce tem problemas." .. RESET)
		loop = false
	end
	eu:discardHand()
	bot:discardHand()
end
