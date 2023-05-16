const pushNotificationContoller = require("../controllers/push_notifications_controller");

const express = require("express");
const notificationRouter = express.Router();

notificationRouter.post("/api/send-notification/", pushNotificationContoller.sendPushNotification);
 
module.exports = notificationRouter;