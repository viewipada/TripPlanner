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
      type: Sequelize.STRING(30),
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
      type: Sequelize.INTEGER,
    },
    lastLocation: {
      type: Sequelize.INTEGER,
    },
    thumnail: {
      type: Sequelize.STRING,
    },
    status: {
      type: Sequelize.STRING(15),
    },
  });
  return Trip;
};
