module.exports = (sequelize, Sequelize) => {
  const Baggage = sequelize.define("baggage", {
    locationId: {
      type: Sequelize.INTEGER,
      autoIncrement: true,
      primaryKey: true,
    },
    locationName: {
      type: Sequelize.STRING(30),
    },
    imageUrl: {
      type: Sequelize.STRING,
    },
  });

  return Baggage;
};
