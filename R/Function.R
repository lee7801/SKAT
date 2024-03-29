
#
# Get Parameter for the Liu et. al 
#

Get_Liu_Params<-function(c1){
  ## Helper function for getting the parameters for the null approximation
  muQ<-c1[1]
  sigmaQ<-sqrt(2 *c1[2])
  s1 = c1[3] / c1[2]^(3/2)
  s2 = c1[4] / c1[2]^2

  beta1<-sqrt(8)*s1
  beta2<-12*s2
  type1<-0

  if(s1^2 > s2){
    a = 1/(s1 - sqrt(s1^2 - s2))
    d = s1 *a^3 - a^2
    l = a^2 - 2*d
  } else {
    type1<-1
    a = 1/s1
    d = 0
    l = 1/s1^2
  }
  muX <-l+d
  sigmaX<-sqrt(2) *a

  re<-list(l=l,d=d,muQ=muQ,muX=muX,sigmaQ=sigmaQ,sigmaX=sigmaX)
  return(re)
}

Get_Liu_Params_Mod<-function(c1){
  ## Helper function for getting the parameters for the null approximation
  muQ<-c1[1]
  sigmaQ<-sqrt(2 *c1[2])
  s1 = c1[3] / c1[2]^(3/2)
  s2 = c1[4] / c1[2]^2

  beta1<-sqrt(8)*s1
  beta2<-12*s2
  type1<-0

  #print(c(s1^2,s2))
  if(s1^2 > s2){
    a = 1/(s1 - sqrt(s1^2 - s2))
    d = s1 *a^3 - a^2
    l = a^2 - 2*d
  } else {
    type1<-1
    l = 1/s2
    a = sqrt(l)
    d = 0
  }
  muX <-l+d
  sigmaX<-sqrt(2) *a

  re<-list(l=l,d=d,muQ=muQ,muX=muX,sigmaQ=sigmaQ,sigmaX=sigmaX)
  return(re)
}


Get_Liu_Params_Mod_Lambda<-function(lambda){
  ## Helper function for getting the parameters for the null approximation

  c1<-rep(0,4)
  for(i in 1:4){
	c1[i]<-sum(lambda^i)
  }

  muQ<-c1[1]
  sigmaQ<-sqrt(2 *c1[2])
  s1 = c1[3] / c1[2]^(3/2)
  s2 = c1[4] / c1[2]^2

  beta1<-sqrt(8)*s1
  beta2<-12*s2
  type1<-0

  #print(c(s1^2,s2))
  if(s1^2 > s2){
    a = 1/(s1 - sqrt(s1^2 - s2))
    d = s1 *a^3 - a^2
    l = a^2 - 2*d
  } else {
    type1<-1
    l = 1/s2
    a = sqrt(l)
    d = 0
  }
  muX <-l+d
  sigmaX<-sqrt(2) *a

  re<-list(l=l,d=d,muQ=muQ,muX=muX,sigmaQ=sigmaQ,sigmaX=sigmaX)
  return(re)
}

Get_Liu_PVal<-function(Q, W, Q.resampling = NULL){
    

	Q.all<-c(Q,Q.resampling)

	A1<-W/2
	A2<-A1 %*% A1

	c1<-rep(0,4)
	c1[1]<-sum(diag(A1))
	c1[2]<-sum(diag(A2))
	c1[3]<-sum(A1*t(A2))
	c1[4]<-sum(A2*t(A2))
	param<-Get_Liu_Params(c1)

	Q.Norm<-(Q.all - param$muQ)/param$sigmaQ
	Q.Norm1<-Q.Norm * param$sigmaX + param$muX
	p.value<- 1-pchisq(Q.Norm1,  df = param$l,ncp=param$d)

	p.value.resampling = NULL
	if(length(Q.resampling) > 0){
		p.value.resampling<-p.value[-1]
	}

	re<-list(p.value = p.value[1], param=param, p.value.resampling = p.value.resampling )  
	return(re)
}

