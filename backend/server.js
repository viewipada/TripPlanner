const express = require("express");

const fileUpload = require("express-fileupload");
const cors = require("cors");
const bodyParser = require("body-parser");
const morgan = require("morgan");
const _ = require("lodash");

const db = require("./app/models");
const { sequelize } = require("./app/models");

const app = express();

global.__basedir = __dirname;

//add other middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(morgan("dev"));

// enable files upload
app.use(
  fileUpload({
    createParentPath: true,
  })
);

app.use(express.static("uploads"));

// parse requests of content-type - application/json
app.use(express.json());

// parse requests of content-type - application/x-www-form-urlencoded
app.use(express.urlencoded({ extended: true }));

db.sequelize.sync();

// simple route
app.get("/", (req, res) => {
  res.json({ message: "Welcome to API application." });
});

require("./app/routes/baggage.routes")(app);
require("./app/routes/location.routes")(app);
require("./app/routes/review.routes")(app);
require("./app/routes/file.routes")(app);
require("./app/routes/authen.routes")(app);
require("./app/routes/trip.routes")(app);
require("./app/routes/user.routes")(app);

// set port, listen for requests
const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}.`);
});
