module.exports = (app) => {
  const locations = require("../controllers/location.controller.js");

  var router = require("express").Router();

  // Create a new Location
  router.post("/", locations.create);

  // Retrieve all locations in card pattern
  router.get("/card", locations.findAllCard);

  // Retrieve searched data
  router.get("/search/:sort", locations.findAllData);

  router.get("/admin/search/:sort", locations.searchAdmin);

  // Retrieve one location by locationId
  router.get("/:locationId", locations.findOne);

  // retrieve locations created by user
  router.get("/byUser/:userId", locations.findByUser);

  //delete one location
  router.delete("/:locationId", locations.delete);

  //Retrieve ten most popular
  router.get("/top/popular", locations.findPopular);

  //Retrieve nearby user location by category
  router.get("/nearby/:category/:lat/:lng", locations.findNearBy);

  //update status location when admin checked
  router.put("/:locationId", locations.updateLocationStatus);

  //get type of location by categoty
  router.get("/category/type/:category", locations.getType);

  //checkIn location
  router.put("/checkIn/:locationId", locations.checkIn);

  app.use("/api/locations", router);
};
