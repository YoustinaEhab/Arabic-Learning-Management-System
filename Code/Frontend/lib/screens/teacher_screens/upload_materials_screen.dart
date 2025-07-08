import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_application_1/components/widgets/custom_text_form_field.dart';
import 'package:flutter_application_1/generated/l10n.dart';
import '../../components/widgets/custom_app_bar.dart';
import '../../services/api_services.dart';

class UploadMaterialScreen extends StatefulWidget {
  const UploadMaterialScreen({super.key});

  @override
  State<UploadMaterialScreen> createState() => _UploadMaterialScreenState();
}

class _UploadMaterialScreenState extends State<UploadMaterialScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();

  PlatformFile? _selectedFile;
  List<String> _tags = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  List<String> _getAISuggestedTags(String content) {
    if (content.toLowerCase().contains("math")) {
      return ["Math", "Algebra", "Calculus"];
    } else if (content.toLowerCase().contains("science")) {
      return ["Science", "Physics", "Chemistry"];
    }
    return ["General"];
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        setState(() {
          _selectedFile = result.files.first;
          final suggestedTags = _getAISuggestedTags(_selectedFile!.name);
          _tags = suggestedTags;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).fileError(e.toString()))),
      );
    }
  }

void _submitForm() async {
  if (_formKey.currentState!.validate() && _selectedFile != null) {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.orange)),
      );

      // Create a temp file with the title as the filename
      String title = _titleController.text.trim();
      // Replace only invalid filename characters
      String sanitizedTitle = title.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
      if (sanitizedTitle.isEmpty) {
        sanitizedTitle = 'uploaded_material';
      }
      // Ensure .pdf extension
      if (!sanitizedTitle.toLowerCase().endsWith('.pdf')) {
        sanitizedTitle += '.pdf';
      }
      String tempDir = Directory.systemTemp.path;
      String tempFilePath = '$tempDir/$sanitizedTitle';
      File tempFile = File(tempFilePath);
      await tempFile.writeAsBytes(File(_selectedFile!.path!).readAsBytesSync());

      await ApiService.uploadPdf(
        pdfFile: tempFile,
        filename: title,
      );

      // Clean up temp file
      if (await tempFile.exists()) {
        await tempFile.delete();
      }

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).uploadSuccess)),
      );

      Navigator.pop(context, true);
      
    } catch (e) {
      // Close loading indicator if still showing
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${S.of(context).uploadError}: ${e.toString()}')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(S.of(context).uploadError)),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    Locale currentLocale = Localizations.localeOf(context);
    String languageCode = currentLocale.languageCode;

    return Scaffold(
      appBar: CustomAppBar(
        title: S.of(context).uploadMaterial,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickFile,
                child: Container(
                  height: screenHeight * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _selectedFile == null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.upload_file, size: screenWidth * 0.1),
                              SizedBox(height: screenHeight * 0.01),
                              Text(
                                S.of(context).tapToUpload,
                                style: TextStyle(fontSize: languageCode == 'en' ? screenWidth * 0.04 : screenWidth * 0.05),
                              ),
                            ],
                          ),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.picture_as_pdf, size: screenWidth * 0.1, color: Colors.red),
                              SizedBox(height: screenHeight * 0.01),
                              Text(
                                _selectedFile!.name,
                                style: TextStyle(fontSize: screenWidth * 0.04),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: screenHeight * 0.005),
                              Text(
                                '${(_selectedFile!.size / 1024).toStringAsFixed(2)} KB',
                                style: TextStyle(fontSize: screenWidth * 0.035, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              CustomTextField(
                controller: _titleController,
                labelText: S.of(context).uploadFileTitle,
                isRequired: true, 
              ),
              SizedBox(height: screenHeight * 0.02),
              CustomTextField(
                controller: _descriptionController,
                labelText: S.of(context).uploadFileDescription,
                isRequired: true,
                keyboardType: TextInputType.multiline,
              ),
              SizedBox(height: screenHeight * 0.02),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).uploadFileTagsTitle,
                    style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: languageCode == 'ar' ? FontWeight.bold : FontWeight.normal),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Wrap(
                    spacing: screenWidth * 0.02,
                    children: _tags
                        .map((tag) => Chip(
                              label: Text(tag),
                              onDeleted: () {
                                setState(() {
                                  _tags.remove(tag);
                                });
                              },
                            ))
                        .toList(),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  CustomTextField(
                    controller: _tagsController,
                    labelText: S.of(context).uploadFileTag,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.add, color: Colors.orange, size: screenWidth * 0.06),
                      onPressed: () {
                        if (_tagsController.text.isNotEmpty) {
                          setState(() {
                            _tags.add(_tagsController.text);
                            _tagsController.clear();
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.06),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.02,
                    horizontal: screenWidth * 0.04,
                  ),
                ),
                child: Text(
                  S.of(context).uploadMaterialButton,
                  style: TextStyle(fontSize: languageCode == 'en' ? screenWidth * 0.04 : screenWidth * 0.05, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}