import 'package:course_dilaundry/config/app_assets.dart';
import 'package:course_dilaundry/config/app_colors.dart';
import 'package:course_dilaundry/config/app_constants.dart';
import 'package:course_dilaundry/config/app_response.dart';
import 'package:course_dilaundry/config/failure.dart';
import 'package:course_dilaundry/datasources/user_datasource.dart';
import 'package:course_dilaundry/providers/register_provider.dart';
import 'package:d_info/d_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final edtUsername = TextEditingController();
  final edtEmail = TextEditingController();
  final edtPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool hidePass = true;

  execute() {
    bool validInput = formKey.currentState!.validate();
    if (!validInput) return;

    setRegisterStatus(ref, 'Loading');

    UserDatasource.register(edtUsername.text, edtEmail.text, edtPassword.text)
        .then(
      (value) {
        String newStatus = '';
        value.fold((failure) {
          switch (failure.runtimeType) {
            case ServerFailure:
              newStatus = 'Server Error';
              DInfo.toastError(newStatus);
              break;
            case NotFoundFailure:
              newStatus = 'Error Not Found';
              DInfo.toastError(newStatus);
              break;
            case ForbiddenFailure:
              newStatus = 'You don\' have access';
              DInfo.toastError(newStatus);
              break;
            case BadRequestFailure:
              newStatus = 'Bad request';
              DInfo.toastError(newStatus);
              break;
            case InvalidInputFailure:
              newStatus = 'Invalid Input';
              AppResponse.invalidInput(context, failure.message ?? '{}');
              break;
            case UnauthorizedFailure:
              newStatus = 'Unauthorized';
              DInfo.toastError(newStatus);
              break;
            default:
              newStatus = 'Request Error';
              DInfo.toastError(newStatus);
              newStatus = failure.message ?? '-';
              break;
          }
          setRegisterStatus(ref, newStatus);
        }, (r) {
          const SnackBar(
            content: Text('Success'),
          );
          setRegisterStatus(ref, 'Success');
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppAssets.bgAuth,
            fit: BoxFit.cover,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.transparent,
                Colors.black54,
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 60, 30, 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      Text(
                        AppConstants.appName,
                        style: GoogleFonts.poppins(
                            fontSize: 40,
                            color: Colors.green[900],
                            fontWeight: FontWeight.w500),
                      ),
                      Container(
                        height: 5,
                        width: 40,
                        decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    ],
                  ),
                ),
                Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.white70,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: TextField(
                            controller: edtUsername,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: AppColors.primary,
                                ),
                                hintText: 'Username',
                                contentPadding: EdgeInsets.only(top: 12)),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.white70,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: TextField(
                            controller: edtEmail,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: AppColors.primary,
                                ),
                                hintText: 'Email',
                                contentPadding: EdgeInsets.only(top: 12)),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.white70,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: TextField(
                            controller: edtPassword,
                            obscureText: hidePass,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: const Icon(
                                  Icons.key,
                                  color: AppColors.primary,
                                ),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        hidePass = !hidePass;
                                      });
                                    },
                                    icon: Icon(
                                      hidePass
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey,
                                    )),
                                hintText: 'Password',
                                contentPadding: const EdgeInsets.only(top: 12)),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.white70,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'LOG',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Consumer(builder: (_, wiRef, __) {
                                  String status =
                                      wiRef.watch(registerStatusProvider);
                                  if (status == 'Loading') {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  return ElevatedButton(
                                    onPressed: () => execute(),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      'Register',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
