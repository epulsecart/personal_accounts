const {onDocumentCreated, onDocumentUpdated} =
require("firebase-functions/v2/firestore");
const {initializeApp} = require("firebase-admin/app");
const {getFirestore} = require("firebase-admin/firestore");
const {getMessaging} = require("firebase-admin/messaging");

initializeApp();

const db = getFirestore();
const messaging = getMessaging();

// 🔧 Helper: Load user info
const getUserInfo = async (uid) => {
  const snap = await db.collection("users").doc(uid).get();
  return snap.exists ? snap.data() : null;
};

// 🔔 1. On Transaction Created → Notify other participant
exports.onTransactionCreated =
onDocumentCreated("groups/{groupId}/transactions/{txnId}", async (event) => {
  const data = event.data.data();
  const {groupId} = event.params;
  if (!data) {
    console.log("❌ No data in transaction document.");
    return;
  }
  const {
    createdBy,
    fromUserId,
    toUserId,
    amount,
    description,
  } = data;
  console.log("🔥Transaction:", {createdBy, fromUserId, toUserId, groupId});

  const otherUserId = createdBy === fromUserId ? toUserId : fromUserId;

  const [creatorInfo, otherUserInfo, groupSnap] = await Promise.all([
    getUserInfo(createdBy),
    getUserInfo(otherUserId),
    db.collection("groups").doc(groupId).get(),
  ]);

  if (!creatorInfo || !otherUserInfo || !groupSnap.exists) {
    console.log("❌", {creatorInfo, groupExists: groupSnap.exists});
    return;
  }

  const fcmToken = otherUserInfo.fcmToken;
  const lang = otherUserInfo.language || "en";
  const creatorName = creatorInfo.name || "Someone";
  const groupName = groupSnap.data().name || "the group";

  const title = lang === "ar" ?
    `معاملة جديدة تمت إضافتها في ${groupName}` :
    `New transaction in ${groupName}`;
  const body = lang === "ar" ?
    `تمت إضافة معاملة بواسطة ${creatorName} بمبلغ ${amount} لـ ${description}` :
    `New transaction added ${creatorName},amount:${amount} for ${description}`;
  console.log("📨 Ready to send FCM", {fcmToken, title, body});

  if (fcmToken) {
    await messaging.send({
      token: fcmToken,
      notification: {title, body},
      data: {
        click_action: "FLUTTER_NOTIFICATION_CLICK",
        type: "transaction",
        groupId: groupId,
      },
    });
    console.log("✅ Notification sent!");
  } else {
    console.log("⚠️ No FCM token found for other user.");
  }
});

// 🔔 2. On Join Request Created → Notify Admin
exports.onJoinRequestCreated =
onDocumentCreated("groups/{groupId}/joinRequests/{reqId}", async (event) => {
  const data = event.data.data();
  const {groupId} = event.params;
  const {inviteeId, requesterId} = data;

  const [inviteeInfo, requesterInfo, groupSnap] = await Promise.all([
    getUserInfo(inviteeId),
    getUserInfo(requesterId),
    db.collection("groups").doc(groupId).get(),
  ]);

  if (!inviteeInfo || !requesterInfo || !groupSnap.exists) return;

  const fcmToken = inviteeInfo.fcmToken;
  const lang = inviteeInfo.language || "en";
  const requesterName = requesterInfo.name || "A user";
  const groupName = groupSnap.data().name || "your group";

  const title = lang === "ar" ?
    `طلب انضمام جديد في ${groupName}` :
    `New join request in ${groupName}`;
  const body = lang === "ar" ?
    `${requesterName} طلب الانضمام للمجموعة. وافق أو ارفض الطلب الآن.` :
    `${requesterName} wants to join the group. Approve or reject now.`;

  if (fcmToken) {
    await messaging.send({
      token: fcmToken,
      notification: {title, body},
      data: {
        type: "join_request",
        groupId,
        requesterId,
      },
    });
  }
});

// 🔔 3. On Join Request Approved → Notify the Requester
exports.onJoinRequestApproved =
onDocumentUpdated("groups/{groupId}/joinRequests/{reqId}", async (event) => {
  const before = event.data.before.data();
  const after = event.data.after.data();

  if (before.status === after.status || after.status !== "approved") return;

  const {groupId} = event.params;
  const requesterId = after.requesterId;

  const [requesterInfo, groupSnap] = await Promise.all([
    getUserInfo(requesterId),
    db.collection("groups").doc(groupId).get(),
  ]);

  if (!requesterInfo || !groupSnap.exists) return;

  const fcmToken = requesterInfo.fcmToken;
  const lang = requesterInfo.language || "en";
  const groupName = groupSnap.data().name || "the group";

  const title = lang === "ar" ?
    `تمت الموافقة على انضمامك` :
    `You’ve been approved`;
  const body = lang === "ar" ?
    `أنت الآن عضو رسمي في مجموعة ${groupName}` :
    `You're now a member of ${groupName}`;

  if (fcmToken) {
    await messaging.send({
      token: fcmToken,
      notification: {title, body},
      data: {
        type: "join_approved",
        groupId,
      },
    });
  }
});
