import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/patient.dart';

/// Builds a patient register PDF and opens the system share/print sheet.
Future<void> exportPatientsPdf(List<Patient> patients) async {
  final doc = pw.Document();
  final fmt = DateFormat('dd MMM yyyy');

  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      header: (_) => pw.Text(
        'Patient Register',
        style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
      ),
      footer: (c) => pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.Text('Page ${c.pageNumber} of ${c.pagesCount}'),
      ),
      build: (_) => [
        pw.SizedBox(height: 12),
        pw.TableHelper.fromTextArray(
          headers: const ['#', 'Name', 'Age', 'Gender', 'Phone', 'Registered'],
          data: [
            for (var i = 0; i < patients.length; i++)
              [
                '${i + 1}',
                patients[i].name,
                '${patients[i].age}',
                patients[i].gender,
                patients[i].phone,
                fmt.format(patients[i].createdAt),
              ],
          ],
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
          cellPadding: const pw.EdgeInsets.all(6),
        ),
      ],
    ),
  );

  await Printing.sharePdf(
    bytes: await doc.save(),
    filename: 'patient_register.pdf',
  );
}
