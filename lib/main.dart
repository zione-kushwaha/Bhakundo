import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'firebase_options.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';

// Authentication Layer
import 'features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/domain/usecases/get_current_user_usecase.dart';
import 'features/auth/domain/usecases/sign_in_with_email_usecase.dart';
import 'features/auth/domain/usecases/sign_up_with_email_usecase.dart';
import 'features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'features/auth/domain/usecases/sign_out_usecase.dart';

// Booking Layer
import 'features/booking/data/datasources/booking_remote_data_source_impl.dart';
import 'features/booking/data/repositories/booking_repository_impl.dart';
import 'features/booking/presentation/bloc/booking_bloc.dart';
import 'features/booking/domain/usecases/get_courts_usecase.dart';
import 'features/booking/domain/usecases/get_slots_usecase.dart';
import 'features/booking/domain/usecases/create_booking_usecase.dart';
import 'features/booking/domain/usecases/verify_booking_payment_usecase.dart';

// Matchmaking Layer
import 'features/matchmaking/data/datasources/matchmaking_remote_data_source_impl.dart';
import 'features/matchmaking/data/repositories/matchmaking_repository_impl.dart';
import 'features/matchmaking/presentation/bloc/matchmaking_bloc.dart';
import 'features/matchmaking/domain/usecases/get_open_challenges_usecase.dart';
import 'features/matchmaking/domain/usecases/host_challenge_usecase.dart';
import 'features/matchmaking/domain/usecases/accept_challenge_usecase.dart';

// Team Layer
import 'features/team_management/data/datasources/team_remote_data_source_impl.dart';
import 'features/team_management/data/repositories/team_repository_impl.dart';
import 'features/team_management/presentation/bloc/team_bloc.dart';
import 'features/team_management/domain/usecases/get_my_team_usecase.dart';
import 'features/team_management/domain/usecases/create_team_usecase.dart';
import 'features/team_management/domain/usecases/add_player_to_team_usecase.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await GoogleSignIn.instance.initialize();
  } catch (e) {
    debugPrint("Firebase/GoogleSignIn initialization warning (safe to bypass in sandbox): $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Instantiate DataSources
    final authDataSource = AuthRemoteDataSourceImpl();
    final bookingDataSource = BookingRemoteDataSourceImpl();
    final matchmakingDataSource = MatchmakingRemoteDataSourceImpl();
    final teamDataSource = TeamRemoteDataSourceImpl();

    // 2. Instantiate Repositories
    final authRepository = AuthRepositoryImpl(authDataSource);
    final bookingRepository = BookingRepositoryImpl(bookingDataSource);
    final matchmakingRepository = MatchmakingRepositoryImpl(matchmakingDataSource);
    final teamRepository = TeamRepositoryImpl(teamDataSource);

    // 3. Instantiate Use Cases
    // Auth Use Cases
    final getCurrentUserUseCase = GetCurrentUserUseCase(authRepository);
    final signInWithEmailUseCase = SignInWithEmailUseCase(authRepository);
    final signUpWithEmailUseCase = SignUpWithEmailUseCase(authRepository);
    final signInWithGoogleUseCase = SignInWithGoogleUseCase(authRepository);
    final signOutUseCase = SignOutUseCase(authRepository);

    // Booking Use Cases
    final getCourtsUseCase = GetCourtsUseCase(bookingRepository);
    final getSlotsUseCase = GetSlotsUseCase(bookingRepository);
    final createBookingUseCase = CreateBookingUseCase(bookingRepository);
    final verifyBookingPaymentUseCase = VerifyBookingPaymentUseCase(bookingRepository);

    // Matchmaking Use Cases
    final getOpenChallengesUseCase = GetOpenChallengesUseCase(matchmakingRepository);
    final hostChallengeUseCase = HostChallengeUseCase(matchmakingRepository);
    final acceptChallengeUseCase = AcceptChallengeUseCase(matchmakingRepository);

    // Team Use Cases
    final getMyTeamUseCase = GetMyTeamUseCase(teamRepository);
    final createTeamUseCase = CreateTeamUseCase(teamRepository);
    final addPlayerToTeamUseCase = AddPlayerToTeamUseCase(teamRepository);

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            getCurrentUserUseCase,
            signInWithEmailUseCase,
            signUpWithEmailUseCase,
            signInWithGoogleUseCase,
            signOutUseCase,
          )..add(AuthCheckRequested()),
        ),
        BlocProvider<BookingBloc>(
          create: (context) => BookingBloc(
            getCourtsUseCase,
            getSlotsUseCase,
            createBookingUseCase,
            verifyBookingPaymentUseCase,
          ),
        ),
        BlocProvider<MatchmakingBloc>(
          create: (context) => MatchmakingBloc(
            getOpenChallengesUseCase,
            hostChallengeUseCase,
            acceptChallengeUseCase,
          ),
        ),
        BlocProvider<TeamBloc>(
          create: (context) => TeamBloc(
            getMyTeamUseCase,
            createTeamUseCase,
            addPlayerToTeamUseCase,
          ),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            title: 'Bhakundo',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}