
## Planning

* **Tuesday:** (DAWN2DUCK) Finish parasols, map, UI => completely closed game loop and playable
* **Wednesday:** (CARTS) Try that other game idea (maybe do this Tuesday evening already?)
* **Thursday:** (DAWN2DUCK) Make stuff look pretty, feel better, add more powerups/strategy/map locations
* **Friday:**: (CARTS/DAWN2DUCK) Whichever is more likely to be finished and playable, to submit before GMTK

## To-Do


TODO (in order of importance):

* PARASOLS
  * Random shapes (which are just resources)
    * When creating an umbrella, it duplicates a resource, scales it according to sprite_size/config, then randomizes that scale a little bit.
  * Rotation (make it realistic/in small increments as you hold down space)
  * Ways to get more => WHEN SHOPS DISABLED (just check if the map has spawned a single shop location or not), just spawn a new umbrella at the start of every day 
  * Simple UV shader to get alternating white-red stripes (or other colors) on the umbrellas
* MAP
  * HERE'S THE PLAN:
    * Generate a random shore line => save the beach as one polygon shape, save the sea below as one shape, background is the dark green
    * The beach becomes beige and has a shader that fades near the bottom.
    * The water gets is usual water shader.
    * Now that we have these shapes, we can only let tourists spawn inside the beach area, and we can test where people are at any given time (land/sea)
  * Randomly generated? Tiles? How?
  * Beach area
  * Back area (which would otherwise house shops or new parasols or whatever)
  * The sun clearly visible, and otherwise indicate by an arrow
  * The background/lighting changing depending on time of day
* UI: some simple UI to display lives and money


* Properly scale number of tourists to arrive during the day.
* The idea of getting money => progression, buying more parasols, etcetera
* Generate special places on map => DROP points and ROTATE points
  * SHOP = if not holding an umbrella, and you have enough money, run into this to buy a new one
  * DROP = if there, and you have something, drop it => but also, don't allow re-grabbing it until you've LEFT the spot (or some timer has passed)
  * ROTATE = if there, simply call some rotate function on parasol
  * LURE = if there, it simply lures all nearby people to use that location as target => An alternative is to always use "lure" if you're _not_ holding a parasol (and press space).
  * DON'T USE PHYSICS for anything in this game => all these things only need to check if any of the players are in range, which is cheap and easy.

@IDEA: Randomly spawn coins? So you can also earn a bit more by just running around all the time?

@IDEA: Simple weather variations, making some days cooler and some hotter. Also allow "cloudy days" where the sun is sometimes obscured.

@IDEA: People that stay longer and will re-position a few times. (Requirements = set this number in target follower, only switch state to leaving if #repositions exceeds that num.)
