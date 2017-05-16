module.exports = function(app) {
	var score = require('../controllers/score');
	var scorePath = '/score';

	app.post({path:scorePath+'/addPoint'}, score.addPoint);
	app.post({path:scorePath+'/removePoint'}, score.removePoint);
	app.post({path:scorePath+'/setWinner'}, score.setWinner);
};
