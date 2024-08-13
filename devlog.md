---
title: "Sunbluck"
---

Welcome to my devlog for the game _Sunbluck_ (@TODO: actual final title + link). It was made for the _Godot Wild Jam 72_ in a few days, which is why this devlog will be rather brief. Nevertheless, I want to talk about the process, any interesting challenges or situations, and anything else that seems worth sharing.

## What's the idea?

The theme of the jam was **Light and Dark**. 

The extra wildcards, which are completely optional, were 

* **Dynamic Perspective** ("Use more than one camera in your game.")
* **Curses** ("Difficulty increases with powerups")
* **What the Duck** ("Include at least one duck in your game.")

I only entered the jam a few days late, because I was finishing another jam first and then I wanted to take a break for a day. This meant I had only a few days, while the actual jam lasts 9 days.

From the start, I had one idea that seemed promising. An idea that was different from what I'd made before and could fit all the requirements.

But the next day, when I woke up early to start working on this, it was the hottest day of the year (in the Netherlands). It was so hot that I couldn't even _stand_ behind my desk and _do nothing_, because I'd break out in sweat and feel light-headed.

As such, I ditched the idea for something that _seemed_ smaller and more appropriate for the current time of year. What was that idea?

* You run a beach, tourists arrive.
* You have to _keep them in the shade_ by constantly moving the parasols and positioning them correctly.
* As the sun arcs across the sky (morning->evening), changing the shadows all the time.
* Because if a tourist is exposed to sun for too long, they burn and you lose a life.

{{% remark %}}
I didn't really ditch the other idea, of course. I wrote it down and told myself to create a quick prototype somewhere in the coming days. To at least explore it and see if it might still be worth pursuing that one.
{{% /remark %}}

Simple enough, right? Wrong. Always wrong :p

## My personal challenges

But first, let's see which personal challenges I invented for myself.

First of all, I wanted to learn from my mistakes with previous game jam games. 

I'd often have an idea that only worked once all 5 systems for the game were operational and connected. This meant I couldn't really test/play the idea until _the final day/hours before the deadline_, which isn't great. It also just meant a lot of coding and a constant fear that I might not finish in time and the game couldn't even be submitted, because it couldn't even be played.

Instead, in this game, I wanted every "main system" or "main mechanic" to be completely standalone. Each of them can be enabled or disabled, and the game will still run and still be a closed game loop (that is somewhat fun or challenging). 

For example, if we turn off the Tourist system, it will just spawn X tourists straight into the level and do nothing else. If we _enable_ it, tourists walk onto the beach from off screen, and they come in waves/timed events, and they actually do what the full game intended.

Similarly, if I turn off the Sun/Weather system, then the player itself will simply be the light source. And so you can still test and play the game.

I'm writing this from the future, of course, and I can confidently say that this was a _great approach_. I could test the core loop as soon as my shadow code was done. I could test a new system with _everything else turned off_, and the game still played (like a game). This made it easy to really focus on one system, iron out bugs, and only _then_ turn on the next one. It also gave me new ideas for the game itself, because I was forced to consider "but how would this still work if we DON'T even have tourists!?"

Secondly, I would suppress the urge to make it local multiplayer or to push myself in all sorts of corners because I want to add _too much content_. Of course my brain immediately went for it: oh but what if we have different _types_ of tourists? Tourist A could do X, and B could do Z, and then, and then---no, keep it simple and contained.

