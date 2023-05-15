using Plots, XLSX, DataFrames, CSV, DifferentialEquations,StatsPlots,Random
using Turing
# Set a seed for reproducibility.
using Random
Random.seed!(14);

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





xv_online_measurement_RD_AAV=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_real_data/xv_online_measurement_RD_AAV.csv",DataFrame;header=false )

timeEKF=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/time_h_of_Xv_syntetic_data_with_gaussian_noises.csv",DataFrame;header=false )
timeRD=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_real_data/time_RD.csv",DataFrame;header=false )


Xv_online_run41_noise_3=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/Xv_syntetic_data_run41_with_gaussian_noise_0.5.csv",DataFrame;header=false )
mAb_True_syntetic_data_based_on_run41=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/mAb_syntetic_data_based_on_run41.csv",DataFrame;header=false )
Xv_syntetic_data_run41_ground_truth=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/Xv_syntetic_data_run41_ground_truth.csv",DataFrame;header=false )

## Evaluation_with_synthetic_data  - unique P

#SIC MRDE_with_P_correlated
Xv_result_SIC_pc=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/MRDE_with_P_correlated/Xv_result_SIC_pc.csv",DataFrame;header=false )
mAb_result_SIC_pc=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/MRDE_with_P_correlated/mAb_result_SIC_pc.csv",DataFrame;header=false )
QmAb_result_SIC_pc=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/MRDE_with_P_correlated/QmAb_result_SIC_pc.csv",DataFrame;header=false )

#1H2 MRDE_with_P_correlated
Xv_result_1H2_pc=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/MRDE_with_P_correlated/Xv_result_1H2_pc.csv",DataFrame;header=false )
mAb_result_1H2_pc=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/MRDE_with_P_correlated/mAb_result_1H2_pc.csv",DataFrame;header=false )
QmAb_result_1H2_pc=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/MRDE_with_P_correlated/QmAb_result_1H2_pc.csv",DataFrame;header=false )

#2H2 MRDE_with_P_correlated
Xv_result_2H2_pc=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/MRDE_with_P_correlated/Xv_result_2H2_pc.csv",DataFrame;header=false )
mAb_result_2H2_pc=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/MRDE_with_P_correlated/mAb_result_2H2_pc.csv",DataFrame;header=false )
QmAb_result_2H2_pc=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/MRDE_with_P_correlated/QmAb_result_2H2_pc.csv",DataFrame;header=false )

#KPH2 MRDE_with_P_correlated
Xv_result_KPH2_pc=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/MRDE_with_P_correlated/Xv_result_KPH2_pc.csv",DataFrame;header=false )
mAb_result_KPH2_pc=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/MRDE_with_P_correlated/mAb_result_KPH2_pc.csv",DataFrame;header=false )
QmAb_result_KPH2_pc=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/MRDE_with_P_correlated/QmAb_result_KPH2_pc.csv",DataFrame;header=false )

#fail MRDE_with_P_correlated
Xv_result_EKF_fail_pc=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/MRDE_with_P_correlated/Xv_result_EKF_fail_pc.csv",DataFrame;header=false )
mAb_result_EKF_fail_pc=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/MRDE_with_P_correlated/mAb_result_EKF_fail_pc.csv",DataFrame;header=false )
QmAb_result_EKF_fail_pc=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/MRDE_with_P_correlated/QmAb_result_EKF_fail_pc.csv",DataFrame;header=false )

##  - unique P

#SIC MRDE_with_P_uncorrelated
Xv_result_SIC_pu=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/MRDE_with_P_uncorrelated/Xv_result_sol_SIC_pu.csv",DataFrame;header=false )
mAb_result_SIC_pu=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/MRDE_with_P_uncorrelated/mAb_result_sol_SIC_pu.csv",DataFrame;header=false )
QmAb_result_SIC_pu=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/MRDE_with_P_uncorrelated/QmAb_result_sol_SIC_pu.csv",DataFrame;header=false )

#1H2 MRDE_with_P_uncorrelated
Xv_result_1H2_pu=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/MRDE_with_P_uncorrelated/Xv_result_sol_1H2_pu.csv",DataFrame;header=false )
mAb_result_1H2_pu=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/MRDE_with_P_uncorrelated/mAb_result_sol_1H2_pu.csv",DataFrame;header=false )
QmAb_result_1H2_pu=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/MRDE_with_P_uncorrelated/QmAb_result_sol_1H2_pu.csv",DataFrame;header=false )

#2H2 MRDE_with_P_uncorrelated
Xv_result_2H2_pu=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/MRDE_with_P_uncorrelated/Xv_result_sol_2H2_pu.csv",DataFrame;header=false )
mAb_result_2H2_pu=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/MRDE_with_P_uncorrelated/mAb_result_sol_2H2_pu.csv",DataFrame;header=false )
QmAb_result_2H2_pu=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/MRDE_with_P_uncorrelated/QmAb_result_sol_2H2_pu.csv",DataFrame;header=false )

#KPH2 MRDE_with_P_uncorrelated
Xv_result_KPH2_pu=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/MRDE_with_P_uncorrelated/Xv_result_sol_KPH2_pu.csv",DataFrame;header=false )
mAb_result_KPH2_pu=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/MRDE_with_P_uncorrelated/mAb_result_sol_KPH2_pu.csv",DataFrame;header=false )
QmAb_result_KPH2_pu=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/MRDE_with_P_uncorrelated/QmAb_result_sol_KPH2_pu.csv",DataFrame;header=false )

