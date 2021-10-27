module.exports = (sequelize, Sequelize) => {
    const UserInterested = sequelize.define("userInterested", {
      userId: {
          type: Sequelize.INTEGER,
          primaryKey: true
      },
      interestedType: {
          type: Sequelize.INTEGER,
          primaryKey: true
      }
    });
  
    return UserInterested;
  };
  