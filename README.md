# Rick and Morty Characters App

Aplicativo Flutter que exibe personagens da série Rick and Morty, implementado com Clean Architecture e integração nativa via MethodChannel para obter o nível da bateria do dispositivo.

##  Funcionalidades

- Lista de personagens com paginação infinita
- Detalhes do personagem (nome, status, espécie, localização)
- Navegação com Bottom Navigation Bar
- Exibição do nível da bateria do dispositivo (via MethodChannel)
- Cache de imagens para melhor performance
- Pull-to-refresh na lista de personagens

## Demonstração

[![Demo Android](demo-android.mov)](demo-android.mov)

<video width="100%" controls>
  <source src="demo-android.mov" type="video/quicktime">
  Seu navegador não suporta a reprodução de vídeo. 
  [Clique aqui para baixar o vídeo](demo-android.mov)
</video>


[![Demo iOS](demo-ios.mov)](demo-ios.mov)

<video width="100%" controls>
  <source src="demo-ios.mov" type="video/quicktime">
  Seu navegador não suporta a reprodução de vídeo. 
  [Clique aqui para baixar o vídeo](demo-ios.mov)
</video>

## Arquitetura

O projeto utiliza **Clean Architecture** com separação clara de responsabilidades em três camadas principais:

### 1. Domain (Camada de Domínio)
Camada mais interna, contém as regras de negócio e é independente de frameworks.

- **Entities**: Entidades de domínio puras (sem dependências externas)
  - `CharacterEntity`
  - `LocationEntity`
  - `CharacterResponseEntity`

- **Repositories (Interfaces)**: Contratos que definem como os dados serão obtidos
  - `ICharacterRepository`

- **Use Cases**: Lógica de negócio específica
  - `GetCharacterUsecase`: Busca personagens com paginação

### 2. Data (Camada de Dados)
Responsável por obter dados de fontes externas (API, banco de dados, etc.)

- **DataSources**: Implementação concreta para buscar dados
  - `CharacterDataSourceImpl`: Faz requisições HTTP para a API do Rick and Morty

- **Models**: Modelos de dados que implementam as entidades do domínio
  - `CharacterModel`
  - `CharacterResponseModel`
  - `LocationModel`

- **Repository Implementation**: Implementação concreta dos repositórios
  - `CharacterRepositoryImpl`: Conecta o domínio com a camada de dados

### 3. Presentation (Camada de Apresentação)
Interface do usuário e gerenciamento de estado.

- **BLoC/Cubit**: Gerenciamento de estado reativo
  - `CharacterCubit`: Gerencia o estado da lista de personagens
  - `CharacterState`: Estados possíveis (loading, success, error)

- **Screens**: Telas da aplicação
  - `MainScreen`: Tela principal com Bottom Navigation Bar
  - `CharacterListScreen`: Lista de personagens
  - `CharacterDetailScreen`: Detalhes do personagem
  - `BlankScreen`: Tela que exibe o nível da bateria

- **Widgets**: Componentes reutilizáveis
  - `CharacterCard`: Card do personagem na lista
  - `CharacterListItem`: Item da lista com tratamento de loading

## 📂 Estrutura de Pastas

```
lib/
├── app/
│   └── features/
│       └── home/
│           ├── data/              # Camada de Dados
│           │   ├── datasources/   # Fontes de dados (API)
│           │   ├── models/        # Modelos de dados
│           │   └── repositories/  # Implementação dos repositórios
│           ├── domain/            # Camada de Domínio
│           │   ├── entities/     # Entidades de negócio
│           │   ├── repositories/  # Interfaces dos repositórios
│           │   └── usecases/     # Casos de uso
│           └── presentation/      # Camada de Apresentação
│               ├── blocs/         # Gerenciamento de estado
│               ├── screens/       # Telas
│               └── widgets/       # Componentes UI
├── core/                          # Código compartilhado
│   ├── di/                       # Injeção de dependências
│   ├── errors/                   # Tratamento de erros
│   ├── network/                  # Verificação de conexão
│   └── usecase/                  # Classe base de UseCase
└── main.dart                     # Ponto de entrada
```


##  MethodChannel - Integração Nativa

O projeto implementa comunicação entre Flutter e código nativo usando **MethodChannel** para obter o nível da bateria do dispositivo.

### Como Funciona

O MethodChannel permite comunicação bidirecional entre o código Dart (Flutter) e o código nativo (Kotlin/Swift).

#### 1. Lado Flutter (Dart)

```dart
// lib/app/features/home/presentation/screens/blank_screen.dart
static const platform = MethodChannel('com.example.fteamapp/battery');

Future<void> _getBatteryLevel() async {
  try {
    final int result = await platform.invokeMethod('getBatteryLevel');
    setState(() {
      _batteryLevel = result;
    });
  } on PlatformException catch (e) {
    // Tratamento de erro
  }
}
```

**Componentes:**
- `MethodChannel`: Canal de comunicação identificado por um nome único
- `invokeMethod`: Invoca um método no código nativo e aguarda o resultado
- `PlatformException`: Exceção lançada quando há erro na comunicação

#### 2. Lado Android (Kotlin)

