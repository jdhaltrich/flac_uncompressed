# flac encoding

## description

Short program to encode FLAC, WAV and AIFF lossless audio files under
a directory tree to FLAC uncompressed.
Source audio files can be either compressed or already uncompressed
in which case the program will only reencode the source and perform
its other operations.

The program creates a bare copy of the original directory tree in a new one
followed by the actual encoding of the files, by calling the system FLAC
command line encoder using the sys package. Then it calls FFmpeg to run an
spectrogram, and finally ExifTool to extract metadata in a textfile, also
using the mentioned sys library.


[source files] (./src)

