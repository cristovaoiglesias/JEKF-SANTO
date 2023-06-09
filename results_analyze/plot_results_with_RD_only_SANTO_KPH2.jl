using Plots, XLSX, DataFrames, CSV, DifferentialEquations,StatsPlots,Random
using Turing
# Set a seed for reproducibility.
using Random
Random.seed!(14);
using LaTeXStrings

theme(:default)
# gr();
# plotly();







function RMSE(observed_data,prediction)
    t=observed_data
    y=prediction
    se = (t - y).^2
    mse = mean(se)
    rmse = sqrt(mse)
    return rmse
end



abs_path="/Users/cristovao/Devel/bioprocessesDT"




xv_online_measurement_RD_AAV=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/xv_online_measurement_RD_AAV.csv",DataFrame;header=false )

timeEKF=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_synthetic_data/time_h_of_Xv_syntetic_data_with_gaussian_noises.csv",DataFrame;header=false )
timeRD=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/time_RD.csv",DataFrame;header=false )


Xv_online_run41_noise_3=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_synthetic_data/Xv_syntetic_data_run41_with_gaussian_noise_0.5.csv",DataFrame;header=false )
mAb_True_syntetic_data_based_on_run41=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_synthetic_data/mAb_syntetic_data_based_on_run41.csv",DataFrame;header=false )
Xv_syntetic_data_run41_ground_truth=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_synthetic_data/Xv_syntetic_data_run41_ground_truth.csv",DataFrame;header=false )







## Evaluation_with_REAL_data


##--------------------------- specific P(0)
# MRDE-PU P uncorrelated
Xv_result_SIC_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/Xv_result_SIC_pc_rd.csv",DataFrame;header=false )
GLC_result_SIC_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/GLC_result_SIC_pc.csv",DataFrame;header=false )
LAC_result_SIC_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/LAC_result_SIC_pc.csv",DataFrame;header=false )
rAAV_result_SIC_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/rAAV_result_SIC_pc.csv",DataFrame;header=false )
uGLC_result_SIC_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/uGLC_result_SIC_pc.csv",DataFrame;header=false )
uLAC_result_SIC_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/uLAC_result_SIC_pc.csv",DataFrame;header=false )
urAAV_result_SIC_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/urAAV_result_SIC_pc.csv",DataFrame;header=false )

Xv_result_KPH2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/Xv_result_KPH2_pc_rd.csv",DataFrame;header=false )
GLC_result_KPH2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/GLC_result_KPH2_pc.csv",DataFrame;header=false )
LAC_result_KPH2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/LAC_result_KPH2_pc.csv",DataFrame;header=false )
rAAV_result_KPH2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/rAAV_result_KPH2_pc.csv",DataFrame;header=false )
uGLC_result_KPH2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/uGLC_result_KPH2_pc.csv",DataFrame;header=false )
uLAC_result_KPH2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/uLAC_result_KPH2_pc.csv",DataFrame;header=false )
urAAV_result_KPH2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/urAAV_result_KPH2_pc.csv",DataFrame;header=false )

Xv_result_KPH2_pu_rd_sp0_2=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/Xv_result_KPH2_pc_rd_2.csv",DataFrame;header=false )
GLC_result_KPH2_pu_rd_sp0_2=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/GLC_result_KPH2_pc_2.csv",DataFrame;header=false )
LAC_result_KPH2_pu_rd_sp0_2=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/LAC_result_KPH2_pc_2.csv",DataFrame;header=false )
rAAV_result_KPH2_pu_rd_sp0_2=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/rAAV_result_KPH2_pc_2.csv",DataFrame;header=false )
uGLC_result_KPH2_pu_rd_sp0_2=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/uGLC_result_KPH2_pc_2.csv",DataFrame;header=false )
uLAC_result_KPH2_pu_rd_sp0_2=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/uLAC_result_KPH2_pc_2.csv",DataFrame;header=false )
urAAV_result_KPH2_pu_rd_sp0_2=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/urAAV_result_KPH2_pc_2.csv",DataFrame;header=false )

Xv_result_1H2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/Xv_result_1H2_pc_rd.csv",DataFrame;header=false )
GLC_result_1H2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/GLC_result_1H2_pc.csv",DataFrame;header=false )
LAC_result_1H2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/LAC_result_1H2_pc.csv",DataFrame;header=false )
rAAV_result_1H2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/rAAV_result_1H2_pc.csv",DataFrame;header=false )
uGLC_result_1H2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/uGLC_result_1H2_pc.csv",DataFrame;header=false )
uLAC_result_1H2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/uLAC_result_1H2_pc.csv",DataFrame;header=false )
urAAV_result_1H2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/urAAV_result_1H2_pc.csv",DataFrame;header=false )

Xv_result_2H2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/Xv_result_2H2_pc_rd.csv",DataFrame;header=false )
GLC_result_2H2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/GLC_result_2H2_pc.csv",DataFrame;header=false )
LAC_result_2H2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/LAC_result_2H2_pc.csv",DataFrame;header=false )
rAAV_result_2H2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/rAAV_result_2H2_pc.csv",DataFrame;header=false )
uGLC_result_2H2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/uGLC_result_2H2_pc.csv",DataFrame;header=false )
uLAC_result_2H2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/uLAC_result_2H2_pc.csv",DataFrame;header=false )
urAAV_result_2H2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/urAAV_result_2H2_pc.csv",DataFrame;header=false )

# MRDE-PC  P correlated


Xv_result_SIC_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/Xv_result_SIC_pc_rd.csv",DataFrame;header=false )
GLC_result_SIC_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/GLC_result_SIC_pc.csv",DataFrame;header=false )
LAC_result_SIC_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/LAC_result_SIC_pc.csv",DataFrame;header=false )
rAAV_result_SIC_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/rAAV_result_SIC_pc.csv",DataFrame;header=false )
uGLC_result_SIC_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/uGLC_result_SIC_pc.csv",DataFrame;header=false )
uLAC_result_SIC_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/uLAC_result_SIC_pc.csv",DataFrame;header=false )
urAAV_result_SIC_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/urAAV_result_SIC_pc.csv",DataFrame;header=false )