Similarly, I really hate creating or having _UI elements_ in my games. I often work really hard to remove all of that, or to make the information a natural part of the game world. (For example, instead of displaying lives as a number or hearts in the top-left, I'd put a shader on the player that degrades over time to show their health degrading.) It's _better_, in most cases. It's also _a lot more work_ than I can handle in such a short time period. 

Let's just keep this simple idea a singleplayer experience, and it's fine to put some interface elements (such as health and money) on top of the game world.


## Day 1: Getting a core game loop

### How to detect if I'm in shadow?

This was the first thing I needed to test. If I couldn't make this work, or it would be too expensive too calculate, then the whole idea would be moot.

There are many ways to try and solve this problem.

For example, to check if an object is in shadow, you could ...

* Enable physics in your game, giving everything somewhat fitting physics bodies.
* Then shoot a _raycast_ from your physics body ( = the tourist) to the light ( = the sun).
* If it hits anything else in between, well, then your body must be in shadow!

Or you could let the game engine (in my case, Godot) fully simulate the light and shadows (with actual light sources and occluders), then do some shader magic---hoping you have access to the right things---to pull out the areas in shadow.

You could even test the literal _pixels_ on the screen. If a tourist is surrounded by mostly really dark pixels, they are probably in shadow, right?

All of these might've worked, but I cast them aside rather quickly. I needed to both _accurately display_ those shadows, as well as _really cheaply_ check if tourists were within them or not. (Potentially for many parasols, of many different weird shapes, at the same time.)

I wanted to keep the game light and not resort to physics. (If possible, always do it without physics. Otherwise you add a lot of overhead and an entire class of extra possible bugs for ... nothing. For example, teleporting bodies is a notorious problem that physics engines just can't handle well. But without physics---such as in my game---I can have stuff teleport/move as I please!)

The game would have a day/night cycle, so testing for "dark pixels" on the screen would be incredibly imprecise at certain times.

No, I quickly decided I should just do the shadow casting myself, in the absolute simplest way possible.

* Parasols are defined by a _polygon_. (I created a Resource for some basic shapes, such as triangle/rectangle/circle, and it just picks one of those.)
* For every light source, the ShadowCaster ...
  * Draws a line from the source to every point (or "corner", or "vertex") of its polygon. This is basically the "light direction at that point"
  * Then it _extends_ the point in that direction, by as much as some max shadow distance I defined myself.
  * Now we have a second polygon that defines the _shadow area_. Make it transparent black, display it underneath the umbrella, and you're good to go.

@TODO: IMAGE OF THIS??

Now, of course, there are some edge cases here. For example,

* You must also include the original points of the polygon, otherwise the shadow will "peter pan" ( = it's detached from its original shape, because you're only drawing the extended points)
* But now you have a mess of points that are in the wrong order, and some are unnecessary (such as edges facing away from the light)
* As such, I use Godot's `Geometry2D.convex_hull` to find the smallest polygon _around_ this mess of points.
* That actually creates a somewhat realistic shadow very cheaply, in most situations.

But despite those tweaks and extra realizations, the core algorithm is quite simple and fast to compute.

Moreover, now we have the literal polygon of each shadow. As such, testing if a tourist is inside it means nothing more than calling `Geomtery2D.is_point_inside_polygon` on it, supplying the tourist's position and the shadow polygon we calculate each frame.

In practice, this means at most 50--100 loops through very small polygons (only a few vertices) every frame, no matter what else happens in the game. This is no problem and I also didn't encounter any accuracy issues at this point.

After an hour or two, I had parasols, shadows, and a debug label telling me it could accurately detect if tourists were in shadow or not :p

### Getting the systems up and running

This is always a bit messy, as there's so much to do, and my hyperactive brain keeps jumping between places. But after a few hours, we get through this.

All the major systems were now operational, both standalone and together.

* Tourists would arrive in waves, growing in difficulty over time.
* Parasols would spawn, and you could pick them up and drop them. (Obviously, a player character can run around and do all this.)
* The sun arcs across the sky and the game modulates colors (and sun intensity, for example) as the day progresses.
* Tourists either walk away when done, or they get burned and you lose a life.
* And when they day is over, it just waits for a second, then starts the next one.

The game loop is closed, it is playable, and it's already quite a challenge.

At this moment, the game looked like a gray mess filled with the default Godot icon as the placeholder for everything. That's how all Godot games start :p

I wanted to at least _sketch_ the general graphics and map layout I'd need, but I suppressed the urge to start making things pretty now.

Instead, now I could test the game loop and really see what it needs. My observations were as follows.

* The core idea is a strong one. Because the sun _moves_ during the day, you can never just place a parasol and forget about someone. You always have to move and reposition stuff. This means the game, even in this simple form, has urgency, no down-time, and always a challenge.
* Picking up the parasols and putting tourists in shadow is quite satisfying. The way the shadows cast is also very clear and intuitive.
* It's annoying if you move close to the edge or things spawn close to the edge. (You can't see a tourist's health or if your parasol is the right way. Same thing for the sun: I should add an indicator for where it is at all times.)
* The idea easily scales to more tourists, more parasols, juggling more things at the same time.
* But it's also missing something.

### The extra spice

The game was already a game. And if I tweaked the numbers, it was already a challenge. I really had to keep paying attention and stay focused, otherwise I'd fail quickly. And all that with just one rule: move around with a parasol and keep tourists in shade.

The problem is that the sun is a directional light. Every parasol will cast a shadow from the same direction, making the process quite uniform: "place your parasols, ten seconds later the sun is on the other side, now move all your parasols slightly to the other side of their tourist".

There must be some things to shake it up. I needed one or two more clever ideas to really make the game tick.

* The first idea was **rotation**. We have these nice random shapes for parasols. This also means that you can _rotate_ them to catch more or less shadow. 
  * This worked great and will stay in the game.
* The second idea was **luring**. When tourists pick random locations, you're unlikely to ever catch two or three of them with the same parasol. But if you could somehow lure them, or herd them, or change where they will sit ... you can make that happen. 
  * I initially coded "luring" as an alternative for when the entire parasol system was disabled, and you therefore couldn't grab/move parasols. That's how I got the idea for this solution in the first place.
  * As such, I already had the code for this and could test it immediately. This _also_ worked great, though there had to be restrictions on it, such as luring costing a coin.
* The third idea was simply **messing with scale**. Make the parasol bigger! Make tourists smaller!
  * This was part of the finetuning process.
  * But I also realized I could implement those _powerups_ in this way: perhaps there was one that, if visited/used, would scale your parasol to be bigger.

All of these ideas were fine. I, however, want to stay minimal and relate everything back to the _core unique idea_ of the game: the realistic shadow casting. I brainstormed about how I could make all these changes directly related to the lights and the shadows.

And that's when I had my breakthrough: 

* These powerups are all scattered across the map, randomly spawned or generated. (Getting more parasols happens via that shop powerup, growing your current one would happen through visiting one, and so forth.)
* To _grab_ the powerup ... you must keep it in shade for a while.

Now the same core mechanic was used for _everything_ in the game. You really need those powerups to survive longer ... but it means devoting at least _one_ of your umbrellas to a powerup, which means it can't be put on a tourist. (Conversely, there might be a powerup that's bad and you don't want it. But it's right next to a tourist! Now how do you position the umbrella to not accidentally grab the powerup too?)

This was simply way more cohesive and streamlined than doing the typical "you get the powerup by visiting it/walking through it".

### Ending the day

At the end of that first day, I already made the map look like an actual beach. Just simple colors, dividing it into land and water, which also made it possible to _keep the player on the screen_. (I check if you're about to leave the bounds of the playable area, and if so, you wrap around to the other side.)

It's not much yet, but it already looks way more fun and professional now than the static gray background.

I also lost a lot of time here because I initially coded it in a weird way. And then I did so again. On my first try, I finally realized the simple solutions to my problems (such as how to get a wavy/somewhat random shore line) and it all came together.

I drew a few quick icons for the UI I'd build tomorrow, and also to settle on an art style. Then I wrote a part of this devlog and went to bed.

## Day 2: Still Hot

Didn't sleep too well because of the heat. But anyway, no time to lose, let's get going again.

### The necessary UI & Fixes

I made the UI, nothing special about that. 

The game now actually has a game over screen, you can see the time of day and how many lives you have left, etcetera.

I also fixed some major things about the game that bugged me while testing it last night.

For example, now you can place parasols _inside tourists_. Which is often all a player will do, because, well, the closer they are, the easier it is to stay in shadow right? But it's boring and it looks ugly. Even worse, I currently only checked if the _center_ of the tourist was inside the shadow cast, while I should check if their entire rectangular/circular body overlaps.

These things aren't much work, but they simply remove the most annoying or uninteresting aspects of the game (in its current state).

### Powerups & Progression

It was finally time for that extra spice. And actually being able to buy more parasols and progress to later and later days :p

@TODO