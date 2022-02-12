const db = require("../models");
const User = db.User;
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

exports.register = (req, res) => {
  const { username, password, role } = req.body;

  if (!(username && password && role)) {
    res.status(400).json({
      status: 400,
      msg: "All input is required",
      success: false,
      data: {},
    });
  }

  const oldUser = User.findOne({
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

  // Encrypt Password
  bcrypt
    .hash(password, 10)
    .then((encryptedPassword) => {
      const user = User.create({
        username: username,
        password: encryptedPassword,
        role: role,
      }).then((data) => {
        // Create token
        const token = jwt.sign(
          { user_id: data.id, username: username, role: role },
          process.env.TOKEN_KEY,
          {
            expiresIn: "8h",
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
      });
    })
    .catch((err) => {
      res.status(500).json({
        status: 500,
        msg: err.message,
        success: false,
        data: {},
      });
    });
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
                expiresIn: "8h",
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
