# README #

With the end of POS nearing I decided to release a public version of my POS manager tool.  This program is intended to be ran on localhost.  To make things simpler for me and the users I have removed SSO login so only a few manual database inserts/edits are required.  It also also assumed that the users have some technical experience.

Screenshots:  http://imgur.com/a/drJOF

Depending on how this is recieved; I would not be against fixing issues/adding features etc, or taking pull requests
from others.  Feel free to create issues or mail me in game (Blacksmoke16).

### Prerequisites:
  1. Ruby on rails (created with Ruby version 2.3.1p112 and Rails version 4.2.7.1)
  2. EVE SDE (required tables are:  invCategories, invGroups, invTypes, mapConstellations, mapRegions,
  mapSolarSystems and mapDenormalize)
  3. MySQL2

### Setup:
   1. Assuming you already have rails/ruby/mysql etc setup
   2. Clone repo to desiered location.
   3. Rename the config/database.yml.example to database.yml and change the username/password to your details.
   4. Inside the project root run <tt>gem install bundler</tt>
   5. Once bundler is installed run <tt>bundle install</tt> to install the rest of the gems
   6. Run <tt>rake db:setup</tt> to initialize the database
   7. Import EVE SDE tables in
   8. In the users table, add the character you will using.  (Because it is meant to be usedfor localhost it will only use the first user in the table.  The table is used to store some settings so that when you stop and return they remain intact.
   9. In the corps table, add the corp information and api.  Api requires:  assetList, locations, corporationSheet, starbaseList and starbaseDetails.
   10. Run <tt>rake pos:POSs</tt> to load in the data.
   11. Run <tt>rails s</tt> to host the server on localhost:3000


When stopping and returning again later you will want to run <tt>rake pos:POSs</tt> to update the informaiton. If needed I can include instructions on how to use cron tasks to keep things updated if people will use that method.

### Features:
  *  View POSs, fuel usage/stats, silo contents/type etc etc
  *  View fuel usage per day/week/month for all pos
  *  Hide POS to remvoe them from list and fuel usage numbers
  *  Add labels to pos to quickly filter between say reaction vs mining pos
  
### Legend:
  * State is green:  POS is online and opperational
  * State is orange:  POS is anchored
  * State is red:  POS is reinforced or unanchored
  * State is yellow:  POS is onlining
  * State is blinking pink:  Has a siphon or amounts in silo are not divisible by 100 with no remainder.
  
  * Silo bar is red:  Raw moon goo
  * Silo bar is Blue:  Intermediate goo
  * Silo bar is purple: Advanced goo
  
  * Fuel bar is green: More than a week left
  * Fuel bar is yellow: Less than a week left
  * Fuel bar is red:  Less than 3 days left
     
### Contact Info
In-game:  Blacksmoke16  
Discord:  Blacksmoke16#1684

Donations are accepted :)

### License (MIT LICENSE)
  See LICENSE file
  
### Copyright
 EVE Online and the EVE logo are the registered trademarks of CCP hf. All rights are reserved worldwide. All other 
 trademarks are the property of their respective owners. EVE Online, the EVE logo, EVE and all associated logos and designs are the intellectual property of CCP hf. All artwork, screenshots, characters, vehicles, storylines, world facts or other recognizable features of the intellectual property relating to these trademarks are likewise the intellectual property of CCP hf.    CCP hf. has granted permission to posManager to use EVE Online and all associated logos and designs for promotional and information purposes on its website but does not endorse, and is not in any way affiliated with, the posManager. CCP is in no way responsible for the content on or functioning of this website, nor can it be liable for any damage arising from the use of this website.
