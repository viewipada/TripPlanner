module.exports = (app) => {
  const locations = require("../controllers/location.controller.js");

  var router = require("express").Router();

  // Create a new Location
  router.post("/", locations.create);

  // Retrieve all locations in card pattern
  router.get("/card", locations.findAllCard);

  // Retrieve searched data
  router.get("/search/:sort", locations.findAllData);

  // Retrieve one location by locationId
  router.get("/:locationId", locations.findOne);

  // retrieve locations created by user
  router.get("/:userId", locations.findByUser);

  //delete one location
  router.delete("/:locationId", locations.delete);

  //Retrieve ten most popular
  router.get("/popular", locations.findPopular);

  app.use("/api/locations", router);
};
