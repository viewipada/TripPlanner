module.exports = (sequelize, Sequelize) => {
    const TripItem = sequelize.define("tripItem", {
      tripId: {
        type: Sequelize.INTEGER,
      },
      locationId:{
          type: Sequelize.INTEGER
      },
      travelDay: {
          type: Sequelize.INTEGER,
          defaultValue: 1,
      },
      startTime:{
          type: Sequelize.TIME
      },
      locationDuration: {
          type: Sequelize.INTEGER
      },
      distanceFromStart: {
          type : Sequelize.INTEGER
      },
      drivingDuration: {
          type: Sequelize.INTEGER
      },
      locationNote :{
          type: Sequelize.STRING(300)
      }
    });
    return TripItem;
  };
  