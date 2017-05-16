// Connection Setup
var connection = require('../connection');

//This Controller deals with all functionalities of Todo
function scoreController() {    
    this.addPoint = function(req,res,next){
        if(req.params.gameId === undefined || req.params.gameId === '' || req.params.gameId === null
         ||req.params.visit === undefined || req.params.visit === '' || req.params.visit === null
         ||req.params.setId === undefined || req.params.setId === '' || req.params.setId === null ) {
                        var json = { data: "missing parameters", code: "Failed"};
            res.send(200, json);
            return next();
        }
        // select y mandar setWiner validar limite de puntos!! 

        var scorefield = 'score'+(req.params.visit === '0'?'Local':'Visit');
        connection.query('UPDATE gameset SET '+scorefield+'='+scorefield+'+1 WHERE gameId='+connection.escape(req.params.gameId) +' AND setId='+connection.escape(req.params.setId), function(error,results){
            if(error) throw error;
                            var data = results;
                var json = { data, code: "Success"};
                res.send(200, json);
            return next();
        });
    }

    this.removePoint = function(req,res,next){
        if(req.params.gameId === undefined || req.params.gameId === '' || req.params.gameId === null
         ||req.params.visit === undefined || req.params.visit === '' || req.params.visit === null
         ||req.params.setId === undefined || req.params.setId === '' || req.params.setId === null ) {
                        var json = { data: "missing parameters", code: "Failed"};
            res.send(200, json);
            return next();
        }

        var scorefield = 'score'+(req.params.visit === '0'?'Local':'Visit');
        connection.query('UPDATE gameset SET '+scorefield+'='+scorefield+'-1 WHERE gameId='+connection.escape(req.params.gameId) +' AND setId='+connection.escape(req.params.setId), function(error,results){
            if(error) throw error;
                            var data = results;
                var json = { data, code: "Success"};
                res.send(200, json);
            return next();
        });
    }

    this.setWinner = function(req,res,next) {
        if(req.params.gameId === undefined || req.params.gameId === '' || req.params.gameId === null
         ||req.params.winnerTeamId === undefined || req.params.winnerTeamId === '' || req.params.winnerTeamId === null
         ||req.params.setId === undefined || req.params.setId === '' || req.params.setId === null
          ) {
                        var json = { data: "missing parameters", code: "Failed"};
            res.send(200, json);
            return next();
        }

        connection.query('UPDATE gameset SET winnerTeamId='+connection.escape(req.params.winnerTeamId) +', endDate = SYSDATE() WHERE gameId='+connection.escape(req.params.gameId) +' AND setId='+connection.escape(req.params.setId), function(error,results){
            if(error) throw error;


            // Here we need to check for the sets that the game is set up ex. 3 out of 5 and the count the ammount of sets played
            // and how many have the users won and if the sets have been played or a user has won the majority
            // we need to finish the game
        
            connection.query('SELECT g.gameTypeId \
                            ,(SELECT Count(setId) FROM gameset WHERE gameid = '+connection.escape(req.params.gameId)+' AND winnerTeamId=t1.teamId) as setLocalWon \
                           ,(SELECT Count(setId) FROM gameset WHERE gameid = '+connection.escape(req.params.gameId)+' AND winnerTeamId=t2.teamId) as setVisitWon \
                           FROM game as g \
                           JOIN team AS t1 ON g.teamLocalId = t1.teamId \
                           JOIN team AS t2 ON g.teamVisitId = t2.teamId \
                           LEFT JOIN gameset AS s ON s.gameId = g.gameId \
                           WHERE g.gameId = '+connection.escape(req.params.gameId)+'\
                           ORDER BY g.startDate ASC LIMIT 1',
               function(error, results) {
                if(error) throw error;
                
                if(results.length > 0){
                    //Check for pending sets
                    if(results[0].gameTypeId == results[0].setLocalWon || results[0].gameTypeId == results[0].setVisitWon){
                        //no pending games
                        connection.query('UPDATE game SET endDate = SYSDATE(),winnerTeamId='+connection.escape(req.params.winnerTeamId)+' \
                                            WHERE gameId ='+connection.escape(req.params.gameId), function(error,results){
                            if(error) throw error;
                            var json = { data: "Game Finished", code: "Success"};
                            res.send(200, json);
                        });
                    }else{
                        //add new set
                        connection.query('INSERT INTO gameset(gameId, startDate) VALUES('+connection.escape(req.params.gameId)+', SYSDATE() )', function(error, results) {
                            if(error) throw error;
                            var json = { data: {gameId: req.params.gameId, setId: results.insertId}, code:"Success" };
                            res.send(200, json);
                            //return next();
                        });
                    }
                }

                //res.send(200, results);
                //return next();
            });

            //res.send(200, results);
            return next();
        });
    }

   return this;
}

module.exports = new scoreController();
