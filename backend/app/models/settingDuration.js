module.exports = (sequelize, Sequelize) => {
    const SettingDuration = sequelize.define("settingDuration" , {
        userId: {
            type: Sequelize.INTEGER,
            primaryKey: true
        },
        locationTypeId: {
            type: Sequelize.INTEGER,
            primaryKey: true,
          },
        settingDuration: {
            type: Sequelize.INTEGER
        }
    }
    );
    return SettingDuration;
};