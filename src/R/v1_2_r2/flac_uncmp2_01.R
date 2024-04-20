library(sys)

codearguments <- commandArgs(trailingOnly = TRUE)

rootdir <- print(codearguments[1], quote = TRUE)
basedir <- paste(rootdir, codearguments[2], sep = "", collapse = NULL)
targetdir <- paste(rootdir, codearguments[3], sep = "", collapse = NULL)
spectrograms_switch <- as.numeric(codearguments[4])
flac_convertion_R <- print(codearguments[5], quote = TRUE)
batchfilename <- print(codearguments[6], quote =TRUE)

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

targetfiles <- gsub(basedir, targetdir, basefiles01, ignore.case = FALSE,
        perl = FALSE, fixed = FALSE, useBytes = FALSE
    )

targetfilesdir <- unique(sub("/[^/]*$", "",targetfiles), incomparables = FALSE)

targetlogdirs <- paste(
            targetfilesdir,
			rep("/logs",
			times = length(targetfilesdir)), sep = "",
			collapse = NULL
		)

lapply(1:length(targetlogdirs),
        function(k) {
		dir.create(
			path = targetlogdirs[k],
			showWarnings = TRUE,
			recursive = TRUE,
			mode = "0755"
		)
        }
)

targetspectrogramsdirs <- paste(targetfilesdir, rep("/spectrograms",
                        times = length(targetfilesdir)), sep = "",
                        collapse = NULL
                )

lapply(1:length(targetspectrogramsdirs),
        function(k) {
                dir.create(path = targetspectrogramsdirs[k],
			showWarnings = TRUE,
			recursive = TRUE,
			mode = "0755"
                )	
        }
)

filecount <- length(targetfiles)

lapply(1:filecount,
    function(k){
        string <- paste(
                    "R --no-save CMD BATCH '--args ",
                    paste("'",rootdir,"' ",sep = ""),
                    paste("'",codearguments[2],"' ",sep = ""),
                    paste("'",codearguments[3],"' ",sep = ""),
                    paste(k," ",sep = ""),
                    paste(spectrograms_switch,"' ",sep = ""),
                    flac_convertion_R,
                    sep = ""
                )
        if (k == 1) {
        write(string,batchfilename,ncolumns = 1,append = FALSE, sep = "\n")
        } else {
        write(string,batchfilename,ncolumns = 1,append = TRUE, sep = "\n")
        }
    }
)
