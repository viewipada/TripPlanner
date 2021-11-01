const dbConfig = require("../config/db.config.js");

const Sequelize = require("sequelize");
const sequelize = new Sequelize(dbConfig.DB, dbConfig.USER, dbConfig.PASSWORD, {
  host: dbConfig.HOST,
  dialect: dbConfig.dialect,
  dialectOptions: {
    ssl: {
      require: true,
      rejectUnauthorized: false,
    },
  },
  operatorsAliases: false,

  pool: {
    max: dbConfig.pool.max,
    min: dbConfig.pool.min,
    acquire: dbConfig.pool.acquire,
    idle: dbConfig.pool.idle,
  },
});

const db = {};

db.Sequelize = Sequelize;
db.sequelize = sequelize;

db.activities = require("./activity.model.js")(sequelize, Sequelize);
db.baggage = require("./baggage.model.js")(sequelize, Sequelize);
db.checkIns = require("./checkIn.model.js")(sequelize, Sequelize);
db.locations = require("./location.model.js")(sequelize, Sequelize);
db.locationCategories = require("./locationCategory.model.js")(sequelize, Sequelize);
db.locationOpeningDayHours = require("./locationOpeningDayHour.model.js")(sequelize, Sequelize);
db.locationTypes = require("./locationType.model.js")(sequelize, Sequelize);
db.reviews = require("./review.model.js")(sequelize, Sequelize);
db.settingDurations = require("./settingDuration.model.js")(sequelize, Sequelize);
db.tripItems = require("./tripItem.model.js")(sequelize, Sequelize);
db.trips = require("./trip.model.js")(sequelize, Sequelize);
db.users = require("./user.model.js")(sequelize, Sequelize);
db.userInterested = require("./userInterested.model.js")(sequelize, Sequelize);

module.exports = db;
