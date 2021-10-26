module.exports = (app) => {
  const baggages = require("../controllers/baggageList.controller.js");

  var router = require("express").Router();

  // Create a new Baggage
  router.post("/", baggages.create);

  // Retrieve all baggages
  router.get("/", baggages.findAll);

  app.use("/api/baggages", router);
};
