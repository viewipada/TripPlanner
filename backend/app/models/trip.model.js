module.exports = (sequelize, Sequelize) => {
  const Trip = sequelize.define("trip", {
    tripId: {
      type: Sequelize.INTEGER,
      autoIncrement: true,
      primaryKey: true,
    },
    userId: {
      type: Sequelize.INTEGER,
    },
    tripName: {
      type: Sequelize.STRING(30),
    },
    numberPerson: {
      type: Sequelize.INTEGER,
    },
    numberTravellingDay: {
      type: Sequelize.INTEGER,
    },
    trevelStartDate: {
      type: Sequelize.DATE,
      defaultValue: Sequelize.NOW,
    },
    startLat: {
      type: Sequelize.DOUBLE,
    },
    startLong: {
      type: Sequelize.DOUBLE,
    },
    tripProfileImg: {
      type: Sequelize.STRING,
    },
    status: {
      type: Sequelize.STRING(15),
    },
  });
  return Trip;
};
