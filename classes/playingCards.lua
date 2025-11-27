local GREEN = "\27[1;32m"
local RED = "\27[1;31m"
local RESET = "\27[0m"

local playingCards = {}
local nipeAliases = {
	espadas = "♠",
	copas = "♥",
	ouros = "♦",
	paus = "♣",
	coringa = "jkr",
}

function playingCards.newCard(nome, nipe)
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
		isFlipped = false,
	}
	function card:flip()
		self.isFlipped = not self.isFlipped
	end
	function card:show(backwards)
		local COLOR = RESET

		local nome = self.nome
		local nipe = self.nipe
		local function format(parm1, parm2)
			if self.nipe == "♥" or self.nipe == "♦" then
				COLOR = RED
			end
			if isJoker then
				io.write(COLOR .. string.format("|  %3s  |", parm1) .. RESET)
			elseif parm1 == "10" then
				io.write(COLOR .. string.format("|%s  %1s|", parm1, parm2) .. RESET)
			elseif parm2 == "10" then
				io.write(COLOR .. string.format("|%1s  %s|", parm1, parm2) .. RESET)
			else
				io.write(COLOR .. string.format("|%s  %s |", parm1, parm2) .. RESET)
			end
		end
		if not self.isFlipped then
			if backwards == true then
				format(nipe, nome)
			else
				format(nome, nipe)
			end
		else
			io.write("|=====|")
		end
	end

	-- card:show()
	return card
end

function playingCards.newDeck(ActualDeck, rmvJoker, rmvRoyalty)
	local deck = { cartas = {}, quantidadeDe = {}, total = 0 }
	local vetor_nomes = { "A", "K", "Q", "J", "10", "9", "8", "7", "6", "5", "4", "3", "2", "jkr" }
	local vetor_nipes = { "♠", "♥", "♦", "♣" }
	local isRoyalty = { K = true, Q = true, J = true } --chave: valor
	function deck:findCardIndex(nome, nipe, pontos) --find the index of the first match
		for i, card in ipairs(self.cartas) do
			if card then
				local match = true

				if nome and card.nome ~= nome then
					match = false
				end
				if nipe and not (card.nipe == nipeAliases[nipe] or card.nipe == nipe) then
					match = false
				end
				if pontos and card.pontuacao ~= pontos then
					match = false
				end

				if match then
					return i
				end
			end
		end
		return nil
	end
	-- function deck:find(nome, nipe)
	-- 	local i = self:findCardIndex(nome, nipe)
	-- 	local carta = deck.cartas[i]
	--
	-- 	if carta then
	-- 		return carta
	-- 	end
	-- 	print("card Not found")
	-- 	return nil
	-- end
	function deck:addCard(card)
		table.insert(self.cartas, card)
		self.total = self.total + 1
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
	function deck:showPretty()
		local COLOR = RESET
		local function printHorizontally(amount, string) --horizontaly  allign print
			for _ = 1, amount do
				io.write(COLOR .. string .. RESET)
			end
			io.write("\n")
		end
		local function horizontalCardList(amount, index) -- horizontaly print the cards
			if amount <= 0 then --recursive call
				return
			end
			local maxCardsRow = 5
			local usedAmount = amount or 1
			if amount > maxCardsRow then --if >then 7 cards, complete in next line
				usedAmount = maxCardsRow
				-- índice final correto
			end
			local endIndex = index + usedAmount - 1
			io.write("\n")
			printHorizontally(usedAmount, " _____ ")
			printHorizontally(usedAmount, "|     |")
			for i = index, endIndex do -- print the nipe of the card
				self.cartas[i]:show()
			end
			io.write("\n")
			printHorizontally(usedAmount, "|     |")
			printHorizontally(usedAmount, "|     |")
			for i = index, endIndex do
				self.cartas[i]:show(true) -- print backwards
			end
			io.write("\n")
			printHorizontally(usedAmount, "|_____|")
			horizontalCardList(amount - maxCardsRow, index + maxCardsRow)
		end
		horizontalCardList(self.total, 1)
	end
	function deck:removeCard(nome, nipe)
		local function rmv(cardName, cardSuit)
			local index = self:findCardIndex(cardName, cardSuit)
			if index then
				return table.remove(self.cartas, index), cardName
			else
				-- print("Não existe carta: " .. tostring(cardName) .. " " .. tostring(cardSuit))
				return nil, cardName
			end
		end

		local iteraction = 0

		while iteraction < 100 do
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
				-- found = true
				return removedCard
			end
			iteraction = iteraction + 1
		end
		return nil
		-- print("carta nao encontrada no deck")
	end

	if ActualDeck == true then --permission to  have 54 cards innit
		function deck:fill() -- fill deck
			for _, nome in ipairs(vetor_nomes) do
				local isJoker = (nome == "jkr")

				if not isJoker then
					--exceto joker, todas tem 4 copias
					if not (rmvRoyalty and isRoyalty[nome]) then -- ou é realeza ou eu pedi para remover algo que nao veio, nunca os dois
						for _, nipe in ipairs(vetor_nipes) do
							self:addCard(playingCards.newCard(nome, nipe))
						end
					end
				else
					if rmvJoker == false then
						--joker tem 2 copias, e sem nipe
						for _ = 1, 2 do
							self:addCard(playingCards.newCard(nome))
						end
					end
				end
			end
		end
		deck:fill()
	end

	return deck
end
-- local deck = playingCards.newDeck(true)
-- deck:showPretty()
-- deck:showAmount()
return {
	baralho = playingCards,
	nipes = nipeAliases,
}