#fail MRDE_with_P_uncorrelated
Xv_result_EKF_fail_pu=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/MRDE_with_P_uncorrelated/Xv_result_EKF_fail_pu.csv",DataFrame;header=false )
mAb_result_EKF_fail_pu=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/MRDE_with_P_uncorrelated/mAb_result_EKF_fail_pu.csv",DataFrame;header=false )
QmAb_result_EKF_fail_pu=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/MRDE_with_P_uncorrelated/QmAb_result_EKF_fail_pu.csv",DataFrame;header=false )



## Evaluation_with_synthetic_data_specific_P0

#SIC MRDE_with_P_correlated
Xv_result_SIC_pc_sp0=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data_specific_P0/MRDE_with_P_correlated/Xv_result_SIC_pc.csv",DataFrame;header=false )
mAb_result_SIC_pc_sp0=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data_specific_P0/MRDE_with_P_correlated/mAb_result_SIC_pc.csv",DataFrame;header=false )
QmAb_result_SIC_pc_sp0=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data_specific_P0/MRDE_with_P_correlated/QmAb_result_SIC_pc.csv",DataFrame;header=false )

#1H2 MRDE_with_P_correlated
Xv_result_1H2_pc_sp0=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data_specific_P0/MRDE_with_P_correlated/Xv_result_1H2_pc.csv",DataFrame;header=false )
mAb_result_1H2_pc_sp0=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data_specific_P0/MRDE_with_P_correlated/mAb_result_1H2_pc.csv",DataFrame;header=false )
QmAb_result_1H2_pc_sp0=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data_specific_P0/MRDE_with_P_correlated/QmAb_result_1H2_pc.csv",DataFrame;header=false )

#2H2 MRDE_with_P_correlated
Xv_result_2H2_pc_sp0=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data_specific_P0/MRDE_with_P_correlated/Xv_result_2H2_pc.csv",DataFrame;header=false )
mAb_result_2H2_pc_sp0=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data_specific_P0/MRDE_with_P_correlated/mAb_result_2H2_pc.csv",DataFrame;header=false )
QmAb_result_2H2_pc_sp0=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data_specific_P0/MRDE_with_P_correlated/QmAb_result_2H2_pc.csv",DataFrame;header=false )

#KPH2 MRDE_with_P_correlated
Xv_result_KPH2_pc_sp0=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data_specific_P0/MRDE_with_P_correlated/Xv_result_KPH2_pc.csv",DataFrame;header=false )
mAb_result_KPH2_pc_sp0=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data_specific_P0/MRDE_with_P_correlated/mAb_result_KPH2_pc.csv",DataFrame;header=false )
QmAb_result_KPH2_pc_sp0=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data_specific_P0/MRDE_with_P_correlated/QmAb_result_KPH2_pc.csv",DataFrame;header=false )

##


#1H2 MRDE_with_P_uncorrelated
Xv_result_SIC_pu_sp0=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data_specific_P0/MRDE_with_P_uncorrelated/Xv_result_sol_SIC_pu.csv",DataFrame;header=false )
mAb_result_SIC_pu_sp0=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data_specific_P0/MRDE_with_P_uncorrelated/mAb_result_sol_SIC_pu.csv",DataFrame;header=false )
QmAb_result_SIC_pu_sp0=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data_specific_P0/MRDE_with_P_uncorrelated/QmAb_result_sol_SIC_pu.csv",DataFrame;header=false )



#1H2 MRDE_with_P_uncorrelated
Xv_result_1H2_pu_sp0=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data_specific_P0/MRDE_with_P_uncorrelated/Xv_result_sol_1H2_pu.csv",DataFrame;header=false )
mAb_result_1H2_pu_sp0=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data_specific_P0/MRDE_with_P_uncorrelated/mAb_result_sol_1H2_pu.csv",DataFrame;header=false )
QmAb_result_1H2_pu_sp0=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data_specific_P0/MRDE_with_P_uncorrelated/QmAb_result_sol_1H2_pu.csv",DataFrame;header=false )

#2H2 MRDE_with_P_uncorrelated
Xv_result_2H2_pu_sp0=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data_specific_P0/MRDE_with_P_uncorrelated/Xv_result_sol_2H2_pu.csv",DataFrame;header=false )
mAb_result_2H2_pu_sp0=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data_specific_P0/MRDE_with_P_uncorrelated/mAb_result_sol_2H2_pu.csv",DataFrame;header=false )
QmAb_result_2H2_pu_sp0=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data_specific_P0/MRDE_with_P_uncorrelated/QmAb_result_sol_2H2_pu.csv",DataFrame;header=false )

#KPH2 MRDE_with_P_uncorrelated
Xv_result_KPH2_pu_sp0=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data_specific_P0/MRDE_with_P_uncorrelated/Xv_result_sol_KPH2_pu.csv",DataFrame;header=false )
mAb_result_KPH2_pu_sp0=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data_specific_P0/MRDE_with_P_uncorrelated/mAb_result_sol_KPH2_pu.csv",DataFrame;header=false )
QmAb_result_KPH2_pu_sp0=CSV.read("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data_specific_P0/MRDE_with_P_uncorrelated/QmAb_result_sol_KPH2_pu.csv",DataFrame;header=false )















