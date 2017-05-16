// set up ======================================================================
require("./config/config");
const restify = require('restify');

// configuration ===============================================================
var server = restify.createServer({ name : "ScorePoint API" });
server.use(restify.queryParser());
server.use(restify.bodyParser());
server.use(restify.CORS());

// listen (start app with node server.js) ======================================
server.listen(process.env.PORT, () => {
    console.log(`Started on port ${process.env.PORT}`);
});

// routes =======================================================================
server.get({path:'/'}, Home);
function Home(req, res, next) { res.send(200, "IPS ScorePoint API"); return next(); }

require('./routes/score')(server);
require('./routes/user')(server);
require('./routes/game')(server);
require('./routes/statistics')(server);
