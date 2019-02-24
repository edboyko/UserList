# UserList
A demo app that shows list of moderators from the stackexchange API.

## Modules
- Network Manager: class that downloads data from the internet using URL provided. Expects URLSession dependency.
- Storage Manager: class that works with persistent data i.e. saving or getting from the persistent store. Expects NSPersistentContainer dependency.
- Users Provider: class that communicates with the Network Manager to download data and parse it, parsed data will be sent to Storage Manager so it could save that data to the persistent store.
- Users Collection View Data Source: this class implements UICollectionViewDataSource as well as UICollectionViewDelegate and UICollectionViewDelegateFlowLayout methods, which helps to lighten UsersViewController.

## Functionality
- Displays a list of users on the initial screen.
- Users saved into the persistent store therefore the app can work without the internet connection.
- If user is selected, details of that user are shown.
