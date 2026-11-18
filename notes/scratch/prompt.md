Awesome start! Heads up, I had to preform some minor updates to your code to eliminate some compiler errors. I don't have the dependents for your environment figure out yet, so you can't build for yourself, yet.
The major "error" which I had to comment out was the `track.estimated_bounding_box` isn't a thing. Replacing what you stub in as a bounding box is NOT going to be easy. I was talking with my coworkers and they have believe we'll have to write some of the  code responsible for converting a measurement and track to camera space.
What they said I find very difficult to follow, but I'll do my best to recount.
In order to do this, I will need to get the metadata from the camera via dds to get the source position (likely coming in as ECEF), subtract that from the target (measurement/track also in ECEF), multipy that by the rotation matrix to get to sensorSpace (see `CoordFrames::getEcefToSensorDcm`) to get an X,Y,Z of the sensor. Using a pinhole camera model, I should be able to get the the target xyz using the focus length(f), pixel pitch(p), image width(w), and image height(h)

[x_s,y_s,z_s] = L_sensor = R(T-S)
x_c = y_s/x_s * f/p + w/2 
y_c = z/sqrt(x_s^2+y_s^2) * f/p + h/2
r_c = ||L_sensor||

Where r_c is equal to the range from the camera to the target in camera space.
I'm not sure why they label x_c and y_c with the `c` subscript. If I understand the flow of 
