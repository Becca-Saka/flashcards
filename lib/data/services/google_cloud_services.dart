// import 'dart:io';
// import 'dart:typed_data';
// import 'package:googleapis/storage/v1.dart';
// import 'package:googleapis_auth/auth_io.dart';

// Future<dynamic> uploadFileToStorage(File file) async {
//     try {
//       /// Load the credentials from the JSON key file.
//       final credentials = ServiceAccountCredentials.fromJson({
//         "type": "service_account",
//         "project_id": "<project_id>",
//         "private_key_id": "<private_key_id>",
//         "private_key": "<private_key>",
//         "client_email": "<client_email>",
//         "client_id": "<client_id>",
//         "auth_uri": "<auth_uri>",
//         "token_uri": "<token_uri>",
//         "auth_provider_x509_cert_url": "<auth_provider_x509_cert_url>",
//         "client_x509_cert_url": "<client_x509_cert_url>",
//         "universe_domain": "<universe_domain>"
//       });

//       // Create an HTTP client using the credentials and required scope
//       final httpClient = await clientViaServiceAccount(
//           credentials, [StorageApi.devstorageReadWriteScope]);

//       /// Create the Storage API client.
//       final storage = StorageApi(httpClient);

//       // Define the GCS uploading file folder and name
//       final fileFolderAndName = '$<uploading-folder-path>$<filename>';

//       // Read file content as bytes
//       final fileContent = await file.readAsBytes();

//       // Create Storage API object with file name
//       final bucketObject = Object(name: fileFolderAndName);

//       // Upload file to Google Cloud Storage
//       final resp = await storage.objects.insert(
//         bucketObject,
//         <bucket-name>,
//         uploadMedia: Media(
//           Stream<List<int>>.fromIterable([fileContent]),
//           fileContent.length,
//         ),
//       );

//       // Check if upload was successful
//       if (resp.id != null && resp.id!.isNotEmpty) {
//         return {"etag": resp.etag ?? ""};
//       }
//     } catch (e) {
//       // Handle any errors that occur during the upload
//       print("Upload GCS Error $e");
//     }
//     // Return an empty etag if the upload fails
//     return {"etag": ""};
// }