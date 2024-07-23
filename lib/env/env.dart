import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
    @EnviedField(varName: 'SUPERBASEURL')
    static const String superbaseUrl = _Env.superbaseUrl;
    @EnviedField(varName: 'SUPABASEANONKEY')
    static const String superbaseAnonKey = _Env.superbaseAnonKey;
    @EnviedField(varName: 'GEMINIKEY')
    static const String geminiKey = _Env.geminiKey;
}