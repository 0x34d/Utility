#tshark -r in.pcap -q -z follow,tcp,raw,0 > f
#!(tcp.srcport == 8080 && http2) && !(http2.magic) &&  !(http2.flags.ack.settings)
#!(tcp.srcport == 8080 && http2)  && !(http2.magic) &&  !(http2.flags.ack.settings) && !(http2.header) && http2

infile=man.pcap
outfile=out
ext=raw
for stream in $(tshark -nlr $infile -Y tcp.flags.syn==1 -T fields -e tcp.stream | sort -n | uniq | sed 's/\r//')
do
    echo "Processing stream $stream: ${outfile}_${stream}.${ext}"
    tshark -nlr $infile -qz "follow,tcp,raw,$stream" | tail -n +7 | sed 's/^\s\+//g' | xxd -r -p > ${outfile}_${stream}.${ext}
    dd if=${outfile}_${stream}.${ext} of=save/eq_${stream}.${ext} bs=1 skip=35
    rm ${outfile}_${stream}.${ext}
done

