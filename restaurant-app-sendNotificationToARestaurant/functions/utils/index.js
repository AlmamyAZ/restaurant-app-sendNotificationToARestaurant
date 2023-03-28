/* eslint-disable prettier/prettier */
// const functions = require("firebase-functions");
const admin = require("firebase-admin");
const db = admin.firestore();

const OrderStatus = {
  waitingRestaurantConfirmation: 0,
  processingByRestaurant: 1,
  delivering: 2,
  completed: 3,
  rejectedByRestaurant: 4,
  canceledByUser: 5,
  waitingForPickup: 6,
  cooking: 7,
};
const getUserDocRef = (userId) => {
  return db.collection("users").doc(userId);
};
const getUserSubCollectionRef = (userId, subCollectionName) => {
  const userDocRef = getUserDocRef(userId);
  return userDocRef.collection(subCollectionName);
};
const markNotificationAsRead = (data) => {
  const userRef = getUserDocRef(data);
  const subcollectionRef = userRef.collection("notifications");
  const newNotificationRef = subcollectionRef.doc(data.notificationId);
  newNotificationRef
    .set(
      {
        isRead: true,
      },
      { merge: true }
    )
    .then(() => {
      console.log("document was updated succesfuly : 👍👍👍");
    })
    .catch((error) => {
      console.log("document was not updated succesfuly 😞😞😞😞", error);
    });
};
const deleteAllNotifications = async (data) => {
  const userId = data.userId;
  const notificationIds = data.notificationIds;

  const subcollectionRef = getUserSubCollectionRef(userId, "notifications");

  const batch = db.batch();
  notificationIds.forEach((notificationId) => {
    const docRef = subcollectionRef.doc(notificationId);
    batch.delete(docRef);
  });
  await batch.commit();
  return { message: "documents supprimes avec succes 👌👌👌" };
};
const markAllNotificationsAsRead = async (data) => {
  const userId = data.userId;
  const unReadNotificationIds = data.unReadNotificationIds;
  const subcollectionRef = getUserSubCollectionRef(userId, "notifications");
  const batch = db.batch();
  unReadNotificationIds.forEach((unReadNotificationId) => {
    const docRef = subcollectionRef.doc(unReadNotificationId);
    batch.set(
      docRef,
      {
        isRead: true,
      },
      {
        merge: true,
      }
    );
  });
  // Commit the batch
  batch
    .commit()
    .then(() => {
      console.log("Batch write succeeded.🔎🔎🔎");
    })
    .catch((error) => {
      console.error("Batch write failed: ", error);
    });
};
const orderStatuMessages = (status) => {
  if (status == OrderStatus.waitingRestaurantConfirmation) {
    return "Votre commande est en attente de confirmation";
  }
  if (status == OrderStatus.processingByRestaurant) {
    return "Votre commande a été acceptée";
  }
  if (status == OrderStatus.delivering) {
    return "Votre commande est en cours de livraison";
  }
  if (status == OrderStatus.completed) {
    return "Votre commande est prête pour la livraison";
  }
  if (status == OrderStatus.rejectedByRestaurant) {
    return "Votre commande a été refusée";
  }
  if (status == OrderStatus.canceledByUser) {
    return "Vous avez annuler votre commande";
  }
  if (status == OrderStatus.waitingForPickup) {
    return "Votre commande est en attente de confirmation";
  }
  if (status == OrderStatus.cooking) {
    return "Votre commande est en cours de préparation";
  }
  return "Le statut de votre commande est inconnu.";
};

const createNotification = (notification, userId) => {
  // Get a reference to the user document
  const userRef = db.collection("users").doc(userId);

  // Get a reference to the subcollection
  const subcollectionRef = userRef.collection("notifications");

  // Create a new document in the subcollection
  const newNotificationRef = subcollectionRef.doc();

  const newNotificationData = {
    title: notification.notification.title,
    content: notification.notification.body,
    isRead: false,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  };
  // create notification
  newNotificationRef
    .set(newNotificationData)
    .then(() => {
      console.log("document created succefuly : ❤️❤️❤️❤️");
    })
    .catch((error) => {
      console.log("document not created 👍👍👍", error);
    });
  return notification;
};
module.exports = {
  orderStatuMessages,
  createNotification,
  markNotificationAsRead,
  markAllNotificationsAsRead,
  deleteAllNotifications,
};
