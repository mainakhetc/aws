<?php
require_once "db.php";

$message = "";

if ($_SERVER["REQUEST_METHOD"] === "POST") {

    $todo_name = trim($_POST["todo_name"]);

    if ($todo_name !== "") {

        $stmt = $conn->prepare(
            "INSERT INTO todos (todo_name) VALUES (?)"
        );

        $stmt->bind_param("s", $todo_name);
        $stmt->execute();
        $stmt->close();

        $message = "Todo added successfully!";
    } else {
        $message = "Please enter a Todo.";
    }
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Add Todo</title>
</head>

<body>

<h1>Add Todo</h1>

<?php if ($message): ?>
    <p><?php echo htmlspecialchars($message); ?></p>
<?php endif; ?>

<form method="POST" action="">

    <label for="todo_name">Todo:</label>
    <input
        type="text"
        id="todo_name"
        name="todo_name"
        required
    >

    <button type="submit">Add Todo</button>

</form>

<p>
    <a href="manage-todo.php">Manage Todos</a>
</p>

</body>
</html>
