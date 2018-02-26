# TopTraxx

TopTraxx is a sample application to showcase how to simply connect to an external API 
and consume its data.  In this case, it connects to the Spotify API to get the top tracks 
for a specific artist. ( We have Radiohead hardcoded by default but also have 
The Flaming Lips and Muse - commented out to try something different if Radiohead is not
your thing. )  These top tracks get displayed to the user using a CollectionView.  Upon
track selection by the user.  We simply play the track.

# Requirements

TopTraxx connects to Spotify's API. A Premium Spotify account is required.  In the case,
the user does not have a Spotify account, we provided a short lived access to an account
in order to test and experiment what the app is like. It can be found using the link on 
the login screen.

# Auth

Please not that if you have the Spotify app installed on your phone, the Authentication
flow will use the app to log you in.  If you don't have the app, we get you authenticated
using the web flow.

# External libs

We made use of a few external libs (using cocoapods) to speed up dev process. Here they are
along with a quick description.

AlamofireImage : Networking lib that deals with web image retrieval.  
ColorThiefSwift : Get dominant color of an image.
Crashlytics : Defacto lib to collect crashes, issues, bugs, etc.
Fabric : Crashlytics home
SnapKit : Lib to do the layout by code.
Spotify-iOS-SDK : Wrapper to Spotify's API
SwiftLint : Lib to enforce coding rules.
TYBlurImage : Lib to blur images on the fly.
Swinject : Dependency Injection Framework.