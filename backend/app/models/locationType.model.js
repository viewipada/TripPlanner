module.exports = (sequelize, Sequelize) => {
    const LocationType = sequelize.define("locationType", {
      locationTypeId: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },
      interestedName: {
          type: Sequelize.STRING
      },
      interestedImgUrl: {
          type: Sequelize.STRING
      },
      dufaultDuration:{
          type: Sequelize.INTEGER
      },
      category:{
          type: Sequelize.STRING
      }
    });
    return LocationType;
  };
  