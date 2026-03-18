# 🎀 Lojinha 🎀
### Um projeto feito para minhas alunas e alunos!

![Flutter](https://img.shields.io/badge/Flutter-3.29-ff69b4?style=for-the-badge&logo=flutter&logoColor=white&labelColor=ffb6c1)
![Supabase](https://img.shields.io/badge/Supabase-FFC0CB?style=for-the-badge&logo=supabase&logoColor=white&labelColor=ffb6c1)
![License](https://img.shields.io/badge/license-MIT-ffb6c1?style=for-the-badge)
![Made with Love](https://img.shields.io/badge/Made%20with-💖-ffb6c1?style=for-the-badge)

🌸 *Um aplicativo de vendas para aprender Flutter!* 🌸

---

## 🧸 Sobre o Projeto

A **Lojinha Fofa** é um aplicativo de vendas que vamos desenvolver durante nossas aulas de Flutter. Ele permite:

- Cadastrar produtos  🛍️
- Adicionar ao carrinho 🛒
- Finalizar pedidos com direito a notificação! 🔔
- Ver a localização da lojinha no mapa 🗺️

Tudo isso enquanto aprendemos conceitos importantes como:
- Widgets e navegação
- Gerenciamento de estado com Provider
- Integração com Supabase
- Notificações locais
- E muito mais!

---

## ✨ Funcionalidades

| Ícone | Funcionalidade | Descrição |
|-------|----------------|-----------|
| 🛍️ | **Lista de produtos** | Veja todos os produtos disponíveis na lojinha |
| ➕ | **Cadastrar produtos** | Adicione novos itens fofos ao catálogo |
| ✏️ | **Editar produtos** | Atualize informações dos produtos |
| 🛒 | **Carrinho de compras** | Adicione e remova itens com um clique |
| 💳 | **Finalizar pedido** | Com notificação de confirmação! |
| 🗺️ | **Mapa da loja** | Veja a localização da lojinha (usando WebView) |
| 🔔 | **Notificações locais** | Receba um aviso quando o pedido for confirmado |

(Ainda estamos construindo mais funcionalidades, fique de olho! 😉)

---

## 🚀 Como executar o projeto

Siga os passos abaixo:

1. **Clone o repositório**
   ```bash
   git clone https://github.com/LeticiaPavao/app_lojinha.git
   ```

2. **Entre na pasta**
   ```bash
   cd app_lojinha
   ```

3. **Instale as dependências**
   ```bash
   flutter pub get
   ```

4. **Configure a API**
   - Crie um projeto no [Supabase](https://supabase.com) (ou utilize outra api de preferência)
   - Copie a URL e a chave anônima
   - Crie um arquivo `.env` na raiz com:

     ```
     API_URL=https://exemplo.com
     API_KEY=sua-chave-aqui
     ```

5. **Rode o app**
   ```bash
   flutter run
   ```

---

## 💖 Contribuindo

Quer ajudar a deixar a Lojinha mais commpletinha?
 
- Reporte problemas em [Issues](https://github.com/seu-usuario/lojinha-fofa/issues)  
- Envie sugestões via Pull Request  

Toda contribuição será bem recebida! 😊

---

## 📄 Licença

Este projeto é licenciado sob a **MIT License** – veja o arquivo [LICENSE](LICENSE) para detalhes.
