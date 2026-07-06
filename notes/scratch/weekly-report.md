This week was unfortunately very short, so I wasn't able to work on as much as I had wanted. TLDR; I got a yolo11 model trained for swaamii, wasn't able to quite get the yolo26 model working. We also pushed a new sdl-tensorrt code patch to help Dan's testing. I wasn't able to get to work on the GPU container pass-through stuff for Dan. I hope to soon thought.

Current work:

- SWAAMII:
  - Got a new model yolo11 model re-trained on the new mid-flight data.
- TMX:
  - Got a patch pushed to up for Dan to be able to run the SIGMA Atr from his laptop for testing.

Blockers:

- (soft, SWAAMII) yolo26 models:
  - Had a problem getting the current training servers to train the new model.
  - Will likely need to update the machines and/or the source code to do both yolo11 and yolo26
- (soft, TMX): GPU container pass-through
  - This is a carry over from last week, no progress made
  - Dan asked if it was possible to run the ATR from his laptop for testing
  - We got him able to run it on his host for now, but a container is better long term.

Successes:

- Got a new model made for SWAAMII
- Removed a bunch of cruft from sdl-tensorrt


Good morning all,
Last week was relatively fruitful. TLDR; I was able to fix Dan's error building sigma-cuda on his host, and fixed the new model export issue for SWAAMII.

Successes:

- SWAAMII:
  - Got the new yolo11 model(s) re-trained on the new mid-flight data.
- TMX:
  - Got Dan's compatibility patch for sdl-tensorrt tested on rocky9, jetpack5, ubuntu22, and merged.

Blockers:
  - None 

Current work:
  - Work on model daisy-chaining 

New problems/tickets to 
- (soft, SWAAMII) yolo26 models:
  - Had a problem getting the current training servers to train the new model.
  - Will likely need to update the machines and/or the source code to do both yolo11 and yolo26
- (soft, TMX): GPU container pass-through
  - This is a carry over from last week, no progress made
  - Dan asked if it was possible to run the ATR from his laptop for testing
  - We got him able to run it on his host for now, but a container is better long term.


///////////////////////////////////////////////////////

Good morning all, 
Last week was relatively fruitful. TLDR; I was able to fix Dan's error building sigma-cuda on his host, and fixed the new model export issue for SWAAMII.

Successes:
- TMX:
  - Got Dan's compatibility patch for sdl-tensorrt tested on rocky9, jetpack5, ubunt
  - Had a problem getting the current training servers to train the new model.^J  -
  - SensorPath End-2-End testing^J

Current work:
  - SensorPath End-2-End Test
  - Work on model daisy-chaining 

New problems/tickets to work
  - f
