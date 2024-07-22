# Video Transcoder Bash Script

This repository contains an old bash script used to transcode videos into formats compatible with various devices such as iPad, iPhone, and PS3. The script is no longer in use and is kept here solely for archival purposes.

## Features

- Transcode videos to formats compatible with:
  - iPad
  - iPhone
  - PS3
- Supports various transcoding profiles
- Allows specification of start time and duration for transcoding

## Usage

To use the script, execute the following command in your terminal:

```bash
./transcode.sh [options] input_file output_file
```

Replace `input_file` with the path to your video file and `output_file` with the desired output path. The script also accepts the following optional parameters:

- `-p profile`: Specify the profile to be used for transcoding.
- `-t 0:0:0.0`: Set the timestamp for the transcoding stop time.
- `-ss 0:0:0.0`: Set the timestamp for the transcoding start time.

### Example

```bash
./2ps3.sh -p ps3 -t 0:0:10.0 -ss 0:5:0.0 input.mp4 output.mp4
```

## Supported Profiles

- `copy`: Copies the input video and audio streams without re-encoding.
- `mpegts`: Transcodes to MPEG-TS format.
- `mpg2`: Transcodes to MPEG-2 format with MP2 audio.
- `mpegtshd`: Transcodes to MPEG-TS HD format with AAC audio.
- `ps3`: Transcodes with settings optimized for PS3.
- `x264`: Transcodes using x264 codec with custom settings.
- `lossless`: Transcodes using x264 lossless settings with ALAC audio.
- `iphone`: Transcodes with settings optimized for iPhone.
- `mms`: Transcodes with settings suitable for MMS.
- `ipad`: Transcodes with settings optimized for iPad.
- `nosound`: Transcodes video without audio.

## Requirements

- Bash
- FFmpeg (or any other transcoding tool specified in the script)

## Script Explanation

The script processes the input and output file names, handles optional parameters for profile, start time, and length, and executes FFmpeg commands based on the specified profile.

### Key Sections

1. **Parameter Parsing:**
   The script parses input parameters and assigns them to variables for later use.

2. **Offset and Length Conversion:**
   The script converts the `offset` (start time) and `length` (duration) from `HH:MM:SS.SSS` format to seconds.

3. **Profile-Based Settings:**
   The script sets FFmpeg command options based on the specified `profile` parameter. Each profile corresponds to different FFmpeg settings and output file formats.

4. **Executing FFmpeg Command:**
   The script constructs and executes the FFmpeg command with the selected options and parameters.

## License

This project is licensed under the GNU General Public License v3.0. See the [LICENSE](LICENSE) file for details.

## Acknowledgements

Special thanks to all contributors and users who have used and improved this script over time.

---

**Disclaimer:** This script is kept for archival purposes only and is not intended for production use. Use at your own risk.
