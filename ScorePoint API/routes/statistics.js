module.exports = function(app) {
	var statistics = require('../controllers/statistics');
	var statisticsPath = '/statistics';

	app.get({path:statisticsPath+'/totalUsers'}, statistics.getCountUsers);
	app.get({path: statisticsPath+'/mostWinners'}, statistics.getMostWinningTeams);
	app.get({path: statisticsPath+'/totalGames'}, statistics.totalGamesPlayed);
	app.get({path: statisticsPath+'/gamesPerHour'}, statistics.gamesPerHour);
};