Get_Liu_PVal.MOD<-function(Q, W, Q.resampling = NULL){
    
	Q.all<-c(Q,Q.resampling)

	A1<-W/2
	A2<-A1 %*% A1

	c1<-rep(0,4)
	c1[1]<-sum(diag(A1))
	c1[2]<-sum(diag(A2))
	c1[3]<-sum(A1*t(A2))
	c1[4]<-sum(A2*t(A2))
	param<-Get_Liu_Params_Mod(c1)

	Q.Norm<-(Q.all - param$muQ)/param$sigmaQ
	Q.Norm1<-Q.Norm * param$sigmaX + param$muX
	p.value<- 1-pchisq(Q.Norm1,  df = param$l,ncp=param$d)

	p.value.resampling = NULL
	if(length(Q.resampling) > 0){
		p.value.resampling<-p.value[-1]
	}

	re<-list(p.value = p.value[1], param=param, p.value.resampling = p.value.resampling ) 

	return(re)
}

Get_Davies_PVal<-function(Q, W, Q.resampling = NULL){
    
	K<-W/2
	
	Q.all<-c(Q,Q.resampling)

	re<-Get_PValue(K,Q.all)
	param<-list()
	param$liu_pval<-re$p.val.liu[1]
	param$Is_Converged<-re$is_converge[1]


	p.value.resampling = NULL
	if(length(Q.resampling) > 0){
		p.value.resampling<-re$p.value[-1]
		param$liu_pval.resampling<-re$p.val.liu[-1]
		param$Is_Converged.resampling<-re$is_converge[-1]

	}
	

	re<-list(p.value = re$p.value[1], param=param,p.value.resampling = p.value.resampling )  
	return(re)
}



Get_Lambda<-function(K){

	out.s<-eigen(K,symmetric=TRUE, only.values = TRUE)
	#print(out.s$values)

	#out.s1<-eigen(K,symmetric=TRUE)
	#print(out.s1$values)
	
	lambda1<-out.s$values
	IDX1<-which(lambda1 >= 0)

	# eigenvalue bigger than sum(eigenvalues)/1000
	IDX2<-which(lambda1 > mean(lambda1[IDX1])/100000)

	if(length(IDX2) == 0){
		stop("No Eigenvalue is bigger than 0!!")
	}
	lambda<-lambda1[IDX2]
	lambda

}



Get_Lambda_U_From_Z<-function(Z1){
	
	if(dim(Z1)[2]==1){
		Is.OnlyOne = TRUE
		lambda<-sum(Z1^2)
		U<-Z1/sqrt(lambda)		
		return(list( lambda = lambda, U = cbind(U)))
	}

	out.svd<-svd(Z1, LINPACK = TRUE)
	lambda.org<-out.svd$d^2
	IDX<-which(lambda.org > mean(lambda.org)/100000)
	if(length(IDX) <= 1){
		Is.OnlyOne = TRUE
	}

	if(length(IDX) == 0){
		return(list(lambda=NULL, U=NULL))
	}
	return(list( lambda = lambda.org[IDX], U = cbind(out.svd$u[,IDX])))
}


Get_PValue<-function(K,Q){
	
	lambda<-Get_Lambda(K)
	#print(lambda)
	n1<-length(Q)

	p.val<-rep(0,n1)
	p.val.liu<-rep(0,n1)
	is_converge<-rep(0,n1)

	for(i in 1:n1){
		out<-SKAT_davies(Q[i],lambda,acc=10^(-6))

		p.val[i]<-out$Qq
		p.val.liu[i]<-SKAT_liu(Q[i],lambda)

		is_converge[i]<-1
		
		# check convergence
		if(length(lambda) == 1){
			p.val[i]<-p.val.liu[i]
		} else if(out$ifault != 0){
			is_converge[i]<-0
		}
	
		# check p-value
		if(p.val[i] > 1 || p.val[i] <= 0 ){
			is_converge[i]<-0
			p.val[i]<-p.val.liu[i]
		}
	}

	return(list(p.value=p.val, p.val.liu=p.val.liu, is_converge=is_converge))

}




