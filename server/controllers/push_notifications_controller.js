const admin = require("firebase-admin")

var serviceAccount = require('../config/push_notification_key.json');

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
});

exports.sendPushNotification = (req, res, next) => {
    try{
        let message = { 
            notification: {
                title: req.query.title,
            },
            token: req.query.fcmToken,
        } 

        admin.messaging().send(message).then((response) => {
            res.status(200).send({
                message:"Notification Sent",
            });
            console.log('Successfully sent message:', response);
        }).catch((error) => {
            console.log('Error sending message:', error);});

    } catch (err) {
        throw err;
    }
};
