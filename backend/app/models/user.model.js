module.exports = (sequelize, Sequelize) => {
    const User = sequelize.define("user", {
      username: {
          unique: true,
          type: Sequelize.STRING(15)
      },
      imgUrl: {
          type: Sequelize.STRING
      },
      birthDate : {
          type: Sequelize.DATE
      },
      gender:{
          type: Sequelize.STRING
      },
      role:{
          type: Sequelize.STRIMG
      }
    });
    return User;
  };
  