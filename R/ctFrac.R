makeCounts = function(fn, bins=getBins(), blackList=getBlackList(), mi=60, ma=300, byLength=FALSE)
{ if (is(fn, "GAlignmentPairs")) { bam = fn; }
  else
  {	bam = readGAlignmentPairs(fn,
    	param=ScanBamParam(flag=scanBamFlag(isPaired=TRUE, isProperPair=TRUE, isDuplicate=FALSE,
      	isSupplementaryAlignment=FALSE, isSecondaryAlignment=FALSE),
      	what="mapq", mapqFilter=60))
  }
  w = seqnames(bam) %in% c(paste0("chr", 1:22), "chrX");
  bam = bam[w];
  st = do.call(cbind, lapply(c(first, second), function(f) cbind(start(f(bam)), end(f(bam)))))
  st = cbind(rowMins(st), rowMaxs(st))

  r = GRanges(seqnames(bam), IRanges(st[,1], st[,2]))
  mcols(r) = data.frame(mapq1=mcols(first(bam))[,"mapq"], mapq2=mcols(second(bam))[,"mapq"])  

  r = r[seqnames(r) %in% seqlevels(bins)]
  r = suppressWarnings(r[!overlapsAny(r, excl)])
  r2 = GPos(seqnames(r), round((start(r)+end(r))/2))
  o = as.matrix(findOverlaps(r2, bins))
  o2 = factor(o[,2], levels=1:length(bins))
  wid = width(r)[o[,1]]; wid[wid>ma] = ma;
  wid=wid-mi+1;  wid[wid<1]=1;
  
  if (ncol(mcols(r))>0)
	{ qal = rowMins(as.matrix(mcols(r)))
		ok = qal==60;
  } else { ok = rep(TRUE, length(r)); }
  wok = ok[o[,1]];
  
  fp = do.call(rbind, lapply(split(wid[o[,1]][wok], o2[wok]), function(wi)
  { tabulate(wi, nbins=ma-mi+1) 
  }))
  colnames(fp) = mi:ma;
  #per = tapply(ok[o[,1]], o2, mean); per = per[rownames(fp)];
  
  #fp = cbind(fp, Q=per);
  if (byLength) { return(fp); }
  return(rowSums2(fp));
}

normalizeCounts = function(x)
{ med = getNormFactor();
	model = load_model(system.file('extdata/autoEncoder.keras', package='ctFrac'));

	if (is.matrix(x)) { x = x[names(med),]; y = 1e6*x/rep(colSums2(x), each=nrow(x)) }
	else { x = x[names(med)]; y = 1e6 * x / sum(x); }
	y = log(y)-med;
	y[y < -1] = -1;
	
	pr = t(model %>% predict(t(y), verbose=FALSE));
	y = y - pr; y[y< -1] = -1;
	
	return(y)
}

GCnormalize = function(x, n.cores=1)
{	if (is.matrix(x))
	{	r=do.call(cbind, mclapply(1:ncol(x), function(i)
			GCnormalize(x[,i]), mc.cores=n.cores))
		colnames(r) = colnames(x);
		return(r);
	}
	bins = getBins()
	if (length(bins)!=length(x)) { bins = bins[as.integer(names(x))] }
	g = mcols(bins)$gc
	
	r = rep(NA, length(x))
  r[!is.na(x)] = residuals(gam(x ~ s(g)));
  names(r) = names(x)
  return(r);
}

callFrac = function(x)
{	n = length(getNormFactor())
	if (is.matrix(x) && nrow(x) != n) { stop("Not the right number of rows. Have you used normalizeCounts?")}
	if (is.vector(x) && !is.matrix(x) && length(x) != length(n))
	{ stop("Vector of wrong length. Have you used normalizeCounts?")}

  modPred = load_model(system.file('extdata/modPred.keras', package='ctFrac'));
	pr = as.vector(modPred %>% predict(t(x), verbose=0));
	if (is.matrix(x)) { names(pr) = colnames(x); }
	return(pr);
}

getBins = function()
{	readRDS(system.file('extdata/bins.RDS', package='ctFrac'))
}

getBlackList = function()
{	readRDS(system.file('extdata/blackList.RDS', package='ctFrac'))
}

getNormFactor = function()
{	readRDS(system.file('extdata/normFactor.RDS', package='ctFrac'))
}