using DifferentialEquations, DiffEqFlux, Plots
using XLSX, DataFrames, Optim, BlackBoxOptim,DiffEqParamEstim
using GalacticOptim
using DelimitedFiles
using Noise
using Turing, StatsPlots, Random
using CSV

gr();
data_train=[]
tgrid_dt=[]




# Experiment No.	Time [h]	Xv [10ˆ6 Cells/mL]	GLC [mM]	GLN[mM]	NH4 [mM]	LAC [mM]	Titer [mg/L]	pH	T [º C]	Feed - GLC [mM]	Feed - GLN [mM]
#
# 41	0	0.2	60	8	0.1	0.1	0	7.1	37.5	0	0
# 41	24	0.811403238	60.06243891	6.324187332	2.078699362	1.958842417	0	7.1	37.5	5	1
# 41	48	2.188174482	70.10686846	6.299721736	3.238189837	15.40156493	26.03249129	7.1	37.5	5	1
# 41	72	3.76995564	88.02169791	4.561300503	5.974760475	36.77705866	59.09761832	7.1	37.5	5	1
# 41	96	4.493805754	69.91560004	2.891713127	8.484818783	58.81635029	161.378951	7.1	37.5	5	1
# 41	120	5.553648585	52.03324669	1.379978313	6.99091414	73.35478269	197.8538318	7.1	37.5	5	1
# 41	144	7.116577485	38.25872381	0.799808862	11.06948568	101.6878188	352.2600463	7	35	5	1
# 41	168	4.242134172	22.86082257	1.243243382	9.797079848	103.0214983	525.5522513	7	35	5	1
# 41	192	4.553645378	26.62883138	1.972260071	8.560733952	97.56604237	679.7191398	7	35	5	1
# 41	216	4.374959445	27.12317178	2.247043248	10.14151241	98.00416862	584.7679404	7	35	5	1
# 41	240	3.487412985	26.27391667	2.15312126	10.10519455	103.537939	1017.868295	7	35	5	1
# 41	264	2.443729352	17.82174123	2.277458843	12.37351261	117.4292059	801.8871137	7	35	5	1
# 41	288	3.039915884	13.49001384	3.346921943	10.59811464	115.1320779	1120.401286	7	35	5	1
# 41	312	2.63012191	20.08396644	2.747475224	9.396076848	176.635261	1137.563769	7	35	0	0
# 41	336	2.631382428	16.57357113	2.041168266	12.41202344	83.54509488	930.9233752	7	35	0	0
#
# 91	0	0.2	60	8	0.1	0.1	0	7.1	36	0	0
# 91	24	0.423186032	48.2629411	6.125537785	2.037563392	2.607773531	0	7.1	36	0	0
# 91	48	0.776259499	38.32501185	5.165377153	1.93276519	5.259953832	7.445985324	7.1	36	0	0
# 91	72	0.843199982	38.15871046	3.168092194	3.474152199	10.09826862	43.67506173	7.1	36	5	1
# 91	96	1.477195514	25.79742358	2.913674767	5.352952788	22.82488719	54.69410694	7.1	36	5	1
# 91	120	2.481298158	32.45389489	3.616843235	7.990571291	25.76960225	90.69374706	7.1	36	5	1
# 91	144	2.026525346	37.45899908	2.607138616	5.543880395	41.39420218	164.1542046	6.7	36	5	1
# 91	168	3.056002942	38.96502481	2.33865242	8.15986808	25.3283414	266.3386248	6.7	36	5	1
# 91	192	2.467507931	36.26050149	2.708271729	7.096202356	37.54054712	319.9230869	6.7	36	0	0
# 91	216	2.216350085	30.16383281	2.283832315	7.705630677	52.16966407	450.5282903	6.7	36	0	0
# 91	240	2.30221067	24.50479955	2.191874206	6.095666272	66.90948414	480.1609034	6.7	36	0	0
# 91	264	2.220481834	26.73733187	1.535051807	8.583729706	73.02765287	551.0496459	6.7	36	0	0
# 91	288	2.670388638	19.52080722	1.238335854	7.134508935	72.75990408	576.2880628	6.7	36	0	0
# 91	312	1.45525158	18.96553555	0.892471222	8.772600583	57.71014516	585.2818312	6.7	36	0	0
# 91	336	2.062129809	14.05292403	0.498352495	6.66562606	84.08515175	671.0508408	6.7	35	0	0





