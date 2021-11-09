import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/participant_consent_datastore_service.dart';
import 'package:fda_mystudies_spec/participant_consent_datastore_service/get_consent_document.pbserver.dart';
import 'package:fda_mystudies_spec/participant_consent_datastore_service/update_eligibility_consent_status.pbserver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ParticipantConsentDatastoreService? participantConsentDatastoreService;
  final config = DemoConfig();

  setUpAll(() {
    configureDependencies(config);
    participantConsentDatastoreService =
        getIt<ParticipantConsentDatastoreService>();
  });

  group('get consent document tests', () {
    test('test default scenario', () async {
      var response = await participantConsentDatastoreService!
          .getConsentDocument('userId', 'authToken', 'studyId');

      expect(
          response,
          GetConsentDocumentResponse()
            ..message = 'success'
            ..sharing = 'Provided'
            ..consent = (GetConsentDocumentResponse_ConsentDocument()
              ..version = '1.1'
              ..type = 'application/pdf'
              ..content =
                  'JVBERi0xLjQKJcKlwrHDqwoxIDAgb2JqCjw8L1R5cGUvUGFnZXMvS2lkc1s0IDAgUl0vQ291bnQgMT4+CmVuZG9iagoyIDAgb2JqCjw8L0Rlc3RzPDw+Pj4+CmVuZG9iagozIDAgb2JqCjw8L1R5cGUvQ2F0YWxvZy9WZXJzaW9uLzEuNy9QYWdlcyAxIDAgUi9OYW1lcyAyIDAgUi9QYWdlTW9kZS9Vc2VOb25lPj4KZW5kb2JqCjQgMCBvYmoKPDwvVHlwZS9QYWdlL1Jlc291cmNlczw8L1Byb2NTZXRbL1BERi9UZXh0L0ltYWdlQi9JbWFnZUNdL0ZvbnQ8PC9GNiA2IDAgUj4+Pj4vUGFyZW50IDEgMCBSL01lZGlhQm94WzAgMCA1OTUuMjc1NTkgODQxLjg4OTc2XS9Db250ZW50cyA1IDAgUj4+CmVuZG9iago1IDAgb2JqCjw8L0ZpbHRlci9GbGF0ZURlY29kZS9MZW5ndGggMTMwPj5zdHJlYW0KeJwzUAgp4jJQAMGidC6nEAVTMz0zSyNLQwVzcxM9AyMTC1OFkBQFfTczBUMjhZA0oNqQZBBRzmVoAKSqQOxirmiNkNTiEs3YEC8F1xCQMRbGesZmFqQb45yfV5yah2ySobGhnjE5LkrJTy7NBZqlCDMM4s0gdy4DPTOFci4A6O85wAplbmRzdHJlYW0KZW5kb2JqCjYgMCBvYmoKPDwvVHlwZS9Gb250L1N1YnR5cGUvVHlwZTEvTmFtZS9GNi9FbmNvZGluZy9XaW5BbnNpRW5jb2RpbmcvQmFzZUZvbnQvSGVsdmV0aWNhPj4KZW5kb2JqCnhyZWYKMCA3CjAwMDAwMDAwMDAgNjU1MzUgZiAKMDAwMDAwMDAxNyAwMDAwMCBuIAowMDAwMDAwMDY4IDAwMDAwIG4gCjAwMDAwMDAwOTggMDAwMDAgbiAKMDAwMDAwMDE4NCAwMDAwMCBuIAowMDAwMDAwMzQxIDAwMDAwIG4gCjAwMDAwMDA1MzggMDAwMDAgbiAKdHJhaWxlcgo8PC9TaXplIDcvUm9vdCAzIDAgUi9JRFs8MzE2OGMyNGM2ZTFjNTNmYmEzMzI1ODhlMjM3YWUwMzQ4MGVkNWE5ZWNlOTMzMWNlMmI1OWQyNzk1MTIzNDY0OD48MzE2OGMyNGM2ZTFjNTNmYmEzMzI1ODhlMjM3YWUwMzQ4MGVkNWE5ZWNlOTMzMWNlMmI1OWQyNzk1MTIzNDY0OD5dPj4Kc3RhcnR4cmVmCjYzNAolJUVPRgo='));
    });
  });

  group('update eligibility and consent status tests', () {
    test('test default scenario', () async {
      var response = await participantConsentDatastoreService!
          .updateEligibilityAndConsentStatus('userId', 'authToken', 'studyId',
              'siteId', 'consentVersion', 'base64Pdf', 'userDataSharing');

      expect(
          response,
          UpdateEligibilityConsentStatusResponse()
            ..code = 200
            ..message = 'success'
            ..consentDocumentFileName = 'test_consent_doc');
    });
  });
}
