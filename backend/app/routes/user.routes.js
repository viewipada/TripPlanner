module.exports = (app) => {
  const users = require("../controllers/user.controller.js");

  var router = require("express").Router();

  router.get("/:userId", users.findOne);

  router.put("/:userId", users.update);

  router.post("/interested", users.create_interested);

  router.put("/interested/:userId", users.update_interested);

  app.use("/api/user", router);
};
