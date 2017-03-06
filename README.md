# TD_Reco_parole
TD reconnaissance de la parole oui-non

This program takes the .wav sound in located in the folder called oui-non and try to guess if it's a 'oui' or a 'non' which is pronounced.

- input : Sounds in the wave format
- Crop to get useful Signal (better SNR)
- Calculation of LPC coefficients for each (calcul_lpc.m)
- Calculation of 'elastic distances' (means distance of the LPC coefficients of 2 differents signals)
- Classification with k-nearest points
- Print results
