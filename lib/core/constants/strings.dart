/// All user-facing strings for the CodePath app.
class AppStrings {
  AppStrings._();

  // ── App ──────────────────────────────────────────────────────────────────
  static const String appName = 'CodePath';
  static const String tagline = 'Build real skills, one card at a time.';

  // ── Navigation ───────────────────────────────────────────────────────────
  static const String navHome = 'Home';
  static const String navCatalog = 'Catalog';
  static const String navProgress = 'Progress';
  static const String navProfile = 'Profile';

  // ── Auth ─────────────────────────────────────────────────────────────────
  static const String signIn = 'Sign In';
  static const String signUp = 'Sign Up';
  static const String signOut = 'Sign Out';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String forgotPassword = 'Forgot Password?';
  static const String resetPassword = 'Reset Password';
  static const String sendResetLink = 'Send Reset Link';
  static const String alreadyHaveAccount = 'Already have an account? Sign In';
  static const String dontHaveAccount = "Don't have an account? Sign Up";
  static const String continueWithGoogle = 'Continue with Google';
  static const String continueWithGithub = 'Continue with GitHub';
  static const String orDivider = 'or';

  // ── Catalog ───────────────────────────────────────────────────────────────
  static const String tracks = 'Roadmaps';
  static const String track = 'Roadmap';
  static const String modules = 'Stages';
  static const String module = 'Stage';
  static const String lessons = 'Cards';
  static const String lesson = 'Card';
  static const String difficulty = 'Difficulty';
  static const String beginner = 'Beginner';
  static const String intermediate = 'Intermediate';
  static const String advanced = 'Advanced';
  static const String estimatedTime = 'Est. time';
  static const String minutes = 'min';
  static const String startTrack = 'Start Roadmap';
  static const String continueTrack = 'Continue';
  static const String viewAll = 'View All';
  static const String searchTracks = 'Search roadmaps…';
  static const String filterByTag = 'Filter by tag';
  static const String noTracksFound = 'No roadmaps found.';
  static const String noModulesFound = 'No stages found.';
  static const String noLessonsFound = 'No cards found.';

  // ── Lesson / Practice ────────────────────────────────────────────────────
  static const String practice = 'Drills';
  static const String submit = 'Submit';
  static const String checkAnswer = 'Check Answer';
  static const String correct = 'Correct!';
  static const String incorrect = 'Incorrect';
  static const String tryAgain = 'Try Again';
  static const String nextChallenge = 'Next Drill';
  static const String finishLesson = 'Finish Card';
  static const String hintLabel = 'Hint';
  static const String showHint = 'Show Hint';
  static const String explanation = 'Explanation';
  static const String yourAnswer = 'Your answer…';
  static const String chooseAnswer = 'Choose an answer';
  static const String challengeOf = 'Drill {current} of {total}';
  static const String keyTakeaways = 'Key Takeaways';

  // ── Quiz ──────────────────────────────────────────────────────────────────
  static const String quiz = 'Checkpoint';
  static const String startQuiz = 'Start Checkpoint';
  static const String retakeQuiz = 'Retake Checkpoint';
  static const String quizScore = 'Score';
  static const String quizPassed = 'Passed! 🎉';
  static const String quizFailed = 'Not quite – try again';
  static const String questionOf = 'Question {current} of {total}';
  static const String nextQuestion = 'Next Question';
  static const String submitQuiz = 'Submit Checkpoint';
  static const String quizResults = 'Checkpoint Results';
  static const String passThreshold = 'Pass threshold';

  // ── Progress ──────────────────────────────────────────────────────────────
  static const String progress = 'Progress';
  static const String streak = 'Streak';
  static const String currentStreak = 'Current Streak';
  static const String longestStreak = 'Longest Streak';
  static const String days = 'days';
  static const String badges = 'Badges';
  static const String noBadgesYet = 'No badges yet – keep learning!';
  static const String lessonsCompleted = 'Cards Completed';
  static const String modulesCompleted = 'Stages Completed';
  static const String tracksCompleted = 'Roadmaps Completed';
  static const String totalXp = 'Total XP';
  static const String weeklyActivity = 'Weekly Activity';
  static const String overallProgress = 'Overall Progress';
  static const String completed = 'Completed';
  static const String inProgress = 'In Progress';
  static const String notStarted = 'Not Started';

