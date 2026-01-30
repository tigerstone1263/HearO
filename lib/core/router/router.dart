

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:hear_o/game/hear_o_game.dart';
import 'package:hear_o/main.dart';
import 'package:hear_o/presentation/home/home_view.dart';

import 'route_names.dart';

class AppRouterService with ChangeNotifier {

  // // 라우터 재생성 트리거용
  // int _epoch = 0;
  //
  late GoRouter _router;
  GoRouter get router => _router;

  AppRouterService() {
    _router = build();
  }
  //
  // // 로그인/로그아웃 직후 호출
  // void reset() {
  //   _epoch++; // 디버깅/키 라벨링에 쓰면 편함
  //   _router = build();
  //   notifyListeners(); // ← MaterialApp.router가 새 GoRouter를 받도록 리빌드
  // }
  //
  GoRouter build() {
    return GoRouter(
    initialLocation: RouteNames.root,
    routes: [
  //     GoRoute(
  //       path: RouteNames.timeoutError,
  //       builder: (context, state) => TimeoutErrorView(),
  //     ),
  //     GoRoute(
  //       path: RouteNames.unknownError,
  //       builder: (context, state) {
  //         final int errorCode = state.extra as int;
  //         return ErrorView(errorCode: errorCode);
  //       },
  //     ),
  //
      GoRoute(
          path: RouteNames.game, builder: (context, state) => HearOApp()),
  //
  //     GoRoute(path: RouteNames.subscription,
  //         builder: (context, state) => SubscriptionView()),
  //
      GoRoute(
          name: RouteNames.root,
          path: RouteNames.root,
          builder: (context, state) =>
              HomeView(key: ValueKey(state.uri.toString()))),
  //     // GoRoute(
  //     //   path: RouteNames.login,
  //     //   builder:
  //     //       (context, state) => LoginView(
  //     //         onLoginSuccess: () {
  //     //           context.go(RouteNames.home);
  //     //         },
  //     //       ),
  //     // ),
  //     //bottom nav
  //     StatefulShellRoute.indexedStack(
  //       builder: (context, state, navigationShell) {
  //         return HomeView(
  //           body: navigationShell,
  //           currentPageIndex: navigationShell.currentIndex,
  //           setCurrentIndex: (index) {
  //             navigationShell.goBranch(
  //               index,
  //               initialLocation: index == navigationShell.currentIndex,
  //             );
  //           },
  //         );
  //       },
  //       branches: [
  //         StatefulShellBranch(
  //           routes: [
  //             GoRoute(
  //               name: RouteNames.home,
  //               path: RouteNames.home,
  //               builder: (context, state) => FeedView(),
  //             ),
  //           ],
  //         ),
  //         StatefulShellBranch(
  //           routes: [
  //             GoRoute(
  //               path: RouteNames.topic,
  //               builder: (context, state) => SubscribedTopicRoot(),
  //             ),
  //           ],
  //         ),
  //         StatefulShellBranch(
  //           routes: [
  //             GoRoute(
  //               path: RouteNames.blindSpot,
  //               builder:
  //                   (context, state) =>
  //                   BlindSpotRoot(
  //                     onIssueSelected:
  //                         (issueId) =>
  //                         context.push(
  //                           '${RouteNames.issueDetailFeed}/$issueId',
  //                         ),
  //                   ),
  //             ),
  //           ],
  //         ),
  //         StatefulShellBranch(
  //           routes: [
  //             GoRoute(
  //               path: RouteNames.media,
  //               builder: (context, state) => SubscribedMediaRoot(),
  //             ),
  //           ],
  //         ),
  //         StatefulShellBranch(
  //           routes: [
  //             GoRoute(
  //               name: RouteNames.myPage,
  //               path: RouteNames.myPage,
  //               builder:
  //                   (context, state) =>
  //                   MyPageView(
  //                     toWatchHistory: () =>
  //                         context.push(RouteNames.watchHistory),
  //                     toSubscribedIssue:
  //                         () => context.push(RouteNames.subscribedIssue),
  //                     toManageMediaSubscription:
  //                         () => context.push(RouteNames.wholeMedia),
  //                     toManageTopicSubscription:
  //                         () => context.push(RouteNames.wholeTopics),
  //                     toManageIssueEvaluation:
  //                         () => context.push(RouteNames.manageIssueEvalution),
  //                     toManageSourceEvaluation:
  //                         () => context.push(RouteNames.manageSourceEvaluation),
  //                   ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //
  //     GoRoute(
  //       path: RouteNames.onboarding,
  //       builder: (context, state) => const OnboardingView(),
  //     ),
  //
  //     GoRoute(
  //       path: RouteNames.moreIssues,
  //       builder: (context, state) {
  //         final extra = state.extra as Map<String, dynamic>;
  //         final category = extra['category'] as Categories;
  //         final issueType = extra['issueType'] as String;
  //         return MoreIssuesView(issueType: issueType, category: category);
  //       },
  //     ),
  //
  //     GoRoute(
  //       path: RouteNames.search,
  //       builder: (context, state) {
  //         return SearchView();
  //       },
  //     ),
  //
  //     GoRoute(
  //       path: RouteNames.searchIssue,
  //       builder: (context, state) {
  //         return SearchIssueView();
  //       },
  //     ),
  //
  //     GoRoute(
  //         path: RouteNames.notice, builder: (context, state) => NoticeView()),
  //     GoRoute(
  //       path: RouteNames.unsupportedDevice,
  //       builder: (context, state) => UnsupportedDevice(),
  //     ),
  //     GoRoute(
  //       path: RouteNames.needUpdate,
  //       builder: (context, state) => NeedUpdate(isUpdate: true),
  //     ),
  //     GoRoute(
  //       path: RouteNames.serverCheck,
  //       builder: (context, state) => NeedUpdate(isUpdate: false),
  //     ),
  //     GoRoute(
  //       path: RouteNames.haveUpdate,
  //       builder:
  //           (context, state) =>
  //           HaveUpdate(latestVersionNow: state.extra as String),
  //     ),
  //     GoRoute(
  //       path: RouteNames.shorebirdPatch,
  //       builder: (context, state) => ShorebirdPatchView(),
  //     ),
  //
  //     // GoRoute(
  //     //   path: RouteNames.shortsPlayer,
  //     //   builder: (context, state) {
  //     //     final issueId = state.pathParameters['issueId']!;
  //     //     return ShortsPlayerView(issueId: issueId);
  //     //   },
  //     // ),
  //     GoRoute(
  //       path: '${RouteNames.issueDetailFeed}/:id',
  //       builder: (context, state) {
  //         final issueId = state.pathParameters['id']!;
  //         return IssueDetailFeedRoot(issueId: issueId);
  //       },
  //     ),
  //     GoRoute(
  //       path: '/cola/:id',
  //       builder: (context, state) {
  //         final issueId = state.pathParameters['id']!;
  //         return ColaDetailFeedRoot(issueId: issueId);
  //       },
  //     ),
  //     GoRoute(
  //       path: RouteNames.hotIssueFeed,
  //       builder: (context, state) {
  //         final hotIssuesViewModel = state.extra as HotIssuesViewModel;
  //         return HotIssueView(hotIssuesViewModel: hotIssuesViewModel);
  //       },
  //     ),
  //
  //     //article
  //     GoRoute(
  //       path: RouteNames.webView,
  //       builder: (context, state) {
  //         final extra = state.extra! as Map<String, dynamic>;
  //         if (extra['issueInfo'] != null) {
  //           final issueId = extra['issueInfo'].$1 as String;
  //           final bias = extra['issueInfo'].$2 as Bias;
  //           return WebViewView(issueId: issueId, bias: bias);
  //         } else {
  //           final articles = extra['articleInfo'].$1 as List<Article>;
  //           final selectedArticleId = extra['articleInfo'].$2 as String;
  //           final selectedSourceId = extra['articleInfo'].$3 as String;
  //           return WebViewView(
  //             articles: articles,
  //             selectedArticleId: selectedArticleId,
  //             selectedSourceId: selectedSourceId,
  //           );
  //         }
  //       },
  //     ),
  //
  //     //topic
  //     GoRoute(
  //       path: RouteNames.topicDetail,
  //       builder: (context, state) {
  //         final extra = state.extra as String;
  //         return TopicDetailView(topicId: extra);
  //       },
  //     ),
  //     GoRoute(
  //       path: RouteNames.wholeTopics,
  //       builder: (context, state) {
  //         return WholeTopicView();
  //       },
  //     ),
  //
  //     //media
  //     GoRoute(
  //       path: RouteNames.wholeMedia,
  //       builder: (context, state) => WholeMediaView(),
  //     ),
  //     GoRoute(
  //       path: RouteNames.mediaDetail,
  //       builder: (context, state) {
  //         final sourceId = state.extra! as String;
  //         return MediaDetailView(sourceId: sourceId);
  //       },
  //     ),
  //
  //     //my page
  //     GoRoute(
  //       path: RouteNames.watchHistory,
  //       builder: (context, state) => WatchHistoryView(),
  //     ),
  //     GoRoute(
  //       path: RouteNames.subscribedIssue,
  //       builder: (context, state) => SubscribedIssueView(),
  //     ),
  //     GoRoute(
  //       path: RouteNames.manageIssueEvalution,
  //       builder: (context, state) => ManageIssueEvaluationView(),
  //     ),
  //     GoRoute(
  //       path: RouteNames.settings,
  //       builder: (context, state) => SettingView(),
  //     ),
  //     GoRoute(
  //       path: RouteNames.manageSourceEvaluation,
  //       builder: (context, state) => ManageSourceEvaluationView(),
  //     ),
  //     GoRoute(
  //       path: RouteNames.profileManage,
  //       builder: (context, state) {
  //         final extra = state.extra as String?;
  //         return ProfileManageView(imageUrl: extra);
  //       },
  //     ),
  //     GoRoute(
  //       path: RouteNames.biasTest,
  //       builder: (context, state) => PoliticalTestPage(),
  //     ),
  //     GoRoute(
  //       path: RouteNames.biasTestResult,
  //       builder: (context, state) {
  //         final answers = state.extra as List<BiasQuizAnswerVo>;
  //         return BiasTestResultView(answers: answers);
  //       },
  //     ),
  //     //customer services
  //     GoRoute(
  //       path: RouteNames.feedback,
  //       builder: (context, state) => FeedbackRoot(),
  //     ),
    ],
  );
}
}
