# JEKF-SANTO - Specific initiAl coNdiTiOn (SANTO)


## This repository has the code and data used in paper: How To NOT Make the Joint Extended Kalman Filter Fail with Unstructured Mechanistic Models

* Abstract:   Unstructured Mechanistic Model (UMM) allows for modeling the macro-scale of a phenomenon without known mechanisms. This is extremely useful in biomanufacturing because using UMM in the Joint estimation of states and parameters with Extended Kalman Filter (JEKF) can enable the real-time monitoring of bioprocess with unknown mechanisms.
 However, the UMM commonly used in biomanufacturing contains Ordinary Differential Equations (ODEs) with unshared parameters, weak variables, and weak terms. When such a UMM is coupled with an initial state error covariance matrix $\textbf{P}(t=0)$ and a process error covariance matrix $\textbf{Q}$ with uncorrelated elements, along with just one measured state variable, the Joint Extended Kalman Filter (JEKF) fails to simultaneously estimate the unshared parameters and state. This is because the Kalman gain that corresponds to the unshared parameter remains constant and is equal to zero.
In this work, we formally describe this failure case, present the proof of JEKF failure, and propose an approach called SANTO to side-steps this failure case. The SANTO approach consists of adding a small quantity to state error covariance between the measured state variable and unshared parameter in the initial $\textbf{P}(t=0)$ of the matrix Ricatti differential equation to compute the predicted error covariance matrix of state and prevent the Kalman gain from being zero.
Our theoretical and empirical results showed the potential of SANTO with a synthetic and real datasets.

## Content

### Real dataset
- we used the same dataset published in Iglesias Jr, Cristovão Freitas, et al. "Monitoring the Recombinant Adeno-Associated Virus Production using Extended Kalman Filter." Processes 10.11 (2022): 2180.  https://www.mdpi.com/2227-9717/10/11/2180 

### Synthetic dataset 
This dataset was generated with Julia based in the following papers
-  Kornecki, Martin, and Jochen Strube. "Accelerating biologics manufacturing by upstream process modelling." Processes 7.3 (2019): 166.
-  Narayanan, H. et al. Hybrid-ekf: Hybrid model coupled with extended kalman filter for real-time monitoring and control
of mammalian cell culture. Biotechnol. Bioeng. 117, 2703–2714 (2020).


### Experiments (Matlab) with Real dataset: SANTO vs KPH2 
#### Conditions
- RMDE-PC and standard $\textbf{P}(t=0)$: https://github.com/cristovaoiglesias/JEKF-SANTO/tree/main/Evaluation_with_real_data/MRDE_with_P_correlated
- RMDE-PC and specific $\textbf{P}(t=0)$: https://github.com/cristovaoiglesias/JEKF-SANTO/tree/main/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated
- RMDE-PU and standard $\textbf{P}(t=0)$: https://github.com/cristovaoiglesias/JEKF-SANTO/tree/main/Evaluation_with_real_data/MRDE_with_P_uncorrelated
- RMDE-PU and specific $\textbf{P}(t=0)$: https://github.com/cristovaoiglesias/JEKF-SANTO/tree/main/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated

### Experiments with Synthetic dataset
#### Conditions
- RMDE-PC and standard $\textbf{P}(t=0)$: https://github.com/cristovaoiglesias/JEKF-SANTO/tree/main/Evaluation_with_synthetic_data/MRDE_with_P_correlated
- RMDE-PC and specific $\textbf{P}(t=0)$: https://github.com/cristovaoiglesias/JEKF-SANTO/tree/main/Evaluation_with_synthetic_data_specific_P0/MRDE_with_P_correlated
- RMDE-PU and standard $\textbf{P}(t=0)$: https://github.com/cristovaoiglesias/JEKF-SANTO/tree/main/Evaluation_with_synthetic_data/MRDE_with_P_uncorrelated
- RMDE-PU and specific $\textbf{P}(t=0)$: https://github.com/cristovaoiglesias/JEKF-SANTO/tree/main/Evaluation_with_synthetic_data_specific_P0/MRDE_with_P_uncorrelated

### Results analyze
- The plots with the results can be viewed using Julia: https://github.com/cristovaoiglesias/JEKF-SANTO/tree/main/results_analyze 

