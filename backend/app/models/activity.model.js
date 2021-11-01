module.exports = (sequelize, Sequelize) => {
  const Activity = sequelize.define(
    "activity",
    {
      timestamps: false,
      userId: {
        type: Sequelize.INTEGER,
        primaryKey: true,
      },
      locationId: {
        type: Sequelize.INTEGER,
        primaryKey: true,
      },
      visitedTime: {
        type: Sequelize.DATE,
      },
    },
    {
      createdAt: "visitedTime",
    }
  );

  return Activity;
};
