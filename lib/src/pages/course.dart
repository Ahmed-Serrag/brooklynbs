import 'package:clean_one/src/widgets/Course_Card.dart';
import 'package:flutter/material.dart';

class CoursePage extends StatelessWidget {
  const CoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Courses',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30), // Rounded top-left corner
            topRight: Radius.circular(30), // Rounded top-right corner
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: const SingleChildScrollView(
          child: Column(
            children: [
              CourseCard(
                title: 'Product Design v1.0',
                instructor: 'Robertson Connie',
                price: '\$190',
                duration: '16 hours',
              ),
              SizedBox(height: 16),
              CourseCard(
                title: 'Java Development',
                instructor: 'Nguyen Shane',
                price: '\$190',
                duration: '16 hours',
              ),
              SizedBox(height: 16),
              CourseCard(
                title: 'Visual Design',
                instructor: 'Bert Pullman',
                price: '\$250',
                duration: '14 hours',
              ),
              SizedBox(height: 16),
              CourseCard(
                title: 'Visual Design',
                instructor: 'Bert Pullman',
                price: '\$250',
                duration: '14 hours',
              ),
              SizedBox(height: 16),
              CourseCard(
                title: 'Visual Design',
                instructor: 'Bert Pullman',
                price: '\$250',
                duration: '14 hours',
              ),
              SizedBox(height: 16),
              CourseCard(
                title: 'Visual Design',
                instructor: 'Bert Pullman',
                price: '\$250',
                duration: '14 hours',
              ),
              SizedBox(height: 16),
              CourseCard(
                title: 'Visual Design',
                instructor: 'Bert Pullman',
                price: '\$250',
                duration: '14 hours',
              ),
              SizedBox(height: 16),
              CourseCard(
                title: 'Visual Design',
                instructor: 'Bert Pullman',
                price: '\$250',
                duration: '14 hours',
              ),
              SizedBox(height: 16),
              CourseCard(
                title: 'Visual Design',
                instructor: 'Bert Pullman',
                price: '\$250',
                duration: '14 hours',
              ),
              SizedBox(height: 16),
              CourseCard(
                title: 'Visual Design',
                instructor: 'Bert Pullman',
                price: '\$250',
                duration: '14 hours',
              ),
              SizedBox(height: 16),
              CourseCard(
                title: 'Visual Design',
                instructor: 'Bert Pullman',
                price: '\$250',
                duration: '14 hours',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
