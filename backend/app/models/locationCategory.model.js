module.exports = (sequelize, Sequelize) => {
    const LocationCategory = sequelize.define("locationCategory", {
      locationCategoryId: {
          type: Sequelize.INTEGER,
          autoIncrement : true,
          primaryKey : true
      },
      locationCategoryName :{
          type: Sequelize.STRING
      }
    });
    return LocationCategory;
  };
  