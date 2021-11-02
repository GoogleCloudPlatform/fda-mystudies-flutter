cd package/fda_mystudies_http_client
flutter test --coverage --coverage-path ../../coverage/fda_mystudies_http_client.base.info
cd ../..
flutter test --coverage
sed 's/:lib\//:package\/fda_mystudies_http_client\/lib\//g' coverage/fda_mystudies_http_client.base.info > coverage/http_client.base.info
rm coverage/fda_mystudies_http_client.base.info
lcov -a coverage/lcov.info -a coverage/http_client.base.info -o coverage/total_coverage.info
genhtml --prefix $PWD coverage/total_coverage.info --output-directory out