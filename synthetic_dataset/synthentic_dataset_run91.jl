using DifferentialEquations, DiffEqFlux, Plots
using XLSX, DataFrames, Optim, BlackBoxOptim,DiffEqParamEstim
using GalacticOptim
using DelimitedFiles
using Noise
using Turing, StatsPlots, Random

gr();
data_train=[]
tgrid_dt=[]

# ## All runs of syntetic (In silico) dataset from the paper - Hybrid‐EKF: Hybrid model coupled with extended Kalman filter for real‐time monitoring and control of mammalian cell culture
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
n=91#24#41
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
# u0 = [0.2   ,    60.0 ,    8.0    ,   0.1,       0.1   ,     0.0] #initial condition of RUN 91



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



#GOOD.1 91
bounds = Tuple{Float64, Float64}[
(0.0035,0.085),       #μmax   0.029
(0.01,.2),          #kglc   0.15
(0.01,.02),           #kgln   0.04
(3.0,6.),           #kilac  45.0
(11.5,15.0),         #kiamm  9.5
(0.07,0.566),    #kd    0.0066
(20.0,45.0),        #kdlac  40.0
(10.,13.),           #kdamm  4.0
(0.0009,0.007),        #a1     3.2
(.005,6.),          #a2     2.1
(1.1,3.0),           #Yxv_glc 0.413
(0.01,0.1),          #mglc   69.2
(.5,6.0),           #Yxv_gln 0.573
(9.0,10.0),       #Ylac_glc  1.391
(.1,10.42),           #Yamm_gln  0.739
(0.0,0.0000001),         #ramm   6.3
(.05,1.69)         #QmAb   2.25 1.69
]

# #GOOD.2 91
# bounds = Tuple{Float64, Float64}[
# (0.0015,0.6),       #μmax   0.029
# (0.01,.2),          #kglc   0.15
# (0.01,.02),           #kgln   0.04
# (3.0,6.),           #kilac  45.0
# (11.5,15.0),         #kiamm  9.5
# (0.4,0.566),    #kd    0.0066
# (20.0,45.0),        #kdlac  40.0
# (10.,16.),           #kdamm  4.0
# (0.0009,0.007),        #a1     3.2
# (4.05,6.),          #a2     2.1
# (2.1,4.5),           #Yxv_glc 0.413
# (0.01,0.1),          #mglc   69.2
# (.5,6.0),           #Yxv_gln 0.573
# (9.0,10.0),       #Ylac_glc  1.391
# (1.1,10.42),           #Yamm_gln  0.739
# (0.0,0.0000001),         #ramm   6.3
# (.05,0.69)         #QmAb   2.25
# ]
#
# #GOOD.3 91
# bounds = Tuple{Float64, Float64}[
# (0.0035,0.085),       #μmax   0.029
# (0.01,.2),          #kglc   0.15
# (0.01,.02),           #kgln   0.04
# (3.0,6.),           #kilac  45.0
# (11.5,15.0),         #kiamm  9.5
# (0.07,0.566),    #kd    0.0066
# (20.0,45.0),        #kdlac  40.0
# (10.,13.),           #kdamm  4.0
# (0.0009,0.007),        #a1     3.2
# (.005,6.),          #a2     2.1
# (1.1,3.0),           #Yxv_glc 0.413
# (0.01,0.1),          #mglc   69.2
# (.5,6.0),           #Yxv_gln 0.573
# (9.0,10.0),       #Ylac_glc  1.391
# (.1,10.42),           #Yamm_gln  0.739
# (0.0,0.0000001),         #ramm   6.3
# (.05,.69)         #QmAb   2.25
# ]

#GOOD.4 91
bounds = Tuple{Float64, Float64}[
(0.0035,0.085),       #μmax   0.029
(0.01,.2),          #kglc   0.15
(0.01,.02),           #kgln   0.04
(3.0,6.),           #kilac  45.0
(11.5,15.0),         #kiamm  9.5
(0.07,0.566),    #kd    0.0066
(20.0,45.0),        #kdlac  40.0
(10.,13.),           #kdamm  4.0
(0.0009,0.007),        #a1     3.2
(.005,6.),          #a2     2.1
(1.1,3.0),           #Yxv_glc 0.413
(0.01,0.1),          #mglc   69.2
(.5,6.0),           #Yxv_gln 0.573
(9.0,10.0),       #Ylac_glc  1.391
(.1,10.42),           #Yamm_gln  0.739
(0.0,0.0000001),         #ramm   6.3
(.05,.79)         #QmAb   2.25 1.69
]