## xv
gr( xtickfontsize=13, ytickfontsize=13, xguidefontsize=13, yguidefontsize=13, legendfontsize=13);


plot0=plot(Array(timeEKF)[2:end],Array(Xv_online_run41_noise_3)[2:end],color=:lightblue, label = "Xv online (noise)", lw=4.5, xlabel="time(h)",ylabel="QmAb")

plot!(Array(timeEKF)[2:end],Array(Xv_result_SIC_pu),color=:blue, label = "JEKF-SIC PU", ls=:dash,lw=3.5,xlabel="time(h)",ylabel="[Xv]")
plot!(Array(timeEKF)[2:end],Array(Xv_result_1H2_pu),color=:black, label = "JEKF-1H2 PU",ls=:dash, lw=3.5, xlabel="time(h)",ylabel="[Xv]")
plot!(Array(timeEKF)[2:end],Array(Xv_result_2H2_pu),color=:orange, label = "JEKF-2H2 PU",ls=:dash, lw=3.5, xlabel="time(h)",ylabel="[Xv]")
plot!(Array(timeEKF)[2:end],Array(Xv_result_KPH2_pu),color=:green,label = "JEKF-KPH2 PU", ls=:dash, lw=3.5,xlabel="time(h)",ylabel="[Xv]")

plot!(Array(timeEKF)[2:end],Array(Xv_result_SIC_pc),color=:blue, label = "JEKF-SIC PC", lw=3.5,xlabel="time(h)",ylabel="[Xv]")
plot!(Array(timeEKF)[2:end],Array(Xv_result_1H2_pc),color=:black, label = "JEKF-1H2 PC", lw=3.5, xlabel="time(h)",ylabel="[Xv]")
plot!(Array(timeEKF)[2:end],Array(Xv_result_2H2_pc),color=:orange, label = "JEKF-2H2 PC", lw=3.5, xlabel="time(h)",ylabel="[Xv]")
plot!(Array(timeEKF)[2:end],Array(Xv_result_KPH2_pc),color=:green,label = "JEKF-KPH2 PC",  lw=3.5,xlabel="time(h)",ylabel="[Xv]")

plot!(Array(timeEKF)[2:end],Array(Xv_syntetic_data_run41_ground_truth)[2:end],color=:red, ls=:dot, label = "Xv Ground truth", lw=3.5, xlabel="time(h)",ylabel="[Xv]")
plot!(legend=:outertopright,size = (650,450))
###savefig("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/all_Xv_estimations.png")
display(plot0)







## EKF fail

# gr();
gr( xtickfontsize=13, ytickfontsize=13, xguidefontsize=16, yguidefontsize=16, legendfontsize=13);


plot0=plot(Array(timeEKF)[2:end],Array(Xv_online_run41_noise_3)[2:end],color=:lightblue, label = "Xv online (noise)", lw=4.5, xlabel="time(h)",ylabel="QmAb")
plot!(Array(timeEKF)[2:end],Array(Xv_result_EKF_fail_pc),color=:purple, label = "JEKF", lw=3.5,xlabel="time(h)",ylabel="[Xv]")
plot!(Array(timeEKF)[2:end],Array(Xv_syntetic_data_run41_ground_truth)[2:end],color=:red, ls=:dot, label = "Xv Ground truth", lw=3.5, xlabel="time(h)",ylabel="[Xv]")
plot!(legend=:outertopright,size = (650,450))

# plotly();

plot1=plot(Array(timeEKF)[2:end],Array(QmAb_result_EKF_fail_pc),color=:purple,label = "JEKF (failure)",  lw=3.5,xlabel="time(h)",ylabel="QmAb")
plot!(Array(timeEKF)[2:end],repeat([1.00487], 6720),color=:red, label = "Ground truth",ls=:dot, lw=3.5, xlabel="time(h)",ylabel="QmAb")
plot!(legend=:best)
# display(plot1)

plot2=plot(Array(timeEKF)[2:end],Array(mAb_result_EKF_fail_pc), color=:purple,label = "JEKF (failure)", ls=:solid, lw=3.5, xlabel="time(h)",ylabel="[mAb]")
plot!(Array(timeEKF)[2:end],Array(mAb_True_syntetic_data_based_on_run41)[2:end], color=:red, ls=:dot, label = "Ground truth", lw=3.5, xlabel="time(h)",ylabel="[mAb]")
plot!(legend=:topleft)
# display(plot2)

pp=plot(plot0,plot1,plot2, layout=(3,1),size = (800,900))
###savefig("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/MRDE_with_P_correlated/results_JEKF_fail.png")
display(pp)




































