@Turns = {}

Turns.inHand = (set, card) ->
	for acard in set when matchCards acard, card
		return true
	return false
	
matchCards = (a,b)->
	a.suit is b.suit and a.value is b.value

Turns.getMatch = (card, set) ->
	matches = Turns.findMatches card, set
	if matches.length > 0
		return Turns.bestMatch matches
	return null

Turns.findMatches = (card,set)->
	matches = []
	for tableCard in set
		if tableCard.value is card.value
			matches.push [tableCard]
	if matches.length >0 
		return matches
	for i in [2..set.length] # for i = 2; i <= set.length; i++
		combinations set, i, (potentialMatch)->
			if (sumCards potentialMatch) is card.value
				matches.push potentialMatch.slice()
	return matches

Turns.bestMatch = (matches)->
	mostCoins = [ 0, null]
	mostCards = [0,null]
	for match in matches
		for m in match
			if m.suit is 'Coins' and m.value is 7
				return match
		coinCount = match.filter( (card)-> card.suit is 'Coins').length 
		if coinCount > mostCoins[0]
			mostCoins = [coinCount, match]
		if match.length > mostCards[0] 
			mostCards = [match.length,match]
	return if mostCards[0] > mostCoins[0] then mostCards[1] else mostCoins[1]

Turns.takeMatch = (game, id, card, match) ->
	for matchCard in match
		game.players[id].pile.push matchCard
		game.table = Turns.removeCard matchCard, game.table

	game.players[id].pile.push card
	game.lastScorer = id

	if game.table.length is 0
		game.players[id].score.scopa++ # scopa ++ will not work!!

Turns.removeCard = (card,set) ->
	set.filter (setCard)->
	 	not matchCards card, setCard

sumCards = (set) ->
	set.reduce ((a,b)-> a + b.value),0


# The author copied from stackoverflow answer
combinations = (numArr, choose, callback) ->
	n = numArr.length
	c = []
	inner = (start, choose_) ->
		if choose_ is 0
			callback c 
		else
			for i in [start..n - choose_ ] #for i = start; i<= n- choose_; ++i
				c.push numArr[i]
				inner i+1,choose_-1
				c.pop()


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

@GameFactory = {}

GameFactory.dealPlayers = (players, deck)->
	for i in [0..2] # needed to do 3 times 
		for id in Object.keys players
			players[id].hand.push deck.shift() #shift?

GameFactory.createGame = (playerIds)-> 
	createDeck = ->
		suits = ['Cups','Coins','Swords','Clubs']
		cards = []

		for suit in suits
			for i in [1..10]
				name = switch i 
					when 1 then 'A'
					when 8 then 'N'
					when 9 then 'Q'
					when 10 then 'K'
					else i

				cards.push 
					suit: suit
					value: i
					name: name

		_.shuffle cards

	createPlayers = (ids)->
		o = {}
		class Player 
			constructor: ->
			hand:[]
			pile:[]
			score:
				mostCoins:0
				mostCards:0
				setteBello:0
				primera:0
				scopa:0

		for id in ids
			o[id] = new Player
		o

	dealTable = (deck) ->
		c = deck.shift.bind deck
		[c(),c(),c(),c()]
		# what?

	players = createPlayers playerIds
	deck = createDeck()
	GameFactory.dealPlayers players, deck

	deck: deck
	players: players
	table: dealTable deck
	currentTurn: playerIds
	inProgress: true
	started: new Date 



