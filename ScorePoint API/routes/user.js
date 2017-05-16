module.exports = function(app) {
	var user = require('../controllers/user');
	var userPath = '/user';
	var ver = '0.0.1';

	app.get({path:userPath}, user.getAllUsers);
	app.get({path:userPath+'/suggested'}, user.getAllSuggestedUsers);
	app.get({path:userPath+'/:userId'}, user.getUser);
	app.post({path:userPath+'/login'}, user.loginGmail);
	app.post({path:userPath+'/update'}, user.updateUser);
	app.del({path:userPath+'/:userId'}, user.removeUser);
};
