using Plots, XLSX, DataFrames, CSV, DifferentialEquations,StatsPlots,Random
using Turing
# Set a seed for reproducibility.
using Random
Random.seed!(14);
using LaTeXStrings

theme(:default)
# gr();
# plotly();

results_path="/Users/cristovao/PhD_courses/Thesis/JEKF-SANTO/evaluation_with_real_dataset/results"

xv_online_measurement_RD_AAV=CSV.read(results_path*"/Xv_bioreactor_dt2_online.csv",DataFrame;header=false )
timeEstimations=CSV.read(results_path*"/timeEstimations.csv",DataFrame;header=false )
timeRD=CSV.read(results_path*"/timeObsData.csv",DataFrame;header=false )

SANTO_Xv=CSV.read(results_path*"/JEKF-SANTO_Xv.csv",DataFrame;header=false )
SANTO_GLC=CSV.read(results_path*"/JEKF-SANTO_GLC.csv",DataFrame;header=false )
SANTO_LAC=CSV.read(results_path*"/JEKF-SANTO_LAC.csv",DataFrame;header=false )
SANTO_rAAV=CSV.read(results_path*"/JEKF-SANTO_rAAV.csv",DataFrame;header=false )
SANTO_muGLC=CSV.read(results_path*"/JEKF-SANTO_muGLC.csv",DataFrame;header=false )
SANTO_muLAC=CSV.read(results_path*"/JEKF-SANTO_muLAC.csv",DataFrame;header=false )
SANTO_muAAV=CSV.read(results_path*"/JEKF-SANTO_muAAV.csv",DataFrame;header=false )
SANTO_k_muGLC=CSV.read(results_path*"/JEKF-SANTO_k_mu_glc.csv",DataFrame;header=false )
SANTO_k_muLAC=CSV.read(results_path*"/JEKF-SANTO_k_mu_lac.csv",DataFrame;header=false )
SANTO_k_muAAV=CSV.read(results_path*"/JEKF-SANTO_k_mu_raav.csv",DataFrame;header=false )

SANTO_Sk=CSV.read(results_path*"/JEKF-SANTO_Sk.csv",DataFrame;header=false )
SANTO_innovation_error=CSV.read(results_path*"/JEKF-SANTO_innovation_error.csv",DataFrame;header=false )
SANTO_NIS=CSV.read(results_path*"/JEKF-SANTO_NIS.csv",DataFrame;header=false )

SANTO_SE_Xv=CSV.read(results_path*"/JEKF-SANTO_updated_stde_P_xv.csv",DataFrame;header=false )
SANTO_SE_GLC=CSV.read(results_path*"/JEKF-SANTO_updated_stde_P_GLC.csv",DataFrame;header=false )
SANTO_SE_LAC=CSV.read(results_path*"/JEKF-SANTO_updated_stde_P_LAC.csv",DataFrame;header=false )
SANTO_SE_rAAV=CSV.read(results_path*"/JEKF-SANTO_updated_stde_P_rAAV.csv",DataFrame;header=false )
SANTO_SE_muGLC=CSV.read(results_path*"/JEKF-SANTO_updated_stde_P_muGLC.csv",DataFrame;header=false )
SANTO_SE_muLAC=CSV.read(results_path*"/JEKF-SANTO_updated_stde_P_muLAC.csv",DataFrame;header=false )
SANTO_SE_murAAV=CSV.read(results_path*"/JEKF-SANTO_updated_stde_P_murAAV.csv",DataFrame;header=false )

Classic_Xv=CSV.read(results_path*"/JEKF-Classic_Xv.csv",DataFrame;header=false )
Classic_GLC=CSV.read(results_path*"/JEKF-Classic_GLC.csv",DataFrame;header=false )
Classic_LAC=CSV.read(results_path*"/JEKF-Classic_LAC.csv",DataFrame;header=false )
Classic_rAAV=CSV.read(results_path*"/JEKF-Classic_rAAV.csv",DataFrame;header=false )
Classic_muGLC=CSV.read(results_path*"/JEKF-Classic_muGLC.csv",DataFrame;header=false )
Classic_muLAC=CSV.read(results_path*"/JEKF-Classic_muLAC.csv",DataFrame;header=false )
Classic_muAAV=CSV.read(results_path*"/JEKF-Classic_muAAV.csv",DataFrame;header=false )
Classic_k_muGLC=CSV.read(results_path*"/JEKF-Classic_k_mu_glc.csv",DataFrame;header=false )
Classic_k_muLAC=CSV.read(results_path*"/JEKF-Classic_k_mu_lac.csv",DataFrame;header=false )
Classic_k_muAAV=CSV.read(results_path*"/JEKF-Classic_k_mu_raav.csv",DataFrame;header=false )

Classic_Sk=CSV.read(results_path*"/JEKF-Classic_Sk.csv",DataFrame;header=false )
Classic_innovation_error=CSV.read(results_path*"/JEKF-Classic_innovation_error.csv",DataFrame;header=false )
Classic_NIS=CSV.read(results_path*"/JEKF-Classic_NIS.csv",DataFrame;header=false )

Classic_SE_Xv=CSV.read(results_path*"/JEKF-Classic_updated_stde_P_xv.csv",DataFrame;header=false )
Classic_SE_GLC=CSV.read(results_path*"/JEKF-Classic_updated_stde_P_GLC.csv",DataFrame;header=false )
Classic_SE_LAC=CSV.read(results_path*"/JEKF-Classic_updated_stde_P_LAC.csv",DataFrame;header=false )
Classic_SE_rAAV=CSV.read(results_path*"/JEKF-Classic_updated_stde_P_rAAV.csv",DataFrame;header=false )
Classic_SE_muGLC=CSV.read(results_path*"/JEKF-Classic_updated_stde_P_muGLC.csv",DataFrame;header=false )
Classic_SE_muLAC=CSV.read(results_path*"/JEKF-Classic_updated_stde_P_muLAC.csv",DataFrame;header=false )
Classic_SE_murAAV=CSV.read(results_path*"/JEKF-Classic_updated_stde_P_murAAV.csv",DataFrame;header=false )

KPH2_Xv=CSV.read(results_path*"/JEKF-KPH2_Xv.csv",DataFrame;header=false )
KPH2_GLC=CSV.read(results_path*"/JEKF-KPH2_GLC.csv",DataFrame;header=false )
KPH2_LAC=CSV.read(results_path*"/JEKF-KPH2_LAC.csv",DataFrame;header=false )
KPH2_rAAV=CSV.read(results_path*"/JEKF-KPH2_rAAV.csv",DataFrame;header=false )
KPH2_muGLC=CSV.read(results_path*"/JEKF-KPH2_muGLC.csv",DataFrame;header=false )
KPH2_muLAC=CSV.read(results_path*"/JEKF-KPH2_muLAC.csv",DataFrame;header=false )
KPH2_muAAV=CSV.read(results_path*"/JEKF-KPH2_muAAV.csv",DataFrame;header=false )
KPH2_k_muGLC=CSV.read(results_path*"/JEKF-KPH2_k_mu_glc.csv",DataFrame;header=false )
KPH2_k_muLAC=CSV.read(results_path*"/JEKF-KPH2_k_mu_lac.csv",DataFrame;header=false )
KPH2_k_muAAV=CSV.read(results_path*"/JEKF-KPH2_k_mu_raav.csv",DataFrame;header=false )

KPH2_Sk=CSV.read(results_path*"/JEKF-KPH2_Sk.csv",DataFrame;header=false )
KPH2_innovation_error=CSV.read(results_path*"/JEKF-KPH2_innovation_error.csv",DataFrame;header=false )
KPH2_NIS=CSV.read(results_path*"/JEKF-KPH2_NIS.csv",DataFrame;header=false )

KPH2_SE_Xv=CSV.read(results_path*"/JEKF-KPH2_updated_stde_P_xv.csv",DataFrame;header=false )
KPH2_SE_GLC=CSV.read(results_path*"/JEKF-KPH2_updated_stde_P_GLC.csv",DataFrame;header=false )
KPH2_SE_LAC=CSV.read(results_path*"/JEKF-KPH2_updated_stde_P_LAC.csv",DataFrame;header=false )
KPH2_SE_rAAV=CSV.read(results_path*"/JEKF-KPH2_updated_stde_P_rAAV.csv",DataFrame;header=false )
KPH2_SE_muGLC=CSV.read(results_path*"/JEKF-KPH2_updated_stde_P_muGLC.csv",DataFrame;header=false )
KPH2_SE_muLAC=CSV.read(results_path*"/JEKF-KPH2_updated_stde_P_muLAC.csv",DataFrame;header=false )
KPH2_SE_murAAV=CSV.read(results_path*"/JEKF-KPH2_updated_stde_P_murAAV.csv",DataFrame;header=false )




# Checking consistency

function checking_consistency(innovation_error,Sk,NIS)

    innovation_error=innovation_error
    Sk=Sk
    NIS=NIS

    rmse= sqrt(sum(innovation_error.^2)/length(innovation_error))

    mean_NIS=mean(NIS)

    N=length(NIS)
    # https://www.chisquaretable.net/
    # https://www.itl.nist.gov/div898/handbook/eda/section3/eda3674.htm
    r1=2752.636832539055 # cquantile(Chisq(2901-1), .975) # CI from table using N=2901 size of noise dt
    r2=3051.1515913146504 # cquantile(Chisq(2901-1), .025)


    println("\n====== Innovation magnitude bound test ======")
    println("What is the percentege of innovation errors that lie within the ±2sqrt(Sk)? ", (N-(sum(-2*sqrt.(Sk).>innovation_error)+sum(innovation_error.>2*sqrt.(Sk))))/N )
    println("RMSE(innovation_error): ",rmse)
    println("mean(NIS): ",mean_NIS)
    # println("What is the percentege of innovation errors lie within the ±2sqrt(Sk) ", (N-(sum(-2*sqrt.(Sk).>innovation_error)+sum(innovation_error.>2*sqrt.(Sk))))/N )

    println("\n====== Normalised innovations squared Chi2 test ======")
    println("Is N*mean(NIS) inside of 95% CI (r1 < N*mean(NIS) < r2)?", r1 < N*mean_NIS < r2)
    println("N = ",N)
    println("r1 = ",r1)
    println("r2 = ",r2)
    println("N*mean(NIS) = ",N*mean_NIS)



    # println("Is N*mean(NIS) inside of 95% CI (two side)?", r1 < N*mean_NIS < r2)
    # println("Is N*mean(NIS) < 95% CI (one side)? ", 0 < N*mean_NIS < r2one)

    ppp=plot(NIS,label="NIS")
    plot!(repeat([mean_NIS], N), label="mean(NIS) ~ 1" )
    plot!(repeat([r1/N], N), label="r1/N" )
    plot!(repeat([r2/N], N), label="r2/N" )
    # plot!(repeat([r2one/N], N), label="r2one/N" )
    display(ppp)

    # # plot Innovation magnitude bound test
    # ppp=plot(innovation_error,label="Innovation error")
    # plot!(2*sqrt.(Sk), label="+2sqrt(Sk)" )
    # plot!(-2*sqrt.(Sk), label="-2sqrt(Sk)" )
    # display(ppp)