## All runs of syntetic (In silico) dataset from the paper - Hybrid‐EKF: Hybrid model coupled with extended Kalman filter for real‐time monitoring and control of mammalian cell culture
# for i=[24,41,97 ,91, 17, 30]
#     df = DataFrame(XLSX.readtable(dirname(Base.source_path())*"/bit27437-sup-0001-si_experiments.xlsx", "Sheet1"))
#     n=i
#     dataset_exp1=df[1+(15*n-15):(15*n),3:8]
#     data_train=Array(dataset_exp1)
#     data_train=convert(Array{Float64,2}, data_train)
#     data_train=transpose(data_train)
#     tgrid_dt=df[1:15,2]
#     pdim=(1200,500)
#     # plots=Plots.scatter(tgrid,dtest,color=[:red  :red :red :red :red :red], label = ["[Xv] Offline Bioreactor1"  "[GLC] Offline Bioreactor1" "[GLN] Offline Bioreactor1" "[LAC] Offline Bioreactor1" "[AMM] Offline Bioreactor1" "[AAV] Offline Bioreactor1"], ylabel=["[Xv]"  "[GLC]" "[GLN]" "[LAC]" "[AMM]" "[AAV]"],layout=(2,3),pdim )
#     # plots=Plots.scatter(tgrid_dt,transpose(data_train), label = false, ylabel=["[Xv]"  "[GLC]" "[GLN]" "[LAC]" "[AMM]" "[AAV]"],layout=(2,3) )
#     #
#     # # plots=plot(sol.t,transpose(sol),color=[:red  :red :red :red :red :red], lw=1.5, label = ["[Xv] Bioreactor1 MM"  "[GLC] Bioreactor1 MM" "[GLN] Bioreactor1 MM" "[LAC] Bioreactor1 MM" "[AMM] Bioreactor1 MM" "[AAV] Bioreactor1 MM" ], ylabel=["[Xv]"  "[GLC]" "[GLN]" "[LAC]" "[AMM]" "[AAV]"], layout=(2,3),size =pdim)
#     # display(plots)
#
#     title = plot(title = string(i), grid = false, showaxis = false, bottom_margin = -50Plots.px,legendfont=font(10))
#     p1=Plots.scatter(tgrid_dt,transpose(data_train), label = false, ylabel=["[Xv]"  "[GLC]" "[GLN]" "[LAC]" "[AMM]" "[AAV]"],layout=(2,3) )
#     plots=plot(title, p1,layout = @layout([A{0.01h}; grid(1,1)]))
#     display(plots)
# end


df = DataFrame(XLSX.readtable(dirname(Base.source_path())*"/bit27437-sup-0001-si_experiments.xlsx", "Sheet1"))
n=41#24#41
dataset_exp1=df[1+(15*n-15):(15*n),3:8]
data_train=Array(dataset_exp1)
data_train=convert(Array{Float64,2}, data_train)
data_train=transpose(data_train)
tgrid_dt=df[1:15,2]
pdim=(1200,500)
plots=Plots.scatter(tgrid_dt,transpose(data_train), label = false, ylabel=["[Xv]"  "[GLC]" "[GLN]" "[LAC]" "[AMM]" "[mAb]"],layout=(2,3) )

# ODE system for mAb production used in "Accelerating Biologics Manufacturing by Upstream Process Modelling (2019)"
function ode_system!(du, u, p, t)
    Xv, GLC, GLN, LAC, AMM, mAb = u
    μmax,kglc,kgln,kilac,kiamm,kd,kdlac,kdamm,a1,a2,Yxv_glc,mglc,Yxv_gln,Ylac_glc,Yamm_gln,ramm,QmAb = p

    μ=μmax*(GLC/(kglc+GLC))*(GLN/(kgln+GLN))*(kilac/(kilac+LAC))*(kiamm/(kiamm+AMM))
    μd=kd*(LAC/(kdlac+LAC))*(AMM/(kdamm+AMM))
    mgln=(a1*GLN)/(a2+GLN)
    du[1] = (μ-μd)*Xv  #dXv
    du[2] = -(((μ-μd)/Yxv_glc) + mglc)*Xv #dGLC
    du[3] = -(((μ-μd)/Yxv_gln) + mgln)*Xv #dGLN
    du[4] =  Ylac_glc*((μ-μd)/Yxv_glc)*Xv #dLAC
    du[5] = Yamm_gln*((μ-μd)/Yxv_gln)*Xv-ramm*Xv #dAMM
    du[6] = QmAb*Xv #dmAb
