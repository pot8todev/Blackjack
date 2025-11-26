local GREEN = "\27[1;32m"
local RED = "\27[1;31m"
local RESET = "\27[0m"
local jogadores = require("classes.jogadores")
local baralho = require("classes.baralho")
-- local jogo = require("./classes/gameplayLoop.lua")

local eu = jogadores.newPcharacter()
local bot = jogadores.newNPcharacter("bot")
local mesa = jogadores.newNPcharacter("mesa")

--setup blackjack
-- bot:draw(2)
eu:draw(50)
eu:showHand()
--
-- local compra = true
-- local botWins = false
-- local playerWins = false
--
-- local noWinner = true
-- while noWinner do
-- 	while compra == true do
-- 		os.execute("clear")
-- 		print("player turn, " .. eu.pontos_mao .. " pontos")
-- 		print("bot has, " .. bot.pontos_mao .. " pontos")
-- 		bot:showHand()
-- 		eu:showHand()
-- 		compra = eu.decisao()
-- 		if eu.pontos_mao > 21 then
-- 			noWinner = false
-- 			compra = false
--
-- 			break
-- 		elseif compra == true then
-- 			eu:draw()
-- 			io.write(string.format(RED .. "YOU ARE OUT" .. RESET))
-- 		end
-- 	end
--
-- 	compra = true
-- 	while compra == true and noWinner do
-- 		-- os.execute("clear")
-- 		print("bot turn, " .. bot.pontos_mao .. " pontos")
-- 		eu:showHand()
-- 		bot:showHand()
-- 		compra = bot.decisao(bot.pontos_mao, eu.pontos_mao)
-- 		if eu.pontos_mao > 21 then
-- 			noWinner = false
-- 			compra = false
-- 		elseif compra == true then
-- 			bot:draw()
-- 		end
-- 		print("enter to continue")
-- 		io.read()
-- 		-- os.execute("sleep 1")
-- 	end
-- 	if not botWins and not playerWins then
-- 		noWinner = (bot.pontos_mao > eu.pontos_mao)
-- 	elseif playerWins then
-- 		noWinner = false
-- 		noWinner = eu.decisao()
-- 	else
-- 	end
-- end
