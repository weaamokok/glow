import 'dart:ui';

import '../domain/glow.dart';
import '../domain/user_info.dart';

String scheduleCreationPrompt(
    {required UserPersonalInfo userInfo, required Locale local}) {
  return '''
Generate a personalized glow-up routine in JSON format optimized for calendar/schedule display. Follow these requirements:

1. **Structure Requirements:**
{
  "daily_schedule": [
    {
      "time_slot": "Morning/Afternoon/Evening/Night",
      "start_time": "HH:MM", // Estimated ideal time
      "actions": [
        {
          "id": "unique-id",
          "title": "Action name",
          "duration": X, // Minutes
          "category": "Physical|Skincare|Mental|etc.",
          "startDate":"YYYY-MM-DD",
          "endDate":"YYYY-MM-DD",
          "frequency": ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"], // Days
          "recurring": true/false,
          "priority": "High/Medium/Low",
          "description": "Step-by-step instructions",
          "prep_needed": true/false,
          "location": "Home/Gym/Office/etc.",
      
        }
      ]
    }
  ],
  "weekly_goals": [
    {
      "id": "unique-id",
      "title": "Goal name",
      "type": "Social|Fitness|Skill|etc.",
      "frequency": "Weekly/Bi-weekly",
      "best_day": "Monday-Friday",
      "duration": X, // Minutes
      "time_of_day": "Morning/Afternoon/Evening"
    }
  ],
  "preparation_list": [
    {
      "id": "unique-id",
      "task": "Item to acquire/prepare",
      "category": "Shopping/Research/Setup",
      "deadline": "YYYY-MM-DD",
      "urgency": "High/Medium/Low"
    }
  ],
  "progress_milestones": [
    {
      "id": "unique-id",
      "title": "Milestone name",
      "target_date": "YYYY-MM-DD",
      "success_metrics": ["metric1", "metric2"]
    }
  ]
}

2. **Key Personalization Factors:**
- Age: ${userInfo.birthDate}
- Occupation: ${userInfo.job} (consider commute/working hours)
- Current fitness schedule: ${userInfo.workoutSchedule}
- Style preferences/note to consider: ${userInfo.notes}
- hobbies: ${userInfo.hobbies}
- personal goal: ${userInfo.goals}
- gender: ${userInfo.gender}
- Available time slots: {calculate_free_time_based_on_job}
- Budget: {estimate_based_on_occupation}

3. **Scheduling Rules:**
- Never schedule more than 2 new habits per week
- Minimum 30 minutes buffer between work-related and self-care activities
- Morning routines max 45 minutes
- Evening routines max 1 hour
- Weekly goals should align with days off work when possible
- Include progressive overload for fitness goals

4. **Output Requirements:**
- All time slots must have concrete start times add related emoji to time_slot
-every slot most have an action at least
- Duration in whole minutes only
- Include location requirements
- Specify needed preparation items
- Add progress checkpoints
- Flag conflicts with typical work hours
- Include alternate actions for bad days
-organize time slot by order> morning> afternoon> evening > night 

5. **Special Instructions:**
- Assume user wakes up at {calculate_wakeup_time_based_on_job}
- Prioritize home-based activities for first 2 weeks
- Suggest specific YouTube workout videos when relevant
- Recommend exact product names for skincare don't recommend product from companies that support israel, recommend korean skin care but not from COSRX company
- Include 5-minute buffer between consecutive tasks
-the actions starts from ${DateTime.now()} to 3 months add the start date and end date form actions accordingly make sure its starts from ${DateTime.now()} in the year ${DateTime.now().year} and month ${DateTime.now().month}
-make sure the json response in correctly formatted 
Focus on creating a time-bound, executable schedule rather than general advice. The output should be ready for direct import into a digital calendar.''';
}

String actionUpdatePrompt({required ScheduleAction action}) {
  return '''
Update the following action by filling missing fields based on existing schedule context.
Return  the updated action and timeSlot in valid JSON format without any additional text or explanations.

Original action:
${action.toJson()}

Update rules:
1. Preserve existing values unless they're null/empty
2. Add realistic duration based on action type duration type is int in Minutes
3. Set appropriate category if missing
4. Generate sensible description if empty
5. Add recurrence rules if relevant
6. Never modify 'instances' field
7. Ensure all dates are in ISO 8601 format
8. add slot that matches the action
9. if action is not recurring create an action instance and set date property to ${DateTime.now()} it should look like {'id':'unique-id','date':'','status':'todo'}
match the types in the original glow up response 
the returned response should look like :
{
"action":${action.toJson()},//updated action
"slot":"Morning/Afternoon/Evening/Night"
}
''';
}
