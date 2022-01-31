# NASA Picture of the day
This is an app that displays pictures from the NASA APOD API. It display picture according to selected date and stores all the data using Core Data.
## Installation

To install this app:

1. Ensure you have cocoapods installed using:

        sudo gem install cocoapods
2. Install pods with:

        pod install
3. Open the app in XCode from the generated `NASAPictureOfTheDay.xcworkspace` and run

## DEMO Video
![Demo](https://user-images.githubusercontent.com/10582613/151709092-864afdc2-9b75-4312-81b8-9ec5bdbf230c.gif)

## User Experience
The app is composed of three main screens:

### 1. Select date
Select date from the first screen by default today's date will be set in datepicker. Once you select date click on done button it will take user to details screen of that perticular day picture and meanwhile in background it will store in core data as well. 

### 2. Selected day picture details
This screen is pushed onto the navigation controller when you click on done button of the date picker. It shows extra details of the picture returned from the APOD API. There is one button called Mark favorite which will mark that picture as favorite and it will store in core data.

### 3. Manage favorite listing
This is presented after pressing the Manage favorite listing button below the select date textfield of the Select date Screen. This screen contains list of picture which marked as favorite and when you tap on any CollectionViewCell it will marked as unfavorite and user will redirect back to select date screen.


