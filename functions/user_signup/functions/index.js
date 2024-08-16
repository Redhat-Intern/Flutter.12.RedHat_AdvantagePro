const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const { getFirestore, FieldValue } = require("firebase-admin/firestore");
const { initializeApp } = require("firebase-admin/app");

initializeApp();
const db = getFirestore();

exports.onUserSignup = onDocumentCreated("users/{userId}", async (event) => {
    const user = event.data.data();

    //  Get the list of all users
    const userCollectionData = await db.collection("users").get();
    const adminDoc = userCollectionData.docs.find((doc) => doc.data().userRole === "superAdmin");
    const adminData = adminDoc ? adminDoc.data() : null;

    try {
        // Step 1: Check if the user is a student and has signed up for any batches
        if (user.userRole === "student" && user.currentBatch) {
            for (const [batchName, batchId] of Object.entries(user.currentBatch)) {
                // Add student to the batch forum
                await db
                    .collection("forum")
                    .doc(batchName.toUpperCase())
                    .set(
                        {
                            members: {
                                [user.email]: {
                                    name: user.name,
                                    imagePath: user.imagePath,
                                    userRole: "student",
                                },
                            },
                        },
                        { merge: true }
                    );

                // Add a welcome message to the student's forum
                await db
                    .collection("forum")
                    .doc(`${user.email}|admin`)
                    .set(
                        {
                            members: {
                                admin: {
                                    name: adminData.name,
                                    imagePath: adminData.imagePath,
                                    userRole: "superAdmin",
                                },
                                [user.email]: {
                                    name: user.name,
                                    imagePath: user.imagePath || "",  // Use the correct imagePath if available
                                    userRole: "student",
                                },
                            },
                            details: {
                                name: "admin",
                            },
                            [`admin|${new Date().toISOString()}`]: {
                                text: `Welcome to Vectra Advantage Pro! We’re excited to have you on board for this certification journey. Get ready to dive into a world of learning, growth, and success. Let’s make the most of this experience and conquer every challenge together!`,
                                from: "admin",
                                time: new Date().toISOString(),
                            },
                        },
                        { merge: true }
                    );
            }
        } else if (user.userRole === "staff" || user.userRole === "admin") {
            // Create a forum entry for the staff/admin
            await db
                .collection("forum")
                .doc(`${user.email}|admin`)
                .set(
                    {
                        members: {
                            [user.email]: {
                                name: user.name,
                                imagePath: user.imagePath || "",  // Use the correct imagePath if available
                                userRole: user.userRole,
                            },
                            admin: {
                                name: adminData.name,
                                imagePath: adminData.imagePath,
                                userRole: "superAdmin",
                            },
                        },
                        details: {
                            name: user.name,
                        },
                        [`admin|${new Date().toISOString()}`]: {
                            text: `Welcome to Vectra Advantage Pro, ${user.userRole}! We are thrilled to have you as part of our team. We look forward to achieving great things together. Let's get started!`,
                            from: "admin",
                            time: new Date().toISOString(),
                        },
                    },
                    { merge: true }
                );
        }

        return true;
    } catch (error) {
        console.error("Error processing user signup:", error);
        return false;
    }
});
