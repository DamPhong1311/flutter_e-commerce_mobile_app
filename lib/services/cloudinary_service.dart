
// tải file lên cloudinary

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<bool> upLoadToCloudinary(FilePickerResult?  filePickerResult) async{
  if(filePickerResult == null || filePickerResult.files.isEmpty){
    print('No file selected');
    return false;
  }
  File file = File(filePickerResult.files.single.path!);

  String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';

  var uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/raw/upload");
  // taọ MultipartRequest để upload file
  var request = http.MultipartRequest("POST", uri);

  //read the file content as bytes 
  var fileBytes  = await file.readAsBytes();

  var multipartFile = http.MultipartFile.fromBytes(
    'file',
    fileBytes,
    filename: file.path.split("/").last,
  );

  // add the file part to request
  request.files.add(multipartFile);

  request.fields['upload_request'] = "preset_for_file_upload";
  request.fields['resource_type'] = "raw";

  // send request and await response
  var response = await request.send();

  //get the response as text
  var responseBody = await response.stream.bytesToString();

  print(responseBody);

  if(response.statusCode == 200){
    print('upload successfull');
    return true;
  
  }
  else{
    print('upload failed with status: ${response.statusCode}');
    return false;
  }
}