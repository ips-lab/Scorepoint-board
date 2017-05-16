// Connection Setup
var connection = require('../connection');

//This Controller deals with all functionalities of Todo
function gameController() {

    this.getGames = function(req, res, next) {
        connection.query('SELECT * from game WHERE active = 1 AND endDate IS null ORDER BY startDate ASC', function(error,results) {
            if(error) throw error;
            var data = results;
            var json = { data, code: "Success"};
            res.send(200, json);
            return next();
        });
    }

    this.getGame = function(req, res, next) {
        if(req.params.gameId === undefined || req.params.gameId === '' || req.params.gameId === null) {
            var json = { data: "missing parameters", code: "Failed"};
            res.send(200, json);
            return next();
        }

        connection.query('SELECT g.gameId, g.gameTypeId, g.teamLocalId, g.teamVisitId, g.points, t1.teamname AS teamLocalName, t2.teamname AS teamVisitName, s.setId as setId, s.scoreLocal, s.scoreVisit \
                           ,(SELECT Count(setId) FROM gameset WHERE gameid = '+connection.escape(req.params.gameId)+' AND winnerTeamId=t1.teamId) as setLocalWon \
                           ,(SELECT Count(setId) FROM gameset WHERE gameid = '+connection.escape(req.params.gameId)+' AND winnerTeamId=t2.teamId) as setVisitWon \
                           ,g.endDate \
                           FROM game AS g \
                           JOIN team AS t1 ON g.teamLocalId = t1.teamId \
                           JOIN team AS t2 ON g.teamVisitId = t2.teamId \
                           LEFT JOIN gameset AS s ON s.gameId = g.gameId AND s.setId = (SELECT MAX(setId) FROM gameset WHERE gameId = '+connection.escape(req.params.gameId)+') \
                           WHERE g.gameId = '+connection.escape(req.params.gameId)+'\
                           ORDER BY g.startDate ASC LIMIT 1',
        function(error, results) {
                if(error) throw error;
                var data = results[0];
                var json = { data, code: "Success"};
                res.send(200, json);
                return next();
        });
    }

    this.createGame = function(req, res, next) {
        if(req.params.pongTableId === undefined || req.params.pongTableId === '' || req.params.pongTableId === null
         || req.params.startDate === undefined || req.params.startDate === '' || req.params.startDate === null
         || req.params.teamLocalId === undefined || req.params.teamLocalId === '' || req.params.teamLocalId === null
         || req.params.teamVisitId === undefined || req.params.teamVisitId === '' || req.params.teamVisitId === null
         || req.params.gameTypeId === undefined || req.params.gameTypeId === '' || req.params.gameTypeId === null
         || req.params.points === undefined || req.params.points === '' || req.params.points === null
         ) {
            var json = { data: "missing parameters", code: "Failed"};
            res.send(200, json);
            return next();
         }

        var startDate = req.params.startDate;

        connection.query('INSERT INTO game(pongTableId, tournamentId, startDate, teamLocalId, teamVisitId, gameTypeId, points) VALUES('+connection.escape(req.params.pongTableId) +', '+connection.escape(req.params.tournamentId) +', '+connection.escape(req.params.startDate) +', '+connection.escape(req.params.teamLocalId) +', '+connection.escape(req.params.teamVisitId) +', '+connection.escape(req.params.gameTypeId)+', '+connection.escape(req.params.points) +')',
        function(error,results) {
            if(error) throw error;
            
            var gameId = results.insertId;
            // res.send(200, gameId);
            connection.query('INSERT INTO gameset(gameId, startDate) VALUES('+connection.escape(gameId)+', '+connection.escape(startDate)+')', function(error, result) {
                if(error) throw error;
                var json = { data: {gameId: gameId, setId: results.insertId}, code:"Success" };
                res.send(200, json);
                return next();
            });

            return next();
        });
    }

    this.createGameRequest = function(req, res, next) {        
        if( req.params.pongTableId === undefined || req.params.pongTableId === '' || req.params.pongTableId === null
         || req.params.teamLocalId === undefined || req.params.teamLocalId === '' || req.params.teamLocalId === null
         || req.params.teamVisitId === undefined || req.params.teamVisitId === '' || req.params.teamVisitId === null
         || req.params.gameTypeId === undefined || req.params.gameTypeId === '' || req.params.gameTypeId === null
         || req.params.points === undefined || req.params.points === '' || req.params.points === null
         ) {
            var json = { data: "missing parameters", code: "Failed"};
            res.send(400, json);
            return next();
         }

        connection.query('INSERT INTO gameRequest(pongTableId, tournamentId, teamLocalId, teamVisitId, gameTypeId, points) VALUES('+connection.escape(req.params.pongTableId) +', '+connection.escape(req.params.tournamentId) +', '+connection.escape(req.params.teamLocalId) +', '+connection.escape(req.params.teamVisitId) +', '+connection.escape(req.params.gameTypeId)+', '+connection.escape(req.params.points) +')',
        function(error,results) {
            if(error) throw error;
                var data = results[0];
                var json = { data, code: "Success"};
                res.send(200, json);
            return next();
        });
    }

    this.getGameRequestSent = function(req, res, next) {
        if(req.params.teamId === undefined || req.params.teamId === '' || req.params.teamId === null) {
            var json = { data: "missing parameters", code: "Failed"};
            res.send(200, json);
            return next();
        }
        
        connection.query('SELECT * FROM gameRequest WHERE teamLocalId = ' + req.params.teamId, function(error,results) {
            if(error) throw error;
                var data = results;
                var json = { data, code: "Success"};
                res.send(200, json);
            return next();
        });
    }

    this.getGameRequestReceived = function(req, res, next) {
        if(req.params.teamId === undefined || req.params.teamId === '' || req.params.teamId === null) {
                        var json = { data: "missing parameters", code: "Failed"};
            res.send(200, json);
            return next();
        }

        connection.query('SELECT * FROM gameRequest WHERE teamVisitId = ' + req.params.teamId, function(error,results) {
            if(error) throw error;
                var data = results;
                var json = { data, code: "Success"};
                res.send(200, json);
            return next();
        });
    }

    this.deleteGames = function(req, res, next) {
        connection.query('DELETE FROM game', function(error,results) {
            if(error) throw error;
                var data = results;
                var json = { data, code: "Success"};
                res.send(200, json);
            return next();
        });
    }

    this.createTableGame = function(req, res, next) {

        if(req.params.tableName === undefined || req.params.tableName === '' || req.params.tableName === null
         ) {
                        var json = { data: "missing parameters", code: "Failed"};
            res.send(200, json);
            return next();
         }

        connection.query('INSERT INTO pongTable(name, active) VALUES('+connection.escape(req.params.tableName) +', 1)',
            function(error,results){
                if(error) throw error;
                var data = results;
                var json = { data, code: "Success"};
                res.send(200, json);
                return next();
            }
        );
    }

    this.createGameTypes = function(req, res, next) {

        if(req.params.gameTypeName === undefined || req.params.gameTypeName === '' || req.params.gameTypeName === null
         ) {
                        var json = { data: "missing parameters", code: "Failed"};
            res.send(200, json);
            return next();
         }

        connection.query('INSERT INTO gameTypes(name) VALUES('+connection.escape(req.params.gameTypeName) +')',
            function(error,results){
                if(error) throw error;
                var data = results;
                var json = { data, code: "Success"};
                res.send(200, json);
                return next();
            }
        );
    }

    this.restartGame = function(req,res,next){
        if(req.params.gameId === undefined || req.params.gameId === '' || req.params.gameId === null
         ||req.params.setId === undefined || req.params.setId === '' || req.params.setId === null ){
                        var json = { data: "missing parameters", code: "Failed"};
            res.send(200, json);
            return next();
        }

        connection.query('UPDATE gameset SET scoreLocal = 0, scoreVisit = 0 WHERE gameId = '+connection.escape(req.params.gameId) +' AND setId = '+connection.escape(req.params.setId), function(error,results){
            if(error) throw error;
                var data = results;
                var json = { data, code: "Success"};
                res.send(200, json);
            return next();
        });

        /*

        if(req.params.gameId === undefined || req.params.gameId === '' || req.params.gameId=== null){
                        var json = { data: "missing parameters", code: "Failed"};
            res.send(200, json);
        }
        connection.query('UPDATE teamgamescore SET score=0 WHERE gameId='+connection.escape(req.params.gameId), function(error,results){
            if(error) throw error;
            res.send(200, results);
            return next();
        });
        */
    }

    this.cancelGame = function(req,res,next){
        if(req.params.gameId === undefined || req.params.gameId === '' || req.params.gameId === null){
                        var json = { data: "missing parameters", code: "Failed"};
            res.send(200, json);
            return next();
        }

        connection.query('UPDATE game SET endDate = SYSDATE() and active = 0 WHERE gameId ='+connection.escape(req.params.gameId), function(error,results){
            if(error) throw error;
        
            connection.query('UPDATE gameset SET endDate = SYSDATE() and active = 0 WHERE gameId ='+connection.escape(req.params.gameId), function(error,results){
                if(error) throw error;
                var data = results;
                var json = { data, code: "Success"};
                res.send(200, json);
                return next();
            });
        });
    }

    this.endGame = function(req,res,next){
        res.send(200, 'EndGame has not been implemented.......');
        return next();
    }

   return this;
}

module.exports = new gameController();
