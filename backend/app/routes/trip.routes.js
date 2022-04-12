module.exports = (app) => {
  const trips = require("../controllers/trip.controller.js");

  var router = require("express").Router();

  // Create a new trip
  router.post("/", trips.create);

  //Retrieve  trip
  router.get("/:id", trips.findOne);

  // Retrieve one trip by tripId
  //router.get("/:tripId", trips.findOne);

  app.use("/api/trips", router);
};
