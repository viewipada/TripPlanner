const db = require("../models");
const Review = db.reviews;
const User = db.users;
const Location = db.locations;
const Op = db.Sequelize.Op;
const Sequelize = db.Sequelize;
const sequelize = db.sequelize;

exports.create = async (req, res) => {
  try {
    // Validate request
    if (!req.body.userId) {
      return res.status(400).send({
        message: "userId can not be empty!",
      });
    }

    // Create a Location
    const review = ({
      userId,
      locationId,
      reviewRate,
      reviewCaption,
      reviewImg1,
      reviewImg2,
      reviewImg3,
    } = req.body);

    // Save Location in the database
    const reviewData = await Review.create(review);

    const l = await Location.findOne({ where: review.locationId });
    await l.increment("totalReview");
    await l.reload();
    console.log(l);

    const data = await Review.findAll({
      where: review.locationId,
      attributes: [[sequelize.fn("AVG", sequelize.col("reviewRate")), "avgRating"]],
      group: ["locationId"],
      raw: true,
    });

    console.log(data);

    const locationData = await Location.update(
      { totalReview: l.totalReview, averageRating: data.avgRating },
      { where: { locationId }, returning: true, plain: true }
    );

    console.log(locationData);
    return res.status(200).json(reviewData);
  } catch (err) {
    res.status(400).send("Something wrong while creating Review");
    console.log(err);
  }
};

exports.findAllReviewLocation = async (req, res) => {
  try {
    const { locationId } = req.params;

    const data = await Review.findAll({
      where: {
        locationId,
      },
      attributes: [[sequelize.fn("AVG", sequelize.col("reviewRate")), "avgRating"]],
      group: ["locationId"],
      raw: true,
    });

    // const data = await Promise.all(
    //   reviewData.map(
    //     async ({
    //       userId,
    //       reviewRate: rating,
    //       reviewCaption: caption,
    //       reviewImg1,
    //       reviewImg2,
    //       reviewImg3,
    //       createdAt,
    //     }) => {
    //       let { imgUrl: profileImage, username } = await User.findOne({
    //         where: {
    //           id: userId,
    //         },
    //         raw: true,
    //       });

    //       return {
    //         profileImage,
    //         username,
    //         rating,
    //         caption,
    //         images: [reviewImg1, reviewImg2, reviewImg3].filter((image) => image),
    //         createdAt,
    //       };
    //     }
    //   )
    // );
    return res.status(200).json(data);
  } catch (err) {
    console.log(err);
    return res.status(400).send("Something wrong while finding review");
  }
};

exports.findAll = async (req, res) => {
  try {
    const locationId = req.query.locationId;

    console.log(locationId);

    Review.findAll({ where: { locationId } });
    let reviewData = await Review.findAll({
      where: {
        locationId,
      },
      raw: true,
    });

    console.log(reviewData);

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

    console.log(data);

    return res.status(200).json(data);
  } catch (err) {
    return res.status(400).send(err);
  }
};

exports.findOriginalReview = async (req, res) => {
  try {
    const uid = req.params.userId;
    const lid = req.params.locationId;

    const reviewData = await Review.findOne({ where: { userId: uid, locationId: lid }, raw: true });

    if (reviewData == null) {
      return res.status(204).send({ msg: "no review" });
    }

    console.log(reviewData);

    if (reviewData != null) {
      const { imgUrl: profileImage, username } = await User.findOne({
        where: { id: uid },
        rew: true,
      });
      reviewData.profileImage = profileImage;
      reviewData.username = username;
      reviewData.rating = reviewData.reviewRate;
      reviewData.caption = reviewData.reviewCaption;
      reviewData.images = [reviewData.reviewImg1, reviewData.reviewImg2, reviewData.reviewImg3];
    }

    const {
      userId,
      locationId,
      reviewRate,
      reviewCaption,
      reviewImg1,
      reviewImg2,
      reviewImg3,
      updatedAt,
      ...newReview
    } = reviewData;

    return reviewData != null
      ? res.status(200).json(newReview)
      : res.status(503).send("There's no review from this user");
  } catch (err) {
    console.log(err);

    return res.status(400).send("something wrong while finding review");
  }
};

exports.update = async (req, res) => {
  try {
    const review = req.body;
    req.updatedAt = new Date();

    const updateData = await Review.update(review, {
      where: {
        userId: review.userId,
        locationId: review.locationId,
      },
      returning: true,
      plain: true,
      raw: true,
    });

    console.log(updateData);
    return res.status(200).send(updateData[1]);
  } catch (err) {
    console.log(err);
    return res.status(400).send("something wrong while updating review");
  }
};

exports.delete = async (req, res) => {
  try {
    const { userId, locationId } = req.params;

    const deleteData = await Review.destroy({ where: { userId, locationId } });

    console.log(deleteData);

    return res.status(200).json(deleteData);
  } catch (err) {
    console.log(err);
    return res.status(400).send("Something wrong while deleting reviews");
  }
};
