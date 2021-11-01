const db = require("../models");
const Baggage = db.baggage;
const Location =  db.locations;
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

  Location.

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

exports.delete = (req, res) => {
  const id = req.params.baggageItemId;

  Baggage.destroy({
    where: { id: id }
  })
    .then(num => {
      if (num == 1) {
        res.send({
          message: "Baggage was deleted successfully!"
        });
      } else {
        res.send({
          message: `Cannot delete Baggage with id=${id}. Maybe Baggage was not found!`
        });
      }
    })
    .catch(err => {
      res.status(500).send({
        message: "Could not delete Baggage with id=" + id
      });
    });
};
