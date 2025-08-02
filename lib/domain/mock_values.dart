import 'package:glow/domain/user.dart';
import 'package:glow/domain/user_info.dart';

import 'glow.dart';

class MockValues {
  static final user = User(name: 'wiam', bio: "stay focused, 'Don't quit.");
  static final mockUserInfo = UserPersonalInfo(
    job: 'doctor',
    gender: 'female',
    activity: ' mostly standing',
    workoutSchedule: '3 days a week or less',
    birthDate: '1998-01-01',
    hobbies: 'nothing',
    goals: 'to be prettier',
    notes: '..',
  );
  static final mockUserInfoAr = UserPersonalInfo(
    job: 'طبيبة',
    gender: 'أنثى',
    activity: 'الوقوف معظم الوقت',
    workoutSchedule: '٣ أيام في الأسبوع أو أقل',
    birthDate: '1998-01-01',
    hobbies: 'لا شيء',
    goals: 'أصبح أكثر جمالًا',
    notes: '..',
  );

  static final mockGlowSchedule = GlowSchedule(
    dailySchedule: [
      DailyTimeSlot(
        timeSlot: Slot.morning,
        startTime: "08:00",
        actions: [
          ScheduleAction(
            id: 'a1',
            title: 'Morning Workout',
            duration: 30,
            category: 'Health',
            startDate: DateTime.now().subtract(Duration(days: 3)),
            endDate: DateTime.now().add(Duration(days: 3)),
            frequency: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
            recurring: true,
            priority: 'High',
            description: '30 mins of cardio & stretching',
            prepNeeded: false,
            location: 'Home',
            instances: [],
          ),
        ],
      ),
      DailyTimeSlot(
        timeSlot: Slot.afternoon,
        startTime: "12:00",
        actions: [
          ScheduleAction(
            id: 'a2',
            title: 'Lunch with team',
            duration: 60,
            category: 'Social',
            startDate: DateTime.now().subtract(Duration(days: 1)),
            endDate: DateTime.now().add(Duration(days: 5)),
            frequency: ['Tue', 'Thu'],
            recurring: false,
            priority: 'Medium',
            description: 'Team bonding over lunch',
            prepNeeded: false,
            location: 'Cafe Zone',
            instances: [],
          ),
        ],
      ),
      DailyTimeSlot(
        timeSlot: Slot.evening,
        startTime: "18:00",
        actions: [
          ScheduleAction(
            id: 'a3',
            title: 'Read 20 pages',
            duration: 20,
            category: 'Personal Development',
            startDate: DateTime.now().subtract(Duration(days: 2)),
            endDate: DateTime.now().add(Duration(days: 4)),
            frequency: ['Mon', 'Wed', 'Fri'],
            recurring: true,
            priority: 'Low',
            description: 'Reading self-help or fiction',
            prepNeeded: false,
            location: 'Home',
            instances: [],
          ),
        ],
      ),
    ],
    weeklyGoals: [
      WeeklyGoal(
        id: 'g1',
        title: 'Finish Flutter module',
        type: 'Learning',
        frequency: '3 times/week',
        bestDay: 'Wednesday',
        duration: 90,
        timeOfDay: 'Evening',
      ),
      WeeklyGoal(
        id: 'g2',
        title: 'Run 5km',
        type: 'Fitness',
        frequency: '2 times/week',
        bestDay: 'Monday',
        duration: 45,
        timeOfDay: 'Morning',
      ),
    ],
    preparationList: [
      PreparationItem(
        id: 'p1',
        task: 'Buy running shoes',
        category: 'Fitness',
        deadline: DateTime.now().add(Duration(days: 2)),
        urgency: 'High',
      ),
      PreparationItem(
        id: 'p2',
        task: 'Download eBook',
        category: 'Reading',
        deadline: DateTime.now().add(Duration(days: 1)),
        urgency: 'Low',
      ),
    ],
    progressMilestones: [
      ProgressMilestone(
        id: 'm1',
        title: 'Complete first week of schedule',
        targetDate: DateTime.now().add(Duration(days: 7)),
        successMetrics: ['All actions completed', 'Goals reviewed'],
      ),
      ProgressMilestone(
        id: 'm2',
        title: 'Run total of 10km',
        targetDate: DateTime.now().add(Duration(days: 10)),
        successMetrics: ['2 runs logged', 'Improved timing'],
      ),
    ],
  );
}
