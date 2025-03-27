import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';
import '../providers/terms_provider.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({Key? key}) : super(key: key);

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TermsProvider>().loadTerms();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('약관 동의'),
      ),
      body: Consumer<TermsProvider>(
        builder: (context, termsProvider, child) {
          if (termsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (termsProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    termsProvider.error!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => termsProvider.loadTerms(),
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: termsProvider.terms.length,
            itemBuilder: (context, index) {
              final term = termsProvider.terms[index];
              return Card(
                child: ExpansionTile(
                  title: Row(
                    children: [
                      Checkbox(
                        value: termsProvider.agreements[term.id] ?? false,
                        onChanged: (value) => termsProvider.toggleAgreement(term.id),
                      ),
                      Expanded(
                        child: Text('약관 ${index + 1}'),
                      ),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: FutureBuilder<String>(
                        future: termsProvider.getTermsContent(term.resourceUrl),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Text(
                              '약관 내용을 불러오는데 실패했습니다: ${snapshot.error}',
                              style: TextStyle(color: Theme.of(context).colorScheme.error),
                            );
                          }
                          return Html(data: snapshot.data ?? '');
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Consumer<TermsProvider>(
          builder: (context, termsProvider, child) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Checkbox(
                    value: termsProvider.isAllAgreed,
                    onChanged: (value) => termsProvider.toggleAllAgreements(value ?? false),
                  ),
                  const Text('전체 동의'),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: termsProvider.isAllAgreed
                        ? () => Navigator.pop(context, true)
                        : null,
                    child: const Text('다음'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
} 