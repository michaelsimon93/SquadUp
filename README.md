# README #

### What is this repository for? ###

* SquadUp repo for CS407. Basketball matchmaking app using firebase as a backend.

### How do I get set up? ###

* Download the project through Xcode with the clone link
* You may have to navigate to the folder in terminal and do a 'pod install' or 'pod update'
* Since log in has changed over time you will have to add 'ref.unauth()' to viewDidLoad() of 'LogInViewController' to un-authenticate your simulator so you can re-log in without the crash