end


checking_consistency(Array(Classic_innovation_error),Array(Classic_Sk),Array(Classic_NIS))
checking_consistency(Array(SANTO_innovation_error),Array(SANTO_Sk),Array(SANTO_NIS))
checking_consistency(Array(KPH2_innovation_error),Array(KPH2_Sk),Array(KPH2_NIS))

tProcess=Array(timeEstimations)'
# plot Innovation magnitude bound test
innovation_error=Array(Classic_innovation_error)
Sk=Array(Classic_Sk)
plot1=plot(tProcess,innovation_error,label="Innovation error",xlabel=L"time(h)", ylabel=L"Innovation~Error" )
plot!(tProcess,2*sqrt.(Sk), label=L"+2\sqrt{S_k}" )
plot!(tProcess,-2*sqrt.(Sk), label=L"-2\sqrt{S_k}" )
plot!(legend=:outertopright)
annotate!(85, 1.5e4, text("JEKF-Classic", :left, 10, 13))

innovation_error=Array(SANTO_innovation_error)
Sk=Array(SANTO_Sk)
plot2=plot(tProcess,innovation_error,label="Innovation error",xlabel=L"time(h)", ylabel=L"Innovation~Error" )
plot!(tProcess,2*sqrt.(Sk), label=L"+2\sqrt{S_k}" )
plot!(tProcess,-2*sqrt.(Sk), label=L"-2\sqrt{S_k}" )
plot!(legend=:outertopright)
annotate!(85, 1.4e4, text("JEKF-SANTO", :left, 10, 13))

innovation_error=Array(KPH2_innovation_error)
Sk=Array(KPH2_Sk)
plot3=plot(tProcess,innovation_error,label="Innovation error",xlabel=L"time(h)", ylabel=L"Innovation~Error" )
plot!(tProcess,2*sqrt.(Sk), label=L"+2\sqrt{S_k}" )
plot!(tProcess,-2*sqrt.(Sk), label=L"-2\sqrt{S_k}" )
plot!(legend=:outertopright)
annotate!(85, 1.5e4, text("JEKF-KPH2", :left, 10, 13))

pp=plot(plot1,plot2,plot3, layout=(3,1),size = (900,800))
display(pp)
# png("IMB-RDT_with_MRDE_PC_and_SPECIFIC_P0")






gr(xtickfontsize=13, ytickfontsize=13, xguidefontsize=16, yguidefontsize=16, legendfontsize=11);
tProcess=Array(timeEstimations)'
# plot Innovation magnitude bound test
innovation_error=Array(Classic_innovation_error)
Sk=Array(Classic_Sk)
plot1=plot(tProcess,innovation_error,label=L"Innovation~error~of~JEKF-Classic",xlabel=L"time(h)",color=:purple, ylabel=L"Innovation~Error" ,linestyle=:solid, lw=lws)
plot!(tProcess,2*sqrt.(Sk),  label=L"+2\sqrt{S_k}~of~JEKF-Classic",color=:purple ,linestyle=:solid, lw=lws)
plot!(tProcess,-2*sqrt.(Sk),label=L"-2\sqrt{S_k}~of~JEKF-Classic" ,color=:purple,linestyle=:solid, lw=lws)
plot!(legend=:outertopright)
# annotate!(85, 1.5e4, text("JEKF-Classic", :left, 10, 13))

innovation_error=Array(SANTO_innovation_error)
Sk=Array(SANTO_Sk)
plot!(tProcess,innovation_error,label=L"Innovation~error~of~JEKF-SANTO",xlabel=L"time(h)", ylabel=L"Innovation~Error" ,color=:blue,linestyle=:dot, lw=lws)
plot!(tProcess,2*sqrt.(Sk), label=L"+2\sqrt{S_k}~of~JEKF-SANTO" ,color=:blue,linestyle=:dot, lw=lws)
plot!(tProcess,-2*sqrt.(Sk),  label=L"-2\sqrt{S_k}~of~JEKF-SANTO" ,color=:blue,linestyle=:dot, lw=lws )
plot!(legend=:outertopright)
# annotate!(85, 1.4e4, text("JEKF-SANTO", :left, 10, 13))

innovation_error=Array(KPH2_innovation_error)
Sk=Array(KPH2_Sk)
plot!(tProcess,innovation_error,label=L"Innovation~error~of~JEKF-KPH2",xlabel=L"time(h)", ylabel=L"Innovation~Error" ,color=:green,linestyle=:dashdot, lw=lws)
plot!(tProcess,2*sqrt.(Sk), label=L"+2\sqrt{S_k}~of~JEKF-KPH2" ,color=:green,linestyle=:dashdot, lw=lws )
plot!(tProcess,-2*sqrt.(Sk),  label=L"-2\sqrt{S_k}~of~JEKF-KPH2",color=:green,linestyle=:dashdot , lw=lws )
plot!(legend=:outertopright)
# annotate!(85, 1.5e4, text("JEKF-KPH2", :left, 10, 13))

pp=plot(plot1,size = (1300,500),left_margin=5mm, bottom_margin=5mm)
display(pp)
png("IMB-RDT_with_MRDE_PC_and_SPECIFIC_P0")












################ kalman gain

