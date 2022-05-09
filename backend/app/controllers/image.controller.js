exports.uploadImage = async (req, res) => {
  try {
    if (!req.files) {
      return res.send({
        status: false,
        message: "No file uploaded",
      });
    } else {
      //Use the name of the input field (i.e. "avatar") to retrieve the uploaded file
      let file = req.files.file;

      //Use the mv() method to place the file in upload directory (i.e. "uploads")
      file.mv("./uploads/" + file.name);

      //send response
      return res.send({
        status: 200,
        message: "File is uploaded",
        name: file.name,
      });
    }
  } catch (err) {
    return res.status(500).send(err);
  }
};
