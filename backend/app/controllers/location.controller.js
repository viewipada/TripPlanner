const { response } = require("express");
const db = require("../models");
const Location = db.locations;
const Review = db.reviews;
const User = db.users;
const Duration = db.settingDurations;
const OpeningDayHour = db.locationOpeningDayHours;

exports.create = async (req, res) => {
  try {
    const location = req.body;

    if (!(location.locationName && location.latitude && location.longitude)) {
      res.status(400).send("locationName and lat-long can not be empty ! ! ");
    }

    //create new location
    const newLocation = await Location.create(location);

    res.status(201).send(newLocation);
  } catch (err) {
    res.status(400).send("Someting wrong while crating Location");
    console.log(err);
  }
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

  console.log("reviewData : " + reviewData);

  console.log("category : " + locationData.category);

  if (reviewData.length == 0) locationData.reviewers = [];
  else {
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
          } catch (error) {
            console.error(error);
          }

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
    ).catch((err) => {
      console.log(err);
    });

    locationData.reviewers = data;
  }

  console.log(locationData);

  return res.status(200).json(locationData);
};
