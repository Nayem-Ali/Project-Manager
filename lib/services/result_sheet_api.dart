import 'package:firebase_auth/firebase_auth.dart';
import 'package:gsheets/gsheets.dart';

import '../model/result_model.dart';

class ResultSheetApi {
  static const spreadsheetId = '1h_AKiwN82RWy5Tt5muSFaDKReL28eZw4P5ES0eQvqJc';
  static const credentials = r'''
  {
  "type": "service_account",
  "project_id": "result-410019",
  "private_key_id": "fa30ae24674738a517c40341990a8d7b587c8926",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQD0djA/tIuuTxob\nZBGu+Qt9ejDelpEIDLW8NPgKOUdZLiCSw0QMDCG6pd6NeEbagK1KIBwRjs9nS2CL\n3Nu3OCd0ZRbNsvesQE8ocsTjifq+Qc09rifVsmQBgrtUs+RkDCfEFqoCQyxPNjFY\nG7h/xFqkQ61xoERwt8CHvgJgroCB2rQ2BtBwym41VIuKZWfe6FYRsHuOOysdadd1\nlzUhxGFoO+JiTGM+7he71EOI+lWr+gvjAhf0LVafmnSWHdijE381Yi9cmJbW9R3f\nCzIA9wAdThzTKwVPLt9YAym2LW7X7W4BbJkajE+wkBOdSizc2+Q7cLG9QmfpzKGU\nEPjr18lZAgMBAAECggEAS4n10MmeW+dvfsVGPZYROd23GiDWgfFDevu3JZmbdXAu\neotCDKL3DTDR+08OPdiDM6OGaNqDNjzxgWZmsk/0yR+vkzJZG+3nR+1m75SkWYQF\nwqh9AKiWBG18K2lHCq9C3nHOaNKO748kYkB2m2x2Qcnz32eRnm75XDiXjX5+kSED\n8YoqriZb7sc5Oe3T+9xy/aCy4acpiBrm39LYH5/jaIYEQvvUQWgLbJ3MzZ+RfhIy\nEmTtzp7CFVJLruaXJRMHRgupqQ5gguYElKD3BHC2Cvklxlz636+MKEWu/BjwTOEV\nlfBd58vh57l/8pz4vI/X48vzsso+a/Ge/WKqm5scTQKBgQD7R6JqX1iMo3pHsk3u\nA66BLreRULtPMmxfWwOLQpucYrNy3Que2cTysW9Sq8S2+L6sMJQo5+SDtf6F5VMr\nj9iCRrWtNrDw//zZo+Rc77Ul9MSoT/G01km46VApuA3iwN091tO9XFcjZpHroq6R\nRa540VXgApLiHnvJTLymHRfi2wKBgQD5DcRBWolhXz9OqcXqRGV/JukuxvYAtql+\nMBIXIzuXmJWcUktofVPCxWHgWWF4p3q6/324ZHndCYlPxhBKmm1vbJHjsTmIA+pu\nSxXluT0rNL7+kzFpFtSxbSV20vqxUjhLFFyPo9cs+gS72yUAkBqD2tEqG7IzLjvc\nbMcEvmuo2wKBgFtx5E9lx2nXDGcPIoEd4eGtSKyffqsBpKLHEnEZmlu9J6UDgHkc\nsynHHMYvMHWN7IXpX+HLEkREdQ3xOOU/ggFXDkKtBpON9UyW8kJIEdpwSykdfs7a\ntRWQAtZL3vHIUjtw9LmS4ztE1pG0MGc5vpbFR8Uv6phTk6TcQkMJj2nFAoGAH5CB\nGQ9SbgbWTS/zJ3e3rV/PGeCZeQmtfZK2GDyc5t+txnwfloSbwwmlF/v8AICpa13K\nHz6Mu1jkEDo4AlyEFiUacFMbyYNFiOj3Q4AwonMy6azaDEmad0ov/1lJ8INNIybX\nfFT1hnvBcdWaYPHiimeHLuEHurjXWV5n8s/3cRUCgYBlHucrXU2512G/jLdYLPK7\n3A1GchtjW4jxqlGL+g5+SYjEELFHJskSVwJKB8NO6fsLndiTasWEM3npJUvaFwtv\n8ewTF9+bMrADtwUjhhHRbITCZDnO0HWsA4GDmb9x52L9gSmZIJdtegIJpwNzigxO\nQ8M5iYmpy94tDHg/DaiRYQ==\n-----END PRIVATE KEY-----\n",
  "client_email": "result@result-410019.iam.gserviceaccount.com",
  "client_id": "105548947667189877330",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/result%40result-410019.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
  ''';

