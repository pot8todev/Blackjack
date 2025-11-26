local playingCards = require("classes.baralho") --jogadores sem deck nao faz sentido
local deck = playingCards.newDeck(true, true)
local graveyard = playingCards.newDeck()

local jogadores = {}
local function newPlayer(nome, decisao) --classe abstrata decisao de quando comprar carta
	local player = { nome = nome, mao = playingCards.newDeck(), pontos_mao = 0, decisao = decisao }

	function player:draw(numCards)
		numCards = numCards or 1
		for _ = 1, numCards do
			local pulledCard = deck:removeCard()
			if not pulledCard then
				break
			end
			player.mao:addCard(pulledCard)
			self.pontos_mao = self.pontos_mao + pulledCard.pontuacao
		end
	end
	function player:showHand()
		io.write(string.format("\n%s hand: ", self.nome))
		player.mao:showPretty()
		io.write("\n")
	end
	return player
end
function jogadores.newPcharacter(deck)
	local function decisao()
		local escolha
		while true do --player escolhe
			io.write(string.format("voce deseja comprar outra carta?"))
			escolha = io.read()
			if escolha == "y" then
				return true
			elseif escolha == "n" then
				return false
			end
		end
	end

	io.write(string.format("seu nickname: "))
	local nome = io.read()
	local jogador = newPlayer(nome, decisao)
	jogador.dinheiro = 0
	return jogador
end
function jogadores.newNPcharacter(nome, deck)
	local function decisao(pontos_meu, pontos_oponente)
		return (pontos_meu < pontos_oponente) --se verdade, compre outra carta
	end

	local bot = newPlayer(nome, decisao)
	return bot
end

---// ------------ //---
return jogadores
