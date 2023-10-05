# Design of FDA MyStudies flutter app

[Stage: Draft]


## Context

### Objective

FDA MyStudies platform is a digital health study platform. The objective of
this document is to enlist the design decisions taken during building the
flutter app for this platform.

The main objectives driving the decision are:

- Quick onboarding for new studies
- Quick prototyping for updating & creating studies
- Quick brand & design changes for new teams adopting the platform
- Modular feature implementations, allowing new studies develop and plug-in
their features easily.

### Background

FDA MyStudies platform already has native apps that allow us to collect data
for digital health studies, but have some disadvantages for small times:

- High Setup cost. Costlier to test the feasibility of the platform for a new
study
- Two code-bases and bug-bases to manage.
- Hard to change UI, color schemes, fonts through-out the apps.
- Low support for accessibility features.

Flutter is the best choice for tackling most of these issues, as it allows us
to:

- Build cross-platform apps: Reduces code-bases & bug-bases to 1.
- Defining [design-tokens](https://carbon.googleplex.com/carbon-design-system/pages/tokens)
allows us to build the app up that can allow modification to themes and
branding very easily.
- Using built-in typography tokens allows us to take advantage of accessibility
features like light/dark themes, larger font-sizes and contrast-modes by
default.
- Designing HTTPClient package that treats mocks as first-class citizens
allowed us to build prototype for new studies within a day. This reduced the
feasibility testing time for newer studies.

We'll discuss these things in details in the next section.


## Design

Our codebase is divided into app (`lib/` folder) & 4 packages (`package/`
folder). We discuss packages first, as they are the building-blocks of the app.
We have 4 packages in our codebase:

1. fda_mystudies_spec
2. fda_mystudies_http_client
3. fda_mystudies_design_system
4. fda_mystudies_activity_ui_kit

### FDA MyStudies Spec

The Spec package stores request/response specs in protocol-buffers (protobufs).
We use protobufs instead of the recommended [Json Serialization](https://docs.flutter.dev/data-and-backend/json)
solution since it's more consise and clear. This design decisions and pros &
cons of this are documented in
**package/fda_mystudies_http_client/design/proto_vs_json_serializable.md**.

We use [protoc_plugin](https://pub.dev/packages/protoc_plugin) to generate the
dart code needed to use these protobufs in our flutter app and http_client
package.

This package also contains some utility methods under the `proto_json.dart`
file which can be reused while converting to and from protos to dart code.

### FDA MyStudies HTTP Client

The primary objective of this package is to implement all the interactions with
the FDA MyStudies backend and provide a clean interface for the app to interact
with the backend without worrying about the "how".

#### Session Moat

This package is meant to be a moat for all session variables and other data
that we need to send to the backend but are no use to the frontend. This design
decision has not been thoroughly followed-through during the implementation, but
is a good objective to keep in mind while refactoring this package. Data like
user-id, participant-id, auth-token & refresh-token have been exposed by some
interfaces to the caller, or are required by some interfaces from the caller,
these should ideally not happen, and these should be maintained by the package
itself.

#### 2 Responses per method

All the methods in every service use a CommonErrorResponse instead of exceptions
to propagate errors to the callers. This decision was made to reduce the number
of states the caller to needs manage, since the caller is going to be a user-facing
component that needs to generate a UI for every success / failure response. By
sending the caller just two types of responses, we make the callers job easy
by just requiring two types of UIs to surface response received from each action.
More details on this are documented in **package/fda_mystudies_http_client/design/io_and_exceptions.md**.

#### Mocks as first-class citizen

Another objective of this package is to introduce mocks as first-class citizens.
Mock responses for each service are listed under the `assets/mock/scenario`
folder. Mock responses are created using yaml files. `default.yaml` should
contain happy-path response. When no mapping is mentioned in configs, in the
mock environment the moethods would return the response in `default.yaml`.

Each yaml file has 4 properties:

- `title` is a short title for the response.
- `description` describes the scenario the response enables.
- `code` is the HTTP code. 200 should be the code for most default.yaml
responses.
- `response` holds the json response for the scenario.

Each method can have multiple yaml files defining scenarios for a
given method under a service, and then mapping under
`lib/demo/mock/demo_config.dart` determines which response is mocked in demo
environment for given method. If no mapping is provided, the scenario under
default.yaml is returned in the demo environment. Mocking can be used to mock
error-conditions, happy-paths, transitions and animations in UI without
depending on the backend for those particular scenarios. This also allows for
testing scenarios randomly, without depending on pre-cursor scenarios to be
executed successfully i.e. you can mock and test registration flow before
successfully going through the sign-in flow.


### FDA MyStudies Design System

Design Systems are Design Tokens for the app as a package. We define the
common language between designers and engineers using this package. All the
reusable UI elements are defined in this package.

All the UI elements are divided in 4 directories.

- **theme** - contains color-schemes and any other theme specific details.
- **typography** - contains everything relating to fonts
	- typography tokens define the base tokens of the typography systems.
	- components define the comonly used aliases built using the typography
	  tokens.
- **components** - contains reusable UI elements that need some overhead while
  placing them in a screen.
- **block** - contains reusable elements that can be directly placed in a
  ListView in any of our screens. Since most of our screens are vertical linear
  lists that contain one element per row, block elements can be placed directly
  in a list since they define all the margins / padding, expansion / shrinking
  behavior correctly.

All the UI elements defined in this package have a golden test for them.
Golden snapshots are stored in the format

```
<theme>.<element-name>.<state>
```

e.g. `dark.agree_to_tnc_block.agreed`


### FDA MyStudies Activity UI Kit

Everything that deals with collecting user responses in form of survey
questionnaire, tests & tasks is packaged in this package. This package
provides methods that accepts the JSON that defines steps of any user facing
activity, renders them into the survey UIs that collect responses from the user
, collects the responses, packages them into JSON that can be sent back to the
backend and returns it to the caller which can then upload the JSON to the
FDA MyStudies backend.

> Activity Step JSON in. User Response JSON out.

The caller doesn't need to bother with how the UI is generated, how to responses
are collected, how branching is done between questions of the survey. It can
rely on this package to take care of this CUJ end to end.

There are currently 3 methods that build different kind of activities:

- **buildActivity** - takes steps in and renders a UI, and spits out user-
 responses. Simplest of them all, and the most commonly used for daily, weekly
 monthly & one-time activities.
- **buildFailFastTest** - takes steps in with correct answers. Builds a test
 that displays a failure screen when user responds with an incorrect answer.
 This has been exclusively built for `Eligibility Test`.
- **buildRetriableTestWithSuggtestions** - take steps in with correct answers.
 Builds a test that highlights correct & incorrect answers on second try of the
 test. This is meant to improve the UX for comprehension test.


### App

The app uses [MVC architecture](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller).
At the momemnt it's not perfectly implemented.
I'll document the ideal implementation design here and refactor the existing
code to match the ideal scenario.

We are using [StatefulWidgets](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)
as Controllers, [StatelessWidgets](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html)
as Screens / Views. Dart Objects or [Providers](https://pub.dev/packages/provider)
as Models. We are using Providers to avoid re-rendering of unchanged elements,
and sending data down the hierarchy of screens without attaching it in every
screens initializer.

Currently, controllers are placed under **lib/src/controller** folder, and
views are placed under **lib/src/screens** folder. These need to be divided into
individual modules that exist in **lib/src** folders. As of now the module
directories contain unrefactored old code that doesn't confirm to MVC
architecture. This needs to be corrected during the next refactoring.

For navigation, we are using [GoRouter](https://pub.dev/packages/go_router).
This allows us to navigate using string based paths, rather than referencing
controllers directly from inside another controllers. This helps us generate
modular flows that manage their own navigation and can be plugged into the app
without depending on or being dependent on other controllers.