#
#
#
#
# ## Evaluation_with_synthetic_data PC
#
# # gr();
# gr( xtickfontsize=13, ytickfontsize=13, xguidefontsize=16, yguidefontsize=16, legendfontsize=13);
#
# # plotly();
#
# plot0=plot(Array(timeEKF)[2:end],Array(Xv_online_run41_noise_3)[2:end],color=:lightblue, label = "Xv online (noise)", lw=4.5, xlabel="time(h)",ylabel="QmAb")
# plot!(Array(timeEKF)[2:end],Array(Xv_result_SIC_pu_rd),color=:blue, label = "JEKF-SIC", lw=3.5,xlabel="time(h)",ylabel="[Xv]")
# plot!(Array(timeEKF)[2:end],Array(Xv_result_1H2_pc),color=:black, label = "JEKF-1H2", lw=3.5, xlabel="time(h)",ylabel="[Xv]")
# plot!(Array(timeEKF)[2:end],Array(Xv_result_2H2_pc),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel="time(h)",ylabel="[Xv]")
# plot!(Array(timeEKF)[2:end],Array(Xv_result_KPH2_pc),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel="time(h)",ylabel="[Xv]")
# plot!(Array(timeEKF)[2:end],Array(Xv_result_EKF_fail_pc),color=:purple, label = "JEKF", lw=3.5,xlabel="time(h)",ylabel="[Xv]")
# plot!(Array(timeEKF)[2:end],Array(Xv_syntetic_data_run41_ground_truth)[2:end],color=:red, ls=:dot, label = "Xv Ground truth", lw=3.5, xlabel="time(h)",ylabel="[Xv]")
# plot!(legend=:outertopright,size = (650,450))
#
# plot1=plot(Array(timeEKF)[2:end],Array(QmAb_result_SIC_pc),color=:blue, label = "JEKF-SIC", lw=3.5, xlabel="time(h)",ylabel="QmAb")
# plot!(Array(timeEKF)[2:end],Array(QmAb_result_1H2_pc),color=:black, label = "JEKF-1H2", lw=3.5,xlabel="time(h)",ylabel="QmAb")
# plot!(Array(timeEKF)[2:end],Array(QmAb_result_2H2_pc),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel="time(h)",ylabel="QmAb")
# plot!(Array(timeEKF)[2:end],Array(QmAb_result_KPH2_pc),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel="time(h)",ylabel="QmAb")
# plot!(Array(timeEKF)[2:end],Array(QmAb_result_EKF_fail_pc),color=:purple,label = "JEKF (failure)",  lw=3.5,xlabel="time(h)",ylabel="QmAb")
# plot!(Array(timeEKF)[2:end],repeat([1.00487], 6720),color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel="time(h)",ylabel="QmAb")
# plot!(legend=:outertopright)
# # display(plot1)
#
# plot2=plot(Array(timeEKF)[2:end],Array(mAb_result_SIC_pc), color=:blue,ls=:solid, label = "JEKF-SIC", lw=3.5, xlabel="time(h)",ylabel="[mAb]")
# plot!(Array(timeEKF)[2:end],Array(mAb_result_1H2_pc), color=:black,label = "JEKF-1H2", lw=3.5, ls=:solid, xlabel="time(h)",ylabel="[mAb]")
# plot!(Array(timeEKF)[2:end],Array(mAb_result_2H2_pc), color=:orange,label = "JEKF-2H2", lw=3.5, ls=:solid, xlabel="time(h)",ylabel="[mAb]")
# plot!(Array(timeEKF)[2:end],Array(mAb_result_KPH2_pc),color=:green,label = "JEKF-KPH2", lw=3.5, ls=:solid, xlabel="time(h)",ylabel="[mAb]")
# plot!(Array(timeEKF)[2:end],Array(mAb_result_EKF_fail_pc), color=:purple,label = "JEKF (failure)", ls=:solid, lw=3.5, xlabel="time(h)",ylabel="[mAb]")
# plot!(Array(timeEKF)[2:end],Array(mAb_True_syntetic_data_based_on_run41)[2:end], color=:red, ls=:dot, label = "Ground truth", lw=5.5, xlabel="time(h)",ylabel="[mAb]")
# plot!(legend=:topleft)
# # display(plot2)
#
# pp=plot(plot0,plot1,plot2, layout=(3,1),size = (800,900))
# ###savefig("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/MRDE_with_P_correlated/results_pc.png")
# display(pp)
#
#
#
#
#
















## Evaluation_with_synthetic_data PC - unique P

# gr();
gr( xtickfontsize=13, ytickfontsize=13, xguidefontsize=16, yguidefontsize=16, legendfontsize=13);

# plotly();

plot0=plot(Array(timeEKF)[2:end],Array(Xv_online_run41_noise_3)[2:end],color=:lightblue, label = "Xv online (noise)", lw=4.5, xlabel="time(h)",ylabel="QmAb")
plot!(Array(timeEKF)[2:end],Array(Xv_result_SIC_pc),color=:blue, label = "JEKF-SIC", lw=3.5,xlabel="time(h)",ylabel="[Xv]")
# plot!(Array(timeEKF)[2:end],Array(Xv_result_1H2_pc),color=:black, label = "JEKF-1H2", lw=3.5, xlabel="time(h)",ylabel="[Xv]")
# plot!(Array(timeEKF)[2:end],Array(Xv_result_2H2_pc),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel="time(h)",ylabel="[Xv]")
plot!(Array(timeEKF)[2:end],Array(Xv_result_KPH2_pc),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel="time(h)",ylabel="[Xv]")
plot!(Array(timeEKF)[2:end],Array(Xv_result_EKF_fail_pc),color=:purple, label = "JEKF", lw=3.5,xlabel="time(h)",ylabel="[Xv]")
plot!(Array(timeEKF)[2:end],Array(Xv_syntetic_data_run41_ground_truth)[2:end],color=:red, ls=:dot, label = "Xv Ground truth", lw=3.5, xlabel="time(h)",ylabel="[Xv]")
plot!(legend=:outertopright,size = (650,450))

