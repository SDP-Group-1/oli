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
- [details.dart](https://github.com/SDP-Group-1/oli/blob/main/lib/details.dart) - form to accept user details
- [postFall.dart](https://github.com/SDP-Group-1/oli/blob/main/lib/postFall.dart) - after the classfier determines whether the action was a fall or not, this file takes care of the UI for the response. 
- [flaskApi.dart](https://github.com/SDP-Group-1/oli/blob/main/lib/flaskApi.dart) - communicates with the classifier on the backend. 

Additionally, a Flask server is present in [/fall-detection](https://github.com/SDP-Group-1/oli/tree/main/fall_detection), which should be run prior to testing the app.  
