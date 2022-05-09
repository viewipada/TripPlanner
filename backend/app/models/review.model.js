module.exports = (sequelize, Sequelize) => {
  const Review = sequelize.define("review", {
    userId: {
      type: Sequelize.INTEGER,
      primaryKey: true,
    },
    locationId: {
      type: Sequelize.INTEGER,
      primaryKey: true,
    },
    reviewRate: {
      type: Sequelize.INTEGER,
    },
    reviewCaption: {
      type: Sequelize.STRING(120),
    },
    reviewImg1: {
      type: Sequelize.STRING,
    },
    reviewImg2: {
      type: Sequelize.STRING,
    },
    reviewImg3: {
      type: Sequelize.STRING,
    },
  });
  return Review;
};
