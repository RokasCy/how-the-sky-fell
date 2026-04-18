# how-the-sky-fell
This is a cosmic horror game about charting the sky. I wanted to create an accurate night sky simulator and use it to make a creepy and atmospheric video game. I used the Godot game engine and blender for the 3D models.

**Play here:** https://rokkks.itch.io/how-the-sky-fell

<img src="assets/readme/videos/overview.gif" width="500"/>

## Night Sky
I used the data from [Hipparcos Planetarium Data](https://creativival.github.io/hipparcos_planetarium_data_creator/index.en.html) to generate the stars and constellations.

Star generation was done with hip_constellation_line_star.csv by:
- Converting their **right ascension and declination** into xyz coordinates with a set distance from the player
- Setting their size and brightness based on their **visual magnitude**
- Coloring them using **B-V index**

The constellations were made with hip_constellation_line.csv by:
- Drawing lines that connect the stars with the coresponding HIP (id)

## Game Description
The player is given a list of target constellations and planets to chart. Using their telescope they need to click on stars to connect them into their correct constellation shape and find the planets. During this charting they will encounter creepy phenomena (stars moving, planets appearing/disappearing, location changing etc.)

I also implemented dithering for a more charming visual appeal.

<img src="assets/readme/videos/connecting.gif" width="400"/>


### Screenshots

<img src="assets/readme/milkyway.png" width="500">
<img src="assets/readme/jupiter.png" width="500">
<img src="assets/readme/morning.png" width="500">
<img src="assets/readme/planetchart.png" width="500">
<img src="assets/readme/mountain.png" width="500">
<img src="assets/readme/ending.png" width="500">

gosh i love dithering