plot1=plot(Array(timeEKF)[2:end],Array(QmAb_result_SIC_pc),color=:blue, label = "JEKF-SIC", lw=3.5, xlabel="time(h)",ylabel="QmAb")
# plot!(Array(timeEKF)[2:end],Array(QmAb_result_1H2_pc),color=:black, label = "JEKF-1H2", lw=3.5,xlabel="time(h)",ylabel="QmAb")
# plot!(Array(timeEKF)[2:end],Array(QmAb_result_2H2_pc),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel="time(h)",ylabel="QmAb")
plot!(Array(timeEKF)[2:end],Array(QmAb_result_KPH2_pc),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel="time(h)",ylabel="QmAb")
plot!(Array(timeEKF)[2:end],Array(QmAb_result_EKF_fail_pc),color=:purple,label = "JEKF (failure)",  lw=3.5,xlabel="time(h)",ylabel="QmAb")
plot!(Array(timeEKF)[2:end],repeat([1.00487], 6720),color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel="time(h)",ylabel="QmAb")
plot!(legend=:outertopright)
# display(plot1)

plot2=plot(Array(timeEKF)[2:end],Array(mAb_result_SIC_pc), color=:blue,ls=:solid, label = "JEKF-SIC", lw=3.5, xlabel="time(h)",ylabel="[mAb]")
# plot!(Array(timeEKF)[2:end],Array(mAb_result_1H2_pc), color=:black,label = "JEKF-1H2", lw=3.5, ls=:solid, xlabel="time(h)",ylabel="[mAb]")
# plot!(Array(timeEKF)[2:end],Array(mAb_result_2H2_pc), color=:orange,label = "JEKF-2H2", lw=3.5, ls=:solid, xlabel="time(h)",ylabel="[mAb]")
plot!(Array(timeEKF)[2:end],Array(mAb_result_KPH2_pc),color=:green,label = "JEKF-KPH2", lw=3.5, ls=:solid, xlabel="time(h)",ylabel="[mAb]")
plot!(Array(timeEKF)[2:end],Array(mAb_result_EKF_fail_pc), color=:purple,label = "JEKF (failure)", ls=:solid, lw=3.5, xlabel="time(h)",ylabel="[mAb]")
plot!(Array(timeEKF)[2:end],Array(mAb_True_syntetic_data_based_on_run41)[2:end], color=:red, ls=:dot, label = "Ground truth", lw=5.5, xlabel="time(h)",ylabel="[mAb]")
plot!(legend=:topleft)
# display(plot2)

pp=plot(plot0,plot1,plot2, layout=(3,1),size = (800,900))
###savefig("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/MRDE_with_P_correlated/results_pc.png")
display(pp)





## ## Evaluation_with_synthetic_data PU  - unique P


plot0=plot(Array(timeEKF)[2:end],Array(Xv_online_run41_noise_3)[2:end],color=:lightblue, label = "Xv online (noise)", lw=4.5, xlabel="time(h)",ylabel="QmAb")
plot!(Array(timeEKF)[2:end],Array(Xv_result_SIC_pu),color=:blue, label = "JEKF-SIC", ls=:solid,lw=3.5,xlabel="time(h)",ylabel="[Xv]")
# plot!(Array(timeEKF)[2:end],Array(Xv_result_1H2_pu),color=:black, label = "JEKF-1H2",ls=:solid, lw=3.5, xlabel="time(h)",ylabel="[Xv]")
# plot!(Array(timeEKF)[2:end],Array(Xv_result_2H2_pu),color=:orange, label = "JEKF-2H2",ls=:solid, lw=3.5, xlabel="time(h)",ylabel="[Xv]")
plot!(Array(timeEKF)[2:end],Array(Xv_result_KPH2_pu),color=:green,label = "JEKF-KPH2", ls=:solid, lw=3.5,xlabel="time(h)",ylabel="[Xv]")
plot!(Array(timeEKF)[2:end],Array(Xv_result_EKF_fail_pu),color=:purple, label = "JEKF", lw=3.5,xlabel="time(h)",ylabel="[Xv]")
plot!(Array(timeEKF)[2:end],Array(Xv_syntetic_data_run41_ground_truth)[2:end],color=:red, ls=:dot, label = "Xv Ground truth", lw=3.5, xlabel="time(h)",ylabel="[Xv]")
plot!(legend=:outertopright,size = (650,450))

plot1=plot(Array(timeEKF)[2:end],Array(QmAb_result_SIC_pu),color=:blue, label = "JEKF-SIC", lw=3.5, xlabel="time(h)",ylabel="QmAb")
# plot!(Array(timeEKF)[2:end],Array(QmAb_result_1H2_pu),color=:black, label = "JEKF-1H2", lw=3.5,xlabel="time(h)",ylabel="QmAb")
# plot!(Array(timeEKF)[2:end],Array(QmAb_result_2H2_pu),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel="time(h)",ylabel="QmAb")
plot!(Array(timeEKF)[2:end],Array(QmAb_result_KPH2_pu),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel="time(h)",ylabel="QmAb")
plot!(Array(timeEKF)[2:end],Array(QmAb_result_EKF_fail_pu),color=:purple,label = "JEKF (failure)",  lw=3.5,xlabel="time(h)",ylabel="QmAb")
plot!(Array(timeEKF)[2:end],repeat([1.00487], 6720),color=:red, label = "Ground truth", ls=:dot, lw=5.5, xlabel="time(h)",ylabel="QmAb")
plot!(legend=:outertopright)
# display(plot1)