# Simple Imputation
# Z : an n x p genotype matrix with n samples and p SNPs
# Missing : a missing genotype value. Default is 9

Impute<-function(Z, impute.method){
	
	p<-dim(Z)[2]

	if(impute.method =="random"){
		for(i in 1:p){
			IDX<-which(is.na(Z[,i]))
			if(length(IDX) > 0){
				maf1<-mean(Z[-IDX,i])/2
				Z[IDX,i]<-rbinom(length(IDX),2,maf1)
			}
		}
	} else if(impute.method =="fixed"){
		for(i in 1:p){
			IDX<-which(is.na(Z[,i]))
			if(length(IDX) > 0){
				maf1<-mean(Z[-IDX,i])/2
				Z[IDX,i]<-2 * maf1
			}
		}
	} else {
		stop("Error: Imputation method shoud be either \"fixed\" or \"random\"! ")
	}

	return(Z)
}


##################################################
# Get polymorphic SNP
SKAT_Get_Polymorphic_SNP<-function(Z){

	temp<-apply(Z,2,var)
	ID<-which(temp == 0)
	return(ID)
}

###########################################
#
# Functions related to weights


# Get Beta Weights
# Z : an n x p genotype matrix with n samples and p SNPs

Beta.Weights<-function(MAF,weights.beta){

	n<-length(MAF)
	weights<-rep(0,n)	
	IDX_0<-which(MAF == 0)
	if(length(IDX_0) == n){
		stop("No polymorphic SNPs")
	} else if( length(IDX_0) == 0){
		weights<-dbeta(MAF,weights.beta[1],weights.beta[2])
	} else {
		weights[-IDX_0]<-dbeta(MAF[-IDX_0],weights.beta[1],weights.beta[2])
	}
	
	#print(length(IDX_0))
	#print(weights[-IDX_0])
	return(weights)
	
}



Get_MAF<-function(Z){

	is.missing<-which(Z == 9)
	Z[is.missing]<-NA

	maf<-colMeans(Z,na.rm = TRUE)/2
	return(maf)

}


Get_Logistic_Weights_MAF<-function(MAF,par1= 0.07, par2=150){

	n<-length(MAF)
	weights<-rep(0,n)	
	IDX<-which(MAF > 0)
	if(length(IDX) == 0){
		stop("No polymorphic SNPs")
	} else {

		x1<-(MAF[IDX] - par1) * par2
		weights[IDX]<-exp(-x1)/(1+exp(-x1))
	} 

	return(weights)
	
}



Get_Logistic_Weights<-function(Z,par1=0.07, par2=150){

	MAF<-Get_MAF(Z)
	re<-Get_Logistic_Weights_MAF(MAF,par1,par2)
	return(re)
}




Get_Matrix_Square.1<-function(A){
	
	out<-eigen(A,symmetric=TRUE)
	ID1<-which(out$values > 0)
	if(length(ID1)== 0){
		stop("Error to obtain matrix square!")
	}
	out1<-t(out$vectors[,ID1]) * sqrt(out$values[ID1])
	return(out1)
}


###########################################
#	Function related to resampling 

Get_Resampling_Pvalue<-function (obj, ...){


	ml<-match.call()
	ml.name<-names(ml)
	IDX1<-which(ml.name == "p.value")
	if(length(IDX1) > 0){
		re<-Get_Resampling_Pvalue.numeric(...)
	} else {
		if(class(obj) == "SKAT_OUT"){
			re<-Get_Resampling_Pvalue.SKAT_OUT(obj, ...)
		} else{
			re<-Get_Resampling_Pvalue.numeric(obj, ...)
		}
	}

	return(re)
}


Get_Resampling_Pvalue.SKAT_OUT<-function(obj){

	if(is.null(obj$p.value.resampling)){
		stop("No resampling was applied!")
	}

	n<-length(obj$p.value.resampling)
	n1<-length(which(obj$p.value >= obj$p.value.resampling))
	pval1<-(n1+1)/(n+1)
	
	re<-list(p.value=pval1, is_smaller=FALSE)
	if(n1==0){
		re$is_smaller=TRUE
	}
	
	return(re)
}

