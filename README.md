<div align="center">

<img src="https://uploaddeimagens.com.br/images/004/806/045/full/imagem_2024-06-28_165852926.png?1719604739" alt="Logo" width="240">

# Monte seu PC

App em Flutter para montar configurações de PC gamer peça por peça, acompanhar o custo total e salvar a montagem em PDF.

[![Ver site](https://img.shields.io/badge/VER_SITE-0D0D0D?style=for-the-badge&logo=netlify&logoColor=FF003C)](https://monteseupc.netlify.app)

![Flutter](https://img.shields.io/badge/Flutter-0D0D0D?style=for-the-badge&logo=flutter&logoColor=FF003C)
![Dart](https://img.shields.io/badge/Dart-0D0D0D?style=for-the-badge&logo=dart&logoColor=FF003C)
![Netlify](https://img.shields.io/badge/Netlify-0D0D0D?style=for-the-badge&logo=netlify&logoColor=FF003C)

</div>

## Sobre

Aplicativo desenvolvido por mim para o meu grupo de TCC do técnico em Desenvolvimento de Sistemas da **ETEC Professor Basilides de Godoy** (2024), como complemento ao [e-commerce de hardware gamer](https://github.com/Lu1sR0/E-Commerce-TCC) do grupo.

O usuário escolhe processador, placa de vídeo, memória RAM, armazenamento, cooler, fonte e gabinete a partir de um catálogo, acompanha o valor total e a potência estimada em tempo real e gera um PDF com a configuração final. A versão web está publicada no Netlify e também aparece embutida no [site de apresentação do grupo](https://disquetechwin.netlify.app), que simula o Windows XP.

## Telas

**Tela inicial**

![Tela inicial](https://uploaddeimagens.com.br/images/004/806/202/full/imagem_2024-06-28_212644940.png?1719620809)

**Tela com as montagens salvas**

![Tela com as montagens salvas](https://uploaddeimagens.com.br/images/004/806/204/full/imagem_2024-06-28_212755909.png?1719620879)

**Tela de montagem**

![Tela de montagem](https://uploaddeimagens.com.br/images/004/806/207/full/imagem_2024-06-28_213008300.png?1719621011)

## Funcionalidades

- **Splash screen animada** com Lottie ao abrir o app.
- **Minhas montagens**: lista as configurações salvas com todas as peças, valor total e potência mínima; é possível abrir os detalhes ou excluir uma montagem.
- **Montagem em 7 categorias**: processador, placa de vídeo, memória RAM, armazenamento, cooler, fonte e gabinete, cada uma com cards de produto (imagem, especificações e preço) — de AMD Ryzen e Intel Core a GeForce RTX e Radeon RX.
- **Cálculo em tempo real** do valor total (R$) e da potência mínima necessária (soma do TDP das peças).
- **Validação**: o app avisa quando alguma peça ficou sem escolher antes de salvar ou gerar o PDF.
- **Salvar configuração** com um nome personalizado, armazenada localmente com `shared_preferences`.
- **Exportar em PDF**: gera um documento com as peças, o valor total e os watts, pronto para imprimir ou salvar.
- **Limpar seleções** com um toque para recomeçar a montagem.

## Tecnologias

| Pacote | Uso |
| --- | --- |
| Flutter / Dart | Interface e lógica do app (Dart SDK >= 3.3.4) |
| `provider` | Gerenciamento de estado (`ChangeNotifier`) |
| `pdf` + `printing` | Geração, visualização e impressão do PDF |
| `shared_preferences` | Armazenamento local da configuração salva |
| `lottie` + `animated_splash_screen` | Splash screen animada |

Fonte: Poppins.

## Estrutura

```
Monte-seu-PC/
├── lib/
│   ├── main.dart          # estado (BuildState), telas e catálogo de peças
│   └── splachscreen.dart  # splash screen animada com Lottie
├── assets/                # imagens das peças, fonte Poppins e animação Lottie
├── web/                   # configuração da versão web
└── pubspec.yaml           # dependências e assets
```

## Como rodar localmente

**Pré-requisito:** [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado.

```bash
git clone https://github.com/Lu1sR0/Monte-seu-PC.git
cd Monte-seu-PC
flutter pub get
flutter run -d chrome
```

Recomendo rodar no Google Chrome. Para gerar a versão web de produção:

```bash
flutter build web
```

---

<div align="center">
Desenvolvido por <a href="https://github.com/Lu1sR0">Luis Roberto</a> · <a href="https://outframe.dev">Outframe</a>
</div>
