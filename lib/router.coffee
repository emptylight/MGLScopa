Router.configure  
  	layoutTemplate: 'layout'

Router.map ->  
	@route 'home', 
		path: '/'
	@route 'play', 
		path: '/game/:_id'
		data: ->
			game = Games.findOne @params._id
			game.player = game.players[Meteor.userId()]
			game.yourTurn = game.currentTurn[0] is Meteor.userId()
			otherId = game.currentTurn[if game.yourTurn then 1 else 0]
			game.otherPlayer = 
				username: Meteor.users.findOne(otherId).username
				score: game.players[otherId].score

			game

