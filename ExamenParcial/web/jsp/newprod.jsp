<%@ page import="java.sql.*, configuration.ConnectionBD" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Agregar Producto</title>
</head>
<body>
    <h1>Agregar Producto</h1>

    <%
        ConnectionBD conexionBD = new ConnectionBD();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = conexionBD.getConnectionBD();

            String query = "SELECT supplier_id, supplier_name FROM suppliers";
            stmt = conn.prepareStatement(query);
            rs = stmt.executeQuery();
    %>

    <form action="${pageContext.request.contextPath}/tienda" method="post">
        <input type="hidden" name="action" value="addProduct">

        <label for="productName">Nombre del Producto:</label>
        <input type="text" id="productName" name="productName" required><br>

        <label for="price">Precio:</label>
        <input type="number" id="price" name="price" step="0.01" required><br>

        <label for="stockQuantity">Cantidad en Stock:</label>
        <input type="number" id="stockQuantity" name="stockQuantity" required><br>

        <label for="supplierId">Proveedor:</label>
        <select id="supplierId" name="supplierId" required>
            <%
                while (rs.next()) {
            %>
                <option value="<%= rs.getInt("supplier_id") %>">
                    <%= rs.getString("supplier_name") %>
                </option>
            <%
                }
            %>
        </select><br>

        <input type="submit" value="Agregar Producto">
    </form>

    <%
        } catch (Exception e) {
            out.println("Error al conectar o realizar la consulta: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                out.println("Error al cerrar los recursos: " + e.getMessage());
            }
        }
    %>
</body>
</html>
