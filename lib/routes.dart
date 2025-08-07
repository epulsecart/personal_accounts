import 'package:accounts/data/groups_module/group_model.dart';
import 'package:accounts/services/groups_module/group_join_request_service_impl.dart';
import 'package:accounts/services/groups_module/group_service_impl.dart';
import 'package:accounts/services/groups_module/group_transaction_service_impl.dart';
import 'package:accounts/services/groups_module/settlement_request_service_impl.dart';
import 'package:accounts/state/group_module/group_join_request_provider.dart';
import 'package:accounts/state/group_module/group_provider.dart';
import 'package:accounts/state/group_module/group_transaction_provider.dart';
import 'package:accounts/state/group_module/settlement_request_provider.dart';
import 'package:accounts/ui/auth/update_profile.dart';
import 'package:accounts/ui/group/group_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';

import '../state/auth_provider.dart';
import '../ui/splash/splash_screen.dart';
import '../ui/auth/login_screen.dart';
import '../ui/auth/phone_auth.dart';
import '../ui/dash/dash_scaffold.dart';
import '../ui/dash/settings.dart';

import '../services/user_module/transactions_service_impl.dart';
import '../services/user_module/category_service_imp.dart';
import '../services/user_module/template_service_imp.dart';

import '../state/user_module/transactions_provider.dart';
import '../state/user_module/category_provider.dart';
import '../state/user_module/template_provider.dart';

import '../data/user_module/transactions.dart';
import '../data/user_module/sync_record.dart';
import 'data/groups_module/group_join_request_model.dart';
import 'data/groups_module/group_transaction_model.dart';
import 'data/groups_module/settlement_request_model.dart';
import 'data/offline_mutation.dart';