plot2=plot(Array(timeEKF)[2:end],Array(mAb_result_SIC_pu), color=:blue,ls=:solid, label = "JEKF-SIC", lw=3.5, xlabel="time(h)",ylabel="[mAb]")
# plot!(Array(timeEKF)[2:end],Array(mAb_result_1H2_pu), color=:black,label = "JEKF-1H2", lw=3.5, ls=:solid, xlabel="time(h)",ylabel="[mAb]")
# plot!(Array(timeEKF)[2:end],Array(mAb_result_2H2_pu), color=:orange,label = "JEKF-2H2", lw=3.5, ls=:solid, xlabel="time(h)",ylabel="[mAb]")
plot!(Array(timeEKF)[2:end],Array(mAb_result_KPH2_pu),color=:green,label = "JEKF-KPH2", lw=3.5, ls=:solid, xlabel="time(h)",ylabel="[mAb]")
plot!(Array(timeEKF)[2:end],Array(mAb_result_EKF_fail_pu), color=:purple,label = "JEKF (failure)", ls=:solid, lw=3.5, xlabel="time(h)",ylabel="[mAb]")
plot!(Array(timeEKF)[2:end],Array(mAb_True_syntetic_data_based_on_run41)[2:end], color=:red, ls=:dot, label = "Ground truth", lw=5.5, xlabel="time(h)",ylabel="[mAb]")
plot!(legend=:topleft)
# display(plot2)


pp=plot(plot0,plot1,plot2, layout=(3,1),size = (800,900))
###savefig("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/MRDE_with_P_uncorrelated/results_pu.png")
display(pp)











## Evaluation_with_synthetic_data_specific_P0 PC

# gr();
gr( xtickfontsize=13, ytickfontsize=13, xguidefontsize=16, yguidefontsize=16, legendfontsize=13);

# plotly();

plot0=plot(Array(timeEKF)[2:end],Array(Xv_online_run41_noise_3)[2:end],color=:lightblue, label = "Xv online (noise)", lw=4.5, xlabel="time(h)",ylabel="QmAb")
plot!(Array(timeEKF)[2:end],Array(Xv_result_SIC_pc_sp0),color=:blue, label = "JEKF-SIC", lw=3.5,xlabel="time(h)",ylabel="[Xv]")
# plot!(Array(timeEKF)[2:end],Array(Xv_result_1H2_pc_sp0),color=:black, label = "JEKF-1H2", lw=3.5, xlabel="time(h)",ylabel="[Xv]")
# plot!(Array(timeEKF)[2:end],Array(Xv_result_2H2_pc_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel="time(h)",ylabel="[Xv]")
plot!(Array(timeEKF)[2:end],Array(Xv_result_KPH2_pc_sp0),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel="time(h)",ylabel="[Xv]")
plot!(Array(timeEKF)[2:end],Array(Xv_result_EKF_fail_pc),color=:purple, label = "JEKF", lw=3.5,xlabel="time(h)",ylabel="[Xv]")
plot!(Array(timeEKF)[2:end],Array(Xv_syntetic_data_run41_ground_truth)[2:end],color=:red, ls=:dot, label = "Xv Ground truth", lw=3.5, xlabel="time(h)",ylabel="[Xv]")
plot!(legend=:outertopright,size = (650,450))


plot1=plot(Array(timeEKF)[2:end],Array(QmAb_result_SIC_pc_sp0),color=:blue, label = "JEKF-SIC", lw=3.5, xlabel="time(h)",ylabel="QmAb")
# plot!(Array(timeEKF)[2:end],Array(QmAb_result_1H2_pc_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel="time(h)",ylabel="QmAb")
# plot!(Array(timeEKF)[2:end],Array(QmAb_result_2H2_pc_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel="time(h)",ylabel="QmAb")
plot!(Array(timeEKF)[2:end],Array(QmAb_result_KPH2_pc_sp0),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel="time(h)",ylabel="QmAb")
plot!(Array(timeEKF)[2:end],Array(QmAb_result_EKF_fail_pc),color=:purple,label = "JEKF (failure)",  lw=3.5,xlabel="time(h)",ylabel="QmAb")
plot!(Array(timeEKF)[2:end],repeat([1.00487], 6720),color=:red, label = "Ground truth", ls=:dot, lw=5.5, xlabel="time(h)",ylabel="QmAb")
plot!(legend=:outertopright)
# display(plot1)

