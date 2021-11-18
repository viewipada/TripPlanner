module.exports = (app) => {
  const Baggage = require("../controllers/baggageList.controller.js");

  var router = require("express").Router();

  // Create a new Baggage
  router.post("/", Baggage.create);

  router.get("/:userId", Baggage.findOne);

  // Delete an Item in baggage
  router.delete("/:baggageItemId", Baggage.delete);

  app.use("/api/baggage", router);
};
