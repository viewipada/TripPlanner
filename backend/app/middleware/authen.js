const jwt = require("jsonwebtoken");
const config = process.env;
exports.verifyToken = (req, res, next) => {
  const token = req.headers["x-access-token"];

  if (!token) {
    return res.status(403).send("A token is required for authentication");
  }
  try {
    const decoded = jwt.verify(token, config.TOKEN_KEY);
    req.user = decoded;
    // console.log(req.user.role);
  } catch (err) {
    return res.status(401).send("Invalid Token");
  }
  return next();
};

exports.checkAdmin = (req, res, next) => {
  const token = req.headers["x-access-token"];
  if (!token) {
    return res.status(403).send("A token is required for authentication");
  }
  try {
    const decoded = jwt.verify(token, config.TOKEN_KEY);
    if (decoded.role == "admin") {
      req.user = decoded;
      return next();
    } else {
      return res.status(400).send("Admin Role is Required");
    }
  } catch (err) {
    return res.status(401).send("Invalid Token");
  }
};
