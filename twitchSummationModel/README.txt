File Descriptions:
FAModel - force to amplitude model: relates stimulation amplitude to contraction force using a sigmoid
twitchModel - normalized twitch model: model muscle twitches as radial basis function
twitchSummationModel - models contraction force as a function of past twitches given their time and the respective stimulation amplitude
FESModel - using the aforementioned models, simulations stimulation from t=-1:5 with a predefined stimulation starting at t = 0. Assumes a constant stimulation pulsewidth and frequency.
