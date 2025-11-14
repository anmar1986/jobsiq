import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobsiq_mobile/domain/entities/job_entity.dart';
import 'package:jobsiq_mobile/presentation/widgets/common/job_card.dart';

void main() {
  group('JobCard Widget Tests', () {
    late JobEntity testJob;

    setUp(() {
      testJob = JobEntity(
        id: 1,
        title: 'Flutter Developer',
        slug: 'flutter-developer',
        description: 'Build amazing apps',
        employmentType: 'full-time',
        location: 'New York, USA',
        experienceLevel: 'Mid Level',
        salaryMin: 80000,
        salaryMax: 120000,
        salaryCurrency: 'USD',
        salaryPeriod: 'year',
        isRemote: true,
        isFeatured: true,
        isActive: true,
        isSaved: false,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
        company: const CompanyBriefEntity(
          id: 1,
          name: 'Tech Corp',
          slug: 'tech-corp',
        ),
      );
    });

    Widget createTestWidget(JobEntity job,
        {VoidCallback? onTap, VoidCallback? onSaveToggle}) {
      return ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => MaterialApp(
          home: Scaffold(
            body: JobCard(
              job: job,
              onTap: onTap,
              onSaveToggle: onSaveToggle,
            ),
          ),
        ),
      );
    }

    testWidgets('displays job title correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(testJob));

      expect(find.text('Flutter Developer'), findsOneWidget);
    });

    testWidgets('displays company name correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(testJob));

      expect(find.text('Tech Corp'), findsOneWidget);
    });

    testWidgets('displays location when provided', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(testJob));

      expect(find.textContaining('New York'), findsOneWidget);
    });

    testWidgets('displays employment type', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(testJob));

      // Employment type is now formatted (e.g., 'full-time' -> 'Full Time')
      expect(find.textContaining('Full Time'), findsWidgets);
    });

    testWidgets('displays salary range when provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(testJob));

      // Salary is displayed via salaryRange property
      expect(find.text(testJob.salaryRange), findsOneWidget);
    });

    testWidgets('displays remote badge when job is remote',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(testJob));

      expect(find.textContaining('Remote'), findsOneWidget);
    });

    testWidgets('displays outline bookmark icon for unsaved jobs',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(testJob));

      // Job is not saved (isSaved: false), so bookmark_border_rounded icon should be displayed
      expect(find.byIcon(Icons.bookmark_border_rounded), findsOneWidget);
    });

    testWidgets('calls onTap when card is tapped', (WidgetTester tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(createTestWidget(
        testJob,
        onTap: () => wasTapped = true,
      ));

      // Find the Card widget and tap it instead of InkWell (there are multiple InkWells)
      await tester.tap(find.byType(Card));
      await tester.pumpAndSettle();

      expect(wasTapped, isTrue);
    });

    testWidgets('calls onSaveToggle when save icon is tapped',
        (WidgetTester tester) async {
      bool wasToggled = false;

      await tester.pumpWidget(createTestWidget(
        testJob,
        onSaveToggle: () => wasToggled = true,
      ));

      await tester.tap(find.byIcon(Icons.bookmark_outline_rounded));
      await tester.pumpAndSettle();

      expect(wasToggled, isTrue);
    });

    testWidgets('displays filled bookmark icon when job is saved',
        (WidgetTester tester) async {
      final savedJob = JobEntity(
        id: 1,
        title: 'Flutter Developer',
        slug: 'flutter-developer',
        description: 'Build amazing apps',
        employmentType: 'full-time',
        isRemote: false,
        isFeatured: false,
        isActive: true,
        isSaved: true,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      await tester.pumpWidget(createTestWidget(savedJob));

      expect(find.byIcon(Icons.bookmark_rounded), findsOneWidget);
    });

    testWidgets('does not display salary when not provided',
        (WidgetTester tester) async {
      final jobWithoutSalary = JobEntity(
        id: 1,
        title: 'Flutter Developer',
        slug: 'flutter-developer',
        description: 'Build amazing apps',
        employmentType: 'full-time',
        isRemote: false,
        isFeatured: false,
        isActive: true,
        isSaved: false,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      await tester.pumpWidget(createTestWidget(jobWithoutSalary));

      expect(find.textContaining('K'), findsNothing);
    });

    testWidgets('renders correctly for different employment types',
        (WidgetTester tester) async {
      final partTimeJob = JobEntity(
        id: 1,
        title: 'Part Time Designer',
        slug: 'part-time-designer',
        description: 'Create designs',
        employmentType: 'part-time',
        isRemote: false,
        isFeatured: false,
        isActive: true,
        isSaved: false,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      await tester.pumpWidget(createTestWidget(partTimeJob));

      // Employment type is now formatted: 'part-time' -> 'Part Time'
      expect(find.textContaining('Part Time'), findsWidgets);
    });
  });
}
