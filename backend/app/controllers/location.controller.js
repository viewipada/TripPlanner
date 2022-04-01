const { response } = require("express");
const db = require("../models");
const Location = db.locations;
const Review = db.reviews;
const User = db.users;
const Price = db.prices;

const Op = db.Sequelize.Op;
const Sequelize = db.Sequelize;
const sequelize = db.sequelize;

exports.create = async (req, res) => {
  try {
    const location = req.body;

    if (!(location.locationName && location.latitude && location.longitude)) {
      res.status(400).send("locationName and lat-long can not be empty ! ! ");
    }

    if (location.categry == 3) {
      const min_p = req.body.min_price;
      const max_p = req.body.max_price;

      const { min_price, max_price, ...newObjLocation } = location;

      return newObjLocation;
    }

    const newLocation = await Location.create(location);

    return res.status(201).send(newLocation);
  } catch (err) {
    //create new location
    return res.status(400).send("Someting wrong while crating Location");
    console.log(err);
  }
};
// // Validate request
// if (!req.body.locationName) {
//   res.status(400).send({
//     message: "locationName can not be empty!",
//   });
//   return;
// }

// // Create a Location
// const location = req.body;

// // Save Location in the database
// Location.create(location)
//   .then((data) => {
//     res.status(201).send(data);

//     const openingDayHourData = {
//       location: data.locationId,
//       openingDayHour: req.body.openingDayHour,
//     };
//     OpeningDayHour.create(openingDayHourData);
//   })
//   .catch((err) => {
//     res.status(500).send({
//       message: err.message || "Some error occurred while creating the Location.",
//     });
//   });

// Retrieve all objects in Locations Table
exports.findAllCard = async (req, res) => {
  let locationData = await Location.findAll();

  const data = await Promise.all(
    locationData.map(async ({ locationId, locationName, imageUrl }) => {
      return { locationId, locationName, imageUrl };
    })
  );
  return res.status(200).json(data);
};

exports.findOne = async (req, res) => {
  const { locationId } = req.params;

  let locationData = await Location.findOne({ where: { locationId }, raw: true });

  let reviewData = await Review.findAll({
    where: {
      locationId,
    },
    raw: true,
  });

  console.log(reviewData);

  if (!reviewData) {
    locationData.reviewers = [];
  } else {
    console.log(12345678891000000);
    const data = await Promise.all(
      reviewData.map(
        async ({
          userId,
          reviewRate: rating,
          reviewCaption: caption,
          reviewImg1,
          reviewImg2,
          reviewImg3,
          createdAt,
        }) => {
          try {
            console.log(123456);
            let { imgUrl: profileImage, username } = await User.findOne({
              where: {
                id: userId,
              },
              raw: true,
            });

            console.log(profileImage, username);

            return {
              profileImage,
              username,
              rating,
              caption,
              images: [reviewImg1, reviewImg2, reviewImg3].filter((image) => image),
              createdAt,
            };
          } catch (error) {
            console.log(err);
            return res.status(400).send("Something wrong while query user review");
          }
        }
      )
    ).catch((err) => {
      console.log(err);
    });

    locationData.reviewers = data;
  }

  console.log(locationData);

  return res.status(200).json(locationData);
};

exports.findAllData = async (req, res, next) => {
  try {
    const filters = await req.query.category;
    const { sort } = await req.params;
    //let filters = await req.query.filters;
    console.log(sort == "rating" ? "averageRating" : "totalCheckin");
    console.log("filters : " + filters);

    const data = await Location.findAll({
      where: { category: filters },
      order: [
        [sort == "rating" ? "averageRating" : "totalCheckin", "DESC"],
        ["locationName", "ASC"],
      ],
    });

    if (filters == 0) {
      const allData = await Location.findAll({
        order: [
          [sort == "rating" ? "averageRating" : "totalCheckin", "DESC"],
          ["locationName", "ASC"],
        ],
      });

      return res.status(200).json(allData);
    }

    return res.status(200).json(data);
  } catch (err) {
    console.log(err);
  }
};

exports.findByUser = async (req, res) => {
  try {
    const { userId } = req.params;

    const locationData = await Location.findOne({
      where: { createBy: userId },
      raw: true,
    });
    console.log(locationData);

    return locationData != null
      ? res.status(200).json(locationData)
      : res.status(204).json({ msg: "There's no location that user:" + userId + "create" });
  } catch (err) {
    console.log(err);
    return res.status(400).send("Something wrong while finding locatoin by use");
  }
};
