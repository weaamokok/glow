import 'package:flutter/material.dart';

class PersonalGoalsStep extends StatelessWidget {
  const PersonalGoalsStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          SizedBox(
              height: 46,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "what's your goal from this glow up",
                ),
                onChanged: (value) {},
              )),
          SizedBox(
              height: 46,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Any notes to take in consideration",
                ),
                onChanged: (value) {},
              )),
        ],
      ),
    );
  }
}
