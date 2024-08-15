
## Planning

* **Friday:**: Have DAWN2DUCK done and submittable by afternoon. CARTS can be whatever is possible.
  * GMTK Jam starts by evening, but I'll probably want that evening just for brainstorming and making a plan, not actually starting yet.

## To-Do (Friday)

* Create DUCKS + ANIMATION
* Create BURNING FEEDBACK
* Make map shaders work with PIXEL SIZE (and as pretty as possible)
* Update tutorial that luring costs money
* Balance game => heat bounds change, day duration change too (makes sense for earlier levels to be shorter! Fixes downtime issue!)
* Final PLAYTEST
* Game Logo + Screenshots + Open Source
* => Submit


* @FIX: MOve the max heat bounds as well over time? (The first few days should be consistently "not so hot")
  * Nah, there should just be LESS VARIATION in this, at least in the earlier waves => So, in fact, the progression over time should increase VARIATION in heat/burn values
* TUTORIAL: add the actual tourist/player characters into the images
  * Explain luring costs a coin
* TOURISTS: Have clear animations for when they're at risk of being sunburned + when it actually happened, otherwise you have no clue why you died.
  * Similarly, clear animations/effects for when IN SHADOW OR NOT.
    * Add a (subtle) "glowing" animation when someone is in sunlight. => NO, animate squiggly lines, randomly place them in circle around character
    * Add an (extreme) "burning" animation when someone is about to burn => PLUS modulate to be more red/flashing red
* When you die, linger a little and zoom in/focus on the person that died? (Or is it enough if they have a death animation that takes 1 or 2 seconds?)
* As for ANIMATING the walk:
  * Only animate the feet. Back, backup, front, front up => cycle.
* How to differentiate TOURISTS and PLAYER?
  * DUCKS HAVE BLACK OUTLINES; makes them stand out, especially against the beach
  * Just make the player a black duck with different eyes, beak, a hat, a uniform.



## To-Do (Friday)

* Not sure if I like the sound for COIN CHANGE ...
* MAP SHADERS: It would've been better to pass the REAL SIZE of the polygon to the shader, to automatically scale everything accordingly.
  * Now it uses a lot of magic values ...
* Make the map decorations tween into existence? (Especially the ones that appear _later_ after tutorial is done?)

* MENU: Add final game logo
* @QUESTION: Zhenga thought things were not "in sunlight" because they weren't in that direct sunbeam/sunray. Make sure others don't have the same confusion => make the sunbeam less strong, or wider, or just clarify in the tutorial and with clear feedback.

* Not sure about luring costing money => YES, I THINK THAT ACTUALLY WORKS
* "Throwing" tourists in the water is a bit weird/inconsistent with the other mechanics, but we can surely LURE tourists to the water---and in there, you burn far more slowly?
* @IDEA: Maybe we need a SECOND way in which powerups can fail? They start at 50%-->If they're not in shade, they also cool down, and they "fail" when they get to 0%?

* MOVEMENT: if we're going to wrap, we should show a clear outline of where the beach ends!
* @BUG: Sun always offscreen _is not correct_?



@ARTICLE: "Every game is a distribution problem." (The challenge comes from the fact that the player can't do everything, they must divide attention/resources/moves/energy between multiple things. That's where the challenge and the strategy/tactics come from.)

@ARTICLE: PirateJam issues and stuff with GDD.

"I'm sorry I wrote you such a long letter; I didn't have time to write a short one."  - Blaise Pascal


## Future To-Do / Discarded

* Should we split WALKING and ARRIVING again? (Really not sure. Already burning people as they enter is realistic and preventable if you just follow them around.)
* @IDEA: A "backwards day" once in a while => all powerups are _inverted_ and the sun moves from right to left. (Would be part of Weather, which has some sort of Events subsystem.)
* Add clouds over the thermometer when it's cloudy


@IDEA: DIFFERENT TOURIST TYPES:

* People that require a specific color or shape of parasol. (Picked from the ones you actually have, of course.)
* People that stay longer and will re-position a few times. (Requirements = set this number in target follower, only switch state to leaving if #repositions exceeds that num.)
* People with other requirements or oddities? Maybe they walk _reaaally_ fast, or they are _really_ small and hard to put in shadow. Or they desire a specific SHAPE of umbrella.

@IDEA: DIFFERENT PARASOL TYPES

* @IDEA: Add a few more parasol **shapes**. (Bubbly cloud, heart shape, what else?)
* @IDEA: A special type of parasol that automatically rotates, constantly. 
* A special type of parasol that is direction-locked by default.

@IDEA: MORE POWERUPS
* (SHAPER => changes shape of parasol? Is this useful enough?)