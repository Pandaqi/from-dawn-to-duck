
## Planning

* **Thursday:** Work on CARTS in morning (just for variation/while cycling), then necessary polishing DAWN2DUCK in evening
* **Friday:**: Have DAWN2DUCK done and submittable by afternoon. CARTS can be whatever is possible.
  * GMTK Jam starts by evening, but I'll probably want that evening just for brainstorming and making a plan, not actually starting yet.

## To-Do (Thursday)

### Progression / "Keep it interesting"

* TUTORIAL: add the actual tourist/player characters into the images
* Properly scale number of tourists to arrive during the day.
  * Also scale how long they will stay, how much they pile up around noon, over time

### Feedback

* TOURISTS: Have clear animations for when they're at risk of being sunburned + when it actually happened, otherwise you have no clue why you died.
  * Similarly, clear animations/effects for when IN SHADOW OR NOT.
    * Add a (subtle) "glowing" animation when someone is in sunlight. => NO, animate squiggly lines, randomly place them in circle around character
    * Add an (extreme) "burning" animation when someone is about to burn => PLUS modulate to be more red/flashing red
    * Add a satisfied smiley or something when they're satisfied and leave => maybe also make them transparent or something
      * Nah make that a smiley face + arrow + house, flipped to face the direction in which they're leaving
* When you die, linger a little and zoom in/focus on the person that died? (Or is it enough if they have a death animation that takes 1 or 2 seconds?)
* As for ANIMATING the walk:
  * Only animate the feet. Back, backup, front, front up => cycle.
* How to differentiate TOURISTS and PLAYER?
  * Just make the player a black duck with different eyes, beak, a hat, a uniform.



## To-Do (Friday)

* JUICE (SoundFX, BG Music, etcetera)
  * BG MUSIC: Use my good Spanish guitar to get some random spanish summer-vibe plucking. (Perhaps add some quacking ducks on beat through it.)
* DUCKS: Illustrate and animate the final ducks for players + tourists.
* MENU: Add the Wildcards from the Godot jam + final game logo (maybe a background pattern?)
* @QUESTION: Zhenga thought things were not "in sunlight" because they weren't in that direct sunbeam/sunray. Make sure others don't have the same confusion => make the sunbeam less strong, or wider, or just clarify in the tutorial and with clear feedback.

* Not sure about luring costing money
* "Throwing" tourists in the water is a bit weird/inconsistent with the other mechanics, but we can surely LURE tourists to the water---and in there, you burn far more slowly?
* @IDEA: Maybe we need a SECOND way in which powerups can fail? They start at 50%-->If they're not in shade, they also cool down, and they "fail" when they get to 0%?
* MAP: Make prettier. => Special shader for water, add random rocks/fences/sand grains, etcetera
* MOVEMENT: if we're going to wrap, we should show a clear outline of where the beach ends!
* @BUG: Sun always offscreen _is not correct_?



@ARTICLE: "Every game is a distribution problem." (The challenge comes from the fact that the player can't do everything, they must divide attention/resources/moves/energy between multiple things. That's where the challenge and the strategy/tactics come from.)



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