const { response } = require("express");
const db = require("../models");
const Location = db.locations;
const Review = db.reviews;
const User = db.users;
const Duration = db.settingDurations;

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
exports.findAll = async (req, res) => {
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

  console.log(locationData.category);
  let durationData = await Promise.all(
    Duration.findOne({
      where: {
        category: locationData.category,
      },
      raw: true,
    })
  ).catch(() => {});
  console.log(durationData);

  if (reviewData == []) locationData.reviewers = [];
  else {
    //console.log(5555555);
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
          let { imgUrl: profileImage, username } = await User.findOne({
            where: {
              id: userId,
            },
            raw: true,
          });

          return {
            profileImage,
            username,
            rating,
            caption,
            images: [reviewImg1, reviewImg2, reviewImg3].filter((image) => image),
            createdAt,
          };
        }
      )
    );

    locationData.reviewers = data;
  }

  console.log(locationData);

  return res.status(200).json(locationData);
};
