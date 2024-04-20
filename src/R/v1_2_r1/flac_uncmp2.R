library(sys)

rootdir <- "/users/juancho_gentoo/test/flac"
basedir <- paste(rootdir, "/a", sep = "", collapse = NULL)
targetdir <- paste(rootdir, "/b", sep = "", collapse = NULL)
logdir <- paste(targetdir, "/logs", sep = "", collapse = NULL)

start00 <- Sys.time()

structdir01 <- list.dirs(path = basedir, full.names = TRUE, recursive = TRUE)
structdir02 <- gsub(basedir, targetdir, structdir01, ignore.case = FALSE,
			perl = FALSE, fixed = FALSE, useBytes = FALSE
		)

lapply(1:length(structdir02),
	function(k) {
		dir.create(path = structdir02[k], showWarnings = TRUE,
			recursive = TRUE, mode = "0755"
		)
	}
)

if(!dir.exists(path = logdir)) {
	dir.create(path = logdir, showWarnings = TRUE, recursive = TRUE,
		mode = "0755"
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

basefiles <- c(basefiles_flac,
		basefiles_wav,
		basefiles_aif,
		basefiles_aiff
	)

targetfiles <- gsub(basedir, targetdir, basefiles, ignore.case = FALSE,
		perl = FALSE, fixed = FALSE, useBytes = FALSE
	)

structdir02_b <- structdir02[2:length(structdir02)]

targetlogdirs <- paste(structdir02_b, rep("/logs",
			times = length(structdir02_b)), sep = "",
			collapse = NULL
		)

lapply(1:length(targetlogdirs),
        function(k) {
		dir.create(path = targetlogdirs[k], showWarnings = TRUE,
				recursive = TRUE, mode = "0755"
		)
        }
)

flacfn <- function(n){
		argsvector <- c("-l",
				"0",
				"--disable-constant-subframes",
				"--disable-fixed-subframes",
				"--no-preserve-modtime",
				"-V",
				"-o",
				targetfiles[n],
				basefiles[n]
				)
		
		exec_wait("/usr/local/bin/flac",
			args = argsvector,
			std_out = stdout(),
			std_err = stderr(),
			std_in = NULL,
			timeout = 0
		)
	}


flacfn2 <- function(n){
		argsvector <- c("-l",
				"0",
				"--disable-constant-subframes",
				"--disable-fixed-subframes",
				"--no-preserve-modtime",
				"-V",
				"-o",
				targetfiles[n],
				basefiles[n]
				)
		
		exec_background("/usr/local/bin/flac",
			args = argsvector,
			std_out = TRUE,
			std_err = TRUE,
			std_in = NULL
		)
	}



lapply(1:length(targetfiles),
flacfn
)

ffmpegspectrum <- function(n){
		x01 <- targetfiles[n]
		x02 <- function(x01){
			substr(x01, 1, nchar(x01)-4)
		}
		x03 <- paste(x02(x01), "png", sep = "", collapse = NULL)

		argsffmpeg <- c("-nostdin",
				"-i",
				x01,
				"-lavfi",
				"showspectrumpic",
				x03
			)
		exec_wait("/usr/bin/ffmpeg",
			args = argsffmpeg,
			std_out = stdout(),
	                std_err = stderr(),
	                std_in = NULL,
			timeout = 0
		)
}

ffmpegspectrum2 <- function(n){
		x01 <- targetfiles[n]
		x02 <- function(x01){
			substr(x01, 1, nchar(x01)-4)
		}
		x03 <- paste(x02(x01), "png", sep = "", collapse = NULL)

		argsffmpeg <- c("-nostdin",
				"-i",
				x01,
				"-lavfi",
				"showspectrumpic",
				x03
			)
		exec_background("/usr/bin/ffmpeg",
			args = argsffmpeg,
			std_out = FALSE,
	                std_err = FALSE,
	                std_in = NULL
		)
}

lapply(1:length(targetfiles),
ffmpegspectrum
)

exiftoolfn <- function(e){
		x01 <- targetfiles[e]
		x02 <- function(x01){
			substr(x01, 1, nchar(x01)-4)
		}
		x03 <- paste(x02(x01), "md", sep = "", collapse = NULL)

		argsexiftool <- c("-a",
				"-G1",
				"-s",
				x01,
				">",
				x03
			)
		exec_wait("/usr/bin/exiftool",
			args = argsexiftool,
			std_out = stdout(),
	                std_err = stderr(),
	                std_in = NULL,
			timeout = 0
		)
}

lapply(1:length(targetfiles),
exiftoolfn
)
