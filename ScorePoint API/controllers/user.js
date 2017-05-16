// Connection Setup
var connection = require('../connection');

//This Controller deals with all functionalities of Todo
function userController() {

    this.getAllUsers = function(req, res, next) {
        connection.query('SELECT u.userId, u.username, u.email, u.firstname, u.lastname, t.teamId, t.teamname FROM user u LEFT JOIN userHasTeam uh ON u.userId = uh.userId LEFT JOIN team t ON uh.teamId = t.teamId where u.active = 1', function(error,results) {
                if(error) throw error;
                var data = results;
                var json = { data, code: "Success"};
                res.send(200, json);
                return next();
        });
    }

    this.getAllSuggestedUsers = function(req, res, next) {
        connection.query('SELECT u.userId, u.username, u.email, u.firstname, u.lastname, t.teamId, t.teamname FROM user u LEFT JOIN userHasTeam uh ON u.userId = uh.userId LEFT JOIN team t ON uh.teamId = t.teamId where u.active = 1 ORDER BY RAND() LIMIT 10', function(error, results) {
            if(error) throw error;
                var data = results;
                var json = { data, code: "Success"};
                res.send(200, json);
            return next();
        });
    }

    this.getUser = function(req, res, next) {
        if (req.params.userId !== undefined || req.params.userId !== '' || req.params.userId !== null) {
            connection.query('SELECT u.userId, u.username, u.email, u.firstname, u.lastname, t.teamId, t.teamname FROM user u LEFT JOIN userHasTeam uh ON u.userId = uh.userId LEFT JOIN team t ON uh.teamId = t.teamId where u.active = 1 and u.userId = '+connection.escape(req.params.userId), function(error, results) {
                if(error) throw error;
                var data = results[0];
                var json = { data, code: "Success"};
                res.send(200, json);
                return next();
            });
        } else {
            var json = { data: "missing parameters", code: "Failed"};
            res.send(200, json);
            return next();
        }
    }

    this.loginGmail = function(req, res, next) {
        if (
           req.params.username === undefined || req.params.username === '' || req.params.username === null ||
           req.params.email === undefined || req.params.email === '' || req.params.email === null ||
           req.params.firstname === undefined || req.params.firstname === '' || req.params.firstname === null ||
           req.params.lastname === undefined || req.params.lastname === '' || req.params.lastname === null
        ) {
                        var json = { data: "missing parameters", code: "Failed"};
            res.send(200, json);
            return next();
        } else {
            connection.query("Select COUNT(email) as count FROM user where email = "+connection.escape(req.params.email), function(error, results) {
                if(error) throw error;
                if(results[0].count === 0) {
                    connection.query('INSERT INTO user (username, email, created, imageUrl, firstname, lastname)'+
                                    'VALUES ('+connection.escape(req.params.username)+','+connection.escape(req.params.email)+', SYSDATE() ,'+connection.escape(req.params.imageUrl)+','+connection.escape(req.params.firstname)+','+connection.escape(req.params.lastname)+');',
                        function(error, results) {
                            if(error) throw error;

                            var userId = results.insertId;
                            connection.query('INSERT INTO team (teamname, created) VALUES('+connection.escape(req.params.username)+', SYSDATE())', function(error, resultsTeam) {
                                if(error) throw error;

                                var teamId = resultsTeam.insertId
                                connection.query('INSERT INTO userHasTeam VALUES('+userId+', '+teamId+')', function(error, resultUserTeam) {
                                    if(error) throw error;
                                    var json = { data: {userId: userId, teamId: teamId}, code: "Success"};
                                    res.send(200, json);
                                    return next();
                                });
                            });
                        });
                }  else {
                    if(error) throw error;
                    connection.query('SELECT u.userId, u.username, u.email, u.firstname, u.lastname, t.teamId, t.teamname FROM user u LEFT JOIN userHasTeam uh ON u.userId = uh.userId LEFT JOIN team t ON uh.teamId = t.teamId where u.active = 1 and u.email = '+connection.escape(req.params.email), function(error, results) {
                        if(error) throw error;
                        console.log();
                        var data = results[0];
                        var json = { data, code: "Success"};
                        res.send(200, json);
                        return next();
                    });
                    next();
                }
            });
        }
    }

    this.updateUser = function(req, res, next) {
        if (req.params.userId === undefined || req.params.userId === '' || req.params.userId === null) {
                        var json = { data: "missing parameters", code: "Failed"};
            res.send(200, json);
            return next();
        } else {
            connection.query('UPDATE user SET imageUrl = '+connection.escape(req.params.image_url)+','+
                            'firstname = '+connection.escape(req.params.firstname)+','+
                            'lastname = '+connection.escape(req.params.lastname)+''+
                            'WHERE userId='+connection.escape(req.params.userId), function(error,results){
                if(error) throw error;
                // var data = results[0];
                var json = {code: "Success"};
                res.send(200, json);
                return next();
            });
        }
    }

    this.removeUser = function(req, res, next) {
        if (req.params.userId === undefined || req.params.userId === '' || req.params.userId === null) {
                        var json = { data: "missing parameters", code: "Failed"};
            res.send(200, json);
            return next();
        } else {
            connection.query('UPDATE user SET active = 0 WHERE userId='+connection.escape(req.params.userId), function(error,results){
                if(error) throw error;
                // var data = results[0];
                var json = {code: "Success"};
                res.send(200, json);
                return next();
            });
        }
    }

   return this;
}

module.exports = new userController();
