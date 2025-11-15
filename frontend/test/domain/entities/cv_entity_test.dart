import 'package:flutter_test/flutter_test.dart';
import 'package:jobsiq_mobile/domain/entities/cv_entity.dart';

void main() {
  group('CvEntity', () {
    final tCvEntity = CvEntity(
      id: 1,
      userId: 1,
      title: 'Software Engineer CV',
      slug: 'software-engineer-cv',
      fullName: 'John Doe',
      email: 'john@example.com',
      phone: '+1234567890',
      website: 'https://johndoe.com',
      linkedin: 'https://linkedin.com/in/johndoe',
      github: 'https://github.com/johndoe',
      profileImagePath: 'path/to/image.jpg',
      address: '123 Main St',
      city: 'New York',
      country: 'USA',
      postalCode: '10001',
      workExperience: const [],
      education: const [],
      skills: const ['Flutter', 'Dart', 'Firebase'],
      languages: const [],
      certifications: const [],
      projects: const [],
      isPublic: true,
      isPrimary: true,
      template: 'modern',
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    );

    group('copyWith', () {
      test('should return new instance with updated title', () {
        final result = tCvEntity.copyWith(title: 'Updated Title');

        expect(result.title, 'Updated Title');
        expect(result.id, tCvEntity.id);
        expect(result.email, tCvEntity.email);
        expect(result.fullName, tCvEntity.fullName);
      });

      test('should return new instance with updated email and phone', () {
        final result = tCvEntity.copyWith(
          email: 'newemail@example.com',
          phone: '+9876543210',
        );

        expect(result.email, 'newemail@example.com');
        expect(result.phone, '+9876543210');
        expect(result.title, tCvEntity.title);
        expect(result.fullName, tCvEntity.fullName);
      });

      test('should return new instance with updated boolean fields', () {
        final result = tCvEntity.copyWith(
          isPublic: false,
          isPrimary: false,
        );

        expect(result.isPublic, false);
        expect(result.isPrimary, false);
        expect(result.title, tCvEntity.title);
      });

      test('should return new instance with updated skills', () {
        final newSkills = ['Rust', 'Go', 'Python'];
        final result = tCvEntity.copyWith(skills: newSkills);

        expect(result.skills, newSkills);
        expect(result.skills!.length, 3);
        expect(result.title, tCvEntity.title);
      });

      test('should return new instance with updated work experience', () {
        final newWorkExp = [
          WorkExperienceEntity(
            jobTitle: 'Senior Developer',
            company: 'Tech Corp',
            startDate: DateTime(2024, 1, 1),
            isCurrent: true,
          ),
        ];
        final result = tCvEntity.copyWith(workExperience: newWorkExp);

        expect(result.workExperience, newWorkExp);
        expect(result.workExperience!.length, 1);
        expect(result.workExperience!.first.jobTitle, 'Senior Developer');
      });

      test('should return new instance with updated dates', () {
        final newCreatedAt = DateTime(2024, 6, 1);
        final newUpdatedAt = DateTime(2024, 6, 15);
        final result = tCvEntity.copyWith(
          createdAt: newCreatedAt,
          updatedAt: newUpdatedAt,
        );

        expect(result.createdAt, newCreatedAt);
        expect(result.updatedAt, newUpdatedAt);
        expect(result.title, tCvEntity.title);
      });

      test('should not change original instance', () {
        final result = tCvEntity.copyWith(title: 'New Title');

        expect(tCvEntity.title, 'Software Engineer CV');
        expect(result.title, 'New Title');
      });

      test(
          'should return instance with all same values when no parameters provided',
          () {
        final result = tCvEntity.copyWith();

        expect(result.id, tCvEntity.id);
        expect(result.userId, tCvEntity.userId);
        expect(result.title, tCvEntity.title);
        expect(result.slug, tCvEntity.slug);
        expect(result.fullName, tCvEntity.fullName);
        expect(result.email, tCvEntity.email);
        expect(result.phone, tCvEntity.phone);
        expect(result.website, tCvEntity.website);
        expect(result.linkedin, tCvEntity.linkedin);
        expect(result.github, tCvEntity.github);
        expect(result.profileImagePath, tCvEntity.profileImagePath);
        expect(result.address, tCvEntity.address);
        expect(result.city, tCvEntity.city);
        expect(result.country, tCvEntity.country);
        expect(result.postalCode, tCvEntity.postalCode);
        expect(result.isPublic, tCvEntity.isPublic);
        expect(result.isPrimary, tCvEntity.isPrimary);
        expect(result.template, tCvEntity.template);
        expect(result.createdAt, tCvEntity.createdAt);
        expect(result.updatedAt, tCvEntity.updatedAt);
      });

      test('should update multiple nullable fields at once', () {
        final result = tCvEntity.copyWith(
          website: 'https://newwebsite.com',
          github: 'https://github.com/newuser',
          profileImagePath: 'new/path/image.jpg',
          address: '456 New Street',
        );

        expect(result.website, 'https://newwebsite.com');
        expect(result.github, 'https://github.com/newuser');
        expect(result.profileImagePath, 'new/path/image.jpg');
        expect(result.address, '456 New Street');
        expect(result.email, tCvEntity.email);
      });
    });

    group('Helper getters', () {
      test('experienceCount returns correct count', () {
        final cvWithExperience = tCvEntity.copyWith(
          workExperience: [
            WorkExperienceEntity(
              jobTitle: 'Developer',
              company: 'Company A',
              startDate: DateTime(2020, 1, 1),
              isCurrent: false,
            ),
            WorkExperienceEntity(
              jobTitle: 'Senior Developer',
              company: 'Company B',
              startDate: DateTime(2021, 1, 1),
              isCurrent: true,
            ),
          ],
        );

        expect(cvWithExperience.experienceCount, 2);
      });

      test('experienceCount returns 0 when null', () {
        final cvWithoutExperience = tCvEntity.copyWith(workExperience: null);
        expect(cvWithoutExperience.experienceCount, 0);
      });

      test('educationCount returns correct count', () {
        final cvWithEducation = tCvEntity.copyWith(
          education: [
            EducationEntity(
              degree: 'Bachelor of Science',
              institution: 'University A',
              startDate: DateTime(2016, 9, 1),
              isCurrent: false,
            ),
          ],
        );

        expect(cvWithEducation.educationCount, 1);
      });

      test('skillsCount returns correct count', () {
        expect(tCvEntity.skillsCount, 3);
      });

      test('skillsCount returns 0 when null', () {
        final cvWithoutSkills = tCvEntity.copyWith(skills: null);
        expect(cvWithoutSkills.skillsCount, 0);
      });
    });
  });

  group('WorkExperienceEntity', () {
    test('should be properly created with required fields', () {
      final workExp = WorkExperienceEntity(
        jobTitle: 'Software Engineer',
        company: 'Tech Company',
        startDate: DateTime(2020, 1, 1),
        isCurrent: true,
      );

      expect(workExp.jobTitle, 'Software Engineer');
      expect(workExp.company, 'Tech Company');
      expect(workExp.isCurrent, true);
      expect(workExp.endDate, null);
    });

    test('should support optional fields', () {
      final workExp = WorkExperienceEntity(
        jobTitle: 'Developer',
        company: 'Company',
        location: 'New York',
        startDate: DateTime(2020, 1, 1),
        endDate: DateTime(2022, 1, 1),
        isCurrent: false,
        description: 'Did development work',
      );

      expect(workExp.location, 'New York');
      expect(workExp.description, 'Did development work');
      expect(workExp.endDate, DateTime(2022, 1, 1));
    });
  });

  group('EducationEntity', () {
    test('should be properly created', () {
      final education = EducationEntity(
        degree: 'Bachelor of Science',
        institution: 'University',
        startDate: DateTime(2016, 9, 1),
        isCurrent: false,
        endDate: DateTime(2020, 6, 1),
      );

      expect(education.degree, 'Bachelor of Science');
      expect(education.institution, 'University');
      expect(education.isCurrent, false);
    });
  });

  group('LanguageEntity', () {
    test('should be properly created', () {
      const language = LanguageEntity(
        language: 'English',
        proficiency: 'Native',
      );

      expect(language.language, 'English');
      expect(language.proficiency, 'Native');
    });
  });

  group('CertificationEntity', () {
    test('should be properly created with all fields', () {
      final cert = CertificationEntity(
        name: 'AWS Certified',
        issuingOrganization: 'Amazon',
        issueDate: DateTime(2023, 1, 1),
        expiryDate: DateTime(2026, 1, 1),
        credentialId: '12345',
      );

      expect(cert.name, 'AWS Certified');
      expect(cert.issuingOrganization, 'Amazon');
      expect(cert.credentialId, '12345');
    });
  });

  group('ProjectEntity', () {
    test('should be properly created', () {
      final project = ProjectEntity(
        name: 'E-commerce App',
        description: 'Built a mobile app',
        url: 'https://github.com/project',
        startDate: DateTime(2023, 1, 1),
        technologies: const ['Flutter', 'Firebase'],
      );

      expect(project.name, 'E-commerce App');
      expect(project.technologies!.length, 2);
    });
  });
}
