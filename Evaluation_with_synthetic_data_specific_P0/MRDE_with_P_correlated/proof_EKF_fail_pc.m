

% Equations come from these papers below:
% Paper 1 - The Kalman Filter for the Supervision of Cultivation Processes
% Paper 2 - Development of a Soft-Sensor Based on Multi-Wavelength Fluorescence Spectroscopy and a Dynamic Metabolic Model for Monitoring Mammalian Cell Cultures


%Initialization
clear; close all; clc;
sympref('AbbreviateOutput', false);
%Variable and parameter definition
%Symbols for symbolic math calculations
syms Xv  GLC GLN  LAC  AMM  mAb t
syms umax  kglc kgln kilac kiamm kd kdlac kdamm a1 a2 Yxv_glc mglc Yxv_gln Ylac_glc Yamm_gln ramm QmAb 

dataset_insilico_run41=[
 % "[Xv]"  "[GLC]" "[GLN]" "[LAC]" "[AMM]" "[mAb]"
0.192695  75.146    7.81966   0.265034    1.27991    32.7291;
2.11623   56.3378   7.03898   2.10494    26.662     209.976;
2.87119   50.4827   6.08581   7.85398    68.4866    176.481;
4.41954   49.2173   5.14943   8.77957    85.6762    107.637;
3.32521   38.4718   3.70475   8.6194     81.0077    208.951;
4.17088   57.5675   3.6162    8.99678    92.2043    333.799;
2.84115   59.475    3.64439   9.11203    81.2265    618.069;
4.44663   43.0841   3.00971   9.69383   117.602     479.196;
3.86769   37.031    2.44176   8.73131    96.7622    826.939;
4.13991   33.361    1.94364   8.73629    74.197     761.688;
3.42359   29.7166   2.45774  10.1081     98.2864    720.757;
4.31046   16.1609   1.35554   9.75317   102.432     697.37;
4.38777   42.0331   1.30546   8.59807    98.7049    880.777;
4.07674    5.18514  1.73006   7.84829    90.4645   1073.67;
3.98725   11.0665   1.46735   9.38338    89.6966   1167.8];


dataset_insilico_run91=[
% "[Xv]"  "[GLC]" "[GLN]" "[LAC]" "[AMM]" "[mAb]"
 0.569124  55.8536  8.30142  0.993031  0.8823    8.6691;
 1.05832   48.6394  7.09718  1.30178    12.0793   50.2186;
 1.78708   47.6167  6.84174  2.68903    11.1408   23.0721;
 1.97921   36.957   5.93311  6.73872    29.1418  171.364;
 2.78782   58.6522  4.78733  7.17753    34.8223   61.5214;
 2.34705   60.1879  4.49614  7.26918    22.5003  259.302;
 3.18781   36.3323  4.29496  5.96666    29.4695  135.019;
 2.79167   26.0652  2.97793  6.70033    37.8903  242.771;
 3.1683    38.7066  2.36992  8.37146    53.8758  454.051;
 3.07924   35.8218  1.55129  8.77781    43.9493  282.814;
 2.39014   21.915   2.19973  7.65447    53.1395  397.722;
 2.9608    32.9942  2.11888  6.72268    61.9409  510.151;
 3.57861   28.9626  1.23883  7.51955    44.9947  636.756;
 3.07269   12.1787  1.14699  7.37788    35.9725  707.726;
 2.73412   10.9623  1.34439  8.86506    61.1478  578.963];


timeE = csvread("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/time_h_of_Xv_syntetic_data_with_gaussian_noises.csv"); % bioreactor 2 dataset (online) 
mAb_syntetic_data_based_on_run41 = csvread("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/mAb_syntetic_data_based_on_run41.csv"); % bioreactor 2 dataset (online) 
mAb_syntetic_data_based_on_run91 = csvread("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/mAb_syntetic_data_based_on_run91.csv"); % bioreactor 2 dataset (online) 

n=3

if n==1
    Xv_online_run41_noise_1 = csvread("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/Xv_syntetic_data_run41_with_gaussian_noise_0.03.csv"); % bioreactor 2 dataset (online) 
    Xv_online_run91_noise_1 = csvread("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/Xv_syntetic_data_run91_with_gaussian_noise_0.03.csv"); % bioreactor 2 dataset (online) 
    datasetOnline=Xv_online_run41_noise_1; 
    % measurement noise covariance matrix
    R=0.03;%0.006;  
end 
if n==2
    Xv_online_run41_noise_2  = csvread("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/Xv_syntetic_data_run41_with_gaussian_noise_0.05.csv"); % bioreactor 2 dataset (online) 
    Xv_online_run91_noise_2  = csvread("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/Xv_syntetic_data_run91_with_gaussian_noise_0.05.csv"); % bioreactor 2 dataset (online) 
    datasetOnline=Xv_online_run41_noise_2;
    % measurement noise covariance matrix
    R=0.05;%0.006;
