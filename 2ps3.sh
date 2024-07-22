#!/bin/bash

#echo $1 | sed \
#  -e 's/\//\\\//g' \
#  -e 's/\&/\\\&/g'
  


#echo
#echo $1
#echo 2\ \ 7


while test $# != 0
do case "$1" in
        -ss)    shift; offset="$1";;
        -t)     shift; lenght="$1";;
#       -l)     shift; opt="$opt -l $1" ;;
        -p)     shift; profile="$1";;
		 *)		#echo ${infile};
		 if [[ opt=$1 =~ ^-.* ]];
		 	then echo "invalid option $1"; exit;
		 else
			if [ ! "${infile}" ];
				then infile=$1;
		 	else outfile=$1; fi; fi ;;
esac
shift
done

if [ ! "${infile}" ]; then echo "no infile"; exit; fi
if [ ! "${outfile}" ]; then outfile="${infile}"; fi;
if [ ${offset} ]; then offset="${offset}"; fi;
if [ ${lenght} ]; then lenght="${lenght}"; fi;

#echo "${infile}" | sed -e 's/ /\\ /g'
#einfile=`echo "${infile}" | sed -e 's/ /\\ /g'`
#infile=$(echo "${infile}" | sed -e 's/ /\\ /g' -e 's/\//\\\//g')
echo
echo ${infile}
#  -e 's/\&/\\\&/g'

name=$(echo "${outfile}" | sed -e 's/^\(.*\)\.\(.*\)$/\1/g')
ext=$(echo "${outfile}" | sed -e 's/^\(.*\)\.\(.*\)$/\2/g')

if [ ${offset} ];
then
echo "${offset}"
	start_h=$(echo "${offset}" | sed -e 's/^\(.*\)\:\(.*\)\:\(.*\)\.\(.*\)$/\1/g')
	start_m=$(echo "${offset}" | sed -e 's/^\(.*\)\:\(.*\)\:\(.*\)\.\(.*\)$/\2/g')
	start_s=$(echo "${offset}" | sed -e 's/^\(.*\)\:\(.*\)\:\(.*\)\.\(.*\)$/\3/g')
	start_c=$(echo "${offset}" | sed -e 's/^\(.*\)\:\(.*\)\:\(.*\)\.\(.*\)$/\4/g')
	echo start_h: $start_h;	echo start_m: $start_m;	echo start_s: $start_s;	echo start_c: $start_c;

	start_m=$(echo "$start_m*60" | bc -q )
	start_h=$(echo "$start_h*3600" | bc -q )
	offset=$(echo "$start_m+$start_h+$start_s" | bc -q ).${start_c}
	echo $start_m;	echo $start_h;	echo $offset;
	offset_str="-ss ${offset}"
else
	offset=0.000
fi;


if [ ${lenght} ];
then
	end_h=$(echo "${lenght}" | sed -e 's/^\(.*\)\:\(.*\)\:\(.*\)\.\(.*\)$/\1/g')
	end_m=$(echo "${lenght}" | sed -e 's/^\(.*\)\:\(.*\)\:\(.*\)\.\(.*\)$/\2/g')
	end_s=$(echo "${lenght}" | sed -e 's/^\(.*\)\:\(.*\)\:\(.*\)\.\(.*\)$/\3/g')
	end_c=$(echo "${lenght}" | sed -e 's/^\(.*\)\:\(.*\)\:\(.*\)\.\(.*\)$/\4/g')
	echo end_h: $end_h;	echo end_m: $end_m;	echo end_s: $end_s;	echo end_c: $end_c;

	end_m=$(echo "$end_m*60" | bc -q )
	end_h=$(echo "$end_h*3600" | bc -q )
	lenght=$(echo "$end_m+$end_h+$end_s" | bc -q ).${end_c}
	echo end_h: $end_h;	echo end_m: $end_m;	echo $lenght;

	lenght=$(echo "$lenght-$offset" | bc -q )
	echo $lenght
	lenght_str="-t ${lenght}"
fi

echo
echo "ext : $ext"
echo
outfile="${name}.2.mov"


app="/cygdrive/c/bin/ffmpeg_cuda.2.exe -threads 0"

#cv="-c:v libx264 -level 30 -q:v 2 -preset ultrafast"
#  -profile high -s hd720 -sws_flags fast_bilinear -deinterlace


