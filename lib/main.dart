// ------------------------------------------------------------
// o uso de comentários ao longo do código é uma prática que
// aprendi, que facilita o acompanhamento e divisão do que cada
// parte do código está fazendo
// ------------------------------------------------------------

// ============================================================
// 1. INÍCIO E PREPARAÇÃO DO APLICATIVO
// ============================================================

import 'package:flutter/material.dart';

// importo o pacote que uso para tocar os áudios das frases
import 'package:audioplayers/audioplayers.dart';

// importo o pacote que uso para criar e acessar o banco de dados sqlite
import 'package:sqflite/sqflite.dart';

// importo a biblioteca que uso para sortear as frases e os ícones
import 'dart:math';

// ------------------------------------------------------------
// inicio o meu aplicativo por esta função principal
Future<void> main() async {
  // garanto que o flutter esteja pronto antes de acessar o banco
  WidgetsFlutterBinding.ensureInitialized();

  // busco o nome do usuário que já foi cadastrado, se existir
  final nome = await BancoDados.buscarNomeUsuario();

  // gravo as categorias, subcategorias e frases se ainda não existirem
  await BancoDados.garantirItens();

  // inicio o aplicativo informando se já existe um cadastro
  runApp(QueroDizerApp(nomeUsuario: nome));
}

// ------------------------------------------------------------
// crio aqui a estrutura principal do meu aplicativo
class QueroDizerApp extends StatelessWidget {
  // guardo o nome do usuário cadastrado, que fica vazio no primeiro uso
  final String? nomeUsuario;

  // uso este construtor para criar o aplicativo
  const QueroDizerApp({super.key, this.nomeUsuario});

  // construo aqui a estrutura inicial do meu aplicativo
  @override
  Widget build(BuildContext context) {
    // pego o nome do usuário cadastrado
    final nome = nomeUsuario;

    // uso o MaterialApp para fornecer a estrutura básica
    // que preciso para construir as telas do meu aplicativo
    return MaterialApp(
      // retiro a faixa de debug que aparece durante os testes
      debugShowCheckedModeBanner: false,

      // defino aqui o nome do meu aplicativo
      title: 'Quero Dizer',

      // abro a tela principal se já existe cadastro
      // e a tela inicial se for o primeiro uso
      home: nome == null
          ? const TelaInicial()
          : TelaPrincipal(nomeUsuario: nome),
    );
  }
}

// ============================================================
// 2. CADASTRO INICIAL (FEITO PELO CUIDADOR)
// ============================================================

// ------------------------------------------------------------
// crio aqui a primeira tela do meu aplicativo
class TelaInicial extends StatelessWidget {
  // uso este construtor para criar a tela inicial
  const TelaInicial({super.key});