  static final gsheets = GSheets(credentials);
  static Worksheet? result3300;
  static Worksheet? result4800;
  static Worksheet? result4801;

  static Future initialize() async {
    try {
      final spreadSheet = await gsheets.spreadsheet(spreadsheetId);
      result3300 = await getWorkSheet(spreadSheet, title: "CSE-3300");
      result4800 = await getWorkSheet(spreadSheet, title: "CSE-4800");
      result4801 = await getWorkSheet(spreadSheet, title: "CSE-4801");

      final firstRow = ResultFields.getFields();

      result3300!.values.insertRow(1, firstRow);
      result4800!.values.insertRow(1, firstRow);
      result4801!.values.insertRow(1, firstRow);
    } catch (e) {
      print("$e");
      // Get.snackbar(
      //   "Oops",
      //   "Something went wrong",
      // );
    }
  }

  static Future<Worksheet> getWorkSheet(Spreadsheet spreadsheet, {required String title}) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  static addResult(Map<String, dynamic> resultData, String type) async {
    // DataBaseMethods dataBaseMethods = DataBaseMethods();
    if (result3300 == null || result4800 == null || result4801 == null) return null;
    if (type == 'CSE-3300') {
      // await result3300!.deleteRow(2,count: result3300!.rowCount);
      final lastRow = await result3300!.values.lastRow();
      resultData['ID'] = ((int.tryParse(lastRow!.first) ?? 0) + 1).toString();
      await result3300!.values.map.appendRow(resultData);
    } else if (type == 'CSE-4800') {
      // await result3300!.deleteRow(2,count: result3300!.rowCount);
      final lastRow = await result4800!.values.lastRow();
      resultData['ID'] = ((int.tryParse(lastRow!.first) ?? 0) + 1).toString();
      await result4800!.values.map.appendRow(resultData);
    } else {
      // await result3300!.deleteRow(2,count: result3300!.rowCount);
      final lastRow = await result4801!.values.lastRow();
      resultData['ID'] = ((int.tryParse(lastRow!.first) ?? 0) + 1).toString();
      await result4801!.values.map.appendRow(resultData);
    }
    // dataBaseMethods.updateDataAfterProposalSubmission(proposalData['ID'], type);
  }

  static deleteResult(String type) async {
    // DataBaseMethods dataBaseMethods = DataBaseMethods();
    if (result3300 == null || result4800 == null || result4801 == null) return null;
    if (type == 'CSE-3300') {
      if (result3300!.rowCount > 1) {
        await result3300!.deleteRow(2, count: result3300!.rowCount);
      }
    } else if (type == 'CSE-4800') {
      if (result4800!.rowCount > 1) {
        await result4800!.deleteRow(2, count: result4800!.rowCount);
      }
    } else {
      if (result4801!.rowCount > 1) {
        await result4801!.deleteRow(2, count: result4801!.rowCount);
      }
    }
    // dataBaseMethods.updateDataAfterProposalSubmission(proposalData['ID'], type);
  }

  static getResult(String type) async {
    dynamic allData = [];
    if (type == 'CSE-3300') {
      allData = await result3300!.values.map.allRows();
    } else if (type == 'CSE-4800') {
      allData = await result4800!.values.map.allRows();
    } else {
      allData = await result4801!.values.map.allRows();
    }
    return allData;
  }

  static giveAccess() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final spreadSheet = await gsheets.spreadsheet(spreadsheetId);
    await spreadSheet.share(
      "${auth.currentUser!.email}",
      role: PermRole.writer,
      type: PermType.user,
      // withLink: true
    );
    final url = spreadSheet.url;
    return url;
  }
}
