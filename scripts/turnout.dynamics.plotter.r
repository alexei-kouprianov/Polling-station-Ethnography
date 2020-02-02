# Reading data;
ps <- read.table("../data/ps.log.txt", h=TRUE, sep="\t")

breaks.05 <- read.table("../misc/breaks.0800_2100.05.txt", h=TRUE, sep="\t")
breaks.10 <- read.table("../misc/breaks.0800_2100.10.txt", h=TRUE, sep="\t")
breaks.15 <- read.table("../misc/breaks.0800_2100.15.txt", h=TRUE, sep="\t")
breaks.20 <- read.table("../misc/breaks.0800_2100.20.txt", h=TRUE, sep="\t")
breaks.30 <- read.table("../misc/breaks.0800_2100.30.txt", h=TRUE, sep="\t")
breaks.60 <- read.table("../misc/breaks.0800_2100.60.txt", h=TRUE, sep="\t")

################################################################
################################################################
# Basic data transformations
################################################################
################################################################

# Trimming timestamps
ps$timecode <- strptime(ps$TIMECODE, "%Y-%m-%d %H:%M:%S")
breaks.05$timecode <- strptime(breaks.05$BREAKS, "%Y-%m-%d %H:%M:%S")
breaks.10$timecode <- strptime(breaks.10$BREAKS, "%Y-%m-%d %H:%M:%S")
breaks.15$timecode <- strptime(breaks.15$BREAKS, "%Y-%m-%d %H:%M:%S")
breaks.20$timecode <- strptime(breaks.20$BREAKS, "%Y-%m-%d %H:%M:%S")
breaks.30$timecode <- strptime(breaks.30$BREAKS, "%Y-%m-%d %H:%M:%S")
breaks.60$timecode <- strptime(breaks.60$BREAKS, "%Y-%m-%d %H:%M:%S")

# Building a list of polling stations with subsets for event classes;
ps.ls <- NULL
ps.ls <- as.list(ps.ls)

ps.UIDs <- unique(ps$PS.UID)
ps.UIDs <- ps.UIDs[order(ps.UIDs)]

for(i in 1:length(ps.UIDs)){
	ps.ls[[i]] <- list(
	subset(ps, ps$PS.UID == ps.UIDs[i]),
	subset(ps, ps$PS.UID == ps.UIDs[i] & ps$ACTION.TYPE=="ballot cast"),
	subset(ps, ps$PS.UID == ps.UIDs[i] & ps$ACTION.TYPE=="lacune begins"),
	subset(ps, ps$PS.UID == ps.UIDs[i] & ps$ACTION.TYPE=="lacune ends"),
	subset(ps, ps$PS.UID == ps.UIDs[i] & ps$ACTION.TYPE=="ballot cast" & ps$GENDER=="f"),
	subset(ps, ps$PS.UID == ps.UIDs[i] & ps$ACTION.TYPE=="ballot cast" & ps$GENDER=="m")
	)
	names(ps.ls[[i]]) <- c("ps.raw", "ps.b", "ps.lb", "ps.le", "ps.bf", "ps.bm")
}

