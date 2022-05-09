module.exports = (sequelize, Sequelize) => {
  const Baggage = sequelize.define("baggage", {
    locationId: {
      type: Sequelize.INTEGER,
    },
    userId: {
      type: Sequelize.INTEGER,
    },
  });

  return Baggage;
};
