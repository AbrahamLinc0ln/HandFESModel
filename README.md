# HandFESModel
Model of grip forces resulting from functional electrical stimulation applied to the forearm

Calculates grip forces given models of twitches and force-amplitude curve. Twitches are modeled as a radial basis function. The force-amplitude curve is model by a sigmoid. These models are included in the script and have adjustable parameters. 

The script models the contraction force when stimulation starts at time t=0;

Future commits will move the models to callable functions and change the script to be a function for use in an MPC model.
