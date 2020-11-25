# Spot Search

### Note - Use case of this application is very niche but its fun to use

#### This application integrates Spotify and Twilio APIs and make adding songs into your Spotify Playlist simpler

So let me explain what does this application actually do and why do we need this??
Consider a case when you are chatting with your friend on whatsapp and he/she suggested you a song. Not you want this song in your playlist but at the same time you are **toooooooooooo lazy to open spotify app(maybe 100 more 'o' when your phone is laggy like mine)** --> **click on search button** --> **search for the complex song name** --> **and few more steps to add it into your well curated playlist**  

Now what if you can instantly switch to other chat(you can call it your spot servent) and type that same name your friend typed and you get top 3 search results directly from Spotify within this whatsapp chat and you just need to type "yes" to add this song in your playlist. Yes this is possible with this **Rails App**

### Requirements to just try the app and suggest me your favorite songs via this app-
* 1) You just need to subscribe to following Twilio channel for this -
 Just Send a WhatsApp message to **+1 415 523 8886** with code **join drive-breathe** 

* 2) Now type name of your favorite song, you will get 3 options

* 3) Type digit number of corresponding to your song

* 4) You will see Success message when song is added into my playlist

### Requirements to setup this app on local machine and customize to use it for yourself-
* Ruby Version - 2.7.1
* Rails Version - 6.0.3
* App on Spotify for Developer - https://developer.spotify.com/dashboard
* Twilio Account and Whatsapp Sandbox

#### Steps to Setup on local machine-
**I am not adding steps to setup spotify app and sandbox**
* 1) Clone the repository -  git clone https://github.com/saksham-jain/Whatsapp-Bot-for-Spotify.git
* 2) Install the required gems - bundle install
* 3) Type **bundle exec figaro install** to install some additional files required
* 4) Add SPOTIFY_KEY, SPOTIFY_SECRET, SPOTIFY_USER_ID, SPOTIFY_USER_TOKEN, SPOTIFY_USER_REFRESH_TOKEN in application.yml file 
First two values you will get from App you have created on spotify and other three you need to get by running server using **rails s** and click on **Sign in with Spotify** option and follow the procedure there

Follow **Requirements to just try the app and suggest me your favorite songs via this app** to setup whatsapp bot and then you are good to go for your Spot_Search app

Thanks for reading!!!!
