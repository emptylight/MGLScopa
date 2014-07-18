Router.configure  
  	layoutTemplate: 'layout'

Router.map ->  
	@route 'home', 
		path: '/'
	@route 'play', 
		path: '/game/:_id'
		data: ->
			game = Games.findOne @params._id
			return {} unless game? # return empty object when a game couldn't be found! strange
			game.player = game.players[Meteor.userId()]
			game.yourTurn = game.currentTurn[0] is Meteor.userId()
			otherId = game.currentTurn[if game.yourTurn then 1 else 0]
			usr = Meteor.users.findOne _id: otherId
			game.otherPlayer = 
				username: usr.username
				score: game.players[otherId].score

			game

