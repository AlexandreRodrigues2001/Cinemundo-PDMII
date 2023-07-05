<?php
// Configuração da base de dados
$host = 'localhost';
$dbName = 'PDM2';
$username = 'root';
$password = '';

// Conectar a base de dados MySQL
try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbName", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Falha na conexão: " . $e->getMessage());
}

// Obter o nome de utilizador e password enviados no request
$username = $_POST['username'] ?? '';
$password = $_POST['password'] ?? '';

// criar encriptação em hash da senha
$hashedPassword = password_hash($password, PASSWORD_DEFAULT);

// Preparar a instrução SQL para inserir o utilizador na base de dados
$stmt = $pdo->prepare('INSERT INTO users (nome, pass) VALUES (:username, :password)');
$stmt->bindParam(':username', $username);
$stmt->bindParam(':password', $hashedPassword);

// Inserir o utilizador na base de dados
if ($stmt->execute()) {
    // Registro bem-sucedido
    $response = [
        'success' => true,
        'message' => 'Registro bem-sucedido',
    ];
} else {
    // Registro falhou
    $response = [
        'success' => false,
        'message' => 'Registro falhou',
    ];
}

// Definir os cabeçalhos da resposta
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

// Enviar a resposta em formato JSON
echo json_encode($response);
?>
