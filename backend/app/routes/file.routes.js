module.exports = (app) => {
  const fileWorker = require("../controllers/file.controller.js");

  var router = require("express").Router();

  let upload = require("../config/multer.config.js");

  let path = __basedir + "/views/";

  router.get("/", (req, res) => {
    res.sendFile(path + "index.html");
  });

  router.post("/upload", upload.single("file"), fileWorker.uploadFile);
  router.post("/multiple/upload", upload.array("file", 4), fileWorker.uploadMultipleFiles);

  router.get("/info", fileWorker.listAllFiles);

  router.get("/:id", fileWorker.downloadFile);

  app.use("/api/file", router);
};
