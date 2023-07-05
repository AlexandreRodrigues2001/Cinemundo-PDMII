<?php
// Configuração da base de dados
$host = 'localhost';
$dbName = 'PDM2';
$username = 'root';
$password = '';

// Conexão com a base de dados MySQL
try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbName", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Falha na conexão: " . $e->getMessage());
}

// Obter o nome de utilizador e password enviados na request
$username = $_POST['username'] ?? '';
$password = $_POST['password'] ?? '';

// Preparar a instrução SQL para procurar o utilizador na base de dados
$stmt = $pdo->prepare('SELECT * FROM users WHERE nome = :username');
$stmt->bindParam(':username', $username);
$stmt->execute();
$user = $stmt->fetch(PDO::FETCH_ASSOC);

// Verificar se o utilizador existe e se a senha corresponde
if ($user && password_verify($password, $user['pass'])) {
    // Login bem-sucedido
    $response = [
        'success' => true,
        'message' => 'Login bem-sucedido',
    ];
} else {
    // Login falhou
    $response = [
        'success' => false,
        'message' => 'Nome de usuário ou senha inválidos',
    ];
}

// Defenir os cabeçalhos da resposta
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

// Enviar a resposta em formato JSON
echo json_encode($response);
?>
