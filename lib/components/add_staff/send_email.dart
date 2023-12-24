import 'package:sendgrid_mailer/sendgrid_mailer.dart';
// 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

Future<void> sendEmail({
  required String imageURL,
  required String receiverEmail,
  required String name,
  required String registrationNo,
}) async {
  final mailer = Mailer(
      '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');
  final toAddress = Address(receiverEmail);
  const fromAddress = Address('advantage.redhat@gmail.com');
  const subject = 'Invitation from Vectra Pro (Redhat academy)';
  final personalization = Personalization([
    toAddress
  ], dynamicTemplateData: {
    "image_url": imageURL,
    "name": name,
    "registrationID": registrationNo,
    "app_link": "http://www.google.com",
  });

  final email = Email([personalization], fromAddress, subject,
      templateId: "d-33064115105143d18bc332f22b8cc04e");
  mailer.send(email).then((result) {
    print("error:      ${result.isError}");
  });
}
