const db = require("../models");
const User = db.users;
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const tokenKey = require("../config/authen.config");

exports.register = async (req, res) => {
  try {
    const { username, password, role } = req.body;

    if (!(username && password && role)) {
      res.status(400).json({
        status: 400,
        msg: "All input is required",
        success: false,
        data: {},
      });
    }

    const oldUser = await User.findOne({
      where: {
        username: username,
      },
    }).then((user) => {
      if (user) {
        return res.status(409).json({
          status: 409,
          msg: "User already exist. Please login",
          success: false,
          data: {},
        });
      }
    });

    encryptedPassword = await bcrypt.hash(password, 10);

    const u = { username: username, password: encryptedPassword, role: role };
    console.log(u);

    const user = await User.create(u);

    const token = jwt.sign(
      {
        user_id: user.id,
        username: username,
        role: role,
      },
      tokenKey.secret,
      { expiresIn: "15d" }
    );

    user.token = token;

    return res.status(201).json({
      token,
    });
  } catch (err) {
    console.log(err);
  }
};

exports.login = async (req, res) => {
  try {
    const { username, password } = req.body;

    if (!(username && password)) {
      res.status(400).send("All input is required");
    }

    const user = await User.findOne({ where: { username }, raw: true });

    console.log(user);

    if (user && (await bcrypt.compare(password, user.password))) {
      const token = jwt.sign(
        {
          user_id: user.id,
          username: username,
          role: user.role,
        },
        tokenKey.secret,
        { expiresIn: "15d" }
      );

      // user.token = token;

      return res.status(200).json(token);
    }

    return res.status(400).send("Invalid Credentials");
  } catch (err) {
    console.log(err);
  }
};

exports.changePassword = (req, res) => {
  const id = req.body.id;
  req.updatedAt = new Date();
  User.update(req.body, {
    where: {
      id: id,
    },
    returning: true,
    plain: true,
  })
    .then((data) => {
      if (data) {
        res.status(200).json({
          status: 200,
          msg: "Update #" + id + " User Success",
          success: true,
          data: data[1].dataValues,
        });
      } else {
        res.status(400).json({
          status: 400,
          msg: "Update #" + id + " User Fail",
          success: false,
          data: [],
        });
      }
    })
    .catch((err) => {
      res.status(500).json({
        status: 500,
        msg: "Error updating User with id=" + id,
        success: false,
        data: [],
      });
    });
};

exports.delete = (req, res) => {
  const id = req.params.id;
  User.destroy({
    where: {
      id: id,
    },
  })
    .then((num) => {
      if (num == 1) {
        res.status(200).json({
          status: 200,
          msg: "Delete #" + id + " User Success",
          success: true,
          data: [],
        });
      } else {
        res.status(400).json({
          status: 400,
          msg: "Update #" + id + " User Fail",
          success: false,
          data: [],
        });
      }
    })
    .catch((err) => {
      res.status(500).json({
        status: 500,
        msg: "Error deleting User with id=" + id,
        success: false,
        data: [],
      });
    });
};
