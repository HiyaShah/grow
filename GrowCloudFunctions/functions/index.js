const functions = require('firebase-functions');
const admin = require('firebase-admin')

admin.initializeApp();

const stripe = require("stripe")(functions.config().stripe.secret_test_key);

exports.createStripeCustomer = functions.firestore.document('users/{userId}').onCreate(async (snap, context) => {
    const data = snap.data();
    const email = data.email;

    const customer = await stripe.customers.create({email: email})
    return admin.firestore().collection('users').doc(data.id).update({stripeId: customer.id})
});

exports.createEphemeralKey = functions.https.onCall(async (data, context) => {

    const customerId = data.customer_id;
    const stripeVersion = data.stripe_version;
    const uid = context.auth.uid;

    if(uid === null) {
        console.log('Illegal access attempt due to unauthenticated user');
        throw new functions.https.HttpsError('permission-denied', 'Illegal access attempt')
    }

    return stripe.EphemeralKeys.create(
        {customer: customerId},
        {stripe_version: stripeVersion}
    ).then((key)=> {
        return key
    }).catch((err) => {
        console.log(err)
        throw new functions.https.HttpsError('internal', 'Unable to create ephemeral key')
    })
})

// exports.helloWorld = functions.https.onRequest((request, response) => {
//     console.log("this is console message")
//  response.send("Hello from hiya!");
// });