# Control plot # 1
for(i in 1:length(ps.UIDs)){
	png(file=paste("../plots/cumul.dyn/", ps.ls[[i]]$ps.raw$PS.UID[1], ".cumul.dyn.png", sep=""), height=500, width=500)

	plot(
	ps.ls[[i]]$ps.b$timecode, 
	1:length(ps.ls[[i]]$ps.b$timecode), 
	type="n", pch=20, axes=FALSE,
	main=paste("Turnout dynamics for the Polling Station # ",ps.ls[[i]]$ps.raw$PS.UID[1]," (",round.POSIXt(ps.ls[[i]]$ps.raw$timecode[1], unit="days"),")",sep=""),
	xlab="Timeline, unaggregated", 
	ylab="Cumulated number of voters recorded")

	abline(h=seq(0,2000,100), lty=3, lwd=.75)
	abline(v=as.POSIXct(breaks.60$timecode), lty=3, lwd=.75)

	rect(xleft=ps.ls[[i]]$ps.lb$timecode, xright=ps.ls[[i]]$ps.le$timecode, ybottom=-5, ytop=1000, col=rgb(0,0,0,.3), border=8)
	points(ps.ls[[i]]$ps.b$timecode, 1:length(ps.ls[[i]]$ps.b$timecode), type="o", pch=20, cex=.5)
	points(ps.ls[[i]]$ps.bf$timecode, 1:length(ps.ls[[i]]$ps.bf$timecode), type="o", pch=20, col=2, cex=.5)
	points(ps.ls[[i]]$ps.bm$timecode, 1:length(ps.ls[[i]]$ps.bm$timecode), type="o", pch=20, col=4, cex=.5)

	cumul.dyn.legend <- legend("bottomright", col=c(1,2,4), lty=1, 
	legend=c(
	paste("Total (",length(ps.ls[[i]]$ps.b$timecode),")", sep=""),
	paste("Women (",length(ps.ls[[i]]$ps.bf$timecode),")", sep=""),
	paste("Men (",length(ps.ls[[i]]$ps.bm$timecode),")", sep="")
	), bty="n")
	rect(xleft=cumul.dyn.legend$rect$left, 
	xright=cumul.dyn.legend$rect$left+cumul.dyn.legend$rect$w, 
	ytop=cumul.dyn.legend$rect$top, 
	ybottom=cumul.dyn.legend$rect$top-cumul.dyn.legend$rect$h, 
	border=0, col="white")
	legend("bottomright", col=c(1,2,4), lty=1, 
	legend=c(
	paste("Total (",length(ps.ls[[i]]$ps.b$timecode),")", sep=""),
	paste("Women (",length(ps.ls[[i]]$ps.bf$timecode),")", sep=""),
	paste("Men (",length(ps.ls[[i]]$ps.bm$timecode),")", sep="")
	), 
	bty="n")

	axis(2)
	axis.POSIXct(1, at=breaks.60$timecode)

	dev.off()
}

# Control plot # 2
for(i in 1:length(ps.UIDs)){
	png(file=paste("../plots/hist.dyn/05/", ps.ls[[i]]$ps.raw$PS.UID[1], ".hist.dyn.05.png", sep=""), height=500, width=500)
	hist(ps.ls[[i]]$ps.b$timecode, breaks=breaks.05$timecode, freq=TRUE, 
	col=1, border="white", axes=FALSE,
	main=paste("Turnout dynamics for the Polling Station # ",ps.ls[[i]]$ps.raw$PS.UID[1]," (",round.POSIXt(ps.ls[[i]]$ps.raw$timecode[1], unit="days"),")",sep=""),
	xlab="Timeline, 5 min. bins",
	ylab="Number of voters recorded within a bin")
	axis(2)
	axis.POSIXct(1, at=breaks.60$timecode)
	dev.off()
}

for(i in 1:length(ps.UIDs)){
	png(file=paste("../plots/hist.dyn/10/", ps.ls[[i]]$ps.raw$PS.UID[1], ".hist.dyn.10.png", sep=""), height=500, width=500)
	hist(ps.ls[[i]]$ps.b$timecode, breaks=breaks.10$timecode, freq=TRUE, 
	col=1, border="white", axes=FALSE,
	main=paste("Turnout dynamics for the Polling Station # ",ps.ls[[i]]$ps.raw$PS.UID[1]," (",round.POSIXt(ps.ls[[i]]$ps.raw$timecode[1], unit="days"),")",sep=""),
	xlab="Timeline, 10 min. bins",
	ylab="Number of voters recorded within a bin")
	axis(2)
	axis.POSIXct(1, at=breaks.60$timecode)
	dev.off()
}

