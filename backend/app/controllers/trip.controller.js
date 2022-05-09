const db = require("../models");
const Location = db.locations;
const User = db.users;
const Trip = db.trips;
const TripItem = db.tripItems;

exports.create = async (req, res) => {
  try {
    const trip = req.body;
    const tripItemObj = req.body.tripItem;

    const { tripItem, ...newObjTrip } = trip;

    if (!trip.name) {
      res.status(400).send("trip name is required! !");
    }

    const newTrip = await Trip.create(newObjTrip);

    tripItemObj.forEach((item) => {
      item.tripId = newTrip.id;
    });

    const dataTripItem = await TripItem.bulkCreate(tripItemObj);

    console.log(dataTripItem);

    return res.status(201).json({
      newTrip,
    });
    //
  } catch (err) {
    res.status(400).send("Something wrong while creating new Trip!!");
    console.log(err);
  }
};

exports.findOne = async (req, res) => {
  try {
    const { id } = req.params;

    const tripData = await Trip.findOne({ where: { id }, raw: true });

    const tripItemData = await TripItem.findAll({ where: { tripId: tripData.id } });

    tripData.tripItem = tripItemData;
    console.log(tripData);

    return res.status(200).json(tripData);
  } catch (err) {
    return res.status(400).send(err);
  }
};
