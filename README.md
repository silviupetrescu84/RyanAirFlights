# RyanAirFlights

RyanAirFlights is an example iOS app that uses the RyanAir API to search for flights

## Requirements

A MacOS device running XCode 11.2.1

## How to Build/Run

1. Make a clone of this repository in a folder on your Mac OS using your favourite git tool  
2. Open the project in XCode
3. Select any simulator as target, as the interface was created with Autolayout, but the iPhone 7/8 simulator is preffered 
4. Build and run!

Optional: If you want to run on the device, you will need to select a team and create a bundle id for the project.

## To do

- Fix issue with flights not load
- Improve the app appearance
- Implement caching if possible for the stations
- Add more UI/Unit tests

## Pods Used

Alamofire - https://github.com/Alamofire/Alamofire

The pod was integrated into the project for easier download and to make sure the project is buildable in case Alamofire is getting updated

Other resources used:
https://github.com/apasccon/SearchTextField for easy searching inside the textfields