plot2=plot(Array(timeEKF)[2:end],Array(mAb_result_SIC_pc_sp0), color=:blue,ls=:solid, label = "JEKF-SIC", lw=3.5, xlabel="time(h)",ylabel="[mAb]")
# plot!(Array(timeEKF)[2:end],Array(mAb_result_1H2_pc_sp0), color=:black,label = "JEKF-1H2", lw=3.5, ls=:solid, xlabel="time(h)",ylabel="[mAb]")
# plot!(Array(timeEKF)[2:end],Array(mAb_result_2H2_pc_sp0), color=:orange,label = "JEKF-2H2", lw=3.5, ls=:solid, xlabel="time(h)",ylabel="[mAb]")
plot!(Array(timeEKF)[2:end],Array(mAb_result_KPH2_pc_sp0),color=:green,label = "JEKF-KPH2", lw=3.5, ls=:solid, xlabel="time(h)",ylabel="[mAb]")
plot!(Array(timeEKF)[2:end],Array(mAb_result_EKF_fail_pc), color=:purple,label = "JEKF (failure)", ls=:solid, lw=3.5, xlabel="time(h)",ylabel="[mAb]")
plot!(Array(timeEKF)[2:end],Array(mAb_True_syntetic_data_based_on_run41)[2:end], color=:red, ls=:dot, label = "Ground truth", lw=5.5, xlabel="time(h)",ylabel="[mAb]")
plot!(legend=:topleft)
# display(plot2)

pp=plot(plot0,plot1,plot2, layout=(3,1),size = (800,900))
###savefig("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/MRDE_with_P_correlated/results_pc_sp0.png")
display(pp)




## ## Evaluation_with_synthetic_data_specific_P0 PU

plot0=plot(Array(timeEKF)[2:end],Array(Xv_online_run41_noise_3)[2:end],color=:lightblue, label = "Xv online (noise)", lw=4.5, xlabel="time(h)",ylabel="QmAb")
plot!(Array(timeEKF)[2:end],Array(Xv_result_SIC_pu_sp0),color=:blue, label = "JEKF-SIC", ls=:solid,lw=3.5,xlabel="time(h)",ylabel="[Xv]")
# plot!(Array(timeEKF)[2:end],Array(Xv_result_1H2_pu_sp0),color=:black, label = "JEKF-1H2",ls=:solid, lw=3.5, xlabel="time(h)",ylabel="[Xv]")
# plot!(Array(timeEKF)[2:end],Array(Xv_result_2H2_pu_sp0),color=:orange, label = "JEKF-2H2",ls=:solid, lw=3.5, xlabel="time(h)",ylabel="[Xv]")
plot!(Array(timeEKF)[2:end],Array(Xv_result_KPH2_pu_sp0),color=:green,label = "JEKF-KPH2", ls=:solid, lw=3.5,xlabel="time(h)",ylabel="[Xv]")
plot!(Array(timeEKF)[2:end],Array(Xv_result_EKF_fail_pu),color=:purple, label = "JEKF", lw=3.5,xlabel="time(h)",ylabel="[Xv]")
plot!(Array(timeEKF)[2:end],Array(Xv_syntetic_data_run41_ground_truth)[2:end],color=:red, ls=:dot, label = "Xv Ground truth", lw=3.5, xlabel="time(h)",ylabel="[Xv]")
plot!(legend=:outertopright,size = (650,450))

plot1=plot(Array(timeEKF)[2:end],Array(QmAb_result_SIC_pu_sp0),color=:blue, label = "JEKF-SIC", lw=3.5, xlabel="time(h)",ylabel="QmAb")
# plot!(Array(timeEKF)[2:end],Array(QmAb_result_1H2_pu_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel="time(h)",ylabel="QmAb")
# plot!(Array(timeEKF)[2:end],Array(QmAb_result_2H2_pu_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel="time(h)",ylabel="QmAb")
plot!(Array(timeEKF)[2:end],Array(QmAb_result_KPH2_pu_sp0),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel="time(h)",ylabel="QmAb")
plot!(Array(timeEKF)[2:end],Array(QmAb_result_EKF_fail_pu),color=:purple,label = "JEKF (failure)",  lw=3.5,xlabel="time(h)",ylabel="QmAb")
plot!(Array(timeEKF)[2:end],repeat([1.00487], 6720),color=:red, label = "Ground truth", ls=:dot, lw=5.5, xlabel="time(h)",ylabel="QmAb")
plot!(legend=:outertopright)
# display(plot1)

plot2=plot(Array(timeEKF)[2:end],Array(mAb_result_SIC_pu_sp0), color=:blue,ls=:solid, label = "JEKF-SIC", lw=3.5, xlabel="time(h)",ylabel="[mAb]")
# plot!(Array(timeEKF)[2:end],Array(mAb_result_1H2_pu_sp0), color=:black,label = "JEKF-1H2", lw=3.5, ls=:solid, xlabel="time(h)",ylabel="[mAb]")
# plot!(Array(timeEKF)[2:end],Array(mAb_result_2H2_pu_sp0), color=:orange,label = "JEKF-2H2", lw=3.5, ls=:solid, xlabel="time(h)",ylabel="[mAb]")
plot!(Array(timeEKF)[2:end],Array(mAb_result_KPH2_pu_sp0),color=:green,label = "JEKF-KPH2", lw=3.5, ls=:solid, xlabel="time(h)",ylabel="[mAb]")
plot!(Array(timeEKF)[2:end],Array(mAb_result_EKF_fail_pu), color=:purple,label = "JEKF (failure)", ls=:solid, lw=3.5, xlabel="time(h)",ylabel="[mAb]")
plot!(Array(timeEKF)[2:end],Array(mAb_True_syntetic_data_based_on_run41)[2:end], color=:red, ls=:dot, label = "Ground truth", lw=5.5, xlabel="time(h)",ylabel="[mAb]")
plot!(legend=:topleft)
# display(plot2)


