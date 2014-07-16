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
		for game in (Games.find inProgress:true)
			cantPlayAgainst.push game.currentTurn[if game.currentTurn[0] is myId then 1 else 0]
		Meteor.users.find _id: $not: $in: cantPlayAgainst

Template.userItem.events
	'click button': (e,t) ->
		Meteor.call 'createGame', t.data._id