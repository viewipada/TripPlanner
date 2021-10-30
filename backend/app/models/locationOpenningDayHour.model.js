module.exports = (sequelize, Sequelize) => {
    const LocationOpeningDayHour = sequelize.define("locationOpeningDayHour", {
      locationId: {
        type: Sequelize.INTEGER,
        primaryKey: true,
      },
      dayWork: {
          type : Sequelize.DATE
      },
      hourWork: {
          type: Sequelize.DATETIME
      },
      status: {
          type: Sequelize.BOOLEAN
      }
    });
    return LocationOpeningDayHour;
  };
  