const { response } = require("express");
const { locations } = require("../models");
const db = require("../models");
const Location = db.locations;
const Review = db.reviews;
const User = db.users;
const CheckIn = db.checkIns;
const Price = db.prices;

const Op = db.Sequelize.Op;
const Sequelize = db.Sequelize;
const sequelize = db.sequelize;

exports.create = async (req, res) => {
  try {
    const location = req.body;

    const type = location.type;

    if (
      type == "สถานที่ผจญภัย" ||
      type == "สถานบันเทิง, ผับ, บาร์" ||
      type == "สวน" ||
      type == "พิพิธภัณฑ์" ||
      type == "วัด, โบราณสถาน" ||
      type == "ตลาด, ชุมชน, สถานที่ถ่ายภาพ"
    ) {
      location.duration = 3;
    } else if (type == "ภูเขา, ป่าไม้, ธรรมชาติ" || type == "ชายหาด, เกาะ") {
      location.duration = 4;
    } else if (
      type == "อาหารเส้น" ||
      type == "อาหารตามสั่ง, จานด่วน" ||
      type == "สตรีทฟู้ด" ||
      type == "ร้านอาหาร, ภัตราคาร" ||
      type == "ปิ้งย่าง, บุฟเฟ่ต์"
    ) {
      location.duration = 2;
    } else if (type == "คาเฟ่" || type == "ร้านกาแฟ") {
      location.duration = 1;
    } else if (
      type == "รีสอร์ท" ||
      type == "แคมป์ปิ้ง" ||
      type == "โรงแรม" ||
      type == "บังกะโล, บ้านพัก" ||
      type == "โฮมสเตย์, เกสเฮาส์"
    ) {
      location.duration = 8;
    } else if (type == "ของกิน" || type == "ของใช้") {
      location.duration = 1;
    }

    console.log(location.duration);

    if (!(location.locationName && location.latitude && location.longitude)) {
      return res.status(400).send("locationName and lat-long can not be empty ! ! ");
    }

    const { min_price, max_price, ...newObjLocation } = await location;

    const newLocation = await Location.create(location.category == 3 ? location : newObjLocation);

    if (location.category == 3) {
      const priceData = await Price.create({
        locationId: newLocation.locationId,
        min_price: req.body.min_price,
        max_price: req.body.max_price,
      });
    }

    console.log(newLocation);

    return res.status(201).json(newLocation);
  } catch (err) {
    //create new location
    console.log(err);
    return res.status(400).send("Someting wrong while crating Location");
  }
};

// Retrieve all objects in Locations Table
exports.findAllCard = async (req, res) => {
  let locationData = await Location.findAll({ where: { locationStatus: "Approved" } });

  const data = await Promise.all(
    locationData.map(async ({ locationId, locationName, imageUrl }) => {
      return { locationId, locationName, imageUrl };
    })
  );
  return res.status(200).json(data);
};

exports.findOne = async (req, res) => {
  const { locationId } = req.params;

  let locationData = await Location.findOne({
    where: { locationId },
    raw: true,
  });

  if (locationData.category == 3) {
    let { min_price, max_price } = await Price.findOne({ where: { locationId }, raw: true });
    locationData.min_price = min_price;
    locationData.max_price = max_price;
  }

  let reviewData = await Review.findAll({
    where: {
      locationId,
    },
    raw: true,
    limit: 3,
  });

  console.log(reviewData);

  if (!reviewData) {
    locationData.reviewers = [];
  } else {
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

    const totalReviews = await Review.count({ where: { locationId } });

    const avg = await Review.findAll({
      where: { locationId },
      attributes: [[sequelize.fn("avg", sequelize.col("reviewRate")), "average"]],
      raw: true,
    });

    //const totalCheckin = await CheckIn.count({ where: { locationId } });

    console.log(totalReviews);
    console.log(avg);

    const updateData = await Location.update(
      {
        totalReview: totalReviews,
        averageRating: avg[0].average == null ? 0 : parseFloat(avg[0].average).toFixed(2),
      },
      {
        where: { locationId },
        returning: true,
        plain: true,
        raw: true,
      }
    );

    locationData.totalReview = totalReviews;
    locationData.averageRating =
      avg[0].average == null ? "0" : parseFloat(avg[0].average).toFixed(2);
    locationData.reviewers = data;
  }

  console.log(locationData);

  return res.status(200).json(locationData);
};