Xv_result_KPH2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/Xv_result_KPH2_pc_rd.csv",DataFrame;header=false )
GLC_result_KPH2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/GLC_result_KPH2_pc.csv",DataFrame;header=false )
LAC_result_KPH2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/LAC_result_KPH2_pc.csv",DataFrame;header=false )
rAAV_result_KPH2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/rAAV_result_KPH2_pc.csv",DataFrame;header=false )
uGLC_result_KPH2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/uGLC_result_KPH2_pc.csv",DataFrame;header=false )
uLAC_result_KPH2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/uLAC_result_KPH2_pc.csv",DataFrame;header=false )
urAAV_result_KPH2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/urAAV_result_KPH2_pc.csv",DataFrame;header=false )

Xv_result_KPH2_pc_rd_sp0_2=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/Xv_result_KPH2_pc_rd_2.csv",DataFrame;header=false )
GLC_result_KPH2_pc_rd_sp0_2=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/GLC_result_KPH2_pc_2.csv",DataFrame;header=false )
LAC_result_KPH2_pc_rd_sp0_2=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/LAC_result_KPH2_pc_2.csv",DataFrame;header=false )
rAAV_result_KPH2_pc_rd_sp0_2=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/rAAV_result_KPH2_pc_2.csv",DataFrame;header=false )
uGLC_result_KPH2_pc_rd_sp0_2=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/uGLC_result_KPH2_pc_2.csv",DataFrame;header=false )
uLAC_result_KPH2_pc_rd_sp0_2=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/uLAC_result_KPH2_pc_2.csv",DataFrame;header=false )
urAAV_result_KPH2_pc_rd_sp0_2=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/urAAV_result_KPH2_pc_2.csv",DataFrame;header=false )

Xv_result_1H2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/Xv_result_1H2_pc_rd.csv",DataFrame;header=false )
GLC_result_1H2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/GLC_result_1H2_pc.csv",DataFrame;header=false )
LAC_result_1H2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/LAC_result_1H2_pc.csv",DataFrame;header=false )
rAAV_result_1H2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/rAAV_result_1H2_pc.csv",DataFrame;header=false )
uGLC_result_1H2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/uGLC_result_1H2_pc.csv",DataFrame;header=false )
uLAC_result_1H2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/uLAC_result_1H2_pc.csv",DataFrame;header=false )
urAAV_result_1H2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/urAAV_result_1H2_pc.csv",DataFrame;header=false )

Xv_result_2H2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/Xv_result_2H2_pc_rd.csv",DataFrame;header=false )
GLC_result_2H2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/GLC_result_2H2_pc.csv",DataFrame;header=false )
LAC_result_2H2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/LAC_result_2H2_pc.csv",DataFrame;header=false )
rAAV_result_2H2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/rAAV_result_2H2_pc.csv",DataFrame;header=false )
uGLC_result_2H2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/uGLC_result_2H2_pc.csv",DataFrame;header=false )
uLAC_result_2H2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/uLAC_result_2H2_pc.csv",DataFrame;header=false )
urAAV_result_2H2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/urAAV_result_2H2_pc.csv",DataFrame;header=false )








##---------------------------  unique P(0)

#MRDE-PU   P uncorrelated
Xv_result_SIC_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/Xv_result_SIC_pc_rd.csv",DataFrame;header=false )
GLC_result_SIC_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/GLC_result_SIC_pc.csv",DataFrame;header=false )
LAC_result_SIC_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/LAC_result_SIC_pc.csv",DataFrame;header=false )
rAAV_result_SIC_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/rAAV_result_SIC_pc.csv",DataFrame;header=false )
uGLC_result_SIC_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/uGLC_result_SIC_pc.csv",DataFrame;header=false )
uLAC_result_SIC_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/uLAC_result_SIC_pc.csv",DataFrame;header=false )
urAAV_result_SIC_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/urAAV_result_SIC_pc.csv",DataFrame;header=false )

Xv_result_KPH2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/Xv_result_KPH2_pc_rd.csv",DataFrame;header=false )
GLC_result_KPH2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/GLC_result_KPH2_pc.csv",DataFrame;header=false )
LAC_result_KPH2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/LAC_result_KPH2_pc.csv",DataFrame;header=false )
rAAV_result_KPH2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/rAAV_result_KPH2_pc.csv",DataFrame;header=false )
uGLC_result_KPH2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/uGLC_result_KPH2_pc.csv",DataFrame;header=false )
uLAC_result_KPH2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/uLAC_result_KPH2_pc.csv",DataFrame;header=false )
urAAV_result_KPH2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/urAAV_result_KPH2_pc.csv",DataFrame;header=false )


Xv_result_1H2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/Xv_result_1H2_pc_rd.csv",DataFrame;header=false )
GLC_result_1H2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/GLC_result_1H2_pc.csv",DataFrame;header=false )
LAC_result_1H2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/LAC_result_1H2_pc.csv",DataFrame;header=false )
rAAV_result_1H2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/rAAV_result_1H2_pc.csv",DataFrame;header=false )
uGLC_result_1H2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/uGLC_result_1H2_pc.csv",DataFrame;header=false )
uLAC_result_1H2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/uLAC_result_1H2_pc.csv",DataFrame;header=false )
urAAV_result_1H2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/urAAV_result_1H2_pc.csv",DataFrame;header=false )

Xv_result_2H2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/Xv_result_2H2_pc_rd.csv",DataFrame;header=false )
GLC_result_2H2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/GLC_result_2H2_pc.csv",DataFrame;header=false )
LAC_result_2H2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/LAC_result_2H2_pc.csv",DataFrame;header=false )
rAAV_result_2H2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/rAAV_result_2H2_pc.csv",DataFrame;header=false )
uGLC_result_2H2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/uGLC_result_2H2_pc.csv",DataFrame;header=false )
uLAC_result_2H2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/uLAC_result_2H2_pc.csv",DataFrame;header=false )
urAAV_result_2H2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/urAAV_result_2H2_pc.csv",DataFrame;header=false )



#MRDE-PC
Xv_result_SIC_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/Xv_result_SIC_pc_rd.csv",DataFrame;header=false )
GLC_result_SIC_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/GLC_result_SIC_pc.csv",DataFrame;header=false )
LAC_result_SIC_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/LAC_result_SIC_pc.csv",DataFrame;header=false )
rAAV_result_SIC_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/rAAV_result_SIC_pc.csv",DataFrame;header=false )
uGLC_result_SIC_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/uGLC_result_SIC_pc.csv",DataFrame;header=false )
uLAC_result_SIC_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/uLAC_result_SIC_pc.csv",DataFrame;header=false )
urAAV_result_SIC_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/urAAV_result_SIC_pc.csv",DataFrame;header=false )

