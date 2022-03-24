#!/bin/sh
#tshark -r in.pcap -q -z follow,tcp,raw,0 > f

infile=input.pcap
outfile=out
ext=raw
for stream in $(tshark -nlr $infile -Y tcp.flags.syn==1 -T fields -e tcp.stream | sort -n | uniq | sed 's/\r//')
do
    echo "Processing stream $stream: ${outfile}_${stream}.${ext}"
    tshark -nlr $infile -qz "follow,tcp,raw,$stream" | tail -n +7 | sed 's/^\s\+//g' | xxd -r -p > ${outfile}_${stream}.${ext}
done

