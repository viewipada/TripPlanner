module.exports = (sequelize, Sequelize) => {
  const UserInterested = sequelize.define("userInterested", {
    userId: {
      type: Sequelize.INTEGER,
      primaryKey: true,
    },
    first_activity: {
      type: Sequelize.STRING,
    },
    second_activity: {
      type: Sequelize.STRING,
    },
    third_activity: {
      type: Sequelize.STRING,
    },
    first_food: {
      type: Sequelize.STRING,
    },
    second_food: {
      type: Sequelize.STRING,
    },
    third_food: {
      type: Sequelize.STRING,
    },
    first_hotel: {
      type: Sequelize.STRING,
    },
    second_hotel: {
      type: Sequelize.STRING,
    },
    third_hotel: {
      type: Sequelize.STRING,
    },
    min_price: {
      type: Sequelize.INTEGER,
    },
    max_price: {
      type: Sequelize.INTEGER,
    },
  });

  return UserInterested;
};
