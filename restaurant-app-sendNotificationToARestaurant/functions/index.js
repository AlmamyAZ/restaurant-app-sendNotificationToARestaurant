const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const {
  orderStatuMessages,
  createNotification,
  markNotificationAsRead,
  markAllNotificationsAsRead,
  deleteAllNotifications,
} = require("./utils");

exports.markAllNotificationsAsRead = functions.https.onCall((data, context) => {
  return markAllNotificationsAsRead(data);
});

exports.deleteAllNotifications = functions.https.onCall((data, context) => {
  return deleteAllNotifications(data);
});
exports.readNotification = functions.https.onCall((data, context) => {
  return markNotificationAsRead(data);
});

exports.sendOrderNotificationToRestaurant = functions.firestore
  .document("orders/{orderId}")
  .onCreate(async (change, context) => {
    const order = change.data();
    const waiterId = order.waiterId;
    const restaurantName = order.restaurantName;
    const waiterFcmToken = await admin
      .firestore()
      .collection("users")
      .doc(waiterId)
      .get()
      .then((doc) => doc.data().fcmToken);
    const userNotification = {
      notification: {
        title: `${restaurantName}`,
        body: "Vous avez une commande en attente de confirmation",
      },
      token: waiterFcmToken,
    };
    return await admin.messaging().send(userNotification);
  });

exports.sendOrderAcceptedNotification = functions.firestore
  .document("orders/{orderId}")
  .onUpdate(async (change, context) => {
    const previousOrder = change.before.data();
    const order = change.after.data();

    const oldstatus = previousOrder.status;
    const newStatus = order.status;
    const restaurantName = order.restaurantName;

    if (oldstatus === newStatus || newStatus === 0) {
      return;
    }
    const notificationMessage = orderStatuMessages(newStatus);

    const userId = order.userId;
    const userFcmToken = await admin
      .firestore()
      .collection("users")
      .doc(userId)
      .get()
      .then((doc) => doc.data().fcmToken);
    const userNotification = {
      notification: {
        title: `${restaurantName}`,
        body: notificationMessage,
      },
      token: userFcmToken,
    };
    createNotification(userNotification, userId);
    return await admin.messaging().send(userNotification);
  });
