import 'package:dermai/features/core/cubits/app_user/app_user_cubit.dart';
import 'package:dermai/features/core/entities/diagnosed_disease.dart';
import 'package:dermai/features/core/entities/doctor.dart';
import 'package:dermai/features/doctor/domain/usecases/doctor_get_cases.dart';
import 'package:dermai/features/doctor/presentation/bloc/doctor_bloc.dart';
import 'package:dermai/features/doctor/presentation/components/case_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CasesPage extends StatefulWidget {
  const CasesPage({super.key});

  @override
  State<CasesPage> createState() => _CasesPageState();
}

class _CasesPageState extends State<CasesPage>
    with SingleTickerProviderStateMixin {
  List<DiagnosedDisease> _cases = [];
  var selectedCaseType = CasesType.values[0];
  @override
  void initState() {
    super.initState();
    _fetchDiagnosedDiseases();
  }

  Future<void> _fetchDiagnosedDiseases() async {
    Doctor doctor = (context.read<AppUserCubit>().state as AppUserAuthenticated)
        .user
        .doctor();
    context.read<DoctorBloc>().add(DoctorDiagnosedDisease(
        doctorID: doctor.id, casesType: selectedCaseType));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<DoctorBloc, DoctorState>(
        listener: (context, state) {
          if (state is DoctorFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
          if (state is DoctorSuccessListOfDiagnosedDisease) {
            setState(() {
              _cases = state.diagnosedDiseases;
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                    floating: true,
                    snap: true,
                    automaticallyImplyLeading: false,
                    titleSpacing: 0,
                    title: SizedBox(
                      height: 48,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: CasesType.values.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                SizedBox(
                                  width: index == 0 ? 16 : 4,
                                ),
                                ChoiceChip(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  label: Text(CasesType.values[index].caseName),
                                  selected: selectedCaseType ==
                                      CasesType.values[index],
                                  onSelected: (_) {
                                    setState(() {
                                      selectedCaseType =
                                          CasesType.values[index];
                                    });
                                    _fetchDiagnosedDiseases();
                                  },
                                ),
                                SizedBox(
                                  width: index == 3 ? 16 : 4,
                                ),
                              ],
                            );
                          }),
                    )),
              ],
              body: state is DoctorLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: _fetchDiagnosedDiseases,
                      child: _cases.isEmpty ? const Center(
                              child: Text('No cases'),
                            ) : ListView.builder(
                        itemCount: _cases.length,
                        padding: const EdgeInsets.all(16),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              CaseCard(
                                  diagnosedDisease: _cases[index]),
                              if (index >= _cases.length)
                                const SizedBox(
                                  height: 16,
                                )
                            ],
                          );
                        },
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}