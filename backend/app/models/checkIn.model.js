module.exports = (sequelize, Sequelize) => {
  const CheckIn = sequelize.define(
    "checkIn",
    {
      checkInId: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
      },
      userId: { type: Sequelize.INTEGER },
      locationId: {
        type: Sequelize.INTEGER,
      },
      checkInTime: {
        type: Sequelize.DATE,
      },
    },
    {
      createdAt: "checkInTime",
    }
  );

  return CheckIn;
};
