# 8086-Microprocessor-Game-in-Assembly-Language
This is a game developed with assembly language and tested in emu8086 (v4.08) emulator

All you need to copy the code from <code>game.asm</code> file and run it in emu8086.

<h4>Summery</h4>
It’s a balloon shooting game where player shoots an arrow to hit the balloon and when the balloon gets hit it beeps and a new balloon pops up and you get to shoot another arrow towards it. 

I used few label and conditional jump statement to update logic and display everything.

<h4>ALGORITHM:</h4>

<pre>
Main_loop:
  This is where logical part of game, handling user inputs and visually rendering happens.

  Inside_loop:
    Checks collision detection
    Changes direction of player
    Hides arrow when it gets out of viewport
    If there isn’t  any balloon on viewport it fires a new one

  Hit: 
    Plays sound (beep)
  
  Render_loon:
    The balloon moves upwards

  Render_arrow:
    Moves arrow forwards
  
  Insede_loop2:
    Render player on viewport

  Handling user input:
    Check if any key is pressed 
  
  upKey
    set player's direction to up
  
  downKey
    set player's direction to down
  
  spaceKey
    If no arrow on screen fire new one
</pre>

<h4>USED PROCEDURES </h4>
<pre>
 clear_screen: it clear the screen. <br>
 show_score: This procedure used for display score in same position on screen.
 </pre>