for(i in 1:length(ps.UIDs)){
	png(file=paste("../plots/hist.dyn/15/", ps.ls[[i]]$ps.raw$PS.UID[1], ".hist.dyn.15.png", sep=""), height=500, width=500)
	hist(ps.ls[[i]]$ps.b$timecode, breaks=breaks.15$timecode, freq=TRUE, 
	col=1, border="white", axes=FALSE,
	main=paste("Turnout dynamics for the Polling Station # ",ps.ls[[i]]$ps.raw$PS.UID[1]," (",round.POSIXt(ps.ls[[i]]$ps.raw$timecode[1], unit="days"),")",sep=""),
	xlab="Timeline, 15 min. bins",
	ylab="Number of voters recorded within a bin")
	axis(2)
	axis.POSIXct(1, at=breaks.60$timecode)
	dev.off()
}

for(i in 1:length(ps.UIDs)){
	png(file=paste("../plots/hist.dyn/20/", ps.ls[[i]]$ps.raw$PS.UID[1], ".hist.dyn.20.png", sep=""), height=500, width=500)
	hist(ps.ls[[i]]$ps.b$timecode, breaks=breaks.20$timecode, freq=TRUE, 
	col=1, border="white", axes=FALSE,
	main=paste("Turnout dynamics for the Polling Station # ",ps.ls[[i]]$ps.raw$PS.UID[1]," (",round.POSIXt(ps.ls[[i]]$ps.raw$timecode[1], unit="days"),")",sep=""),
	xlab="Timeline, 20 min. bins",
	ylab="Number of voters recorded within a bin")
	axis(2)
	axis.POSIXct(1, at=breaks.60$timecode)
	dev.off()
}

for(i in 1:length(ps.UIDs)){
	png(file=paste("../plots/hist.dyn/30/", ps.ls[[i]]$ps.raw$PS.UID[1], ".hist.dyn.30.png", sep=""), height=500, width=500)
	hist(ps.ls[[i]]$ps.b$timecode, breaks=breaks.30$timecode, freq=TRUE, 
	col=1, border="white", axes=FALSE,
	main=paste("Turnout dynamics for the Polling Station # ",ps.ls[[i]]$ps.raw$PS.UID[1]," (",round.POSIXt(ps.ls[[i]]$ps.raw$timecode[1], unit="days"),")",sep=""),
	xlab="Timeline, 30 min. bins",
	ylab="Number of voters recorded within a bin")
	axis(2)
	axis.POSIXct(1, at=breaks.60$timecode)
	dev.off()
}

ps.timecode.hist.60.ls <- NULL
ps.timecode.hist.60.ls <- as.list(ps.timecode.hist.60.ls)

for(i in 1:length(ps.UIDs)){
	png(file=paste("../plots/hist.dyn/60/", ps.ls[[i]]$ps.raw$PS.UID[1], ".hist.dyn.60.png", sep=""), height=500, width=500)
	ps.timecode.hist.60.ls[[i]] <- hist(ps.ls[[i]]$ps.b$timecode, breaks=breaks.60$timecode, freq=TRUE, 
	col=1, border="white", axes=FALSE,
	main=paste("Turnout dynamics for the Polling Station # ",ps.ls[[i]]$ps.raw$PS.UID[1]," (",round.POSIXt(ps.ls[[i]]$ps.raw$timecode[1], unit="days"),")",sep=""),
	xlab="Timeline, 60 min. bins",
	ylab="Number of voters recorded within a bin")
	axis(2)
	axis.POSIXct(1, at=breaks.60$timecode)
	dev.off()
}

for(i in 1:length(ps.UIDs)){
timecode.hist.60.contingency <- rbind.data.frame(ps.timecode.hist.60.ls[[i]]$counts)
}

rownames(timecode.hist.60.contingency) <- ps.UIDs
colnames(timecode.hist.60.contingency) <- c("HR.08.09","HR.09.10","HR.10.11","HR.11.12","HR.12.13","HR.13.14","HR.14.15","HR.15.16","HR.16.17","HR.17.18","HR.18.19","HR.19.20","HR.20.21")
