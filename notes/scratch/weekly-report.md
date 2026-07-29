Good Morning to all my various Bosses, Supervisors, Matrix Leaders, and Betters,

Last week I had the pleasure to work on all the 




* Successes
  * Build a new emergency model for SWAAMII.
    * We found that the latest commissioned model we made for swaamii was not preforming as expected.
    * Tanner believed that the opterra data was poisoning the model because the white target was causing it to label clouds as drones.
    * So we decided to make a new model trained on only shaheed and swaamii data, no Opterra data.
    * Unfortunately the this model also under preformed. Brandin helped debug with me and we found that only a subset (about 1/3) of the shaheed data was being utilized for training.
    * Luckily, that 3rd model actually preformed well and allowed swaamii proceed with the rest of their test.
* Current Work
* Blockers
