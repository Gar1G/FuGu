# FuGu

## An Internet of Things approach to tackling foodwaste.

FuGu is an IOT system consisting of six components:

1. Food items with RFID (Radio Frequency ID) tags
2. Fridge equipped with RFID sensor
3. Food waste bin with weight sensor
4. Backend web service
5. Recipe recommendation system
6. iOS App



![screen shot 2017-07-20 at 10 51 41](https://user-images.githubusercontent.com/9306774/36110808-e6a637a8-101b-11e8-8aba-cfbb5f2aa01c.png)


## File Structure

- `Web Service` : Contains all files related to the backend RESTful API
* `FoodApp > Models` : Model data structures for food items, waste entries and users
* `FoodApp > Controllers` : Controllers provide methods to process incoming API calls and perform the necessary logic and database interactions to provide a responses.
* `UsersController` : Authenticates login requests and processes registration requests from the app.
* `FoodItemsController` : Processes requests to add food items from the fridge, and retrives items stored in the database when requested by the app.
* `WastesController` : Returns a list of waste entries over a number of past days as specified by the app.

- `RESTInteract` : Contains xCode project and all files related to the iOS App component
* `Main Views` : Contains the view controllers for the 3 main pages; Recipes For You, Items List, Waste Dashboard
* `Secondary Views` : View controllers for the pages; Add New Custom Recipe, View Recipe, Custom Recipes List
* `Setup Views` : View controllers to handle functions; Login, Registration, Cuisine Preferences, Fridge and Bin Setup, Settings
* `Cells` : Set of custom classes written for use in the TableView and CollectionViews throughout the app.
* `Core Data` : Data models of objects stored in the on-device data storage (User Recipes and Food Waste)


