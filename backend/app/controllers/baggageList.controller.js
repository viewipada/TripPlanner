const db = require("../models");
const Baggage = db.baggage;
const Location = db.locations;
const Category = db.locationCategories;
const Op = db.Sequelize.Op;

exports.create = (req, res) => {
  // Create a Baggage
  const baggage = req.body;

  // Save Baggage in the database
  Baggage.create(baggage)
    .then((data) => {
      res.status(201).send(data);
    })
    .catch((err) => {
      res.status(500).send({
        message: err.message || "Some error occurred while creating the Baggage.",
      });
    });
};

exports.findOne = async (req, res) => {
  const { userId } = req.params;

  let BaggageData = await Baggage.findAll({
    where: {
      userId,
    },
    raw: true,
  });

  const data = await Promise.all(
    BaggageData.map(async ({ locationId }) => {
      let {
        locationName,
        latitude,
        longitude,
        imageUrl,
        description,
        category: locationCategoryId,
        duration,
      } = await Location.findOne({
        where: {
          locationId,
        },
        raw: true,
      });

      let { locationCategoryName: category } = await Category.findOne({
        where: {
          locationCategoryId,
        },
        raw: true,
      });
      return {
        locationId,
        locationName,
        latitude,
        longitude,
        imageUrl,
        description,
        category,
        duration,
      };
    })
  );

  return res.status(200).json(data);
};

exports.delete = (req, res) => {
  // const { baggageItemId: id } = req.params;
  const { userId, locationId } = req.params;

  // const deleteData = await Review.destroy({ where: { userId, locationId } });
  Baggage.destroy({
    where: { userId, locationId },
  })
    .then((num) => {
      if (num === 1) {
        res.status(200).send({
          message: "Baggage was deleted successfully!",
        });
      } else {
        res.status(403).send({
          message: `Cannot delete Baggage with id=${locationId}. Maybe Baggage was not found!`,
        });
      }
    })
    .catch((err) => {
      res.status(500).send({
        message: `Could not delete Baggage with id=${locationId}`,
      });
    });
};
