const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const { getFirestore, FieldValue } = require("firebase-admin/firestore");
const { initializeApp } = require("firebase-admin/app");

initializeApp();
const db = getFirestore();

exports.onBatchCreated = onDocumentCreated("batches/{batchId}", async (event) => {
    const batch = event.data.data();

    try {
        // Validate batch.name and batch.courseID
        if (!batch.name || !batch.courseID) {
            console.error("Invalid batch data: batch.name or batch.courseID is missing");
            return false;
        }

        const batchName = batch.name.toUpperCase();
        const courseID = batch.courseID.toUpperCase();

        // Step 1: Get course data from the "courses" collection using courseID
        const courseDoc = await db.collection("courses").doc(courseID).get();

        if (!courseDoc.exists) {
            console.error(`Course with ID ${courseID} not found`);
            return false;
        }

        const courseData = courseDoc.data();

        // Step 2: Add batch data to "courses/{courseID}/instances/{batchName}"
        await db
            .collection("courses")
            .doc(courseID)
            .collection("instances")
            .doc(batchName)
            .set(courseData);

        // Step 4: Get the list of all users
        const userCollectionData = await db.collection("users").get();
        const adminDoc = userCollectionData.docs.find((doc) => doc.data().userRole === "superAdmin");
        const adminData = adminDoc ? adminDoc.data() : null;

        if (!adminData) {
            console.error("No superAdmin found");
            return false;
        }

        // Step 5: Convert the array of single-key objects into a single object
        const transformedStaffsBatch = batch.staffs.reduce((acc, staff) => {
            const [key, value] = Object.entries(staff)[0];
            acc[key] = value;
            return acc;
        }, {});

        const staffEmails = Object.values(transformedStaffsBatch);

        // Initialize membersData with admin data
        const membersData = {
            admin: {
                name: adminData.name,
                imagePath: adminData.imagePath,
                userRole: "superAdmin",
            },
        };

        // Step 6: Process staff members and add them to the membersData
        for (const email of staffEmails) {
            const userDoc = userCollectionData.docs.find((doc) => doc.id === email);

            if (!userDoc) {
                console.error(`User with email ${email} not found`);
                continue;
            }

            const userData = userDoc.data();
            membersData[email] = {
                name: userData.name,
                imagePath: userData.imagePath || "",  // Use the correct imagePath if available
                userRole: "staff",
            };

            await db
                .collection("users")
                .doc(email)
                .set(
                    {
                        batches: FieldValue.arrayUnion(batchName),
                    },
                    { merge: true }
                );

            await db
                .collection("forum")
                .doc(`${email}|admin`)
                .set(
                    {
                        members: {
                            admin: {
                                name: adminData.name,
                                imagePath: adminData.imagePath,
                                userRole: "superAdmin",
                            },
                            [email]: {
                                name: userData.name,
                                imagePath: userData.imagePath || "",  // Use the correct imagePath if available
                                userRole: "staff",
                            },
                        },
                        details: {
                            name: "admin",
                        },
                        [`admin|${new Date().toISOString()}`]: {
                            text: `Welcome aboard to our dedicated staff joining the new batch ${batchName} at Vectra Advantage Pro! Wishing you an enriching teaching experience filled with passion and dedication. Let's inspire our students to embrace and love every aspect of this certification course journey!`,
                            from: "admin",
                            time: new Date().toISOString(),
                        },
                    },
                    { merge: true }
                );
        }

        // Step 7: Add remaining batch details to the forum
        await db
            .collection("forum")
            .doc(batchName)
            .set(
                {
                    members: membersData,
                    details: {
                        name: batchName,
                        image: courseData.image,  // Assuming courseData contains an "image" field
                    },
                    [`admin|${new Date().toISOString()}`]: {
                        text: `A heartfelt welcome to all our students at Vectra Advantage Pro - where learning meets excellence, and success is a shared journey!`,
                        from: "admin",
                        time: new Date().toISOString(),
                    },
                },
                { merge: true }
            );

        return true;
    } catch (error) {
        console.error("Error processing batch:", error);
        return false;
    }
});

exports.onUserSignup = onDocumentCreated("users/{userId}", async (event) => {
    const user = event.data.data();

    try {
        // Step 1: Check if the user is a student and has signed up for any batches
        if (user.userRole === "student" && user.currentBatch) {
            for (const [batchName, batchId] of Object.entries(user.currentBatch)) {
                // Step 2: Add student to the forum
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
            }
        }

        return true;
    } catch (error) {
        console.error("Error processing user signup:", error);
        return false;
    }
});
