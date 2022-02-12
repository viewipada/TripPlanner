const db = require("../models");
const Location = db.locations;
const User = db.users;

exports.create = (req, res) => {
  // Validate request
  if (!req.body.userId) {
    res.status(400).send({
      message: "userId can not be empty!",
    });
    return;
  }

  // Create a Location
  const review = ({
    tripId,
    userId,
    tripName,
    numberPerson,
    numberTravellingDay,
    reviewImg2,
    reviewImg3,
  } = req.body);

  // Save Location in the database
  Trip.create(review)
    .then((data) => {
      res.status(201).send(data);
    })

    .catch((err) => {
      res.status(500).send({
        message: err.message || "Some error occurred while creating the Location.",
      });
    });
};
