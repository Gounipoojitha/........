const functions = require('firebase-functions');
const admin = require('firebase-admin');
const tf = require('@tensorflow/tfjs-node');
admin.initializeApp();

let anomalyModel;
async function loadModels() {
  anomalyModel = tf.sequential({
    layers: [
      tf.layers.dense({inputShape: [2], units: 1, activation: 'sigmoid'})
    ]
  });
  anomalyModel.compile({optimizer: 'adam', loss: 'binaryCrossentropy'});
}
loadModels();

exports.detectAnomaly = functions.https.onCall(async (data, context) => {
  if (!context.auth) throw new functions.https.HttpsError('unauthenticated', 'User not authenticated');
  const combinedData = data.combinedData;
  const input = tf.tensor([combinedData]);
  const prediction = anomalyModel.predict(input);
  const isAnomaly = prediction.dataSync()[0] < 0.5;
  return {isAnomaly};
});

exports.generateInsights = functions.firestore.document('users/{userId}/data/{dataId}').onCreate(async (snap, context) => {
  const data = snap.data();
  const sleepEff = data.sleepEfficiency;
  const stress = data.stressLevel;
  const recommendation = sleepEff < 0.8 ? 'Improve sleep hygiene' : 'Maintain routine';
  await admin.firestore().collection('insights').doc(context.params.userId).set({recommendation, timestamp: admin.firestore.FieldValue.serverTimestamp()});
});

exports.processNutrition = functions.https.onCall(async (data, context) => {
  const imageUrl = data.imageUrl;
  return {calories: 250, protein: 10};
});