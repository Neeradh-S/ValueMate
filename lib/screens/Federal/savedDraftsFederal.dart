import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:login_screen/screens/Federal/federal.dart';
import 'dart:convert';
import 'config.dart';

class SavedDraftsFederal extends StatefulWidget {
  const SavedDraftsFederal({super.key});

  @override
  State<SavedDraftsFederal> createState() => _SavedDraftsFederalState();
}

class _SavedDraftsFederalState extends State<SavedDraftsFederal> {
  DateTime date = DateTime.now();
  List<dynamic> searchResults = [];
  bool isLoading = false;

  Future<void> searchByDate() async {
    setState(() {
      isLoading = true;
      searchResults = [];
    });

    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final response = await http.post(
        Uri.parse(url3),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'date': formattedDate}),
      );

      debugPrint("send req to back");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          searchResults = data;
        });
      } else {
        debugPrint("some err");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void navigateToValuationForm(Map<String, dynamic> propertyData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfGeneratorScreen(
          propertyData: propertyData,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Federal Bank Drafts',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB0D9F8),
              Color(0xFF90C1F7),
              Color(0xFFA1A4F8),
              Color(0xFFC49CF7),
              Color(0xFFE4A2F5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Gradient date picker container
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFEBF6FF), Color(0xFFDDEBFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.black54),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Date: ${DateFormat('dd-MM-yyyy').format(date)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_calendar,
                            color: Colors.black54),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: date,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2200),
                          );
                          if (picked != null) {
                            setState(() {
                              date = picked;
                            });
                          }
                        },
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Search Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: isLoading ? null : searchByDate,
                    icon: const Icon(Icons.search),
                    label: const Text('Search'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.deepPurpleAccent.shade100,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Search Results
                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : searchResults.isEmpty
                          ? const Center(
                              child: Text(
                                'No Federal Bank drafts found',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                  color: Colors.black87,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: searchResults.length,
                              itemBuilder: (context, index) {
                                final property = searchResults[index];

                                final gradients = [
                                  [const Color(0xFFDAF1F5), const Color(0xFFC7E8F3)],
                                  [const Color(0xFFF6E9F8), const Color(0xFFEBD8F5)],
                                  [const Color(0xFFFFF2D8), const Color(0xFFFFE8B8)],
                                  [const Color(0xFFDFF6DD), const Color(0xFFBDE7BE)],
                                ];
                                final gradientColors =
                                    gradients[index % gradients.length];

                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(
                                      colors: gradientColors,
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(16),
                                    title: Text(
                                      'Owner: ${property['ownerOfTheProperty']}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding:
                                          const EdgeInsets.only(top: 6.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Bank: Federal Bank',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Location: ${property['propertyAddressAsPerSiteVisit']}',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Inspection Date: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(property['createdAt']).toLocal())}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    trailing: const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 18,
                                      color: Colors.black54,
                                    ),
                                    onTap: () =>
                                        navigateToValuationForm(property),
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
