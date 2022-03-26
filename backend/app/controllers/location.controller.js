const { response } = require("express");
const db = require("../models");
const Location = db.locations;
const Review = db.reviews;
const User = db.users;
const Op = db.Sequelize.Op;
const Sequelize = db.Sequelize;
const sequelize = db.sequelize;

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

exports.findAllData = async (req, res, next) => {
  try {
    let filters = await req.query;
    //let filters = await req.query.filters;
    // console.log(category);
    //console.log(filters);

    const data = await Location.findAll();

    const filteredData = data.filter((location) => {
      let isValid = true;
      for (key in filters) {
        console.log(key, location[key], filters[key]);
        isValid = isValid && location[key] == filters[key];
      }
      return isValid;
    });
    // console.log("locationData : " + locationData);

    //locationData = await locationData.orderBy(locationData, filter, "asc");

    res.status(200).json(filteredData);
  } catch (err) {
    console.log(err);
  }
};

// try {
//   let locationName = await req.query.locationName;
//   let filter = await req.query.filter;
//   console.log(locationName);
//   console.log(filter);
//   let newLocationName = await JSON.stringify(locationName)
//   var condition = (await locationName)
//     ? { locationName: { [Op.like]: `%${newLocationName}%` } }
//     : null;

//   let locationData = await Location.findAll({
//     where: { condition },
//     order: [filter, "ASC"],
//     attributes: [
//       "locationId",
//       "locationName",
//       "category",
//       "description",
//       "contactName",
//       "website",
//       "duration",
//       "type",
//       "imageUrl",
//       "latitude",
//       "longitude",
//       "province",
//       "averageRating",
//       "totalReview",
//       "totalCheckin",
//       "createBy",
//       "locationStatus",
//       "createdAt",
//       "updatedAt",
//     ],
//   });
//   console.log("locationData : " + locationData);

//   //locationData = await locationData.orderBy(locationData, filter, "asc");

//   res.status(200).json(locationData);
// } catch (err) {
//   console.log(err);
// }
