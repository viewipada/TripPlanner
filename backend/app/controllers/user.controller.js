const db = require("../models");
const User = db.users;
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

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
      process.env.TOKEN_KEY,
      { expiresIn: "8h" }
    );

    user.token = token;

    return res.status(201).json({
      id: user.id,
      username: user.username,
      token,
    });
  } catch (err) {
    console.log(err);
  }
};

exports.login = (req, res) => {
  const { username, password } = req.body;
  if (!(username && password)) {
    res.status(400).json({
      status: 400,
      msg: "All input is required",
      success: false,
      data: {},
    });
  }

  User.findOne({ where: { username: username } })
    .then((data) => {
      if (data) {
        bcrypt.compare(password, data.password).then((same) => {
          if (same) {
            const token = jwt.sign(
              { user_id: data.id, username: username, role: data.role },
              process.env.TOKEN_KEY,
              {
                expiresIn: "10h",
              }
            );
            const result = {
              id: data.id,
              username: data.username,
              password: data.password,
              role: data.role,
              token: token,
            };
            res.status(200).json(result);
          } else {
            res.status(400).json({
              status: 400,
              msg: "INVALID PASSWORD",
              success: false,
              data: {},
            });
          }
        });
      } else {
        res.status(400).json({
          status: 400,
          msg: "INVALID USERNAME OR PASSWORD",
          success: false,
          data: {},
        });
      }
    })
    .catch((err) => {
      return res.status(500).json({
        status: 500,
        msg: err.message,
        success: false,
        data: {},
      });
    });
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
