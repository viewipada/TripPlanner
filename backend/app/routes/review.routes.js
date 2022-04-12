module.exports = (app) => {
  const reviews = require("../controllers/review.controller.js");

  var router = require("express").Router();

  // Create a new review
  router.post("/", reviews.create);

  // Retrieve all reviews
  router.get("/reviewLocation", reviews.findAll);

  router.get("/:locationId", reviews.findAllReviewLocation);

  router.get("/:userId/:locationId", reviews.findOriginalReview);

  router.delete("/:userId/:locationId", reviews.delete);

  router.put("/:userId", reviews.update);

  app.use("/api/reviews", router);
};