```kotlin
// android/app/src/main/kotlin/com/example/fteamapp/MainActivity.kt
class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.fteamapp/battery"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "getBatteryLevel") {
                    val batteryLevel = getBatteryLevel()
                    if (batteryLevel != -1) {
                        result.success(batteryLevel)
                    } else {
                        result.error("UNAVAILABLE", "Nível da bateria não disponível.", null)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun getBatteryLevel(): Int {
        val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        var level = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        
        // Fallback para método alternativo se necessário
        if (level < 0 || level > 100) {
            val intent = registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            level = intent?.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) ?: -1
            val scale = intent?.getIntExtra(BatteryManager.EXTRA_SCALE, -1) ?: -1
            if (level >= 0 && scale > 0) {
                level = (level * 100 / scale)
            }
        }
        
        return if (level in 0..100) level else -1
    }
}
```

**Componentes:**
- `setMethodCallHandler`: Define o handler que processa chamadas do Flutter
- `call.method`: Nome do método chamado
- `result.success()`: Retorna sucesso com valor
- `result.error()`: Retorna erro com código e mensagem
- `BatteryManager`: API do Android para obter informações da bateria

#### 3. Lado iOS (Swift)

```swift
// ios/Runner/AppDelegate.swift
@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    guard let controller = window?.rootViewController as? FlutterViewController else {
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    let batteryChannel = FlutterMethodChannel(
      name: "com.example.fteamapp/battery",
      binaryMessenger: controller.binaryMessenger
    )
    
    batteryChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      guard call.method == "getBatteryLevel" else {
        result(FlutterMethodNotImplemented)
        return
      }
      self.receiveBatteryLevel(result: result)
    })
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func receiveBatteryLevel(result: @escaping FlutterResult) {
    let device = UIDevice.current
    device.isBatteryMonitoringEnabled = true
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      let batteryLevel = device.batteryLevel
      let batteryState = device.batteryState
      
      if batteryLevel < 0.0 || batteryLevel > 1.0 || batteryState == UIDevice.BatteryState.unknown {
        result(FlutterError(
          code: "UNAVAILABLE",
          message: "Nível da bateria não disponível. Teste em um dispositivo físico.",
          details: nil
        ))
      } else {
        result(Int(batteryLevel * 100))
      }
    }
  }
}
```

**Componentes:**
- `FlutterMethodChannel`: Canal de comunicação no iOS
- `setMethodCallHandler`: Define o handler para processar chamadas
- `@escaping FlutterResult`: Closure que pode ser executado após a função retornar
- `UIDevice`: API do iOS para obter informações do dispositivo
- `batteryLevel`: Retorna valor entre 0.0 e 1.0 (convertido para 0-100%)

### Fluxo de Comunicação

```
┌─────────────┐
│   Flutter   │
│   (Dart)    │
└──────┬──────┘
       │ invokeMethod('getBatteryLevel')
       ▼
┌─────────────────────────────────┐
│      MethodChannel               │
│  'com.example.fteamapp/battery'  │
└──────┬───────────────────────────┘
       │
       ├──────────────┬─────
       ▼              ▼              
┌─────────────┐  ┌──────────┐  
│   Android   │  │   iOS    │  
│  (Kotlin)   │  │ (Swift)  │  
└──────┬──────┘  └────┬─────┘  
       │              │
       │ getBatteryLevel()
       │              │
       ▼              ▼
┌─────────────┐  ┌─────────────┐
│ BatteryManager│ │  UIDevice   │
│   API        │  │    API      │
└──────┬───────┘  └──────┬──────┘
       │                 │
       │ result.success()│
       │                 │
       ▼                 ▼
┌─────────────────────────────┐
│   Retorna valor (0-100)      │
└─────────────────────────────┘
```


### Observações Importantes

- **iOS Simulator**: O nível da bateria não está disponível no simulador. É necessário testar em dispositivo físico.
- **Android Emulator**: Funciona normalmente, pode ser configurado nas configurações do emulador.


## Dependências

### Gerenciamento de Estado
- **flutter_bloc**: Gerenciamento de estado reativo com BLoC pattern

### Injeção de Dependências
- **get_it**: Service locator para injeção de dependências

### Networking
- **http**: Cliente HTTP para requisições à API
- **internet_connection_checker**: Verificação de conectividade

### Programação Funcional
- **dartz**: Programação funcional com `Either` para tratamento de erros
- **equatable**: Comparação de objetos

### UI
- **cached_network_image**: Cache de imagens de rede para melhor performance

## Como Executar

### Pré-requisitos

- Flutter 3.35.4 • channel stable 
- Dart 3.9.2
- Android Studio / Xcode
- Android SDK (para Android)
- CocoaPods (para iOS)
-
 
## Fluxo de Dados

```
UI (CharacterListScreen)
    ↓
CharacterCubit (BLoC)
    ↓
GetCharacterUsecase
    ↓
ICharacterRepository (interface)
    ↓
CharacterRepositoryImpl (implementação)
    ↓
CharacterDataSourceImpl
    ↓
API (Rick and Morty API)
```

## API Utilizada

- **Rick and Morty API**: https://rickandmortyapi.com/
- Endpoint: `/character?page={pageNumber}`
- Documentação: https://rickandmortyapi.com/documentation

 
