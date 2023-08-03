# WeMeet

- Simple iOS app that allows users to view all available meeting rooms and book rooms if they have available spots.
- Demonstrate the use of SwiftUI + MVVM + CoreData + Async/await.
- Supports iOS 16.4+

## 

https://github.com/ajithrnayak/WeMeet/assets/3415400/b7b811d6-573a-4da7-9227-66dfdc2a902c

## Acceptance Criteria 

Write a simple client for iOS that handles the following user scenarios:
- A user wants to be able to see all of the rooms available
- A user wants to book a room if it has available spots

## Architecture 

    +----------------------------------+
    |              View                |
    +----------------------------------+
    |  Uses SwiftUI                    |
    |  - ViewModel as @StateObject     |
    |  - Reusable child views          |
    +----------------------------------+
                     ^
                     |
    +----------------------------------+       +----------------------------------+
    |           ViewModel              |       |             Store                |
    +----------------------------------+       +----------------------------------+
    |  Uses Combine                    |       |  Uses URLSession & Core Data     |
    |  - Holds the app's state         |       |  - Handles data fetching         |
    |  - Handles business logic        | < ––  |  - Writes fetched data to db     |
    |  - Conforms to ObservableObject  |       |  - Cordinates between API & DB   |
    |  - Observes to Fetched Results   |       |  - Dedicated per API endpoint    |
    +----------------------------------+       +----------------------------------+
                     ^
                     |
    +----------------------------------+
    |            Model                 |
    +----------------------------------+
    |  Uses Core Data                  |
    |  - Represents app data           |
    |  - Conforms to Codable           |
    +----------------------------------+


## Todo
- Cache thumbnail images
- Unit testing using URLProtocol
- Use Background context for FetchRequest

<br/>
<br/>
<br/>

Happy Meeting Room Booking!
