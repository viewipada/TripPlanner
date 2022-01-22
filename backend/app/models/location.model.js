module.exports = (sequelize, Sequelize) => {
  const Location = sequelize.define("location", {
    locationId: {
      type: Sequelize.INTEGER,
      autoIncrement: true,
      primaryKey: true,
    },
    locationName: {
      type: Sequelize.STRING(50),
    },
    category: {
      type: Sequelize.INTEGER,
    },
    description: {
      type: Sequelize.STRING(300),
    },
    contactNumber: {
      type: Sequelize.STRING(10),
    },
    website: {
      type: Sequelize.STRING,
    },
    imageUrl: {
      type: Sequelize.STRING(500),
    },
    latitude: {
      type: Sequelize.DOUBLE,
    },
    longitude: {
      type: Sequelize.DOUBLE,
    },
    province: {
      type: Sequelize.STRING(100),
      defaultValue: "Angthong",
    },
    averageRating: {
      type: Sequelize.DOUBLE,
    },
    totalReview: {
      type: Sequelize.INTEGER,
    },
    totalCheckin: {
      type: Sequelize.INTEGER,
    },
    createBy: {
      type: Sequelize.INTEGER,
    },
    locationStatus: {
      type: Sequelize.STRING(15),
      defaultValue: "inprogress",
    },
  });

  return Location;
};
