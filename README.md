# IMGD-Final-Project
For my final project for IMGD 5010, I created an interactive game using the Love2d game engine and Lua programming language.

## How to Play:
### Download (Recommended)
To play the game, you can download this .zip file below: 

[IMGD5010FinalProject.zip](https://github.com/user-attachments/files/20096126/IMGD5010FinalProject.zip)

Once you've downloaded it, unzip the file and run FinalProject.exe.

### In Browser using Itch.io (Not Recommended)

Alternatively, you can run the game in a browser through my itch.io: https://masterpiecesbymary.itch.io/imgd-5010-final-project

*This is not recommended due to issues with the scaling of the project impacting mouse placement which trying to pick up and place blocks. There are also other bugs when using this method.

## My Final Project Game - What I Made
The final product of this project was a fully playable game running using Love2d. In the game, you have control over a character which can move left, move right, and jump using the arrow keys or wasd as well as spacebar to control this movement. You can also press and hold SHIFT to make the player run faster. To collect a block, simply click on the block you wish to collect. If it is within range of your character, the block will dissappear and you will see a counter in the upper right corner of the screen representing how many of those block types you have. To place a block, click on the block type counter label that you wish to place (it will highlight red) and then right click to place. Just like collecting blocks, you can only place a block if the location where you want to place it is within range of your character.

## Inspiration
This game is inspired heavily by Terraria and Minecraft. Although it does not go nearly into the depth that those games have, it has many of the basics that make them up. 

When first brainstorming ideas for a final project, I was interested in using cellular automata to create organic looking caves and game maps. This led me to the idea of creating a Terraria like game while also figuring out an algorithm for creating the caves using cellular automata. The rest of the gameplay is a very basic version of Terraria using my own code, but the generation of the bottom half of the game was what I wanted to explore the most.

## Goals
My main goal, as mentioned above, was to figure out a way to use cellular automata to generate an organic game map. The algorithm that I ended up using loops over each type of cell (dirt, grass, stone, gold, diamond, and cave). It then for every cell it calculates how many of its neighbors are of that cell type. If there are more than 4 neighbors with that cell type, then the current cell will be changed to that cell type. If there are less than 3 neighbors with that cell type, then the current cell will be changed to a random cell type. I had this algorithm loop 5 times which smoothed out the map enough for it to look decent. I definitely achieved this goal of using cellular automata to generate my game map.

My other goal was to simply create a working game, which involved the physics of the character. The physics was the hardest part and took the longest. There are definitely still bugs and errors that would need to be worked out if I continued this project, but overall I would say that I achieved this goal of creating a working game.