plot_K1=plot(Array(timeEstimations)',(Array(Classic_k_muGLC)), label = "JEKF-Classic",color=:purple ,xlabel=L"time(h)", ylabel=L"\textbf{K}_k~of~\mu GLC", lw=lws)
plot!(Array(timeEstimations)',(Array(SANTO_k_muGLC)), label = "JEKF-SANTO",color=:blue , lw=lws )
plot!(Array(timeEstimations)',(Array(KPH2_k_muGLC)), label = "JEKF-KPH2",color=:green , lw=lws )
plot!(legend=:topright)
# annotate!(80, 5e-13, text("\muGLC", :left, 10, 17))
display(plot_K1)

plot_K2=plot(Array(timeEstimations)',(Array(Classic_k_muLAC)), label = "JEKF-Classic",color=:purple ,xlabel=L"time(h)", ylabel=L"\textbf{K}_k~of~\mu LAC", lw=lws)
plot!(Array(timeEstimations)',(Array(SANTO_k_muLAC)), label = "JEKF-SANTO",color=:blue , lw=lws )
plot!(Array(timeEstimations)',(Array(KPH2_k_muLAC)), label = "JEKF-KPH2",color=:green , lw=lws )
plot!(legend=:topright)
display(plot_K2)

plot_K3=plot(Array(timeEstimations)',(Array(Classic_k_muAAV)), label = "JEKF-Classic",color=:purple ,xlabel=L"time(h)", ylabel=L"\textbf{K}_k~of~\mu rAAV", lw=lws)
plot!(Array(timeEstimations)',(Array(SANTO_k_muAAV)), label = "JEKF-SANTO",color=:blue , lw=lws )
plot!(Array(timeEstimations)',(Array(KPH2_k_muAAV)), label = "JEKF-KPH2",color=:green , lw=lws )
plot!(legend=:topright)
display(plot_K3)

pp=plot(plot_K1,plot_K2,plot_K3, layout=(3,1),size = (800,700),left_margin=5mm, bottom_margin=5mm)
# savefig(abs_path*"/JEKF-SANTO/results_analyze/figs/real_dt/estimations_RD_Puncorrelated_sp0.png")

display(pp)
png("kalman_gain_RDT_B_with_MRDE_PC_and_SPECIFIC_P0")





################ SE
lws=3.5
gr(xtickfontsize=13, ytickfontsize=13, xguidefontsize=16, yguidefontsize=16, legendfontsize=11);

plot_SE=plot(Array(timeEstimations)',(Array(Classic_SE_Xv)), label = "JEKF-Classic",color=:purple ,xlabel=L"time(h)", ylabel=L"SE~of~Xv", lw=lws,linestyle=:solid)
plot!(Array(timeEstimations)',(Array(SANTO_SE_Xv)), label = "JEKF-SANTO",color=:blue , lw=lws,linestyle=:dot )
plot!(Array(timeEstimations)',(Array(KPH2_SE_Xv)), label = "JEKF-KPH2",color=:green , lw=lws ,linestyle=:dashdot)
# plot!(legend=:outertopright)
plot!(legend=:bottomright,size = (900,400),left_margin=5mm, bottom_margin=5mm)
display(plot_SE)
png("SE_xv_RD_with_MRDE_PC_and_SPECIFIC_P0")


plot_SE1=plot(Array(timeEstimations)',(Array(Classic_SE_GLC)), label = "JEKF-Classic",color=:purple ,xlabel=L"time(h)", ylabel=L"SE~of~GLC", lw=lws)
plot_SE2=plot(Array(timeEstimations)',(Array(SANTO_SE_GLC)), label = "JEKF-SANTO",color=:blue ,xlabel=L"time(h)", ylabel=L"SE~of~GLC", lw=lws )
plot_SE3=plot(Array(timeEstimations)',(Array(KPH2_SE_GLC)), label = "JEKF-KPH2",color=:green ,xlabel=L"time(h)", ylabel=L"SE~of~GLC", lw=lws )
pp=plot(plot_SE1,plot_SE2,plot_SE3, layout=(3,1),size = (900,800),left_margin=5mm, bottom_margin=5mm)
display(pp)
png("SE_GLC_RD_with_MRDE_PC_and_SPECIFIC_P0")


plot_SE1=plot(Array(timeEstimations)',(Array(Classic_SE_LAC)), label = "JEKF-Classic",color=:purple ,xlabel=L"time(h)", ylabel=L"SE~of~LAC", lw=lws)
plot_SE2=plot(Array(timeEstimations)',(Array(SANTO_SE_LAC)), label = "JEKF-SANTO",color=:blue , xlabel=L"time(h)",ylabel=L"SE~of~LAC", lw=lws )
plot_SE3=plot(Array(timeEstimations)',(Array(KPH2_SE_LAC)), label = "JEKF-KPH2",color=:green ,xlabel=L"time(h)", ylabel=L"SE~of~LAC", lw=lws )
pp=plot(plot_SE1,plot_SE2,plot_SE3, layout=(3,1),size = (900,800),left_margin=5mm, bottom_margin=5mm)
display(pp)
png("SE_LAC_RD_with_MRDE_PC_and_SPECIFIC_P0")


plot_SE1=plot(Array(timeEstimations)',(Array(Classic_SE_rAAV)), label = "JEKF-Classic",color=:purple ,xlabel=L"time(h)", ylabel=L"SE~of~rAAV", lw=lws)
plot_SE2=plot(Array(timeEstimations)',(Array(SANTO_SE_rAAV)), label = "JEKF-SANTO",color=:blue , xlabel=L"time(h)",ylabel=L"SE~of~rAAV", lw=lws )
plot_SE3=plot(Array(timeEstimations)',(Array(KPH2_SE_rAAV)), label = "JEKF-KPH2",color=:green , xlabel=L"time(h)",ylabel=L"SE~of~rAAV", lw=lws )
pp=plot(plot_SE1,plot_SE2,plot_SE3, layout=(3,1),size = (900,800),left_margin=5mm, bottom_margin=5mm)
display(pp)
png("SE_rAAV_RD_with_MRDE_PC_and_SPECIFIC_P0")


plot_SE1=plot(Array(timeEstimations)',(Array(Classic_SE_muGLC)), label = "JEKF-Classic",color=:purple ,xlabel=L"time(h)", ylabel=L"SE~of~\mu GLC", lw=lws)
plot_SE2=plot(Array(timeEstimations)',(Array(SANTO_SE_muGLC)), label = "JEKF-SANTO",color=:blue , xlabel=L"time(h)",ylabel=L"SE~of~\mu GLC", lw=lws )
plot_SE3=plot(Array(timeEstimations)',(Array(KPH2_SE_muGLC)), label = "JEKF-KPH2",color=:green ,xlabel=L"time(h)", ylabel=L"SE~of~\mu GLC", lw=lws )
pp=plot(plot_SE1,plot_SE2,plot_SE3, layout=(3,1),size = (900,800),left_margin=5mm, bottom_margin=5mm)
display(pp)
png("SE_muGLC_RD_with_MRDE_PC_and_SPECIFIC_P0")


plot_SE1=plot(Array(timeEstimations)',(Array(Classic_SE_muLAC)), label = "JEKF-Classic",color=:purple ,xlabel=L"time(h)", ylabel=L"SE~of~\mu LAC", lw=lws)
plot_SE2=plot(Array(timeEstimations)',(Array(SANTO_SE_muLAC)), label = "JEKF-SANTO",color=:blue , xlabel=L"time(h)",ylabel=L"SE~of~\mu LAC", lw=lws )
plot_SE3=plot(Array(timeEstimations)',(Array(KPH2_SE_muLAC)), label = "JEKF-KPH2",color=:green, xlabel=L"time(h)",ylabel=L"SE~of~\mu LAC" , lw=lws )
pp=plot(plot_SE1,plot_SE2,plot_SE3, layout=(3,1),size = (900,800),left_margin=5mm, bottom_margin=5mm)
display(pp)
png("SE_muLAC_RD_with_MRDE_PC_and_SPECIFIC_P0")

plot_SE=plot(Array(timeEstimations)',(Array(Classic_SE_murAAV)), label = "JEKF-Classic",color=:purple ,xlabel=L"time(h)", ylabel=L"SE~of~\mu rAAV", lw=lws)
plot!(Array(timeEstimations)',(Array(SANTO_SE_murAAV)), label = "JEKF-SANTO",color=:blue , xlabel=L"time(h)",ylabel=L"SE~of~\mu rAAV", lw=lws )
plot!(Array(timeEstimations)',Array(KPH2_SE_murAAV), label = "JEKF-KPH2",color=:green , xlabel=L"time(h)",ylabel=L"SE~of~\mu rAAV", lw=lws )
pp=plot(plot_SE1,plot_SE2,plot_SE3, layout=(3,1),size = (900,800),left_margin=5mm, bottom_margin=5mm)
display(pp)
png("SE_murAAV_RD_with_MRDE_PC_and_SPECIFIC_P0")







# println("PC and specific P(0)")
gr();
plot0=plot(Array(timeRD)',Array(xv_online_measurement_RD_AAV),color=:lightblue, label = "Xv online (noise)", lw=5.5, xlabel=L"time(h)",ylabel=L"Xv(cells/mL)")
plot!(Array(timeEstimations)',Array(Classic_Xv),color=:purple, label = "JEKF-Classic", lw=2.5,xlabel=L"time(h)",ylabel=L"Xv( cells/mL)")
plot!(Array(timeEstimations)',Array(SANTO_Xv),color=:blue, label = "JEKF-SANTO", lw=2.5,xlabel=L"time(h)",ylabel=L"Xv(    cells/mL)")
plot!(Array(timeEstimations)',Array(KPH2_Xv),color=:green,label = "JEKF-KPH2",  lw=2.5,xlabel=L"time(h)",ylabel=L"Xv(    cells/mL)")
plot!(legend=:bottomright,size = (650,450))
annotate!(70, 1.6e6, text("A", :left, 10, 17))

plot1=plot(Array(timeEstimations)',Array(SANTO_GLC),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
plot!(Array(timeEstimations)',Array(KPH2_GLC),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"GLC(mM)")
plot!(Array(timeEstimations)',Array(Classic_GLC),color=:purple,label = "JEKF-Classic",  lw=3.5,xlabel=L"time(h)",ylabel=L"GLC(mM)")
Plots.scatter!([4679-3;6144-3]/60,[22.00943658;17.707466],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
plot!(legend=:bottomleft)
annotate!(80, 20, text("B", :left, 10, 17))

plot2=plot(Array(timeEstimations)',Array(SANTO_LAC),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
plot!(Array(timeEstimations)',Array(KPH2_LAC),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"LAC(mM)")
plot!(Array(timeEstimations)',Array(Classic_LAC),color=:purple,label = "JEKF-Classic",  lw=3.5,xlabel=L"time(h)",ylabel=L"LAC(mM)")
Plots.scatter!([4679-3;6144-3]/60,[9.10352484;11.54593394],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
plot!(legend=false)
annotate!(80, 11, text("C", :left, 10, 17))

plot3=plot(Array(timeEstimations)',Array(SANTO_rAAV),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
plot!(Array(timeEstimations)',Array(KPH2_rAAV),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
plot!(Array(timeEstimations)',Array(Classic_rAAV),color=:purple,label = "JEKF-Classic",  lw=3.5,xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
Plots.scatter!([3252-3;4679-3;6144-3]/60,[0;3190000000;7010000000],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
plot!(legend=false)
annotate!(80, 5e9, text("D", :left, 10, 17))

plot4=plot(Array(timeEstimations)',Array(SANTO_muGLC),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
plot!(Array(timeEstimations)',Array(KPH2_muGLC),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
plot!(Array(timeEstimations)',Array(Classic_muGLC),color=:purple,label = "JEKF-Classic",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
plot!(legend=false)
annotate!(80,  1.3e-7, text("E", :left, 10, 17))

plot5=plot(Array(timeEstimations)',Array(SANTO_muLAC),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
plot!(Array(timeEstimations)',Array(KPH2_muLAC),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
plot!(Array(timeEstimations)',Array(Classic_muLAC),color=:purple,label = "JEKF-Classic",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
plot!(legend=false)
annotate!(80, 4e-8, text("F", :left, 10, 17))

plot6=plot(Array(timeEstimations)',Array(SANTO_muAAV),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
plot!(Array(timeEstimations)',Array(KPH2_muAAV),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
plot!(Array(timeEstimations)',Array(Classic_muAAV),color=:purple,label = "JEKF-Classic",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
plot!(legend=false)
annotate!(80, 90, text("G", :left, 10, 17))


pp=plot(plot0,plot1,plot2,plot3,plot4,plot5,plot6, layout=(4,2),size = (1000,900))
# savefig(abs_path*"/JEKF-SANTO/results_analyze/figs/real_dt/estimations_RD_Puncorrelated_sp0.png")

display(pp)
png("RDT_B_with_MRDE_PC_and_SPECIFIC_P0")


















#
#
#
#
#
#
# function RMSE(observed_data,prediction)
#     t=observed_data
#     y=prediction
#     se = (t - y).^2
#     mse = mean(se)
#     rmse = sqrt(mse)
#     return rmse
# end
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
# abs_path="/Users/cristovao/Devel/bioprocessesDT"
#
#
#
#
# xv_online_measurement_RD_AAV=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/xv_online_measurement_RD_AAV.csv",DataFrame;header=false )
#
# timeEKF=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_synthetic_data/time_h_of_Xv_syntetic_data_with_gaussian_noises.csv",DataFrame;header=false )
# timeRD=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/time_RD.csv",DataFrame;header=false )
#
#
# Xv_online_run41_noise_3=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_synthetic_data/Xv_syntetic_data_run41_with_gaussian_noise_0.5.csv",DataFrame;header=false )
# mAb_True_syntetic_data_based_on_run41=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_synthetic_data/mAb_syntetic_data_based_on_run41.csv",DataFrame;header=false )
# Xv_syntetic_data_run41_ground_truth=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_synthetic_data/Xv_syntetic_data_run41_ground_truth.csv",DataFrame;header=false )
#
#
#
#
# test=CSV.read("/JEKF-SANTO_LAC.csv",DataFrame;header=false )
# plot(Array(test))
#
#
# ## Evaluation_with_REAL_data
#
#
# ##--------------------------- specific P(0)
# # MRDE-PU P uncorrelated
# Xv_result_SIC_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/Xv_result_SIC_pc_rd.csv",DataFrame;header=false )
# GLC_result_SIC_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/GLC_result_SIC_pc.csv",DataFrame;header=false )
# LAC_result_SIC_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/LAC_result_SIC_pc.csv",DataFrame;header=false )
# rAAV_result_SIC_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/rAAV_result_SIC_pc.csv",DataFrame;header=false )
# uGLC_result_SIC_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/uGLC_result_SIC_pc.csv",DataFrame;header=false )
# uLAC_result_SIC_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/uLAC_result_SIC_pc.csv",DataFrame;header=false )
# urAAV_result_SIC_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/urAAV_result_SIC_pc.csv",DataFrame;header=false )
#
# Xv_result_KPH2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/Xv_result_KPH2_pc_rd.csv",DataFrame;header=false )
# GLC_result_KPH2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/GLC_result_KPH2_pc.csv",DataFrame;header=false )
# LAC_result_KPH2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/LAC_result_KPH2_pc.csv",DataFrame;header=false )
# rAAV_result_KPH2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/rAAV_result_KPH2_pc.csv",DataFrame;header=false )
# uGLC_result_KPH2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/uGLC_result_KPH2_pc.csv",DataFrame;header=false )
# uLAC_result_KPH2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/uLAC_result_KPH2_pc.csv",DataFrame;header=false )
# urAAV_result_KPH2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/urAAV_result_KPH2_pc.csv",DataFrame;header=false )
#
# Xv_result_KPH2_pu_rd_sp0_2=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/Xv_result_KPH2_pc_rd_2.csv",DataFrame;header=false )
# GLC_result_KPH2_pu_rd_sp0_2=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/GLC_result_KPH2_pc_2.csv",DataFrame;header=false )
# LAC_result_KPH2_pu_rd_sp0_2=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/LAC_result_KPH2_pc_2.csv",DataFrame;header=false )
# rAAV_result_KPH2_pu_rd_sp0_2=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/rAAV_result_KPH2_pc_2.csv",DataFrame;header=false )
# uGLC_result_KPH2_pu_rd_sp0_2=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/uGLC_result_KPH2_pc_2.csv",DataFrame;header=false )
# uLAC_result_KPH2_pu_rd_sp0_2=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/uLAC_result_KPH2_pc_2.csv",DataFrame;header=false )
# urAAV_result_KPH2_pu_rd_sp0_2=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/urAAV_result_KPH2_pc_2.csv",DataFrame;header=false )
#
# Xv_result_1H2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/Xv_result_1H2_pc_rd.csv",DataFrame;header=false )
# GLC_result_1H2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/GLC_result_1H2_pc.csv",DataFrame;header=false )
# LAC_result_1H2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/LAC_result_1H2_pc.csv",DataFrame;header=false )
# rAAV_result_1H2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/rAAV_result_1H2_pc.csv",DataFrame;header=false )
# uGLC_result_1H2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/uGLC_result_1H2_pc.csv",DataFrame;header=false )
# uLAC_result_1H2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/uLAC_result_1H2_pc.csv",DataFrame;header=false )
# urAAV_result_1H2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/urAAV_result_1H2_pc.csv",DataFrame;header=false )
#
# Xv_result_2H2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/Xv_result_2H2_pc_rd.csv",DataFrame;header=false )
# GLC_result_2H2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/GLC_result_2H2_pc.csv",DataFrame;header=false )
# LAC_result_2H2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/LAC_result_2H2_pc.csv",DataFrame;header=false )
# rAAV_result_2H2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/rAAV_result_2H2_pc.csv",DataFrame;header=false )
# uGLC_result_2H2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/uGLC_result_2H2_pc.csv",DataFrame;header=false )
# uLAC_result_2H2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/uLAC_result_2H2_pc.csv",DataFrame;header=false )
# urAAV_result_2H2_pu_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_uncorrelated/urAAV_result_2H2_pc.csv",DataFrame;header=false )
#
# # MRDE-PC  P correlated
#
#
# Xv_result_SIC_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/Xv_result_SIC_pc_rd.csv",DataFrame;header=false )
# GLC_result_SIC_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/GLC_result_SIC_pc.csv",DataFrame;header=false )
# LAC_result_SIC_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/LAC_result_SIC_pc.csv",DataFrame;header=false )
# rAAV_result_SIC_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/rAAV_result_SIC_pc.csv",DataFrame;header=false )
# uGLC_result_SIC_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/uGLC_result_SIC_pc.csv",DataFrame;header=false )
# uLAC_result_SIC_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/uLAC_result_SIC_pc.csv",DataFrame;header=false )
# urAAV_result_SIC_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/urAAV_result_SIC_pc.csv",DataFrame;header=false )
#
# Xv_result_KPH2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/Xv_result_KPH2_pc_rd.csv",DataFrame;header=false )
# GLC_result_KPH2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/GLC_result_KPH2_pc.csv",DataFrame;header=false )
# LAC_result_KPH2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/LAC_result_KPH2_pc.csv",DataFrame;header=false )
# rAAV_result_KPH2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/rAAV_result_KPH2_pc.csv",DataFrame;header=false )
# uGLC_result_KPH2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/uGLC_result_KPH2_pc.csv",DataFrame;header=false )
# uLAC_result_KPH2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/uLAC_result_KPH2_pc.csv",DataFrame;header=false )
# urAAV_result_KPH2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/urAAV_result_KPH2_pc.csv",DataFrame;header=false )
#
# Xv_result_KPH2_pc_rd_sp0_2=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/Xv_result_KPH2_pc_rd_2.csv",DataFrame;header=false )
# GLC_result_KPH2_pc_rd_sp0_2=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/GLC_result_KPH2_pc_2.csv",DataFrame;header=false )
# LAC_result_KPH2_pc_rd_sp0_2=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/LAC_result_KPH2_pc_2.csv",DataFrame;header=false )
# rAAV_result_KPH2_pc_rd_sp0_2=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/rAAV_result_KPH2_pc_2.csv",DataFrame;header=false )
# uGLC_result_KPH2_pc_rd_sp0_2=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/uGLC_result_KPH2_pc_2.csv",DataFrame;header=false )
# uLAC_result_KPH2_pc_rd_sp0_2=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/uLAC_result_KPH2_pc_2.csv",DataFrame;header=false )
# urAAV_result_KPH2_pc_rd_sp0_2=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/urAAV_result_KPH2_pc_2.csv",DataFrame;header=false )
#
# Xv_result_1H2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/Xv_result_1H2_pc_rd.csv",DataFrame;header=false )
# GLC_result_1H2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/GLC_result_1H2_pc.csv",DataFrame;header=false )
# LAC_result_1H2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/LAC_result_1H2_pc.csv",DataFrame;header=false )
# rAAV_result_1H2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/rAAV_result_1H2_pc.csv",DataFrame;header=false )
# uGLC_result_1H2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/uGLC_result_1H2_pc.csv",DataFrame;header=false )
# uLAC_result_1H2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/uLAC_result_1H2_pc.csv",DataFrame;header=false )
# urAAV_result_1H2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/urAAV_result_1H2_pc.csv",DataFrame;header=false )
#
# Xv_result_2H2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/Xv_result_2H2_pc_rd.csv",DataFrame;header=false )
# GLC_result_2H2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/GLC_result_2H2_pc.csv",DataFrame;header=false )
# LAC_result_2H2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/LAC_result_2H2_pc.csv",DataFrame;header=false )
# rAAV_result_2H2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/rAAV_result_2H2_pc.csv",DataFrame;header=false )
# uGLC_result_2H2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/uGLC_result_2H2_pc.csv",DataFrame;header=false )
# uLAC_result_2H2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/uLAC_result_2H2_pc.csv",DataFrame;header=false )
# urAAV_result_2H2_pc_rd_sp0=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data_specific_P0/MRDE_with_P_correlated/urAAV_result_2H2_pc.csv",DataFrame;header=false )
#
#
#
#
#
#
#
#
# ##---------------------------  unique P(0)
#
# #MRDE-PU   P uncorrelated
# Xv_result_SIC_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/Xv_result_SIC_pc_rd.csv",DataFrame;header=false )
# GLC_result_SIC_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/GLC_result_SIC_pc.csv",DataFrame;header=false )
# LAC_result_SIC_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/LAC_result_SIC_pc.csv",DataFrame;header=false )
# rAAV_result_SIC_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/rAAV_result_SIC_pc.csv",DataFrame;header=false )
# uGLC_result_SIC_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/uGLC_result_SIC_pc.csv",DataFrame;header=false )
# uLAC_result_SIC_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/uLAC_result_SIC_pc.csv",DataFrame;header=false )
# urAAV_result_SIC_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/urAAV_result_SIC_pc.csv",DataFrame;header=false )
#
# Xv_result_KPH2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/Xv_result_KPH2_pc_rd.csv",DataFrame;header=false )
# GLC_result_KPH2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/GLC_result_KPH2_pc.csv",DataFrame;header=false )
# LAC_result_KPH2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/LAC_result_KPH2_pc.csv",DataFrame;header=false )
# rAAV_result_KPH2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/rAAV_result_KPH2_pc.csv",DataFrame;header=false )
# uGLC_result_KPH2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/uGLC_result_KPH2_pc.csv",DataFrame;header=false )
# uLAC_result_KPH2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/uLAC_result_KPH2_pc.csv",DataFrame;header=false )
# urAAV_result_KPH2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/urAAV_result_KPH2_pc.csv",DataFrame;header=false )
#
#
# Xv_result_1H2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/Xv_result_1H2_pc_rd.csv",DataFrame;header=false )
# GLC_result_1H2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/GLC_result_1H2_pc.csv",DataFrame;header=false )
# LAC_result_1H2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/LAC_result_1H2_pc.csv",DataFrame;header=false )
# rAAV_result_1H2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/rAAV_result_1H2_pc.csv",DataFrame;header=false )
# uGLC_result_1H2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/uGLC_result_1H2_pc.csv",DataFrame;header=false )
# uLAC_result_1H2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/uLAC_result_1H2_pc.csv",DataFrame;header=false )
# urAAV_result_1H2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/urAAV_result_1H2_pc.csv",DataFrame;header=false )
#
# Xv_result_2H2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/Xv_result_2H2_pc_rd.csv",DataFrame;header=false )
# GLC_result_2H2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/GLC_result_2H2_pc.csv",DataFrame;header=false )
# LAC_result_2H2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/LAC_result_2H2_pc.csv",DataFrame;header=false )
# rAAV_result_2H2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/rAAV_result_2H2_pc.csv",DataFrame;header=false )
# uGLC_result_2H2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/uGLC_result_2H2_pc.csv",DataFrame;header=false )
# uLAC_result_2H2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/uLAC_result_2H2_pc.csv",DataFrame;header=false )
# urAAV_result_2H2_pu_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_uncorrelated/urAAV_result_2H2_pc.csv",DataFrame;header=false )
#
#
#
# #MRDE-PC
# Xv_result_SIC_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/Xv_result_SIC_pc_rd.csv",DataFrame;header=false )
# GLC_result_SIC_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/GLC_result_SIC_pc.csv",DataFrame;header=false )
# LAC_result_SIC_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/LAC_result_SIC_pc.csv",DataFrame;header=false )
# rAAV_result_SIC_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/rAAV_result_SIC_pc.csv",DataFrame;header=false )
# uGLC_result_SIC_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/uGLC_result_SIC_pc.csv",DataFrame;header=false )
# uLAC_result_SIC_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/uLAC_result_SIC_pc.csv",DataFrame;header=false )
# urAAV_result_SIC_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/urAAV_result_SIC_pc.csv",DataFrame;header=false )
#
# Xv_result_KPH2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/Xv_result_KPH2_pc_rd.csv",DataFrame;header=false )
# GLC_result_KPH2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/GLC_result_KPH2_pc.csv",DataFrame;header=false )
# LAC_result_KPH2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/LAC_result_KPH2_pc.csv",DataFrame;header=false )
# rAAV_result_KPH2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/rAAV_result_KPH2_pc.csv",DataFrame;header=false )
# uGLC_result_KPH2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/uGLC_result_KPH2_pc.csv",DataFrame;header=false )
# uLAC_result_KPH2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/uLAC_result_KPH2_pc.csv",DataFrame;header=false )
# urAAV_result_KPH2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/urAAV_result_KPH2_pc.csv",DataFrame;header=false )
#
# Xv_result_1H2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/Xv_result_1H2_pc_rd.csv",DataFrame;header=false )
# GLC_result_1H2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/GLC_result_1H2_pc.csv",DataFrame;header=false )
# LAC_result_1H2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/LAC_result_1H2_pc.csv",DataFrame;header=false )
# rAAV_result_1H2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/rAAV_result_1H2_pc.csv",DataFrame;header=false )
# uGLC_result_1H2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/uGLC_result_1H2_pc.csv",DataFrame;header=false )
# uLAC_result_1H2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/uLAC_result_1H2_pc.csv",DataFrame;header=false )
# urAAV_result_1H2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/urAAV_result_1H2_pc.csv",DataFrame;header=false )
#
# Xv_result_2H2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/Xv_result_2H2_pc_rd.csv",DataFrame;header=false )
# GLC_result_2H2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/GLC_result_2H2_pc.csv",DataFrame;header=false )
# LAC_result_2H2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/LAC_result_2H2_pc.csv",DataFrame;header=false )
# rAAV_result_2H2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/rAAV_result_2H2_pc.csv",DataFrame;header=false )
# uGLC_result_2H2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/uGLC_result_2H2_pc.csv",DataFrame;header=false )
# uLAC_result_2H2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/uLAC_result_2H2_pc.csv",DataFrame;header=false )
# urAAV_result_2H2_pc_rd=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/MRDE_with_P_correlated/urAAV_result_2H2_pc.csv",DataFrame;header=false )
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
# # gr( xtickfontsize=13, ytickfontsize=13, xguidefontsize=16, yguidefontsize=16, legendfontsize=13);
#
#
#
#
#
#
#
# timeRD=CSV.read(abs_path*"/JEKF-SANTO/Evaluation_with_real_data/time_RD.csv",DataFrame;header=false )
#
# ##MRDE-PU -----PU and unique P(0)
# println("PU and unique P(0)aa")
#
# plot0=plot(Array(timeRD)',Array(xv_online_measurement_RD_AAV),color=:lightblue, label = "Xv online (noise)", lw=5.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# plot!(Array(timeRD)',Array(Xv_result_SIC_pu_rd),color=:blue, label = "JEKF-SANTO", lw=2.5,xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# # plot!(Array(timeRD)',Array(Xv_result_1H2_pu_rd),color=:black, label = "JEKF-1H2", lw=2.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# # plot!(Array(timeRD)',Array(Xv_result_2H2_pu_rd),color=:orange, label = "JEKF-2H2", lw=2.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# plot!(Array(timeRD)',Array(Xv_result_KPH2_pu_rd),color=:green,label = "JEKF-KPH2",  lw=2.5,xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# plot!(legend=:bottomright,size = (650,450))
#
# plot1=plot(Array(timeRD)',Array(GLC_result_SIC_pu_rd),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
# # plot!(Array(timeRD)',Array(GLC_result_1H2_pu_rd),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"GLC(mM)")
# # plot!(Array(timeRD)',Array(GLC_result_2H2_pu_rd),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
# plot!(Array(timeRD)',Array(GLC_result_KPH2_pu_rd),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"GLC(mM)")
# Plots.scatter!([4679-3;6144-3]/60,[22.00943658;17.707466],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
# plot!(legend=:bottomleft)
#
# plot2=plot(Array(timeRD)',Array(LAC_result_SIC_pu_rd),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
# # plot!(Array(timeRD)',Array(LAC_result_1H2_pu_rd),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"LAC(mM)")
# # plot!(Array(timeRD)',Array(LAC_result_2H2_pu_rd),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
# plot!(Array(timeRD)',Array(LAC_result_KPH2_pu_rd),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"LAC(mM)")
# Plots.scatter!([4679-3;6144-3]/60,[9.10352484;11.54593394],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
# plot!(legend=false)
#
# plot3=plot(Array(timeRD)',Array(rAAV_result_SIC_pu_rd),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# # plot!(Array(timeRD)',Array(rAAV_result_1H2_pu_rd),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# # plot!(Array(timeRD)',Array(rAAV_result_2H2_pu_rd),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# plot!(Array(timeRD)',Array(rAAV_result_KPH2_pu_rd),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# Plots.scatter!([3252-3;4679-3;6144-3]/60,[0;3190000000/10^9;7010000000/10^9],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# plot!(legend=false)
#
#
# ar=Array(GLC_result_SIC_pu_rd)
# println("plot1\nRMSE(GLC Ground truth vs SANTO): ",RMSE([ar[1424];ar[2889]],[22.00943658;17.707466]))
# ar=Array(GLC_result_KPH2_pu_rd)
# println("RMSE(GLC Ground truth vs KPH2): ",RMSE([ar[1424];ar[2889]],[22.00943658;17.707466]))
#
# ar=Array(LAC_result_SIC_pu_rd)
# println("RMSE(LAC Ground truth vs SANTO): ",RMSE([ar[1424];ar[2889]],[9.10352484;11.54593394]))
# ar=Array(LAC_result_KPH2_pu_rd)
# println("RMSE(LAC Ground truth vs KPH2): ",RMSE([ar[1424];ar[2889]],[9.10352484;11.54593394]))
#
# ar=Array(rAAV_result_SIC_pu_rd)
# println("RMSE(rAAV Ground truth vs SANTO): ",RMSE([ar[1];ar[1424];ar[2889]],[0;3190000000/10^9;7010000000/10^9]))
# ar=Array(rAAV_result_KPH2_pu_rd)
# println("RMSE(rAAV Ground truth vs KPH2): ",RMSE([ar[1];ar[1424];ar[2889]],[0;3190000000/10^9;7010000000/10^9]))
#
#
#
# plot4=plot(Array(timeRD)',Array(uGLC_result_SIC_pu_rd),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# # plot!(Array(timeRD)',Array(uGLC_result_1H2_pu_rd),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# # plot!(Array(timeRD)',Array(uGLC_result_2H2_pu_rd),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# plot!(Array(timeRD)',Array(uGLC_result_KPH2_pu_rd),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# plot!(legend=false)
#
# plot5=plot(Array(timeRD)',Array(uLAC_result_SIC_pu_rd),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# # plot!(Array(timeRD)',Array(uLAC_result_1H2_pu_rd),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# # plot!(Array(timeRD)',Array(uLAC_result_2H2_pu_rd),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# plot!(Array(timeRD)',Array(uLAC_result_KPH2_pu_rd),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# plot!(legend=false)
#
# plot6=plot(Array(timeRD)',Array(urAAV_result_SIC_pu_rd),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# # plot!(Array(timeRD)',Array(urAAV_result_1H2_pu_rd),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# # plot!(Array(timeRD)',Array(urAAV_result_2H2_pu_rd),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# plot!(Array(timeRD)',Array(urAAV_result_KPH2_pu_rd),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# plot!(legend=false)
#
# pp=plot(plot0,plot1,plot2,plot3,plot4,plot5,plot6, layout=(4,2),size = (800,900))
# savefig(abs_path*"/JEKF-SANTO/results_analyze/figs/real_dt/estimations_RD_Puncorrelated.png")
# display(pp)
#
#
# ## MRDE-PC-----PC and unique P(0)
# println("PC and unique P(0)aa")
#
# plot0=plot(Array(timeRD)',Array(xv_online_measurement_RD_AAV),color=:lightblue, label = "Xv online (noise)", lw=5.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# plot!(Array(timeRD)',Array(Xv_result_SIC_pc_rd),color=:blue, label = "JEKF-SANTO", lw=2.5,xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# # plot!(Array(timeRD)',Array(Xv_result_1H2_pc_rd),color=:black, label = "JEKF-1H2", lw=2.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# # plot!(Array(timeRD)',Array(Xv_result_2H2_pc_rd),color=:orange, label = "JEKF-2H2", lw=2.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# plot!(Array(timeRD)',Array(Xv_result_KPH2_pc_rd),color=:green,label = "JEKF-KPH2",  lw=2.5,xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# plot!(legend=:bottomright,size = (650,450))
#
# plot1=plot(Array(timeRD)',Array(GLC_result_SIC_pc_rd),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
# # plot!(Array(timeRD)',Array(GLC_result_1H2_pc_rd),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"GLC(mM)")
# # plot!(Array(timeRD)',Array(GLC_result_2H2_pc_rd),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
# plot!(Array(timeRD)',Array(GLC_result_KPH2_pc_rd),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"GLC(mM)")
# Plots.scatter!([4679-3;6144-3]/60,[22.00943658;17.707466],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
# plot!(legend=:bottomleft)
#
# plot2=plot(Array(timeRD)',Array(LAC_result_SIC_pc_rd),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
# # plot!(Array(timeRD)',Array(LAC_result_1H2_pc_rd),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"LAC(mM)")
# # plot!(Array(timeRD)',Array(LAC_result_2H2_pc_rd),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
# plot!(Array(timeRD)',Array(LAC_result_KPH2_pc_rd),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"LAC(mM)")
# Plots.scatter!([4679-3;6144-3]/60,[9.10352484;11.54593394],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
# plot!(legend=false)
#
# plot3=plot(Array(timeRD)',Array(rAAV_result_SIC_pc_rd),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# # plot!(Array(timeRD)',Array(rAAV_result_1H2_pc_rd),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# # plot!(Array(timeRD)',Array(rAAV_result_2H2_pc_rd),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# plot!(Array(timeRD)',Array(rAAV_result_KPH2_pc_rd),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# Plots.scatter!([3252-3;4679-3;6144-3]/60,[0;3190000000/10^9;7010000000/10^9],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# plot!(legend=false)
#
#
# ar=Array(GLC_result_SIC_pc_rd)
# println("plot2\nRMSE(GLC Ground truth vs SANTO): ",RMSE([ar[1424];ar[2889]],[22.00943658;17.707466]))
# ar=Array(GLC_result_KPH2_pc_rd)
# println("RMSE(GLC Ground truth vs KPH2): ",RMSE([ar[1424];ar[2889]],[22.00943658;17.707466]))
#
# ar=Array(LAC_result_SIC_pc_rd)
# println("RMSE(LAC Ground truth vs SANTO): ",RMSE([ar[1424];ar[2889]],[9.10352484;11.54593394]))
# ar=Array(LAC_result_KPH2_pc_rd)
# println("RMSE(LAC Ground truth vs KPH2): ",RMSE([ar[1424];ar[2889]],[9.10352484;11.54593394]))
#
# ar=Array(rAAV_result_SIC_pc_rd)
# println("RMSE(rAAV Ground truth vs SANTO): ",RMSE([ar[1];ar[1424];ar[2889]],[0;3190000000/10^9;7010000000/10^9]))
# ar=Array(rAAV_result_KPH2_pc_rd)
# println("RMSE(rAAV Ground truth vs KPH2): ",RMSE([ar[1];ar[1424];ar[2889]],[0;3190000000/10^9;7010000000/10^9]))
#
#
#
# plot4=plot(Array(timeRD)',Array(uGLC_result_SIC_pc_rd),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# # plot!(Array(timeRD)',Array(uGLC_result_1H2_pc_rd),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# # plot!(Array(timeRD)',Array(uGLC_result_2H2_pc_rd),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# plot!(Array(timeRD)',Array(uGLC_result_KPH2_pc_rd),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# plot!(legend=false)
#
# plot5=plot(Array(timeRD)',Array(uLAC_result_SIC_pc_rd),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# # plot!(Array(timeRD)',Array(uLAC_result_1H2_pc_rd),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# # plot!(Array(timeRD)',Array(uLAC_result_2H2_pc_rd),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# plot!(Array(timeRD)',Array(uLAC_result_KPH2_pc_rd),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# plot!(legend=false)
#
# plot6=plot(Array(timeRD)',Array(urAAV_result_SIC_pc_rd),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# # plot!(Array(timeRD)',Array(urAAV_result_1H2_pc_rd),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# # plot!(Array(timeRD)',Array(urAAV_result_2H2_pc_rd),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# plot!(Array(timeRD)',Array(urAAV_result_KPH2_pc_rd),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# plot!(legend=false)
#
# pp=plot(plot0,plot1,plot2,plot3,plot4,plot5,plot6, layout=(4,2),size = (800,900))
# savefig(abs_path*"/JEKF-SANTO/results_analyze/figs/real_dt/estimations_RD_Pcorrelated.png")
#
# display(pp)
#
#
#
#
#
#
#
# ## MRDE-PU-----PU and specific P(0)
# println("PU and specific P(0)")
#
# plot0=plot(Array(timeRD)',Array(xv_online_measurement_RD_AAV),color=:lightblue, label = "Xv online (noise)", lw=5.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# plot!(Array(timeRD)',Array(Xv_result_SIC_pu_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=2.5,xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# # plot!(Array(timeRD)',Array(Xv_result_1H2_pu_rd_sp0),color=:black, label = "JEKF-1H2", lw=2.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# # plot!(Array(timeRD)',Array(Xv_result_2H2_pu_rd_sp0),color=:orange, label = "JEKF-2H2", lw=2.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# plot!(Array(timeRD)',Array(Xv_result_KPH2_pu_rd_sp0),color=:green,label = "JEKF-KPH2",  lw=2.5,xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# plot!(legend=:bottomright,size = (650,450))
#
# plot1=plot(Array(timeRD)',Array(GLC_result_SIC_pu_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
# # plot!(Array(timeRD)',Array(GLC_result_1H2_pu_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"GLC(mM)")
# # plot!(Array(timeRD)',Array(GLC_result_2H2_pu_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
# plot!(Array(timeRD)',Array(GLC_result_KPH2_pu_rd_sp0),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"GLC(mM)")
# Plots.scatter!([4679-3;6144-3]/60,[22.00943658;17.707466],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
# plot!(legend=:bottomleft)
#
# plot2=plot(Array(timeRD)',Array(LAC_result_SIC_pu_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
# # plot!(Array(timeRD)',Array(LAC_result_1H2_pu_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"LAC(mM)")
# # plot!(Array(timeRD)',Array(LAC_result_2H2_pu_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
# plot!(Array(timeRD)',Array(LAC_result_KPH2_pu_rd_sp0),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"LAC(mM)")
# Plots.scatter!([4679-3;6144-3]/60,[9.10352484;11.54593394],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
# plot!(legend=false)
#
# plot3=plot(Array(timeRD)',Array(rAAV_result_SIC_pu_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# # plot!(Array(timeRD)',Array(rAAV_result_1H2_pu_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# # plot!(Array(timeRD)',Array(rAAV_result_2H2_pu_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# plot!(Array(timeRD)',Array(rAAV_result_KPH2_pu_rd_sp0),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# Plots.scatter!([3252-3;4679-3;6144-3]/60,[0;3190000000/10^9;7010000000/10^9],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# plot!(legend=false)
#
#
# ar=Array(GLC_result_SIC_pu_rd_sp0)
# println("plot3\nRMSE(GLC Ground truth vs SANTO): ",RMSE([ar[1424];ar[2889]],[22.00943658;17.707466]))
# ar=Array(GLC_result_KPH2_pu_rd_sp0)
# println("RMSE(GLC Ground truth vs KPH2): ",RMSE([ar[1424];ar[2889]],[22.00943658;17.707466]))
#
# ar=Array(LAC_result_SIC_pu_rd_sp0)
# println("RMSE(LAC Ground truth vs SANTO): ",RMSE([ar[1424];ar[2889]],[9.10352484;11.54593394]))
# ar=Array(LAC_result_KPH2_pu_rd_sp0)
# println("RMSE(LAC Ground truth vs KPH2): ",RMSE([ar[1424];ar[2889]],[9.10352484;11.54593394]))
#
# ar=Array(rAAV_result_SIC_pu_rd_sp0)
# println("RMSE(rAAV Ground truth vs SANTO): ",RMSE([ar[1];ar[1424];ar[2889]],[0;3190000000/10^9;7010000000/10^9]))
# ar=Array(rAAV_result_KPH2_pu_rd_sp0)
# println("RMSE(rAAV Ground truth vs KPH2): ",RMSE([ar[1];ar[1424];ar[2889]],[0;3190000000/10^9;7010000000/10^9]))
#
#
#
#
# plot4=plot(Array(timeRD)',Array(uGLC_result_SIC_pu_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# # plot!(Array(timeRD)',Array(uGLC_result_1H2_pu_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# # plot!(Array(timeRD)',Array(uGLC_result_2H2_pu_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# plot!(Array(timeRD)',Array(uGLC_result_KPH2_pu_rd_sp0),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# plot!(legend=false)
#
# plot5=plot(Array(timeRD)',Array(uLAC_result_SIC_pu_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# # plot!(Array(timeRD)',Array(uLAC_result_1H2_pu_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# # plot!(Array(timeRD)',Array(uLAC_result_2H2_pu_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# plot!(Array(timeRD)',Array(uLAC_result_KPH2_pu_rd_sp0),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# plot!(legend=false)
#
# plot6=plot(Array(timeRD)',Array(urAAV_result_SIC_pu_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# # plot!(Array(timeRD)',Array(urAAV_result_1H2_pu_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# # plot!(Array(timeRD)',Array(urAAV_result_2H2_pu_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# plot!(Array(timeRD)',Array(urAAV_result_KPH2_pu_rd_sp0),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# plot!(legend=false)
#
# pp=plot(plot0,plot1,plot2,plot3,plot4,plot5,plot6, layout=(4,2),size = (800,900))
# savefig(abs_path*"/JEKF-SANTO/results_analyze/figs/real_dt/estimations_RD_Puncorrelated_sp0.png")
#
# display(pp)
#
#
# ## MRDE-PC -----PC and specific P(0)
# println("PC and specific P(0)")
#
# plot0=plot(Array(timeRD)',Array(xv_online_measurement_RD_AAV),color=:lightblue, label = "Xv online (noise)", lw=5.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# plot!(Array(timeRD)',Array(Xv_result_SIC_pc_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=2.5,xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# # plot!(Array(timeRD)',Array(Xv_result_1H2_pc_rd_sp0),color=:black, label = "JEKF-1H2", lw=2.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# # plot!(Array(timeRD)',Array(Xv_result_2H2_pc_rd_sp0),color=:orange, label = "JEKF-2H2", lw=2.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# plot!(Array(timeRD)',Array(Xv_result_KPH2_pc_rd_sp0),color=:green,label = "JEKF-KPH2",  lw=2.5,xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# plot!(legend=:bottomright,size = (650,450))
#
# plot1=plot(Array(timeRD)',Array(GLC_result_SIC_pc_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
# # plot!(Array(timeRD)',Array(GLC_result_1H2_pc_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"GLC(mM)")
# # plot!(Array(timeRD)',Array(GLC_result_2H2_pc_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
# plot!(Array(timeRD)',Array(GLC_result_KPH2_pc_rd_sp0),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"GLC(mM)")
# Plots.scatter!([4679-3;6144-3]/60,[22.00943658;17.707466],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
# plot!(legend=:bottomleft)
#
# plot2=plot(Array(timeRD)',Array(LAC_result_SIC_pc_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
# # plot!(Array(timeRD)',Array(LAC_result_1H2_pc_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"LAC(mM)")
# # plot!(Array(timeRD)',Array(LAC_result_2H2_pc_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
# plot!(Array(timeRD)',Array(LAC_result_KPH2_pc_rd_sp0),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"LAC(mM)")
# Plots.scatter!([4679-3;6144-3]/60,[9.10352484;11.54593394],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
# plot!(legend=false)
#
# plot3=plot(Array(timeRD)',Array(rAAV_result_SIC_pc_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# # plot!(Array(timeRD)',Array(rAAV_result_1H2_pc_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# # plot!(Array(timeRD)',Array(rAAV_result_2H2_pc_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# plot!(Array(timeRD)',Array(rAAV_result_KPH2_pc_rd_sp0),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# Plots.scatter!([3252-3;4679-3;6144-3]/60,[0;3190000000/10^9;7010000000/10^9],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# plot!(legend=false)
#
#
# ar=Array(GLC_result_SIC_pc_rd_sp0)
# println("plot4\nRMSE(GLC Ground truth vs SANTO): ",RMSE([ar[1424];ar[2889]],[22.00943658;17.707466]))
# ar=Array(GLC_result_KPH2_pc_rd_sp0)
# println("RMSE(GLC Ground truth vs KPH2): ",RMSE([ar[1424];ar[2889]],[22.00943658;17.707466]))
#
# ar=Array(LAC_result_SIC_pc_rd_sp0)
# println("RMSE(LAC Ground truth vs SANTO): ",RMSE([ar[1424];ar[2889]],[9.10352484;11.54593394]))
# ar=Array(LAC_result_KPH2_pc_rd_sp0)
# println("RMSE(LAC Ground truth vs KPH2): ",RMSE([ar[1424];ar[2889]],[9.10352484;11.54593394]))
#
# ar=Array(rAAV_result_SIC_pc_rd_sp0)
# println("RMSE(rAAV Ground truth vs SANTO): ",RMSE([ar[1];ar[1424];ar[2889]],[0;3190000000/10^9;7010000000/10^9]))
# ar=Array(rAAV_result_KPH2_pc_rd_sp0)
# println("RMSE(rAAV Ground truth vs KPH2): ",RMSE([ar[1];ar[1424];ar[2889]],[0;3190000000/10^9;7010000000/10^9]))
#
#
#
# plot4=plot(Array(timeRD)',Array(uGLC_result_SIC_pc_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# # plot!(Array(timeRD)',Array(uGLC_result_1H2_pc_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# # plot!(Array(timeRD)',Array(uGLC_result_2H2_pc_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# plot!(Array(timeRD)',Array(uGLC_result_KPH2_pc_rd_sp0),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# plot!(legend=false)
#
# plot5=plot(Array(timeRD)',Array(uLAC_result_SIC_pc_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# # plot!(Array(timeRD)',Array(uLAC_result_1H2_pc_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# # plot!(Array(timeRD)',Array(uLAC_result_2H2_pc_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# plot!(Array(timeRD)',Array(uLAC_result_KPH2_pc_rd_sp0),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# plot!(legend=false)
#
# plot6=plot(Array(timeRD)',Array(urAAV_result_SIC_pc_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# # plot!(Array(timeRD)',Array(urAAV_result_1H2_pc_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# # plot!(Array(timeRD)',Array(urAAV_result_2H2_pc_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# plot!(Array(timeRD)',Array(urAAV_result_KPH2_pc_rd_sp0),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# plot!(legend=false)
#
# pp=plot(plot0,plot1,plot2,plot3,plot4,plot5,plot6, layout=(4,2),size = (800,900))
# savefig(abs_path*"/JEKF-SANTO/results_analyze/figs/real_dt/estimations_RD_Pcorrelated_sp0.png")
#
# display(pp)
#
#
#
#
# #
# #
# #
# #
# # plot0=plot(Array(timeRD)',Array(xv_online_measurement_RD_AAV),color=:lightblue, label = "Xv online (noise)", lw=5.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# # plot!(Array(timeRD)',Array(Xv_result_KPH2_pc_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=2.5,xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# # plot!(legend=:bottomright,size = (650,450))
# #
# # plot1=
# # plot(Array(timeRD)',Array(GLC_result_KPH2_pc_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"GLC(mM)")
# # Plots.scatter!([4679-3;6144-3]/60,[22.00943658;17.707466],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
# # plot!(legend=:bottomleft)
# #
# # plot2=
# # plot(Array(timeRD)',Array(LAC_result_KPH2_pc_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"LAC(mM)")
# # Plots.scatter!([4679-3;6144-3]/60,[9.10352484;11.54593394],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
# # plot!(legend=false)
# #
# # plot3=
# # plot(Array(timeRD)',Array(rAAV_result_KPH2_pc_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# # Plots.scatter!([3252-3;4679-3;6144-3]/60,[0;3190000000/10^9;7010000000/10^9],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# # plot!(legend=false)
# #
# # plot4=
# # plot(Array(timeRD)',Array(uGLC_result_KPH2_pc_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# # plot!(legend=false)
# #
# # plot5=
# # plot(Array(timeRD)',Array(uLAC_result_KPH2_pc_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# # plot!(legend=false)
# #
# # plot6=
# # plot(Array(timeRD)',Array(urAAV_result_KPH2_pc_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# # plot!(legend=false)
# #
# # pp=plot(plot0,plot1,plot2,plot3,plot4,plot5,plot6, layout=(4,2),size = (800,900))
# # savefig(abs_path*"/JEKF-SANTO/results_analyze/figs/real_dt/estimations_RD_KPH2_Pcorrelated_sp0.png")
# #
# # display(pp)
# #
# #
# #
# #
# #
# # plot0=plot(Array(timeRD)',Array(xv_online_measurement_RD_AAV),color=:lightblue, label = "Xv online (noise)", lw=5.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# # plot!(Array(timeRD)',Array(Xv_result_KPH2_pu_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=2.5,xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# # plot!(legend=:bottomright,size = (650,450))
# #
# # plot1=
# # plot(Array(timeRD)',Array(GLC_result_KPH2_pu_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"GLC(mM)")
# # Plots.scatter!([4679-3;6144-3]/60,[22.00943658;17.707466],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
# # plot!(legend=:bottomleft)
# #
# # plot2=
# # plot(Array(timeRD)',Array(LAC_result_KPH2_pu_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"LAC(mM)")
# # Plots.scatter!([4679-3;6144-3]/60,[9.10352484;11.54593394],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
# # plot!(legend=false)
# #
# # plot3=
# # plot(Array(timeRD)',Array(rAAV_result_KPH2_pu_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# # Plots.scatter!([3252-3;4679-3;6144-3]/60,[0;3190000000/10^9;7010000000/10^9],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# # plot!(legend=false)
# #
# # plot4=
# # plot(Array(timeRD)',Array(uGLC_result_KPH2_pu_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# # plot!(legend=false)
# #
# # plot5=
# # plot(Array(timeRD)',Array(uLAC_result_KPH2_pu_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# # plot!(legend=false)
# #
# # plot6=
# # plot(Array(timeRD)',Array(urAAV_result_KPH2_pu_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# # plot!(legend=false)
# #
# # pp=plot(plot0,plot1,plot2,plot3,plot4,plot5,plot6, layout=(4,2),size = (800,900))
# # savefig(abs_path*"/JEKF-SANTO/results_analyze/figs/real_dt/estimations_RD_KPH2_Puncorrelated_sp0.png")
# #
# # display(pp)
# #
# #
#
#
#
#
#
#
#
#
#
#
#
# ## MRDE-PU-----PU and specific P(0) and Q
# println("PU and specific P(0) and Q")
#
# plot0=plot(Array(timeRD)',Array(xv_online_measurement_RD_AAV),color=:lightblue, label = "Xv online (noise)", lw=5.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# plot!(Array(timeRD)',Array(Xv_result_SIC_pu_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=2.5,xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# # plot!(Array(timeRD)',Array(Xv_result_1H2_pu_rd_sp0),color=:black, label = "JEKF-1H2", lw=2.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# # plot!(Array(timeRD)',Array(Xv_result_2H2_pu_rd_sp0),color=:orange, label = "JEKF-2H2", lw=2.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# plot!(Array(timeRD)',Array(Xv_result_KPH2_pu_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=2.5,xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# plot!(legend=:bottomright,size = (650,450))
#
# plot1=plot(Array(timeRD)',Array(GLC_result_SIC_pu_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
# # plot!(Array(timeRD)',Array(GLC_result_1H2_pu_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"GLC(mM)")
# # plot!(Array(timeRD)',Array(GLC_result_2H2_pu_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
# plot!(Array(timeRD)',Array(GLC_result_KPH2_pu_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"GLC(mM)")
# Plots.scatter!([4679-3;6144-3]/60,[22.00943658;17.707466],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
# plot!(legend=:bottomleft)
#
# plot2=plot(Array(timeRD)',Array(LAC_result_SIC_pu_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
# # plot!(Array(timeRD)',Array(LAC_result_1H2_pu_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"LAC(mM)")
# # plot!(Array(timeRD)',Array(LAC_result_2H2_pu_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
# plot!(Array(timeRD)',Array(LAC_result_KPH2_pu_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"LAC(mM)")
# Plots.scatter!([4679-3;6144-3]/60,[9.10352484;11.54593394],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
# plot!(legend=false)
#
# plot3=plot(Array(timeRD)',Array(rAAV_result_SIC_pu_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# # plot!(Array(timeRD)',Array(rAAV_result_1H2_pu_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# # plot!(Array(timeRD)',Array(rAAV_result_2H2_pu_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# plot!(Array(timeRD)',Array(rAAV_result_KPH2_pu_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# Plots.scatter!([3252-3;4679-3;6144-3]/60,[0;3190000000/10^9;7010000000/10^9],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# plot!(legend=false)
#
#
# ar=Array(GLC_result_SIC_pu_rd_sp0)
# println("plot5\nRMSE(GLC Ground truth vs SANTO): ",RMSE([ar[1424];ar[2889]],[22.00943658;17.707466]))
# ar=Array(GLC_result_KPH2_pu_rd_sp0_2)
# println("RMSE(GLC Ground truth vs KPH2): ",RMSE([ar[1424];ar[2889]],[22.00943658;17.707466]))
#
# ar=Array(LAC_result_SIC_pu_rd_sp0)
# println("RMSE(LAC Ground truth vs SANTO): ",RMSE([ar[1424];ar[2889]],[9.10352484;11.54593394]))
# ar=Array(LAC_result_KPH2_pu_rd_sp0_2)
# println("RMSE(LAC Ground truth vs KPH2): ",RMSE([ar[1424];ar[2889]],[9.10352484;11.54593394]))
#
# ar=Array(rAAV_result_SIC_pu_rd_sp0)
# println("RMSE(rAAV Ground truth vs SANTO): ",RMSE([ar[1];ar[1424];ar[2889]],[0;3190000000/10^9;7010000000/10^9]))
# ar=Array(rAAV_result_KPH2_pu_rd_sp0_2)
# println("RMSE(rAAV Ground truth vs KPH2): ",RMSE([ar[1];ar[1424];ar[2889]],[0;3190000000/10^9;7010000000/10^9]))
#
#
#
#
#
#
#
# plot4=plot(Array(timeRD)',Array(uGLC_result_SIC_pu_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# # plot!(Array(timeRD)',Array(uGLC_result_1H2_pu_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# # plot!(Array(timeRD)',Array(uGLC_result_2H2_pu_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# plot!(Array(timeRD)',Array(uGLC_result_KPH2_pu_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# plot!(legend=false)
#
# plot5=plot(Array(timeRD)',Array(uLAC_result_SIC_pu_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# # plot!(Array(timeRD)',Array(uLAC_result_1H2_pu_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# # plot!(Array(timeRD)',Array(uLAC_result_2H2_pu_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# plot!(Array(timeRD)',Array(uLAC_result_KPH2_pu_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# plot!(legend=false)
#
# plot6=plot(Array(timeRD)',Array(urAAV_result_SIC_pu_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# # plot!(Array(timeRD)',Array(urAAV_result_1H2_pu_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# # plot!(Array(timeRD)',Array(urAAV_result_2H2_pu_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# plot!(Array(timeRD)',Array(urAAV_result_KPH2_pu_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# plot!(legend=false)
#
# pp=plot(plot0,plot1,plot2,plot3,plot4,plot5,plot6, layout=(4,2),size = (800,900))
# savefig(abs_path*"/JEKF-SANTO/results_analyze/figs/real_dt/estimations_RD_KPH2_Puncorrelated_sp0.png")
#
# display(pp)
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
# ## MRDE-PC-----PC and specific P(0) and Q
#
# println("PC and specific P(0) and Q")
#
# plot0=plot(Array(timeRD)',Array(xv_online_measurement_RD_AAV),color=:lightblue, label = "Xv online (noise)", lw=5.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# plot!(Array(timeRD)',Array(Xv_result_SIC_pc_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=2.5,xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# # plot!(Array(timeRD)',Array(Xv_result_1H2_pc_rd_sp0),color=:black, label = "JEKF-1H2", lw=2.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# # plot!(Array(timeRD)',Array(Xv_result_2H2_pc_rd_sp0),color=:orange, label = "JEKF-2H2", lw=2.5, xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# plot!(Array(timeRD)',Array(Xv_result_KPH2_pc_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=2.5,xlabel=L"time(h)",ylabel=L"Xv(   10^6 cells/mL)")
# plot!(legend=:bottomright,size = (650,450))
#
# plot1=plot(Array(timeRD)',Array(GLC_result_SIC_pc_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
# # plot!(Array(timeRD)',Array(GLC_result_1H2_pc_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"GLC(mM)")
# # plot!(Array(timeRD)',Array(GLC_result_2H2_pc_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
# plot!(Array(timeRD)',Array(GLC_result_KPH2_pc_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"GLC(mM)")
# Plots.scatter!([4679-3;6144-3]/60,[22.00943658;17.707466],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"GLC(mM)")
# plot!(legend=:bottomleft)
#
# plot2=plot(Array(timeRD)',Array(LAC_result_SIC_pc_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
# # plot!(Array(timeRD)',Array(LAC_result_1H2_pc_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"LAC(mM)")
# # plot!(Array(timeRD)',Array(LAC_result_2H2_pc_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
# plot!(Array(timeRD)',Array(LAC_result_KPH2_pc_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"LAC(mM)")
# Plots.scatter!([4679-3;6144-3]/60,[9.10352484;11.54593394],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"LAC(mM)")
# plot!(legend=false)
#
# plot3=plot(Array(timeRD)',Array(rAAV_result_SIC_pc_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# # plot!(Array(timeRD)',Array(rAAV_result_1H2_pc_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# # plot!(Array(timeRD)',Array(rAAV_result_2H2_pc_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# plot!(Array(timeRD)',Array(rAAV_result_KPH2_pc_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# Plots.scatter!([3252-3;4679-3;6144-3]/60,[0;3190000000/10^9;7010000000/10^9],color=:red, label = "Ground truth", ls=:dot ,lw=5.5, xlabel=L"time(h)",ylabel=L"rAAV (VG/mL)")
# plot!(legend=false)
#
#
# ar=Array(GLC_result_SIC_pc_rd_sp0)
# println("plot6\nRMSE(GLC Ground truth vs SANTO): ",RMSE([ar[1424];ar[2889]],[22.00943658;17.707466]))
# ar=Array(GLC_result_KPH2_pc_rd_sp0_2)
# println("RMSE(GLC Ground truth vs KPH2): ",RMSE([ar[1424];ar[2889]],[22.00943658;17.707466]))
#
# ar=Array(LAC_result_SIC_pc_rd_sp0)
# println("RMSE(LAC Ground truth vs SANTO): ",RMSE([ar[1424];ar[2889]],[9.10352484;11.54593394]))
# ar=Array(LAC_result_KPH2_pc_rd_sp0_2)
# println("RMSE(LAC Ground truth vs KPH2): ",RMSE([ar[1424];ar[2889]],[9.10352484;11.54593394]))
#
# ar=Array(rAAV_result_SIC_pc_rd_sp0)
# println("RMSE(rAAV Ground truth vs SANTO): ",RMSE([ar[1];ar[1424];ar[2889]],[0;3190000000/10^9;7010000000/10^9]))
# ar=Array(rAAV_result_KPH2_pc_rd_sp0_2)
# println("RMSE(rAAV Ground truth vs KPH2): ",RMSE([ar[1];ar[1424];ar[2889]],[0;3190000000/10^9;7010000000/10^9]))
#
#
#
#
#
#
# plot4=plot(Array(timeRD)',Array(uGLC_result_SIC_pc_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# # plot!(Array(timeRD)',Array(uGLC_result_1H2_pc_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# # plot!(Array(timeRD)',Array(uGLC_result_2H2_pc_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# plot!(Array(timeRD)',Array(uGLC_result_KPH2_pc_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{GLC}(mmol10^{-6}c~h^-)")
# plot!(legend=false)
#
# plot5=plot(Array(timeRD)',Array(uLAC_result_SIC_pc_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# # plot!(Array(timeRD)',Array(uLAC_result_1H2_pc_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# # plot!(Array(timeRD)',Array(uLAC_result_2H2_pc_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# plot!(Array(timeRD)',Array(uLAC_result_KPH2_pc_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{LAC}(mmol10^{-6}c~h^-)")
# plot!(legend=false)
#
# plot6=plot(Array(timeRD)',Array(urAAV_result_SIC_pc_rd_sp0),color=:blue, label = "JEKF-SANTO", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# # plot!(Array(timeRD)',Array(urAAV_result_1H2_pc_rd_sp0),color=:black, label = "JEKF-1H2", lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# # plot!(Array(timeRD)',Array(urAAV_result_2H2_pc_rd_sp0),color=:orange, label = "JEKF-2H2", lw=3.5, xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# plot!(Array(timeRD)',Array(urAAV_result_KPH2_pc_rd_sp0_2),color=:green,label = "JEKF-KPH2",  lw=3.5,xlabel=L"time(h)",ylabel=L"\mu{rAAV}(10^{9} vg/mL~c~h^6)")
# plot!(legend=false)
#
# pp=plot(plot0,plot1,plot2,plot3,plot4,plot5,plot6, layout=(4,2),size = (800,900))
# savefig(abs_path*"/JEKF-SANTO/results_analyze/figs/real_dt/estimations_RD_KPH2_Pcorrelated_sp0.png")
#
# display(pp)
#
#
#
# # index_GLC=[1424,2889]
# # index_LAC=[1424,2889]
# # index_rAAV=[1,1424,2889]
#
#
#
#
# #
# # println("synthentic_dataset")
# # println("PC ")
# # println("RMSE true mAb vs JEKF: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_EKF_fail_pc)))
# # println("RMSE true mAb vs SIC: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_SIC_pc)))
# # println("RMSE true mAb vs 1H2: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_1H2_pc)))
# # println("RMSE true mAb vs 2H2: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_2H2_pc)))
# # println("RMSE true mAb vs KPH2: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_KPH2_pc)))
# # println("PU ")
# # println("RMSE true mAb vs JEKF: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_EKF_fail_pu)))
# # println("RMSE true mAb vs SIC: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_SIC_pu)))
# # println("RMSE true mAb vs 1H2: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_1H2_pu)))
# # println("RMSE true mAb vs 2H2: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_2H2_pu)))
# # println("RMSE true mAb vs KPH2: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_KPH2_pu)))
# #
# #
# # println("PC sp0")
# # println("RMSE true mAb vs 1H2: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_1H2_pc_sp0)))
# # println("RMSE true mAb vs 2H2: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_2H2_pc_sp0)))
# # println("RMSE true mAb vs KPH2: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_KPH2_pc_sp0)))
# # println("PU sp0")
# # println("RMSE true mAb vs 1H2: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_1H2_pu_sp0)))
# # println("RMSE true mAb vs 2H2: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_2H2_pu_sp0)))
# # println("RMSE true mAb vs KPH2: ",RMSE(Array(mAb_True_syntetic_data_based_on_run41)[2:end],Array(mAb_result_KPH2_pu_sp0)))
# #
# #
# #
# # println("Real_dataset")
#
#
#
#
#
#
# #
# #
# #
# # atime=Array(timeRD)'
# # open("timeRD.txt", "w") do f
# #   for i in atime
# #     println(f, i)
# #   end
# # end
