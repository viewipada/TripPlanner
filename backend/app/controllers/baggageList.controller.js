const db = require("../models");
const Baggage = db.baggages;
const Op = db.Sequelize.Op;

exports.create = (req, res) => {
  // Validate request
  if (!req.body.locationName) {
    res.status(400).send({
      message: "Content can not be empty!",
    });
    return;
  }

  // Create a Baggage
  const baggage = {
    locationName: req.body.locationName,
    imageUrl: req.body.imageUrl,
  };

  // Save Baggage in the database
  Baggage.create(baggage)
    .then((data) => {
      res.status(201).send(data);
    })
    .catch((err) => {
      res.status(500).send({
        message:
          err.message || "Some error occurred while creating the Baggage.",
      });
    });
};

exports.findAll = (req, res) => {
  const locationName = req.query.locationName;
  var condition = locationName
    ? { locationName: { [Op.iLike]: `%${locationName}%` } }
    : null;

  Baggage.findAll({ where: condition })
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
