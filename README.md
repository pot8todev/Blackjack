# Blackjack
implementando jogos de carta usando princípios de orientação a objeto
![diagrama de classes usado](classes/assets/blackJack.png)

## Sobre o codigo
a ideia foi deixar as interaçoes com o baralho e jogadores o mais generica possivel, para que pudessem ser implementados outros jogos utilizando os mesmas estruturas e funçoes, mas a fim de simplicidade, foi deixado a pontuaçao das cartas fixas para o jogo de blackJack
```lua

	local function pontuacaoCarta() --regras pontas carta no blackjack
		local pontuacao
		if isJoker then
			pontuacao = 0
		elseif nome == "A" then
			pontuacao = 11 -- podendo ser 1 caso a mao exceda 21
		elseif isRoyalty[nome] then
			pontuacao = 10
		else
			pontuacao = tonumber(nome)
		end
		return pontuacao
	end
```
```

```

toda carta possui nome, nipe e pontuacao, os nipes sao os simbolos :{ "♠", "♥", "♦", "♣" }, mas é exportada do arquivo uma tabela de aliases para se referir a eles externamente.
```lua
local nipeAliases = {
	espadas = "♠",
	copas = "♥",
	ouros = "♦",
	paus = "♣",
	coringa = "jkr",
}
```

e pode ser importada usando:
```lua

local playingCards = require("classes.playingCards")
local nipes = playingCards.nipes
 ```

a mao dos jogadores é considerada um tipo de deck, mas sem a permissao de usar a funçao `fill()`, que preenche eles com as 54 cartas do baralho.

nesse exemplozinho de codigo, os jogadores compartilham de um mesmo deck de 52 cartas sem o coringa, mas voce pode criar um deck alheio usando:
```lua


local baralho = playingCards.baralho.newDeck(true, true,true)
```

o primeiro booleano para permitir usar a funçao `fill()`, o segundo para tirar os coringas, o terceiro para tirar os J,Q,K do baralho.

# Blackjack
![Sobre o funcionamento de jogo](classes/assets/gameplay.png)
##### setup
- primeiro pedimos o nome do jogador, e o quanto ele deseja apostar. 
- cada jogador compra 2 cartas, e o bot deixa a segunda secreta

##### turno do jogador
- a decisao do personagem jogavel é feita pelo input do usuario.Que escolhe puxar ou nao uma carta.
- isso se repete ate que decida parar ou que o valor exceda 21(jogador estourou)
- caso As seja adicionado a mao, ele vale 11 ate o momento que o jogador exceda 21, ai a pontuacao do primeiro As encotrada na mao desse jogador dele é alterado para 1, e previne-se o estouro

##### turno do bot
- vira-se a carta secreta do bot
- segundo as mesmas regras, a decisao do bot é comprar uma carta ate que ele ao menos empate com o jogador, 

##### decidindo vecedor
- A pontuacao do jogador deve EXCEDER a pontuacao do bot, caso contrario, ele perde

- se ganhou, entao o valor investido volta multiplicado pela cotaçao da mesa, e esta sobe, para que possa ganhar mais dinheiro na proxima vez.
- se perdeu, entao o dinheiro investido gera 0 retorno, e a cotaçao permanesse a mesma