end

u0 = [0.2    ,   60.0 ,    8.0    ,    0.1     ,   0.1   ,      0.0] #initial condition of RUN 41
# u0 = [ 0.4    ,  20.0 ,   8.0 ,       0.1  ,      0.1  ,      0.0] #initial condition of RUN 24

tstart=0.0
tend=336.0
sampling= 24.0
tgrid=tstart:sampling:tend

# p=[μmax,kglc,kgln,kilac,kiamm,kd    ,kdlac,kdamm ,a1,a2  ,Yxv_glc,mglc,Yxv_gln,Ylac_glc,Yamm_gln,ramm,QmAb]
#parameters from the paper that use the ODE system that I am using in this script
# p=[0.029,0.15,0.04,45.0  ,9.5  ,0.0066,40.0,4.0    ,3.2,2.1,0.413,69.2, 0.573   ,1.391   ,0.739,6.3,2.25]
#parameters for run 41
p = [0.3500000000047384, 0.19999999977305788, 0.01999999995894285, 3.727137010196651, 11.500000000380524, 0.07000000000013726, 44.99999999869456, 12.999999999268605, 0.009999999979506579, 5.000000009971098, 3.9999999999901883, 0.036999999999992705, 1.669230945816793, 9.000000000082299, 40.10000019066239, 2.5389948882942365e-13, 0.8999999999958256]

prob =  ODEProblem(ode_system!, u0, (tstart,tend), p)
sol = solve(prob, AutoTsit5(Rosenbrock23()),saveat=tgrid)
plots=Plots.scatter(tgrid_dt,transpose(data_train), label = false, ylabel=["[Xv]"  "[GLC]" "[GLN]" "[LAC]" "[AMM]" "[mAb]"],layout=(2,3) )
plot!(sol.t,transpose(sol),color=[:red  :red :red :red :red :red], lw=1.5, label = false, ylabel=["[Xv]"  "[GLC]" "[GLN]" "[LAC]" "[AMM]" "[mAb]"], layout=(2,3))
display(plots)





#GOOD option2 for run 41
bounds = Tuple{Float64, Float64}[
(0.35,0.45),       #μmax   0.029
(0.01,.2),          #kglc   0.15
(0.01,.02),           #kgln   0.04
(3.0,6.),           #kilac  45.0
(11.5,15.0),         #kiamm  9.5
(0.07,0.566),    #kd    0.0066
(20.0,45.0),        #kdlac  40.0
(10.,13.),           #kdamm  4.0
(0.005,0.01),        #a1     3.2
(5.0,5.8),          #a2     2.1
(1.1,4.0),           #Yxv_glc 0.413
(0.01,0.037),          #mglc   69.2
(1.,2.0),           #Yxv_gln 0.573
(9.0,10.0),       #Ylac_glc  1.391
(40.1,40.42),           #Yamm_gln  0.739
(0.0,0.0000001),         #ramm   6.3
(.05,.9)         #QmAb   2.25
]



#GOOD option2 for run 41
bounds = Tuple{Float64, Float64}[
(0.35,0.45),       #μmax   0.029
(0.01,.2),          #kglc   0.15
(0.01,.02),           #kgln   0.04
(3.0,6.),           #kilac  45.0
(11.5,15.0),         #kiamm  9.5
(0.07,0.566),    #kd    0.0066
(20.0,45.0),        #kdlac  40.0
(10.,13.),           #kdamm  4.0
(0.005,0.01),        #a1     3.2
(5.0,5.8),          #a2     2.1
(1.1,4.0),           #Yxv_glc 0.413
(0.01,0.037),          #mglc   69.2
(1.,2.0),           #Yxv_gln 0.573
(9.0,10.0),       #Ylac_glc  1.391
(40.1,40.42),           #Yamm_gln  0.739
(0.0,0.0000001),         #ramm   6.3
(.05,1.9)         #QmAb   2.25
]

