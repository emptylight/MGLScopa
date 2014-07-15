if Meteor.isClient
	Meteor.subscribe 'games'
	Meteor.subscribe 'users'

if Meteor.isServer
	Meteor.publish 'games', -> Games.find currentTurn: @userId #find @userId is currentTurn user ids
	Meteor.publish 'users', -> Meteor.users.find {}

