const db = require("../models");
const Review = db.reviews;
const Op = db.Sequelize.Op;

exports.create = (req, res) => {
  // Validate request
  if (!req.body.userId) {
    res.status(400).send({
      message: "userId can not be empty!",
    });
    return;
  }

  // Create a Location
  const review = {
    userId: req.body.userId,
    locationId: req.body.locationId,
    reviewRate: req.body.reviewRate,
    reviewCaption: req.body.reviewCaption,
    reviewImg1: req.body.reviewImg1,
    reviewImg2: req.body.reviewImg2,
    reviewImg3: req.body.reviewImg3,
  };

  // Save Location in the database
  Review.create(review)
    .then((data) => {
      res.status(201).send(data);
    })
    .catch((err) => {
      res.status(500).send({
        message:
          err.message || "Some error occurred while creating the Location.",
      });
    });
};

exports.findAll = (req, res) => {
  const locationId = req.query.locationId;
  var condition = locationId
    ? { locationId: { [Op.iLike]: `%${locationId}%` } }
    : null;

  Review.findAll({ where: condition })
    .then((data) => {
      res.send(data);
    })
    .catch((err) => {
      res.status(500).send({
        message:
          err.message || "Some error occurred while retrieving tutorials.",
      });
    });
};
