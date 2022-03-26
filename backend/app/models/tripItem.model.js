module.exports = (sequelize, Sequelize) => {
  const TripItem = sequelize.define("tripItem", {
    tripId: {
      type: Sequelize.INTEGER,
    },
    day: {
      type: Sequelize.INTEGER,
    },
    order: {
      type: Sequelize.INTEGER,
    },
    locationId: {
      type: Sequelize.INTEGER,
    },
    locationName: {
      type: Sequelize.STRING,
    },
    imageUrl: {
      type: Sequelize.STRING,
    },
    lat: {
      type: Sequelize.DOUBLE,
    },
    lng: {
      type: Sequelize.DOUBLE,
    },
    locationCategory: {
      type: Sequelize.INTEGER,
    },
    startTime: {
      type: Sequelize.DATE,
    },
    distance: {
      type: Sequelize.DOUBLE,
      default: null,
    },
    duration: {
      type: Sequelize.INTEGER,
    },
    drivingDuration: {
      type: Sequelize.INTEGER,
    },
    note: {
      type: Sequelize.STRING,
    },
  });
  return TripItem;
};
