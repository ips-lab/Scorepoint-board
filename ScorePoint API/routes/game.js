module.exports = function(app) {
	var game = require('../controllers/game');
	var gamePath = '/game';

	app.get({path:gamePath}, game.getGames);
	app.get({path:gamePath+'/:gameId'}, game.getGame);

	app.post({path:gamePath+'/gameRequestSent'}, game.getGameRequestSent);
	app.post({path:gamePath+'/gameRequestReceived'}, game.getGameRequestReceived);
	app.post({path:gamePath+'/createGame'}, game.createGame);
	app.post({path:gamePath+'/createGameRequest'}, game.createGameRequest);
	app.post({path:gamePath+'/createTableGame'}, game.createTableGame);
	app.post({path:gamePath+'/createGameTypes'}, game.createGameTypes);
	app.post({path:gamePath+'/resetGame'}, game.restartGame);
	app.post({path:gamePath+'/cancelGame'}, game.cancelGame);
	app.post({path:gamePath+'/endGame'}, game.endGame);	

	app.del({path:gamePath+'/deleteGames'}, game.deleteGames);
};