#GOOD.5 91
bounds = Tuple{Float64, Float64}[
(0.0035,0.085),       #μmax   0.029
(0.01,.2),          #kglc   0.15
(0.01,.02),           #kgln   0.04
(3.0,6.),           #kilac  45.0
(11.5,15.0),         #kiamm  9.5
(0.07,0.566),    #kd    0.0066
(20.0,45.0),        #kdlac  40.0
(10.,13.),           #kdamm  4.0
(0.0009,0.05),        #a1     3.2
(.0045,6.),          #a2     2.1
(1.1,3.0),           #Yxv_glc 0.413
(0.01,0.05),          #mglc   69.2
(.5,6.0),           #Yxv_gln 0.573
(8.0,10.0),       #Ylac_glc  1.391
(30.5,45.42),           #Yamm_gln  0.739
(0.0,0.0000001),         #ramm   6.3
(.05,.79)         #QmAb   2.25 1.69
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

#run 91 best parameters
p=[0.0777599, 0.01, 0.01, 6.0, 15.0, 0.07, 45.0, 13.0, 0.0221436, 6.0, 3.0, 0.05, 2.07621, 8.0, 30.5, 7.18176e-13, 0.79]

# 0.07775986142629199
# 0.010000002362193384
# 0.010000000230973074
# 5.999999999767767
# 14.999999999016929
# 0.07000000000345054
# 44.99999999994502
# 12.999999998465023
# 0.022143586468943963
# 5.999998922551222
# 2.999999999988906
# 0.04999999999999999
# 2.0762109710083756
# 8.000000000491639
# 30.50000011566309
# 7.181763953307889e-13
# 0.789999999992151

## creating the in insilico online Xv
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


# # saving to CSV the Xv with three different noise 0.03, 0.05 and 0.5
# writedlm("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/time_h_of_Xv_syntetic_data_with_gaussian_noises.csv",sol.t,",")
# writedlm("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Xv_syntetic_data_run91_with_gaussian_noise_0.03.csv",add_gauss(transpose(sol)[:,1],0.03),",")
# writedlm("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Xv_syntetic_data_run91_with_gaussian_noise_0.05.csv",add_gauss(transpose(sol)[:,1],0.05),",")
# writedlm("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/Xv_syntetic_data_run91_with_gaussian_noise_0.5.csv",add_gauss(transpose(sol)[:,1],0.5),",")

# writedlm("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/mAb_syntetic_data_based_on_run91.csv",transpose(sol)[:,6],",")



#reading from CSV
# CSV.read("Xv_syntetic_data_with_gaussian_noise_0.03.csv",DataFrame)

#measurement errors regards Xv 0.03, 0.05, 0.5
# std(add_gauss(transpose(sol)[:,1],0.5) - transpose(sol)[:,1])




## creating the in syhthetic offline  "[GLC]" "[GLN]" "[LAC]" "[AMM]" "[mAb]"

tstart=0.0
tend=336.0 #hours
sampling= 24.0
tgrid=tstart:sampling:tend

offline_systhetic_dataset=add_gauss(transpose(sol),0.5)
offline_systhetic_dataset[:,2]=add_gauss(transpose(sol)[:,2],8.5)#specific noise
offline_systhetic_dataset[:,3]=add_gauss(transpose(sol)[:,3],0.5)
offline_systhetic_dataset[:,4]=add_gauss(transpose(sol)[:,4],1.0)
offline_systhetic_dataset[:,5]=add_gauss(transpose(sol)[:,5],10.5)
offline_systhetic_dataset[:,6]=add_gauss(transpose(sol)[:,6],80.5)


prob =  ODEProblem(ode_system!, u0, (tstart,tend), p)
sol = solve(prob, AutoTsit5(Rosenbrock23()),saveat=tgrid)
plots=Plots.scatter(tgrid_dt,transpose(data_train), label = false, ylabel=["[Xv]"  "[GLC]" "[GLN]" "[LAC]" "[AMM]" "[mAb]"],layout=(2,3) )
plot!(sol.t,offline_systhetic_dataset, label = false, ylabel=["[Xv]"  "[GLC]" "[GLN]" "[LAC]" "[AMM]" "[mAb]"],layout=(2,3) )
plot!(sol.t,transpose(sol),color=[:red  :red :red :red :red :red], lw=1.5, label = false, ylabel=["[Xv]"  "[GLC]" "[GLN]" "[LAC]" "[AMM]" "[mAb]"], layout=(2,3))
display(plots)
display(offline_systhetic_dataset)

# writedlm("/Users/cristovao/Devel/bioprocessesDT/ICML_paper/offline_syntetic_data_from_run91.csv",offline_systhetic_dataset,",")

# # "[Xv]"  "[GLC]" "[GLN]" "[LAC]" "[AMM]" "[mAb]"
# 0.569124  55.8536  8.30142  0.993031  0.8823    8.6691
# 1.05832   48.6394  7.09718  1.30178    12.0793   50.2186
# 1.78708   47.6167  6.84174  2.68903    11.1408   23.0721
# 1.97921   36.957   5.93311  6.73872    29.1418  171.364
# 2.78782   58.6522  4.78733  7.17753    34.8223   61.5214
# 2.34705   60.1879  4.49614  7.26918    22.5003  259.302
# 3.18781   36.3323  4.29496  5.96666    29.4695  135.019
# 2.79167   26.0652  2.97793  6.70033    37.8903  242.771
# 3.1683    38.7066  2.36992  8.37146    53.8758  454.051
# 3.07924   35.8218  1.55129  8.77781    43.9493  282.814
# 2.39014   21.915   2.19973  7.65447    53.1395  397.722
# 2.9608    32.9942  2.11888  6.72268    61.9409  510.151
# 3.57861   28.9626  1.23883  7.51955    44.9947  636.756
# 3.07269   12.1787  1.14699  7.37788    35.9725  707.726
# 2.73412   10.9623  1.34439  8.86506    61.1478  578.963



## process error

tstart=0.0
tend=336.0
sampling= 24.0
tgrid=tstart:sampling:tend

prob =  ODEProblem(ode_system!, u0, (tstart,tend), p)
sol = solve(prob, AutoTsit5(Rosenbrock23()),saveat=tgrid)
plots=Plots.scatter(tgrid_dt,transpose(data_train), label = false, ylabel=["[Xv]"  "[GLC]" "[GLN]" "[LAC]" "[AMM]" "[mAb]"],layout=(2,3) )
plot!(sol.t,transpose(sol),color=[:red  :red :red :red :red :red], lw=1.5, label = false, ylabel=["[Xv]"  "[GLC]" "[GLN]" "[LAC]" "[AMM]" "[mAb]"], layout=(2,3))
display(plots)

#process error regards the state variables GLC, GLN, LAC, AMM and mAb


println(std(transpose(sol)[:,2] - data_train[2,:])) #GLC
println(std(transpose(sol)[:,3] - data_train[3,:])) #GLN
println(std(transpose(sol)[:,4] - data_train[4,:])) #LAC
println(std(transpose(sol)[:,5] - data_train[5,:])) #AMM
println(std(transpose(sol)[:,6] - data_train[6,:])) #mAb
#process error regards the state variables GLC, GLN, LAC, AMM and mAb
# 12.568826139326376
# 1.3425909084680439
# 1.9263669441968778
# 33.054794974755794
# 117.22120488234692



#### REDO for run91 ###IMPORTANT
#
# ## Bayesian parameter estimation to get the initial process error for QmAb
#
# # p =  [0.3500000000018143,
# #   0.19999999945296218,
# #   0.01999999998750423,
# #   3.727145529338013,
# #  11.500000000011484,
# #   0.07000000000000003,
# #  44.99999999999999,
# #  12.99999999974547,
# #   0.009999999998920579,
# #   5.00000000013392,
# #   3.9999999999958984,
# #   0.03699999999999961,
# #   1.6692292443034908,
# #   9.000000000051596,
# #  40.10000017750236,
# #   2.3863630840060696e-13,
# #   0.899999999999832] #0.9004412179440505
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
