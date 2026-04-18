# how-the-sky-fell
This is a cosmic horror game about charting the sky. I wanted to create an accurate night sky simulator and use it to make a creepy and atmospheric video game. All 3D models were made by me in blender. The project took about a month finish (not counting breaks). 

Play here: https://rokkks.itch.io/how-the-sky-fell

<img src="assets/readme/videos/overview.gif" width="500"/>

## Night Sky
I used the data from [Hipparcos Planetarium Data](https://creativival.github.io/hipparcos_planetarium_data_creator/index.en.html) to generate the stars and constellations.

Star generation was done with hip_constellation_line_star.csv by:
- Converting their **right ascension and declination** into xyz coordinates with a set distance from the player
- Setting their size and brightness based on their **visual magnitude**
- Coloring them using **B-V index**

The constellations were made with hip_constellation_line.csv by:
- Mapping each hip value (id) to the star and drawing a line which connects the 2 stars positions.



## Game Description
The player is given a list of target constellations and planets to chart. Using their telescope they need to click on stars to connect them into their correct constellation shape and find the planets. During this charting they will encounter creepy phenomena (stars moving, planets appearing/disappearing, location changing etc.)

<img src="assets/readme/videos/connecting.gif" width="400"/>

### Images

<img src="assets/readme/milkyway.png" width="500">
<img src="assets/readme/jupiter.png" width="500">
<img src="assets/readme/morning.png" width="500">
<img src="assets/readme/planetchart.png" width="500">
<img src="assets/readme/mountain.png" width="500">
<img src="assets/readme/ending.png" width="500">

gosh i love dithering