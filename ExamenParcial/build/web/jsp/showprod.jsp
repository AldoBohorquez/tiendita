<%-- 
    Document   : showprod
    Created on : 14/10/2024, 08:23:34 PM
    Author     : swoke
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="configuration.ConnectionBD"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Mostrar Productos</title>
</head>
<body>
    <h1>Lista de Productos</h1>
    <form action="${pageContext.request.contextPath}/tienda" method="post">
        <input type="hidden" name="action" value="showProducts">
        <input type="submit" value="Mostrar Productos">
    </form>

    <div id="productList">
        <%
            if (request.getParameter("action") != null && request.getParameter("action").equals("showProducts")) {
                ConnectionBD connBD = new ConnectionBD();
                try (Connection connection = connBD.getConnectionBD();
                     Statement statement = connection.createStatement();
                     ResultSet rs = statement.executeQuery("SELECT p.product_id, p.name, p.price, p.stock_quantity, s.supplier_name "
                            + "FROM products p "
                            + "JOIN product_suppliers ps ON p.product_id = ps.product_id "
                            + "JOIN suppliers s ON ps.supplier_id = s.supplier_id")) {

                    out.println("<table border='1'><tr><th>ID</th><th>Producto</th><th>Precio</th><th>Cantidad</th><th>Proveedor</th></tr>");
                    while (rs.next()) {
                        out.println("<tr><td>" + rs.getInt("product_id") + "</td>");
                        out.println("<td>" + rs.getString("name") + "</td>");
                        out.println("<td>" + rs.getDouble("price") + "</td>");
                        out.println("<td>" + rs.getInt("stock_quantity") + "</td>");
                        out.println("<td>" + rs.getString("supplier_name") + "</td></tr>");
                    }
                    out.println("</table>");
                } catch (Exception e) {
                    out.println("Error al mostrar productos: " + e.getMessage());
                }
            }
        %>
    </div>
</body>
</html>
