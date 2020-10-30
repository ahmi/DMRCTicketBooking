# DMRCTicketBooking
- Xcode 12.1, iOS 14
- Switch to master branch if you are on develop
- Code covers following topics
  - Protocols for Fetch services.
  - Generics, Result Type, 3 ways of Error handling in Data layer
  - MkMapView, Annotations and Routes
  - Coordinator pattern for navigation
  - Light and Dark mode live transition
  - Multiple screen sizes and orientations
  - Autolayout both in storyboard and programmatically designed UI
  - 1 third party library is used (Toast: https://github.com/scalessec/Toast-Swift) to show toast messages
- App uses Protocols for Data layer. Data is being fetched from json file in resources. To replace it with live data, just change the fetch store. i-e         
`````let metroLocalData = MetroLocalStore()````` replace it with ``````MetroAPIStore()``````

`````let metroFetchWorker = MetroFetchWorker(metroStore: metroLocalData)`````
