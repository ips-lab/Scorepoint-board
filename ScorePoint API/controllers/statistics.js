// Connection Setup
var connection = require('../connection');

function statisticsController() {
    this.getCountUsers = function(req, res, next) {
        connection.query("SELECT COUNT(*) as total FROM user", function(error, results){ 
            if(error) throw error;
            var data = results;
            var json = { data, code: "Success"};
            res.send(200, json);
        })
    }

    this.getMostWinningTeams = function(req, res, next) {
        connection.query("SELECT COUNT(g.winnerTeamId) AS total, t.teamName as team\
        FROM game g \
        LEFT JOIN team t ON g.winnerTeamId = t.teamId \
        WHERE g.endDate IS NOT NULL AND g.winnerTeamId IS NOT NULL \
        GROUP BY g.winnerTeamId \
        ORDER BY total DESC\
        LIMIT 10;", function(error, results) {
            if(error) throw error;
            var data = results;
            var json = { data, code: "Success"};
            res.send(200, json);
        })
    }

    this.totalGamesPlayed = function(req, res, next) {
        connection.query("SELECT COUNT(*) AS total FROM game WHERE endDate IS NOT NULL AND winnerTeamId IS NOT NULL", function(error, results){
            if(error) throw error;
            var data = results;
            var json = { data, code: "Success"};
            res.send(200, json);
        })
    }

    this.gamesPerHour = function(req, res, next) {
        connection.query("SELECT DATE_FORMAT(startDate,'%h:%i %p') AS hour, COUNT(*) AS total\
        FROM game\
        GROUP BY HOUR(startDate)\
        ORDER BY total DESC\
        LIMIT 5;", function(error, results){
            if(error) throw error;
            var data = results;
            var json = { data, code: "Success"};
            res.send(200, json);
        })
    }

   return this;
}

module.exports = new statisticsController();
