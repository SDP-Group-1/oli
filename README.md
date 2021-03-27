# operational lookout intern
The repository for the OLI App

## Purpose of the app: 


## Structure:

The project is created using the Flutter framework, and primarily programmed in Dart (with some Android specific code in Java).

The app consists of:
- [main.dart](https://github.com/SDP-Group-1/oli/blob/main/lib/main.dart) - the starting point of the app 
- [home.dart](https://github.com/SDP-Group-1/oli/blob/main/lib/home.dart) - consists of the layout for the home page + the state of the robot 
- [call.dart](https://github.com/SDP-Group-1/oli/blob/main/lib/call.dart) - implements the 'Call OLI' function. 
- [setup.dart](https://github.com/SDP-Group-1/oli/blob/main/lib/setup.dart) - interface for user to set up the app and send a request to the robot to map their home. 
- [background.dart](https://github.com/SDP-Group-1/oli/blob/main/lib/background.dart) - the background processes required for monitoring the sensors and detection a fall
- [database.dart](https://github.com/SDP-Group-1/oli/blob/main/lib/database.dart) - helper functions used to manipulate a local SQLite database


NOTE - I HAVE ADDED SUPPORT TO PUBLISH THE APP TO THE PLAY STORE. I HAVE ADDED A SIGNING KEY TO PUBLISH IT, AND I HAVE THE KEY.PROPERTIES FILE THAT CONTAINS THE PASSWORD TO SIGN THE APP BUNDLE.
