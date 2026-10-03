<?php
require_once "db.php";

/* -------------------------
   Delete Todo
------------------------- */
if (isset($_GET["delete"])) {

    $id = (int) $_GET["delete"];

    $stmt = $conn->prepare(
        "DELETE FROM todos WHERE id = ?"
    );

    $stmt->bind_param("i", $id);
    $stmt->execute();
    $stmt->close();

    header("Location: manage-todo.php");
    exit;
}


/* -------------------------
   Update Todo
------------------------- */
if ($_SERVER["REQUEST_METHOD"] === "POST") {

    $id = (int) $_POST["id"];
    $todo_name = trim($_POST["todo_name"]);

    if ($todo_name !== "") {

        $stmt = $conn->prepare(
            "UPDATE todos SET todo_name = ? WHERE id = ?"
        );

        $stmt->bind_param("si", $todo_name, $id);
        $stmt->execute();
        $stmt->close();
    }

    header("Location: manage-todo.php");
    exit;
}


/* -------------------------
   Get Todo for Editing
------------------------- */
$edit_todo = null;

if (isset($_GET["edit"])) {

    $id = (int) $_GET["edit"];

    $stmt = $conn->prepare(
        "SELECT id, todo_name FROM todos WHERE id = ?"
    );

    $stmt->bind_param("i", $id);
    $stmt->execute();

    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $edit_todo = $result->fetch_assoc();
    }

    $stmt->close();
}


/* -------------------------
   Get All Todos
------------------------- */
$result = $conn->query(
    "SELECT id, todo_name FROM todos ORDER BY id DESC"
);

?>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Todos</title>
</head>

<body>

<h1>Manage Todos</h1>

<p>
    <a href="add-todo.php">Add New Todo</a>
</p>


<?php if ($edit_todo): ?>

    <h2>Edit Todo</h2>

    <form method="POST" action="manage-todo.php">

        <input
            type="hidden"
            name="id"
            value="<?php echo $edit_todo["id"]; ?>"
        >

        <input
            type="text"
            name="todo_name"
            value="<?php echo htmlspecialchars($edit_todo["todo_name"]); ?>"
            required
        >

        <button type="submit">Update Todo</button>

        <a href="manage-todo.php">Cancel</a>

    </form>

<?php endif; ?>


<h2>Todo List</h2>

<table border="1" cellpadding="8" cellspacing="0">

    <tr>
        <th>ID</th>
        <th>Todo Name</th>
        <th>Actions</th>
    </tr>

    <?php while ($todo = $result->fetch_assoc()): ?>

        <tr>

            <td>
                <?php echo $todo["id"]; ?>
            </td>

            <td>
                <?php echo htmlspecialchars($todo["todo_name"]); ?>
            </td>

            <td>

                <a href="manage-todo.php?edit=<?php echo $todo["id"]; ?>">
                    Edit
                </a>

                |

                <a
                    href="manage-todo.php?delete=<?php echo $todo["id"]; ?>"
                    onclick="return confirm('Are you sure you want to delete this Todo?');"
                >
                    Delete
                </a>

            </td>

        </tr>

    <?php endwhile; ?>

</table>

</body>
</html>
