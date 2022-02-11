const db = require("../models");
const Review = db.reviews;
const User = db.users;
const Op = db.Sequelize.Op;

exports.create = (req, res) => {
  // Validate request
  if (!req.body.userId) {
    res.status(400).send({
      message: "userId can not be empty!",
    });
    return;
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
  Review.create(review)
    .then((data) => {
      res.status(201).send(data);
    })

    .catch((err) => {
      res.status(500).send({
        message: err.message || "Some error occurred while creating the Location.",
      });
    });
};

exports.findAllReviewLocation = async (req, res) => {
  const { locationId } = req.params;

  let reviewData = await Review.findAll({
    where: {
      locationId,
    },
    raw: true,
  });

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
  return res.status(200).json(data);
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
