import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/cv_entity.dart';

class CvPdfGenerator {
  /// Generate PDF from CV entity
  static Future<pw.Document> generatePdf(CvEntity cv) async {
    final pdf = pw.Document();

    // Load fonts
    final fontRegular = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();
    final fontItalic = await PdfGoogleFonts.robotoItalic();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          // Header Section with Name and Contact
          _buildHeader(cv, fontBold, fontRegular),
          pw.SizedBox(height: 20),
          pw.Divider(thickness: 2),
          pw.SizedBox(height: 20),

          // Work Experience Section
          if (cv.workExperience != null && cv.workExperience!.isNotEmpty) ...[
            _buildSectionTitle('Work Experience', fontBold),
            pw.SizedBox(height: 10),
            ...cv.workExperience!.map((exp) =>
                _buildWorkExperience(exp, fontBold, fontRegular, fontItalic)),
            pw.SizedBox(height: 20),
          ],

          // Education Section
          if (cv.education != null && cv.education!.isNotEmpty) ...[
            _buildSectionTitle('Education', fontBold),
            pw.SizedBox(height: 10),
            ...cv.education!.map((edu) =>
                _buildEducation(edu, fontBold, fontRegular, fontItalic)),
            pw.SizedBox(height: 20),
          ],

          // Skills Section
          if (cv.skills != null && cv.skills!.isNotEmpty) ...[
            _buildSectionTitle('Skills', fontBold),
            pw.SizedBox(height: 10),
            _buildSkills(cv.skills!, fontRegular),
            pw.SizedBox(height: 20),
          ],

          // Languages Section
          if (cv.languages != null && cv.languages!.isNotEmpty) ...[
            _buildSectionTitle('Languages', fontBold),
            pw.SizedBox(height: 10),
            _buildLanguages(cv.languages!, fontRegular),
            pw.SizedBox(height: 20),
          ],

          // Certifications Section
          if (cv.certifications != null && cv.certifications!.isNotEmpty) ...[
            _buildSectionTitle('Certifications', fontBold),
            pw.SizedBox(height: 10),
            ...cv.certifications!.map((cert) =>
                _buildCertification(cert, fontBold, fontRegular, fontItalic)),
            pw.SizedBox(height: 20),
          ],

          // Projects Section
          if (cv.projects != null && cv.projects!.isNotEmpty) ...[
            _buildSectionTitle('Projects', fontBold),
            pw.SizedBox(height: 10),
            ...cv.projects!.map((proj) =>
                _buildProject(proj, fontBold, fontRegular, fontItalic)),
          ],
        ],
        footer: (context) => pw.Container(
          alignment: pw.Alignment.center,
          margin: const pw.EdgeInsets.only(top: 10),
          child: pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: pw.TextStyle(
                fontSize: 10, font: fontRegular, color: PdfColors.grey),
          ),
        ),
      ),
    );

    return pdf;
  }

  static pw.Widget _buildHeader(
      CvEntity cv, pw.Font fontBold, pw.Font fontRegular) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          cv.fullName,
          style: pw.TextStyle(
              fontSize: 28, font: fontBold, color: PdfColors.blue800),
        ),
        pw.SizedBox(height: 8),
        if (cv.email.isNotEmpty)
          pw.Row(
            children: [
              pw.Icon(const pw.IconData(0xe0be),
                  size: 14, color: PdfColors.grey700),
              pw.SizedBox(width: 6),
              pw.Text(cv.email,
                  style: pw.TextStyle(fontSize: 11, font: fontRegular)),
            ],
          ),
        if (cv.phone != null && cv.phone!.isNotEmpty) ...[
          pw.SizedBox(height: 4),
          pw.Row(
            children: [
              pw.Icon(const pw.IconData(0xe0cd),
                  size: 14, color: PdfColors.grey700),
              pw.SizedBox(width: 6),
              pw.Text(cv.phone!,
                  style: pw.TextStyle(fontSize: 11, font: fontRegular)),
            ],
          ),
        ],
        if (cv.city != null || cv.country != null) ...[
          pw.SizedBox(height: 4),
          pw.Row(
            children: [
              pw.Icon(const pw.IconData(0xe0c8),
                  size: 14, color: PdfColors.grey700),
              pw.SizedBox(width: 6),
              pw.Text(
                [cv.city, cv.country]
                    .where((e) => e != null && e.isNotEmpty)
                    .join(', '),
                style: pw.TextStyle(fontSize: 11, font: fontRegular),
              ),
            ],
          ),
        ],
        if (cv.linkedin != null && cv.linkedin!.isNotEmpty) ...[
          pw.SizedBox(height: 4),
          pw.Text('LinkedIn: ${cv.linkedin}',
              style: pw.TextStyle(
                  fontSize: 10, font: fontRegular, color: PdfColors.blue)),
        ],
        if (cv.github != null && cv.github!.isNotEmpty) ...[
          pw.SizedBox(height: 4),
          pw.Text('GitHub: ${cv.github}',
              style: pw.TextStyle(
                  fontSize: 10, font: fontRegular, color: PdfColors.blue)),
        ],
        if (cv.website != null && cv.website!.isNotEmpty) ...[
          pw.SizedBox(height: 4),
          pw.Text('Website: ${cv.website}',
              style: pw.TextStyle(
                  fontSize: 10, font: fontRegular, color: PdfColors.blue)),
        ],
      ],
    );
  }

  static pw.Widget _buildSectionTitle(String title, pw.Font fontBold) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 6),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
            bottom: pw.BorderSide(width: 2, color: PdfColors.blue800)),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
            fontSize: 16, font: fontBold, color: PdfColors.blue800),
      ),
    );
  }

  static pw.Widget _buildWorkExperience(WorkExperienceEntity exp,
      pw.Font fontBold, pw.Font fontRegular, pw.Font fontItalic) {
    final dateFormat = DateFormat('MMM yyyy');
    final startDate = dateFormat.format(exp.startDate);
    final endDate = exp.isCurrent
        ? 'Present'
        : (exp.endDate != null ? dateFormat.format(exp.endDate!) : '');

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 12),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                child: pw.Text(
                  exp.jobTitle,
                  style: pw.TextStyle(fontSize: 13, font: fontBold),
                ),
              ),
              pw.Text(
                '$startDate - $endDate',
                style: pw.TextStyle(
                    fontSize: 10, font: fontRegular, color: PdfColors.grey700),
              ),
            ],
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            exp.company,
            style: pw.TextStyle(
                fontSize: 11, font: fontItalic, color: PdfColors.grey800),
          ),
          if (exp.location != null && exp.location!.isNotEmpty) ...[
            pw.SizedBox(height: 2),
            pw.Text(
              exp.location!,
              style: pw.TextStyle(
                  fontSize: 10, font: fontRegular, color: PdfColors.grey600),
            ),
          ],
          if (exp.description != null && exp.description!.isNotEmpty) ...[
            pw.SizedBox(height: 4),
            pw.Text(
              exp.description!,
              style: pw.TextStyle(fontSize: 10, font: fontRegular),
            ),
          ],
        ],
      ),
    );
  }

  static pw.Widget _buildEducation(EducationEntity edu, pw.Font fontBold,
      pw.Font fontRegular, pw.Font fontItalic) {
    final dateFormat = DateFormat('MMM yyyy');
    final startDate = dateFormat.format(edu.startDate);
    final endDate = edu.isCurrent
        ? 'Present'
        : (edu.endDate != null ? dateFormat.format(edu.endDate!) : '');

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 12),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                child: pw.Text(
                  edu.degree,
                  style: pw.TextStyle(fontSize: 13, font: fontBold),
                ),
              ),
              pw.Text(
                '$startDate - $endDate',
                style: pw.TextStyle(
                    fontSize: 10, font: fontRegular, color: PdfColors.grey700),
              ),
            ],
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            edu.institution,
            style: pw.TextStyle(
                fontSize: 11, font: fontItalic, color: PdfColors.grey800),
          ),
          if (edu.location != null && edu.location!.isNotEmpty) ...[
            pw.SizedBox(height: 2),
            pw.Text(
              edu.location!,
              style: pw.TextStyle(
                  fontSize: 10, font: fontRegular, color: PdfColors.grey600),
            ),
          ],
          if (edu.description != null && edu.description!.isNotEmpty) ...[
            pw.SizedBox(height: 4),
            pw.Text(
              edu.description!,
              style: pw.TextStyle(fontSize: 10, font: fontRegular),
            ),
          ],
        ],
      ),
    );
  }

  static pw.Widget _buildSkills(List<String> skills, pw.Font fontRegular) {
    return pw.Wrap(
      spacing: 8,
      runSpacing: 6,
      children: skills
          .map((skill) => pw.Container(
                padding:
                    const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: pw.BoxDecoration(
                  color: PdfColors.blue50,
                  borderRadius: pw.BorderRadius.circular(12),
                  border: pw.Border.all(color: PdfColors.blue200),
                ),
                child: pw.Text(
                  skill,
                  style: pw.TextStyle(
                      fontSize: 10,
                      font: fontRegular,
                      color: PdfColors.blue800),
                ),
              ))
          .toList(),
    );
  }

  static pw.Widget _buildLanguages(
      List<LanguageEntity> languages, pw.Font fontRegular) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: languages
          .map((lang) => pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 6),
                child: pw.Row(
                  children: [
                    pw.Text('${lang.language}: ',
                        style: pw.TextStyle(fontSize: 11, font: fontRegular)),
                    pw.Text(lang.proficiency,
                        style: pw.TextStyle(
                            fontSize: 11,
                            font: fontRegular,
                            color: PdfColors.grey700)),
                  ],
                ),
              ))
          .toList(),
    );
  }

  static pw.Widget _buildCertification(CertificationEntity cert,
      pw.Font fontBold, pw.Font fontRegular, pw.Font fontItalic) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(cert.name, style: pw.TextStyle(fontSize: 12, font: fontBold)),
          if (cert.issuingOrganization != null &&
              cert.issuingOrganization!.isNotEmpty) ...[
            pw.SizedBox(height: 2),
            pw.Text(cert.issuingOrganization!,
                style: pw.TextStyle(
                    fontSize: 10, font: fontItalic, color: PdfColors.grey800)),
          ],
          if (cert.issueDate != null) ...[
            pw.SizedBox(height: 2),
            pw.Text(
              'Issued: ${DateFormat('MMM yyyy').format(cert.issueDate!)}${cert.expiryDate != null ? ' - Expires: ${DateFormat('MMM yyyy').format(cert.expiryDate!)}' : ''}',
              style: pw.TextStyle(
                  fontSize: 9, font: fontRegular, color: PdfColors.grey600),
            ),
          ],
          if (cert.credentialId != null && cert.credentialId!.isNotEmpty) ...[
            pw.SizedBox(height: 2),
            pw.Text('Credential ID: ${cert.credentialId}',
                style: pw.TextStyle(
                    fontSize: 9, font: fontRegular, color: PdfColors.grey600)),
          ],
        ],
      ),
    );
  }

  static pw.Widget _buildProject(ProjectEntity proj, pw.Font fontBold,
      pw.Font fontRegular, pw.Font fontItalic) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(proj.name, style: pw.TextStyle(fontSize: 12, font: fontBold)),
          if (proj.url != null && proj.url!.isNotEmpty) ...[
            pw.SizedBox(height: 2),
            pw.Text(proj.url!,
                style: pw.TextStyle(
                    fontSize: 9, font: fontRegular, color: PdfColors.blue)),
          ],
          if (proj.description != null && proj.description!.isNotEmpty) ...[
            pw.SizedBox(height: 4),
            pw.Text(proj.description!,
                style: pw.TextStyle(fontSize: 10, font: fontRegular)),
          ],
          if (proj.technologies != null && proj.technologies!.isNotEmpty) ...[
            pw.SizedBox(height: 4),
            pw.Wrap(
              spacing: 6,
              runSpacing: 4,
              children: proj.technologies!
                  .map((tech) => pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: pw.BoxDecoration(
                          color: PdfColors.grey200,
                          borderRadius: pw.BorderRadius.circular(8),
                        ),
                        child: pw.Text(tech,
                            style:
                                pw.TextStyle(fontSize: 8, font: fontRegular)),
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  /// Download PDF to device
  static Future<File> downloadPdf(CvEntity cv) async {
    final pdf = await generatePdf(cv);
    final bytes = await pdf.save();

    final directory = await getApplicationDocumentsDirectory();
    final fileName =
        'CV_${cv.fullName.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File('${directory.path}/$fileName');

    await file.writeAsBytes(bytes);
    return file;
  }

  /// Share PDF
  static Future<void> sharePdf(CvEntity cv) async {
    final pdf = await generatePdf(cv);
    final bytes = await pdf.save();

    await Printing.sharePdf(
      bytes: bytes,
      filename: 'CV_${cv.fullName.replaceAll(' ', '_')}.pdf',
    );
  }

  /// Print PDF
  static Future<void> printPdf(CvEntity cv) async {
    final pdf = await generatePdf(cv);
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }
}
