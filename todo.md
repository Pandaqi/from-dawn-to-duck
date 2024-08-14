
## Planning

* **Wednesday:** (DAWN2DUCK) Do the list below, so I can PLAYTEST in the EVENING.
  * Then also respond to itch.io stuff
* **Thursday:** Work on CARTS in morning (just for variation/while cycling), then necessary polishing DAWN2DUCK in evening
* **Friday:**: Have DAWN2DUCK done and submittable by afternoon. CARTS can be whatever is possible.
  * GMTK Jam starts by evening, but I'll probably want that evening just for brainstorming and making a plan, not actually starting yet.

## To-Do


TODO (in order of importance):

* ACTUALLY PAY THE PRICE WHEN BUYING POWERUPS
* Graphics:
  * POWERUPS all => Once I have that, assign colors
  * (I feel like we are magically getting more parasols somewhere ...)

* Finetuning 
  * Parasols even bigger / tourists even smaller, so we _can_ grab multiple in one beam.
  * Allow a "margin" when drawing random points from an area, because tourists _right_ at the edges are just nasty.
  * THE ACTUAL TUTORIAL:
    * "You grab parasols automatically"
    * "Drop them with SPACE"
    * "If you hold nothing, pressing SPACE lures tourists to your current location"
  * Properly scale number of tourists to arrive during the day.
  * Change scalings of player, tourist, etcetera, so the beach looks more expansive and you could perhaps catch multiple in a single shadow.

@ARTICLE: "Every game is a distribution problem." (The challenge comes from the fact that the player can't do everything, they must divide attention/resources/moves/energy between multiple things. That's where the challenge and the strategy/tactics come from.)

## Later To-Do

* MENU: Add the Wildcards from the Godot jam + final game logo (maybe a background pattern?)
* Feedback (not enough coins, not completed yet, etcetera)
* MAP: Make prettier.
  * Special shader for water, add random rocks/fences/sand grains, etcetera
  * More dynamic init spawning: loop through types and check for each one if it's "required" or has a "starting_num"
* SHADOWS: Make prettier.
  * Fuzzy edges, maybe with noise
* MOVEMENT: if we're going to wrap, we should show a clear outline of where the beach ends!
  * The alternative is sliding across the border, but I don't even know how to do that.
* UI: Animate on changes.
* TOURISTS: Have clear animations for when they're at risk of being sunburned + when it actually happened, otherwise you have no clue why you died.
* POWERUPS: Not sure about disabling rotate/drop if any of those powerups are present.
  * Set a max number on powerups (such as the shop), adhere to it when spawning.
  * Also make this a MainSystem, and allow enabling/disabling it completely?
  * Allow INVERTING them + add a clear icon if so (to get the "curses" aspect actually into the game)
  * Implement the other ones too.
    * CLOUD = call up a cloud at that instant, which would just fly from right to left (clouds always go _against_ the sun, for consistency) and could block the sun for a while
    * INTENSITY = changes sun intensity (maybe even DIRECTION?)
    * (SHAPER => changes shape of parasol? Is this useful enough?)
    * (Any misc global rule changes should be kept on PowerupsData)



@IDEA: Some way to "lock" a parasol shadow? Or "lock" the sun? => Maybe a powerup like "Your current parasol will always have the same shadow, regardless of where the sun is."

@IDEA: Scale the coin reward from tourists based on how BURNED they are?

@IDEA: Maybe Luring also costs 1 coin?

@IDEA: A "reverse lure" => you can make a specific part of the beach _really undesirable_, perhaps dropping garbage or something, which will send everyone to another place.

@IDEA: Assign random colors (or colors based on shape/functionality) to the parasols => through duplicating shader and setting parameter
* Maybe later tourists have requirements about the COLOR of their parasol?

@IDEA: Use some thermometer, or a blinking red animation, to signal the sun is much more intense during midday?

@IDEA: Randomly spawn coins? So you can also earn a bit more by just running around all the time?

@IDEA: Simple weather variations, making some days cooler and some hotter. Also allow "cloudy days" where the sun is sometimes obscured. => **Should probably rename SUNS to WEATHER, and just randomly spawn clouds.** => If such a cloud is currently hit by the sun (with directional ray to arc center), the sun is "obscured"; all shadows disappear and nobody burns.

@IDEA: People that stay longer and will re-position a few times. (Requirements = set this number in target follower, only switch state to leaving if #repositions exceeds that num.)

@IDEA: People with other requirements or oddities? Maybe they walk _reaaally_ fast, or they are _really_ small and hard to put in shadow. Or they desire a specific SHAPE of umbrella.

@IDEA: Add a few more shapes. (Bubbly cloud, heart shape, what else?)
