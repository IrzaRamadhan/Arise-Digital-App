import 'package:arise/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../bloc/matriks_risiko/matriks_risiko_bloc.dart';
import '../../../../../data/models/matriks_risiko_model.dart';
import '../../../../../widgets/states/error_state_widget.dart';

class MatriksRisikoPage extends StatelessWidget {
  const MatriksRisikoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Matriks Risiko')),
      body: SafeArea(
        child: BlocBuilder<MatriksRisikoBloc, MatriksRisikoState>(
          builder: (context, state) {
            if (state is MatriksRisikoLoaded) {
              // Buat map untuk lookup data berdasarkan levelKemungkinanId dan levelDampakId
              final Map<String, MatriksRisikoModel> matriksMap = {};
              for (var item in state.data) {
                final key = '${item.levelKemungkinanId}-${item.levelDampakId}';
                matriksMap[key] = item;
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 120,
                                    width: 120,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          color: Colors.grey.shade200,
                                          width: 1,
                                        ),
                                        left: BorderSide(
                                          color: Colors.grey.shade200,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Level\nKemungkinan',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Icon(
                                          Icons.arrow_downward,
                                          color: Colors.blue.shade400,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        width: 76 * 5,
                                        height: 60,
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            left: BorderSide(
                                              color: Colors.grey.shade200,
                                              width: 1,
                                            ),
                                            right: BorderSide(
                                              color: Colors.grey.shade200,
                                              width: 1,
                                            ),
                                            top: BorderSide(
                                              color: Colors.grey.shade200,
                                              width: 1,
                                            ),
                                            bottom: BorderSide(
                                              color: Colors.grey.shade200,
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Level Dampak',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.red.shade700,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Icon(
                                              Icons.arrow_forward,
                                              color: Colors.red.shade700,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Row(
                                            children: List.generate(5, (index) {
                                              return Container(
                                                height: 60,
                                                width: 76,
                                                padding: const EdgeInsets.all(
                                                  16,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    left: BorderSide(
                                                      color:
                                                          Colors.grey.shade200,
                                                      width: 1,
                                                    ),
                                                    right:
                                                        index == 4
                                                            ? BorderSide(
                                                              color:
                                                                  Colors
                                                                      .grey
                                                                      .shade200,
                                                              width: 1,
                                                            )
                                                            : BorderSide.none,
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    '${index + 1}',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Column(
                                    children: List.generate(5, (index) {
                                      return Container(
                                        height: 96,
                                        width: 120,
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                              color: Colors.grey.shade200,
                                              width: 1,
                                            ),
                                            left: BorderSide(
                                              color: Colors.grey.shade200,
                                              width: 1,
                                            ),
                                            bottom:
                                                index == 4
                                                    ? BorderSide(
                                                      color:
                                                          Colors.grey.shade200,
                                                      width: 1,
                                                    )
                                                    : BorderSide.none,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${index + 1}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                  Table(
                                    defaultColumnWidth: const FixedColumnWidth(
                                      76,
                                    ),
                                    border: TableBorder.all(
                                      color: Colors.grey.shade200,
                                      width: 1,
                                    ),
                                    children: List.generate(5, (rowIndex) {
                                      // Level kemungkinan dari 1 ke 5 (top to bottom)
                                      final levelKemungkinan = rowIndex + 1;

                                      return _buildMatrixRow(
                                        matriksMap,
                                        levelKemungkinan,
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Keterangan Kategori Risiko:',
                            style: interBodyMediumSemibold,
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: _buildLegendItems(state.data),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is MatriksRisikoFailed) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ErrorStateWidget(
                    onTap: () {
                      context.read<MatriksRisikoBloc>().add(
                        FetchMatriksRisiko(),
                      );
                    },
                    errorType: state.message,
                  ),
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  TableRow _buildMatrixRow(
    Map<String, MatriksRisikoModel> matriksMap,
    int levelKemungkinan,
  ) {
    return TableRow(
      children: List.generate(5, (colIndex) {
        final levelDampak = colIndex + 1;
        final key = '$levelKemungkinan-$levelDampak';
        final data = matriksMap[key];

        return _buildRiskCell(data);
      }),
    );
  }

  Widget _buildRiskCell(MatriksRisikoModel? data) {
    if (data == null) {
      return Container(
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(minHeight: 96),
        color: Colors.grey.shade100,
        child: Center(
          child: Text('-', style: TextStyle(color: Colors.grey.shade400)),
        ),
      );
    }

    final riskLevel = _getRiskLevelFromClass(data.riskClass);
    Color bgColor;

    switch (riskLevel) {
      case RiskLevel.veryLow:
        bgColor = const Color(0xFF93C5FD);
        break;
      case RiskLevel.low:
        bgColor = const Color(0xFF86EFAC);
      case RiskLevel.medium:
        bgColor = const Color(0xFFFDE047);
        break;
      case RiskLevel.high:
        bgColor = const Color(0xFFFDBA74);
        break;
      case RiskLevel.veryHigh:
        bgColor = const Color(0xFFF87171);
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(minHeight: 96),
      color: bgColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white),
            ),
            child: Center(child: Text(data.besaran, style: interSmallMedium)),
          ),
          const SizedBox(height: 8),
          Text(
            data.klasifikasi,
            textAlign: TextAlign.center,
            style: interSmallMedium,
          ),
        ],
      ),
    );
  }

  RiskLevel _getRiskLevelFromClass(String riskClass) {
    switch (riskClass.toLowerCase()) {
      case 'risk-very-low':
        return RiskLevel.veryLow;
      case 'risk-low':
        return RiskLevel.low;
      case 'risk-medium':
        return RiskLevel.medium;
      case 'risk-high':
        return RiskLevel.high;
      case 'risk-very-high':
        return RiskLevel.veryHigh;
      default:
        return RiskLevel.medium;
    }
  }

  List<Widget> _buildLegendItems(List<MatriksRisikoModel> matriksRisiko) {
    final Map<String, MatriksRisikoModel> uniqueClassifications = {};

    for (var item in matriksRisiko) {
      if (!uniqueClassifications.containsKey(item.klasifikasi)) {
        uniqueClassifications[item.klasifikasi] = item;
      }
    }

    final sortedItems =
        uniqueClassifications.values.toList()..sort((a, b) {
          final aVal = int.tryParse(a.besaran) ?? 0;
          final bVal = int.tryParse(b.besaran) ?? 0;
          return aVal.compareTo(bVal);
        });

    final Map<String, List<int>> rangeMap = {};
    for (var item in matriksRisiko) {
      final besaranInt = int.tryParse(item.besaran) ?? 0;
      if (!rangeMap.containsKey(item.klasifikasi)) {
        rangeMap[item.klasifikasi] = [];
      }
      rangeMap[item.klasifikasi]!.add(besaranInt);
    }

    return sortedItems.map((item) {
      final riskLevel = _getRiskLevelFromClass(item.riskClass);
      Color bgColor;
      switch (riskLevel) {
        case RiskLevel.veryLow:
          bgColor = const Color(0xFF93C5FD);
          break;
        case RiskLevel.low:
          bgColor = const Color(0xFF86EFAC);
        case RiskLevel.medium:
          bgColor = const Color(0xFFFDE047);
          break;
        case RiskLevel.high:
          bgColor = const Color(0xFFFDBA74);
          break;
        case RiskLevel.veryHigh:
          bgColor = const Color(0xFFF87171);
          break;
      }

      // Get range for this classification
      final range = rangeMap[item.klasifikasi] ?? [];
      range.sort();
      final rangeText =
          range.isNotEmpty ? '${range.first}-${range.last}' : item.besaran;

      return _buildLegendItem('${item.klasifikasi}: $rangeText', bgColor);
    }).toList();
  }

  Widget _buildLegendItem(String text, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: interSmallMedium),
    );
  }
}

enum RiskLevel { veryLow, low, medium, high, veryHigh }
