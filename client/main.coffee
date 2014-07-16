Template.signup.events
	'click button': (evnt,tmplt) ->
		evnt.preventDefault()
		Accounts.createUser
			email: ($ '#su-email').val()
			username: ($ '#su-username').val()
			password: ($ '#su-password').val()

Template.login.events
	'click button': (e, t) ->
		e.preventDefault()
		Meteor.loginWithPassword ($ '#li-username').val(), 
			($ '#li-password').val()
			(err)-> console.log err

Template.logout.events
	'click button': (e,t) ->
		e.preventDefault()
		Meteor.logout()

Template.userList.helpers
	users: -> 
		myId = Meteor.userId()
		cantPlayAgainst = [myId]
		# note: only games that I'm playing are published
		gs = Games.find inProgress: true
		for game in gs.fetch() # a fetch() is needed here otherwise it doesn't work
			for uid in game.currentTurn
				cantPlayAgainst.push uid unless uid is myId 

		Meteor.users.find _id: $not: $in: cantPlayAgainst
		

Template.userItem.events
	'click button': (e,t) ->
		Meteor.call 'createGameWith', @_id #t.data._id