Get_Resampling_Pvalue.numeric<-function(p.value,p.value.resampling){

	if(is.null(p.value.resampling)){
		stop("No resampling was applied!")
	}

	n<-length(p.value.resampling)
	n1<-length(which(p.value >= p.value.resampling))
	pval1<-(n1+1)/(n+1)

	re<-list(p.value=pval1, is_smaller=FALSE)
	if(n1==0){
		re$is_smaller=TRUE
	}

	return(re)
}

Resampling_FWER<-function (obj, ...){


	ml<-match.call()
	ml.name<-names(ml)
	IDX1<-which(ml.name == "P.value")
	if(length(IDX1) > 0){
		re<-Resampling_FWER.numeric(...)
	} else {

		if(class(obj) == "SKAT_SSD_ALL"){
			re<-Resampling_FWER.SKAT_SSD_ALL(obj, ...)
		} else{
			re<-Resampling_FWER.numeric(obj, ...)
		}
	}


	return(re)
}


Resampling_FWER.SKAT_SSD_ALL<-function(obj,FWER=0.05){

	p.min<-apply(obj$P.value.Resampling,2,min,na.rm=TRUE)
	P.cut<-quantile(p.min,FWER)
	ID<-which(obj$results$P.value < P.cut)

	if(length(ID) == 0){
		re<-list(result=NULL, n=length(ID) ,ID=NULL)
	} else {
		re<-list(result=obj$results[ID,], n=length(ID) ,ID=ID)
	}
	return(re) 
	
}

Resampling_FWER.numeric<-function(P.value, P.value.Resampling, FWER=0.05){

	if(is.matrix(P.value.Resampling) == FALSE){
		stop("P.value.Resampling should be a matrix")
	}
	p.min<-apply(P.value.Resampling,2,min,na.rm=TRUE)
	P.cut<-quantile(p.min,FWER)
	ID<-which(P.value < P.cut)

	if(length(ID) == 0){
		re<-list(result=NULL, n=length(ID) ,ID=NULL)
	} else {
		re<-list(result=P.value[ID], n=length(ID) ,ID=ID)
	}
	return(re) 	

}

############################################################
#
#

Get_RequiredSampleSize<-function (obj, ...){


	ml<-match.call()
	ml.name<-names(ml)
	IDX1<-which(ml.name == "Power.Est")
	if(length(IDX1) > 0){
		re<-Get_RequiredSampleSize.numeric(...)
	} else {
		if(class(obj) == "SKAT_Power"){
			re<-Get_RequiredSampleSize.SKAT_Power(obj, ...)
		} else {
			re<-Get_RequiredSampleSize.numeric(obj, ...)
		}
	}


	return(re)
}


Get_RequiredSampleSize.SKAT_Power<-function(obj, Power=0.8){

	Get_RequiredSampleSize.numeric(obj$Power, Power=0.8)

}


Get_RequiredSampleSize.numeric<-function(Power.Est, Power=0.8){

	N.Sample.ALL<-as.numeric(rownames(Power.Est))
	alpha<-as.numeric(colnames(Power.Est))

	re<-list()
	for(i in 1:length(alpha)){

		
		temp<-which(Power.Est[,i] > Power)
		if(length(temp) == 0){
			temp<-sprintf("> %d",max(N.Sample.ALL))
			#print(temp)
			re[[i]]<-temp
		} else if( min(temp) ==1 ){
			re[[i]]<-min(N.Sample.ALL)
		} 
		else {
			id1<-min(temp)
			re[[i]]<-(N.Sample.ALL[id1] - N.Sample.ALL[id1-1])/(Power.Est[id1,i] - Power.Est[id1-1,i]) * (Power - Power.Est[id1-1,i]) + N.Sample.ALL[id1-1]

		}
	}
	names(re)<-sprintf("alpha = %.2e",alpha)
	return(re)
}






