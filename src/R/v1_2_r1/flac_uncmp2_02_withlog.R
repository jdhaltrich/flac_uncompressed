library(sys)

sttimedatecode <- Sys.time()
sttimeunixcode <- as.numeric(sttimeunixcode)

rootdir <- "/users/juancho_gentoo/test/flac"
basedir <- paste(rootdir, "/a", sep = "", collapse = NULL)
targetdir <- paste(rootdir, "/b", sep = "", collapse = NULL)
logdir <- paste(targetdir, "/logs", sep = "", collapse = NULL)

indexfile <- as.numeric(commandArgs(trailingOnly = TRUE))
basefileindex <- indexfile
targetfileindex <- indexfile

logfn <- function(type,string,target,labelvector){
	if (type == 0){
		cat(string,
			file = target,
			sep = "%d %Y-%m-%d %H:%M %s %s",
			fill = TRUE,
			labels = labelvector,
			append = FALSE
		)
	} else {
		cat(string,
			file = target,
			sep = "%d %Y-%m-%d %H:%M %s %s",
#			sep = "\n",
			fill = TRUE,
			labels = labelvector,
			append = TRUE
		)
	}
}

basefiles_flac <- list.files(path = basedir, pattern = "\\.flac$",
				all.files = TRUE, full.names = TRUE,
				recursive = TRUE, ignore.case = FALSE,
				include.dirs = FALSE, no.. = FALSE
		)

basefiles_wav <- list.files(path = basedir, pattern = "\\.wav$",
				all.files = TRUE, full.names = TRUE,
				recursive = TRUE, ignore.case = FALSE,
				include.dirs = FALSE, no.. = FALSE
		)

basefiles_aif <- list.files(path = basedir, pattern = "\\.aif$",
				all.files = TRUE, full.names = TRUE,
				recursive = TRUE, ignore.case = FALSE,
				include.dirs = FALSE, no.. = FALSE
		)
basefiles_aiff <- list.files(path = basedir, pattern = "\\.aiff$",
				all.files = TRUE, full.names = TRUE,
				recursive = TRUE, ignore.case = FALSE,
				include.dirs = FALSE, no.. = FALSE
		)

basefile01 <- c(basefiles_flac,
		basefiles_wav,
		basefiles_aif,
		basefiles_aiff
	)

basefile02 <- basefile01[basefileindex]

targetfile <- gsub(basedir, targetdir, basefile02, ignore.case = FALSE,
		perl = FALSE, fixed = FALSE, useBytes = FALSE
	)

formatfn <- function(x01){
	substr(x01, 1, nchar(x01)-4)
}

filemd <- paste(formatfn(targetfile), "md", sep = "", collapse = NULL)
filepng <- paste(formatfn(targetfile), "png", sep = "", collapse = NULL)

logfn(0,sttimedatecode,filemd,"start time ")

flacfn <- function(n,x,k){
		sttimedateflac <- Sys.time()
		sttimeunixflac <- as.numeric(sttimedateflac)

		argsvector <- c("-l",
				"0",
				"--disable-constant-subframes",
				"--disable-fixed-subframes",
				"--no-preserve-modtime",
				"-V",
				"-o",
				x,
				n
				)
		
			exec_wait("/usr/local/bin/flac",
			args = argsvector,
			std_out = TRUE,
			std_err = FALSE,
			std_in = NULL,
			timeout = 0
		)
		finishtimedateflac <- Sys.time()
		finishtimeunixflac <- as.numeric(finishtimedateflac)
		flacproctime0 <- finishtimeunixflac - sttimeunixflac
		flacproctime <- paste(gsub("Time difference of ","",flacproctime0),
				" seconds",
				sep = "",
				collapse = NULL
				)
		logfn(1,sttimedateflac,k,"flac encode start time ")
		logfn(1,finishtimedateflac,k,"flac encode finish time ")
		logfn(1,flacproctime,k,"flac encode process time ")
		
#		mapply(logfn,
#			c(1,startflac,k,"flac encode start time "),
#			c(1,finishflac,k,"flac encode finish time "),
#			c(1,flacproctime,k,"flac encode process time ")
#		)
#
#		mapply(logfn,
#			list(c(1,1,1)),
#			list(c(startflac,finishflac,flacproctime)),
#			list(c(k,k,k)),
#			list(c("flac encode start time ",
#				"flac encode finish time ",
#				"flac encode process time "
#			))
#		)
}

flacfn(basefile02,targetfile,filemd)

#ffmpegspectrum <- function(x,n,k){
#		startffmpeg < Sys.time()
#
#		argsffmpeg <- c("-nostdin",
#				"-i",
#				x,
#				"-lavfi",
#				"showspectrumpic",
#				n
#			)
#		exec_wait("/usr/bin/ffmpeg",
#			args = argsffmpeg,
#			std_out = FALSE,
#	                std_err = FALSE,
#	                std_in = NULL,
#			timeout = 0
##		)
##		finishffmpeg <- Sys.time()
##		ffmpegproctime <- finishffmpeg - startffmpeg
##		mapply(logfn,
##			c(1,1,1),
##			c(startffmpeg,finishffmpeg,ffmpegproctime),
##			c(k,k,k)
##		)
##}
##
##ffmpegspectrum(targetfile,filepng,filemd)
##
##exiftoolfn <- function(e,k){
##		startexiftool <- Sys.time()
##
##		argsexiftool <- c("-a",
##				"-G1",
##				"-s",
##				e
##				)
##		exec_wait("/usr/bin/exiftool",
##			args = argsexiftool,
##			std_out = k,
##	               	std_err = FALSE,
##	               	std_in = NULL,
##			timeout = 0
##		)
##		finishexiftool <- Sys.time()
##		exiftoolproctime <- finishexiftool - startexiftool
##		mapply(logfn,
##			c(1,1,1),
##			c(startffmpeg,finishffmpeg,ffmpegproctime),
##			c(k,k,k)
##		)
##}
#
##exiftoolfn(targetfile,filemd)
#
#finishcode <- Sys.time()
#codeproctime <- finishcode - startcode
#
#mapply(logfn,
#	c(1,1),
#	c(finishcode,codeproctime),
#	c(filems,filemd)
#)
