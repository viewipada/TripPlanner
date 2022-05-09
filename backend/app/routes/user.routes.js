module.exports = (app) => {
  const users = require("../controllers/user.controller.js");

  var router = require("express").Router();

  router.get("/:userId", users.findOne);

  router.put("/:userId", users.update);

  router.post("/interested", users.create_interested);

  router.put("/interested/:userId", users.update_interested);

  router.get("/interested/:userId", users.findOne_interested);

  router.get("/settingProfile/:userId", users.settingProfile);

  app.use("/api/user", router);
};
