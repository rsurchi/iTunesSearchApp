iTunesSearchApp
===============

##App details
- The app only supports iPhone.
- The app will allow you to search for any track from the iTunes feed and view it's details.

##Design decisions
- I've tried to follow the MVC design pattern by having the ISiTunesTrack as the Model, 
the ISMasterViewController as the Controller, and the ISSearchTableViewCustomCell as the View.
- The ISNetworkManager is a single object that takes care of the network connectivity, and in this case brings back the response from the iTunes feed using the URL - http://itunes.apple.com/search?term=SEARCHTERM1+SEARCHTERM2+...
- The data is added to an instance of ISiTunesTrack and is controlled by the Master and Detail view controllers.

##Future Improvements
- Create an iPad view
- Add splash screen
- Change ISSearchTableViewCustomCell selected view
- Categorise tracks/albums/artists on the master view
- Allow the user to buy the track on the app
- Show similar / related tracks on detail view with links
- Create an artist and album view page
- Add media player to preview the tracks on detail view (AVAudioPlayer)



