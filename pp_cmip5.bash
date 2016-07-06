#!/bin/sh
types="Amon" #"Amon Omon fx Amon3D LImon" #OImon"
avars="rlds rlus rsus rsds rsuscs rsdscs rldscs"
ovars="hfds"
models="ACCESS1-0 ACCESS1-3 BNU-ESM CCSM4 CESM1-BGC CESM1-CAM5 CESM1-WACCM CMCC-CESM CMCC-CM CMCC-CMS CNRM-CM5 CSIRO-Mk3-6-0 CanESM2 EC-EARTH GFDL-CM3 GFDL-ESM2G GFDL-ESM2M GISS-E2-R GISS-E2-R-CC HadGEM2-AO HadGEM2-CC HadGEM2-ES IPSL-CM5A-LR IPSL-CM5A-MR IPSL-CM5B-LR MIROC5 MIROC-ESM MIROC-ESM-CHEM MPI-ESM-LR MPI-ESM-LR MPI-ESM-P MRI-CGCM3 NorESM1-M NorESM1-ME bcc-csm1-1-m bcc-csm1-1"

run="r1i1p1"
exps="piControl"
expid="${exps}_r1i1p1"
basedir="/nobackup_1/users/deppenme/ethz/cmip5"

for exp in $exps
do
	if [ ${exp} == 'piControl' ];then
		tot_time=2400
	elif [ ${exp} == 'historical' ];then
		tot_time=2400                       # Way too much, but at least enough.. the specific amount varies between models
	elif [ ${exp} == 'rcp45' ];then
		tot_time=1140
	elif [ ${exp} == 'rcp85' ];then
		tot_time=1140
	fi
	for model in $models 
	do
		for type in $types
		do
			class=$type
			case $type in
				fx) vars=$fvars;expid="${exps}_r0i0p0";run="r0i0p0";;
				Amon) vars=$avars;run="r1i1p1";;
				Amon3D) vars=$avars3d;class=Amon;run="r1i1p1";;
				Omon) vars=$ovars;run="r1i1p1";;
				Lmon) vars=$lvars;run="r1i1p1";;
				LImon) vars=$livars;run="r1i1p1";;
				OImon) vars=$oivars;run="r1i1p1";;
				*) echo "$0: error: unknown type $type"; exit -1;;
			esac
			for var in $vars
			do
                                
				bt=$basedir/$exp/$class
                btv=$basedir/$exp/$class/$var
                btvm=$basedir/$exp/$class/$var/$model/$run
				if [ ${type} == "Amon" ];
				then
                    dir=ethz/cmip5/$exp/${class}/$var/$model/$run
                    cdo mergetime $dir/*.nc $dir/tmp.nc
                    cdo remapbil,/nobackup_1/users/deppenme/good_grid.text $dir/tmp.nc $dir/${exp}_${var}_${model}_gg.nc
                    cdo sellonlatbox,-60,20,-35,35 $dir/${exp}_${var}_${model}_gg.nc $dir/${exp}_${var}_${model}_TA.nc
                    rm -f $dir/tmp*.nc
                fi    
			done
		done
	done
done
