
## Planning

* **Wednesday:** (DAWN2DUCK) Do the list below, so I can PLAYTEST in the EVENING.
  * Then also respond to itch.io stuff
* **Thursday:** Work on CARTS in morning (just for variation/while cycling), then necessary polishing DAWN2DUCK in evening
* **Friday:**: Have DAWN2DUCK done and submittable by afternoon. CARTS can be whatever is possible.
  * GMTK Jam starts by evening, but I'll probably want that evening just for brainstorming and making a plan, not actually starting yet.

## To-Do


TODO (in order of importance):

* DAY/NIGHT CYCLE => indicate where sun is at all times with arrow/sunrays
  * A counter for the current day and time, at least for debugging.
* UI: some simple UI to display lives and money
* Now I merely check the tourist's center => I should probably create a small polygon for it and check all the individual points
  * Maybe you're not allowed to place the parasols _too close_ to tourists? => Seems fair to forbid placing them INSIDE tourists.

* Let the Map spawn and manage special powerup locations. (SEE LIST BELOW)
  * They also have a progress bar and check if they're in shade.
  * If long enough, they trigger. (Some of them are curses, some of them cost money.)
  * Make them all a completely custom resource that extends the same PowerupType base resource?

* Finetuning
  * Properly scale number of tourists to arrive during the day.
  * Change scalings of player, tourist, etcetera, so the beach looks more expansive and you could perhaps catch multiple in a single shadow.
  * A game over menu with the possibility to restart (and perhaps some other statistics)


* Generate special places on map => DROP points and ROTATE points
  * SHOP = if not holding an umbrella, and you have enough money, run into this to buy a new one
  * DROP = if there, and you have something, drop it => but also, don't allow re-grabbing it until you've LEFT the spot (or some timer has passed)
  * ROTATE = if there, continuously call some rotate function on parasol => if included, you can't do this with space of course
  * LIFE = if visited, you simply get an extra life, and the area immediately disappears
  * LURE = if there, it simply lures all nearby people to use that location as target => An alternative is to always use "lure" if you're _not_ holding a parasol (and press space).
  * SCALAR = if you visit it with a parasol, it grows larger/smaller on the fly
  * TIME = speeds up/slows down/reverses the time
  * CLOUD = call up a cloud at that instant, which would just fly from right to left (clouds always go _against_ the sun, for consistency) and could block the sun for a while
  * DON'T USE PHYSICS for anything in this game => all these things only need to check if any of the players are in range, which is cheap and easy.


## Later To-Do

* MAP: Make prettier.
  * Special shader for water, add random rocks/fences/sand grains, etcetera
* SHADOWS: Make prettier.
  * Fuzzy edges, maybe with noise
* MOVEMENT: if we're going to wrap, we should show a clear outline of where the beach ends!
  * The alternative is sliding across the border, but I don't even know how to do that.


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