cv="-c:v copy"
ca="-c:a copy"
mapa="-map 0:a"
mapv="-map 0:v"

# http://ffmpeg.org/ffmpeg.html#Video-Options
# http://mewiki.project357.com/wiki/X264_Settings
# profile : baseline, main, high, high10, high422, high444
# preset : ultrafast, superfast, veryfast, faster, fast, medium, slow, slower, veryslow, placebo
# tune : film, animation, grain, stillimage, psnr, ssim, fastdecode, zerolatency


# mpgts in
if [ "${profile}" == "copy" ];
then
	outfile=${name}.2.mp4 #${ext}
fi;
# mpgts in
if [ "${profile}" == "mpegts" ];
then
	outfile=${name}.2.mpg #${ext}
fi;
# mpgts in
if [ "${profile}" == "mpg2" ];
then
	ca="-c:a mp2 -b:a 192k" # libmp3lame
	outfile=${name}.2.mpg #${ext}
fi;

# mpegts HD
if [ "${profile}" == "mpegtshd" ];
then
	ca="-c:a aac -b:a 160k -strict -2"
	outfile=${name}.mp4
fi;

# ps3 settings
if [ "${profile}" == "ps3" ];
then
	cv="-c:v libx264 -level 41 -crf 20 -preset ultrafast" # -q:v 2  ultrafast
	ca="-c:a aac -b:a 160k -strict -2"
	outfile=${name}.2.mp4
fi;

# x264 settings
if [ "${profile}" == "x264" ];
then
#	cv="-c:v libx264 -level 41 -q:v 2 -preset ultrafast"
	cv="-c:v libx264 -level 41 -crf 17 " #-preset fast  "
	ca="-c:a aac -b:a 160k -strict -2"
	outfile=${name}.2.mp4
fi;

# x264 lossless settings
if [ "${profile}" == "lossless" ];
then
	cv="-c:v libx264 -cqp 0 " #-preset fast -crf 15 "
	ca="-c:a alac"
	outfile=${name}.2.mov
fi;

# iphone settings
if [ "${profile}" == "iphone" ];
then
#	cv="-c:v libx264 -level 41 -q:v 2 -preset ultrafast"
	cv="-c:v libx264 -level 31 -crf 25 -s 720x576  -r 25" #-preset fast -crf 15 "
	ca="-c:a aac -b:a 160k -strict -2"
	outfile=${name}.2.mov
fi;

# iphone settings
if [ "${profile}" == "mms" ];
then
#	cv="-c:v libx264 -level 41 -q:v 2 -preset ultrafast"
	cv="-c:v libx264 -level 31 -crf 25 -s 720x576" #-preset fast -crf 15 "
	ca="-c:a aac -b:a 160k -strict -2"
	outfile=${name}.2.mp4
fi;

# iphone settings
if [ "${profile}" == "ipad" ];
then
#	cv="-c:v libx264 -level 41 -q:v 2 -preset ultrafast"
	cv="-c:v libx264 -level 31 -crf 25 -s 1280x720" #-preset fast -crf 15 "
	ca="-c:a aac -b:a 160k -strict -2"
	outfile=${name}.2.mov
fi;

# iphone settings
if [ "${profile}" == "nosound" ];
then
#	cv="-c:v libx264 -level 41 -q:v 2 -preset ultrafast"
#	cv="-c:v libx264 -level 31 -crf 25 -s 1280x720" #-preset fast -crf 15 "
#	ca="-c:a null"
	mapa=""
	outfile=${name}.2.mov
fi;


# cs="-i \"${subfile}\" -c:s copy" #

# -map 0:a
#${app} -i "$infile" -map 0:v -map 0:a:0 ${cv} ${ca} ${cs} ${offset_str} ${lenght_str} "$outfile" ;
${app} -stats -v verbose -v error -v fatal -i "$infile" ${mapv} ${mapa} ${cv} ${ca} ${cs} ${offset_str} ${lenght_str} "$outfile" ;
#cmd="${app} -i \"$infile\" -map 0:v -map 0:a:1 ${cv} ${ca} ${cs} ${offset_str} ${lenght_str} \"${outfile}\" ;"
echo
#echo $cmd
echo
#exec $cmd

