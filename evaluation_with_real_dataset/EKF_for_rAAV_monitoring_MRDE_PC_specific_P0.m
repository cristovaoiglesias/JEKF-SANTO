

% This implementation is based on the following papers:
% Paper 1 - The Kalman Filter for the Supervision of Cultivation Processes
% Paper 2 - Monitoring the recombinant Adeno-Associated Virus Production by Extended Kalman Filter


%Initialization

clear; close all; clc;

sympref('AbbreviateOutput', false);
%Variable and parameter definition
%Symbols for symbolic math calculations
syms Xv Glc Gln Lac Amm AAV t real
syms uxv uglc ugln ulac uamm kdeg uaav


% The measurement noise variance (R) that was obtained from the variance of Xv measurements in the shake-flask dataset regards three runs
% Shake-Flask Dataset - shake_flask_dataset_AAV6_07_04_2021.xlsx

run1sd=[
 0.6649e6                    48.4025   6.18      0.44405   0.12       0.0; %run 1
 0.7311e6                    44.5725   5.63      4.66252   0.59       0.0;
 1.0475e6                    42.7962   5.12      9.65808   0.95       0.0;
 1.0453e6                    38.9662   4.39      13.5435   1.23       0.00978e9;
 1.2085e6                   35.0807   3.66      15.6528   1.39       0.424e9;
 1.2261e6                    29.4189   3.2       16.9849   1.46       1.038e9;
 1.3959e6                    33.9151   3.43      22.0915   1.7        1.611e9;
 1.5437e6                    29.9185   3.09      23.5346   1.74       1.865e9;
 2.1302e6                    25.2004   2.53      20.0933   1.7        2.2415e9];
 run2sd=[
 0.6032e6                    48.236    6.13      0.222025  0.12       0.0; %run 2
 0.8325e6                    45.6271   5.58      4.99556   0.61       0.0;
 0.9847e6                    42.5187   5.04      9.65808   0.99       0.0;
 0.977e6                     38.7997   4.33      13.5435   1.29       0.006815e9;
 1.3077e6                    37.8006   3.87      16.8739   1.51       0.1355e9;
 1.3474e6                    40.2984   4.03      23.2016   1.84       0.543e9;
 1.5701e6                    33.8595   3.25      21.2034   1.73       0.952e9;
 1.6186e6                    31.5837   3.01      22.9796   1.85       1.0695e9;
 2.321e6                     30.7511   2.77      22.9796   1.94       2.0915e9];
 run3sd=[
 0.5635e6                    48.1805   6.28      0.222025  0.12       0.0; %run 3
 0.8215e6                    44.9055   5.67      5.21758   0.6        0.0;
 1.0486e6                    42.1302   5.21      10.3242   0.97       0.0;
 0.9196e6                    38.9662   4.4       14.0986   1.25       0.005015e9;
 1.2261e6                    25.6444   2.73      11.2123   1.17       0.2475e9;
 1.3628e6                    30.5846   3.06      17.0959   1.44       0.7625e9;
 1.4224e6                    31.3062   3.14      19.8712   1.62       1.165e9;
 1.7223e6                    30.5846   3.18      23.2016   1.84       1.3405e9;
 2.0376e6                    28.6418   2.8       22.4245   1.87       1.9955e9];

mean_of_all_variances=[];
for i = 1:9
   variance_k=var([run1sd(i,1),run2sd(i,1),run3sd(i,1)]); 
%    fprintf('Variance: %f\n', variance_k);
   mean_of_all_variances(i)=variance_k;
end

% fprintf('Mean of all variances: %f\n', mean(mean_of_all_variances));

% Variance: 2610823333.333333
% Variance: 3095853333.333333
% Variance: 1338043333.333333
% Variance: 3960023333.333333
% Variance: 2801493333.333333
% Variance: 5606290000.000000
% Variance: 8810530000.000000
% Variance: 8043610000.000000
% Variance: 20882493333.333332
% Mean of all variances: 6349906666.666667 ≈ 0.006e12

% Based on 0.006e12 (initial R) and Innovation magnitude bound test the final R is 0.00002e12.
% What is the percentege of innovation errors that lie within the ±2sqrt(Sk)? 0.9524301964839711

