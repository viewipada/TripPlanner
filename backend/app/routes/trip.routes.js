module.exports = (app) => {
  const trips = require("../controllers/trip.controller.js");

  var router = require("express").Router();

  // Create a new trip
  router.post("/", trips.create);

  //Retrieve all trips
  router.get("/:userId", trips.findOne);

  // Retrieve one trip by tripId
  //router.get("/:tripId", trips.findOne);

  app.use("/api/trips", router);
};
