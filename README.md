# Sample iOS application using Clean Architecture and MVVM for searching flickr api
iOS Project implemented with Clean Layered Architecture and MVVM.

## Architecture concepts used here:
* Clean Layered Architecture https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html
* Advanced iOS App Architecture https://www.raywenderlich.com/8477-introducing-advanced-ios-app-architecture
* MVVM
* Data Binding
* Dependency Injection
## Includes:
* Unit Tests for Use Cases(Domain Layer), ViewModels(Presentation Layer) 
* NetworkService(Infrastructure Layer)


## Requirements: 
* at least Xcode Version 10.2.1 with Swift 5.0

# How to use app:
To search a photo, write a search term inside searchbar and hit search button. There are two network calls: search photos and download them. Every successful search query is stored persistently.