## NODE for parameters estimation of UMKM with run 41
counter=0
loss_over_step=[]
l_old=0.005
function cost(p)
  global counter=counter+1
  probdef = ODEProblem(ode_system!, u0, (tstart,tend), p)
  sol = solve(probdef, AutoTsit5(Rosenbrock23()), saveat = tgrid)
  # display(sol.u)

  if size(sol.u)[1] == 15
      l=sum(abs2, sol.-data_train)
      global l_old=l
  else
      l=l_old+0000000.1
      display(l_old)
  end
  # display(l)
  push!(loss_over_step,l)
  if counter%1000==0

    title = plot(title = string(counter), grid = false, showaxis = false, bottom_margin = -50Plots.px,legendfont=font(10))
    p1=Plots.scatter(tgrid_dt,transpose(data_train), label = false, ylabel=["[Xv]"  "[GLC]" "[GLN]" "[LAC]" "[AMM]" "[AAV]"],layout=(2,3) )
    plot!(sol.t,transpose(sol),color=[:red  :red :red :red :red :red], lw=1.5, label = false, ylabel=["[Xv]"  "[GLC]" "[GLN]" "[LAC]" "[AMM]" "[mAb]"], layout=(2,3))
    plots=plot(title, p1,layout = @layout([A{0.01h}; grid(1,1)]))
    display(plots)


    println("Loss:  ",l, "  epoch counter: ",counter,"    Parameters:",p)
    pnames=["μmax","kglc","kgln","kilac","kiamm","kd","kdlac","kdamm","a1","a2","Yxv_glc","mglc","Yxv_gln","Ylac_glc","Yamm_gln","ramm","QmAb"]
    for i in 1:17
        println(pnames[i]," = ", round(p[i], digits=4) )
    end
  end
  return l
end

result = bboptimize(cost;SearchRange = bounds, MaxSteps = 1000000, Method = :adaptive_de_rand_1_bin_radiuslimited)

p = result.archive_output.best_candidate
#
# #plot the ODE system with optimazed parameters
# #best parameters for run 41

p= [0.35, 0.2, 0.02, 3.0, 11.5, 0.07, 45.0, 13.0, 0.01, 5.0, 4.0, 0.037, 1.47864, 9.0, 40.1, 1.22174e-13, 1.00487]

# p =  [0.3500000000018143,
#   0.19999999945296218,
#   0.01999999998750423,
#   3.727145529338013,
#  11.500000000011484,
#   0.07000000000000003,
#  44.99999999999999,
#  12.99999999974547,
#   0.009999999998920579,
#   5.00000000013392,
#   3.9999999999958984,
#   0.03699999999999961,
#   1.6692292443034908,
#   9.000000000051596,
#  40.10000017750236,
#   2.3863630840060696e-13,
#   0.9004412179440505]#0.899999999999832]
#



## creating the in syhthetic online Xv
tstart=0.0
tend=336.0 #hours
sampling= 3/60 #sampling every 3 min to Generate a total of 6720.0 =336/(3/60)samples
tgrid=tstart:sampling:tend


prob =  ODEProblem(ode_system!, u0, (tstart,tend), p)
sol = solve(prob, AutoTsit5(Rosenbrock23()),saveat=tgrid)
plots=Plots.scatter(tgrid_dt,transpose(data_train), label = false, ylabel=["[Xv]"  "[GLC]" "[GLN]" "[LAC]" "[AMM]" "[mAb]"],layout=(2,3) )
# Plots.scatter!(sol.t,add_gauss(transpose(sol)[:,1],0.5), label = false, ylabel=["[Xv]"  "[GLC]" "[GLN]" "[LAC]" "[AMM]" "[AAV]"],layout=(2,3) )
plot!(sol.t,add_gauss(transpose(sol)[:,1],0.05), label = false, ylabel=["[Xv]"  "[GLC]" "[GLN]" "[LAC]" "[AMM]" "[mAb]"],layout=(2,3) )
plot!(sol.t,transpose(sol),color=[:red  :red :red :red :red :red], lw=1.5, label = false, ylabel=["[Xv]"  "[GLC]" "[GLN]" "[LAC]" "[AMM]" "[mAb]"], layout=(2,3))
display(plots)

