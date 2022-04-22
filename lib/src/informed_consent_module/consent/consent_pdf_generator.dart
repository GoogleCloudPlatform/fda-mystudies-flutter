import 'dart:convert';
import 'dart:math';

import 'package:fda_mystudies_spec/study_datastore_service/get_eligibility_and_consent.pb.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../main.dart';

class ConsentPdfGenerator {
  static Future<String> generateBase64EncodingPdfString(
      String firstName,
      String lastName,
      List<Offset> points,
      double height,
      double width,
      List<GetEligibilityAndConsentResponse_Consent_VisualScreen>
          visualScreens) {
    var format = DateFormat('MM/dd/yyyy');
    var currentTime = format.format(DateTime.now());
    final pdf = pw.Document();
    pdf.addPage(pw.Page(build: (pw.Context context) {
      return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Text(curConfig.appName,
                      style: const pw.TextStyle(fontSize: 25)),
                  pw.SizedBox(height: 20),
                  pw.Text(
                      'Review this information and consent to participate in this study',
                      style: const pw.TextStyle(fontSize: 20)),
                  pw.SizedBox(height: 20)
                ])
          ]);
    }));
    for (var visualScreen in visualScreens) {
      pdf.addPage(pw.Page(
          build: (pw.Context context) => pw.Column(children: [
                pw.Text(visualScreen.title,
                    style: const pw.TextStyle(fontSize: 18)),
                pw.SizedBox(height: 12),
                pw.Text(
                    parse(parse(visualScreen.html).body?.text)
                            .documentElement
                            ?.text
                            .replaceAll('’', '\'') ??
                        '',
                    style: const pw.TextStyle(fontSize: 16)),
                pw.SizedBox(height: 20)
              ])));
    }
    pdf.addPage(pw.Page(build: (pw.Context context) {
      return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            pw.Text('I agree to participate in this research study.',
                style: const pw.TextStyle(fontSize: 16)),
            pw.SizedBox(height: 40),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('$firstName $lastName',
                            style: const pw.TextStyle(fontSize: 16)),
                        pw.Divider(),
                        pw.Text('Participant\'s Name (printed)')
                      ]),
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Transform(
                            alignment: pw.Alignment.center,
                            transform: Matrix4.rotationX(pi),
                            child: _drawSignature(points, height, width)),
                        pw.Divider(),
                        pw.Text('Participant\'s Signature')
                      ]),
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(currentTime,
                            style: const pw.TextStyle(fontSize: 16)),
                        pw.Divider(),
                        pw.Text('Date'),
                      ])
                ]),
          ]);
    }));
    return pdf.save().then((pdfBytes) {
      return base64.encode(pdfBytes);
    });
  }

  static pw.CustomPaint _drawSignature(
      List<Offset> points, double height, double width) {
    return pw.CustomPaint(
        size: const PdfPoint(100, 100),
        painter: (PdfGraphics canvas, PdfPoint size) {
          var rx = width / 100;
          var ry = height / 100;
          for (int i = 0; i < points.length - 1; ++i) {
            if (points[i] != Offset.infinite &&
                points[i + 1] != Offset.infinite) {
              canvas
                ..drawLine(points[i].dx / rx, points[i].dy / ry,
                    points[i + 1].dx / rx, points[i + 1].dy / ry)
                ..setFillColor(PdfColors.black)
                ..setLineWidth(1)
                ..fillAndStrokePath();
            }
          }
          canvas.setTransform(Matrix4.rotationX(pi));
        });
  }
}
