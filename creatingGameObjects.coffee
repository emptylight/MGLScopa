@GameFactory = {}

GameFactory.dealPlayers = (players,deck)->
	for i in [0..2] # needed to do 3 times 
		for player in players
			player.hand.push deck.shift() #shift?

GameFactory.createGame = (playerIds)-> 
	createDeck = ->
		suits = ['Cups','Coins','Swords','Clubs']
		cards = []

		for suit in suits
			for i in [1..10]
				name = i
				switch i # name = switch i <-- will not work
					when i is 1 then name ='A'
					when i is 8 then name ='N'
					when i is 9 then name ='Q'
					when i is 10 then name ='K'
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