# saving to CSV the Xv with three different noise 0.03, 0.05 and 0.5
# writedlm("time_h_of_Xv_syntetic_data_with_gaussian_noises.csv",sol.t,",")
# writedlm("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Xv_syntetic_data_run41_with_gaussian_noise_0.03.csv",add_gauss(transpose(sol)[:,1],0.03),",")
# writedlm("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Xv_syntetic_data_run41_with_gaussian_noise_0.05.csv",add_gauss(transpose(sol)[:,1],0.05),",")
# writedlm("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Xv_syntetic_data_run41_with_gaussian_noise_0.5.csv",add_gauss(transpose(sol)[:,1],0.5),",")

# writedlm("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Evaluation_with_synthetic_data/Xv_syntetic_data_run41_ground_truth.csv",transpose(sol)[:,1],",")


# #reading from CSV
# # CSV.read("Xv_syntetic_data_with_gaussian_noise_0.03.csv",DataFrame)
#
# #measurement errors regards Xv 0.03, 0.05, 0.5
# # std(add_gauss(transpose(sol)[:,1],0.5) - transpose(sol)[:,1])

# writedlm("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/mAb_syntetic_data_based_on_run41.csv",transpose(sol)[:,6],",")



## creating the in syhthetic offline  "[GLC]" "[GLN]" "[LAC]" "[AMM]" "[mAb]"

tstart=0.0
tend=336.0 #hours
sampling= 24.0
tgrid=tstart:sampling:tend

offline_systhetic_dataset=add_gauss(transpose(sol),0.5)
offline_systhetic_dataset[:,2]=add_gauss(transpose(sol)[:,2],10.5)#specific noise
offline_systhetic_dataset[:,3]=add_gauss(transpose(sol)[:,3],0.5)
offline_systhetic_dataset[:,4]=add_gauss(transpose(sol)[:,4],1.0)
offline_systhetic_dataset[:,5]=add_gauss(transpose(sol)[:,5],13.5)
offline_systhetic_dataset[:,6]=add_gauss(transpose(sol)[:,6],100.5)

offline_systhetic_dataset=
[0.192695  75.146    7.81966   0.265034    1.27991    32.7291;
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
3.98725   11.0665   1.46735   9.38338    89.6966   1167.8]

prob =  ODEProblem(ode_system!, u0, (tstart,tend), p)
sol = solve(prob, AutoTsit5(Rosenbrock23()),saveat=tgrid)
plots=Plots.scatter(tgrid_dt,transpose(data_train), label = false, ylabel=["[Xv]"  "[GLC]" "[GLN]" "[LAC]" "[AMM]" "[mAb]"],layout=(2,3) )
plot!(sol.t,offline_systhetic_dataset, label = false, ylabel=["[Xv]"  "[GLC]" "[GLN]" "[LAC]" "[AMM]" "[mAb]"],layout=(2,3) )
plot!(sol.t,transpose(sol),color=[:red  :red :red :red :red :red], lw=1.5, label = false, ylabel=["[Xv]"  "[GLC]" "[GLN]" "[LAC]" "[AMM]" "[mAb]"], layout=(2,3))
display(plots)
display(offline_systhetic_dataset)

# writedlm("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/offline_syntetic_data_from_run41.csv",offline_systhetic_dataset,",")

# # "[Xv]"  "[GLC]" "[GLN]" "[LAC]" "[AMM]" "[mAb]"
# 0.192695  75.146    7.81966   0.265034    1.27991    32.7291
# 2.11623   56.3378   7.03898   2.10494    26.662     209.976
# 2.87119   50.4827   6.08581   7.85398    68.4866    176.481
# 4.41954   49.2173   5.14943   8.77957    85.6762    107.637
# 3.32521   38.4718   3.70475   8.6194     81.0077    208.951
# 4.17088   57.5675   3.6162    8.99678    92.2043    333.799
# 2.84115   59.475    3.64439   9.11203    81.2265    618.069
# 4.44663   43.0841   3.00971   9.69383   117.602     479.196
# 3.86769   37.031    2.44176   8.73131    96.7622    826.939
# 4.13991   33.361    1.94364   8.73629    74.197     761.688
# 3.42359   29.7166   2.45774  10.1081     98.2864    720.757
# 4.31046   16.1609   1.35554   9.75317   102.432     697.37
# 4.38777   42.0331   1.30546   8.59807    98.7049    880.777
# 4.07674    5.18514  1.73006   7.84829    90.4645   1073.67
# 3.98725   11.0665   1.46735   9.38338    89.6966   1167.8





