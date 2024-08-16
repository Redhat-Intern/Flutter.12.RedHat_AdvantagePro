const { onDocumentCreated, onDocumentDeleted } = require("firebase-functions/v2/firestore");
const { getFirestore, FieldValue } = require("firebase-admin/firestore");
const { initializeApp } = require("firebase-admin/app");

initializeApp();
const db = getFirestore();

exports.onBatchCreated = onDocumentCreated("batches/{batchId}", async (event) => {
    const batch = event.data.data();

    try {
        // Step 1: Validate batch.name and batch.courseID
        if (!batch.name || !batch.courseID) {
            console.error("Invalid batch data: batch.name or batch.courseID is missing");
            return false;
        }

        const batchName = batch.name.toUpperCase();
        const courseID = batch.courseID.toUpperCase();

        // Step 2: Get course data from the "courses" collection using courseID
        const courseDoc = await db.collection("courses").doc(courseID).get();

        if (!courseDoc.exists) {
            console.error(`Course with ID ${courseID} not found`);
            return false;
        }

        const courseData = courseDoc.data();

        // Step 3: Add batch data to "courses/{courseID}/instances/{batchName}"
        await db
            .collection("courses")
            .doc(courseID)
            .collection("instances")
            .doc(batchName)
            .set(courseData);

        // Step 4: Get the list of all users
        const userCollectionData = await db.collection("users").get();
        const adminDocs = userCollectionData.docs.filter((doc) => doc.data().userRole === "superAdmin" || doc.data().userRole === "admin");
        const adminDataList = adminDocs.map((doc) => doc.data());

        if (adminDataList.length === 0) {
            console.error("No superAdmin or admin found");
            return false;
        }

        // Step 5: Initialize membersData with admin data
        const membersData = {};
        adminDataList.forEach((adminData) => {
            const key = adminData.userRole === "superAdmin" ? "admin" : adminData.email;
            membersData[key] = {
                name: adminData.name,
                imagePath: adminData.imagePath,
                userRole: adminData.userRole,
            };
        });

        // Step 6: Convert the array of single-key objects into a single object for staffs
        const transformedStaffsBatch = batch.staffs.reduce((acc, staff) => {
            const [key, value] = Object.entries(staff)[0];
            acc[key] = value;
            return acc;
        }, {});

        const staffEmails = Object.values(transformedStaffsBatch);

        // Step 7: Process staff members and add them to the membersData
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

            // Add batchName to the staff's "batches" array
            await db
                .collection("users")
                .doc(email)
                .set(
                    {
                        batches: FieldValue.arrayUnion(batchName),
                    },
                    { merge: true }
                );

            // Add welcome message to the forum for the staff member
            await db
                .collection("forum")
                .doc(`${email}|admin`)
                .set(
                    {
                        [`admin|${new Date().toISOString()}`]: {
                            text: `Welcome aboard to our dedicated staff joining the new batch ${batchName} at Vectra Advantage Pro! Wishing you an enriching teaching experience filled with passion and dedication. Let's inspire our students to embrace and love every aspect of this certification course journey!`,
                            from: "admin",
                            time: new Date().toISOString(),
                        },
                    },
                    { merge: true }
                );
        }

        // Step 8: Convert the student array into an object for easier processing
        const transformedStudentsBatch = batch.students.reduce((acc, student) => {
            const [key, value] = Object.entries(student)[0];
            acc[key] = value;
            return acc;
        }, {});

        // Step 9: Process student members, update their users collection fields, and update membersData
        for (const [studentID, email] of Object.entries(transformedStudentsBatch)) {
            const userDoc = userCollectionData.docs.find((doc) => doc.id === email);

            if (!userDoc) {
                console.error(`Student with email ${email} not found`);
                continue;
            }

            const userData = userDoc.data();
            const certificateID = transformedStudentsBatch[studentID];

            membersData[email] = {
                name: userData.name,
                imagePath: userData.imagePath || "",  // Use the correct imagePath if available
                userRole: "student",
            };

            // Update "currentBatch" field: Remove old and add new
            await db
                .collection("users")
                .doc(email)
                .update({
                    currentBatch: {
                        [batchName]: certificateID,
                    },
                });

            // Update "id" and "batch" field: Merge new entry with existing ones
            await db
                .collection("users")
                .doc(email)
                .set(
                    {
                        id: {
                            [batchName]: studentID,
                        },
                        batch: {
                            [batchName]: certificateID,
                        },
                    },
                    { merge: true }
                );

            // Add welcome message to the forum for the student
            await db
                .collection("forum")
                .doc(`${email}|admin`)
                .set(
                    {
                        [`admin|${new Date().toISOString()}`]: {
                            text: `Welcome to Vectra Advantage Pro! Embark on an exciting learning journey with batch ${batchName}. We're thrilled to have you and eager to see you excel in your studies!`,
                            from: "admin",
                            time: new Date().toISOString(),
                        },
                    },
                    { merge: true }
                );
        }

        // Step 10: Add remaining batch details to the forum
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



exports.onBatchDeleted = onDocumentDeleted("batches/{batchId}", async (event) => {
    const batchId = event.params.batchId;
    const batch = event.data.data();

    try {
        // Step 1: Delete the batch document from "courses/{courseID}/instances/{batchName}"
        const batchName = batch.name.toUpperCase();
        const courseID = batch.courseID.toUpperCase();

        await db
            .collection("courses")
            .doc(courseID)
            .collection("instances")
            .doc(batchName)
            .delete();

        // Step 2: Remove the batchId from the staff's batch list
        const transformedStaffsBatch = batch.staffs.reduce((acc, staff) => {
            const [key, value] = Object.entries(staff)[0];
            acc[key] = value;
            return acc;
        }, {});

        const staffEmails = Object.values(transformedStaffsBatch);

        for (const email of staffEmails) {
            await db
                .collection("users")
                .doc(email)
                .update({
                    batches: FieldValue.arrayRemove(batchName),
                });
        }

        // Step 3: Remove the batch ID from student data fields
        const studentDocs = await db.collection("users").where("userRole", "==", "student").get();

        studentDocs.forEach(async (doc) => {
            const studentData = doc.data();
            const updatedCurrentBatch = { ...studentData.currentBatch };
            const updatedBatch = { ...studentData.batch };
            const updatedID = { ...studentData.id };

            delete updatedCurrentBatch[batchId];
            delete updatedBatch[batchId];
            delete updatedID[batchId];

            await db
                .collection("users")
                .doc(doc.id)
                .update({
                    currentBatch: updatedCurrentBatch,
                    batch: updatedBatch,
                    id: updatedID,
                });
        });

        // Step 4: Delete any document in the "requests" collection with "batchName" == batchId
        const requestDocs = await db.collection("requests").where("batchName", "==", batchId).get();

        requestDocs.forEach(async (doc) => {
            await db.collection("requests").doc(doc.id).delete();
        });

        // Step 5: Delete documents in collections "liveTest", "dailyTest", and "attendance" with batchID as docId
        const collectionsToDelete = ["liveTest", "dailyTest", "attendance", "forum"];
        for (const collection of collectionsToDelete) {
            const docRef = db.collection(collection).doc(batchId);
            const docSnapshot = await docRef.get();
            if (docSnapshot.exists) {
                await docRef.delete();
            }
        }

        console.log(`Successfully deleted batch with ID: ${batchId}`);
        return true;
    } catch (error) {
        console.error("Error processing batch deletion:", error);
        return false;
    }
});
