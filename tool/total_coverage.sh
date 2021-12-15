cd package/fda_mystudies_http_client
flutter test --coverage --coverage-path ../../coverage/fda_mystudies_http_client.base.info
cd ../fda_mystudies_activity_ui_kit
flutter test --coverage --coverage-path ../../coverage/fda_mystudies_activity_ui_kit.base.info
cd ../..
flutter test --coverage
sed 's/:lib\//:package\/fda_mystudies_http_client\/lib\//g' coverage/fda_mystudies_http_client.base.info > coverage/http_client.base.info
sed 's/:lib\//:package\/fda_mystudies_activity_ui_kit\/lib\//g' coverage/fda_mystudies_activity_ui_kit.base.info > coverage/activity_ui_kit.info
rm coverage/fda_mystudies_http_client.base.info
rm coverage/fda_mystudies_activity_ui_kit.base.info
lcov -a coverage/lcov.info -a coverage/http_client.base.info -a coverage/activity_ui_kit.info -o coverage/total_coverage.info
genhtml --prefix $PWD coverage/total_coverage.info --output-directory out
