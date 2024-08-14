
## Planning

* **Wednesday:** (DAWN2DUCK) Do the list below, so I can PLAYTEST in the EVENING.
  * Then also respond to itch.io stuff
* **Thursday:** Work on CARTS in morning (just for variation/while cycling), then necessary polishing DAWN2DUCK in evening
* **Friday:**: Have DAWN2DUCK done and submittable by afternoon. CARTS can be whatever is possible.
  * GMTK Jam starts by evening, but I'll probably want that evening just for brainstorming and making a plan, not actually starting yet.

## To-Do (Thursday)

### Tutorial / First Introduction

Place the instructions ON THE ACTUAL BEACH! => Like maps laid down in the sand. Also distribute them over MULTIPLE DAYS. Time only starts running once they've all faded into view.

DAY 1:
* "Keep tourists in shade. Burned Tourist = -1 Life. Happy Tourist = Money."
* "You grab parasols automatically. Press space to drop them."
* "Hold SPACE (for longer) to _rotate_ your current parasol."

DAY 2:
* "Press SPACE without parasol to _lure_ nearby tourists; this costs 1 coin."

DAY 3:
* "Powerups appear. Keep them in shade for a while to enable them and/or visit."
* "If you activate them while lacking money, however, they become a CURSE: their effect is INVERTED."

We need to draw at least a STATIC DUCK to use in these tutorials.

### Progression / "Keep it interesting"

* Properly scale number of tourists to arrive during the day.
* Randomly pick the weather + display on thermometer (perhaps blink at hottest point)
  * Some days are colder, some are hotter. (But it always peaks at noon.)
  * Some have more numbers/likelihood of clouds than others

### Feedback

* TOURISTS: Have clear animations for when they're at risk of being sunburned + when it actually happened, otherwise you have no clue why you died.
  * Similarly, clear animations/effects for when IN SHADOW OR NOT.
  * I should prioritize clear feedback and signs to tell the player these crucial details: if something's in shadow or not, if you're in placement range, if a tourist is leaving or not, if you're holding an umbrella.
* When you die, linger a little and zoom in/focus on the person that died?

### Fixes

* Powerups invert if failed
  * @IDEA: Maybe we need a SECOND way in which powerups can fail? They start at 50%-->If they're not in shade, they also cool down, and they "fail" when they get to 0%?
  * Set a max number on powerups (such as the shop), adhere to it when spawning.
  * Also make this a MainSystem, and allow enabling/disabling it completely?
* More expensive to buy parasols; it should complete much slower than any other powerup.
* The reward for people depends on how burned they are (and/or how long they stayed), to balance the money values. (You should never even get close to that 99 max.)
* @MEH: I don't think I like the DROP/ROTATE/LURE forbidding you from doing it yourself => JUST REMOVE THAT
* @BUG: Sun always offscreen _is not correct_!
* @IDEA: Test making Luring cost 1 coin
* @IDEA: Losing a life means losing a parasol too?

### Powerups to Add

* COINS = just a raw coin given (or taken, if used incorrectly)
* CLOUD = call up a cloud at that instant, which would just fly from right to left (clouds always go _against_ the sun, for consistency) and could block the sun for a while
* INTENSITY = changes sun intensity/overall temperature (maybe even DIRECTION?)
* (SHAPER => changes shape of parasol? Is this useful enough?)
* SHADOW_LOCK = Maybe a powerup like "Your current parasol will always have the same shadow, regardless of where the sun is." => **YES, this can just be a powerup you can always walk over, and it will modify your current parasol**
* REPEL = Once activated, tourists will never pick locations anywhere near this spot, and existing tourists are repelled. (Resets when the powerup is removed automatically.)



## To-Do (Friday)

* JUICE (SoundFX, BG Music, etcetera)
* DUCKS: Illustrate and animate the final ducks for players + tourists.
* MENU: Add the Wildcards from the Godot jam + final game logo (maybe a background pattern?)
* @QUESTION: Zhenga thought things were not "in sunlight" because they weren't in that direct sunbeam/sunray. Make sure others don't have the same confusion => make the sunbeam less strong, or wider, or just clarify in the tutorial and with clear feedback.

* MAP: Make prettier.
  * Special shader for water, add random rocks/fences/sand grains, etcetera
  * More dynamic init spawning: loop through types and check for each one if it's "required" or has a "starting_num"
* SHADOWS: Make prettier.
  * Fuzzy edges, maybe with noise
* MOVEMENT: if we're going to wrap, we should show a clear outline of where the beach ends!
  * The alternative is sliding across the border, but I don't even know how to do that.

* @IDEA: A "backwards day" once in a while => all powerups are _inverted_ and the sun moves from right to left. (Would be part of Weather, which has some sort of Events subsystem.)




@ARTICLE: "Every game is a distribution problem." (The challenge comes from the fact that the player can't do everything, they must divide attention/resources/moves/energy between multiple things. That's where the challenge and the strategy/tactics come from.)





@IDEA: DIFFERENT TOURIST TYPES:

* People that require a specific color or shape of parasol. (Picked from the ones you actually have, of course.)
* People that stay longer and will re-position a few times. (Requirements = set this number in target follower, only switch state to leaving if #repositions exceeds that num.)
* People with other requirements or oddities? Maybe they walk _reaaally_ fast, or they are _really_ small and hard to put in shadow. Or they desire a specific SHAPE of umbrella.

@IDEA: DIFFERENT PARASOL TYPES

* @IDEA: Add a few more parasol **shapes**. (Bubbly cloud, heart shape, what else?)
* @IDEA: A special type of parasol that automatically rotates, constantly. 
* A special type of parasol that is direction-locked by default.