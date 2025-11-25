local GREEN = "\27[1;32m"
local RESET = "\27[0m"

function newCard(nome, nipe)
	local isJoker = (nome == "jkr")
	local isRoyalty = { K = true, Q = true, J = true } --chave: valor

	local function pontuacaoCarta() --regras pontas carta no blackjack
		local pontuacao
		if isJoker then
			pontuacao = 0
		elseif nome == "A" then
			pontuacao = 11
		elseif isRoyalty[nome] then
			pontuacao = 10
		else
			pontuacao = tonumber(nome)
		end
		return pontuacao
	end

	local card = {
		nome = nome or "",
		nipe = (not isJoker and nipe) or "", --if not joker or not have nipe ->default
		pontuacao = pontuacaoCarta() or 0,
	}
	function card:show()
		if isJoker then
			io.write(string.format("|%4s|", self.nome, self.nipe))
		else
			io.write(string.format("|%2s %1s|", self.nome, self.nipe))
		end
	end
	-- card:show()
	return card
end

local function newDeck()
	local deck = { cartas = {}, quantidadeDe = {}, total = 0 }
	local vetor_nomes = { "A", "K", "Q", "J", "10", "9", "8", "7", "6", "5", "4", "3", "2", "jkr" }
	local vetor_nipes = { "♠", "♥", "♦", "♣" }
	local nipeAliases = {
		espadas = "♠",
		copas = "♥",
		ouros = "♦",
		paus = "♣",
		coringa = "jkr",
	}
	local function findCardIndex(deck, nome, nipe)
		for i, card in ipairs(deck.cartas) do
			if card and card.nome == nome and card.nipe == nipe then
				return i
			end
		end
		return nil
	end
	function deck:addCard(card)
		table.insert(self.cartas, card)
		self.total = self.total + 1
		self.quantidadeDe[card.nome] = (self.quantidadeDe[card.nome] or 0) + 1
	end

	function deck:showAmount() -- randomseed needed in main
		local oldName
		local currentName
		io.write(GREEN .. string.format("|carta|pnts|\n") .. RESET)
		for _, card in ipairs(self.cartas) do
			currentName = card.nome
			if oldName ~= currentName then
				card:show()
				io.write("qnt: " .. self.quantidadeDe[currentName] .. "\n")
				oldName = currentName
			end
		end
		print("\ntotal: " .. self.total)
	end
	function deck:removeCard(nome, nipe)
		local function rmv(cardName, cardSuit)
			local index = findCardIndex(self, cardName, cardSuit)
			if index then
				return table.remove(self.cartas, index), cardName
			else
				-- print("Não existe carta: " .. tostring(cardName) .. " " .. tostring(cardSuit))
				return nil, cardName
			end
		end

		local iteraction = 0

		local found = false
		while iteraction < 100 and not found do
			local cardName = nome or vetor_nomes[math.random(1, #vetor_nomes)]

			-- determine suit
			local cardSuit
			if nipe then
				cardSuit = nipeAliases[nipe] or nipe
			elseif cardName ~= "jkr" then -- if not joker, pick random suit
				cardSuit = vetor_nipes[math.random(1, #vetor_nipes)]
			else
				cardSuit = "" -- joker has no suit
			end

			local removedCard, removedName = rmv(cardName, cardSuit)

			if removedCard then
				self.quantidadeDe[removedName] = (self.quantidadeDe[removedName] or 1) - 1
				self.total = self.total - 1
				io.write("the card")
				removedCard:show()
				io.write("was romoved\n")
				found = true
			end
			iteraction = iteraction + 1
		end
		-- print("carta nao encontrada no deck")
	end

	local function deckSetup() -- fill deck
		for _, nome in ipairs(vetor_nomes) do
			local isJoker = (nome == "jkr")

			if not isJoker then
				--exceto joker, todas tem 4 copias

				for _, nipe in ipairs(vetor_nipes) do
					deck:addCard(newCard(nome, nipe))
				end
			else
				--joker tem 2 copias, e sem nipe
				for _ = 1, 2 do
					deck:addCard(newCard(nome))
				end
			end
		end
	end
	deckSetup()

	return deck
end

local deck = newDeck()

math.randomseed(os.time())