Xv_result_KPH2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/Xv_result_KPH2_pc_rd.csv",DataFrame;header=false )
GLC_result_KPH2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/GLC_result_KPH2_pc.csv",DataFrame;header=false )
LAC_result_KPH2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/LAC_result_KPH2_pc.csv",DataFrame;header=false )
rAAV_result_KPH2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/rAAV_result_KPH2_pc.csv",DataFrame;header=false )
uGLC_result_KPH2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/uGLC_result_KPH2_pc.csv",DataFrame;header=false )
uLAC_result_KPH2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/uLAC_result_KPH2_pc.csv",DataFrame;header=false )
urAAV_result_KPH2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/urAAV_result_KPH2_pc.csv",DataFrame;header=false )

Xv_result_1H2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/Xv_result_1H2_pc_rd.csv",DataFrame;header=false )
GLC_result_1H2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/GLC_result_1H2_pc.csv",DataFrame;header=false )
LAC_result_1H2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/LAC_result_1H2_pc.csv",DataFrame;header=false )
rAAV_result_1H2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/rAAV_result_1H2_pc.csv",DataFrame;header=false )
uGLC_result_1H2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/uGLC_result_1H2_pc.csv",DataFrame;header=false )
uLAC_result_1H2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/uLAC_result_1H2_pc.csv",DataFrame;header=false )
urAAV_result_1H2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/urAAV_result_1H2_pc.csv",DataFrame;header=false )

Xv_result_2H2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/Xv_result_2H2_pc_rd.csv",DataFrame;header=false )
GLC_result_2H2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/GLC_result_2H2_pc.csv",DataFrame;header=false )
LAC_result_2H2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/LAC_result_2H2_pc.csv",DataFrame;header=false )
rAAV_result_2H2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/rAAV_result_2H2_pc.csv",DataFrame;header=false )
uGLC_result_2H2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/uGLC_result_2H2_pc.csv",DataFrame;header=false )
uLAC_result_2H2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/uLAC_result_2H2_pc.csv",DataFrame;header=false )
urAAV_result_2H2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/urAAV_result_2H2_pc.csv",DataFrame;header=false )


















# gr( xtickfontsize=13, ytickfontsize=13, xguidefontsize=16, yguidefontsize=16, legendfontsize=13);







timeRD=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/time_RD.csv",DataFrame;header=false )

##MRDE-PU -----PU and unique P(0)
println("PU and unique P(0)aa")

