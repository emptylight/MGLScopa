if Meteor.isClient
	Meteor.subscribe 'games'
	Meteor.subscribe 'users'

if Meteor.isServer
	Meteor.publish 'games', -> Games.find currentTurn: @userId #find @userId is currentTurn user ids
	Meteor.publish 'users', -> Meteor.users.find {}
# change server side code to change the access means security

# the following code can be called on both sides but will only be simulated on client side
Meteor.methods
	createGameWith: (otherPlayerId)->
		game = GameFactory.createGame [Meteor.userId(), otherPlayerId]
		Games.insert game 

	takeTurn:(gameId,id,card) ->
		game = Games.findOne gameId
		hand = game.players[id].hand

		unless (game.currentTurn[0] is id) and (Turns.inHand hand, card)
			return

		match = Turns.getMatch card, game.table
		if match 
			Turns.takeMatch game, id, card, match
		else
			game.table.push card

		game.players[id].hand = Turns.removeCard card,hand
		game.currentTurn.unshift game.currentTurn.pop()

		if allHandsEmpty game.players
			if game.deck.length > 0
				GameFactory.dealPlayers game.players,game.deck
			else
				#score the game

		Games.update gameId,game


allHandsEmpty = (players)->
	_.every players, (player)->
		player.hand.length is 0



###
#the game object would look like:

game =
	currentTurn: []
	deck: []
	table: []
	players:
		a:
			hand:[]
			pile:[]
			score: {}
		b:{}
	inProcess: true/false
	started: date
	finished: date
	winner: id
###