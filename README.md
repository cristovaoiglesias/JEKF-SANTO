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
This dataset was generated with Julia using in the following paper
-  Liu, Yang, and Rudiyanto Gunawan. "Bioprocess optimization under uncertainty using ensemble modeling." Journal of biotechnology 244 (2017): 34-44.


### Experiments with Real dataset comparing SANTO vs KPH2 
#### Conditions
-  MRDE-PC and specific $\textbf{P}(t=0)$ : [Matlab code](https://github.com/cristovaoiglesias/JEKF-SANTO/tree/main/evaluation_with_real_dataset)


### Experiments with Synthetic dataset comparing SANTO vs KPH2
#### Conditions
- MRDE-PC and standard $\textbf{P}(t=0)$: [Julia code](https://github.com/cristovaoiglesias/JEKF-SANTO/tree/main/evaluation_with_synthetic_dataset)
- MRDE-PC and specific $\textbf{P}(t=0)$: [Julia code](https://github.com/cristovaoiglesias/JEKF-SANTO/tree/main/evaluation_with_synthetic_dataset)
- MRDE-PU and standard $\textbf{P}(t=0)$: [Julia code](https://github.com/cristovaoiglesias/JEKF-SANTO/tree/main/evaluation_with_synthetic_dataset)
- MRDE-PU and specific $\textbf{P}(t=0)$: [Julia code](https://github.com/cristovaoiglesias/JEKF-SANTO/tree/main/evaluation_with_synthetic_dataset)