  // construo aqui todos os elementos da minha tela inicial
  @override
  Widget build(BuildContext context) {
    // uso o Scaffold para criar a estrutura básica da minha tela
    return Scaffold(
      // defino o fundo da minha tela como branco
      backgroundColor: Colors.white,

      // uso o SafeArea para evitar que meus elementos
      // fiquem escondidos pelas áreas do sistema
      body: SafeArea(
        // organizo os elementos da minha tela verticalmente
        child: Column(
          // distribuo os elementos aproveitando o espaço vertical
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            // uso o Expanded para ocupar o espaço principal da tela
            Expanded(
              // centralizo o conteúdo principal da minha tela
              child: Center(
                // organizo o logo e o nome do aplicativo verticalmente
                child: Column(
                  // centralizo o conjunto no espaço disponível
                  mainAxisAlignment: MainAxisAlignment.center,

                  // centralizo os elementos horizontalmente
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    // apresento aqui o logo do meu aplicativo
                    Image.asset(
                      // informo o caminho onde meu logo está armazenado
                      'assets/images/logo.jpg',

                      // defino a largura do meu logo
                      width: 280,

                      // mantenho a proporção original da imagem
                      fit: BoxFit.contain,
                    ),

                    // crio um espaço entre o logo e o nome
                    const SizedBox(height: 15),

                    // apresento o nome do meu aplicativo
                    const Text(
                      'QUERO DIZER',

                      // defino as características visuais
                      // do nome do meu aplicativo
                      style: TextStyle(
                        // defino o tamanho das letras
                        fontSize: 34,

                        // deixo o nome mais destacado
                        fontWeight: FontWeight.bold,

                        // utilizo o verde definido no meu protótipo
                        color: Color(0xFF5F9B72),

                        // aumento um pouco o espaço entre as letras
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // crio aqui a área onde ficará o botão continuar
            Padding(
              // adiciono espaço nas laterais e na parte inferior
              padding: const EdgeInsets.only(
                left: 30,
                right: 30,
                bottom: 30,
              ),

              // defino o tamanho que quero para o meu botão
              child: SizedBox(
                // defino a largura do meu botão
                width: 180,

                // defino a altura do meu botão
                height: 50,

                // crio o botão que levará o usuário para a próxima tela
                child: ElevatedButton(
                  // defino o que acontece quando o botão for pressionado
                  onPressed: () {
                    // uso o Navigator para abrir a segunda tela
                    Navigator.push(
                      context,

                      // crio uma nova rota para a tela de configuração do nome
                      MaterialPageRoute(
                        builder: (context) =>
                        const TelaConfiguracaoNome(),
                      ),
                    );
                  },

                  // defino a aparência do meu botão
                  style: ElevatedButton.styleFrom(
                    // defino a cor azul do meu botão
                    backgroundColor: Colors.blue,

                    // defino a cor branca para o texto do botão
                    foregroundColor: Colors.white,

                    // arredondo os cantos do meu botão
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),

                  // apresento o texto do meu botão
                  child: const Text(
                    'CONTINUAR',

                    // defino o tamanho do texto
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// crio aqui a tela responsável pelo cadastro do nome
class TelaConfiguracaoNome extends StatefulWidget {
  // uso este construtor para criar a segunda tela
  const TelaConfiguracaoNome({super.key});

  // crio o estado que vou utilizar para controlar
  // as informações que podem mudar nesta tela
  @override
  State<TelaConfiguracaoNome> createState() =>
      _TelaConfiguracaoNomeState();
}

// crio aqui o estado da minha tela de configuração do nome
class _TelaConfiguracaoNomeState extends State<TelaConfiguracaoNome> {
  // crio este controlador para conseguir acessar
  // o nome que for digitado pelo usuário
  final TextEditingController nomeController = TextEditingController();

  // libero o controlador quando saio desta tela
  @override
  void dispose() {
    nomeController.dispose();
    super.dispose();
  }

  // construo aqui todos os elementos da segunda tela
  @override
  Widget build(BuildContext context) {
    // uso o Scaffold para criar a estrutura básica da tela
    return Scaffold(
      // defino o fundo da minha tela como branco
      backgroundColor: Colors.white,

      // uso o SafeArea para respeitar as áreas do sistema
      body: SafeArea(
        // organizo os elementos verticalmente
        child: Column(
          children: [
            // crio um espaço no início da tela
            const SizedBox(height: 25),

            // apresento o título da tela
            const Text(
              'Olá!',

              // defino as caractersticas visuais do título
              style: TextStyle(
                // aumento o tamanho da fonte
                fontSize: 36,

                // deixo o titulo destacado
                fontWeight: FontWeight.bold,

                // utilizo o mesmo verde do meu aplicatvo
                color: Color(0xFF5F9B72),
              ),
            ),

            // crio um pequeno espaço depois do título
            const SizedBox(height: 8),

            // apresento uma explicação simples para o cuidador
            const Text(
              'Para começarmos, precisamos\nsaber o nome do usuário',

              // centralizo o texto e defino seu tamanho
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),

            // crio um espaço antes do logo
            const SizedBox(height: 20),

            // apresento novamente o logo
            Image.asset(
              // informo o caminho onde meu loogo está armazenado
              'assets/images/logo.jpg',

              // utilizo um tamanho menor que o da tela inicial
              width: 130,

              // mantenho a proporção original da imagem
              fit: BoxFit.contain,
            ),

            // crio um espaço antes da pergunta
            const SizedBox(height: 20),

            // apresento a pergunta sobre o nome
            const Padding(
              // adiciono espaço nas laterais
              padding: EdgeInsets.symmetric(horizontal: 30),

              child: Align(
                // alinho a pergunta a esquerda
                alignment: Alignment.centerLeft,

                child: Text(
                  'Qual é o nome do usuário?',

                  // destaco a pergunta para facilitar a leitura
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5F9B72),
                  ),
                ),
              ),
            ),

            // crio um espaço entre a pergunta e o campo
            const SizedBox(height: 10),

            // crio o campo onde o nome SERE digitado
            Padding(
              // adiciono espaço nas laterais do campo
              padding: const EdgeInsets.symmetric(horizontal: 30),

              child: TextField(
                // conecto o campo ao controlador
                controller: nomeController,

                // configuro a aparência do meu campo
                decoration: InputDecoration(
                  // apresento uma dica dentro do campo
                  hintText: 'Digite o nome aqui',

                  // crio uma borda para o campo
                  border: OutlineInputBorder(
                    // arredondo levemente os cantos
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            // crio um espaço antes do aviso
            const SizedBox(height: 20),

            // crio o aviso sobre a utilização do nome
            Padding(
              // adiciono espaço nas laterais
              padding: const EdgeInsets.symmetric(horizontal: 30),

              child: Container(
                // adiciono um espaço interno ao aviso
                padding: const EdgeInsets.all(15),

                // defino uma cor clara para destacar o aviso
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF4EC),

                  // arredondo os cantos do aviso
                  borderRadius: BorderRadius.circular(8),
                ),

                child: const Row(
                  // alinho o ícone e o texto verticalmente
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    // apresento um ícone para identificar o aviso
                    Icon(
                      Icons.lock,
                      color: Color(0xFF5F9B72),
                      size: 30,
                    ),

                    // crio um espaço entre o ícone e o texto
                    SizedBox(width: 12),

                    // apresento a informação sobre o nome
                    Expanded(
                      child: Text(
                        'O nome será usado para personalizar sua experiência no aplicativo',

                        // defino o tamanho do texto do aviso
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // crio um espaço antes do botão
            const SizedBox(height: 20),

            // crio o botão para avançar
            SizedBox(
              // defino a largura do botão
              width: 175,

              // defino a altura do botão
              height: 50,

              child: ElevatedButton(
                // defino o que acontece quando o botão for pressionado
                onPressed: () {
                  // pego o texto que foi digitado no campo
                  final nome = nomeController.text.trim();

                  // verifico se o usuário deixou o campo vazio
                  if (nome.isEmpty) {
                    // aviso que preciso de um nome para continuar
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Digite um nome para continuar',
                        ),
                      ),
                    );

                    // paro aqui para impedir que o usuário continue
                    // sem informar um nome
                    return;
                  }

                  // abro a terceira tela depois de confirmar
                  // que existe um nome preenchido
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TelaCriarSenha(
                        nomeUsuario: nome,
                      ),
                    ),
                  );
                },

                // defino a aparência do meu botão
                style: ElevatedButton.styleFrom(
                  // utilizo a mesma cor azul da primeira tela
                  backgroundColor: Colors.blue,

                  // utilizo branco para o texto
                  foregroundColor: Colors.white,

                  // arredondo os cantos do botão
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),

                child: const Row(
                  // centralizo os elementos do botão
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    // apresento o texto do botão
                    Text(
                      'CONTINUAR',

                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),

                    // crio um pequeno espaço antes da seta
                    SizedBox(width: 10),

                    // apresento a seta indicando que existe uma próxima etapa
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ),

            // crio um espaço antes do indicador de progresso
            const SizedBox(height: 15),

            // apresento uma barra simples indicando o progresso
            Padding(
              // adiciono espaço nas laterais
              padding: const EdgeInsets.symmetric(horizontal: 30),

              child: const LinearProgressIndicator(
                // defino que estou na primeira de duas etapas
                value: 0.5,

                // utilizo azul para indicar o progresso realizado
                color: Colors.blue,

                // utilizo cinza para indicar a parte que falta
                backgroundColor: Colors.grey,
              ),
            ),

            // crio um espaço entre a barra e o texto
            const SizedBox(height: 8),

            // apresento a etapa atual da configuração
            const Text(
              '1 de 2',

              style: TextStyle(
                fontSize: 12,
                color: Colors.blue,
              ),
            ),

            // crio um pequeno espaço na parte inferior
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// crio aqui a terceira tela responsável pela criação da senha
class TelaCriarSenha extends StatefulWidget {
  // guardo o nome do usuário para utilizar depois
  final String nomeUsuario;

  // uso este construtor para criar a tela de senha
  const TelaCriarSenha({
    super.key,
    required this.nomeUsuario,
  });

  // crio o estado que vou utilizar para controlar
  // os campos de senha desta tela
  @override
  State<TelaCriarSenha> createState() => _TelaCriarSenhaState();
}

// crio aqui o estado da minha tela de criação da senha
class _TelaCriarSenhaState extends State<TelaCriarSenha> {
  // crio este controlador para acessar a senha digitada
  final TextEditingController senhaController = TextEditingController();

  // crio este controlador para acessar a confirmação da senha
  final TextEditingController confirmarSenhaController =
  TextEditingController();

  // libero os controladores quando saio desta tela
  @override
  void dispose() {
    senhaController.dispose();
    confirmarSenhaController.dispose();
    super.dispose();
  }

  // construo aqui todos os elementos da terceira tela
  @override
  Widget build(BuildContext context) {
    // uso o Scaffold para criar a estrutura básica da minha tela
    return Scaffold(
      // defino o fundo da minha tela como branco
      backgroundColor: Colors.white,

      // uso o SafeArea para respeitar as áreas do sistema
      body: SafeArea(
        // organizo os elementos verticalmente
        child: Column(
          children: [
            // crio um espaço no início da tela
            const SizedBox(height: 60),

            // apresento o título da tela
            const Text(
              'Criar senha',

              // defino as características visuais do título
              style: TextStyle(
                // defino o tamanho do título
                fontSize: 32,

                // deixo o título destacado
                fontWeight: FontWeight.bold,

                // utilizo o verde do meu aplicativo
                color: Color(0xFF5F9B72),
              ),
            ),

            // crio um espaço depois do título
            const SizedBox(height: 15),

            // apresento uma explicação simples
            const Padding(
              // adiciono espaço nas laterais
              padding: EdgeInsets.symmetric(horizontal: 40),

              child: Text(
                'Crie uma senha para acessar a Área do Cuidador',

                // centralizo o texto
                textAlign: TextAlign.center,

                // defino o tamanho do texto
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),

            // crio um espaço antes do primeiro campo
            const SizedBox(height: 35),

            // apresento o campo da senha
            Padding(
              // adiciono espaço nas laterais
              padding: const EdgeInsets.symmetric(horizontal: 30),

              child: TextField(
                // conecto o campo ao controlador da senha
                controller: senhaController,

                // faço o teclado apresentar números
                keyboardType: TextInputType.number,

                // escondo os números digitados
                obscureText: true,

                // defino o limite de seis caracteres
                maxLength: 6,

                // configuro a aparência do campo
                decoration: const InputDecoration(
                  // apresento o nome do campo
                  labelText: 'Senha',

                  // crio uma borda para o campo
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            // crio um espaço antes do segundo campo
            const SizedBox(height: 15),

            // apresento o campo para confirmar a senha
            Padding(
              // adiciono espaço nas laterais
              padding: const EdgeInsets.symmetric(horizontal: 30),

              child: TextField(
                // conecto o campo ao controlador da confirmação
                controller: confirmarSenhaController,

                // faço o teclado apresentar números
                keyboardType: TextInputType.number,

                // escondo os números digitados
                obscureText: true,

                // defino o limite de seis caracteres
                maxLength: 6,

                // configuro a aparência do campo
                decoration: const InputDecoration(
                  // apresento o nome do campo
                  labelText: 'Confirmar senha',

                  // crio uma borda para o campo
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            // crio um espaço antes do botão
            const SizedBox(height: 15),

            // crio o botão para concluir a configuração
            SizedBox(
              // defino a largura do botão
              width: 175,

              // defino a altura do botão
              height: 50,

              child: ElevatedButton(
                // defino o que acontece quando o botão for pressionado
                onPressed: () async {
                  // pego a senha digitada
                  final senha = senhaController.text;

                  // pego a confirmação da senha digitada
                  final confirmarSenha =
                      confirmarSenhaController.text;

                  // verifico se a senha foi preenchida
                  if (senha.isEmpty) {
                    // aviso que a senha precisa ser informada
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Digite uma senha',
                        ),
                      ),
                    );

                    // paro aqui enquanto a senha estiver vazia
                    return;
                  }

                  // verifico se a senha possui exatamente seis dígitos
                  if (senha.length != 6) {
                    // aviso que a senha precisa ter seis dígitos
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'A senha deve ter 6 dígitos',
                        ),
                      ),
                    );

                    // paro aqui enquanto a senha estiver incompleta
                    return;
                  }

                  // verifico se a confirmação foi preenchida
                  if (confirmarSenha.isEmpty) {
                    // aviso que preciso confirmar a senha
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Confirme a senha',
                        ),
                      ),
                    );

                    // paro aqui enquanto a confirmação estiver vazia
                    return;
                  }

                  // verifico se as duas senhas são iguais
                  if (senha != confirmarSenha) {
                    // aviso que as senhas não são iguais
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'As senhas não são iguais',
                        ),
                      ),
                    );

                    // paro aqui enquanto as senhas forem diferentes
                    return;
                  }

                  // salvo o nome e a senha no banco de dados
                  await BancoDados.salvarCadastro(
                    nome: widget.nomeUsuario,
                    senha: senha,
                  );

                  // confirmo que a tela ainda existe depois de salvar
                  if (!mounted) return;

                  // abro a tela principal depois de concluir
                  // a configuração inicial do aplicativo
                  // e removo as telas de configuração para não voltar a elas
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TelaPrincipal(
                        nomeUsuario: widget.nomeUsuario,
                      ),
                    ),
                        (route) => false,
                  );
                },

                // defino a aparência do botão
                style: ElevatedButton.styleFrom(
                  // utilizo a mesma cor azul das outras telas
                  backgroundColor: Colors.blue,

                  // utilizo branco para o texto
                  foregroundColor: Colors.white,

                  // arredondo os cantos do botão
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),

                child: const Row(
                  // centralizo os elementos do botão
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    // apresento o texto do botão
                    Text(
                      'CONCLUIR',

                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),

                    // crio um pequeno espaço antes da seta
                    SizedBox(width: 10),

                    // apresento a seta indicando a conclusão
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ),

            // crio um espaço antes do indicador de progresso
            const SizedBox(height: 25),

            // apresento uma barra indicando que estou
            // na segunda e última etapa da configuração
            Padding(
              // adiciono espaço nas laterais
              padding: const EdgeInsets.symmetric(horizontal: 30),

              child: const LinearProgressIndicator(
                // mostro a configuração como concluída
                value: 1.0,

                // utilizo azul para indicar o progresso
                color: Colors.blue,

                // mantenho o fundo da barra em cinza
                backgroundColor: Colors.grey,
              ),
            ),

            // crio um espaço entre a barra e o texto
            const SizedBox(height: 8),

            // apresento a segunda etapa da configuração
            const Text(
              '2 de 2',

              style: TextStyle(
                fontSize: 12,
                color: Colors.blue,
              ),
            ),

            // crio um pequeno espaço na parte inferior
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 3. COMUNICAÇÃO DO USUÁRIO
// ============================================================

// ------------------------------------------------------------
// crio aqui a tela principal de comunicação do usuário
class TelaPrincipal extends StatefulWidget {
  // guardo o nome do usuário para apresentar na tela
  final String nomeUsuario;

  // uso este construtor para criar a tela principal
  const TelaPrincipal({
    super.key,
    required this.nomeUsuario,
  });

  // crio o estado que vou utilizar para guardar as categorias
  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

// crio aqui o estado da minha tela principal
class _TelaPrincipalState extends State<TelaPrincipal> {
  // guardo a busca das categorias no banco de dados
  late Future<List<CategoriaItem>> categorias;

  // busco as categorias no banco quando a tela é criada
  @override
  void initState() {
    super.initState();
    categorias = BancoDados.buscarCategorias();
  }

  // construo aqui todos os elementos da tela principal
  @override
  Widget build(BuildContext context) {
    // uso o Scaffold para criar a estrutura básica da tela
    return Scaffold(
      // defino o fundo da minha tela como branco
      backgroundColor: Colors.white,

      // uso o SafeArea para respeitar as áreas do sistema
      body: SafeArea(
        // uso o Stack para colocar o cadeado por cima do conteúdo
        child: Stack(children: [
          // uso o SingleChildScrollView para permitir
          // que a tela seja rolada em aparelhos menores
          SingleChildScrollView(
            // adiciono espaço ao redor do conteúdo
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 15,
            ),

            // organizo os elementos verticalmente
            child: Column(
              children: [
                // apresento a saudação personalizada
                Text(
                  'OLÁ, ${widget.nomeUsuario.toUpperCase()}!',

                  // defino o estilo da saudação
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5F9B72),
                  ),
                ),

                // crio um espaço depois da saudação
                const SizedBox(height: 8),

                // apresento a pergunta principal do aplicativo
                const Text(
                  'O QUE VOCÊ QUER DIZER?',

                  // centralizo o texto
                  textAlign: TextAlign.center,

                  // defino o estilo da pergunta
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                // crio um espaço antes dos botões
                const SizedBox(height: 18),

                // busco as categorias no banco de dados e crio os botões
                FutureBuilder<List<CategoriaItem>>(
                  future: categorias,
                  builder: (context, snapshot) {
                    // não mostro nada enquanto as categorias não chegam
                    final lista = snapshot.data;
                    if (lista == null) {
                      return const SizedBox();
                    }

                    // crio um botão para cada categoria que veio do banco
                    return Column(
                      children: [
                        for (int i = 0; i < lista.length; i++) ...[
                          // crio um espaço entre os botões
                          if (i > 0) const SizedBox(height: 11),

                          _botaoComunicacao(
                            texto: lista[i].nome,
                            cor: lista[i].cor,
                            icone: lista[i].icone,

                            // abro a tela de subcategorias ao pressionar
                            aoPressionar: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TelaSubcategorias(
                                    idCategoria: lista[i].id,
                                    nome: lista[i].nome,
                                    cor: lista[i].cor,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ],
                    );
                  },
                ),

                // separo as categorias da função de compreensão
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(
                    color: Colors.black54,
                    thickness: 1,
                  ),
                ),

                // crio o botão separado para o módulo de compreensão
                SizedBox(
                  // defino uma largura menor para diferenciar
                  // este botão dos botões de comunicação
                  width: 190,

                  // aumento levemente a altura do botão
                  height: 44,

                  child: OutlinedButton(
                    // abro a tela inicial do módulo ao pressionar
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const TelaModuloCompreensao(),
                        ),
                      );
                    },

                    // defino a aparência do botão
                    style: OutlinedButton.styleFrom(
                      // deixo o fundo branco
                      backgroundColor: Colors.white,

                      // defino o contorno preto
                      side: const BorderSide(
                        color: Colors.black,
                        width: 1.5,
                      ),

                      // mantenho os cantos em 90 graus
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),

                      // defino o texto em preto
                      foregroundColor: Colors.black,

                      // retiro espaços internos desnecessários
                      padding: EdgeInsets.zero,
                    ),

                    // apresento o nome do módulo
                    child: const Text(
                      'MÓDULO DE COMPREENSÃO',

                      // defino o tamanho do texto
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // crio um pequeno espaço na parte inferior
                const SizedBox(height: 8),
              ],
            ),
          ),

          // crio o cadeado discreto que abre a área do cuidador
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              // peço a senha ao pressionar
              onPressed: _abrirAreaCuidador,

              // uso um ícone pequeno e cinza para não chamar atenção
              icon: const Icon(
                Icons.lock_outline,
                size: 22,
                color: Colors.black38,
              ),
            ),
          ),
        ]),
      ),
    );
  }

  // peço a senha e abro a área do cuidador se ela estiver correta
  Future<void> _abrirAreaCuidador() async {
    // abro a janela que pede a senha e espero a resposta
    final liberado = await showDialog<bool>(
      context: context,
      builder: (context) => const DialogoSenha(),
    );

    // só continuo se a senha estiver correta e a tela ainda existir
    if (liberado != true || !mounted) return;

    // abro a área do cuidador
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TelaAreaCuidador(),
      ),
    );
  }

  // crio um modelo único para os botões de comunicação
  Widget _botaoComunicacao({
    required String texto,
    required Color cor,
    required IconData icone,

    // recebo aqui a ação do botão, que é opcional
    VoidCallback? aoPressionar,
  }) {
    // retorno um botão grande e arredondado
    return SizedBox(
      // faço o botão ocupar praticamente toda a largura
      width: double.infinity,

      // aumento um pouco a altura dos botões
      height: 66,

      child: ElevatedButton(
        // uso a ação recebida ou deixo vazio para as próximas etapas
        onPressed: aoPressionar ?? () {},

        // defino a aparência do botão
        style: ElevatedButton.styleFrom(
          // aplico a cor correspondente à categoria
          backgroundColor: cor,

          // mantenho o texto em preto
          foregroundColor: Colors.black,

          // arredondo os cantos dos botões de comunicação
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(33),
          ),

          // retiro a elevação para manter a aparência simples
          elevation: 0,

          // retiro espaços internos desnecessários
          padding: EdgeInsets.zero,
        ),

        // organizo o ícone e o texto horizontalmente
        child: Row(
          // centralizo os elementos
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            // crio uma área branca para destacar o ícone
            Container(
              // defino o tamanho da área branca
              width: 46,
              height: 46,

              // deixo a área branca perfeitamente circular
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),

              // apresento o ícone dentro da área branca
              child: Icon(
                icone,
                size: 28,
                color: Colors.black87,
              ),
            ),

            // crio um espaço entre o ícone e o texto
            const SizedBox(width: 15),

            // apresento o nome da categoria
            Text(
              texto,

              // defino o estilo do texto
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// crio aqui a tela única que mostra as subcategorias de qualquer categoria
class TelaSubcategorias extends StatefulWidget {
  // guardo o id da categoria escolhida
  final int idCategoria;

  // guardo o nome da categoria escolhida
  final String nome;

  // guardo a cor da categoria escolhida
  final Color cor;

  // uso este construtor para criar a tela de subcategorias
  const TelaSubcategorias({
    super.key,
    required this.idCategoria,
    required this.nome,
    required this.cor,
  });

  // crio o estado que vou utilizar para guardar as subcategorias
  @override
  State<TelaSubcategorias> createState() => _TelaSubcategoriasState();
}

// crio aqui o estado da minha tela de subcategorias
class _TelaSubcategoriasState extends State<TelaSubcategorias> {
  // guardo a busca das subcategorias no banco de dados
  late Future<List<SubcategoriaItem>> subcategorias;

  // busco as subcategorias no banco quando a tela é criada
  @override
  void initState() {
    super.initState();
    subcategorias = BancoDados.buscarSubcategorias(widget.idCategoria);
  }

  // construo aqui todos os elementos da tela de subcategorias
  @override
  Widget build(BuildContext context) {
    // escureço a cor da categoria para usar no título
    final corTitulo =
    HSLColor.fromColor(widget.cor).withLightness(0.4).toColor();

    // uso o Scaffold para criar a estrutura básica da tela
    return Scaffold(
      // defino o fundo da minha tela como branco
      backgroundColor: Colors.white,

      // uso o SafeArea para respeitar as áreas do sistema
      body: SafeArea(
        child: Column(
          children: [
            // crio um espaço no início da tela
            const SizedBox(height: 40),

            // apresento o nome da categoria como título
            Text(
              widget.nome,

              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: corTitulo,
              ),
            ),

            // crio um espaço antes dos botões
            const SizedBox(height: 20),

            // uso o Expanded para dividir o espaço entre os botões
            Expanded(
              child: Padding(
                // adiciono espaço nas laterais e embaixo
                padding: const EdgeInsets.only(
                  left: 25,
                  right: 25,
                  bottom: 25,
                ),

                // espero o banco devolver as subcategorias
                child: FutureBuilder<List<SubcategoriaItem>>(
                  future: subcategorias,
                  builder: (context, snapshot) {
                    // não mostro nada enquanto os itens não chegam
                    final lista = snapshot.data;
                    if (lista == null) {
                      return const SizedBox();
                    }

                    // aviso se não existe nenhum item disponível
                    if (lista.isEmpty) {
                      return const Center(
                        child: Text(
                          'Nenhum item disponível',
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    }

                    // crio um botão para cada subcategoria do banco
                    return Column(
                      children: [
                        for (int i = 0; i < lista.length; i++) ...[
                          // crio um espaço entre os botões
                          if (i > 0) const SizedBox(height: 15),

                          _botaoSubcategoria(context, lista[i]),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ),

            // crio o botão para voltar à tela principal
            SizedBox(
              // defino a largura do botão
              width: 175,

              // defino a altura do botão
              height: 50,

              child: ElevatedButton(
                // volto para a tela principal ao pressionar
                onPressed: () {
                  Navigator.pop(context);
                },

                // uso a mesma aparência do botão continuar
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),

                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    // apresento a seta indicando que estou voltando
                    Icon(Icons.arrow_back),

                    // crio um pequeno espaço depois da seta
                    SizedBox(width: 10),

                    // apresento o texto do botão
                    Text(
                      'VOLTAR',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            // crio um espaço na parte inferior
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  // crio um modelo único para os botões das subcategorias
  Widget _botaoSubcategoria(BuildContext context, SubcategoriaItem item) {
    // uso o Expanded para os botões terem o mesmo tamanho
    return Expanded(
      child: SizedBox(
        // faço o botão ocupar toda a largura
        width: double.infinity,

        child: ElevatedButton(
          // abro a mensagem da subcategoria ao pressionar
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TelaMensagem(
                  emoji: item.icone,
                  frase: item.frase,
                  cor: item.cor,
                  audio: item.audio,
                ),
              ),
            );
          },

          // defino a aparência do botão
          style: ElevatedButton.styleFrom(
            // aplico a cor da subcategoria
            backgroundColor: item.cor,

            // mantenho o texto em preto
            foregroundColor: Colors.black,

            // arredondo os cantos do botão
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(33),
            ),

            // retiro a elevação para manter a aparência simples
            elevation: 0,

            // retiro espaços internos desnecessários
            padding: EdgeInsets.zero,
          ),

          // organizo o ícone e o texto horizontalmente
          child: Row(
            // centralizo os elementos
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              // crio uma área branca circular para o emoji
              Container(
                width: 70,
                height: 70,

                // deixo a área branca perfeitamente circular
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),

                // centralizo o emoji dentro da área branca
                alignment: Alignment.center,

                child: Text(
                  item.icone,
                  style: const TextStyle(fontSize: 36),
                ),
              ),

              // crio um espaço entre o ícone e o texto
              const SizedBox(width: 18),

              // deixo o texto quebrar linha se o nome for grande
              Flexible(
                child: Text(
                  item.nome,

                  // centralizo o texto caso ele quebre em duas linhas
                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// crio aqui a tela que mostra a mensagem de comunicação
class TelaMensagem extends StatefulWidget {
  // guardo o emoji que representa a mensagem
  final String emoji;

  // guardo a frase que será apresentada
  final String frase;

  // guardo a cor da subcategoria escolhida
  final Color cor;

  // guardo o nome do arquivo de áudio da frase, que é opcional
  final String? audio;

  // uso este construtor para criar a tela da mensagem
  const TelaMensagem({
    super.key,
    required this.emoji,
    required this.frase,
    required this.cor,
    this.audio,
  });

  // crio o estado que vou utilizar para controlar o áudio
  @override
  State<TelaMensagem> createState() => _TelaMensagemState();
}

// crio aqui o estado da minha tela de mensagem
class _TelaMensagemState extends State<TelaMensagem> {
  // crio o tocador que vai reproduzir o áudio da frase
  final AudioPlayer tocador = AudioPlayer();

  // toco o áudio assim que a tela abre
  @override
  void initState() {
    super.initState();

    // pego o nome do arquivo de áudio
    final audio = widget.audio;

    // só toco se esta mensagem tiver um áudio
    if (audio != null) {
      tocador.play(AssetSource('audios/$audio'));
    }
  }

  // libero o tocador quando saio desta tela
  @override
  void dispose() {
    tocador.dispose();
    super.dispose();
  }

  // construo aqui todos os elementos da tela da mensagem
  @override
  Widget build(BuildContext context) {
    // pego os dados da mensagem que recebi
    final emoji = widget.emoji;
    final frase = widget.frase;
    final cor = widget.cor;

    // uso o Scaffold para criar a estrutura básica da tela
    return Scaffold(
      // defino o fundo da minha tela como branco
      backgroundColor: Colors.white,

      // uso o SafeArea para respeitar as áreas do sistema
      body: SafeArea(
        // organizo os elementos verticalmente
        child: Column(
          children: [
            // uso o Expanded para o cartão ocupar o espaço principal
            Expanded(
              child: Padding(
                // adiciono espaço ao redor do cartão
                padding: const EdgeInsets.all(25),

                child: Container(
                  // faço o cartão ocupar toda a área disponível
                  width: double.infinity,

                  // aplico a cor da subcategoria e arredondo os cantos
                  decoration: BoxDecoration(
                    color: cor,
                    borderRadius: BorderRadius.circular(33),
                  ),

                  child: Column(
                    // centralizo o conteúdo do cartão
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      // crio uma área branca circular para o emoji
                      Container(
                        width: 180,
                        height: 180,

                        // deixo a área branca perfeitamente circular
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),

                        // centralizo o emoji dentro da área branca
                        alignment: Alignment.center,

                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 90),
                        ),
                      ),

                      // crio um espaço entre o emoji e a frase
                      const SizedBox(height: 30),

                      // apresento a frase em letras grandes
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),

                        child: Text(
                          frase,

                          // centralizo a frase
                          textAlign: TextAlign.center,

                          // defino o estilo da frase
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // crio o botão para voltar à tela anterior
            SizedBox(
              // defino a largura do botão
              width: 175,

              // defino a altura do botão
              height: 50,

              child: ElevatedButton(
                // volto para a tela anterior ao pressionar
                onPressed: () {
                  Navigator.pop(context);
                },

                // uso a mesma aparência do botão continuar
                style: ElevatedButton.styleFrom(
                  // utilizo a mesma cor azul das outras telas
                  backgroundColor: Colors.blue,

                  // utilizo branco para o texto
                  foregroundColor: Colors.white,

                  // arredondo os cantos do botão
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),

                child: const Row(
                  // centralizo os elementos do botão
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    // apresento a seta indicando que estou voltando
                    Icon(Icons.arrow_back),

                    // crio um pequeno espaço depois da seta
                    SizedBox(width: 10),

                    // apresento o texto do botão
                    Text(
                      'VOLTAR',

                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // crio um espaço na parte inferior
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 4. MÓDULO DE COMPREENSÃO
// ============================================================

// ------------------------------------------------------------
// crio aqui o modelo de uma rodada do módulo de compreensão
class RodadaCompreensao {
  // guardo a frase que será apresentada
  final String frase;

  // guardo os três ícones que serão apresentados
  final List<String> icones;

  // guardo a posição do ícone correto, de 0 a 2
  final int indiceCorreto;

  // guardo o nome do arquivo de áudio da frase
  final String audio;

  // uso este construtor para criar cada rodada
  const RodadaCompreensao({
    required this.frase,
    required this.icones,
    required this.indiceCorreto,
    required this.audio,
  });
}

// ------------------------------------------------------------
// crio aqui o modelo de cada item do banco de frases
class ItemCompreensao {
  // guardo a frase do item
  final String frase;

  // guardo o ícone que combina com a frase
  final String icone;

  // guardo o nome do arquivo de áudio da frase
  final String audio;

  // uso este construtor para criar cada item
  const ItemCompreensao({
    required this.frase,
    required this.icone,
    required this.audio,
  });
}

// ------------------------------------------------------------
// crio aqui as quatro rodadas sorteadas de cada novo teste
// as frases vêm do banco de dados e só entram as que estão ativas
Future<List<RodadaCompreensao>> gerarRodadas() async {
  // busco no banco todas as frases ativas que podem ser sorteadas
  final todos = await BancoDados.buscarItensCompreensao();

  // devolvo uma lista vazia se não existem itens suficientes
  // são necessários pelo menos quatro itens para montar as quatro rodadas
  if (todos.length < 4) {
    return [];
  }

  // crio o sorteador
  final sorteador = Random();

  // embaralho os itens e pego quatro frases diferentes
  final itens = List<ItemCompreensao>.from(todos)..shuffle(sorteador);
  final escolhidos = itens.take(4).toList();

  // monto uma rodada para cada frase escolhida
  return escolhidos.map((item) {
    // sorteio dois ícones errados entre os outros itens
    final outros = todos
        .where((outro) => outro.icone != item.icone)
        .toList()
      ..shuffle(sorteador);

    // junto o ícone correto com os dois errados e embaralho a ordem
    final icones = [item.icone, outros[0].icone, outros[1].icone]
      ..shuffle(sorteador);

    // descubro em qual posição ficou o ícone correto
    return RodadaCompreensao(
      frase: item.frase,
      icones: icones,
      indiceCorreto: icones.indexOf(item.icone),
      audio: item.audio,
    );
  }).toList();
}

// ------------------------------------------------------------
// crio aqui a tela inicial do módulo de compreensão
class TelaModuloCompreensao extends StatelessWidget {
  // uso este construtor para criar a tela inicial do módulo
  const TelaModuloCompreensao({super.key});

  // construo aqui todos os elementos da tela inicial do módulo
  @override
  Widget build(BuildContext context) {
    // uso o Scaffold para criar a estrutura básica da tela
    return Scaffold(
      // defino o fundo da minha tela como branco
      backgroundColor: Colors.white,

      // uso o SafeArea para respeitar as áreas do sistema
      body: SafeArea(
        child: Column(
          children: [
            // uso o Expanded para centralizar o conteúdo principal
            Expanded(
              child: Center(
                child: Padding(
                  // adiciono espaço nas laterais
                  padding: const EdgeInsets.symmetric(horizontal: 30),

                  child: Column(
                    // centralizo os elementos verticalmente
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      // apresento o título do módulo
                      const Text(
                        'MÓDULO DE COMPREENSÃO',

                        // centralizo o título
                        textAlign: TextAlign.center,

                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      // crio um espaço entre o título e a explicação
                      const SizedBox(height: 20),

                      // apresento uma explicação simples
                      const Text(
                        'Toque na imagem que combina com a frase',

                        // centralizo o texto
                        textAlign: TextAlign.center,

                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // crio o botão para iniciar o módulo
            SizedBox(
              // defino a largura do botão
              width: 175,

              // defino a altura do botão
              height: 50,

              child: ElevatedButton(
                // abro a primeira rodada ao pressionar
                onPressed: () async {
                  // sorteio as rodadas de um novo teste
                  final rodadas = await gerarRodadas();

                  // confirmo que a tela ainda existe depois de esperar
                  if (!context.mounted) return;

                  // aviso se não existem itens suficientes para o teste
                  if (rodadas.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Não há itens suficientes para o teste',
                        ),
                      ),
                    );
                    return;
                  }

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TelaRodada(
                        rodadas: rodadas,
                        numeroRodada: 0,
                        acertos: 0,
                      ),
                    ),
                  );
                },

                // uso a mesma aparência do botão continuar
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),

                child: const Row(
                  // centralizo os elementos do botão
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    // apresento o texto do botão
                    Text(
                      'INICIAR',
                      style: TextStyle(fontSize: 16),
                    ),

                    // crio um pequeno espaço antes da seta
                    SizedBox(width: 10),

                    // apresento a seta indicando que existe uma próxima etapa
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ),

            // crio um espaço entre os botões
            const SizedBox(height: 15),

            // crio o botão para voltar à tela principal
            SizedBox(
              width: 175,
              height: 50,

              child: ElevatedButton(
                // volto para a tela principal ao pressionar
                onPressed: () {
                  Navigator.pop(context);
                },

                // uso a mesma aparência do botão continuar
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),

                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    // apresento a seta indicando que estou voltando
                    Icon(Icons.arrow_back),

                    // crio um pequeno espaço depois da seta
                    SizedBox(width: 10),

                    // apresento o texto do botão
                    Text(
                      'VOLTAR',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            // crio um espaço na parte inferior
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// crio aqui a tela de cada rodada do módulo de compreensão
class TelaRodada extends StatefulWidget {
  // guardo as quatro rodadas sorteadas para este teste
  final List<RodadaCompreensao> rodadas;

  // guardo o número da rodada atual, de 0 a 3
  final int numeroRodada;

  // guardo quantos acertos o usuário já teve
  final int acertos;

  // uso este construtor para criar a tela da rodada
  const TelaRodada({
    super.key,
    required this.rodadas,
    required this.numeroRodada,
    required this.acertos,
  });

  // crio o estado que vou utilizar para controlar o áudio
  @override
  State<TelaRodada> createState() => _TelaRodadaState();
}

// crio aqui o estado da minha tela de rodada
class _TelaRodadaState extends State<TelaRodada> {
  // crio o tocador que vai reproduzir o áudio da frase
  final AudioPlayer tocador = AudioPlayer();

  // toco o áudio da frase assim que a rodada aparece na tela
  @override
  void initState() {
    super.initState();

    // pego a rodada atual
    final rodada = widget.rodadas[widget.numeroRodada];

    // toco o áudio correspondente à frase
    tocador.play(AssetSource('audios/${rodada.audio}'));
  }

  // libero o tocador quando saio desta tela
  @override
  void dispose() {
    tocador.dispose();
    super.dispose();
  }

  // trato aqui a escolha feita pelo usuário
  Future<void> _escolher(BuildContext context, int indiceEscolhido) async {
    // pego os dados desta rodada
    final rodadas = widget.rodadas;
    final numeroRodada = widget.numeroRodada;
    final acertos = widget.acertos;

    // paro o áudio antes de mudar de tela
    tocador.stop();

    // pego a rodada atual
    final rodada = rodadas[numeroRodada];

    // somo um acerto se o ícone escolhido for o correto
    final novosAcertos =
    indiceEscolhido == rodada.indiceCorreto ? acertos + 1 : acertos;

    // calculo qual é a próxima rodada
    final proximaRodada = numeroRodada + 1;

    // verifico se ainda existem rodadas para apresentar
    if (proximaRodada < rodadas.length) {
      // abro a próxima rodada no lugar da atual
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TelaRodada(
            rodadas: rodadas,
            numeroRodada: proximaRodada,
            acertos: novosAcertos,
          ),
        ),
      );
    } else {
      // calculo quantos erros o usuário teve no teste
      final erros = rodadas.length - novosAcertos;

      // salvo o resultado no histórico antes de abrir a tela de resultado
      await BancoDados.salvarResultado(acertos: novosAcertos, erros: erros);

      // confirmo que a tela ainda existe depois de salvar
      if (!mounted) return;

      // abro o resultado depois da última rodada
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TelaResultado(
            acertos: novosAcertos,
            erros: erros,
          ),
        ),
      );
    }
  }

  // construo aqui todos os elementos da tela da rodada
  @override
  Widget build(BuildContext context) {
    // pego os dados desta rodada
    final rodadas = widget.rodadas;
    final numeroRodada = widget.numeroRodada;

    // pego a rodada atual
    final rodada = rodadas[numeroRodada];

    // uso o Scaffold para criar a estrutura básica da tela
    return Scaffold(
      // defino o fundo da minha tela como branco
      backgroundColor: Colors.white,

      // uso o SafeArea para respeitar as áreas do sistema
      body: SafeArea(
        child: Column(
          children: [
            // crio um espaço no início da tela
            const SizedBox(height: 20),

            // apresento em qual rodada o usuário está
            Text(
              '${numeroRodada + 1} de ${rodadas.length}',

              style: const TextStyle(
                fontSize: 14,
                color: Colors.blue,
              ),
            ),

            // crio um espaço antes da frase
            const SizedBox(height: 15),

            // apresento a frase em letras grandes
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),

              child: Text(
                rodada.frase,

                // centralizo a frase
                textAlign: TextAlign.center,

                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            // crio um espaço antes dos ícones
            const SizedBox(height: 20),

            // uso o Expanded para dividir o espaço entre os três ícones
            Expanded(
              child: Padding(
                // adiciono espaço nas laterais e embaixo
                padding: const EdgeInsets.only(
                  left: 25,
                  right: 25,
                  bottom: 25,
                ),

                child: Column(
                  children: [
                    // crio um botão para cada um dos três ícones
                    for (int i = 0; i < rodada.icones.length; i++) ...[
                      // crio um espaço entre os botões
                      if (i > 0) const SizedBox(height: 15),

                      Expanded(
                        child: SizedBox(
                          // faço o botão ocupar toda a largura
                          width: double.infinity,

                          child: OutlinedButton(
                            // trato a escolha ao pressionar
                            onPressed: () {
                              _escolher(context, i);
                            },

                            // defino a aparência do botão
                            style: OutlinedButton.styleFrom(
                              // deixo o fundo branco
                              backgroundColor: Colors.white,

                              // defino o contorno preto
                              side: const BorderSide(
                                color: Colors.black,
                                width: 1.5,
                              ),

                              // mantenho os cantos em 90 graus
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),

                            // apresento o ícone em tamanho grande
                            child: Text(
                              rodada.icones[i],
                              style: const TextStyle(fontSize: 64),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // crio o botão parar, que serve como saída de emergência
            SizedBox(
              // uso um botão pequeno para ele não competir com as respostas
              width: 130,
              height: 40,

              child: OutlinedButton(
                // paro o áudio e volto direto para a tela principal
                // sem salvar nada no histórico, pois o teste é anulado
                onPressed: () {
                  tocador.stop();
                  Navigator.pop(context);
                },

                // uso o mesmo estilo discreto do módulo de compreensão
                style: OutlinedButton.styleFrom(
                  // deixo o fundo branco
                  backgroundColor: Colors.white,

                  // defino o contorno preto
                  side: const BorderSide(
                    color: Colors.black,
                    width: 1.5,
                  ),

                  // mantenho os cantos em 90 graus
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),

                  // defino o texto em preto
                  foregroundColor: Colors.black,
                ),

                child: const Text(
                  'PARAR',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // crio um espaço na parte inferior
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// crio aqui a tela de resultado do módulo de compreensão
class TelaResultado extends StatelessWidget {
  // guardo a quantidade de acertos
  final int acertos;

  // guardo a quantidade de erros
  final int erros;

  // uso este construtor para criar a tela de resultado
  const TelaResultado({
    super.key,
    required this.acertos,
    required this.erros,
  });

  // construo aqui todos os elementos da tela de resultado
  @override
  Widget build(BuildContext context) {
    // escolho singular ou plural para o texto dos erros
    final textoErros = erros == 1 ? '1 erro' : '$erros erros';

    // escolho singular ou plural para o texto dos acertos
    final textoAcertos = acertos == 1 ? '1 acerto' : '$acertos acertos';

    // uso o Scaffold para criar a estrutura básica da tela
    return Scaffold(
      // defino o fundo da minha tela como branco
      backgroundColor: Colors.white,

      // uso o SafeArea para respeitar as áreas do sistema
      body: SafeArea(
        child: Column(
          children: [
            // uso o Expanded para centralizar o conteúdo principal
            Expanded(
              child: Column(
                // centralizo os elementos verticalmente
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  // apresento o título da tela
                  const Text(
                    'RESULTADO',

                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5F9B72),
                    ),
                  ),

                  // crio um espaço depois do título
                  const SizedBox(height: 40),

                  // uso o IntrinsicWidth para o bloco ter a largura do maior texto
                  // e continuar centralizado na tela
                  IntrinsicWidth(
                    child: Column(
                      // alinho os dois textos pela esquerda
                      // para ficarem exatamente um embaixo do outro
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        // apresento a quantidade de erros em vermelho
                        Text(
                          textoErros,

                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFD32F2F),
                          ),
                        ),

                        // crio um espaço entre os resultados
                        const SizedBox(height: 15),

                        // apresento a quantidade de acertos em verde
                        Text(
                          textoAcertos,

                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E9E4F),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // crio o botão para voltar à tela principal
            SizedBox(
              width: 175,
              height: 50,

              child: ElevatedButton(
                // volto para a tela principal ao pressionar
                onPressed: () {
                  Navigator.pop(context);
                },

                // uso a mesma aparência do botão continuar
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),

                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    // apresento a seta indicando que estou voltando
                    Icon(Icons.arrow_back),

                    // crio um pequeno espaço depois da seta
                    SizedBox(width: 10),

                    // apresento o texto do botão
                    Text(
                      'VOLTAR',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            // crio um espaço na parte inferior
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 5. BANCO DE DADOS (SQLITE)
// ============================================================

// ------------------------------------------------------------
// crio aqui a classe que cuida de do acesso ao banco de dados
class BancoDados {
  // guardo o banco aberto para não precisar abrir toda vez
  static Database? _banco;

  // abro o banco e crio as tabelas na primeira vez
  static Future<Database> abrir() async {
    // devolvo o banco se ele já estiver aberto
    final aberto = _banco;
    if (aberto != null) {
      return aberto;
    }

    // descubro a pasta onde o aparelho guarda os bancos de dados
    final pasta = await getDatabasesPath();
    final caminho = '$pasta/quero_dizer.db';

    // abro o banco e crio as tabelas se ele ainda não existir
    final banco = await openDatabase(
      caminho,
      version: 1,

      // ativo as chaves estrangeiras
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },

      // crio aqui as tabelas do meu modelo entidade relacionamento
      onCreate: (db, versao) async {
        // crio a tabela do usuário
        await db.execute('''
          CREATE TABLE usuario (
            id_usuario INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL
          )
        ''');

        // crio a tabela do cuidador com a senha da área do cuidador
        await db.execute('''
          CREATE TABLE cuidador (
            id_cuidador INTEGER PRIMARY KEY AUTOINCREMENT,
            id_usuario INTEGER NOT NULL,
            senha TEXT NOT NULL,
            FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
          )
        ''');

        // crio a tabela das categorias
        await db.execute('''
          CREATE TABLE categoria (
            id_categoria INTEGER PRIMARY KEY AUTOINCREMENT,
            id_usuario INTEGER NOT NULL,
            nome TEXT NOT NULL,
            icone TEXT NOT NULL,
            cor TEXT NOT NULL,
            FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
          )
        ''');

        // crio a tabela das subcategorias
        await db.execute('''
          CREATE TABLE subcategoria (
            id_subcategoria INTEGER PRIMARY KEY AUTOINCREMENT,
            id_categoria INTEGER NOT NULL,
            nome TEXT NOT NULL,
            icone TEXT NOT NULL,
            cor TEXT NOT NULL,
            FOREIGN KEY (id_categoria) REFERENCES categoria (id_categoria)
          )
        ''');

        // crio a tabela das ações, que tem o campo ativo para ocultar itens
        await db.execute('''
          CREATE TABLE acao (
            id_acao INTEGER PRIMARY KEY AUTOINCREMENT,
            id_subcategoria INTEGER NOT NULL,
            frase TEXT NOT NULL,
            audio TEXT NOT NULL,
            cor TEXT NOT NULL,
            ativo INTEGER NOT NULL DEFAULT 1,
            FOREIGN KEY (id_subcategoria)
              REFERENCES subcategoria (id_subcategoria)
          )
        ''');

        // crio a tabela do histórico dos testes de compreensão
        await db.execute('''
          CREATE TABLE historico (
            id_historico INTEGER PRIMARY KEY AUTOINCREMENT,
            id_usuario INTEGER NOT NULL,
            qtd_acertos INTEGER NOT NULL,
            qtd_erros INTEGER NOT NULL,
            FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
          )
        ''');
      },
    );

    // guardo o banco aberto para as próximas consultas
    _banco = banco;
    return banco;
  }

  // busco o nome do usuário cadastrado, ou nada se ainda não existe
  static Future<String?> buscarNomeUsuario() async {
    final banco = await abrir();

    // consulto a tabela de usuários
    final linhas = await banco.query('usuario', limit: 1);

    // devolvo nada se ainda não existe cadastro
    if (linhas.isEmpty) {
      return null;
    }

    // devolvo o nome do usuário cadastrado
    return linhas.first['nome'] as String;
  }

  // salvo o usuário e a senha do cuidador no banco
  static Future<void> salvarCadastro({
    required String nome,
    required String senha,
  }) async {
    final banco = await abrir();

    // uso uma transação para salvar as duas informações juntas
    await banco.transaction((txn) async {
      // salvo o nome do usuário e pego o id que foi criado
      final idUsuario = await txn.insert('usuario', {'nome': nome});

      // salvo a senha do cuidador ligada a esse usuário
      await txn.insert('cuidador', {
        'id_usuario': idUsuario,
        'senha': senha,
      });
    });

    // gravo as categorias, subcategorias e frases do usuário
    await garantirItens();
  }

  // defino aqui todos os itens que o aplicativo grava no banco
  // as cores ficam em texto no formato hexadecimal com transparência
  static const List<Map<String, dynamic>> _dadosIniciais = [
    // defino a categoria banheiro
    {
      'nome': 'BANHEIRO',
      'icone': 'wc',
      'cor': 'FF7FCF8A',
      'subcategorias': [
        {
          'nome': 'TOMAR BANHO',
          'icone': '🚿',
          'cor': 'FF9AD9A3',
          'frase': 'QUERO TOMAR BANHO',
          'audio': 'tomar_banho.mp3',
        },
        {
          'nome': 'FAZER XIXI',
          'icone': '🚽',
          'cor': 'FFB5E4BB',
          'frase': 'QUERO FAZER XIXI',
          'audio': 'fazer_xixi.mp3',
        },
        {
          'nome': 'FAZER COCÔ',
          'icone': '💩',
          'cor': 'FFCFEFD3',
          'frase': 'QUERO FAZER COCÔ',
          'audio': 'fazer_coco.mp3',
        },
      ],
    },

    // defino a categoria beber
    {
      'nome': 'BEBER',
      'icone': 'local_drink',
      'cor': 'FF7DB7E8',
      'subcategorias': [
        {
          'nome': 'ÁGUA',
          'icone': '💧',
          'cor': 'FF98C8EE',
          'frase': 'QUERO BEBER ÁGUA',
          'audio': 'beber_agua.mp3',
        },
        {
          'nome': 'SUCO',
          'icone': '🧃',
          'cor': 'FFB5D7F3',
          'frase': 'QUERO BEBER SUCO',
          'audio': 'beber_suco.mp3',
        },
        {
          'nome': 'REFRIGERANTE',
          'icone': '🥤',
          'cor': 'FFD0E5F8',
          'frase': 'QUERO BEBER REFRIGERANTE',
          'audio': 'beber_refrigerante.mp3',
        },
      ],
    },

    // defino a categoria comer
    {
      'nome': 'COMER',
      'icone': 'restaurant',
      'cor': 'FFF4A261',
      'subcategorias': [
        {
          'nome': 'COMIDA NO PRATO',
          'icone': '🍽️',
          'cor': 'FFF6B27A',
          'frase': 'QUERO COMER COMIDA',
          'audio': 'comer_comida.mp3',
        },
        {
          'nome': 'FRUTA',
          'icone': '🍎',
          'cor': 'FFF9C7A0',
          'frase': 'QUERO COMER FRUTA',
          'audio': 'comer_fruta.mp3',
        },
        {
          'nome': 'LANCHE',
          'icone': '🥪',
          'cor': 'FFFBDCC3',
          'frase': 'QUERO COMER LANCHE',
          'audio': 'comer_lanche.mp3',
        },
      ],
    },

    // defino a categoria dormir
    {
      'nome': 'DORMIR',
      'icone': 'bed',
      'cor': 'FF9B8AFB',
      'subcategorias': [
        {
          'nome': 'DORMIR',
          'icone': '😴',
          'cor': 'FFB5A9FC',
          'frase': 'QUERO DORMIR',
          'audio': 'dormir.mp3',
        },
        {
          'nome': 'DEITAR PARA DESCANSAR',
          'icone': '🛏️',
          'cor': 'FFD2CAFD',
          'frase': 'QUERO DEITAR PARA DESCANSAR',
          'audio': 'deitar_para_descansar.mp3',
        },
      ],
    },

    // defino a categoria emoções
    {
      'nome': 'EMOÇÕES',
      'icone': 'sentiment_satisfied',
      'cor': 'FFF2C94C',
      'subcategorias': [
        {
          'nome': 'FELIZ',
          'icone': '😀',
          'cor': 'FFF5D26B',
          'frase': 'ESTOU FELIZ',
          'audio': 'estou_feliz.mp3',
        },
        {
          'nome': 'TRISTE',
          'icone': '😢',
          'cor': 'FFF7DB8A',
          'frase': 'ESTOU TRISTE',
          'audio': 'estou_triste.mp3',
        },
        {
          'nome': 'BRAVO',
          'icone': '😠',
          'cor': 'FFF9E4A9',
          'frase': 'ESTOU BRAVO',
          'audio': 'estou_bravo.mp3',
        },
        {
          'nome': 'MEDO',
          'icone': '😨',
          'cor': 'FFFBEDC8',
          'frase': 'ESTOU COM MEDO',
          'audio': 'estou_com_medo.mp3',
        },
      ],
    },

    // defino a categoria sim e não
    {
      'nome': 'SIM E NÃO',
      'icone': 'check_circle_outline',
      'cor': 'FFD9D9D9',
      'subcategorias': [
        {
          'nome': 'SIM',
          'icone': '✅',
          'cor': 'FFE3E3E3',
          'frase': 'SIM',
          'audio': 'sim.mp3',
        },
        {
          'nome': 'NÃO',
          'icone': '❌',
          'cor': 'FFEFEFEF',
          'frase': 'NÃO',
          'audio': 'nao.mp3',
        },
      ],
    },
  ];

  // busco todos os itens para o cuidador escolher quais ficam disponíveis
  static Future<List<ItemAdministracao>> buscarItensAdministracao() async {
    final banco = await abrir();

    // junto a ação com a subcategoria e a categoria, na ordem de gravação
    final linhas = await banco.rawQuery('''
      SELECT a.id_acao, c.nome AS categoria, s.nome, s.icone, a.ativo
      FROM acao a
      JOIN subcategoria s ON s.id_subcategoria = a.id_subcategoria
      JOIN categoria c ON c.id_categoria = s.id_categoria
      ORDER BY c.id_categoria, s.id_subcategoria
    ''');

    // transformo cada linha do banco em um item
    return linhas.map((linha) {
      return ItemAdministracao(
        idAcao: linha['id_acao'] as int,
        categoria: linha['categoria'] as String,
        nome: linha['nome'] as String,
        icone: linha['icone'] as String,
        ativo: (linha['ativo'] as int) == 1,
      );
    }).toList();
  }

  // ativo ou oculto uma ação no banco
  static Future<void> alterarAtivo(int idAcao, bool ativo) async {
    final banco = await abrir();

    // troco o valor do campo ativo, 1 aparece e 0 fica oculto
    await banco.update(
      'acao',
      {'ativo': ativo ? 1 : 0},
      where: 'id_acao = ?',
      whereArgs: [idAcao],
    );
  }

  // busco os resultados salvos, do mais recente para o mais antigo
  static Future<List<ResultadoTeste>> buscarHistorico() async {
    final banco = await abrir();

    // ordeno do maior id para o menor, assim o mais recente vem primeiro
    final linhas = await banco.query(
      'historico',
      orderBy: 'id_historico DESC',
      limit: 10,
    );

    // transformo cada linha do banco em um resultado
    return linhas.map((linha) {
      return ResultadoTeste(
        acertos: linha['qtd_acertos'] as int,
        erros: linha['qtd_erros'] as int,
      );
    }).toList();
  }

  // troco a senha do cuidador no banco
  static Future<void> alterarSenha(String novaSenha) async {
    final banco = await abrir();

    // atualizo a senha do cuidador cadastrado
    await banco.update('cuidador', {'senha': novaSenha});
  }

  // confiro se a senha digitada é a senha do cuidador
  static Future<bool> verificarSenha(String senha) async {
    final banco = await abrir();

    // procuro um cuidador com a mesma senha
    final linhas = await banco.query(
      'cuidador',
      where: 'senha = ?',
      whereArgs: [senha],
      limit: 1,
    );

    // devolvo verdadeiro se encontrei
    return linhas.isNotEmpty;
  }

  // salvo o resultado de um teste e mantenho só os 10 mais recentes
  static Future<void> salvarResultado({
    required int acertos,
    required int erros,
  }) async {
    final banco = await abrir();

    // busco o usuário cadastrado
    final usuarios = await banco.query('usuario', limit: 1);

    // não salvo nada se ainda não existe usuário
    if (usuarios.isEmpty) {
      return;
    }

    // pego o id do usuário
    final idUsuario = usuarios.first['id_usuario'] as int;

    // uso uma transação para salvar e limpar juntos
    await banco.transaction((txn) async {
      // salvo o novo resultado, que recebe o maior id e é o mais recente
      await txn.insert('historico', {
        'id_usuario': idUsuario,
        'qtd_acertos': acertos,
        'qtd_erros': erros,
      });

      // apago tudo o que não está entre os 10 resultados mais recentes
      await txn.rawDelete('''
        DELETE FROM historico
        WHERE id_historico NOT IN (
          SELECT id_historico FROM historico
          ORDER BY id_historico DESC
          LIMIT 10
        )
      ''');
    });
  }

  // busco as frases ativas que podem entrar no módulo de compreensão
  static Future<List<ItemCompreensao>> buscarItensCompreensao() async {
    final banco = await abrir();

    // pego só as ações ativas e deixo de fora a categoria sim e não
    final linhas = await banco.rawQuery('''
      SELECT s.icone, a.frase, a.audio
      FROM acao a
      JOIN subcategoria s ON s.id_subcategoria = a.id_subcategoria
      JOIN categoria c ON c.id_categoria = s.id_categoria
      WHERE a.ativo = 1 AND c.nome <> 'SIM E NÃO'
    ''');

    // transformo cada linha do banco em um item do teste
    return linhas.map((linha) {
      return ItemCompreensao(
        frase: linha['frase'] as String,
        icone: linha['icone'] as String,
        audio: linha['audio'] as String,
      );
    }).toList();
  }

  // busco as subcategorias ativas de uma categoria
  static Future<List<SubcategoriaItem>> buscarSubcategorias(
      int idCategoria,
      ) async {
    final banco = await abrir();

    // junto a subcategoria com a sua ação e pego só as que estão ativas
    final linhas = await banco.rawQuery('''
      SELECT s.nome, s.icone, s.cor, a.frase, a.audio
      FROM subcategoria s
      JOIN acao a ON a.id_subcategoria = s.id_subcategoria
      WHERE s.id_categoria = ? AND a.ativo = 1
      ORDER BY s.id_subcategoria
    ''', [idCategoria]);

    // transformo cada linha do banco em uma subcategoria
    return linhas.map((linha) {
      return SubcategoriaItem(
        nome: linha['nome'] as String,
        icone: linha['icone'] as String,
        cor: Color(int.parse(linha['cor'] as String, radix: 16)),
        frase: linha['frase'] as String,
        audio: linha['audio'] as String,
      );
    }).toList();
  }

  // busco todas as categorias gravadas no banco
  static Future<List<CategoriaItem>> buscarCategorias() async {
    final banco = await abrir();

    // consulto a tabela de categorias na ordem em que foram gravadas
    final linhas = await banco.query('categoria', orderBy: 'id_categoria');

    // transformo cada linha do banco em uma categoria
    return linhas.map((linha) {
      return CategoriaItem(
        id: linha['id_categoria'] as int,
        nome: linha['nome'] as String,

        // troco o nome do ícone gravado pelo ícone do flutter
        icone: iconesCategorias[linha['icone'] as String] ??
            Icons.help_outline,

        // transformo o texto hexadecimal gravado em uma cor
        cor: Color(int.parse(linha['cor'] as String, radix: 16)),
      );
    }).toList();
  }

  // gravo as categorias, subcategorias e ações se ainda não existirem
  static Future<void> garantirItens() async {
    final banco = await abrir();

    // busco o usuário cadastrado
    final usuarios = await banco.query('usuario', limit: 1);

    // não faço nada se ainda não existe usuário
    if (usuarios.isEmpty) {
      return;
    }

    // pego o id do usuário
    final idUsuario = usuarios.first['id_usuario'] as int;

    // conto quantas categorias já estão gravadas
    final total = Sqflite.firstIntValue(
      await banco.rawQuery('SELECT COUNT(*) FROM categoria'),
    );

    // não repito a gravação se os itens já existem
    if ((total ?? 0) > 0) {
      return;
    }

    // uso uma transação para gravar tudo junto
    await banco.transaction((txn) async {
      // percorro cada categoria da lista
      for (final categoria in _dadosIniciais) {
        // gravo a categoria e pego o id que foi criado
        final idCategoria = await txn.insert('categoria', {
          'id_usuario': idUsuario,
          'nome': categoria['nome'],
          'icone': categoria['icone'],
          'cor': categoria['cor'],
        });

        // percorro cada subcategoria da categoria
        for (final subcategoria in categoria['subcategorias'] as List) {
          // gravo a subcategoria e pego o id que foi criado
          final idSubcategoria = await txn.insert('subcategoria', {
            'id_categoria': idCategoria,
            'nome': subcategoria['nome'],
            'icone': subcategoria['icone'],
            'cor': subcategoria['cor'],
          });

          // gravo a ação, que tem a frase, o áudio e o campo ativo
          await txn.insert('acao', {
            'id_subcategoria': idSubcategoria,
            'frase': subcategoria['frase'],
            'audio': subcategoria['audio'],
            'cor': subcategoria['cor'],
            'ativo': 1,
          });
        }
      }
    });
  }
}

// ============================================================
// 6. MODELOS DE DADOS
// ============================================================

// ------------------------------------------------------------
// relaciono o nome do ícone gravado no banco com o ícone do flutter
const Map<String, IconData> iconesCategorias = {
  'wc': Icons.wc,
  'local_drink': Icons.local_drink,
  'restaurant': Icons.restaurant,
  'bed': Icons.bed,
  'sentiment_satisfied': Icons.sentiment_satisfied,
  'check_circle_outline': Icons.check_circle_outline,
};

// ------------------------------------------------------------
// crio aqui o modelo de uma categoria que veio do banco
class CategoriaItem {
  // guardo o id da categoria no banco
  final int id;

  // guardo o nome da categoria
  final String nome;

  // guardo o ícone da categoria
  final IconData icone;

  // guardo a cor da categoria
  final Color cor;

  // uso este construtor para criar cada categoria
  const CategoriaItem({
    required this.id,
    required this.nome,
    required this.icone,
    required this.cor,
  });
}

// ------------------------------------------------------------
// crio aqui o modelo de uma subcategoria que veio do banco
class SubcategoriaItem {
  // guardo o nome da subcategoria
  final String nome;

  // guardo o emoji da subcategoria
  final String icone;

  // guardo a cor da subcategoria
  final Color cor;

  // guardo a frase da ação
  final String frase;

  // guardo o nome do arquivo de áudio da ação
  final String audio;

  // uso este construtor para criar cada subcategoria
  const SubcategoriaItem({
    required this.nome,
    required this.icone,
    required this.cor,
    required this.frase,
    required this.audio,
  });
}

// ------------------------------------------------------------
// crio aqui o modelo de um resultado guardado no histórico
class ResultadoTeste {
  // guardo a quantidade de acertos do teste
  final int acertos;

  // guardo a quantidade de erros do teste
  final int erros;

  // uso este construtor para criar cada resultado
  const ResultadoTeste({
    required this.acertos,
    required this.erros,
  });
}

// ------------------------------------------------------------
// crio aqui o modelo de um item da tela de itens disponíveis
class ItemAdministracao {
  // guardo o id da ação no banco
  final int idAcao;

  // guardo o nome da categoria do item
  final String categoria;

  // guardo o nome do item
  final String nome;

  // guardo o emoji do item
  final String icone;

  // guardo se o item está disponível, e esse valor pode mudar
  bool ativo;

  // uso este construtor para criar cada item
  ItemAdministracao({
    required this.idAcao,
    required this.categoria,
    required this.nome,
    required this.icone,
    required this.ativo,
  });
}

// ============================================================
// 7. ÁREA DO CUIDADOR
// ============================================================

// ------------------------------------------------------------
// crio aqui a janela que pede a senha do cuidador
class DialogoSenha extends StatefulWidget {
  // uso este construtor para criar a janela da senha
  const DialogoSenha({super.key});

  // crio o estado que vou utilizar para controlar o campo da senha
  @override
  State<DialogoSenha> createState() => _DialogoSenhaState();
}

// crio aqui o estado da minha janela de senha
class _DialogoSenhaState extends State<DialogoSenha> {
  // crio este controlador para acessar a senha digitada
  final TextEditingController senhaController = TextEditingController();

  // guardo a mensagem de erro, que fica vazia enquanto não houver erro
  String? erro;

  // libero o controlador quando fecho a janela
  @override
  void dispose() {
    senhaController.dispose();
    super.dispose();
  }

  // confiro a senha digitada
  Future<void> _entrar() async {
    // pergunto ao banco se a senha está correta
    final correta = await BancoDados.verificarSenha(senhaController.text);

    // confirmo que a janela ainda existe depois de esperar
    if (!mounted) return;

    if (correta) {
      // fecho a janela avisando que a senha está correta
      Navigator.pop(context, true);
    } else {
      // mostro o erro e limpo o campo para tentar de novo
      setState(() {
        erro = 'Senha incorreta';
      });
      senhaController.clear();
    }
  }

  // construo aqui todos os elementos da janela
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // apresento o título da janela
      title: const Text('Área do Cuidador'),

      // crio o campo onde a senha será digitada
      content: TextField(
        controller: senhaController,

        // abro o cursor no campo assim que a janela aparece
        autofocus: true,

        // faço o teclado apresentar números
        keyboardType: TextInputType.number,

        // escondo os números digitados
        obscureText: true,

        // defino o limite de seis caracteres
        maxLength: 6,

        // confiro a senha quando o usuário confirma pelo teclado
        onSubmitted: (_) => _entrar(),

        decoration: InputDecoration(
          labelText: 'Senha',
          border: const OutlineInputBorder(),

          // retiro o contador de caracteres
          counterText: '',

          // mostro a mensagem de erro quando a senha está errada
          errorText: erro,
        ),
      ),

      actions: [
        // crio o botão para cancelar
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text('CANCELAR'),
        ),

        // crio o botão para entrar
        ElevatedButton(
          onPressed: _entrar,
          child: const Text('ENTRAR'),
        ),
      ],
    );
  }
}

// ------------------------------------------------------------
// crio aqui a tela inicial da área do cuidador
class TelaAreaCuidador extends StatelessWidget {
  // uso este construtor para criar a área do cuidador
  const TelaAreaCuidador({super.key});

  // construo aqui todos os elementos da área do cuidador
  @override
  Widget build(BuildContext context) {
    // uso o Scaffold para criar a estrutura básica da tela
    return Scaffold(
      // defino o fundo da minha tela como branco
      backgroundColor: Colors.white,

      // uso o SafeArea para respeitar as áreas do sistema
      body: SafeArea(
        child: Column(
          children: [
            // crio um espaço no início da tela
            const SizedBox(height: 40),

            // apresento o título da tela
            const Text(
              'ÁREA DO CUIDADOR',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            // uso o Expanded para centralizar os botões
            Expanded(
              child: Padding(
                // adiciono espaço nas laterais
                padding: const EdgeInsets.symmetric(horizontal: 25),

                child: Column(
                  // centralizo os botões verticalmente
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    // crio o botão do histórico, que abre a tela com os resultados
                    _botaoAdministrativo('HISTÓRICO', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TelaHistorico(),
                        ),
                      );
                    }),

                    // crio um espaço entre os botões
                    const SizedBox(height: 15),

                    // crio o botão dos itens disponíveis, que abre a tela de ocultação
                    _botaoAdministrativo('ITENS DISPONÍVEIS', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TelaItensDisponiveis(),
                        ),
                      );
                    }),

                    // crio um espaço entre os botões
                    const SizedBox(height: 15),

                    // crio o botão de alterar a senha, que abre a tela de troca
                    _botaoAdministrativo('ALTERAR SENHA', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TelaAlterarSenha(),
                        ),
                      );
                    }),

                    // crio um espaço entre os botões
                    const SizedBox(height: 15),

                    // crio o botão de sair, que volta para a tela principal
                    _botaoAdministrativo('SAIR', () {
                      Navigator.pop(context);
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // crio um modelo único para os botões da área do cuidador
  Widget _botaoAdministrativo(String texto, VoidCallback aoPressionar) {
    return SizedBox(
      // faço o botão ocupar toda a largura
      width: double.infinity,

      // defino a altura do botão
      height: 70,

      child: OutlinedButton(
        onPressed: aoPressionar,

        // uso o mesmo estilo discreto do módulo de compreensão
        style: OutlinedButton.styleFrom(
          // deixo o fundo branco
          backgroundColor: Colors.white,

          // defino o contorno preto
          side: const BorderSide(
            color: Colors.black,
            width: 1.5,
          ),

          // mantenho os cantos em 90 graus
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),

          // defino o texto em preto
          foregroundColor: Colors.black,
        ),

        child: Text(
          texto,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// crio aqui a tela que mostra o histórico dos testes de compreensão
class TelaHistorico extends StatefulWidget {
  // uso este construtor para criar a tela do histórico
  const TelaHistorico({super.key});

  // crio o estado que vou utilizar para guardar os resultados
  @override
  State<TelaHistorico> createState() => _TelaHistoricoState();
}

// crio aqui o estado da minha tela de histórico
class _TelaHistoricoState extends State<TelaHistorico> {
  // guardo a busca dos resultados no banco de dados
  late Future<List<ResultadoTeste>> resultados;

  // busco os resultados no banco quando a tela é criada
  @override
  void initState() {
    super.initState();
    resultados = BancoDados.buscarHistorico();
  }

  // construo aqui todos os elementos da tela de histórico
  @override
  Widget build(BuildContext context) {
    // uso o Scaffold para criar a estrutura básica da tela
    return Scaffold(
      // defino o fundo da minha tela como branco
      backgroundColor: Colors.white,

      // uso o SafeArea para respeitar as áreas do sistema
      body: SafeArea(
        child: Column(
          children: [
            // crio um espaço no início da tela
            const SizedBox(height: 40),

            // apresento o título da tela
            const Text(
              'HISTÓRICO',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            // crio um espaço antes da lista
            const SizedBox(height: 20),

            // uso o Expanded para a lista ocupar o espaço disponível
            Expanded(
              child: FutureBuilder<List<ResultadoTeste>>(
                future: resultados,
                builder: (context, snapshot) {
                  // não mostro nada enquanto os resultados não chegam
                  final lista = snapshot.data;
                  if (lista == null) {
                    return const SizedBox();
                  }

                  // aviso se ainda não existe nenhum teste
                  if (lista.isEmpty) {
                    return const Center(
                      child: Text(
                        'Nenhum teste realizado ainda',
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  }

                  // somo os acertos e os erros de todos os testes guardados
                  int totalAcertos = 0;
                  int totalErros = 0;
                  for (final resultado in lista) {
                    totalAcertos += resultado.acertos;
                    totalErros += resultado.erros;
                  }

                  // calculo a porcentagem de acertos
                  final totalRespostas = totalAcertos + totalErros;
                  final percentual = totalRespostas == 0
                      ? 0
                      : (totalAcertos * 100 / totalRespostas).round();

                  // escolho singular ou plural para os textos do panorama
                  final textoTestes = lista.length == 1
                      ? 'último teste'
                      : 'últimos ${lista.length} testes';
                  final textoTotalAcertos = totalAcertos == 1
                      ? '1 acerto'
                      : '$totalAcertos acertos';
                  final textoTotalErros =
                  totalErros == 1 ? '1 erro' : '$totalErros erros';

                  // apresento o panorama geral em cima e a lista embaixo
                  return Column(
                    children: [
                      // crio o quadro do panorama geral
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        padding: const EdgeInsets.all(14),

                        // uso o mesmo estilo discreto, com contorno preto
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1.5),
                        ),

                        child: Column(
                          children: [
                            // apresento o título do quadro
                            const Text(
                              'PANORAMA GERAL',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),

                            // informo quantos testes entram na conta
                            Text(
                              '($textoTestes)',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),

                            // crio um espaço antes dos totais
                            const SizedBox(height: 8),

                            // apresento o total de acertos em verde e de erros em vermelho
                            Text.rich(
                              TextSpan(
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: textoTotalAcertos,
                                    style: const TextStyle(
                                      color: Color(0xFF2E9E4F),
                                    ),
                                  ),
                                  const TextSpan(
                                    text: ' / ',
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                  TextSpan(
                                    text: textoTotalErros,
                                    style: const TextStyle(
                                      color: Color(0xFFD32F2F),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // crio um pequeno espaço antes da porcentagem
                            const SizedBox(height: 4),

                            // apresento a porcentagem de acertos
                            Text(
                              '$percentual% de acertos',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // crio um espaço entre o panorama e a lista
                      const SizedBox(height: 10),

                      // uso o Expanded para a lista ocupar o restante da tela
                      Expanded(
                        // crio uma linha para cada resultado
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          itemCount: lista.length,

                          // separo as linhas com um traço fino
                          separatorBuilder: (context, indice) => const Divider(),

                          itemBuilder: (context, indice) {
                            final resultado = lista[indice];

                            // escolho singular ou plural para os textos
                            final textoAcertos = resultado.acertos == 1
                                ? '1 acerto'
                                : '${resultado.acertos} acertos';
                            final textoErros = resultado.erros == 1
                                ? '1 erro'
                                : '${resultado.erros} erros';

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),

                              child: Row(
                                children: [
                                  // apresento a posição do resultado, 1 é o mais recente
                                  SizedBox(
                                    width: 45,
                                    child: Text(
                                      '${indice + 1}.',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),

                                  // apresento os acertos em verde e os erros em vermelho
                                  Text.rich(
                                    TextSpan(
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: textoAcertos,
                                          style: const TextStyle(
                                            color: Color(0xFF2E9E4F),
                                          ),
                                        ),
                                        const TextSpan(
                                          text: ' / ',
                                          style: TextStyle(color: Colors.black87),
                                        ),
                                        TextSpan(
                                          text: textoErros,
                                          style: const TextStyle(
                                            color: Color(0xFFD32F2F),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // crio o botão para voltar à área do cuidador
            SizedBox(
              // defino a largura do botão
              width: 175,

              // defino a altura do botão
              height: 50,

              child: ElevatedButton(
                // volto para a área do cuidador ao pressionar
                onPressed: () {
                  Navigator.pop(context);
                },

                // uso a mesma aparência do botão continuar
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),

                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    // apresento a seta indicando que estou voltando
                    Icon(Icons.arrow_back),

                    // crio um pequeno espaço depois da seta
                    SizedBox(width: 10),

                    // apresento o texto do botão
                    Text(
                      'VOLTAR',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            // crio um espaço na parte inferior
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// crio aqui a tela onde o cuidador oculta e reativa os itens
class TelaItensDisponiveis extends StatefulWidget {
  // uso este construtor para criar a tela
  const TelaItensDisponiveis({super.key});

  // crio o estado que vou utilizar para guardar os itens
  @override
  State<TelaItensDisponiveis> createState() => _TelaItensDisponiveisState();
}

// crio aqui o estado da minha tela de itens disponíveis
class _TelaItensDisponiveisState extends State<TelaItensDisponiveis> {
  // guardo os itens, que ficam vazios até o banco responder
  List<ItemAdministracao>? itens;

  // busco os itens no banco quando a tela é criada
  @override
  void initState() {
    super.initState();
    _carregar();
  }

  // busco os itens e atualizo a tela
  Future<void> _carregar() async {
    final lista = await BancoDados.buscarItensAdministracao();

    // confirmo que a tela ainda existe depois de esperar
    if (!mounted) return;

    setState(() {
      itens = lista;
    });
  }

  // salvo a escolha do cuidador para um item
  Future<void> _alterar(ItemAdministracao item, bool ativo) async {
    // atualizo a tela na hora
    setState(() {
      item.ativo = ativo;
    });

    // salvo a escolha no banco
    await BancoDados.alterarAtivo(item.idAcao, ativo);
  }

  // construo aqui todos os elementos da tela
  @override
  Widget build(BuildContext context) {
    // pego a lista de itens
    final lista = itens;

    // uso o Scaffold para criar a estrutura básica da tela
    return Scaffold(
      // defino o fundo da minha tela como branco
      backgroundColor: Colors.white,

      // uso o SafeArea para respeitar as áreas do sistema
      body: SafeArea(
        child: Column(
          children: [
            // crio um espaço no início da tela
            const SizedBox(height: 40),

            // apresento o título da tela
            const Text(
              'ITENS DISPONÍVEIS',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            // crio um espaço depois do título
            const SizedBox(height: 8),

            // explico o que cada chave faz
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Itens desligados ficam ocultos para o usuário',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
            ),

            // crio um espaço antes da lista
            const SizedBox(height: 10),

            // uso o Expanded para a lista ocupar o espaço disponível
            Expanded(
              child: lista == null
              // não mostro nada enquanto os itens não chegam
                  ? const SizedBox()
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: lista.length,
                itemBuilder: (context, indice) {
                  final item = lista[indice];

                  // mostro o nome da categoria quando ela muda
                  final primeiroDaCategoria = indice == 0 ||
                      lista[indice - 1].categoria != item.categoria;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // apresento o nome da categoria acima do primeiro item
                      if (primeiroDaCategoria)
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 16,
                            bottom: 4,
                            left: 4,
                          ),
                          child: Text(
                            item.categoria,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ),

                      // crio a linha do item com a chave de liga e desliga
                      SwitchListTile(
                        value: item.ativo,
                        onChanged: (valor) => _alterar(item, valor),
                        activeThumbColor: const Color(0xFF2E9E4F),

                        // apresento o emoji e o nome do item
                        title: Text(
                          '${item.icone}  ${item.nome}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // crio o botão para voltar à área do cuidador
            SizedBox(
              // defino a largura do botão
              width: 175,

              // defino a altura do botão
              height: 50,

              child: ElevatedButton(
                // volto para a área do cuidador ao pressionar
                onPressed: () {
                  Navigator.pop(context);
                },

                // uso a mesma aparência do botão continuar
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),

                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    // apresento a seta indicando que estou voltando
                    Icon(Icons.arrow_back),

                    // crio um pequeno espaço depois da seta
                    SizedBox(width: 10),

                    // apresento o texto do botão
                    Text(
                      'VOLTAR',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            // crio um espaço na parte inferior
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// crio aqui a tela onde o cuidador altera a senha
class TelaAlterarSenha extends StatefulWidget {
  // uso este construtor para criar a tela
  const TelaAlterarSenha({super.key});

  // crio o estado que vou utilizar para controlar os campos
  @override
  State<TelaAlterarSenha> createState() => _TelaAlterarSenhaState();
}

// crio aqui o estado da minha tela de alterar senha
class _TelaAlterarSenhaState extends State<TelaAlterarSenha> {
  // crio este controlador para acessar a senha atual
  final TextEditingController atualController = TextEditingController();

  // crio este controlador para acessar a nova senha
  final TextEditingController novaController = TextEditingController();

  // crio este controlador para acessar a confirmação da nova senha
  final TextEditingController confirmarController = TextEditingController();

  // libero os controladores quando saio desta tela
  @override
  void dispose() {
    atualController.dispose();
    novaController.dispose();
    confirmarController.dispose();
    super.dispose();
  }

  // mostro uma mensagem curta na parte de baixo da tela
  void _aviso(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  // confiro os campos e salvo a nova senha
  Future<void> _salvar() async {
    // pego o que foi digitado nos três campos
    final atual = atualController.text;
    final nova = novaController.text;
    final confirmar = confirmarController.text;

    // verifico se a senha atual foi preenchida
    if (atual.isEmpty) {
      _aviso('Digite a senha atual');
      return;
    }

    // confiro a senha atual no banco
    final atualCorreta = await BancoDados.verificarSenha(atual);

    // confirmo que a tela ainda existe depois de esperar
    if (!mounted) return;

    // paro se a senha atual estiver errada
    if (!atualCorreta) {
      _aviso('Senha atual incorreta');
      return;
    }

    // verifico se a nova senha tem exatamente seis dígitos
    if (nova.length != 6) {
      _aviso('A nova senha deve ter 6 dígitos');
      return;
    }

    // verifico se a confirmação é igual à nova senha
    if (nova != confirmar) {
      _aviso('As senhas não são iguais');
      return;
    }

    // salvo a nova senha no banco
    await BancoDados.alterarSenha(nova);

    // confirmo de novo que a tela ainda existe depois de salvar
    if (!mounted) return;

    // aviso que deu certo e volto para a área do cuidador
    _aviso('Senha alterada com sucesso');
    Navigator.pop(context);
  }

  // crio um modelo único para os três campos de senha
  Widget _campoSenha(String rotulo, TextEditingController controlador) {
    return Padding(
      // adiciono espaço nas laterais e embaixo do campo
      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 15),

      child: TextField(
        controller: controlador,

        // faço o teclado apresentar números
        keyboardType: TextInputType.number,

        // escondo os números digitados
        obscureText: true,

        // defino o limite de seis caracteres
        maxLength: 6,

        decoration: InputDecoration(
          labelText: rotulo,
          border: const OutlineInputBorder(),

          // retiro o contador de caracteres
          counterText: '',
        ),
      ),
    );
  }

  // construo aqui todos os elementos da tela
  @override
  Widget build(BuildContext context) {
    // uso o Scaffold para criar a estrutura básica da tela
    return Scaffold(
      // defino o fundo da minha tela como branco
      backgroundColor: Colors.white,

      // uso o SafeArea para respeitar as áreas do sistema
      body: SafeArea(
        // permito rolar a tela quando o teclado estiver aberto
        child: SingleChildScrollView(
          child: Column(
            children: [
              // crio um espaço no início da tela
              const SizedBox(height: 40),

              // apresento o título da tela
              const Text(
                'ALTERAR SENHA',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              // crio um espaço antes dos campos
              const SizedBox(height: 30),

              // crio os três campos de senha
              _campoSenha('Senha atual', atualController),
              _campoSenha('Nova senha', novaController),
              _campoSenha('Confirmar nova senha', confirmarController),

              // crio um espaço antes dos botões
              const SizedBox(height: 10),

              // crio o botão para salvar a nova senha
              SizedBox(
                width: 175,
                height: 50,

                child: ElevatedButton(
                  // confiro os campos e salvo ao pressionar
                  onPressed: _salvar,

                  // uso a mesma aparência do botão continuar
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),

                  child: const Text(
                    'SALVAR',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              // crio um espaço entre os botões
              const SizedBox(height: 15),

              // crio o botão para voltar à área do cuidador
              SizedBox(
                width: 175,
                height: 50,

                child: ElevatedButton(
                  // volto para a área do cuidador ao pressionar
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  // uso a mesma aparência do botão continuar
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),

                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      // apresento a seta indicando que estou voltando
                      Icon(Icons.arrow_back),

                      // crio um pequeno espaço depois da seta
                      SizedBox(width: 10),

                      // apresento o texto do botão
                      Text(
                        'VOLTAR',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),

              // crio um espaço na parte inferior
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}