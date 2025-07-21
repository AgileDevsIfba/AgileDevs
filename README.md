# AgileDevs

**AgileDevs** é uma plataforma interativa desenvolvida com o objetivo de facilitar a troca de experiências entre profissionais de desenvolvimento de software, promovendo o uso eficaz de métodos ágeis. A aplicação permite que os usuários explorem práticas ágeis, avaliem metodologias e compartilhem feedback.

## 🛠️ Tecnologias Utilizadas

- **Flutter 3.29.0**
- **Laravel 10.x**
- PHP 8.x
- Docker
- MySQL
-Android Studio

## ⚙️ Como Rodar Localmente

1. Clone o Repositório:

```bash
git clone https://github.com/AgileDevsIfba/AgileDevs.git
```

2. Acesse o diretório do projeto

```bash
cd AgileDevs/servicos
```

3. Suba os containers:

```bash
docker-compose up --build -d
```

4. Configure os serviços Laravel:

Para **cada microserviço Laravel**, execute os comandos abaixo:

**4.1 Crie e configure o arquivo .env**

Dentro de cada pasta (usuarios, metodos, favoritos, avaliacoes), copie o arquivo ```.env.example``` e renomeie para ```.env```:

```bash
cp .env.example .env
```

Em seguida, configure as variáveis de banco de dados:

```bash
DB_CONNECTION=mysql
DB_HOST=agiledevs_db
DB_PORT=3306
DB_DATABASE=agiledevs
DB_USERNAME=root
DB_PASSWORD=root
```

**4.2 Instale dependências e rode as migrations**

**Usuários**

```bash
docker exec -it usuarios bash
composer install
php artisan migrate
exit
```

**Métodos**

```bash
docker exec -it metodos bash
composer install
php artisan migrate
php artisan db:seed
exit
```

**Favoritos**

```bash
docker exec -it favoritos bash
composer install
php artisan migrate
exit
```

**Avaliações**

```bash
docker exec -it avaliacoes bash
composer install
php artisan migrate
exit
```


5. Acessando o banco de dados:

Abra o navegador e acesse:

```http://SEU_IP:5006/``` 

Preencha os campos com os mesmos dados definidos no arquivo .env dos microserviços Laravel:

- Servidor: `agiledevs_db`

- Usuário: `root`

- Senha: `root`

## 📱 Executando o Frontend Flutter

No terminal, vá para o diretório do app:
```bash
cd agiledevs/agiledevs
flutter pub get
flutter run
```

<p align="center">Desenvolvido por Daiane Alves e colaboradores.</p>
