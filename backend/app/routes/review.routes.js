module.exports = (app) => {
  const reviews = require("../controllers/review.controller.js");

  var router = require("express").Router();

  // Create a new review
  router.post("/", reviews.create);

  // Retrieve all reviews
  router.get("/", reviews.findAll);

  app.use("/api/reviews", router);
};
