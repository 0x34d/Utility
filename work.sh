#!/bin/bash
export ASAN_OPTIONS=detect_leaks=0
mkdir data
mkdir save
lcov --zerocounters  --directory nginx/
rm -rf coverage.info output/

for i in  h2_absolute_redirect h2_auth_request h2_fastcgi_request_buffering h2_headers h2_keepalive h2_limit_conn h2_limit_req h2_priority h2_request_body_extra h2_request_body_preread h2_request_body h2_server_push h2_server_tokens h2_trailers h2_variables h2
do
    echo " Start OF : $i"
    mkdir data/$i

    cd nginx-tests
    prove -v ./$i.t

    cd ../
    mv save/nginx-test* data/$i/conf

    #lcov --no-external --capture --directory nginx/ --output-file coverage.info
    lcov --directory nginx/ --base-directory nginx/ --gcov-tool llvm-gcov.sh --capture -o coverage.info
    genhtml --frames --prefix nginx/ --ignore-errors Source coverage.info --output-directory=output/
    lcov --zerocounters  --directory nginx/

    mkdir data/$i/coverage
    mv output/ data/$i/coverage/.
    mv coverage.info data/$i/coverage/.

    sudo pkill tcpdump
    sudo mv input.pcap data/$i/$i.pcap
    sleep 5
    clear
done