% JEKF with SANTO = 000
% JEKF with SANTO = 100
% JEKF with KPH2  = 200

Keys=[000,100,200];
Val=["JEKF-Classic","JEKF-SANTO","JEKF-KPH2"]; 
methods = containers.Map(Keys,Val);


for approach=[000,100,200] %[JEKF-Classic,JEKF-SANTO,JEKF-KPH2]
    offline_bioreactor_dt1=[
    0.3595e6                    32.1954   5.03      0.111019  0.33       0;  %begin of bioreactor 1 dataset (offline) - bioreactor_1_dataset_Data_Alinabioreactor 3L_metabolites_cells count_viral titer.xlsx
    0.709e6                     30.4191   4.7       3.77463   0.91       0;
    1.3287e6                    26.4224   3.97      6.66112   1.32       0;
    1.2691e6                    24.091    3.54      7.88232   1.46       0;
    0.8777e6                    21.7041   2.96      8.27089   1.63       0.0152e9;
    1.49295e6                   20.4829   2.75      8.49292   1.67       0.3015e9;
    1.79725e6                   18.8177   2.49      9.04802   1.65       2.862e9;
    1.86e6                      20.4829   2.75      8.49292   1.67       4.625e9;
    1.75425e6                   14.3769   2.14      10.9353   1.54       5.77e9];

    datasetOnline = csvread("bioreactor_2_dataset_online_hspb.csv"); % bioreactor 2 dataset (online) 

    phase ="after_transfection";

    if phase=="before_transfection";
        offline_bioreactor=offline_bioreactor_dt1(1:3,:); %OFFLINE dataset 
    else
        offline_bioreactor=offline_bioreactor_dt1(4:9,:); %OFFLINE dataset 
    end

    % run 8 = bioreactor 1 dataset (offline)
    % run 9 = bioreactor 2 dataset (online)
    RUNS=[9];

    states_updated= {};


    for run = RUNS;

        % run 9 = bioreactor 2 dataset (online)
        initX = [datasetOnline(3252) ; 26.7039 ;   4.0310  ; 7.4385  ;  1.5678   ;      0; % initial state (Xv,Glc,Gln,Lac,Amm, AVV)
                0.006;  %initial parameters
                1.01e-7;
                2.12e-8;
                2.58571e-8; 
                1.47905e-9; 
                0.0014591; 
                65.6];
         param_only=[0.006 1.01e-7 2.12e-8 2.58571e-8 1.47905e-9 0.0014591 65.6];


        % measurement noise covariance matrix
        R=   130e5;%ok       
        Q_xv=50e5;
        
%          R=   8e6;%ok       
%          Q_xv=50e6;

