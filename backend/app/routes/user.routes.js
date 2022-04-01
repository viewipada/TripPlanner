module.exports = (app) => {
  const users = require("../controllers/user.controller.js");

  var router = require("express").Router();

  router.get("/:userId", users.findOne);

  router.put("/:userId", users.update);

  app.use("/api/user", router);
};
