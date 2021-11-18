const db = require("../models");
const Location = db.locations;
const Op = db.Sequelize.Op;

exports.create = (req, res) => {
  // Validate request
  if (!req.body.locationName) {
    res.status(400).send({
      message: "locationName can not be empty!",
    });
    return;
  }

  // Create a Location
  const location = req.body;

  // Save Location in the database
  Location.create(location)
    .then((data) => {
      res.status(201).send(data);
    })
    .catch((err) => {
      res.status(500).send({
        message: err.message || "Some error occurred while creating the Location.",
      });
    });
};

// Retrieve all objects in Locations Table
exports.findAll = (req, res) => {
  const { locationName } = req.query;
  var condition = locationName ? { locationName: { [Op.iLike]: `%${locationName}%` } } : null;

  Location.findAll({ where: condition })
    .then((data) => {
      res.send(data);
    })
    .catch((err) => {
      res.status(500).send({
        message: err.message || "Some error occurred while retrieving Locations.",
      });
    });
};

exports.findOne = (req, res) => {
  const locationId = req.params.locationId;

  Location.findByPk(locationId)
    .then((data) => {
      if (data) {
        res.send(data);
      } else {
        res.status(404).send({
          message: `Cannot find Location with locationId=${locationId}.`,
        });
      }
    })
    .catch((err) => {
      res.status(500).send({
        message: "Error retrieving Location with locationId=" + locationId,
      });
    });
};
