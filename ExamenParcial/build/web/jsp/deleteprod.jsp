<%@ page import="java.sql.*, configuration.ConnectionBD" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Eliminar Producto</title>
</head>
<body>
    <h1>Eliminar Producto</h1>

    <%
        ConnectionBD conexionBD = new ConnectionBD();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = conexionBD.getConnectionBD();

            String query = "SELECT product_id, name FROM products";
            stmt = conn.prepareStatement(query);
            rs = stmt.executeQuery();
    %>

    <form action="${pageContext.request.contextPath}/tienda" method="post">
        <input type="hidden" name="action" value="deleteProduct">

        <label for="productId">Producto:</label>
        <select id="productId" name="productId" required>
            <%
                while (rs.next()) {
            %>
                <option value="<%= rs.getInt("product_id") %>">
                    <%= rs.getString("name") %>
                </option>
            <%
                }
            %>
        </select><br>

        <input type="submit" value="Eliminar Producto">
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
