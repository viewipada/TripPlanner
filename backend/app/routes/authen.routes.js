module.exports = (app) => {
  const user = require("../controllers/user.controller.js");
  const middle = require("../middleware/authen");
  const verifyToken = middle.verifyToken;
  const checkAdmin = middle.checkAdmin;
  var router = require("express").Router();

  app.use((req, res, next) => {
    res.header("Access-Control-Allow-Headers", "x-access-token, Origin, Content-Type, Accept");
    next();
  });

  // router.post("/", verifyToken, (req, res) => {
  //   res.status(200).send("Welcome 👍");
  // });

  // register
  router.post("/register", user.register);

  // login
  router.post("/login", user.login);

  // router.put("/", user.changePassword);

  // router.delete("/:id", user.delete);

  app.use("/auth", router);
};
