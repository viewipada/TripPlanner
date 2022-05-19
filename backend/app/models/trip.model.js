module.exports = (sequelize, Sequelize) => {
  const Trip = sequelize.define("trip", {
    id: {
      type: Sequelize.INTEGER,
      autoIncrement: true,
      primaryKey: true,
    },
    userId: {
      type: Sequelize.INTEGER,
    },
    name: {
      type: Sequelize.STRING(100),
    },
    totalPeople: {
      type: Sequelize.INTEGER,
    },
    totalDay: {
      type: Sequelize.INTEGER,
    },
    startDate: {
      type: Sequelize.DATE,
      defaultValue: Sequelize.NOW,
    },
    firstLocation: {
      type: Sequelize.STRING,
    },
    lastLocation: {
      type: Sequelize.STRING,
    },
    thumnail: {
      type: Sequelize.STRING(500),
    },
    status: {
      type: Sequelize.STRING(15),
    },
  });
  return Trip;
};