end 
if n==3
    Xv_online_run41_noise_3  = csvread("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/Xv_syntetic_data_run41_with_gaussian_noise_0.5.csv"); % bioreactor 2 dataset (online) 
    Xv_online_run91_noise_3  = csvread("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/Xv_syntetic_data_run91_with_gaussian_noise_0.5.csv"); % bioreactor 2 dataset (online) 
    datasetOnline=Xv_online_run41_noise_3;
    % measurement noise covariance matrix;
    R=0.5;%0.006;
end 
    


%Initial State variables Xv;   GLC;   GLN;  LAC;  AMM;  mAb; QmAb
initX =[0.2 ; 60.0 ; 8.0 ; 0.1 ; 0.1 ; 0.0; 0.79];             

H = [1     0     0     0     0     0    0];

% initP = diag([0.0,0.0,0.0,0.0,0.0,0.0, 8.87008243514944e-8]); % initial process co-varince 
% Q = diag([0.000006, 0.0006, 0.0006, 0.0006, 0.0006, 0.0006 ,8.87008243514944e-8]) ;% process noise covariance %matrix

% initP = diag([0.0,0.0,0.0,0.0,0.0,0.0, 20.87008243514944e-3]); % initial process co-varince 
% Q = diag([0.003, 0.006, 0.006, 0.006, 0.006, 0.006 ,8.87008243514944e-8]) ;% process noise covariance %matrix

initP = diag([0.0,0.0,0.0,0.0,0.0,0.0, 0.0462]); % initial process co-varince 
Q = diag([0.005, 0.005, 0.005, 0.005, 0.005, 0.005 ,0.0462e-4]) ;% process noise covariance %matrix


init = [initX; initP(:)]; % combined initial value vector for the odesolver


% UMKM with parameters of 91 but the data come from run 41

% parameters run91
% p=[0.0777599, 0.01, 0.01, 6.0, 15.0, 0.07, 45.0, 13.0, 0.0221436, 6.0, 3.0, 0.05, 2.07621, 8.0, 30.5, 7.18176e-13, 0.79]

par1=0.0777599;
par2=0.01;
par3=0.01;
par4=6.0;
par5=15.0;
par6=0.07;
par7=45.0;
par8=13.0;
par9=0.0221436;
par10=6.0;
par11=3.0;
par12=0.05;
par13=2.07621;
par14= 8.0;
par15=30.5;
par16= 7.18176e-13;

% parameter run 41
%p= [0.35, 0.2, 0.02, 3.0, 11.5, 0.07, 45.0, 13.0, 0.01, 5.0, 4.0, 0.037, 1.47864, 9.0, 40.1, 1.22174e-13, 1.00487]

% par1=0.3000000000018143;
% par2=0.19999999945296218;
% par3=0.01999999998750423;
% par4=3.727145529338013;
% par5=11.500000000011484;
% par6=0.07000000000000003;
% par7=44.99999999999999;
% par8=12.99999999974547;
% par9=0.009999999998920579;
% par10=5.00000000013392;
% par11=3.9999999999958984;
% par12=0.03699999999999961;
% par13=1.6692292443034908;
% par14=9.000000000051596;
% par15=40.10000017750236;
% par16=2.3863630840060696e-13;



u=umax*(GLC/(kglc+GLC))*(GLN/(kgln+GLN))*(kilac/(kilac+LAC))*(kiamm/(kiamm+AMM));
ud=kd*(LAC/(kdlac+LAC))*(AMM/(kdamm+AMM));
mgln=(a1*GLN)/(a2+GLN);

dS=sym([
    (u-ud)*Xv;  %dXv
    -(((u-ud)/Yxv_glc) + mglc)*Xv; %dGLC
    -(((u-ud)/Yxv_gln) + mgln)*Xv; %dGLN
    Ylac_glc*((u-ud)/Yxv_glc)*Xv; %dLAC
    Yamm_gln*((u-ud)/Yxv_gln)*Xv-ramm*Xv; %dAMM
    QmAb*Xv; %dmAb
    0]); %dQmAb

%Jacobian of Model with respect to state variables
F = jacobian(dS,[Xv, GLC, GLN, LAC, AMM, mAb,QmAb]); %Equation 12
P = sym('P',[7,7]);
dP = F * P + P*F'+Q; %Equation 11 in paper 1 and Equation 14 in paper 2

%Replace all symbolic parameters with their respective numeric values 
F = subs(F,   [umax  kglc kgln kilac kiamm kd kdlac kdamm a1 a2 Yxv_glc mglc Yxv_gln Ylac_glc Yamm_gln ramm], [par1 par2 par3 par4 par5 par6 par7 par8 par9 par10 par11 par12 par13 par14 par15 par16]);
dS = subs(dS, [umax  kglc kgln kilac kiamm kd kdlac kdamm a1 a2 Yxv_glc mglc Yxv_gln Ylac_glc Yamm_gln ramm], [par1 par2 par3 par4 par5 par6 par7 par8 par9 par10 par11 par12 par13 par14 par15 par16]);
dP = subs(dP, [umax  kglc kgln kilac kiamm kd kdlac kdamm a1 a2 Yxv_glc mglc Yxv_gln Ylac_glc Yamm_gln ramm], [par1 par2 par3 par4 par5 par6 par7 par8 par9 par10 par11 par12 par13 par14 par15 par16]);

