module.exports = (sequelize, Sequelize) => {
  const LocationOpeningDayHour = sequelize.define("locationOpeningDayHour", {
    locationId: {
      type: Sequelize.INTEGER,
    },
    dayWork: {
      type: Sequelize.DATE,
    },
    startWork: {
      type: Sequelize.TIME,
    },
    stopWork: {
      type: Sequelize.TIME,
    },
    status: {
      type: Sequelize.BOOLEAN,
    },
  });
  return LocationOpeningDayHour;
};