%         R=   1000e4;%ok       
%         Q_xv=500e4;
        
        if approach == 000 %JEKF-Classic

                H = [1     0     0     0     0     0     0     0    0     0     0     0     0]; % measurement matrix
                initP = diag([0.0,0.0,0.0,0.0,0.0,0.0,                          1.77e-9, 4.76e-5, 1.05e-5, 35.59e-7, 6.71e-10, 8.71e-8,42000]); % initial process co-varince   
                Q = diag([Q_xv, 0.0006, 0.0006, 0.0006, 0.0006, 0.0006,     1.77e-7, .21e-16, 7.86e-18, 13.59e-7, 0.11e-8, 0.71e-8,0.31]) ;% process noise covariance %matrix
                k_mu_glc=[];
                k_mu_lac=[];
                k_mu_raav=[];
                             
        elseif approach == 100 %JEKF-SANTO

                H = [1     0     0     0     0     0     0     0    0     0     0     0     0]; % measurement matrix
                initP = diag([0.0,0.0,0.0,0.0,0.0,0.0,                          1.77e-9, 4.76e-5, 1.05e-5, 35.59e-7, 6.71e-10, 8.71e-8,42000]); % initial process co-varince 
                
                mu_glc=0.000006751;
                initP(8,1) =mu_glc;%0.0000411;
                initP(1,8) =mu_glc;%0.0000411;

                mu_lac=0.0000072505;
                initP(10,1)=mu_lac;
                initP(1,10)=mu_lac;
                
                mu_rAAV=9500.3625;
                initP(13,1)=mu_rAAV;
                initP(1,13)=mu_rAAV;
                
                Q = diag([Q_xv, 0.0006, 0.0006, 0.0006, 0.0006, 0.0006,     1.77e-7, .21e-16, 7.86e-18, 13.59e-7, 0.11e-8, 0.71e-8,0.31]) ;% process noise covariance %matrix

                k_mu_glc=[];
                k_mu_lac=[];
                k_mu_raav=[];
        else  %JEKF-KPH2
            
                H2 = [1     0     0     0     0     0     0     1     1     1     1     1     1]; % measurement matrix
                %new good for new IC 
                initP = diag([0.0,0.0,0.0,0.0,0.0,0.0,                          1.77e-9, 10.66e-6, 1.05e-5, 550.59e-8, 6.71e-10, 8.71e-8,10000]); % initial process co-varince 
                
                Q = diag([Q_xv, 0.0006, 0.0006, 0.0006, 0.0006, 0.0006,         1.77e-7, .21e-16, 7.86e-18, 13.59e-7, 0.11e-8, 0.71e-8,  0.31]) ;% process noise covariance %matrix
                
                H=H2;  
                
                k_mu_glc=[];
                k_mu_lac=[];
                k_mu_raav=[];
        end
         
        init = [initX; initP(:)]; % combined initial value vector for the odesolver


        % full model with ODE for states variables and for parameters
        dS=sym([uxv*Xv;-uglc*Xv;-ugln*Xv;ulac*Xv;uamm*Xv+kdeg*Gln;uaav*Xv;0;0;0;0;0;0;0]);

        % Model with only ODE for states variables
        OdeSysOnly=sym([uxv*Xv;-uglc*Xv;-ugln*Xv;ulac*Xv;uamm*Xv+kdeg*Gln;uaav*Xv]);

        %Jacobian of Model with respect to state variables
        F = jacobian(dS,[Xv,Glc,Gln,Lac,Amm,AAV,uxv, uglc, ugln, ulac, uamm, kdeg, uaav]); %Equation 12
        
        P = sym('P',[13,13]);
      
        dP = F * P + P*F'+Q; %Equation 11 in paper 1 and Equation 14 in paper 2

        %Simulation / State prediction and filtering
        %Assemble all differential equations into a vector of 12 elements %(3x state, 9x P)
        
        OdeSys = matlabFunction([dS(:);dP(:)],'Vars',{t,[Xv; Glc; Gln; Lac; Amm; AAV; uxv; uglc; ugln; ulac; uamm; kdeg; uaav; P(:)]});
        
        % Simulate the process from one measurement time to the next:
        states_updated_EKF = zeros(0,13); %store filtered states in these variables
        SimState = zeros(0,13);
        P_state =[];
        SimTime = [];


        tspanODEonly=[];
        if run==8 % run 8 = bioreactor 1 dataset (offline)
            if phase=="before_transfection"
                time_bioreactor=[0 24 43 57 69 77 90 101 114];
                timeE=time_bioreactor(1+1:3);
                timeObsData=time_bioreactor(1:3);
                t0 = time_bioreactor(1);
                tspanODEonly=[0 43];
            else
                time_bioreactor=[0 24 43 57 69 77 90 101 114];
                timeE=time_bioreactor(4+1:9);
                timeObsData=time_bioreactor(4:9);
                t0 = time_bioreactor(4);
                tspanODEonly=[57 114];
            end
        else  % run 9 = bioreactor 2 dataset (online)
            if phase=="before_transfection"
                timeE = 34-3:1:3231; % 3231 19-3:1:2919-3;Before tran'sfection
                datasetOnline=datasetOnline(34-3:3231);
            else
                timeE = 3252:1:6153; % 3043 After transfection
                datasetOnline=datasetOnline(3252:6153);            
            end
            timeE = timeE/60;
            t0 = timeE(1);
            timeObsData = timeE;
            timeE = timeE(2:end);
            tspanODEonly=[t0 timeE(end)];     
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  JEKF  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        
        innovation_error=[];
        NIS=[];
        Sk=[];
        
        updated_stde_P_xv=[];
        updated_stde_P_GLC=[];
        updated_stde_P_LAC=[];
        updated_stde_P_rAAV=[];
        updated_stde_P_muGLC=[];
        updated_stde_P_muLAC=[];
        updated_stde_P_murAAV=[];

              
        
        for i = 1:numel(timeE)
            tspan = [t0 timeE(i)];
            [T,state] = ode45(OdeSys, tspan, init); % Solve the system of ODE from t-1 to t (simulate / solve model)
            PS = state(end,1:13)';                  % predicted state from the system of ODE
            P_state = [P_state;PS'];                % Save states for plotting
            if run==9
                MS = datasetOnline(i+1);            % measured state from online dataset   
            else
                MS = obs_data(1,i+1);               % measured state from online dataset      
            end
            P = reshape(state(end,14:end),13,13);   % process error covariance matrix
            S=H*P*H'+ R;
            K = P*H'/(S);                   % kalman gain matrix - Equation 13 in paper1
            i_error=MS-PS(1);
            FS = PS + K * (i_error);               % filtered state - Equation 5 and Equation 14 in paper1
            Pfilt = P-K*H*P;                        % filtered process error covariance matrix - Equation 6 and Equation 15(in paper 1) and Equation 18 (in paper2) 
            init = [FS; Pfilt(:)];                  % new initial condition to be used to solve the system of ODE
            t0 = timeE(i);                          % new starting time for next iteration

            % Save intermediate states for plotting

            states_updated_EKF = [states_updated_EKF;FS'];
            state(end,1:13) = NaN;
            SimState = [SimState; state(:,1:13)];
            SimTime = [SimTime; T];

            
            stde_k=sqrt(diag(P));
            
%             updated_stde_P_xv=    [updated_stde_P_xv;stde_k(1)/sqrt(length(updated_stde_P_xv))];
%             updated_stde_P_GLC=   [updated_stde_P_GLC;stde_k(2)/sqrt(length(updated_stde_P_GLC))];
%             updated_stde_P_LAC=   [updated_stde_P_LAC;stde_k(4)/sqrt(length(updated_stde_P_LAC))];
%             updated_stde_P_rAAV=  [updated_stde_P_rAAV;stde_k(6)/sqrt(length(updated_stde_P_rAAV))];
%             updated_stde_P_muGLC= [updated_stde_P_muGLC;stde_k(8)/sqrt(length(updated_stde_P_muGLC))];
%             updated_stde_P_muLAC= [updated_stde_P_muLAC;stde_k(10)/sqrt(length(updated_stde_P_muLAC))];
%             updated_stde_P_murAAV=[updated_stde_P_murAAV;stde_k(13)/sqrt(length(updated_stde_P_murAAV))];
%             
            updated_stde_P_xv=    [updated_stde_P_xv;stde_k(1)];
            updated_stde_P_GLC=   [updated_stde_P_GLC;stde_k(2)];
            updated_stde_P_LAC=   [updated_stde_P_LAC;stde_k(4)];
            updated_stde_P_rAAV=  [updated_stde_P_rAAV;stde_k(6)];
            updated_stde_P_muGLC= [updated_stde_P_muGLC;stde_k(8)];
            updated_stde_P_muLAC= [updated_stde_P_muLAC;stde_k(10)];
            updated_stde_P_murAAV=[updated_stde_P_murAAV;stde_k(13)];

            
            
%       append!(updated_stde_P_xv, sqrt.(abs.(diag(Pfilt)))[1]/sqrt(length(updated_stde_P_xv))) 
%       append!(updated_stde_P_QmAb, sqrt.(abs.(diag(Pfilt)))[8]/sqrt(length(updated_stde_P_QmAb)))
%       append!(updated_stde_P_mAb, sqrt.(abs.(diag(Pfilt)))[7]/sqrt(length(updated_stde_P_mAb)))

            
            k_mu_glc=[k_mu_glc;K(8)];
            k_mu_lac=[k_mu_lac;K(10)];
            k_mu_raav=[k_mu_raav;K(13)];
            innovation_error=[innovation_error;i_error];
            NIS=[NIS;i_error*(1/S)*i_error];
            Sk=[Sk;S];
            
        end

        

         OdeSysOnly = subs(OdeSysOnly, [uxv uglc ugln ulac uamm kdeg uaav], param_only);
         OdeSysOnly = matlabFunction([OdeSysOnly(:)],'Vars',{t,[Xv; Glc; Gln; Lac; Amm; AAV]});
         [T,sol]=ode45(OdeSysOnly, tspanODEonly, initX(1:6));


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  PLOTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        writematrix(timeE,"results/timeEstimations.csv")   

        figure(approach+run);
        counter=1;
        state_names=["Xv (c/mL)" "GLC (mM)" "GLN (mM)" "LAC (mM)" "AMM (mM)" "AAV (VG/mL)" ];
        for j=[1 2 3 4 5 6]
            subplot(3,2,counter);

            plot(timeE,states_updated_EKF(:,j),T,sol(:,j),'r', LineWidth = 2);
            hold on
            title(methods(approach))
            
            

            if run==9 % run 9 = bioreactor 2 dataset (online)

                if j==1 %AAV state estimations
                    plot(timeObsData,datasetOnline,LineWidth = 2) %plot xv - AVV bioreactor 2 dataset (online)                      
    %               plot([3252:1:6153]/60,datasetOnline,LineWidth = 2)   
                    writematrix(timeObsData,"results/timeObsData.csv")
                    writematrix(datasetOnline,"results/Xv_bioreactor_dt2_online.csv")
                    writematrix(states_updated_EKF(:,j),"results/"+methods(approach)+"_Xv.csv")
    
                elseif j==2
                    scatter([4679-3;6144-3]/60,[22.00943658;17.707466],'filled'); %plot AVV offline bioreactor 2 dataset hspb  
                    estimation = [states_updated_EKF(1424,j),states_updated_EKF(2889,j)];
                    ground_truth = [22.00943658,17.707466];
                    mspe=mean(((ground_truth-estimation)./ground_truth).^2);
                    rmspe=sqrt(mspe)*100;
%                      message = sprintf('RMSE GLC of Approach %s: %f',methods(approach),sqrt(mean(([states_updated_EKF(1424,j),states_updated_EKF(2889,j)] - [22.00943658,17.707466]).^2)) );
%                     disp(message)
                     message = sprintf('RMSPE GLC of Approach %s: %f',methods(approach),rmspe );
                    disp(message)

                    writematrix(states_updated_EKF(:,j),"results/"+methods(approach)+"_GLC.csv")

                elseif j==4
                    scatter([4679-3;6144-3]/60,[9.10352484;11.54593394],'filled'); %plot AVV offline bioreactor 2 dataset hspb   
                    estimation = [states_updated_EKF(1424,j),states_updated_EKF(2889,j)];
                    ground_truth = [9.10352484,11.54593394];
                    mspe=mean(((ground_truth-estimation)./ground_truth).^2);
                    rmspe=sqrt(mspe)*100;
%                      message = sprintf('RMSE LAC of Approach %s: %f',methods(approach),sqrt(mean(([states_updated_EKF(1424,j),states_updated_EKF(2889,j)] - [9.10352484,11.54593394]).^2)) );
%                      disp(message)
                     message = sprintf('RMSPE LAC of Approach %s: %f',methods(approach),rmspe );
                    disp(message)

                    writematrix(states_updated_EKF(:,j),"results/"+methods(approach)+"_LAC.csv")

                elseif j==6          
                    timeDO=[3252-3;4679-3;6144-3]/60;
                    scatter(timeDO,[0;3190000000;7010000000],'filled'); %plot AVV offline bioreactor 2 dataset hspb 
                    estimation = [states_updated_EKF(1424,j),states_updated_EKF(2889,j)];
                    ground_truth = [3190000000,7010000000];
                    mspe=mean(((ground_truth-estimation)./ground_truth).^2);
                    rmspe=sqrt(mspe)*100;
%                      message = sprintf('RMSE rAAV of Approach %s: %f',methods(approach),sqrt(mean(([states_updated_EKF(1424,j),states_updated_EKF(2889,j)] - [3190000000,7010000000]).^2)) );
%                     disp(message)
                     message = sprintf('RMSPE rAAV of Approach %s: %f',methods(approach),rmspe );
                    disp(message)

                    writematrix(states_updated_EKF(:,j),"results/"+methods(approach)+"_rAAV.csv")
                end 
                
                
                
                

% 



                
                
                
                
                
                
                
                
            end           

            xlabel('Time (hours)');
            ylabel(state_names(j));

            counter=counter+1;

        end
        hold off

        states_updated{run}=states_updated_EKF;

        legend('EKF','MM','dt2') 
        
        
    end

    params_names=["{\mu}xv (h^{-1})" ,"{\mu}glc (mmol10^{-6} c h^{-1})", "{\mu}gln(mmol10^{-6} c h^{-1})", "{\mu}lac(mmol10^{-6} c h^{-1})", "{\mu}amm(mmol10^{-6} c h^{-1})" ,"kdeg(h^{-1})", "{\mu}AAV(vg/mL h 10^6 c)" ];

    for run = RUNS;
        figure(approach+run+2);
        
        counter=1;
         for j=7:13
                subplot(4,2,counter);
%                 if run==8 & phase =="before_transfection"
%                     plot([24 43],states_updated{run}(:,j));
%                 elseif run==8 & phase =="after_transfection"
%                     plot([69 77 90 101 114],states_updated{run}(:,j));
%                 elseif run==9 & phase =="before_transfection"
%                     plot([2:1:length(datasetOnline)]/60,states_updated{run}(:,j));      
%                 else
                    plot([3253:1:6153]/60,states_updated{run}(:,j)); 
                    title(methods(approach))

                    
%                 end

                hold on
                xlabel('Time (hours)');
                ylabel(params_names(j-6));
                counter=counter+1;
         end 
         hold off
    end  
    
    writematrix(states_updated_EKF(:,8),"results/"+methods(approach)+"_muGLC.csv")
    writematrix(states_updated_EKF(:,10),"results/"+methods(approach)+"_muLAC.csv")
    writematrix(states_updated_EKF(:,13),"results/"+methods(approach)+"_muAAV.csv")

    writematrix(k_mu_glc,"results/"+methods(approach)+"_k_mu_glc.csv")
    writematrix(k_mu_lac,"results/"+methods(approach)+"_k_mu_lac.csv")
    writematrix(k_mu_raav,"results/"+methods(approach)+"_k_mu_raav.csv")

    writematrix(innovation_error,"results/"+methods(approach)+"_innovation_error.csv")
    writematrix(NIS,"results/"+methods(approach)+"_NIS.csv")
    writematrix(Sk,"results/"+methods(approach)+"_Sk.csv")
    
    writematrix(innovation_error,"results/"+methods(approach)+"_innovation_error.csv")
    writematrix(NIS,"results/"+methods(approach)+"_NIS.csv")
    writematrix(Sk,"results/"+methods(approach)+"_Sk.csv")
    
    writematrix(updated_stde_P_xv,"results/"+methods(approach)+"_updated_stde_P_xv.csv")
    writematrix(updated_stde_P_GLC,"results/"+methods(approach)+"_updated_stde_P_GLC.csv")
    writematrix(updated_stde_P_LAC,"results/"+methods(approach)+"_updated_stde_P_LAC.csv")
    writematrix(updated_stde_P_rAAV,"results/"+methods(approach)+"_updated_stde_P_rAAV.csv")
    writematrix(updated_stde_P_muGLC,"results/"+methods(approach)+"_updated_stde_P_muGLC.csv")
    writematrix(updated_stde_P_muLAC,"results/"+methods(approach)+"_updated_stde_P_muLAC.csv")
    writematrix(updated_stde_P_murAAV,"results/"+methods(approach)+"_updated_stde_P_murAAV.csv")
        
    
    
%         updated_stde_P_xv=[];
%         updated_stde_P_GLC=[];
%         updated_stde_P_LAC=[];
%         updated_stde_P_rAAV=[];
%         updated_stde_P_muGLC=[];
%         updated_stde_P_muLAC=[];
%         updated_stde_P_murAAV=[];
    
    
end  
 




