local GREEN = "\27[1;32m"
local RED = "\27[1;31m"
local RESET = "\27[0m"
local jogadores = require("classes.jogadores")
-- local baralho_lib = require("classes.baralho")
-- local jogo = require("./classes/gameplayLoop.lua")

-- local baralho = baralho_lib.newDeck(true)
local eu = jogadores.newPcharacter()
local bot = jogadores.newNPcharacter("bot")
local mesa = jogadores.newNPcharacter("mesa")

--setup blackjack
-- bot:draw(2)
eu:draw(2)
bot:draw(2)

local compra = true

local loop = true
while loop do
	while compra == true do
		os.execute("clear")
		print("player turn, " .. eu.pontos_mao .. " pontos")
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
		print("player turn, " .. eu.pontos_mao .. " pontos")
		print("bot has, " .. bot.pontos_mao .. " pontos")
		eu:showHand()
		bot:showHand() -- inverte as maos

		if bot.pontos_mao > 21 or compra == false then
			loop = false
			compra = false
			if bot.pontos_mao > 21 then
				io.write(string.format(RED .. "YOU ARE OUT" .. RESET))
			end
			break
		end
		compra = bot.decisao(bot.pontos_mao, eu.pontos_mao)
		if compra == true then
			bot:draw()
		else
			print("bot won")
			break
		end
		print("press enter to continue")
		io.read()
	end
	loop = false
end
