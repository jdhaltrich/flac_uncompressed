library(sys)

codearguments <- commandArgs(trailingOnly = TRUE)

rootdir <- print(codearguments[1], quote = TRUE)
basedir <- paste(rootdir, codearguments[2], sep = "", collapse = NULL)
targetdir <- paste(rootdir, codearguments[3], sep = "", collapse = NULL)
#logdir <- paste(targetdir, "/logs", sep = "", collapse = NULL)

basefileindex <- as.numeric(codearguments[4])
spectrogramoption <- as.numeric(codearguments[5])

#writefn <- function(x,w){
#    write(x,
#        file = paste(x, "/", w, sep = "", collapse = NULL),
#        ncolumns = 1,
#        append = FALSE,
#        sep = ""
#    )
#}

basefiles_flac <- list.files(
                path = basedir,
                pattern = "\\.flac$",
                all.files = TRUE,
                full.names = TRUE,
                recursive = TRUE,
                ignore.case = FALSE,
                include.dirs = FALSE,
                no.. = FALSE
        )
basefiles_wav <- list.files(
                path = basedir,
                pattern = "\\.wav$",
                all.files = TRUE,
                full.names = TRUE,
                recursive = TRUE,
                ignore.case = FALSE,
                include.dirs = FALSE,
                no.. = FALSE
        )
basefiles_aif <- list.files(
                path = basedir,
                pattern = "\\.aif$",
                all.files = TRUE,
                full.names = TRUE,
                recursive = TRUE,
                ignore.case = FALSE,
                include.dirs = FALSE,
                no.. = FALSE
        )
basefiles_aiff <- list.files(
                path = basedir,
                pattern = "\\.aiff$",
                all.files = TRUE,
                full.names = TRUE,
                recursive = TRUE,
                ignore.case = FALSE,
                include.dirs = FALSE,
                no.. = FALSE
        )

basefiles01 <- c(basefiles_flac,
		basefiles_wav,
		basefiles_aif,
		basefiles_aiff
	)


basefile02 <- basefiles01[basefileindex]

rm(
basefiles_flac,
basefiles_wav,
basefiles_aif,
basefiles_aiff,
basefiles01,
indexfile,
basefileindex
)

targetfile <- gsub(basedir, targetdir, basefile02, ignore.case = FALSE,
		perl = FALSE, fixed = FALSE, useBytes = FALSE
	)

targetfiledir <- sub("/[^/]*$", "",targetfile)
targetfilelogdir <- paste(targetfiledir, "/logs", sep = "", collapse = NULL)
targetfilespectrogramsdir <- paste(targetfiledir, "/spectrograms", sep = "", collapse = NULL)
targetfilename <- sub(".*\\/", "", targetfile)

formatfn <- function(x01){
    filename <- substr(x01, 1, nchar(x01)-4)
    format <- substr(x01, nchar(x01)-4+1, nchar(x01))
    filename <- if (format == ".wav") {
                substr(x01, 1, nchar(x01)-3)
                } else if (format == ".aif") {
                substr(x01, 1, nchar(x01)-3)
                }
    format <- if (format == ".wav") {
                gsub("\\.","",format)
                } else if (format == ".aif") {
                gsub("\\.","",format)
                }
    c(filename,format)
}

filemd <- paste(targetfilelogdir,"/",formatfn(targetfilename)[1], "md", sep = "", collapse = NULL)
filepng <- paste(targetfilespectrogramsdir,"/",formatfn(targetfilename)[1], "png", sep = "", collapse = NULL)
fileflac <- paste(targetfiledir,"/",formatfn(targetfilename)[1], "flac", sep = "", collapse = NULL)
fileformat <- formatfn(targetfilename)[2]

#baselogfilename <- "basefilepath.md"
#targetlogfilename <- "targetfilepath.md"

#writefn(logdir,baselogfilename)
#writefn(logdir,targetlogfilename)

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
                    c("-l",
                    "0",
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

flacfn(basefile02,fileflac,fileformat)

spectrogramfn <- function(x,n){
        argsffmpeg <- c(
                        "-nostdin",
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

if (spectrogramoption == 1) {
spectrogramfn(fileflac,filepng)
}

exiftoolfn <- function(e,k){
        argsexiftool <- c(
                        "-a",
                        "-G1",
                        "-s",
                        e
                        )
        exec_wait(
                "/usr/bin/exiftool",
                args = argsexiftool,
                std_out = k,
                std_err = FALSE,
                std_in = NULL,
                timeout = 0
        )
}

exiftoolfn(fileflac,filemd)
