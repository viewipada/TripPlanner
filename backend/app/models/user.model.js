const { sequelize, Sequelize } = require(".");

module.exports = (sequelize, Sequelize) => {
  const User = sequelize.define("user", {
    username: {
      unique: true,
      type: Sequelize.STRING(15),
    },
    password: {
      type: Sequelize.STRING,
    },
    imgUrl: {
      type: Sequelize.STRING,
    },
    birthDate: {
      type: Sequelize.DATE,
    },
    gender: {
      type: Sequelize.STRING,
    },
    role: {
      type: Sequelize.STRING,
    },
  });
  return User;
};
