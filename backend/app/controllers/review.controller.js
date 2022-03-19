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

    const data = await Review.findAll({
      where: review.locationId,
      attributes: [[sequelize.fn("AVG", sequelize.col("reviewRate")), "avgRating"]],
      group: ["locationId"],
      raw: true,
    });
    console.log(data);

    const l = await Location.findOne({ where: review.locationId });
    await l.increment("totalReview");
    await l.reload();
    console.log(l);

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

exports.findAll = (req, res) => {
  const { locationId } = req.query;
  var condition = locationId ? { locationId: { [Op.iLike]: `%${locationId}%` } } : null;

  Review.findAll({ where: condition })
    .then((data) => {
      res.send(data);
    })
    .catch((err) => {
      res.status(500).send({
        message: err.message || "Some error occurred while retrieving tutorials.",
      });
    });
};

exports.delete = async (req, res) => {
  try {
    const { userId, locationId } = req.params;

    const deleteData = await Review.destroy({ where: { userId, locationId } });

    const loc = await Location.findOne({ where: locationId });
    await loc.decrement("totalReview");
    await loc.reload();

    console.log(deleteData);

    return res.status(200).json(deleteData);
  } catch (err) {
    console.log(err);
    return res.status(400).send("Something wrong while deleting reviews");
  }
};