class AppRouter {
  static GoRouter buildRouter({
    required String initialRoute,
    required AuthProvider authProvider,
    required SharedPreferences prefs,
  }) {
    return GoRouter(
      initialLocation: initialRoute,
      // when AuthProvider.notifies, re-run redirect:
      refreshListenable: authProvider.statusNotifier,
      redirect: (context, state) {

        final status   = authProvider.statusNotifier.value;
        final loc      = state.uri.toString();
        print ("calling the redirect now is ${status.name}");
        // 1) If you're fully authenticated...
        if (status == AuthStatus.authenticated) {
          // ...and you're on /login or /splash, send you to home
          if (loc.startsWith('/login') || loc == '/splash') {
            print ("now going home");
            return '/';
          }
          // otherwise, let you stay where you are
          return null;
        }
        // 2) If you're in the middle of authenticating (email, Google, phone)—
        //    do NOT redirect you. Let you stay on /login so you can see errors.
        if (status == AuthStatus.codeSent && loc != '/login/phone'){
          print ("i am sending code $loc");
          return '/login/phone';
        }
        if (status == AuthStatus.authenticating || status == AuthStatus.unauthenticated) {
          print ("now authentiaction $loc");
          return null;
        }

        // 3) If you're still uninitialized (first app launch),
        //    let the initialRoute logic handle whether you go to /splash.
        if (status == AuthStatus.uninitialized) {
          print("now going to splash ");
          return '/splash';
        }

        // 4) Otherwise (unauthenticated), protect the private shell at `/`
        //    by redirecting any access to `/` → `/login`.
        if (loc == '/' || loc.startsWith('/settings')) {
          return '/login';
        }

        // 5) For everything else (e.g. /login, /splash), stay put.
        return null;
      },
      routes: [
        // Public routes:
        GoRoute(
          path: '/splash',
          builder: (ctx, st) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (ctx, st) => const LoginScreen(),
          routes: [
            GoRoute(
              path: 'phone',
              builder: (ctx, st) => const PhoneAuthScreen(),
            ),

          ],
        ),

        // Authenticated shell:
        // if (authProvider.user!=null)
        ShellRoute(
          builder: (context, state, child) {
            // once authed, scope all your feature providers here:

            final uid = authProvider.user?.uid??'';
            return MultiProvider(
              providers: [
                ChangeNotifierProvider<TransactionProvider>(
                  create: (_) => TransactionProvider(
                    TransactionServiceImpl(
                      userId:   uid,
                      txnBox:   Hive.box<TransactionModel>('transactions'),
                      queueBox: Hive.box<SyncRecord>('sync_queue'),
                      prefs:    prefs,
                    ),
                  ),
                ),
                ChangeNotifierProvider<CategoryProvider>(
                  create: (_) => CategoryProvider(
                    CategoryServiceImpl(
                      userId: uid,
                      prefs:  prefs,
                    ),
                  ),
                ),
                ChangeNotifierProvider<TemplateProvider>(
                  create: (_) => TemplateProvider(
                    TemplateServiceImpl(
                      userId: uid,
                      prefs:  prefs,
                    ),
                  ),
                ),

                /// groups providers
                ChangeNotifierProvider<GroupProvider>(
                  create: (_) => GroupProvider(
                    GroupServiceImpl(
                      userId: uid,
                      prefs:  prefs,
                      groupBox: Hive.box<GroupModel>('groups'),
                      txnBox: Hive.box<GroupTransactionModel>('group_transactions'),
                      queueBox: Hive.box<OfflineMutation>('mutation_queue'),
                    ),
                  ),
                ),
                ChangeNotifierProvider<SettlementRequestProvider>(
                  create: (_) => SettlementRequestProvider(
                    SettlementRequestServiceImpl(
                      box: Hive.box<SettlementRequestModel>('settlement_requests'),
                      queueBox: Hive.box<OfflineMutation>('mutation_queue'),
                    ),
                  ),
                ),
                ChangeNotifierProvider(
                  create: (_) => GroupJoinRequestProvider(
                    service: GroupJoinRequestServiceImpl(
                      box:     Hive.box<GroupJoinRequestModel>('group_join_requests'),
                      mutBox:  Hive.box<OfflineMutation>('mutation_queue'),
                    ),
                    groupId: '',
                  ),
                ),
              ],
              child: child,
            );
          },
          // your bottom-nav + all inner pages live here:
          routes: [
            /// personal module routes:
            GoRoute(
              path: '/',
              builder: (ctx, st) => const DashboardScaffold(),
              routes: [
                GoRoute(
                  path: 'settings',
                  builder: (ctx, st) => const SettingsScreen(),
                ),
              ],
            ),
            GoRoute(
              path: '/editProfile',
              builder: (ctx, st) => const UpdateProfileScreen(),
            ),
            /// groups module routes:
            GoRoute(
              path: '/groups/:groupId',
              builder: (context, state) {
                final groupId = state.pathParameters['groupId']!;
                final txnId = state.pathParameters['txnId']??'';
                final uid     = context.read<AuthProvider>().user!.uid;
                return MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      create: (_) => GroupTransactionProvider(
                        service: GroupTransactionServiceImpl(
                          box:      Hive.box<GroupTransactionModel>('group_transactions'),
                          mutBox:   Hive.box<OfflineMutation>('mutation_queue'),
                          prefs:    prefs,
                          firestore: FirebaseFirestore.instance,
                        ),
                        groupId: groupId,
                        userId:  uid,
                      ),
                    ),
                    ChangeNotifierProvider(
                      create: (_) => GroupJoinRequestProvider(
                        service: GroupJoinRequestServiceImpl(
                          box:     Hive.box<GroupJoinRequestModel>('group_join_requests'),
                          mutBox:  Hive.box<OfflineMutation>('mutation_queue'),
                        ),
                        groupId: groupId,
                      ),
                    ),
                    // …and any other per-group providers
                  ],
                  child: GroupDetailScreen(groupId: groupId),
                );
              },
            ),

          ],
        ),
      ],
    );
  }
}