  // ── Premium / Freemium ────────────────────────────────────────────────────
  static const String upgrade = 'Upgrade to Premium';
  static const String free = 'Free';
  static const String premium = 'Premium';
  static const String plans = 'Plans';
  static const String monthlyPlan = 'Monthly';
  static const String yearlyPlan = 'Yearly (Best Value)';
  static const String premiumFeatures = 'Premium Features';
  static const String unlockAllTracks = 'Unlock all roadmaps & stages';
  static const String unlimitedPractice = 'Unlimited drill attempts';
  static const String offlineAccess = 'Offline access';
  static const String dailyLimitReached = 'Daily drill limit reached';
  static const String upgradeToUnlock = 'Upgrade to unlock this stage';
  static const String freeModulesNote = 'Free plan: first {n} stages per roadmap';
  static const String attemptsLeft = '{n} attempts left today';

  // ── Admin Panel ───────────────────────────────────────────────────────────
  static const String adminPanel = 'Admin Panel';
  static const String manageContent = 'Manage Content';
  static const String addTrack = 'Add Roadmap';
  static const String editTrack = 'Edit Roadmap';
  static const String deleteTrack = 'Delete Roadmap';
  static const String addModule = 'Add Stage';
  static const String editModule = 'Edit Stage';
  static const String deleteModule = 'Delete Stage';
  static const String addLesson = 'Add Card';
  static const String editLesson = 'Edit Card';
  static const String deleteLesson = 'Delete Card';
  static const String addChallenge = 'Add Drill';
  static const String editChallenge = 'Edit Drill';
  static const String deleteChallenge = 'Delete Drill';
  static const String addQuizQuestion = 'Add Checkpoint Question';
  static const String editQuizQuestion = 'Edit Checkpoint Question';
  static const String deleteQuizQuestion = 'Delete Checkpoint Question';
  static const String publishContent = 'Publish';
  static const String unpublishContent = 'Unpublish';
  static const String confirmDelete = 'Are you sure you want to delete this?';
  static const String cannotUndo = 'This action cannot be undone.';

  // ── Onboarding ────────────────────────────────────────────────────────────
  static const String welcome = 'Welcome to CodePath!';
  static const String chooseInterests = 'What do you want to learn?';
  static const String chooseInterestsSubtitle =
      'Pick topics you\'re interested in. We\'ll personalise your roadmaps.';
  static const String skip = 'Skip';
  static const String getStarted = 'Get Started';
  static const String next = 'Next';
  static const String back = 'Back';

  // ── Home screen sections ─────────────────────────────────────────────────
  static const String todayPlan = "Today's Plan";
  static const String continueSection = 'Continue';
  static const String recommendedRoadmaps = 'Recommended Roadmaps';

  // Interest tags shown during onboarding
  static const List<String> interestTags = [
    'Python',
    'JavaScript',
    'Web Dev',
    'Data Structures',
    'Algorithms',
    'Machine Learning',
    'Mobile Dev',
    'Databases',
    'DevOps',
    'Cybersecurity',
    'Cloud Computing',
    'API Design',
  ];

  // ── Profile ───────────────────────────────────────────────────────────────
  static const String profile = 'Profile';
  static const String username = 'Username';
  static const String displayName = 'Display Name';
  static const String editProfile = 'Edit Profile';
  static const String saveChanges = 'Save Changes';
  static const String accountSettings = 'Account Settings';
  static const String notifications = 'Notifications';
  static const String darkMode = 'Dark Mode';
  static const String language = 'Language';
  static const String deleteAccount = 'Delete Account';
  static const String deleteAccountConfirm =
      'This will permanently delete your account and all progress. Continue?';

  // ── Errors ────────────────────────────────────────────────────────────────
  static const String genericError = 'Something went wrong. Please try again.';
  static const String networkError =
      'No internet connection. Check your network and try again.';
  static const String authErrorInvalidCredentials = 'Invalid email or password.';
  static const String authErrorEmailInUse = 'An account with this email already exists.';
  static const String authErrorWeakPassword =
      'Password must be at least 8 characters.';
  static const String authErrorSessionExpired =
      'Your session has expired. Please sign in again.';
  static const String notFound = 'The requested content was not found.';
  static const String quotaExceeded = 'Daily limit reached. Upgrade for unlimited access.';
  static const String retry = 'Retry';
  static const String dismiss = 'Dismiss';
  static const String ok = 'OK';
  static const String cancel = 'Cancel';
}