#
# ## process error
#
# tstart=0.0
# tend=336.0
# sampling= 24.0
# tgrid=tstart:sampling:tend
#
# prob =  ODEProblem(ode_system!, u0, (tstart,tend), p)
# sol = solve(prob, AutoTsit5(Rosenbrock23()),saveat=tgrid)
# plots=Plots.scatter(tgrid_dt,transpose(data_train), label = false, ylabel=["[Xv]"  "[GLC]" "[GLN]" "[LAC]" "[AMM]" "[mAb]"],layout=(2,3) )
# plot!(sol.t,transpose(sol),color=[:red  :red :red :red :red :red], lw=1.5, label = false, ylabel=["[Xv]"  "[GLC]" "[GLN]" "[LAC]" "[AMM]" "[mAb]"], layout=(2,3))
# display(plots)
#
# #process error regards the state variables GLC, GLN, LAC, AMM and mAb
#
#
# println(std(transpose(sol)[:,2] - data_train[2,:])) #GLC
# println(std(transpose(sol)[:,3] - data_train[3,:])) #GLN
# println(std(transpose(sol)[:,4] - data_train[4,:])) #LAC
# println(std(transpose(sol)[:,5] - data_train[5,:])) #AMM
# println(std(transpose(sol)[:,6] - data_train[6,:])) #mAb
# #process error regards the state variables GLC, GLN, LAC, AMM and mAb
# # 12.568826139326376
# # 1.3425909084680439
# # 1.9263669441968778
# # 33.054794974755794
# # 117.22120488234692
#
#
#
#
# ## Bayesian parameter estimation to get the initial process error for QmAb
#
# p =  [0.3500000000018143,
#   0.19999999945296218,
#   0.01999999998750423,
#   3.727145529338013,
#  11.500000000011484,
#   0.07000000000000003,
#  44.99999999999999,
#  12.99999999974547,
#   0.009999999998920579,
#   5.00000000013392,
#   3.9999999999958984,
#   0.03699999999999961,
#   1.6692292443034908,
#   9.000000000051596,
#  40.10000017750236,
#   2.3863630840060696e-13,
#   0.899999999999832] #0.9004412179440505
#
# prob1 = ODEProblem(ode_system!, u0, (tstart,tend), p)
# # predicted1 = solve(prob1,AutoTsit5(Rosenbrock23()),saveat=tgrid)
#
# tstart=0.0
# tend=336.0
# sampling= 24.0
# tgrid=tstart:sampling:tend
#
# Turing.setadbackend(:forwarddiff)
# @model function fitmb(data, problem)
#     μ=0.5
#     σ=0.1
#     b=0.3
#     e=0.8
#     σ_p  ~ truncated(Normal(μ, σ),b,e)#InverseGamma(4, 3)
#
#     # μmax    ~ Uniform(0.35,0.45)
#     # kglc    ~ Uniform(0.01,.2)
#     # kgln    ~ Uniform(0.01,.02)
#     # kilac    ~ Uniform(3.0,6.)
#     # kiamm    ~ Uniform(11.5,15.0)
#     # kd    ~ Uniform(0.07,0.566)
#     # kdlac    ~ Uniform(20.0,45.0)
#     # kdamm    ~ Uniform(10.,13.)
#     # a1    ~ Uniform(0.005,0.01)
#     # a2    ~ Uniform(5.0,5.8)
#     # Yxv_glc    ~ Uniform(1.1,4.0)
#     # mglc    ~ Uniform(0.01,0.037)
#     # Yxv_gln    ~ Uniform(1.,2.0)
#     # Ylac_glc    ~ Uniform(9.0,10.0)
#     # Yamm_gln    ~ Uniform(40.1,40.42)
#     # ramm    ~ Uniform(0.0,0.0000001)
#     QmAb    ~ Uniform(.05,1.9) # (.05,.9)
#
#
#     # (0.35,0.45),       #μmax   0.029
#     # (0.01,.2),          #kglc   0.15
#     # (0.01,.02),           #kgln   0.04
#     # (3.0,6.),           #kilac  45.0
#     # (11.5,15.0),         #kiamm  9.5
#     # (0.07,0.566),    #kd    0.0066
#     # (20.0,45.0),        #kdlac  40.0
#     # (10.,13.),           #kdamm  4.0
#     # (0.005,0.01),        #a1     3.2
#     # (5.0,5.8),          #a2     2.1
#     # (1.1,4.0),           #Yxv_glc 0.413
#     # (0.01,0.037),          #mglc   69.2
#     # (1.,2.0),           #Yxv_gln 0.573
#     # (9.0,10.0),       #Ylac_glc  1.391
#     # (40.1,40.42),           #Yamm_gln  0.739
#     # (0.0,0.0000001),         #ramm   6.3
#     # (.05,.9)         #QmAb   2.25
#
#     p =  [0.3500000000018143,
#       0.19999999945296218,
#       0.01999999998750423,
#       3.727145529338013,
#      11.500000000011484,
#       0.07000000000000003,
#      44.99999999999999,
#      12.99999999974547,
#       0.009999999998920579,
#       5.00000000013392,
#       3.9999999999958984,
#       0.03699999999999961,
#       1.6692292443034908,
#       9.000000000051596,
#      40.10000017750236,
#       2.3863630840060696e-13,
#       QmAb]
#
#     # p = [μmax,kglc,kgln,kilac,kiamm,kd,kdlac,kdamm,a1,a2,Yxv_glc,mglc,Yxv_gln,Ylac_glc,Yamm_gln,ramm,QmAb]
#
#     rprob1 = remake(problem, p=p)
#     predicted1 = solve(rprob1,AutoTsit5(Rosenbrock23()),saveat=tgrid)
#     for  i = 1:length(predicted1)
#         data[:,i] ~ MvNormal(predicted1[i], σ_p)#0.5)
#     end
# end
#
# model = fitmb(data_train, prob1)
# chain = sample(model, NUTS(.65),2000)
#
# # # results in the chain with QmAb    ~ Uniform(.05,.9)
# # Summary Statistics
# #   parameters      mean       std   naive_se      mcse         ess      rhat   ess_per_sec
# #       Symbol   Float64   Float64    Float64   Float64     Float64   Float64       Float64
# #
# #          σ_p    0.8000    0.0000     0.0000    0.0000   1099.3076    1.0021        1.5287
# #         QmAb    0.8999    0.0001     0.0000    0.0000   1117.4202    1.0008        1.5539
# #
# # Quantiles
# #   parameters      2.5%     25.0%     50.0%     75.0%     97.5%
# #       Symbol   Float64   Float64   Float64   Float64   Float64
# #
# #          σ_p    0.8000    0.8000    0.8000    0.8000    0.8000
# #         QmAb    0.8996    0.8998    0.8999    0.9000    0.9000
#
#
#
# # var_QmAb  = var(chain["QmAb"])
# # 1.1477295438181693e-8
# #
# # std_QmAb  = std(chain["QmAb"])
# # 0.00010713214008028447
# #
# # mean_var_QmAb  = mean(chain["QmAb"])
# # 0.8998774316833018
#
# # display(chain)
# #
# # #plot chain
# # display(plot(chain))
# #
# # #plot the ACF for the chain
# # display(autocorplot(chain))
#
#
#
#
#  # results in the chain with QmAb   ~ Uniform(.05,1.9)
# # Summary Statistics
# #   parameters      mean       std   naive_se      mcse         ess      rhat   ess_per_sec
# #       Symbol   Float64   Float64    Float64   Float64     Float64   Float64       Float64
# #
# #          σ_p    0.8000    0.0000     0.0000    0.0000    662.1889    1.0027        0.5928
# #         QmAb    0.9004    0.0003     0.0000    0.0000   1730.1726    1.0005        1.5487
# #
# # Quantiles
# #   parameters      2.5%     25.0%     50.0%     75.0%     97.5%
# #       Symbol   Float64   Float64   Float64   Float64   Float64
# #
# #          σ_p    0.8000    0.8000    0.8000    0.8000    0.8000
# #         QmAb    0.8998    0.9002    0.9004    0.9006    0.9010
#
#
#
#
# # julia> var_QmAb  = var(chain["QmAb"])
# # 8.87008243514944e-8
# #
# # julia> std_QmAb  = std(chain["QmAb"])
# # 0.0002978268361842069
# #
# # julia> mean_QmAb  = mean(chain["QmAb"])
# # 0.9004412179440505
#
# # display(chain)
# #
# # #plot chain
# # display(plot(chain))
# #
# # #plot the ACF for the chain
# # display(autocorplot(chain))
