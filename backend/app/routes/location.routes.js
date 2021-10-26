module.exports = (app) => {
  const locations = require("../controllers/location.controller.js");

  var router = require("express").Router();

  // Create a new Location
  router.post("/", locations.create);

  // Retrieve all locations
  router.get("/", locations.findAll);

  // Retrieve one location by locationId
  router.get("/:locationId", locations.findOne);

  app.use("/api/locations", router);
};
