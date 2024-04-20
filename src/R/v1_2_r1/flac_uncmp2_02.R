library(sys)

rootdir <- "/users/juancho_gentoo/test/flac"
basedir <- paste(rootdir, "/a", sep = "", collapse = NULL)
targetdir <- paste(rootdir, "/b", sep = "", collapse = NULL)
logdir <- paste(targetdir, "/logs", sep = "", collapse = NULL)

indexfile <- as.numeric(commandArgs(trailingOnly = TRUE))
basefileindex <- indexfile
targetfileindex <- indexfile

writefn <- function(x,w){
	write(x,
		file = paste(x, "/", w, sep = "", collapse = NULL),
		ncolumns = 1,
		append = FALSE,
		sep = ""
	)
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

basefiles01 <- c(basefiles_flac,
		basefiles_wav,
		basefiles_aif,
		basefiles_aiff
	)


basefile02 <- basefiles01[basefileindex]

targetfile <- gsub(basedir, targetdir, basefile02, ignore.case = FALSE,
		perl = FALSE, fixed = FALSE, useBytes = FALSE
	)

rm(basefiles_flac,
basefiles_wav,
basefiles_aif,
basefiles_aiff,
basefiles01,
indexfile,
basefileindex,
targetfileindex
)

formatfn <- function(x01){
	filepath_nofmt <- substr(x01, 1, nchar(x01)-4)
	filepath_wfmt <- substr(x01, nchar(x01)-4+1, nchar(x01))
	c(filepath_nofmt,filepath_wfmt)
}

filemd <- paste(formatfn(targetfile)[1], "md", sep = "", collapse = NULL)
filepng <- paste(formatfn(targetfile)[1], "png", sep = "", collapse = NULL)
fileformat <- gsub("\\.", "", formatfn(targetfile)[2], ignore.case = FALSE,
		perl = FALSE, fixed = FALSE, useBytes = FALSE
	)

baselogfilename <- "basefilepath.md"
targetlogfilename <- "targetfilepath.md"

writefn(logdir,baselogfilename)
writefn(logdir,targetlogfilename)

flacfn <- function(n,x,r){
			argsvector <- if (r == "flac") {
					c("-l",
					"0",
					"--disable-constant-subframes",
					"--disable-fixed-subframes",
					"--no-preserve-modtime",
					"-V",
					"-o",
					x,
					n
					)
				} else {
					c("-l","0",
					"--disable-constant-subframes",
					"--disable-fixed-subframes",
					"--no-preserve-modtime",
					"--keep-foreign-metadata",
					"-V",
					"-o",
					x,
					n
					)
			}
		
			exec_wait("/usr/local/bin/flac",
			args = argsvector,
			std_out = TRUE,
			std_err = FALSE,
			std_in = NULL,
			timeout = 0
		)
}

flacfn(basefile02,targetfile,fileformat)

ffmpegspectrum <- function(x,n){
		argsffmpeg <- c("-nostdin",
				"-i",
				x,
				"-lavfi",
				"showspectrumpic",
				n
			)
		exec_wait("/usr/bin/ffmpeg",
			args = argsffmpeg,
			std_out = FALSE,
	                std_err = FALSE,
	                std_in = NULL,
			timeout = 0
		)
}

ffmpegspectrum(targetfile,filepng)

exiftoolfn <- function(e,k){
		argsexiftool <- c("-a",
				"-G1",
				"-s",
				e
				)
		exec_wait("/usr/bin/exiftool",
			args = argsexiftool,
			std_out = k,
	               	std_err = FALSE,
	               	std_in = NULL,
			timeout = 0
		)
}

exiftoolfn(targetfile,filemd)