pp=plot(plot0,plot1,plot2, layout=(3,1),size = (800,900))
###savefig("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/MRDE_with_P_uncorrelated/results_pu_sp0.png")
display(pp)



























println("synthentic_dataset")
println("PC ")
println("RMSE true mAb vs JEKF: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_EKF_fail_pc)))
println("RMSE true mAb vs SIC: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_SIC_pc)))
println("RMSE true mAb vs 1H2: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_1H2_pc)))
println("RMSE true mAb vs 2H2: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_2H2_pc)))
println("RMSE true mAb vs KPH2: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_KPH2_pc)))
println("PU ")
println("RMSE true mAb vs JEKF: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_EKF_fail_pu)))
println("RMSE true mAb vs SIC: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_SIC_pu)))
println("RMSE true mAb vs 1H2: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_1H2_pu)))
println("RMSE true mAb vs 2H2: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_2H2_pu)))
println("RMSE true mAb vs KPH2: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_KPH2_pu)))


println("PC sp0")
println("RMSE true mAb vs SIC: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_SIC_pc_sp0)))
println("RMSE true mAb vs 1H2: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_1H2_pc_sp0)))
println("RMSE true mAb vs 2H2: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_2H2_pc_sp0)))
println("RMSE true mAb vs KPH2: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_KPH2_pc_sp0)))
println("PU sp0")
println("RMSE true mAb vs 1H2: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_SIC_pu_sp0)))
println("RMSE true mAb vs 1H2: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_1H2_pu_sp0)))
println("RMSE true mAb vs 2H2: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_2H2_pu_sp0)))
println("RMSE true mAb vs KPH2: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_KPH2_pu_sp0)))



println("Real_dataset")









##

function ode_system!(du, u, p, t)
    Xv, GLC, GLN, LAC, AMM, mAb = u
    μmax,kglc,kgln,kilac,kiamm,kd,kdlac,kdamm,a1,a2,Yxv_glc,mglc,Yxv_gln,Ylac_glc,Yamm_gln,ramm,Qaav = p

    μ=μmax*(GLC/(kglc+GLC))*(GLN/(kgln+GLN))*(kilac/(kilac+LAC))*(kiamm/(kiamm+AMM))
    μd=kd*(LAC/(kdlac+LAC))*(AMM/(kdamm+AMM))
    mgln=(a1*GLN)/(a2+GLN)
    du[1] = (μ-μd)*Xv  #dXv
    du[2] = -(((μ-μd)/Yxv_glc) + mglc)*Xv #dGLC
    du[3] = -(((μ-μd)/Yxv_gln) + mgln)*Xv #dGLN
    du[4] =  Ylac_glc*((μ-μd)/Yxv_glc)*Xv #dLAC
    du[5] = Yamm_gln*((μ-μd)/Yxv_gln)*Xv-ramm*Xv #dAMM
    du[6] = Qaav*Xv #dmAb
end

u0 = [0.2    ,   60.0 ,    8.0    ,    0.1     ,   0.1   ,      0.0]


tstart=0.0
tend=336.0
sampling= 24.0
tgrid=tstart:sampling:tend

#run 41 best parameters
p41= [0.35, 0.2, 0.02, 3.0, 11.5, 0.07, 45.0, 13.0, 0.01, 5.0, 4.0, 0.037, 1.47864, 9.0, 40.1, 1.22174e-13, 1.00487]
#run 91 best parameters
p91=[0.0777599, 0.01, 0.01, 6.0, 15.0, 0.07, 45.0, 13.0, 0.0221436, 6.0, 3.0, 0.05, 2.07621, 8.0, 30.5, 7.18176e-13, 0.79]


prob =  ODEProblem(ode_system!, u0, (tstart,tend), p41)
sol41 = solve(prob, AutoTsit5(Rosenbrock23()),saveat=tgrid)
prob =  ODEProblem(ode_system!, u0, (tstart,tend), p91)
sol91 = solve(prob, AutoTsit5(Rosenbrock23()),saveat=tgrid)

n=10
gr( xtickfontsize=n, ytickfontsize=n, xguidefontsize=n, yguidefontsize=n, legendfontsize=n);

pl=plot(Array(timeEKF)[2:end],Array(Xv_online_run41_noise_3)[2:end],color=:lightblue, label = false, lw=4.5, xlabel="time(h)",ylabel="QmAb",layout=(2,3))
plot!(sol41.t,transpose(sol41),color=[:red  :red :red :red :red :red], lw=1.5, label = false, ylabel=["[Xv]"  "[GLC]" "[GLN]" "[LAC]" "[AMM]" "[mAb]"], layout=(2,3))
plot!(sol91.t,transpose(sol91),color=[:purple  :purple :purple :purple :purple :purple], lw=1.5, label = false, ylabel=["[Xv]"  "[GLC]" "[GLN]" "[LAC]" "[AMM]" "[mAb]"], layout=(2,3))
plot!(legend=:outerbottom,size = (650,450))
###savefig("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/synthetic_dataset_mAb.png")

display(pl)
