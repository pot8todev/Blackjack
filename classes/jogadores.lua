local playingCards = require("classes.playingCards").baralho --jogadores sem deck nao faz sentido
local deck = playingCards.newDeck(true, true)
local graveyard = playingCards.newDeck()

local jogadores = {}
local function newPlayer(nickname, decisao) --classe abstrata decisao de quando comprar carta
	local player = { nickname = nickname, mao = playingCards.newDeck(), pontos_mao = 0, decisao = decisao }

	function player:discardHand()
		while #self.mao.cartas > 0 do
			local pulledCard = self.mao:removeCard()
			if pulledCard then
				self.pontos_mao = self.pontos_mao - pulledCard.pontuacao
			end
		end
	end
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
		io.write(string.format("\n%s hand: ", self.nickname))
		player.mao:showPretty()
		io.write("\n")
	end
	function player:contaPontos()
		local pontos = 0
		for _, card in ipairs(self.mao.cartas) do
			pontos = pontos + card.pontuacao
		end
		player.pontos_mao = pontos
		return player.pontos_mao
	end
	function player:alteraPontos(newScore, nome, nipe, pontos)
		for _, card in ipairs(self.mao.cartas) do
			local match = true

			if nome and card.nome ~= nome then
				match = false
			end

			if nipe and card.nipe ~= nipe then
				match = false
			end
			if pontos and card.pontuacao ~= pontos then
				match = false
			end

			if match then
				card.pontuacao = newScore
			end
		end

		self:contaPontos()
	end
	return player
end
function jogadores.newPcharacter()
	local function decisao()
		local escolha
		while true do --player escolhe
			escolha = io.read()
			io.write(string.format("deseja dar mais um hit?"))
			if escolha == "y" then
				return true
			elseif escolha == "n" then
				return false
			end
		end
	end

	io.write(string.format("seu nickname: "))
	local nickname = io.read()
	local jogador = newPlayer(nickname, decisao)
	jogador.dinheiro = 0
	return jogador
end

function jogadores.newNPcharacter(nome)
	local function decisao(pontos_meu, pontos_oponente)
		return (pontos_meu < pontos_oponente) --se verdade, compre outra carta
	end

	local bot = newPlayer(nome, decisao)
	return bot
end

---// ------------ //---
return jogadores