plot0=plot(Array(timeRD)',Array(xv_online_measurement_RD_AAV),color=:lightblue, label = "Xv online (noise)", lw=5.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
plot!(Array(timeRD)',Array(Xv_result_SIC_pu_rd),color=:blue, label = "JEKF-SANTO", lw=2.5,xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# plot!(Array(timeRD)',Array(Xv_result_1H2_pu_rd),color=:black, label = "JEKF-1H2", lw=2.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# plot!(Array(timeRD)',Array(Xv_result_2H2_pu_rd),color=:orange, label = "JEKF-2H2", lw=2.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
plot!(Array(timeRD)',Array(Xv_result_KPH2_pu_rd),color=:green,label = "JEKF-KPH2",  lw=2.5,xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
plot!(legend=:bottomright,size = (650,450))

plot1=plot(Array(timeRD)',Array(GLC_result_SIC_pu_rd),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
# plot!(Array(timeRD)',Array(GLC_result_1H2_pu_rd),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"GLC(mM)")
# plot!(Array(timeRD)',Array(GLC_result_2H2_pu_rd),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
plot!(Array(timeRD)',Array(GLC_result_KPH2_pu_rd),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"GLC(mM)")
Plots.scatter!([4679-3;6144-3]/60,[22.00943658;17.707466],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
plot!(legend=:bottomleft)

plot2=plot(Array(timeRD)',Array(LAC_result_SIC_pu_rd),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
# plot!(Array(timeRD)',Array(LAC_result_1H2_pu_rd),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"LAC(mM)")
# plot!(Array(timeRD)',Array(LAC_result_2H2_pu_rd),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
plot!(Array(timeRD)',Array(LAC_result_KPH2_pu_rd),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"LAC(mM)")
Plots.scatter!([4679-3;6144-3]/60,[9.10352484;11.54593394],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
plot!(legend=false)

plot3=plot(Array(timeRD)',Array(rAAV_result_SIC_pu_rd),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# plot!(Array(timeRD)',Array(rAAV_result_1H2_pu_rd),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# plot!(Array(timeRD)',Array(rAAV_result_2H2_pu_rd),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
plot!(Array(timeRD)',Array(rAAV_result_KPH2_pu_rd),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
Plots.scatter!([3252-3;4679-3;6144-3]/60,[0;3190000000/10^9;7010000000/10^9],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
plot!(legend=false)


ar=Array(GLC_result_SIC_pu_rd)
println("plot1\nRMSE(GLC Ground truth vs SANTO): ",RMSE([ar[1424];ar[2889]],[22.00943658;17.707466]))
ar=Array(GLC_result_KPH2_pu_rd)
println("RMSE(GLC Ground truth vs KPH2): ",RMSE([ar[1424];ar[2889]],[22.00943658;17.707466]))

ar=Array(LAC_result_SIC_pu_rd)
println("RMSE(LAC Ground truth vs SANTO): ",RMSE([ar[1424];ar[2889]],[9.10352484;11.54593394]))
ar=Array(LAC_result_KPH2_pu_rd)
println("RMSE(LAC Ground truth vs KPH2): ",RMSE([ar[1424];ar[2889]],[9.10352484;11.54593394]))

ar=Array(rAAV_result_SIC_pu_rd)
println("RMSE(rAAV Ground truth vs SANTO): ",RMSE([ar[1];ar[1424];ar[2889]],[0;3190000000/10^9;7010000000/10^9]))
ar=Array(rAAV_result_KPH2_pu_rd)
println("RMSE(rAAV Ground truth vs KPH2): ",RMSE([ar[1];ar[1424];ar[2889]],[0;3190000000/10^9;7010000000/10^9]))



plot4=plot(Array(timeRD)',Array(uGLC_result_SIC_pu_rd),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# plot!(Array(timeRD)',Array(uGLC_result_1H2_pu_rd),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# plot!(Array(timeRD)',Array(uGLC_result_2H2_pu_rd),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
plot!(Array(timeRD)',Array(uGLC_result_KPH2_pu_rd),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
plot!(legend=false)

plot5=plot(Array(timeRD)',Array(uLAC_result_SIC_pu_rd),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# plot!(Array(timeRD)',Array(uLAC_result_1H2_pu_rd),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# plot!(Array(timeRD)',Array(uLAC_result_2H2_pu_rd),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
plot!(Array(timeRD)',Array(uLAC_result_KPH2_pu_rd),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
plot!(legend=false)

plot6=plot(Array(timeRD)',Array(urAAV_result_SIC_pu_rd),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# plot!(Array(timeRD)',Array(urAAV_result_1H2_pu_rd),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# plot!(Array(timeRD)',Array(urAAV_result_2H2_pu_rd),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
plot!(Array(timeRD)',Array(urAAV_result_KPH2_pu_rd),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
plot!(legend=false)

pp=plot(plot0,plot1,plot2,plot3,plot4,plot5,plot6, layout=(4,2),size = (800,900))
savefig(abs_path*"/JEKF-SANTO/results_analyze/figs/real_dt/estimations_RD_Puncorrelated.png")
display(pp)


## MRDE-PC-----PC and unique P(0)
println("PC and unique P(0)aa")

plot0=plot(Array(timeRD)',Array(xv_online_measurement_RD_AAV),color=:lightblue, label = "Xv online (noise)", lw=5.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
plot!(Array(timeRD)',Array(Xv_result_SIC_pc_rd),color=:blue, label = "JEKF-SANTO", lw=2.5,xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# plot!(Array(timeRD)',Array(Xv_result_1H2_pc_rd),color=:black, label = "JEKF-1H2", lw=2.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# plot!(Array(timeRD)',Array(Xv_result_2H2_pc_rd),color=:orange, label = "JEKF-2H2", lw=2.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
plot!(Array(timeRD)',Array(Xv_result_KPH2_pc_rd),color=:green,label = "JEKF-KPH2",  lw=2.5,xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
plot!(legend=:bottomright,size = (650,450))

plot1=plot(Array(timeRD)',Array(GLC_result_SIC_pc_rd),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
# plot!(Array(timeRD)',Array(GLC_result_1H2_pc_rd),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"GLC(mM)")
# plot!(Array(timeRD)',Array(GLC_result_2H2_pc_rd),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
plot!(Array(timeRD)',Array(GLC_result_KPH2_pc_rd),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"GLC(mM)")
Plots.scatter!([4679-3;6144-3]/60,[22.00943658;17.707466],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
plot!(legend=:bottomleft)

plot2=plot(Array(timeRD)',Array(LAC_result_SIC_pc_rd),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
# plot!(Array(timeRD)',Array(LAC_result_1H2_pc_rd),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"LAC(mM)")
# plot!(Array(timeRD)',Array(LAC_result_2H2_pc_rd),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
plot!(Array(timeRD)',Array(LAC_result_KPH2_pc_rd),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"LAC(mM)")
Plots.scatter!([4679-3;6144-3]/60,[9.10352484;11.54593394],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
plot!(legend=false)

plot3=plot(Array(timeRD)',Array(rAAV_result_SIC_pc_rd),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# plot!(Array(timeRD)',Array(rAAV_result_1H2_pc_rd),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# plot!(Array(timeRD)',Array(rAAV_result_2H2_pc_rd),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
plot!(Array(timeRD)',Array(rAAV_result_KPH2_pc_rd),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
Plots.scatter!([3252-3;4679-3;6144-3]/60,[0;3190000000/10^9;7010000000/10^9],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
plot!(legend=false)


ar=Array(GLC_result_SIC_pc_rd)
println("plot2\nRMSE(GLC Ground truth vs SANTO): ",RMSE([ar[1424];ar[2889]],[22.00943658;17.707466]))
ar=Array(GLC_result_KPH2_pc_rd)
println("RMSE(GLC Ground truth vs KPH2): ",RMSE([ar[1424];ar[2889]],[22.00943658;17.707466]))

ar=Array(LAC_result_SIC_pc_rd)
println("RMSE(LAC Ground truth vs SANTO): ",RMSE([ar[1424];ar[2889]],[9.10352484;11.54593394]))
ar=Array(LAC_result_KPH2_pc_rd)
println("RMSE(LAC Ground truth vs KPH2): ",RMSE([ar[1424];ar[2889]],[9.10352484;11.54593394]))

ar=Array(rAAV_result_SIC_pc_rd)
println("RMSE(rAAV Ground truth vs SANTO): ",RMSE([ar[1];ar[1424];ar[2889]],[0;3190000000/10^9;7010000000/10^9]))
ar=Array(rAAV_result_KPH2_pc_rd)
println("RMSE(rAAV Ground truth vs KPH2): ",RMSE([ar[1];ar[1424];ar[2889]],[0;3190000000/10^9;7010000000/10^9]))



plot4=plot(Array(timeRD)',Array(uGLC_result_SIC_pc_rd),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# plot!(Array(timeRD)',Array(uGLC_result_1H2_pc_rd),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# plot!(Array(timeRD)',Array(uGLC_result_2H2_pc_rd),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
plot!(Array(timeRD)',Array(uGLC_result_KPH2_pc_rd),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
plot!(legend=false)

plot5=plot(Array(timeRD)',Array(uLAC_result_SIC_pc_rd),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# plot!(Array(timeRD)',Array(uLAC_result_1H2_pc_rd),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# plot!(Array(timeRD)',Array(uLAC_result_2H2_pc_rd),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
plot!(Array(timeRD)',Array(uLAC_result_KPH2_pc_rd),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
plot!(legend=false)

plot6=plot(Array(timeRD)',Array(urAAV_result_SIC_pc_rd),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# plot!(Array(timeRD)',Array(urAAV_result_1H2_pc_rd),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# plot!(Array(timeRD)',Array(urAAV_result_2H2_pc_rd),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
plot!(Array(timeRD)',Array(urAAV_result_KPH2_pc_rd),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
plot!(legend=false)

pp=plot(plot0,plot1,plot2,plot3,plot4,plot5,plot6, layout=(4,2),size = (800,900))
savefig(abs_path*"/JEKF-SANTO/results_analyze/figs/real_dt/estimations_RD_Pcorrelated.png")

display(pp)







## MRDE-PU-----PU and specific P(0)
println("PU and specific P(0)")

plot0=plot(Array(timeRD)',Array(xv_online_measurement_RD_AAV),color=:lightblue, label = "Xv online (noise)", lw=5.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
plot!(Array(timeRD)',Array(Xv_result_SIC_pu_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=2.5,xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# plot!(Array(timeRD)',Array(Xv_result_1H2_pu_rd_sp0),color=:black, label = "JEKF-1H2", lw=2.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# plot!(Array(timeRD)',Array(Xv_result_2H2_pu_rd_sp0),color=:orange, label = "JEKF-2H2", lw=2.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
plot!(Array(timeRD)',Array(Xv_result_KPH2_pu_rd_sp0),color=:green,label = "JEKF-KPH2",  lw=2.5,xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
plot!(legend=:bottomright,size = (650,450))

plot1=plot(Array(timeRD)',Array(GLC_result_SIC_pu_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
# plot!(Array(timeRD)',Array(GLC_result_1H2_pu_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"GLC(mM)")
# plot!(Array(timeRD)',Array(GLC_result_2H2_pu_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
plot!(Array(timeRD)',Array(GLC_result_KPH2_pu_rd_sp0),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"GLC(mM)")
Plots.scatter!([4679-3;6144-3]/60,[22.00943658;17.707466],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
plot!(legend=:bottomleft)

plot2=plot(Array(timeRD)',Array(LAC_result_SIC_pu_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
# plot!(Array(timeRD)',Array(LAC_result_1H2_pu_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"LAC(mM)")
# plot!(Array(timeRD)',Array(LAC_result_2H2_pu_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
plot!(Array(timeRD)',Array(LAC_result_KPH2_pu_rd_sp0),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"LAC(mM)")
Plots.scatter!([4679-3;6144-3]/60,[9.10352484;11.54593394],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
plot!(legend=false)

plot3=plot(Array(timeRD)',Array(rAAV_result_SIC_pu_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# plot!(Array(timeRD)',Array(rAAV_result_1H2_pu_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# plot!(Array(timeRD)',Array(rAAV_result_2H2_pu_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
plot!(Array(timeRD)',Array(rAAV_result_KPH2_pu_rd_sp0),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
Plots.scatter!([3252-3;4679-3;6144-3]/60,[0;3190000000/10^9;7010000000/10^9],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
plot!(legend=false)


ar=Array(GLC_result_SIC_pu_rd_sp0)
println("plot3\nRMSE(GLC Ground truth vs SANTO): ",RMSE([ar[1424];ar[2889]],[22.00943658;17.707466]))
ar=Array(GLC_result_KPH2_pu_rd_sp0)
println("RMSE(GLC Ground truth vs KPH2): ",RMSE([ar[1424];ar[2889]],[22.00943658;17.707466]))

ar=Array(LAC_result_SIC_pu_rd_sp0)
println("RMSE(LAC Ground truth vs SANTO): ",RMSE([ar[1424];ar[2889]],[9.10352484;11.54593394]))
ar=Array(LAC_result_KPH2_pu_rd_sp0)
println("RMSE(LAC Ground truth vs KPH2): ",RMSE([ar[1424];ar[2889]],[9.10352484;11.54593394]))

ar=Array(rAAV_result_SIC_pu_rd_sp0)
println("RMSE(rAAV Ground truth vs SANTO): ",RMSE([ar[1];ar[1424];ar[2889]],[0;3190000000/10^9;7010000000/10^9]))
ar=Array(rAAV_result_KPH2_pu_rd_sp0)
println("RMSE(rAAV Ground truth vs KPH2): ",RMSE([ar[1];ar[1424];ar[2889]],[0;3190000000/10^9;7010000000/10^9]))




plot4=plot(Array(timeRD)',Array(uGLC_result_SIC_pu_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# plot!(Array(timeRD)',Array(uGLC_result_1H2_pu_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# plot!(Array(timeRD)',Array(uGLC_result_2H2_pu_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
plot!(Array(timeRD)',Array(uGLC_result_KPH2_pu_rd_sp0),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
plot!(legend=false)

plot5=plot(Array(timeRD)',Array(uLAC_result_SIC_pu_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# plot!(Array(timeRD)',Array(uLAC_result_1H2_pu_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# plot!(Array(timeRD)',Array(uLAC_result_2H2_pu_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
plot!(Array(timeRD)',Array(uLAC_result_KPH2_pu_rd_sp0),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
plot!(legend=false)

plot6=plot(Array(timeRD)',Array(urAAV_result_SIC_pu_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# plot!(Array(timeRD)',Array(urAAV_result_1H2_pu_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# plot!(Array(timeRD)',Array(urAAV_result_2H2_pu_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
plot!(Array(timeRD)',Array(urAAV_result_KPH2_pu_rd_sp0),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
plot!(legend=false)

pp=plot(plot0,plot1,plot2,plot3,plot4,plot5,plot6, layout=(4,2),size = (800,900))
savefig(abs_path*"/JEKF-SANTO/results_analyze/figs/real_dt/estimations_RD_Puncorrelated_sp0.png")

display(pp)


## MRDE-PC -----PC and specific P(0)
println("PC and specific P(0)")

plot0=plot(Array(timeRD)',Array(xv_online_measurement_RD_AAV),color=:lightblue, label = "Xv online (noise)", lw=5.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
plot!(Array(timeRD)',Array(Xv_result_SIC_pc_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=2.5,xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# plot!(Array(timeRD)',Array(Xv_result_1H2_pc_rd_sp0),color=:black, label = "JEKF-1H2", lw=2.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# plot!(Array(timeRD)',Array(Xv_result_2H2_pc_rd_sp0),color=:orange, label = "JEKF-2H2", lw=2.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
plot!(Array(timeRD)',Array(Xv_result_KPH2_pc_rd_sp0),color=:green,label = "JEKF-KPH2",  lw=2.5,xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
plot!(legend=:bottomright,size = (650,450))

plot1=plot(Array(timeRD)',Array(GLC_result_SIC_pc_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
# plot!(Array(timeRD)',Array(GLC_result_1H2_pc_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"GLC(mM)")
# plot!(Array(timeRD)',Array(GLC_result_2H2_pc_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
plot!(Array(timeRD)',Array(GLC_result_KPH2_pc_rd_sp0),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"GLC(mM)")
Plots.scatter!([4679-3;6144-3]/60,[22.00943658;17.707466],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
plot!(legend=:bottomleft)

plot2=plot(Array(timeRD)',Array(LAC_result_SIC_pc_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
# plot!(Array(timeRD)',Array(LAC_result_1H2_pc_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"LAC(mM)")
# plot!(Array(timeRD)',Array(LAC_result_2H2_pc_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
plot!(Array(timeRD)',Array(LAC_result_KPH2_pc_rd_sp0),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"LAC(mM)")
Plots.scatter!([4679-3;6144-3]/60,[9.10352484;11.54593394],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
plot!(legend=false)

plot3=plot(Array(timeRD)',Array(rAAV_result_SIC_pc_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# plot!(Array(timeRD)',Array(rAAV_result_1H2_pc_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# plot!(Array(timeRD)',Array(rAAV_result_2H2_pc_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
plot!(Array(timeRD)',Array(rAAV_result_KPH2_pc_rd_sp0),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
Plots.scatter!([3252-3;4679-3;6144-3]/60,[0;3190000000/10^9;7010000000/10^9],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
plot!(legend=false)


ar=Array(GLC_result_SIC_pc_rd_sp0)
println("plot4\nRMSE(GLC Ground truth vs SANTO): ",RMSE([ar[1424];ar[2889]],[22.00943658;17.707466]))
ar=Array(GLC_result_KPH2_pc_rd_sp0)
println("RMSE(GLC Ground truth vs KPH2): ",RMSE([ar[1424];ar[2889]],[22.00943658;17.707466]))

ar=Array(LAC_result_SIC_pc_rd_sp0)
println("RMSE(LAC Ground truth vs SANTO): ",RMSE([ar[1424];ar[2889]],[9.10352484;11.54593394]))
ar=Array(LAC_result_KPH2_pc_rd_sp0)
println("RMSE(LAC Ground truth vs KPH2): ",RMSE([ar[1424];ar[2889]],[9.10352484;11.54593394]))

ar=Array(rAAV_result_SIC_pc_rd_sp0)
println("RMSE(rAAV Ground truth vs SANTO): ",RMSE([ar[1];ar[1424];ar[2889]],[0;3190000000/10^9;7010000000/10^9]))
ar=Array(rAAV_result_KPH2_pc_rd_sp0)
println("RMSE(rAAV Ground truth vs KPH2): ",RMSE([ar[1];ar[1424];ar[2889]],[0;3190000000/10^9;7010000000/10^9]))



plot4=plot(Array(timeRD)',Array(uGLC_result_SIC_pc_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# plot!(Array(timeRD)',Array(uGLC_result_1H2_pc_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# plot!(Array(timeRD)',Array(uGLC_result_2H2_pc_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
plot!(Array(timeRD)',Array(uGLC_result_KPH2_pc_rd_sp0),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
plot!(legend=false)

plot5=plot(Array(timeRD)',Array(uLAC_result_SIC_pc_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# plot!(Array(timeRD)',Array(uLAC_result_1H2_pc_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# plot!(Array(timeRD)',Array(uLAC_result_2H2_pc_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
plot!(Array(timeRD)',Array(uLAC_result_KPH2_pc_rd_sp0),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
plot!(legend=false)

plot6=plot(Array(timeRD)',Array(urAAV_result_SIC_pc_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# plot!(Array(timeRD)',Array(urAAV_result_1H2_pc_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# plot!(Array(timeRD)',Array(urAAV_result_2H2_pc_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
plot!(Array(timeRD)',Array(urAAV_result_KPH2_pc_rd_sp0),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
plot!(legend=false)

pp=plot(plot0,plot1,plot2,plot3,plot4,plot5,plot6, layout=(4,2),size = (800,900))
savefig(abs_path*"/JEKF-SANTO/results_analyze/figs/real_dt/estimations_RD_Pcorrelated_sp0.png")

display(pp)




#
#
#
#
# plot0=plot(Array(timeRD)',Array(xv_online_measurement_RD_AAV),color=:lightblue, label = "Xv online (noise)", lw=5.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# plot!(Array(timeRD)',Array(Xv_result_KPH2_pc_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=2.5,xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# plot!(legend=:bottomright,size = (650,450))
#
# plot1=
# plot(Array(timeRD)',Array(GLC_result_KPH2_pc_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"GLC(mM)")
# Plots.scatter!([4679-3;6144-3]/60,[22.00943658;17.707466],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
# plot!(legend=:bottomleft)
#
# plot2=
# plot(Array(timeRD)',Array(LAC_result_KPH2_pc_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"LAC(mM)")
# Plots.scatter!([4679-3;6144-3]/60,[9.10352484;11.54593394],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
# plot!(legend=false)
#
# plot3=
# plot(Array(timeRD)',Array(rAAV_result_KPH2_pc_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# Plots.scatter!([3252-3;4679-3;6144-3]/60,[0;3190000000/10^9;7010000000/10^9],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# plot!(legend=false)
#
# plot4=
# plot(Array(timeRD)',Array(uGLC_result_KPH2_pc_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# plot!(legend=false)
#
# plot5=
# plot(Array(timeRD)',Array(uLAC_result_KPH2_pc_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# plot!(legend=false)
#
# plot6=
# plot(Array(timeRD)',Array(urAAV_result_KPH2_pc_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# plot!(legend=false)
#
# pp=plot(plot0,plot1,plot2,plot3,plot4,plot5,plot6, layout=(4,2),size = (800,900))
# savefig(abs_path*"/JEKF-SANTO/results_analyze/figs/real_dt/estimations_RD_KPH2_Pcorrelated_sp0.png")
#
# display(pp)
#
#
#
#
#
# plot0=plot(Array(timeRD)',Array(xv_online_measurement_RD_AAV),color=:lightblue, label = "Xv online (noise)", lw=5.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# plot!(Array(timeRD)',Array(Xv_result_KPH2_pu_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=2.5,xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# plot!(legend=:bottomright,size = (650,450))
#
# plot1=
# plot(Array(timeRD)',Array(GLC_result_KPH2_pu_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"GLC(mM)")
# Plots.scatter!([4679-3;6144-3]/60,[22.00943658;17.707466],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
# plot!(legend=:bottomleft)
#
# plot2=
# plot(Array(timeRD)',Array(LAC_result_KPH2_pu_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"LAC(mM)")
# Plots.scatter!([4679-3;6144-3]/60,[9.10352484;11.54593394],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
# plot!(legend=false)
#
# plot3=
# plot(Array(timeRD)',Array(rAAV_result_KPH2_pu_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# Plots.scatter!([3252-3;4679-3;6144-3]/60,[0;3190000000/10^9;7010000000/10^9],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# plot!(legend=false)
#
# plot4=
# plot(Array(timeRD)',Array(uGLC_result_KPH2_pu_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# plot!(legend=false)
#
# plot5=
# plot(Array(timeRD)',Array(uLAC_result_KPH2_pu_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# plot!(legend=false)
#
# plot6=
# plot(Array(timeRD)',Array(urAAV_result_KPH2_pu_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# plot!(legend=false)
#
# pp=plot(plot0,plot1,plot2,plot3,plot4,plot5,plot6, layout=(4,2),size = (800,900))
# savefig(abs_path*"/JEKF-SANTO/results_analyze/figs/real_dt/estimations_RD_KPH2_Puncorrelated_sp0.png")
#
# display(pp)
#
#











## MRDE-PU-----PU and specific P(0) and Q
println("PU and specific P(0) and Q")

plot0=plot(Array(timeRD)',Array(xv_online_measurement_RD_AAV),color=:lightblue, label = "Xv online (noise)", lw=5.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
plot!(Array(timeRD)',Array(Xv_result_SIC_pu_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=2.5,xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# plot!(Array(timeRD)',Array(Xv_result_1H2_pu_rd_sp0),color=:black, label = "JEKF-1H2", lw=2.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# plot!(Array(timeRD)',Array(Xv_result_2H2_pu_rd_sp0),color=:orange, label = "JEKF-2H2", lw=2.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
plot!(Array(timeRD)',Array(Xv_result_KPH2_pu_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=2.5,xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
plot!(legend=:bottomright,size = (650,450))

plot1=plot(Array(timeRD)',Array(GLC_result_SIC_pu_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
# plot!(Array(timeRD)',Array(GLC_result_1H2_pu_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"GLC(mM)")
# plot!(Array(timeRD)',Array(GLC_result_2H2_pu_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
plot!(Array(timeRD)',Array(GLC_result_KPH2_pu_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"GLC(mM)")
Plots.scatter!([4679-3;6144-3]/60,[22.00943658;17.707466],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
plot!(legend=:bottomleft)

plot2=plot(Array(timeRD)',Array(LAC_result_SIC_pu_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
# plot!(Array(timeRD)',Array(LAC_result_1H2_pu_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"LAC(mM)")
# plot!(Array(timeRD)',Array(LAC_result_2H2_pu_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
plot!(Array(timeRD)',Array(LAC_result_KPH2_pu_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"LAC(mM)")
Plots.scatter!([4679-3;6144-3]/60,[9.10352484;11.54593394],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
plot!(legend=false)

plot3=plot(Array(timeRD)',Array(rAAV_result_SIC_pu_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# plot!(Array(timeRD)',Array(rAAV_result_1H2_pu_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# plot!(Array(timeRD)',Array(rAAV_result_2H2_pu_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
plot!(Array(timeRD)',Array(rAAV_result_KPH2_pu_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
Plots.scatter!([3252-3;4679-3;6144-3]/60,[0;3190000000/10^9;7010000000/10^9],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
plot!(legend=false)


ar=Array(GLC_result_SIC_pu_rd_sp0)
println("plot5\nRMSE(GLC Ground truth vs SANTO): ",RMSE([ar[1424];ar[2889]],[22.00943658;17.707466]))
ar=Array(GLC_result_KPH2_pu_rd_sp0_2)
println("RMSE(GLC Ground truth vs KPH2): ",RMSE([ar[1424];ar[2889]],[22.00943658;17.707466]))

ar=Array(LAC_result_SIC_pu_rd_sp0)
println("RMSE(LAC Ground truth vs SANTO): ",RMSE([ar[1424];ar[2889]],[9.10352484;11.54593394]))
ar=Array(LAC_result_KPH2_pu_rd_sp0_2)
println("RMSE(LAC Ground truth vs KPH2): ",RMSE([ar[1424];ar[2889]],[9.10352484;11.54593394]))

ar=Array(rAAV_result_SIC_pu_rd_sp0)
println("RMSE(rAAV Ground truth vs SANTO): ",RMSE([ar[1];ar[1424];ar[2889]],[0;3190000000/10^9;7010000000/10^9]))
ar=Array(rAAV_result_KPH2_pu_rd_sp0_2)
println("RMSE(rAAV Ground truth vs KPH2): ",RMSE([ar[1];ar[1424];ar[2889]],[0;3190000000/10^9;7010000000/10^9]))







plot4=plot(Array(timeRD)',Array(uGLC_result_SIC_pu_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# plot!(Array(timeRD)',Array(uGLC_result_1H2_pu_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# plot!(Array(timeRD)',Array(uGLC_result_2H2_pu_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
plot!(Array(timeRD)',Array(uGLC_result_KPH2_pu_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
plot!(legend=false)

plot5=plot(Array(timeRD)',Array(uLAC_result_SIC_pu_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# plot!(Array(timeRD)',Array(uLAC_result_1H2_pu_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# plot!(Array(timeRD)',Array(uLAC_result_2H2_pu_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
plot!(Array(timeRD)',Array(uLAC_result_KPH2_pu_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
plot!(legend=false)

plot6=plot(Array(timeRD)',Array(urAAV_result_SIC_pu_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# plot!(Array(timeRD)',Array(urAAV_result_1H2_pu_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# plot!(Array(timeRD)',Array(urAAV_result_2H2_pu_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
plot!(Array(timeRD)',Array(urAAV_result_KPH2_pu_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
plot!(legend=false)

pp=plot(plot0,plot1,plot2,plot3,plot4,plot5,plot6, layout=(4,2),size = (800,900))
savefig(abs_path*"/JEKF-SANTO/results_analyze/figs/real_dt/estimations_RD_KPH2_Puncorrelated_sp0.png")

display(pp)
















## MRDE-PC-----PC and specific P(0) and Q

println("PC and specific P(0) and Q")

plot0=plot(Array(timeRD)',Array(xv_online_measurement_RD_AAV),color=:lightblue, label = "Xv online (noise)", lw=5.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
plot!(Array(timeRD)',Array(Xv_result_SIC_pc_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=2.5,xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# plot!(Array(timeRD)',Array(Xv_result_1H2_pc_rd_sp0),color=:black, label = "JEKF-1H2", lw=2.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# plot!(Array(timeRD)',Array(Xv_result_2H2_pc_rd_sp0),color=:orange, label = "JEKF-2H2", lw=2.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
plot!(Array(timeRD)',Array(Xv_result_KPH2_pc_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=2.5,xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
plot!(legend=:bottomright,size = (650,450))

plot1=plot(Array(timeRD)',Array(GLC_result_SIC_pc_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
# plot!(Array(timeRD)',Array(GLC_result_1H2_pc_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"GLC(mM)")
# plot!(Array(timeRD)',Array(GLC_result_2H2_pc_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
plot!(Array(timeRD)',Array(GLC_result_KPH2_pc_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"GLC(mM)")
Plots.scatter!([4679-3;6144-3]/60,[22.00943658;17.707466],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
plot!(legend=:bottomleft)

plot2=plot(Array(timeRD)',Array(LAC_result_SIC_pc_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
# plot!(Array(timeRD)',Array(LAC_result_1H2_pc_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"LAC(mM)")
# plot!(Array(timeRD)',Array(LAC_result_2H2_pc_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
plot!(Array(timeRD)',Array(LAC_result_KPH2_pc_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"LAC(mM)")
Plots.scatter!([4679-3;6144-3]/60,[9.10352484;11.54593394],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
plot!(legend=false)

plot3=plot(Array(timeRD)',Array(rAAV_result_SIC_pc_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# plot!(Array(timeRD)',Array(rAAV_result_1H2_pc_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# plot!(Array(timeRD)',Array(rAAV_result_2H2_pc_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
plot!(Array(timeRD)',Array(rAAV_result_KPH2_pc_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
Plots.scatter!([3252-3;4679-3;6144-3]/60,[0;3190000000/10^9;7010000000/10^9],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
plot!(legend=false)


ar=Array(GLC_result_SIC_pc_rd_sp0)
println("plot6\nRMSE(GLC Ground truth vs SANTO): ",RMSE([ar[1424];ar[2889]],[22.00943658;17.707466]))
ar=Array(GLC_result_KPH2_pc_rd_sp0_2)
println("RMSE(GLC Ground truth vs KPH2): ",RMSE([ar[1424];ar[2889]],[22.00943658;17.707466]))

ar=Array(LAC_result_SIC_pc_rd_sp0)
println("RMSE(LAC Ground truth vs SANTO): ",RMSE([ar[1424];ar[2889]],[9.10352484;11.54593394]))
ar=Array(LAC_result_KPH2_pc_rd_sp0_2)
println("RMSE(LAC Ground truth vs KPH2): ",RMSE([ar[1424];ar[2889]],[9.10352484;11.54593394]))

ar=Array(rAAV_result_SIC_pc_rd_sp0)
println("RMSE(rAAV Ground truth vs SANTO): ",RMSE([ar[1];ar[1424];ar[2889]],[0;3190000000/10^9;7010000000/10^9]))
ar=Array(rAAV_result_KPH2_pc_rd_sp0_2)
println("RMSE(rAAV Ground truth vs KPH2): ",RMSE([ar[1];ar[1424];ar[2889]],[0;3190000000/10^9;7010000000/10^9]))






plot4=plot(Array(timeRD)',Array(uGLC_result_SIC_pc_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# plot!(Array(timeRD)',Array(uGLC_result_1H2_pc_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# plot!(Array(timeRD)',Array(uGLC_result_2H2_pc_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
plot!(Array(timeRD)',Array(uGLC_result_KPH2_pc_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
plot!(legend=false)

plot5=plot(Array(timeRD)',Array(uLAC_result_SIC_pc_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# plot!(Array(timeRD)',Array(uLAC_result_1H2_pc_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# plot!(Array(timeRD)',Array(uLAC_result_2H2_pc_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
plot!(Array(timeRD)',Array(uLAC_result_KPH2_pc_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
plot!(legend=false)

plot6=plot(Array(timeRD)',Array(urAAV_result_SIC_pc_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# plot!(Array(timeRD)',Array(urAAV_result_1H2_pc_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# plot!(Array(timeRD)',Array(urAAV_result_2H2_pc_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
plot!(Array(timeRD)',Array(urAAV_result_KPH2_pc_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
plot!(legend=false)

pp=plot(plot0,plot1,plot2,plot3,plot4,plot5,plot6, layout=(4,2),size = (800,900))
savefig(abs_path*"/JEKF-SANTO/results_analyze/figs/real_dt/estimations_RD_KPH2_Pcorrelated_sp0.png")

display(pp)



# index_GLC=[1424,2889]
# index_LAC=[1424,2889]
# index_rAAV=[1,1424,2889]




#
# println("synthentic_dataset")
# println("PC ")
# println("RMSE true mAb vs JEKF: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_EKF_fail_pc)))
# println("RMSE true mAb vs SIC: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_SIC_pc)))
# println("RMSE true mAb vs 1H2: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_1H2_pc)))
# println("RMSE true mAb vs 2H2: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_2H2_pc)))
# println("RMSE true mAb vs KPH2: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_KPH2_pc)))
# println("PU ")
# println("RMSE true mAb vs JEKF: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_EKF_fail_pu)))
# println("RMSE true mAb vs SIC: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_SIC_pu)))
# println("RMSE true mAb vs 1H2: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_1H2_pu)))
# println("RMSE true mAb vs 2H2: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_2H2_pu)))
# println("RMSE true mAb vs KPH2: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_KPH2_pu)))
#
#
# println("PC sp0")
# println("RMSE true mAb vs 1H2: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_1H2_pc_sp0)))
# println("RMSE true mAb vs 2H2: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_2H2_pc_sp0)))
# println("RMSE true mAb vs KPH2: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_KPH2_pc_sp0)))
# println("PU sp0")
# println("RMSE true mAb vs 1H2: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_1H2_pu_sp0)))
# println("RMSE true mAb vs 2H2: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_2H2_pu_sp0)))
# println("RMSE true mAb vs KPH2: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_KPH2_pu_sp0)))
#
#
#
# println("Real_dataset")






#
#
#
# atime=Array(timeRD)'
# open("timeRD.txt", "w") do f
#   for i in atime
#     println(f, i)
#   end
# end
