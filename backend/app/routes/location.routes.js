module.exports = (app) => {
  const locations = require("../controllers/location.controller.js");

  var router = require("express").Router();

  // Create a new Location
  router.post("/", locations.create);

  // Retrieve all locations in card pattern
  router.get("/card", locations.findAllCard);

  // Retrieve all location data
  router.get("/", locations.findAllData);

  // Retrieve one location by locationId
  router.get("/:locationId", locations.findOne);

  router.get("/user/:userId", locations.findByUser);

  app.use("/api/locations", router);
};
