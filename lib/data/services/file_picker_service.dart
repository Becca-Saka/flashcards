import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class FilePickerService {
  final imagePicker = ImagePicker();
  final filePicker = FilePicker.platform;

  Future<List<XFile>?> pickFile() async {
    final file = await filePicker.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: [
        'pdf',
        'png',
      ],
    );

    return file?.files.map((e) => e.xFile).toList();
  }

  Future<bool?> clearFiles() async {
    return await filePicker.clearTemporaryFiles();
  }

  Future<XFile?> pickImage({required ImageSource source}) async {
    final file = await imagePicker.pickImage(source: source);
    if (file == null) return null;
    return file;
  }

  Future<List<XFile>> pickMultipleImage() async {
    final files = await imagePicker.pickMultiImage();
    return files;
  }
}
