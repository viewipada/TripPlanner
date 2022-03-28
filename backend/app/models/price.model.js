module.exports = (sequelize, Sequelize) => {
  const Price = sequelize.define("price", {
    locationId: {
      type: Sequelize.INTEGER,
    },
    min_price: {
      type: Sequelize.INTEGER,
    },
    max_price: {
      type: Sequelize.INTEGER,
    },
  });

  return Price;
};
