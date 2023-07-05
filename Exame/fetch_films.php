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

// Verificar se foi enviada uma pesquisa
if (isset($_GET['searchText'])) {
    $searchText = $_GET['searchText'];

    // Preparar a instrução SQL para buscar os dados dos filmes com base no texto de pesquisa
    $stmt = $pdo->prepare('SELECT * FROM filmes WHERE title LIKE :searchText');

    // Adicionar '%' antes e depois do texto de pesquisa para buscar correspondências parciais
    $searchText = '%' . $searchText . '%';
    $stmt->bindParam(':searchText', $searchText);
} else {
    // Preparar a instrução SQL para buscar todos os dados dos filmes
    $stmt = $pdo->prepare('SELECT * FROM filmes');
}

// Buscar os dados dos filmes na base de dados
if ($stmt->execute()) {
    $films = $stmt->fetchAll(PDO::FETCH_ASSOC);
    // Definir os cabeçalhos da resposta
    header('Content-Type: application/json');
    header('Access-Control-Allow-Origin: *');

    // Verificar se existem filmes encontrados
    if ($films) {
        // Enviar a resposta em formato JSON
        echo json_encode($films);
    } else {
        // Nenhum filme encontrado
        $response = [
            'success' => true,
            'message' => 'Nenhum filme encontrado',
        ];

        // Enviar a resposta em formato JSON
        echo json_encode($response);
    }
} else {
    // Erro ao buscar dados dos filmes
    $response = [
        'success' => false,
        'message' => 'Falha ao buscar dados de filmes',
    ];

    // Definir os cabeçalhos da resposta
    header('Content-Type: application/json');
    header('Access-Control-Allow-Origin: *');

    // Enviar a resposta em formato JSON
    echo json_encode($response);
}
?>
