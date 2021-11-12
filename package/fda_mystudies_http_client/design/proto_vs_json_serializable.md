# Why Protocol Buffers over JsonSerializable package?

In the [Json and Serialization](https://flutter.dev/docs/development/data-and-backend/json) section in flutter documentation, `json_serializable` and `json_annotation` are mentioned as the solution for serializing json string to dart objects. But using dart classes with json_serializable has a major disadvantage in preserving request/response json specs, in that dart doesn't allow nested classes -- for representing nested json objects, we need to create a separate file (ideally) for each entity. As opposed to this in proto specs all entities in a single request/response can be presented conisely in a single file.

For instance let's consider `GetUserProfileResponse`:

```json
{
  "message": "success",
  "profile": {
    "emailId": "tester@fda-mystudies.com"
  },
  "settings": {
    "localNotifications": true,
    "passcode": false,
    "remoteNotifications": true,
    "touchId": false
  }
}
```

## The JsonSerializable way

In the JsonSerializable way we need to write 3 classes to accomplish this.

```dart
// UserProfileSettings.dart

import 'package:json_annotation/json_annotation.dart';

part 'UserProfileSettings.g.dart';

@JsonSerializable()
class UserProfileSettings {
  final bool localNotifications;
  final String? locale;
  final bool passcode;
  final String? reminderLeadTime;
  final bool remoteNotifications;
  final bool touchId;

  UserProfileSettings(
    this.localNotifications,
    this.locale,
    this.passcode,
    this.reminderLeadTime,
    this.remoteNotifications,
    this.touchId
  );

  factory UserProfileSettings.fromJson(Map<String, dynamic> json) => _$UserProfileSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileSettingsToJson(this);
}
```

> Profile class
```dart
// UserProfile.dart

import 'package:json_annotation/json_annotation.dart';

part 'UserProfile.g.dart';

@JsonSerializable()
class UserProfile {
  final String emailId;

  UserProfile(this.emailId);

  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}
```

> GetUserProfileResponse class
```dart
// GetUserProfileResponse.dart

import 'package:json_annotation/json_annotation.dart';

import 'UserProfile.dart';
import 'UserProfileSettings.dart';

part 'GetUserProfileResponse.g.dart';

@JsonSerializable()
class GetUserProfileResponse {
  final String message;
  final UserProfile profile;
  final UserProfileSettings settings;

  GetUserProfileResponse(
    this.message,
    this.profile,
    this.settings
  );

  factory GetUserProfileResponse.fromJson(Map<String, dynamic> json) => _$GetUserProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetUserProfileResponseToJson(this);
}
```

This is the volume of code before code-generation step. Now let's take a look at the protocol-buffer way.


## The Procol Buffer way

```proto get_user_profile.dart
syntax = "proto3";
package fda_mystudies_spec.participant_user_datastore_service;

message GetUserProfileResponse {
  string message = 1;

  message UserProfile {
    string email_id = 1;
  }
  UserProfile profile = 2;

  message UserProfileSettings {
    bool local_notifications = 1;
    string locale = 2;
    bool passcode = 3;
    string reminder_lead_time = 4;
    bool remote_notifications = 5;
    bool touch_id = 6;
  }
  UserProfileSettings settings = 3;
}
```

### Advantages of protocol-buffer

- The specs are much better at readability than in the JsonSerializable way.
- No dart code needed, all the dart code is generated. No tests required at spec level. A good side-effect is protocol buffers are language agnostic, moving ahead if we decide to refactor the backend code, we can use the same specs to generate java code for the bacend.

## Disadvantage of protocol-buffer

- No support for dynamic types. In dart you have support for json objects with `dynamic` data-type, but in protos this is not supported. You won't be able to use `Any` directly here either, since `Any` fields require a `type_url` to be set to serialize json string to dart object correctly. So there is an extra effort required here.

For this application, this extra effort is required in a very limited number of cases, and hence the advantages of using protocol-buffers outweigh its disadvantage. And the effort saved in writing dart code easily compensates for the extra effort needed for special cases.