//search
exports.findAllData = async (req, res, next) => {
  try {
    const filters = await req.query.category;
    const { sort } = await req.params;
    //let filters = await req.query.filters;
    console.log(sort == "rating" ? "averageRating" : "totalCheckin");
    console.log("filters : " + filters);

    const data = await Location.findAll({
      where: { category: filters, locationStatus: "Approved" },
      order: [
        [sort == "rating" ? "averageRating" : "totalCheckin", "DESC"],
        ["locationName", "ASC"],
      ],
    });

    if (filters == 0) {
      const allData = await Location.findAll({
        where: { locationStatus: "Approved" },
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

exports.searchAdmin = async (req, res, next) => {
  try {
    const filters = await req.query.category;
    const { sort } = await req.params;
    //let filters = await req.query.filters;
    console.log(sort == "rating" ? "averageRating" : "totalCheckin");
    console.log("filters : " + filters);

    const data = await Location.findAll({
      where: { category: filters, locationStatus: { [Op.or]: ["Approved", "Deny"] } },
      order: [
        [sort == "rating" ? "averageRating" : "totalCheckin", "DESC"],
        ["locationName", "ASC"],
      ],
    });

    const result = await Promise.all(
      data.map(
        async ({
          updatedAt,
          locationId,
          locationName,
          category,
          type,
          createBy,
          locationStatus: status,
        }) => {
          try {
            let { username } = await User.findOne({ where: { id: createBy }, raw: true });
            console.log("createBy : ", data.createBy);
            return { updatedAt, username, locationId, locationName, category, type, status };
          } catch (err) {
            console.log(err);
            return res.status(400).send(err);
          }
        }
      )
    ).catch((err) => {
      console.log(err);
    });

    if (filters == 0) {
      const allData = await Location.findAll({
        where: { locationStatus: { [Op.or]: ["Approved", "Deny"] } },
        order: [
          [sort == "rating" ? "averageRating" : "totalCheckin", "DESC"],
          ["locationName", "ASC"],
        ],
      });

      const resultData = await Promise.all(
        allData.map(
          async ({
            updatedAt,
            locationId,
            locationName,
            category,
            type,
            createBy,
            locationStatus: status,
          }) => {
            try {
              let { username } = await User.findOne({ where: { id: createBy }, raw: true });
              console.log("createBy : ", data.createBy);
              return { updatedAt, username, locationId, locationName, category, type, status };
            } catch (err) {
              console.log(err);
              return res.status(400).send(err);
            }
          }
        )
      ).catch((err) => {
        console.log(err);
      });

      return res.status(200).json(resultData);
    }

    console.log(data);
    return res.status(200).json(result);
  } catch (err) {
    console.log(err);
  }
};

exports.getLocationRequested = async (req, res) => {
  try {
    const { role } = req.params;

    if (role != "admin") {
      return res.status(400).json({
        msg: "You are not allow to access this API",
        error: "your role is not admin",
      });
    }

    const requestedData = await Location.findAll({
      where: { locationStatus: "In progress" },
      raw: true,
    });
    console.log(requestedData);

    const result = await Promise.all(
      requestedData.map(
        async ({ updatedAt, locationId, locationName, category, type, createBy }) => {
          try {
            let { username } = await User.findOne({ where: { id: createBy }, raw: true });
            console.log("createBy : ", requestedData.createBy);
            return { updatedAt, username, locationId, locationName, category, type };
          } catch (err) {
            console.log(err);
            return res.status(400).send(err);
          }
        }
      )
    ).catch((err) => {
      console.log(err);
    });

    return res.status(200).json(result);
  } catch (err) {
    console.log(err);
    return res.status(400).send(err);
  }
};

exports.findByUser = async (req, res) => {
  try {
    const { userId } = req.params;

    const locationData = await Location.findAll({
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

exports.getType = async (req, res) => {
  try {
    const { category } = req.params;

    if (category == 1) {
      return res.status(200).json([
        { label: "สถานที่ผจญภัย", value: "สถานที่ผจญภัย" },
        { label: "สถานบันเทิง, ผับ, บาร์", value: "สถานบันเทิง, ผับ, บาร์" },
        { label: "ภูเขา, ป่าไม้, ธรรมชาติ", value: "ภูเขา, ป่าไม้, ธรรมชาติ" },
        { label: "ชายหาด, เกาะ", value: "ชายหาด, เกาะ" },
        { label: "สวน", value: "สวน" },
        { label: "พิพิธภัณฑ์", value: "พิพิธภัณฑ์" },
        { label: "วัด, โบราณสถาน", value: "วัด, โบราณสถาน" },
        { label: "ตลาด, ชุมชน, สถานที่ถ่ายภาพ", value: "ตลาด, ชุมชน, สถานที่ถ่ายภาพ" },
      ]);
    } else if (category == 2) {
      return res.status(200).json([
        { label: "อาหารเส้น", value: "อาหารเส้น" },
        { label: "อาหารตามสั่ง, จานด่วน", value: "อาหารตามสั่ง, จานด่วน" },
        { label: "สตรีทฟู้ด", value: "สตรีทฟู้ด" },
        { label: "ร้านอาหาร, ภัตราคาร", value: "ร้านอาหาร, ภัตราคาร" },
        { label: "ปิ้งย่าง, บุฟเฟ่ต์", value: "ปิ้งย่าง, บุฟเฟ่ต์" },
        { label: "คาเฟ่", value: "คาเฟ่" },
        { label: "ร้านกาแฟ", value: "ร้านกาแฟ" },
      ]);
    } else if (category == 3) {
      return res.status(200).json([
        { label: "รีสอร์ท", value: "รีสอร์ท" },
        { label: "แคมป์ปิ้ง", value: "แคมป์ปิ้ง" },
        { label: "โรงแรม", value: "โรงแรม" },
        { label: "บังกะโล, บ้านพัก", value: "บังกะโล, บ้านพัก" },
        { label: "โฮมสเตย์, เกสเฮาส์", value: "โฮมสเตย์, เกสเฮาส์" },
      ]);
    } else if (category == 4) {
      return res.status(200).json([
        { label: "ของกิน", value: "ของกิน" },
        { label: "ของใช้", value: "ของใช้" },
      ]);
    } else return null;
  } catch (err) {
    console.log(err);
    return res.status(400).send(err);
  }
};

exports.checkIn = async (req, res) => {
  try {
    const { locationId } = req.params;
    req.updatedAt = new Date();

    const updateData = await Location.increment("totalCheckin", {
      by: 1,
      where: { locationId },
      raw: true,
      returning: true,
    });

    return res.status(200).send(updateData[0][0][0]);
  } catch (err) {
    console.log(err);
    return res.status(400).send(err);
  }
};

exports.updateLocationStatus = async (req, res) => {
  try {
    const { locationId } = req.params;
    const location = req.body;
    req.updatedAt = new Date();

    if (
      location.type == "สถานที่ผจญภัย" ||
      location.type == "สถานบันเทิง, ผับ, บาร์" ||
      location.type == "สวน" ||
      location.type == "พิพิธภัณฑ์" ||
      location.type == "วัด, โบราณสถาน" ||
      location.type == "ตลาด, ชุมชน, สถานที่ถ่ายภาพ"
    ) {
      location.duration = 3;
    } else if (location.type == "ภูเขา, ป่าไม้, ธรรมชาติ" || location.type == "ชายหาด, เกาะ") {
      location.duration = 4;
    } else if (
      location.type == "อาหารเส้น" ||
      location.type == "อาหารตามสั่ง, จานด่วน" ||
      location.type == "สตรีทฟู้ด" ||
      location.type == "ร้านอาหาร, ภัตราคาร" ||
      location.type == "ปิ้งย่าง, บุฟเฟ่ต์"
    ) {
      location.duration = 2;
    } else if (location.type == "คาเฟ่" || location.type == "ร้านกาแฟ") {
      location.duration = 1;
    } else if (
      location.type == "รีสอร์ท" ||
      location.type == "แคมป์ปิ้ง" ||
      location.type == "โรงแรม" ||
      location.type == "บังกะโล, บ้านพัก" ||
      location.type == "โฮมสเตย์, เกสเฮาส์"
    ) {
      location.duration = 8;
    } else if (location.type == "ของกิน" || location.type == "ของใช้") {
      location.duration = 1;
    }

    if (location.category == 3) {
      const locationData = await Price.findOne({ where: { locationId }, raw: true });

      console.log(locationData);
      if (locationData == null) {
        const priceSet = await Price.create({
          locationId,
          min_price: location.min_price,
          max_price: location.max_price,
        });
      }

      const updatePrice = Price.update(
        { min_price: location.min_price, max_price: location.max_price },
        { where: { locationId }, raw: true, plain: true, returning: true }
      );
    }

    const updateData = Location.update(location, {
      where: { locationId },
      returning: true,
      plain: true,
      raw: true,
    });

    console.log(updateData);
    return res.status(200).json(updateData[1]);
  } catch (err) {
    console.log(err);
    return res.status(400).send(err);
  }
};

exports.findPopular = async (req, res) => {
  try {
    const popularData = await Location.findAll({
      where: { locationStatus: "Approved" },
      limit: 10,
      order: [["totalCheckin", "DESC"]],
      raw: true,
    });

    console.log(popularData);
    return res.status(200).json(popularData);
  } catch (err) {
    console.log(err);
    return res.status(400).send(err);
  }
};

exports.findNearBy = async (req, res) => {
  try {
    const { category } = req.params;
    const latUser = req.params.lat;
    const lonUser = req.params.lng;
    const lat = 18.767372356599942;
    const lon = 99.03631263889169;

    function distanceBetween(lat1, lon1) {
      const R = 6371; // metres
      const seta1 = (lat1 * Math.PI) / 180; // φ, λ in radians
      const seta2 = (latUser * Math.PI) / 180;
      const difSeta = ((latUser - lat1) * Math.PI) / 180;
      const difLamda = ((lonUser - lon1) * Math.PI) / 180;

      const a =
        Math.sin(difSeta / 2) * Math.sin(difSeta / 2) +
        Math.cos(seta1) * Math.cos(seta2) * Math.sin(difLamda / 2) * Math.sin(difLamda / 2);
      const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

      const d = R * c; // in metres

      return d;
    }

    if (category == 0) {
      const allLocationData = await Location.findAll({
        attributes: [
          "locationId",
          "locationName",
          "imageUrl",
          "description",
          "category",
          "latitude",
          "longitude",
        ],
        raw: true,
      });

      const dataAll = await allLocationData.map(
        ({ locationId, locationName, imageUrl, description, category, latitude, longitude }) => {
          return {
            locationId,
            locationName,
            imageUrl,
            description,
            category,
            latitude,
            longitude,
            ditanceFromeUser: distanceBetween(latitude, longitude),
          };
        }
      );

      return res.status(200).json(dataAll);
    }

    const locationData = await Location.findAll({
      where: { category },
      attributes: [
        "locationId",
        "locationName",
        "imageUrl",
        "description",
        "category",
        "latitude",
        "longitude",
      ],
      raw: true,
    });

    const data = await locationData.map(
      ({ locationId, locationName, imageUrl, description, category, latitude, longitude }) => {
        return {
          locationId,
          locationName,
          imageUrl,
          description,
          category,
          latitude,
          longitude,
          ditanceFromeUser: distanceBetween(latitude, longitude),
        };
      }
    );

    console.log(data);

    console.log("ระยะทาง : " + distanceBetween(lat, lon));

    return res.status(200).json(data);
  } catch (err) {
    console.log(err);
    return res.status(400).send(err);
  }
};

exports.delete = async (req, res) => {
  try {
    const { locationId } = req.params;

    const deleteData = await Location.destroy({ where: { locationId } });

    const reviewDelete = await Review.destroy({ where: { locationId } });

    return res
      .status(200)
      .send(
        "LocationId : " + locationId + "result: " + deleteData + "resultReview: " + reviewDelete
      );
  } catch (err) {
    return res.status(400).send(err);
  }
};
