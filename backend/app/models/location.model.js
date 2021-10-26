module.exports = (sequelize, Sequelize) => {
  const Location = sequelize.define("location", {
    locationId: {
      type: Sequelize.INTEGER,
      autoIncrement: true,
      primaryKey: true,
    },
    locationName: {
      type: Sequelize.STRING(30),
    },
    locationCategory: {
      type: Sequelize.INTEGER,
    },
    locationDescription: {
      type: Sequelize.STRING(300),
    },
    locationNumber: {
      type: Sequelize.STRING(10),
    },
    locationWebsite: {
      type: Sequelize.STRING,
    },
    locationImgUrl: {
      type: Sequelize.STRING,
    },
    locationLat: {
      type: Sequelize.DOUBLE,
    },
    locationLong: {
      type: Sequelize.DOUBLE,
    },
    locationProvince: {
      type: Sequelize.STRING(100),
    },
    locationAvgRating: {
      type: Sequelize.FLOAT,
    },
    locationSumReview: {
      type: Sequelize.INTEGER,
    },
    locationSumCheckIn: {
      type: Sequelize.INTEGER,
    },
    createBy: {
      type: Sequelize.INTEGER,
    },
    locationStatus: {
      type: Sequelize.STRING(15),
    },
  });

  return Location;
};
