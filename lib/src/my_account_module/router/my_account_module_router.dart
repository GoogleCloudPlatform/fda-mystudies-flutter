import 'package:go_router/go_router.dart';

import '../../controller/update_password_screen_controller.dart';
import '../../route/module_router.dart';
import '../../route/route_name.dart';
import '../controller/delete_app_account_controller.dart';
import '../controller/my_account_controller.dart';

class MyAccountModuleRouter implements ModuleRouter {
  static const deleteAppAccount = 'delete_app_account';
  static const changePassword = 'change_password';

  @override
  GoRoute get route => GoRoute(
          name: RouteName.myAccount,
          path: '/${RouteName.myAccount}',
          builder: (context, state) => const MyAccountController(),
          routes: [
            GoRoute(
                name: deleteAppAccount,
                path: deleteAppAccount,
                builder: (context, state) =>
                    const DeleteAppAccountController()),
            GoRoute(
                name: changePassword,
                path: changePassword,
                builder: (context, state) =>
                    const UpdatePasswordScreenController(
                        isChangingTemporaryPassword: false))
          ]);
}
