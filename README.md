# nossochat

WHAT IS IT?
Simple chat app developed in Flutter/Dart using Firebase services.

TO WHOM IT IS INTENDED / OBJECTIVE?
I developed this app for practice purpose, it is intended to create chat rooms between two users that are registered in the app.

LIBRABRIES USED?
I imported some libraries of Firebase to deal with the manipulation of the user accounts and messages transactions.
 firebase_auth;
 cloud_firestore;
 firebase_core;
 
Imported the shared_preferences library, to create a file when the user logged in for the first time and when the app was closed the data would be saved to that file and used to login automatically when the user opens the app.
Got the google_sign_in aswell, for easier account creation and login.
