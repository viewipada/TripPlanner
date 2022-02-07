module.exports = (sequelize, Sequelize) => {
  const LocationOpeningDayHour = sequelize.define("locationOpeningDayHour", {
    locationId: {
      type: Sequelize.INTEGER,
    },
    openingDayHour: {
      type: Sequelize.STRING,
      get: function () {
        return JSON.parse(this.getDataValue("openingDayhour"));
      },
      set: function (val) {
        return this.setDataValue("openingDayhour", JSON.stringify(val));
      },
    },
  });
  return LocationOpeningDayHour;
};
