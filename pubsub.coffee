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