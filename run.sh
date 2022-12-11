#!/bin/bash

for i in  h2_absolute_redirect h2_auth_request h2_fastcgi_request_buffering h2_headers h2_keepalive h2_limit_conn h2_limit_req h2_priority h2_request_body_extra h2_request_body_preread h2_request_body h2_server_push h2_server_tokens h2_trailers h2_variables h2
do
    echo " Start OF : $i"
    firefox /home/0x34d/Project/Core/code/data/$i/coverage/output/home/0x34d/Project/nginx/src/http/v2/ngx_http_v2.c.gcov.frameset.html

done
