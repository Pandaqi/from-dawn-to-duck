


## Future To-Do / Discarded

* STILL sometimes a tourist arrives while the tutorial is still playing
* Powerup: use actual body (like tourist) to detect shadows; instead of center-point-only checking I do now => THEN AGAIN, because of this, you're more able to _miss_ powerups to prevent accidentally triggering them. So I think it's FINE.
* Should we split WALKING and ARRIVING again? (Really not sure. Already burning people as they enter is realistic and preventable if you just follow them around.)
* @IDEA: A "backwards day" once in a while => all powerups are _inverted_ and the sun moves from right to left. (Would be part of Weather, which has some sort of Events subsystem.)
* Add clouds over the thermometer when it's cloudy
* @IDEA: Maybe we need a SECOND way in which powerups can fail? They start at 50%-->If they're not in shade, they also cool down, and they "fail" when they get to 0%?

* MOVEMENT: if we're going to wrap, we should show a clear outline of where the beach ends!
* @BUG: Sun always offscreen _is not correct_?

@IDEA: DIFFERENT MAPS?
* I'd need to generalize my current system of map areas slightly more.
* But then we can create islands, other shapes, etcetera => and actually use the water for cooldown, other effects, etcetera.

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