%Simulation / State prediction and filtering
%Assemble all differential equations into a vector of 12 elements %(3x state, 9x P)
OdeSys = matlabFunction([dS(:);dP(:)],'Vars',{t,[Xv; GLC; GLN; LAC; AMM; mAb; QmAb; P(:)]});

% Simulate the process from one measurement time to the next:
MC = zeros(0,7); %store filtered states in these variables
SimState = zeros(0,7);
P_state =[];
SimTime = [];

t0 = timeE(1);
timeE = timeE(2:end);
    
K_evolution=[];
for i = 1:numel(timeE)
    tspan = [t0 timeE(i)];
    [T,state] = ode45(OdeSys, tspan, init); % Solve the system of ODE from t-1 to t (simulate / solve model)
    PS = state(end,1:7)';                  % predicted state from the system of ODE
    P_state = [P_state;PS'];                % Save states for plotting
    
    MS = datasetOnline(i+1);            % measured state from online dataset   

    P = reshape(state(end,8:end),7,7);   % process error covariance matrix
%     disp("process error covariance matrix")
%     disp(P)

    K = P*H'/(H*P*H'+ R);                   % kalman gain matrix - Equation 13 in paper1
    FS = PS + K * (MS-PS(1));               % filtered state - Equation 5 and Equation 14 in paper1
    Pfilt = P-K*H*P;                        % filtered process error covariance matrix - Equation 6 and Equation 15(in paper 1) and Equation 18 (in paper2) 
    init = [FS; Pfilt(:)];                  % new initial condition to be used to solve the system of ODE
    t0 = timeE(i);                          % new starting time for next iteration

    % Save intermediate states for plotting

    MC = [MC;FS'];
    state(end,1:7) = NaN;
    SimState = [SimState; state(:,1:7)];
    SimTime = [SimTime; T];
    
    K_evolution=[K_evolution;K];

end
    


state_names=["[Xv]" "[GLC]" "[GLN]" "[LAC]" "[AMM]" "[mAb]" ];
figure(1);

subplot(3,3,1);
plot(timeE,datasetOnline(2:end),LineWidth = 2,color='red') %plot xv online bioreactor 
hold on
plot(timeE,MC(:,1), LineWidth = 2,color='black'); %plot EKF state variables estimations
xlabel('Time (hours)');
ylabel(state_names(1));

subplot(3,3,2);
plot(timeE,MC(:,2), LineWidth = 2); %plot EKF state variables estimations
hold on
scatter(0:24:336,dataset_insilico_run41(:,2),'g','filled'); %plot offline bioreactor 
xlabel('Time (hours)');
ylabel(state_names(2));

subplot(3,3,3);
plot(timeE,MC(:,3), LineWidth = 2); %plot EKF state variables estimations
hold on
scatter(0:24:336,dataset_insilico_run41(:,3),'g','filled'); %plot offline bioreactor 
xlabel('Time (hours)');
ylabel(state_names(3));

subplot(3,3,4);
plot(timeE,MC(:,4), LineWidth = 2); %plot EKF state variables estimations
hold on
scatter(0:24:336,dataset_insilico_run41(:,4),'g','filled'); %plot offline bioreactor 
xlabel('Time (hours)');
ylabel(state_names(4));

subplot(3,3,5);
plot(timeE,MC(:,5), LineWidth = 2); %plot EKF state variables estimations
hold on
scatter(0:24:336,dataset_insilico_run41(:,5),'g','filled'); %plot offline bioreactor 
xlabel('Time (hours)');
ylabel(state_names(5));

subplot(3,3,6);
plot(timeE,MC(:,6), LineWidth = 2); %plot EKF state variables estimations
hold on
plot(timeE,mAb_syntetic_data_based_on_run41(2:end),LineWidth = 2); %plot EKF state variables estimations
hold on
scatter(0:24:336,dataset_insilico_run41(:,6),'g','filled'); %plot offline bioreactor 
legend('mAb JEKF-SIC','mAb True','mAb noise True');
xlabel('Time (hours)');
ylabel(state_names(6));


figure(90);
% plot([1:1:length(P_state(:,7))]/60,P_state(:,7:end),LineWidth = 2);
plot(timeE,MC(:,7), LineWidth = 2); %plot EKF state variables estimations
xlabel('Time (hours)');
ylabel('Parameters');
legend('QmAb');




writematrix(MC(:,1),'/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/MRDE_with_P_correlated/Xv_result_EKF_fail_pc.csv')
writematrix(MC(:,6),'/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/MRDE_with_P_correlated/mAb_result_EKF_fail_pc.csv')
writematrix(MC(:,7),'/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/MRDE_with_P_correlated/QmAb_result_EKF_fail_pc.csv')











