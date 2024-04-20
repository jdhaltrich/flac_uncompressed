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

targetspectrogramsdirs <- paste(structdir02_b, rep("/spectrograms",
                        times = length(structdir02_b)), sep = "",
                        collapse = NULL
                )

lapply(1:length(targetspectrogramsdirs),
        function(k) {
                dir.create(path = targetspectrogramsdirs[k], showWarnings = TRUE,
                                recursive = TRUE, mode = "0755"
                )
        }
)
